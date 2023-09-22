# frozen_string_literal: true

require_relative "validate_email/version"
require "active_model"
require "mail"
require "active_support/i18n"
I18n.load_path << File.dirname(__FILE__) + "/locale/en.yml"

# module ValidateEmail
#   class Error < StandardError; end
#   # Your code goes here...
# end

module ActiveModel
  module Validations
    class EmailValidator < ActiveModel::EachValidator
      def initialize(options)
        options.reverse_merge!(message: :email)
        super(options)
      end

      def validate_each(record, attribute, value)
        mail = Mail::Address.new(value)

        unless mail.address == value && mail.domain.split(".").length > 1
          record.errors.add(attribute, options[:message])
        end
      rescue
        record.errors.add(attribute, options[:message])
      end
    end

    module ClassMethods
      def validates_email(*attr_names)
        validates_with EmailValidator, _merge_attributes(attr_names)
      end
    end
  end
end
