Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6954F4EC672
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 16:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346786AbiC3OZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 10:25:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346792AbiC3OZM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 10:25:12 -0400
Received: from gateway24.websitewelcome.com (gateway24.websitewelcome.com [192.185.50.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E28F3205BDC
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 07:23:26 -0700 (PDT)
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway24.websitewelcome.com (Postfix) with ESMTP id 0F0FB5B88B7
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 09:23:25 -0500 (CDT)
Received: from 162-215-252-75.unifiedlayer.com ([208.91.199.152])
        by cmsmtp with SMTP
        id ZZEKnItACb6UBZZEKnMkww; Wed, 30 Mar 2022 09:23:25 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:Subject:From:References:Cc:To:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Z+bIz9+dq3nQBsL1agtcS4DmcA/Nw5QI0/tqVKvaifg=; b=TAmA30h2ztJwuOkkbQI6/GJWvG
        u+bhCgdv2vG6ZvQY1NptupTAonDS2Ye5tA8Z+ObNokWMwLIAjs5zrCTKUWnjFlXJ6Gf+a4loIPxb8
        vkucgzRBajBpiLEth5uVDWCXSTJeIgrN52Kn4N8IdcYyyvn19w2QxnNK8tAOjyQp0spZXDHF2mu02
        dGqkNLKbCNyqvijb0LI10q5DZcI80Neiq++ZIrvrKMKB1SU3N3purLRsmuAvYnhAssWo9aHcCpfs1
        uTg2KVBFxrEUD+2t5okTKLVydtTVZmNx0T6nB5WuDveoRg7RETDjz5eoKIf+pfvW8qj+MA6cexSwK
        CXdNH4Pg==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:54566)
        by bh-25.webhostbox.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@roeck-us.net>)
        id 1nZZEK-002NjM-7j; Wed, 30 Mar 2022 14:23:24 +0000
Message-ID: <75093b82-4625-d806-a4ea-372b74e60c3b@roeck-us.net>
Date:   Wed, 30 Mar 2022 07:23:22 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
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
References: <20220329160730.3265481-1-michael@walle.cc>
 <20220329160730.3265481-2-michael@walle.cc>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH v2 1/5] hwmon: introduce hwmon_sanitize_name()
In-Reply-To: <20220329160730.3265481-2-michael@walle.cc>
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
X-Exim-ID: 1nZZEK-002NjM-7j
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net [108.223.40.66]:54566
X-Source-Auth: linux@roeck-us.net
X-Email-Count: 6
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

On 3/29/22 09:07, Michael Walle wrote:
> More and more drivers will check for bad characters in the hwmon name
> and all are using the same code snippet. Consolidate that code by adding
> a new hwmon_sanitize_name() function.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---
>   Documentation/hwmon/hwmon-kernel-api.rst |  9 ++++-
>   drivers/hwmon/hwmon.c                    | 49 ++++++++++++++++++++++++
>   include/linux/hwmon.h                    |  3 ++
>   3 files changed, 60 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/hwmon/hwmon-kernel-api.rst b/Documentation/hwmon/hwmon-kernel-api.rst
> index c41eb6108103..12f4a9bcef04 100644
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
> @@ -93,7 +97,10 @@ removal would be too late.
>   
>   All supported hwmon device registration functions only accept valid device
>   names. Device names including invalid characters (whitespace, '*', or '-')
> -will be rejected. The 'name' parameter is mandatory.
> +will be rejected. The 'name' parameter is mandatory. Before calling a
> +register function you should either use hwmon_sanitize_name or
> +devm_hwmon_sanitize_name to replace any invalid characters with an
> +underscore.

That needs more details and deserves its own paragraph. Calling one of
the functions is only necessary if the original name does or can include
unsupported characters; an unconditional "should" is therefore a bit
strong. Also, it is important to mention that the function duplicates
the name, and that it is the responsibility of the caller to release
the name if hwmon_sanitize_name() was called and the device is removed.

Thanks,
Guenter
