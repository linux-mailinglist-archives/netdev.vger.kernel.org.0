Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F398B4EC7F0
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 17:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348025AbiC3PPF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 11:15:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238645AbiC3PPE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 11:15:04 -0400
Received: from gateway33.websitewelcome.com (gateway33.websitewelcome.com [192.185.146.195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AB76109A4F
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 08:13:18 -0700 (PDT)
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
        by gateway33.websitewelcome.com (Postfix) with ESMTP id 593F244A99
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 10:13:17 -0500 (CDT)
Received: from 162-215-252-75.unifiedlayer.com ([208.91.199.152])
        by cmsmtp with SMTP
        id Za0bnckSHHnotZa0bnUOEM; Wed, 30 Mar 2022 10:13:17 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:Subject:From:References:Cc:To:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=tKdIWG8Ko+/VYotBZ/EE6HR2yUBVPr5g8z4sbrWCXFo=; b=jF7pjhL8GAP5daoECdGSEUYCUB
        Wa4O4ybzLTj9AHumGQbxQgDCqCemhreXrmi80zX16rayqFWxRffhifw1l0RC9OqDjiBPvEDCGZMM3
        1Jz8MnIXq+EY5ubTrCE738JUEsS2LY9Kc2hF+iVL46iFqisGj4RJ1nW+Cn50wPAVslUZRr12OizEs
        E/E5SAvTqIfv0f50WGuqjNVMxitaZlDdZkywsSFAqNKE80E1m5s9eiFprbtPut27XX8kVVZb76f/s
        Ll8S/XPFJ44OjBnjFPeoTmUzbSV5DNQTEP4p4knDLw/L4jMRySkfVqjtUoxPPqxjJDIGOn7RzNuF2
        UD+ZBxKQ==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:54568)
        by bh-25.webhostbox.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@roeck-us.net>)
        id 1nZa0a-002qf7-E6; Wed, 30 Mar 2022 15:13:16 +0000
Message-ID: <795b9b2d-1d6b-359c-ef12-f25c6b3472be@roeck-us.net>
Date:   Wed, 30 Mar 2022 08:13:14 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     David Laight <David.Laight@ACULAB.COM>,
        Michael Walle <michael@walle.cc>,
        Xu Yilun <yilun.xu@intel.com>, Tom Rix <trix@redhat.com>,
        Jean Delvare <jdelvare@suse.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     "linux-hwmon@vger.kernel.org" <linux-hwmon@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20220329160730.3265481-1-michael@walle.cc>
 <20220329160730.3265481-2-michael@walle.cc>
 <75093b82-4625-d806-a4ea-372b74e60c3b@roeck-us.net>
 <02545bf1c21b45f78eba5e8b37951748@AcuMS.aculab.com>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH v2 1/5] hwmon: introduce hwmon_sanitize_name()
In-Reply-To: <02545bf1c21b45f78eba5e8b37951748@AcuMS.aculab.com>
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
X-Exim-ID: 1nZa0a-002qf7-E6
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net [108.223.40.66]:54568
X-Source-Auth: linux@roeck-us.net
X-Email-Count: 1
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

On 3/30/22 07:50, David Laight wrote:
> From: Guenter Roeck
>> Sent: 30 March 2022 15:23
>> On 3/29/22 09:07, Michael Walle wrote:
>>> More and more drivers will check for bad characters in the hwmon name
>>> and all are using the same code snippet. Consolidate that code by adding
>>> a new hwmon_sanitize_name() function.
>>>
>>> Signed-off-by: Michael Walle <michael@walle.cc>
>>> ---
>>>    Documentation/hwmon/hwmon-kernel-api.rst |  9 ++++-
>>>    drivers/hwmon/hwmon.c                    | 49 ++++++++++++++++++++++++
>>>    include/linux/hwmon.h                    |  3 ++
>>>    3 files changed, 60 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/Documentation/hwmon/hwmon-kernel-api.rst b/Documentation/hwmon/hwmon-kernel-api.rst
>>> index c41eb6108103..12f4a9bcef04 100644
>>> --- a/Documentation/hwmon/hwmon-kernel-api.rst
>>> +++ b/Documentation/hwmon/hwmon-kernel-api.rst
>>> @@ -50,6 +50,10 @@ register/unregister functions::
>>>
>>>      void devm_hwmon_device_unregister(struct device *dev);
>>>
>>> +  char *hwmon_sanitize_name(const char *name);
>>> +
>>> +  char *devm_hwmon_sanitize_name(struct device *dev, const char *name);
>>> +
>>>    hwmon_device_register_with_groups registers a hardware monitoring device.
>>>    The first parameter of this function is a pointer to the parent device.
>>>    The name parameter is a pointer to the hwmon device name. The registration
>>> @@ -93,7 +97,10 @@ removal would be too late.
>>>
>>>    All supported hwmon device registration functions only accept valid device
>>>    names. Device names including invalid characters (whitespace, '*', or '-')
>>> -will be rejected. The 'name' parameter is mandatory.
>>> +will be rejected. The 'name' parameter is mandatory. Before calling a
>>> +register function you should either use hwmon_sanitize_name or
>>> +devm_hwmon_sanitize_name to replace any invalid characters with an
>>> +underscore.
>>
>> That needs more details and deserves its own paragraph. Calling one of
>> the functions is only necessary if the original name does or can include
>> unsupported characters; an unconditional "should" is therefore a bit
>> strong. Also, it is important to mention that the function duplicates
>> the name, and that it is the responsibility of the caller to release
>> the name if hwmon_sanitize_name() was called and the device is removed.
> 
> More worrying, and not documented, is that the buffer 'name' points
> to must persist.
> 

You mean the name argument passed to the hwmon registration functions ?
That has been the case forever, and I don't recall a single problem
with it. If it disturbs you, please feel free to submit a patch adding
more details to the documentation.

I would not want to change the code and always copy the name because in
almost all cases it _is_ a fixed string, and duplicating it would have
no value.

> ISTM that the kmalloc() in __hwmon_device_register() should include
> space for a copy of the name.
> It can then do what it will with whatever is passed in.
> 

Whatever is passed in is what the user wants. Registration functions
don't change the name. Providing a valid name is the responsibility
of the caller.

> Oh yes, it has my 'favourite construct':  if (!strlen(name)) ...
> (well str[strlen(str)] = 0 also happens!)
> 

Sorry, I don't understand what the problem is here.

Thanks,
Guenter
