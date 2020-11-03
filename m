Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46CE52A4D01
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 18:32:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728974AbgKCRcn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 12:32:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728889AbgKCRcl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 12:32:41 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 465EFC0613D1
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 09:32:41 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id c20so14831107pfr.8
        for <netdev@vger.kernel.org>; Tue, 03 Nov 2020 09:32:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iT4Qk3his9G+kGeNuhO/O7xzo1j5A6DtUwRY7gOIsb8=;
        b=IAqiDJ2euKs95676evHpkD6v12xbvgQR2Dw4IJpSP4bkU9VaJ0yehFzX3GZrMHqenk
         cVSjrmGz+2tWH8LO/LGpnY3/az3qEA6Wu7d+Q1xefZ+zdnTIixDYoAAfqIp48Tz41cc4
         8Lpl2Lir9499I5Ls1IhSCko7Hw6R05bX2r0yvMyXJCUGowl4FgjdcrN3o1opmB0Xa2Uy
         aoXT2eBNP0MrZkueu67WZQbpiUfTaFRtLEG626lnpW8ynePZuXrcJYVkMGwFLBGLcJoS
         tey+8eEdi/9AZyiaXO3iVQ6hF1cn+C56EwQG6Hf++2mZjYZjT/B8w6rtPIsh/ZebDeVz
         KrJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iT4Qk3his9G+kGeNuhO/O7xzo1j5A6DtUwRY7gOIsb8=;
        b=URaDJJwniXFSZmG27GSnAfUjguLmkoVKOSkfY8oD6PBfRLCH5zxt8EjVhGqQj6BROo
         q2PRcAZU4SpAgoCYDLFJAq1q3sXNsvBkBEZoQ2WGcg9k9BMXqZhIIkkbemKK0grkQEws
         jdBBf/RalbZCWkEQEjmb4HdKjo3AJyqtqk605lUbbR7/FzWqEhvbIrWRchZ/8Vz/xVaN
         dGyOvwntN4+/CfbRUwFzSQZe9ryNGvneqpxxfnNsgQsT/QF3Lky9N7ccQHfXl/bh47Y8
         OpCZqL15m2/tom76KKTubz2V3NwbB68C1Z9bZQRgGQz7JTESzyTV95GCYapGmfKViT4v
         KXOg==
X-Gm-Message-State: AOAM532C5z5SM31Ht/LsBUuv23nW8s44WH6xx3SRwZsRVzFiGsPDPKwd
        KmFSDe7lrX/Ma2YK/cN8JiAwOxUMtdU=
X-Google-Smtp-Source: ABdhPJxvGRknIHtNAEoyQl0j2S41P2EZyN69WzHW/S/TpKFWBa7QSpDKPFiwVCyhdaK3EzkvWeBS6A==
X-Received: by 2002:a62:7f56:0:b029:18b:a70:4f76 with SMTP id a83-20020a627f560000b029018b0a704f76mr7637503pfd.8.1604424760651;
        Tue, 03 Nov 2020 09:32:40 -0800 (PST)
Received: from [10.230.28.234] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o13sm4103102pjq.19.2020.11.03.09.32.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2020 09:32:39 -0800 (PST)
Subject: Re: [PATCH v3 net-next 09/12] net: dsa: tag_brcm: let DSA core deal
 with TX reallocation
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
References: <20201101191620.589272-1-vladimir.oltean@nxp.com>
 <20201101191620.589272-10-vladimir.oltean@nxp.com>
 <10537403-67a4-c64a-705a-61bc5f55f80e@gmail.com>
 <20201103105059.t66xhok5elgx4r4h@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <6c9fccf3-c3be-024b-2aae-e27a61d9c8b2@gmail.com>
Date:   Tue, 3 Nov 2020 09:32:38 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201103105059.t66xhok5elgx4r4h@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/3/2020 2:51 AM, Vladimir Oltean wrote:
> On Mon, Nov 02, 2020 at 12:34:11PM -0800, Florian Fainelli wrote:
>> On 11/1/2020 11:16 AM, Vladimir Oltean wrote:
>>> Now that we have a central TX reallocation procedure that accounts for
>>> the tagger's needed headroom in a generic way, we can remove the
>>> skb_cow_head call.
>>>
>>> Cc: Florian Fainelli <f.fainelli@gmail.com>
>>> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>>
>> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> Florian, I just noticed that tag_brcm.c has an __skb_put_padto call,
> even though it is not a tail tagger. This comes from commit:
> 
> commit bf08c34086d159edde5c54902dfa2caa4d9fbd8c
> Author: Florian Fainelli <f.fainelli@gmail.com>
> Date:   Wed Jan 3 22:13:00 2018 -0800
> 
>     net: dsa: Move padding into Broadcom tagger
> 
>     Instead of having the different master network device drivers
>     potentially used by DSA/Broadcom tags, move the padding necessary for
>     the switches to accept short packets where it makes most sense: within
>     tag_brcm.c. This avoids multiplying the number of similar commits to
>     e.g: bgmac, bcmsysport, etc.
> 
>     Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>     Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> Do you remember why this was needed?

Yes, it is explained in the comment surrounding the padding:

         /* The Ethernet switch we are interfaced with needs packets to
be at
           * least 64 bytes (including FCS) otherwise they will be
discarded when
           * they enter the switch port logic. When Broadcom tags are
enabled, we
           * need to make sure that packets are at least 68 bytes
           * (including FCS and tag) because the length verification is
done after
           * the Broadcom tag is stripped off the ingress packet.


> As far as I understand, either the DSA master driver or the MAC itself
> should pad frames automatically. Is that not happening on Broadcom SoCs,
> or why do you need to pad from DSA?

Some of the Ethernet MACs were not doing that automatic padding and/or
had no option to turn this on. This is true for at least SYSTEMPORT (not
Lite) and BGMAC. GENET is also commonly used but does support automatic
RUNT frame padding.

> How should we deal with this? Having tag_brcm.c still do some potential
> reallocation defeats the purpose of doing it centrally, in a way. I was
> trying to change the prototype of struct dsa_device_ops::xmit to stop
> returning a struct sk_buff *, and I stumbled upon this.
> Should we just go ahead and pad everything unconditionally in DSA?
> 

This is really a problem specific to Broadcom tags and how the switch
operate so it seems reasonable to leave those details down to the tagger.
-- 
Florian
