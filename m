Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7524EDF6F
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 19:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233807AbiCaRPq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 13:15:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233991AbiCaRPP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 13:15:15 -0400
Received: from gateway22.websitewelcome.com (gateway22.websitewelcome.com [192.185.46.224])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1139B87
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 10:13:26 -0700 (PDT)
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway22.websitewelcome.com (Postfix) with ESMTP id 00C2D203E8
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 12:13:26 -0500 (CDT)
Received: from 162-215-252-75.unifiedlayer.com ([208.91.199.152])
        by cmsmtp with SMTP
        id ZyKTnFpUrRnrrZyKTnNzHB; Thu, 31 Mar 2022 12:11:25 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:Subject:From:References:Cc:To:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=aI+bV8VGhtRiaWJK4Xog9eYqwu1fuRPuRDubJJk73ag=; b=c0sezV+TbXC1QwszWGrATQAgiE
        0jgkWUUd6BbxqDO+EjXgTMimyq86tP0QHgrkwh/fdgv2dcoCizLW9iQY3UjATcpTyQGemT1pF/nnX
        tbRNrf86txWyX+N4V/p5CVbqCC0ShTYTKybgmUM18V2HM3cUIOpmHsTs28WbH8IFCv4KEkYOUlJZf
        RdRTlWgP6Ouq75QBvgVEZuftBnRcyOa3uTIweNHxc866NyynaZOJZYEg3GCDT27yQyHipY/pR5jWM
        +xFR+50w4G4UxqwHji7U57A8oTvRngZH8DD9sf46URRBQbi+iRz/h4RRPZYRhlJmTQ4xGihNjlE/W
        IWfLcSrw==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:54590)
        by bh-25.webhostbox.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@roeck-us.net>)
        id 1nZyKS-002ePL-N9; Thu, 31 Mar 2022 17:11:24 +0000
Message-ID: <68f0b4b6-59ed-34ac-bc69-810668a979de@roeck-us.net>
Date:   Thu, 31 Mar 2022 10:11:22 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Michael Walle <michael@walle.cc>
Cc:     Xu Yilun <yilun.xu@intel.com>,
        David Laight <David.Laight@aculab.com>,
        Tom Rix <trix@redhat.com>, Jean Delvare <jdelvare@suse.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-hwmon@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20220329160730.3265481-1-michael@walle.cc>
 <20220329160730.3265481-2-michael@walle.cc>
 <20220330065047.GA212503@yilunxu-OptiPlex-7050>
 <5029cf18c9df4fab96af13c857d2e0ef@AcuMS.aculab.com>
 <20220330145137.GA214615@yilunxu-OptiPlex-7050>
 <4973276f-ed1e-c4ed-18f9-e8078c13f81a@roeck-us.net>
 <YkW+kWXrkAttCbsm@shell.armlinux.org.uk>
 <7b3edeabb66e50825cc42ca1edf86bb7@walle.cc>
 <YkXBgTXRIFpE+YDL@shell.armlinux.org.uk>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH v2 1/5] hwmon: introduce hwmon_sanitize_name()
In-Reply-To: <YkXBgTXRIFpE+YDL@shell.armlinux.org.uk>
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
X-Exim-ID: 1nZyKS-002ePL-N9
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net [108.223.40.66]:54590
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

On 3/31/22 07:58, Russell King (Oracle) wrote:
> On Thu, Mar 31, 2022 at 04:51:47PM +0200, Michael Walle wrote:
>> Am 2022-03-31 16:45, schrieb Russell King (Oracle):
>>> On Wed, Mar 30, 2022 at 08:23:35AM -0700, Guenter Roeck wrote:
>>>> Michael, let's just drop the changes outside drivers/hwmon from
>>>> the series, and let's keep hwmon_is_bad_char() in the include file.
>>>> Let's just document it, explaining its use case.
>>>
>>> Why? There hasn't been any objection to the change. All the discussion
>>> seems to be around the new function (this patch) rather than the actual
>>> conversions in drivers.
>>>
>>> I'm entirely in favour of cleaning this up - it irks me that we're doing
>>> exactly the same cleanup everywhere we have a hwmon.
>>>
>>> At the very least, I would be completely in favour of keeping the
>>> changes in the sfp and phy code.
>>
>> FWIW, my plan was to send the hwmon patches first, by then my other
>> series (the polynomial_calc() one) will also be ready to be picked.
>> Then I'd ask Guenter for a stable branch with these two series which
>> hopefully get merged into net-next. Then I can repost the missing
>> patches on net-next along with the new sensors support for the GPY
>> and LAN8814 PHYs.
> 
> Okay, that's fine. It just sounded like the conversion of other drivers
> outside drivers/hwmon was being dropped.
> 

Not dropped, just disconnected. From hwmon perspective, we want a certain
set of characters to be dropped or replaced. Also, from hwmon perspective,
it makes sense to have the helper function allocate the replacement data.
There was disagreement about which characters should be replaced, and if
the helper function should allocate the replacement string or not.
I have no intention to change the set of characters without good reason,
and I feel quite strongly about allocating the replacement in the helper
function. Since potential callers don't _have_ to use the helper and don't
_have_ to provide valid names (and are responsible for the consequences),
I would like that discussion to be separate from hwmon changes.

> Note that there's another "sanitisation" of hwmon names in
> drivers/net/phy/marvell.c - that converts any non-alnum character to
> an underscore. Not sure why the different approach was chosen there.
> 

It actually drops non-alphanumeric characters. The name is derived
from the phy device name, which I think is derived from the name field
in struct phy_driver. That includes spaces and '(', ')'. I honestly
have no idea what libsensors would do with '(' and ')'. Either case,
even if that would create a hiccup in libsensors and we would add
'(' and ')' to the 'forbidden' list of characters, the fact that the
code doesn't replace but drop non-alphanumeric characters means
it won't be able to use a helper anyway since that would result
in a hwmon 'name' attribute change and thus not be backward
compatible. Besides, "Marvell_88E1111__Finisar_" would look a bit
odd anyway, and "Marvell88E1111Finisar" may be at least slightly
better.

Guenter
