Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D04B308A80
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 17:45:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231620AbhA2QnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 11:43:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231631AbhA2Qml (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 11:42:41 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E5EBC061351
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 08:41:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=GDU+w1zGjd6PPToeONUlX0pM9vavNXS4q9a7+/eYzIo=; b=Q/YlOJ85qk/1rgi5hsKRWmRx3z
        DJtDs/K8JIU4cM2zoIIcofo3JzsGR6V7PmyizuyUiO9FoqFAAUFQBdbyIOQaIKQ7brubRPu7FG+0Q
        TlhpbJBUn4rqpqOxfKqTlWazOLmgt3rpla4p+jBQ3lVEEoniY1mn2HDATaQS49bhlRZrz7JM/iK/R
        E6aIXNEJINgXfmsrlLeDMjY6WuiMUc08pt/pW9PQOAQsfJgZisbN5TU1lLOnTLYDNepuU6Hr2YY71
        g0WMDPXjhnyyj3ydZwg6I0zOdKK/zs7VdE0LrMP38yoLcehXytJ4yCCedAA26F4WtiMKdoMw6BDyE
        yhBaFihA==;
Received: from [2601:1c0:6280:3f0::7650]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1l5Wq0-00070B-TT; Fri, 29 Jan 2021 16:41:37 +0000
Subject: Re: [PATCH net-next] net: dsa: hellcreek: Add missing TAPRIO
 dependency
To:     Kurt Kanzenbach <kurt@linutronix.de>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
References: <20210128163338.22665-1-kurt@linutronix.de>
 <1a076f95-3945-c300-4fea-22d28205aef6@infradead.org> <87im7frf8p.fsf@kurt>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <a53df5e2-2c91-69e5-380f-d78982552985@infradead.org>
Date:   Fri, 29 Jan 2021 08:41:30 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <87im7frf8p.fsf@kurt>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/29/21 6:26 AM, Kurt Kanzenbach wrote:
> On Thu Jan 28 2021, Randy Dunlap wrote:
>> On 1/28/21 8:33 AM, Kurt Kanzenbach wrote:
>>> Add missing dependency to TAPRIO to avoid build failures such as:
>>>
>>> |ERROR: modpost: "taprio_offload_get" [drivers/net/dsa/hirschmann/hellcreek_sw.ko] undefined!
>>> |ERROR: modpost: "taprio_offload_free" [drivers/net/dsa/hirschmann/hellcreek_sw.ko] undefined!
>>>
>>> Fixes: 24dfc6eb39b2 ("net: dsa: hellcreek: Add TAPRIO offloading support")
>>> Reported-by: Randy Dunlap <rdunlap@infradead.org>
>>> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
>>> ---
>>>  drivers/net/dsa/hirschmann/Kconfig | 1 +
>>>  1 file changed, 1 insertion(+)
>>>
>>> Note: It's not against net, because the fixed commit is not in net tree, yet.
>>>
>>> diff --git a/drivers/net/dsa/hirschmann/Kconfig b/drivers/net/dsa/hirschmann/Kconfig
>>> index e01191107a4b..9ea2c643f8f8 100644
>>> --- a/drivers/net/dsa/hirschmann/Kconfig
>>> +++ b/drivers/net/dsa/hirschmann/Kconfig
>>> @@ -5,6 +5,7 @@ config NET_DSA_HIRSCHMANN_HELLCREEK
>>>  	depends on NET_DSA
>>>  	depends on PTP_1588_CLOCK
>>>  	depends on LEDS_CLASS
>>> +	depends on NET_SCH_TAPRIO
>>>  	select NET_DSA_TAG_HELLCREEK
>>>  	help
>>>  	  This driver adds support for Hirschmann Hellcreek TSN switches.
>>>
>>
>> Thanks. This fixes the build errors.
>> Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested
>>  
>>
>> However, I do see this in the build output when
>> NET_DSA_HIRSCHMANN_HELLCREEK is disabled:
>>
>>   AR      drivers/net/dsa/hirschmann/built-in.a
>>
>> That is an empty archive file (8 bytes), which is caused by
>> drivers/net/dsa/Makefile:
>>
>> obj-y				+= hirschmann/
>>
>>
>> Is there some reason that it's not done like this?
>> This passes my y/m/n testing.
> 
> Actually I cannot reproduce this. I've disabled
> NET_DSA_HIRSCHMANN_HELLCREEK and nothing shows up in the build log.

Hmph, I don't see it on a clean build either.
Sorry for the noise.

-- 
~Randy

