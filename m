Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FFA1B6F2A
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 00:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388185AbfIRWCp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 18:02:45 -0400
Received: from mail-pl1-f181.google.com ([209.85.214.181]:42647 "EHLO
        mail-pl1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731399AbfIRWCo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 18:02:44 -0400
Received: by mail-pl1-f181.google.com with SMTP id e5so583313pls.9
        for <netdev@vger.kernel.org>; Wed, 18 Sep 2019 15:02:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iOPwOuL8bS9Mt+aiaiCChN58GagA54WRGEg5NZkIGUw=;
        b=GjH4lw4Y0zYglHzdJu+OaDldJT9BZukKJ/9zcMzatrXLjdqPnnrYmNAAGqTagciF7b
         7bBRhKxHjyxno9Z99nTEv1uBicH5iHvcy0SPDF3vU++ZeDvpte8L/YrhPejp/onKMspY
         pLTwrfXXE8rUaC08/EDTSQU9CP0K4dV66AfJCfYo7lSx/eRBY0sdifAmm3utg2fuoLcU
         htmawNwOoY33AyMRhgDs7puQvGz4PQEo6UgUSPPqlgzFIlSRBJx1d6FV++z1F2s696Wc
         3tTeNvJYaZ9S2PXR7f0hMaRsJP98+cYog8+nxGJAY5VINMO2HHmVbBlECsqAGm2L8U1Q
         O8MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=iOPwOuL8bS9Mt+aiaiCChN58GagA54WRGEg5NZkIGUw=;
        b=Iw+7VwZiiSu9qjp9qcg23dt89M0UmohgQQmLq4GUv02Jj+RPXWaiMQkP49PejretuK
         yHRy5Ho7B0aI68WlEn8syzbNtjGRecLPqhHuFU7x2coOUfza5GL9AEYIs6ma0fIL6Gs5
         0/t35VVqhJ3jdQsgEzjVhbSc71Lje8IJy5q1yPxzV4wci8P2lYp2P/gUX9OUfxm+C6qE
         i9lsPP3MaBILOcknzBow30Q7cl/Xw2h0xU94OCAVYwp/RezuSHZvWs4n3XvyBkwCw73b
         xhtQE/SYA6KmSy9bPF19RKr1S49QhLLJb41igNzZDwzLRGgASXxrrdxHMTJJrN5KV1xb
         2IFg==
X-Gm-Message-State: APjAAAX/1LLR7mgIeYdgIJ3r5XtjYE74nKiYottqfi8+2gndN+YNNOn3
        hHLiO5ZUlu2x0oNNFQsn9LY=
X-Google-Smtp-Source: APXvYqwQVyFqIT1KJpzLriPTyGKRwickeacnT2CxBIU+ZGd1mWTDNPc+Eu2rGVF361l4weCTxDuqQA==
X-Received: by 2002:a17:902:850b:: with SMTP id bj11mr6427870plb.39.1568844163512;
        Wed, 18 Sep 2019 15:02:43 -0700 (PDT)
Received: from [10.67.50.53] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id x11sm9833875pja.3.2019.09.18.15.02.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Sep 2019 15:02:42 -0700 (PDT)
Subject: Re: dsa traffic priorization
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Sascha Hauer <s.hauer@pengutronix.de>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        kernel@pengutronix.de
References: <20190918140225.imqchybuf3cnknob@pengutronix.de>
 <CA+h21hpG52R6ScGpGX86Q7MuRHCgGNY-TxzaQGu2wZR8EtPtbA@mail.gmail.com>
 <1b80f9ed-7a62-99c4-10bc-bc1887f80867@gmail.com>
 <CA+h21hrgODP1VrBrJG6Hy9AE3EqqmzPVtjkBAiNjkm+KkwZLHw@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <6e5167ab-5be9-da2e-cd50-e8cff0d2ec6f@gmail.com>
Date:   Wed, 18 Sep 2019 15:02:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CA+h21hrgODP1VrBrJG6Hy9AE3EqqmzPVtjkBAiNjkm+KkwZLHw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/18/19 12:39 PM, Vladimir Oltean wrote:
> Hi Florian,
> 
> On Wed, 18 Sep 2019 at 20:42, Florian Fainelli <f.fainelli@gmail.com> wrote:
>>
>> On 9/18/19 7:36 AM, Vladimir Oltean wrote:
>>> Hi Sascha,
>>>
>>> On Wed, 18 Sep 2019 at 17:03, Sascha Hauer <s.hauer@pengutronix.de> wrote:
>>>>
>>>> Hi All,
>>>>
>>>> We have a customer using a Marvell 88e6240 switch with Ethercat on one port and
>>>> regular network traffic on another port. The customer wants to configure two things
>>>> on the switch: First Ethercat traffic shall be priorized over other network traffic
>>>> (effectively prioritizing traffic based on port). Second the ethernet controller
>>>> in the CPU is not able to handle full bandwidth traffic, so the traffic to the CPU
>>>> port shall be rate limited.
>>>>
>>>
>>> You probably already know this, but egress shaping will not drop
>>> frames, just let them accumulate in the egress queue until something
>>> else happens (e.g. queue occupancy threshold triggers pause frames, or
>>> tail dropping is enabled, etc). Is this what you want? It sounds a bit
>>> strange to me to configure egress shaping on the CPU port of a DSA
>>> switch. That literally means you are buffering frames inside the
>>> system. What about ingress policing?
>>
>> Indeed, but I suppose that depending on the switch architecture and/or
>> nomenclature, configuring egress shaping amounts to determining ingress
>> for the ports where the frame is going to be forwarded to.
> 
> Egress shaping in the switches I've played with has nothing to do with
> the ingress port, unless that is used as a key for some sort for QoS
> classification (aka selector for a traffic class).
> Furthermore, shaping means queuing (which furthermore means delaying,
> but not dropping except in extreme cases which are outside the scope
> of shaping itself), while policing by definition means early dropping
> (admission control). Like Dave Taht pointed out too, dropping might be
> better for the system's overall latency.
> 
>>
>> For instance Broadcom switches rarely if at all mention ingress because
>> the frames have to originate from somewhere and be forwarded to other
>> port(s), therefore, they will egress their original port (which for all
>> practical purposes is the direct continuation of the ingress stage),
>> where shaping happens, which immediately influences the ingress shaping
>> of the destination port, which will egress the frame eventually because
>> packets have to be delivered to the final port's egress queue anyway.
>>
> 
> You lost me.
> I have never heard of any shaping done inside the guts of a switch, so
> 'egress of an ingress port' and 'ingress of an egress port' makes no
> sense to me.

What I meant to explain is that when a packet enters the switch, the
forwarding logic will determine the destination port(s) and queue of
that packet. As soon as the egress port and queue is known the capacity
of that port and queue can be looked up, and that has the immediate
effect of changing how the packets are ingress the switch. I suspect
that the Marvell switches (like Broadcom) use the ability to perform any
form of packet mangling from the perspective of the port's egress (as
opposed to ingress) because ultimately packets need to go somewhere and
the switch logic tries as much as possible to "connect" the ingress port
to the egress port logic to limit on-chip buffering.

> I was talking about ingress policing at the front panel ports, for
> their best-effort traffic. I think that is actually preferable to
> egress shaping at the CPU port, since I don't think they would want
> the EtherCAT traffic getting delayed.

I would view this as classifying and putting a higher priority on
specific types of traffic and making sure that the switch is configured
not to drop certain traffic landing in specific queues. Where that is
applied (ingress, or egress) amounts to the same thing IMHO.

> Alternatively, maybe the DSA master port supports per-stream hardware
> policing, although that is more exotic.

Even if the DSA master network device does not support it, the switch
probably does, so you could do it on traffic that ingresses or egresses
the CPU port.

> 
>>>
>>>> For reference the patch below configures the switch to their needs. Now the question
>>>> is how this can be implemented in a way suitable for mainline. It looks like the per
>>>> port priority mapping for VLAN tagged packets could be done via ip link add link ...
>>>> ingress-qos-map QOS-MAP. How the default priority would be set is unclear to me.
>>>>
>>>
>>> Technically, configuring a match-all rxnfc rule with ethtool would
>>> count as 'default priority' - I have proposed that before. Now I'm not
>>> entirely sure how intuitive it is, but I'm also interested in being
>>> able to configure this.
>>
>> That does not sound too crazy from my perspective.
>>
> 
> Ok, well at least that requires no user space modification, then.
> 
>>>
>>>> The other part of the problem seems to be that the CPU port has no network device
>>>> representation in Linux, so there's no interface to configure the egress limits via tc.
>>>> This has been discussed before, but it seems there hasn't been any consensous regarding how
>>>> we want to proceed?
>>
>> You have the DSA master network device which is on the other side of the
>> switch,
>> --
>> Florian
> 
> Thanks,
> -Vladimir
> 


-- 
Florian
