Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 309574F3E4F
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 22:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386707AbiDEOZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 10:25:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352593AbiDENHD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 09:07:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0D8AA8119E
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 05:08:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649160496;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0zqRlYSF/srXUIsESCDUgFTwIIiATXDVky1x44pb9Xk=;
        b=isDrCGq0DW1k+srthUc9D9oACAbT3Kz06yG2laCpTHHYO1htbBVo5h532PQFdB/JfUqvY4
        VdeipPZqF5VWg/C1FcvAIPNeyxHtfzjP8bvUfIdAOHBYrzhrKvoyHPYxa/pJiDLkb1dOgO
        /VKcfQ8T0Q+4Dk2edUa29AOT34aumVY=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-567-t9q522PwOGKSiukc1ARZNg-1; Tue, 05 Apr 2022 08:08:14 -0400
X-MC-Unique: t9q522PwOGKSiukc1ARZNg-1
Received: by mail-qv1-f72.google.com with SMTP id m12-20020ad45dcc000000b00443d70cc310so5341591qvh.11
        for <netdev@vger.kernel.org>; Tue, 05 Apr 2022 05:08:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=0zqRlYSF/srXUIsESCDUgFTwIIiATXDVky1x44pb9Xk=;
        b=MT8BAtzS/CqjwY7eo8b8sUOP5XeBpIJMnUBZ65n34AyGL8doasGX0C/DOhOMEWuSuz
         rRpH2H2dXDfs4gL9y4frYZwn8ywAYC/vli9iuZprx63kTbjO0893jyDDgi42wbSkO808
         KjjvAD2WqUZZ0+e3hLN9jtjnErw5/w6REq5emaqUeUonKBxsKxDZcsm4o4vbH2dQl42/
         MSK9w0LOzk8Z3udEOyEQwvJzjJBDeKoJMPJExLVRK5U8A5PC1b//GHL5GvbA0lisZlGW
         7SO8LG2YsjB9mtQO06vVuaHQ7OrzJhStAlbjjCQfjALS8AwkyojUr8J7a6cK5rQ2A6Fz
         fp8A==
X-Gm-Message-State: AOAM531YWUzjCJSo3amACDijVeiSYZB90TOuF9Lu6VNLNamDPVTgrvNZ
        t5x8g+MSsY+yBg7n3+hcznkEP7+SRbjFH+OiFikF+3AQUByc6wUnfX5DCjr+t3w8gTqPj+v6UJd
        BNg91owYWMUvedRWa
X-Received: by 2002:ad4:5946:0:b0:441:bdc:66c9 with SMTP id eo6-20020ad45946000000b004410bdc66c9mr2453621qvb.127.1649160494141;
        Tue, 05 Apr 2022 05:08:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz5TtZldrYQEHbAEt2L8N1+2NHnNYi/RcZ1pl8tugcUxs0ZtdD/2rNztflj0pCjThaSSwB/hg==
X-Received: by 2002:ad4:5946:0:b0:441:bdc:66c9 with SMTP id eo6-20020ad45946000000b004410bdc66c9mr2453600qvb.127.1649160493936;
        Tue, 05 Apr 2022 05:08:13 -0700 (PDT)
Received: from localhost.localdomain (024-205-208-113.res.spectrum.com. [24.205.208.113])
        by smtp.gmail.com with ESMTPSA id g5-20020ac87f45000000b002e125ef0ba3sm10804418qtk.82.2022.04.05.05.08.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 05:08:13 -0700 (PDT)
Subject: Re: [PATCH v4 1/2] hwmon: introduce hwmon_sanitize_name()
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
References: <20220405092452.4033674-1-michael@walle.cc>
 <20220405092452.4033674-2-michael@walle.cc>
From:   Tom Rix <trix@redhat.com>
Message-ID: <b4302bff-cee6-5ea7-aa99-c0110f374f00@redhat.com>
Date:   Tue, 5 Apr 2022 05:08:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220405092452.4033674-2-michael@walle.cc>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 4/5/22 2:24 AM, Michael Walle wrote:
> More and more drivers will check for bad characters in the hwmon name
> and all are using the same code snippet. Consolidate that code by adding
> a new hwmon_sanitize_name() function.
>
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---
>   Documentation/hwmon/hwmon-kernel-api.rst | 16 +++++++
>   drivers/hwmon/hwmon.c                    | 53 ++++++++++++++++++++++++
>   include/linux/hwmon.h                    |  3 ++
>   3 files changed, 72 insertions(+)
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
> index 989e2c8496dd..5915ccfdb7d9 100644
> --- a/drivers/hwmon/hwmon.c
> +++ b/drivers/hwmon/hwmon.c
> @@ -1057,6 +1057,59 @@ void devm_hwmon_device_unregister(struct device *dev)
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
> +		return ERR_PTR(-ENOMEM);
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
> + * Returns newly allocated name, or ERR_PTR on error.
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
> + * Returns newly allocated name, or ERR_PTR on error.
> + */
> +char *devm_hwmon_sanitize_name(struct device *dev, const char *name)
> +{
> +	if (!dev)
> +		return ERR_PTR(-EINVAL);
> +
> +	return __hwmon_sanitize_name(dev, name);
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

Thanks for the changes.

Reviewed-by: Tom Rix <trix@redhat.com>

> +
>   /**
>    * hwmon_is_bad_char - Is the char invalid in a hwmon name
>    * @ch: the char to be considered

