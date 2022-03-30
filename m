Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03D564EC8BB
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 17:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348389AbiC3PuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 11:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348387AbiC3PuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 11:50:21 -0400
X-Greylist: delayed 1346 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 30 Mar 2022 08:48:36 PDT
Received: from gateway22.websitewelcome.com (gateway22.websitewelcome.com [192.185.46.234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D78A657B
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 08:48:36 -0700 (PDT)
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway22.websitewelcome.com (Postfix) with ESMTP id A99CB6765
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 10:23:38 -0500 (CDT)
Received: from 162-215-252-75.unifiedlayer.com ([208.91.199.152])
        by cmsmtp with SMTP
        id ZaAcnKOX5b6UBZaAcnOArU; Wed, 30 Mar 2022 10:23:38 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:Subject:From:References:Cc:To:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=MdHWXaxnfXMbT4dGtxOke852Tfh2I+Qj/Hn4tovXMKI=; b=OpHb4H8PkxkvcVUoESQWRYuGEG
        SO/ven6U6l04uXCHxDi572vzwdWjSViNGsrrJktRFu8dHCfRaFpCdHXQ//Mrl0yUQ77GUOESG1QxM
        dpOLQ5XAioqMyvYFgEpwnWLT4qWrYXiOYEtBMLr7QBFWLczZEAATnzfits91r2bUiDFGm0OFzUUQE
        Kd+B1Xmq15wIjp0pAmOUnD1wo0YDcCxDNEUE8NudAwOqVS0tocYysIDKuZpS1p/UJDeEYQf+0Ko0G
        eWXQ5now840rT5FhcIbyM1mfpVA65voncsCiCmNdp1szsrZon7hUM/dmW76HVjTeibF32AkSKkGfd
        9sRL102A==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:54570)
        by bh-25.webhostbox.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@roeck-us.net>)
        id 1nZaAb-0031qE-PN; Wed, 30 Mar 2022 15:23:37 +0000
Message-ID: <4973276f-ed1e-c4ed-18f9-e8078c13f81a@roeck-us.net>
Date:   Wed, 30 Mar 2022 08:23:35 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     Xu Yilun <yilun.xu@intel.com>,
        David Laight <David.Laight@ACULAB.COM>
Cc:     Michael Walle <michael@walle.cc>, Tom Rix <trix@redhat.com>,
        Jean Delvare <jdelvare@suse.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-hwmon@vger.kernel.org" <linux-hwmon@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20220329160730.3265481-1-michael@walle.cc>
 <20220329160730.3265481-2-michael@walle.cc>
 <20220330065047.GA212503@yilunxu-OptiPlex-7050>
 <5029cf18c9df4fab96af13c857d2e0ef@AcuMS.aculab.com>
 <20220330145137.GA214615@yilunxu-OptiPlex-7050>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH v2 1/5] hwmon: introduce hwmon_sanitize_name()
In-Reply-To: <20220330145137.GA214615@yilunxu-OptiPlex-7050>
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
X-Exim-ID: 1nZaAb-0031qE-PN
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net [108.223.40.66]:54570
X-Source-Auth: linux@roeck-us.net
X-Email-Count: 15
X-Source-Cap: cm9lY2s7YWN0aXZzdG07YmgtMjUud2ViaG9zdGJveC5uZXQ=
X-Local-Domain: yes
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/30/22 07:51, Xu Yilun wrote:
> On Wed, Mar 30, 2022 at 10:11:39AM +0000, David Laight wrote:
>> From: Xu Yilun
>>> Sent: 30 March 2022 07:51
>>>
>>> On Tue, Mar 29, 2022 at 06:07:26PM +0200, Michael Walle wrote:
>>>> More and more drivers will check for bad characters in the hwmon name
>>>> and all are using the same code snippet. Consolidate that code by adding
>>>> a new hwmon_sanitize_name() function.
>>>>
>>>> Signed-off-by: Michael Walle <michael@walle.cc>
>>>> ---
>>>>   Documentation/hwmon/hwmon-kernel-api.rst |  9 ++++-
>>>>   drivers/hwmon/hwmon.c                    | 49 ++++++++++++++++++++++++
>>>>   include/linux/hwmon.h                    |  3 ++
>>>>   3 files changed, 60 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/Documentation/hwmon/hwmon-kernel-api.rst b/Documentation/hwmon/hwmon-kernel-api.rst
>>>> index c41eb6108103..12f4a9bcef04 100644
>>>> --- a/Documentation/hwmon/hwmon-kernel-api.rst
>>>> +++ b/Documentation/hwmon/hwmon-kernel-api.rst
>>>> @@ -50,6 +50,10 @@ register/unregister functions::
>>>>
>>>>     void devm_hwmon_device_unregister(struct device *dev);
>>>>
>>>> +  char *hwmon_sanitize_name(const char *name);
>>>> +
>>>> +  char *devm_hwmon_sanitize_name(struct device *dev, const char *name);
>>>> +
>>>>   hwmon_device_register_with_groups registers a hardware monitoring device.
>>>>   The first parameter of this function is a pointer to the parent device.
>>>>   The name parameter is a pointer to the hwmon device name. The registration
>>>> @@ -93,7 +97,10 @@ removal would be too late.
>>>>
>>>>   All supported hwmon device registration functions only accept valid device
>>>>   names. Device names including invalid characters (whitespace, '*', or '-')
>>>> -will be rejected. The 'name' parameter is mandatory.
>>>> +will be rejected. The 'name' parameter is mandatory. Before calling a
>>>> +register function you should either use hwmon_sanitize_name or
>>>> +devm_hwmon_sanitize_name to replace any invalid characters with an
>>>
>>> I suggest                   to duplicate the name and replace ...
>>
>> You are now going to get code that passed in NULL when the kmalloc() fails.
>> If 'sanitizing' the name is the correct thing to do then sanitize it
>> when the copy is made into the allocated structure.
> 
> Then the driver is unaware of the name change, which makes more
> confusing.
> 
>> (I'm assuming that the 'const char *name' parameter doesn't have to
>> be persistent - that would be another bug just waiting to happen.)
> 
> The hwmon core does require a persistent "name" parameter now. No name
> copy is made when hwmon dev register.
> 
>>
>> Seems really pointless to be do a kmalloc() just to pass a string
>> into a function.
> 
> Maybe we should not force a kmalloc() when the sanitizing is needed, let
> the driver decide whether to duplicate the string or not.
> 

Drivers can do that today, and in all existing cases they do so
(which is why I had suggested to handle the duplication in the
convenience function in the first place). Drivers don't _have_
to use the provided convenience functions. At the same time,
convenience functions should cover the most common use cases.

Michael, let's just drop the changes outside drivers/hwmon from
the series, and let's keep hwmon_is_bad_char() in the include file.
Let's just document it, explaining its use case.

Code outside drivers/hwmon can then be independently modified or not
at a later time, based on driver author and/or maintainer preference.

Thanks,
Guenter
