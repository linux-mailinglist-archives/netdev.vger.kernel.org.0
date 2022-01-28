Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8288749F97E
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 13:35:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348504AbiA1MfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 07:35:08 -0500
Received: from proxima.lasnet.de ([78.47.171.185]:45964 "EHLO
        proxima.lasnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244579AbiA1MfG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 07:35:06 -0500
X-Greylist: delayed 73819 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Jan 2022 07:35:03 EST
Received: from [IPV6:2003:e9:d705:dc25:2cd1:34b0:e26d:e30d] (p200300e9d705dc252cd134b0e26de30d.dip0.t-ipconnect.de [IPv6:2003:e9:d705:dc25:2cd1:34b0:e26d:e30d])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 297F1C0963;
        Fri, 28 Jan 2022 13:35:01 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1643373301;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AJeVvZ+DIYl1JgLNYm2z0QjH/hGMl7a6Sf9zKj1vScY=;
        b=WFngGqFmrxw9KFmD2OwFN36aO7fmEBgimAgAr76Gat1CVc01xLQpalgU+lXTL/tKThVvDu
        HEvfDy8Mwl0RbIoxYAbyC4QbDPae/Q7Aony/7ZFwg7Z/W80PC1Vrc1QbW6eyx+VwzmP37q
        IY2URmCiLrvGIqg4bJ9bIkjPtWqozzYZHftpmtf2RuFT+qLEe6Nmngwopu4yWnvUTvl5Ia
        qtyfOSRG5GpwojFijxl3DDa7MkNdMl6Os+09ByCLGFcZg6x+cfYgjHIc2cXyuvtEG6VuV/
        dk6mR5lWfsdXpUWjItnON88PgMnezph6OUjqeImf6H7ZBZtpT/TrWUQoiBF5qg==
Message-ID: <431ac70b-40f8-0666-0919-e3dd20721794@datenfreihafen.org>
Date:   Fri, 28 Jan 2022 13:35:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [wpan-next 2/4] net: mac802154: Include the softMAC stack inside
 the IEEE 802.15.4 menu
Content-Language: en-US
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>, linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
References: <20220120004350.308866-1-miquel.raynal@bootlin.com>
 <20220120004350.308866-3-miquel.raynal@bootlin.com>
 <53c2d017-a7a5-3ed0-a68c-6b67c96b5b54@datenfreihafen.org>
 <20220127175409.777b9dff@xps13>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20220127175409.777b9dff@xps13>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 27.01.22 17:54, Miquel Raynal wrote:
> Hi Stefan,
> 
> stefan@datenfreihafen.org wrote on Thu, 27 Jan 2022 17:04:41 +0100:
> 
>> Hello.
>>
>> On 20.01.22 01:43, Miquel Raynal wrote:
>>> From: David Girault <david.girault@qorvo.com>
>>>
>>> The softMAC stack has no meaning outside of the IEEE 802.15.4 stack and
>>> cannot be used without it.
>>>
>>> Signed-off-by: David Girault <david.girault@qorvo.com>
>>> [miquel.raynal@bootlin.com: Isolate this change from a bigger commit]
>>> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
>>> ---
>>>    net/Kconfig            | 1 -
>>>    net/ieee802154/Kconfig | 1 +
>>>    2 files changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/net/Kconfig b/net/Kconfig
>>> index 0da89d09ffa6..a5e31078fd14 100644
>>> --- a/net/Kconfig
>>> +++ b/net/Kconfig
>>> @@ -228,7 +228,6 @@ source "net/x25/Kconfig"
>>>    source "net/lapb/Kconfig"
>>>    source "net/phonet/Kconfig"
>>>    source "net/6lowpan/Kconfig"
>>> -source "net/mac802154/Kconfig"
>>>    source "net/sched/Kconfig"
>>>    source "net/dcb/Kconfig"
>>>    source "net/dns_resolver/Kconfig"
>>> diff --git a/net/ieee802154/Kconfig b/net/ieee802154/Kconfig
>>> index 31aed75fe62d..7e4b1d49d445 100644
>>> --- a/net/ieee802154/Kconfig
>>> +++ b/net/ieee802154/Kconfig
>>> @@ -36,6 +36,7 @@ config IEEE802154_SOCKET
>>>    	  for 802.15.4 dataframes. Also RAW socket interface to build MAC
>>>    	  header from userspace.
>>>    > +source "net/mac802154/Kconfig"
>>>    source "net/ieee802154/6lowpan/Kconfig"
>>>    >   endif
>>>    
>>
>> Please fold this patch into the previous one moving the Kconfig option around. This can be done in one go.
> 
> Sure.
> 
> By the way, I was questioning myself: why is the mac802154 folder
> outside of ieee802154? I don't really understand the organization but
> as it would massively prevent any of the future changes that I already
> prepared to apply correctly, I haven't proposed such a move -yet. But
> I would like to know what's the idea behind the current folder
> hierarchy?

The directory structure has been in place from the initial merge of the 
subsystem, before Alex and myself took on the maintainer roles.

I see no reason for a move though. The extra burden for backports, etc 
outweigh the urge of cleanliness on the folder structure. :-)

The Kconfig cleanup and move of the file is worth doing, the move of the 
whole source code folder not.

regards
Stefan Schmidt
