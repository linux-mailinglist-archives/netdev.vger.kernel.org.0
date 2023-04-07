Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 468896DB6DA
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 01:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbjDGXID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 19:08:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbjDGXIB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 19:08:01 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40F1EE053;
        Fri,  7 Apr 2023 16:07:44 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id bl22so17977185oib.11;
        Fri, 07 Apr 2023 16:07:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680908863; x=1683500863;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=1GXeVtN3GoV00vxvLVXGIRrPCAMNFpBRVRalQCm4tNw=;
        b=m48AEcDCRALLEncVyFqYJM9XMMosAkvrgU0vvopYYk1HGswMb5i1miheOhdhOlnirb
         suZ/cBNq0NCM1N6MZ34QkI0NiSopT7nnrAhIQYehH+EKh35o7IyCuSX9AxlbfgDbT9Q+
         xn3lPlhGAzJn1dwJGNWGUuXfuiv+N+dxTfJcMft7eTBr3A64Ipxjwol+mOLSYtkp+/fg
         UFMea724zVY7sw1F1q4wlj8t1nbqld6xNS6a3qje/9/RAIbDDCL3Jr2+KSuVFQrqMqQd
         awLb+ob2IRX5S/nkJEaSagGmJjImZviN588sGPcejuJKsCLJDc6oMIkZDRKQ2Eid+7W/
         G3xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680908863; x=1683500863;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1GXeVtN3GoV00vxvLVXGIRrPCAMNFpBRVRalQCm4tNw=;
        b=NMVtMWJIasdmNof9myvEHtVHJAgwyr1tPfviKWfGT5ObZfGR+ONC0kDNHH5/nTs800
         sj9l8bf3/aFA97Fyd5l0VJ/9eVl2OVWwmgcFfOCY7lC5mRfI06Hx5wklu/TGlKdYwGPb
         suvTCm066v3pSDFk7O/1kXBe2WyzXWoc+CB8veWXJRtvuERtmwO19vuN8SYf015+EQFT
         /hV3vAnBF8gRiZU1ANIWBBCVSdkPOlO/JxxAdaa+iWbt9GCUgV0HWZrBBwJLzqPXhl01
         A6e2H+gMVWYmwqxki8o3tLJaz8x8YEQVI/3rVcqZtWENMgeTYFypxpKFzv3KouWFdvR+
         Xmsw==
X-Gm-Message-State: AAQBX9fC+3Os+UHxQp1das3VNLLqQR3sRZBJxVZrIwmIqIqvNJ/Hew4c
        BktTOj81VmTrREit9EK6uQk=
X-Google-Smtp-Source: AKy350YHr1pybd18G1hzxT7l5kJ9m+cnU4XbxTfRQlQV0TjD+mg7471hZ0ZEEgOnnpYwIOyf1nyJuA==
X-Received: by 2002:aca:d08:0:b0:389:1601:fc7 with SMTP id 8-20020aca0d08000000b0038916010fc7mr1442427oin.34.1680908863540;
        Fri, 07 Apr 2023 16:07:43 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r7-20020acaf307000000b003876369bd0asm2085220oih.19.2023.04.07.16.07.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Apr 2023 16:07:43 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <e6f83397-68f6-f2c6-5594-d3dabac9a192@roeck-us.net>
Date:   Fri, 7 Apr 2023 16:07:40 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 1/8] net: netronome: constify pointers to
 hwmon_channel_info
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        =?UTF-8?Q?Marek_Beh=c3=ban?= <kabel@kernel.org>,
        Xu Liang <lxu@maxlinear.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, oss-drivers@corigine.com
Cc:     Jean Delvare <jdelvare@suse.com>, linux-hwmon@vger.kernel.org
References: <20230407145911.79642-1-krzysztof.kozlowski@linaro.org>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20230407145911.79642-1-krzysztof.kozlowski@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,
        FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/7/23 07:59, Krzysztof Kozlowski wrote:
> Statically allocated array of pointed to hwmon_channel_info can be made
> const for safety.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> 
> ---
> 
> This depends on hwmon core patch:
> https://lore.kernel.org/all/20230406203103.3011503-2-krzysztof.kozlowski@linaro.org/
> 
> Therefore I propose this should also go via hwmon tree.

I am not going to apply patches for 10+ subsystems through the hwmon tree.
This can only result in chaos. The dependent patch is available at

git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-const

or wait until after the next commit window to apply this series.

Thanks,
Guenter

> 
> Cc: Jean Delvare <jdelvare@suse.com>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: linux-hwmon@vger.kernel.org
> ---
>   drivers/net/ethernet/netronome/nfp/nfp_hwmon.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/netronome/nfp/nfp_hwmon.c b/drivers/net/ethernet/netronome/nfp/nfp_hwmon.c
> index 5cabb1aa9c0c..0d6c59d6d4ae 100644
> --- a/drivers/net/ethernet/netronome/nfp/nfp_hwmon.c
> +++ b/drivers/net/ethernet/netronome/nfp/nfp_hwmon.c
> @@ -115,7 +115,7 @@ static const struct hwmon_channel_info nfp_power = {
>   	.config = nfp_power_config,
>   };
>   
> -static const struct hwmon_channel_info *nfp_hwmon_info[] = {
> +static const struct hwmon_channel_info * const nfp_hwmon_info[] = {
>   	&nfp_chip,
>   	&nfp_temp,
>   	&nfp_power,

