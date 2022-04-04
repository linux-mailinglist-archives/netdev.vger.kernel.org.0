Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B59024F2029
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 01:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233190AbiDDXTj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 19:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241763AbiDDXTW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 19:19:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8991F1E3E9
        for <netdev@vger.kernel.org>; Mon,  4 Apr 2022 16:15:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649114101;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kTRTuL6R5chBVkZAPhvLEL9OPO5zJV1n3e4jxK5S8Ms=;
        b=YTU70QBBLLd24iObYRQmaN92W+W5ONi+BYioijmT8cZ01TfIHt/WEOwdw/OnfuLHcCjIjV
        rz5FM5pukPQaEWuuDjV1j8MwwmtkcQTxN4w03oqbvAe2M/1FBf+f2GJ9AzEyoKjSTEzIX/
        2elO4Q4kxPJcrIjUv2poVSI96bShPdQ=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-20-SMUmPKuiMpSSnHa5Y7Z3cA-1; Mon, 04 Apr 2022 19:15:00 -0400
X-MC-Unique: SMUmPKuiMpSSnHa5Y7Z3cA-1
Received: by mail-qt1-f200.google.com with SMTP id z18-20020ac84552000000b002e201c79cd4so7436855qtn.2
        for <netdev@vger.kernel.org>; Mon, 04 Apr 2022 16:14:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=kTRTuL6R5chBVkZAPhvLEL9OPO5zJV1n3e4jxK5S8Ms=;
        b=18MuGk7PoMzske8pd3+1FB4DrG0IANLcAsDI5S+rIfCgupmWLvbvnzqPgIX84HWdUP
         xkmswSyb1Rg6E53gnLzcijpTp2s6KlCdhDCO8IoIztqT65Y9QeEAyUgI1ih1OUNa8hFL
         IH2fXNmszbur1LWhabf4WthxbH5X7eiP6ZpyPPUWY/LVONnIMsssAnHYN/DzzVs+M9VJ
         tmJGAqjd44qvs1u+vvfVIuNnxjFXNFZXhzGoIMpHdT2mz8UBtDje23jSpUt2oqsNLXK4
         HdBNikpNgwvQYjXQmd4E81sXwt/OMEDjgDy6jlqe2lYt04es45JDdam+lVO859lkHEa5
         rdig==
X-Gm-Message-State: AOAM530HLOtfS07w9UtjP7QJ23zZpVfrSX4IEMZQMCSd90GEEt99/45D
        fU4gZooqXq2sB3z1ElGU9YJkDt8miUldafxPmm88cW9TKJiORVAK9enAEdi6TOXtNMHNMt9hUxJ
        tAyV2Kr3ttOmq/VEt
X-Received: by 2002:a05:6214:2342:b0:42d:7c8b:9eac with SMTP id hu2-20020a056214234200b0042d7c8b9eacmr575439qvb.5.1649114099537;
        Mon, 04 Apr 2022 16:14:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwaIxVkenjRBdDOh6Wv2UMQmmTIJuEr8fmsRSmJlATQoawKgS1eJzrIMpeEK/tuHf+1jb3erQ==
X-Received: by 2002:a05:6214:2342:b0:42d:7c8b:9eac with SMTP id hu2-20020a056214234200b0042d7c8b9eacmr575421qvb.5.1649114099261;
        Mon, 04 Apr 2022 16:14:59 -0700 (PDT)
Received: from localhost.localdomain (024-205-208-113.res.spectrum.com. [24.205.208.113])
        by smtp.gmail.com with ESMTPSA id k1-20020ac85fc1000000b002e1c6420790sm10288267qta.40.2022.04.04.16.14.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Apr 2022 16:14:58 -0700 (PDT)
Subject: Re: [PATCH v3 1/2] hwmon: introduce hwmon_sanitize_name()
To:     Michael Walle <michael@walle.cc>, Xu Yilun <yilun.xu@intel.com>,
        Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-hwmon@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, David Laight <David.Laight@ACULAB.COM>
References: <20220404184340.3973329-1-michael@walle.cc>
 <20220404184340.3973329-2-michael@walle.cc>
From:   Tom Rix <trix@redhat.com>
Message-ID: <428c28e4-87cc-50a4-ef13-41ae36702a84@redhat.com>
Date:   Mon, 4 Apr 2022 16:14:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220404184340.3973329-2-michael@walle.cc>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 4/4/22 11:43 AM, Michael Walle wrote:
> More and more drivers will check for bad characters in the hwmon name
> and all are using the same code snippet. Consolidate that code by adding
> a new hwmon_sanitize_name() function.
>
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---
>   Documentation/hwmon/hwmon-kernel-api.rst | 16 ++++++++
>   drivers/hwmon/hwmon.c                    | 50 ++++++++++++++++++++++++
>   include/linux/hwmon.h                    |  3 ++
>   3 files changed, 69 insertions(+)
>
> diff --git a/Documentation/hwmon/hwmon-kernel-api.rst b/Documentation/hwmon/hwmon-kernel-api.rst
> index c41eb6108103..e2975d5caf34 100644
> --- a/Documentation/hwmon/hwmon-kernel-api.rst
> +++ b/Documentation/hwmon/hwmon-kernel-api.rst
> @@ -50,6 +50,10 @@ register/unregister functions::
>   
>     void devm_hwmon_device_unregister(struct device *dev);
>   
> +  char *hwmon_sanitize_name(const char *name);
> +
> +  char *devm_hwmon_sanitize_name(struct device *dev, const char *name);
> +
>   hwmon_device_register_with_groups registers a hardware monitoring device.
>   The first parameter of this function is a pointer to the parent device.
>   The name parameter is a pointer to the hwmon device name. The registration
> @@ -95,6 +99,18 @@ All supported hwmon device registration functions only accept valid device
>   names. Device names including invalid characters (whitespace, '*', or '-')
>   will be rejected. The 'name' parameter is mandatory.
>   
> +If the driver doesn't use a static device name (for example it uses
> +dev_name()), and therefore cannot make sure the name only contains valid
> +characters, hwmon_sanitize_name can be used. This convenience function
> +will duplicate the string and replace any invalid characters with an
> +underscore. It will allocate memory for the new string and it is the
> +responsibility of the caller to release the memory when the device is
> +removed.
> +
> +devm_hwmon_sanitize_name is the resource managed version of
> +hwmon_sanitize_name; the memory will be freed automatically on device
> +removal.
> +
>   Using devm_hwmon_device_register_with_info()
>   --------------------------------------------
>   
> diff --git a/drivers/hwmon/hwmon.c b/drivers/hwmon/hwmon.c
> index 989e2c8496dd..cc4a16a466a0 100644
> --- a/drivers/hwmon/hwmon.c
> +++ b/drivers/hwmon/hwmon.c
> @@ -1057,6 +1057,56 @@ void devm_hwmon_device_unregister(struct device *dev)
>   }
>   EXPORT_SYMBOL_GPL(devm_hwmon_device_unregister);
>   
> +static char *__hwmon_sanitize_name(struct device *dev, const char *old_name)
> +{
> +	char *name, *p;
> +
> +	if (dev)
> +		name = devm_kstrdup(dev, old_name, GFP_KERNEL);
> +	else
> +		name = kstrdup(old_name, GFP_KERNEL);
> +	if (!name)
> +		return NULL;
should return ERR_PTR(-ENOMEM)
> +
> +	for (p = name; *p; p++)
> +		if (hwmon_is_bad_char(*p))
> +			*p = '_';
> +
> +	return name;
> +}
> +
> +/**
> + * hwmon_sanitize_name - Replaces invalid characters in a hwmon name
> + * @name: NUL-terminated name
> + *
> + * Allocates a new string where any invalid characters will be replaced
> + * by an underscore. It is the responsibility of the caller to release
> + * the memory.
> + *
> + * Returns newly allocated name or %NULL in case of error.
> + */
> +char *hwmon_sanitize_name(const char *name)
> +{
> +	return __hwmon_sanitize_name(NULL, name);
> +}
> +EXPORT_SYMBOL_GPL(hwmon_sanitize_name);
> +
> +/**
> + * devm_hwmon_sanitize_name - resource managed hwmon_sanitize_name()
> + * @dev: device to allocate memory for
> + * @name: NUL-terminated name
> + *
> + * Allocates a new string where any invalid characters will be replaced
> + * by an underscore.
> + *
> + * Returns newly allocated name or %NULL in case of error.
> + */
> +char *devm_hwmon_sanitize_name(struct device *dev, const char *name)
> +{
> +	return __hwmon_sanitize_name(dev, name);
Should have a (!dev) check.
> +}
> +EXPORT_SYMBOL_GPL(devm_hwmon_sanitize_name);
> +
>   static void __init hwmon_pci_quirks(void)
>   {
>   #if defined CONFIG_X86 && defined CONFIG_PCI
> diff --git a/include/linux/hwmon.h b/include/linux/hwmon.h
> index eba380b76d15..4efaf06fd2b8 100644
> --- a/include/linux/hwmon.h
> +++ b/include/linux/hwmon.h
> @@ -461,6 +461,9 @@ void devm_hwmon_device_unregister(struct device *dev);
>   int hwmon_notify_event(struct device *dev, enum hwmon_sensor_types type,
>   		       u32 attr, int channel);
>   
> +char *hwmon_sanitize_name(const char *name);
> +char *devm_hwmon_sanitize_name(struct device *dev, const char *name);
> +
>   /**
>    * hwmon_is_bad_char - Is the char invalid in a hwmon name

This still needed in *.h ?

Tom

>    * @ch: the char to be considered

