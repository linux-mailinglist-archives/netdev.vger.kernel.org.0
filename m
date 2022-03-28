Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4169B4E9CD1
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 18:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242731AbiC1QwN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 12:52:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236419AbiC1QwL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 12:52:11 -0400
X-Greylist: delayed 1264 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 28 Mar 2022 09:50:30 PDT
Received: from gateway34.websitewelcome.com (gateway34.websitewelcome.com [192.185.148.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8529D434BE
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 09:50:29 -0700 (PDT)
Received: from cm16.websitewelcome.com (cm16.websitewelcome.com [100.42.49.19])
        by gateway34.websitewelcome.com (Postfix) with ESMTP id 2A04A4A244
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 11:29:20 -0500 (CDT)
Received: from 162-215-252-75.unifiedlayer.com ([208.91.199.152])
        by cmsmtp with SMTP
        id YsF6nmAuQXvvJYsF6nzWjF; Mon, 28 Mar 2022 11:29:20 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ravsT/aucKnVvzJpwttquM0/aEFh0FetHl00O2h6aXw=; b=xjQx8mzlpwruVmELyTRwD22SWX
        kE/e3LznR+m0Or0Nb7PZ7nns/mYp12f7xAyY0VLe/P2ZoUhENAbhbNDmr9XrdC7f7jydWJz2XegyI
        ub9qpi2oAwbgnhxNHfp+ptZHItnYLoDwaU3Fj6t87naGkABB8saz7f9p4UDnWWP0drZxMBg1IWub5
        WtYGFj7gO13wOP1p3OwFGHomD9uX+AhwUoRnSF4pBLXMT+tl+fBg4mp7vxuv9u27Jl9cHMZEsDSP4
        FqjLL2+JaHF8DKpw9y1o4h3X9d8ozgyHgJq9Io/l1DBwADJ+dwY6fA0mto8wiT6qkO7rABuPtNvwW
        IsDyTWGw==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:54530)
        by bh-25.webhostbox.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@roeck-us.net>)
        id 1nYsF5-001eOc-VK; Mon, 28 Mar 2022 16:29:20 +0000
Message-ID: <d589a8e5-c297-b03a-41f8-8bb573ec9824@roeck-us.net>
Date:   Mon, 28 Mar 2022 09:29:18 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v1 1/2] hwmon: introduce hwmon_sanitize_name()
Content-Language: en-US
To:     Michael Walle <michael@walle.cc>, Xu Yilun <yilun.xu@intel.com>,
        Tom Rix <trix@redhat.com>, Jean Delvare <jdelvare@suse.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-hwmon@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20220328115226.3042322-1-michael@walle.cc>
 <20220328115226.3042322-2-michael@walle.cc>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20220328115226.3042322-2-michael@walle.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-BWhitelist: no
X-Source-IP: 108.223.40.66
X-Source-L: No
X-Exim-ID: 1nYsF5-001eOc-VK
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net [108.223.40.66]:54530
X-Source-Auth: linux@roeck-us.net
X-Email-Count: 14
X-Source-Cap: cm9lY2s7YWN0aXZzdG07YmgtMjUud2ViaG9zdGJveC5uZXQ=
X-Local-Domain: yes
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/28/22 04:52, Michael Walle wrote:
> More and more drivers will check for bad characters in the hwmon name
> and all are using the same code snippet. Consolidate that code by adding
> a new hwmon_sanitize_name() function.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---
>   drivers/hwmon/intel-m10-bmc-hwmon.c |  5 +----
>   include/linux/hwmon.h               | 16 ++++++++++++++++

Separate patches please, and the new function needs to be documented
in Documentation/hwmon/hwmon-kernel-api.rst.

Thanks,
Guenter

>   2 files changed, 17 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/hwmon/intel-m10-bmc-hwmon.c b/drivers/hwmon/intel-m10-bmc-hwmon.c
> index 7a08e4c44a4b..e6e55fc30153 100644
> --- a/drivers/hwmon/intel-m10-bmc-hwmon.c
> +++ b/drivers/hwmon/intel-m10-bmc-hwmon.c
> @@ -515,7 +515,6 @@ static int m10bmc_hwmon_probe(struct platform_device *pdev)
>   	struct intel_m10bmc *m10bmc = dev_get_drvdata(pdev->dev.parent);
>   	struct device *hwmon_dev, *dev = &pdev->dev;
>   	struct m10bmc_hwmon *hw;
> -	int i;
>   
>   	hw = devm_kzalloc(dev, sizeof(*hw), GFP_KERNEL);
>   	if (!hw)
> @@ -532,9 +531,7 @@ static int m10bmc_hwmon_probe(struct platform_device *pdev)
>   	if (!hw->hw_name)
>   		return -ENOMEM;
>   
> -	for (i = 0; hw->hw_name[i]; i++)
> -		if (hwmon_is_bad_char(hw->hw_name[i]))
> -			hw->hw_name[i] = '_';
> +	hwmon_sanitize_name(hw->hw_name);
>   
>   	hwmon_dev = devm_hwmon_device_register_with_info(dev, hw->hw_name,
>   							 hw, &hw->chip, NULL);
> diff --git a/include/linux/hwmon.h b/include/linux/hwmon.h
> index eba380b76d15..210b8c0b2827 100644
> --- a/include/linux/hwmon.h
> +++ b/include/linux/hwmon.h
> @@ -484,4 +484,20 @@ static inline bool hwmon_is_bad_char(const char ch)
>   	}
>   }
>   
> +/**
> + * hwmon_sanitize_name - Replaces invalid characters in a hwmon name
> + * @name: NUL-terminated name
> + *
> + * Invalid characters in the name will be overwritten in-place by an
> + * underscore.
> + */
> +static inline void hwmon_sanitize_name(char *name)
> +{
> +	while (*name) {
> +		if (hwmon_is_bad_char(*name))
> +			*name = '_';
> +		name++;
> +	};
> +}
> +
>   #endif

