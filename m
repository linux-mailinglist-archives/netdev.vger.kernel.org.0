Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFDE415B424
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 23:55:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729132AbgBLWzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 17:55:04 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:45786 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727692AbgBLWzE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 17:55:04 -0500
Received: by mail-ed1-f67.google.com with SMTP id v28so4351503edw.12;
        Wed, 12 Feb 2020 14:55:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AP2CQnhbhAdeb/OXvQsj36G6VFSe524rEMr3WNM3vfk=;
        b=kZzAuqVjvxvDv1RGPEoiLhFW2GQ917Bl0LeB2EHGUBa19nH7U2+s+Y67Fq5U4bjsuS
         S533Qh6DSXPqzDwiDQl4bP5CxlFJQSphCUPSWZ26szX6KI3tAHRtqVdv5mIa00oJJkCV
         +AQUs9t+UyqQf5hK9I2eVimpqhi/q0VjGGt231Dq2YkyFZUTrJrntfFcaKl6qS4boLyQ
         ZaK7hoWHHUX0wwk6KSNHmGPFlQhKEMRCPXqPKSVk5YYwPueRbcGm+d64/Zlmbp2TJH8o
         +hsbDvz2s4EzzZmrPiAKm14uBWRZUXPS8qyHYbBpntfmVWF8RghxRmvw5SrAtsd6ei51
         uAiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=AP2CQnhbhAdeb/OXvQsj36G6VFSe524rEMr3WNM3vfk=;
        b=t+H46S7OlNC11TXpsk5U3iqPxNZp75pxqQEAn2oj8O1nPbpHgcHyccuT0iadvJ0Jn2
         S3VigQgKd2qF2f/E/MFm49pEsWahdcz+LjPjBUrIwOwODB5xYHGreD6eMpjRcIRQV/s7
         038K6nMerobuF+fPKf19IESuUtEzfrXpG85d4pW2K8XKMR8wji3wriPKq0YfxAWexqVD
         iTsUqB3n6MwXzKdP5FMNu0NN+7jjxaoN0kuKy+FD8E+/4KNF2KB+9R+sitekGJfz2uQ/
         7Vx9LoBFUrvDOOchp231b9pWYAQGX8nrXM3Ztfcf/c0M6CWdhHtU4fVvfa+KuzR/wpDG
         iZ+Q==
X-Gm-Message-State: APjAAAW8AejkIUDrp/y8SXmHyxTiomk5xAlp+YykmDRhvrxGTPi9EE+T
        gdXPRcewZ1KHh6TBVnz5gRAex7qd
X-Google-Smtp-Source: APXvYqwrCxphnL6kdaFM49q05HCt0dRBGfK4bTjJfzim7TOIt86xns/dWWauZkrittCneO6JiZCJuA==
X-Received: by 2002:a17:906:cb94:: with SMTP id mf20mr13540572ejb.252.1581548100339;
        Wed, 12 Feb 2020 14:55:00 -0800 (PST)
Received: from [10.67.50.49] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id t1sm18419ejg.32.2020.02.12.14.54.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Feb 2020 14:54:58 -0800 (PST)
Subject: Re: [PATCH net] net: dsa: Treat VLAN ID 0 as PVID untagged
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>, michal.vokac@ysoft.com,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20200212200555.2393-1-f.fainelli@gmail.com>
 <CA+h21hpG5y1D2d53P7KK6X5uBFxoSQ_iCs3rRAJe61yxfWWAPA@mail.gmail.com>
 <6ba11003-48fd-0b93-332d-3bc485bcb577@gmail.com>
 <CA+h21hqMLJ0GuZnvv+aCzRBDRfApDouL-piqLVTgZqASBmQv4w@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 G10n8gCguORqNGMsVRxrlLs7/himep7MrCc=
Message-ID: <25462074-8d10-97be-6eee-73507ba0fa48@gmail.com>
Date:   Wed, 12 Feb 2020 14:54:45 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CA+h21hqMLJ0GuZnvv+aCzRBDRfApDouL-piqLVTgZqASBmQv4w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/12/20 2:38 PM, Vladimir Oltean wrote:
> On Wed, 12 Feb 2020 at 23:28, Florian Fainelli <f.fainelli@gmail.com> wrote:
>>
>> On 2/12/20 12:47 PM, Vladimir Oltean wrote:
>>> Hi Florian,
>>>
>>> On Wed, 12 Feb 2020 at 22:06, Florian Fainelli <f.fainelli@gmail.com> wrote:
>>>>
>>>> VLAN ID 0 is special by all kinds and is really meant to be the default
>>>> ingress and egress untagged VLAN. We were not configuring it that way
>>>> and so we would be ingress untagged but egress tagged.
>>>>
>>>> When our devices are interfaced with other link partners such as switch
>>>> devices, the results would be entirely equipment dependent. Some
>>>> switches are completely fine with accepting an egress tagged frame with
>>>> VLAN ID 0 and would send their responses untagged, so everything works,
>>>> but other devices are not so tolerant and would typically reject a VLAN
>>>> ID 0 tagged frame.
>>>
>>> Are you sure that it's not in fact those devices that are not doing
>>> what they're supposed to? VID 0 should be sent as tagged and no port
>>> membership checks should be enforced on it.
>>
>> Where everything works what I see is the following:
>>
>> - Linux on egress sends an untagged frame (as captured by tcpdump) but
>> the VLAN entry for VID 0 makes it egress tagged and the machine on the
>> other sees it as such as well
> 
> So the operating system is sending untagged traffic, it gets
> pvid-tagged by the hardware on the CPU port and is sent as
> egress-tagged on the front panel.
> Odd, but ok, not illegal, I suppose. The odd part is caused by having
> the vid 0 as pvid. Otherwise, having vid 0 as egress-tagged is not in
> itself a problem, since the assumption is that the only way a frame
> would get to the switch with VID 0 was if that VID was already in the
> tag.
> If anything, changing the pvid to something that is egress-untagged
> will give you some nice throughput boost, save you 4 bytes on the wire
> per frame.
> 
>> - the response from that machine is also ingress tagged as captured from
>> the DSA master network device
>>
>> what I do not have visibility into are systems where this does not work
>> but will try to request that.
> 
> Well, we can talk until the cows come home, but until the drop reason
> on those devices is clear, I would refrain from drawing any
> conclusion.
> 
>> Breaking users is obviously bad which
>> prompted me for doing this specification violating frame. I am not sure
>> whether DSA standalone ports qualify as managed ports or not, sounds
>> like no given we have not added support for doing much UC/MC filtering
>> unlike what NICs do.
>>
>>>
>>>>
>>>> Fixes: 061f6a505ac3 ("net: dsa: Add ndo_vlan_rx_{add, kill}_vid implementation")
>>>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>>>> ---
>>>> Hi all,
>>>>
>>>> After looking at all DSA drivers and how they implement port_vlan_add()
>>>> I think this is the right change to do, but would appreciate if you
>>>> could test this on your respective platforms to ensure this is not
>>>> problematic.
>>>
>>> I'm pretty sure this is problematic, for the simple reason that with
>>> this change, DSA is insisting that the default PVID is 0, contrary to
>>> the bridge core which insists it is 1. And some switches, like the
>>> Microchip Ocelot/Felix, don't support more than 1 egress-untagged
>>> VLAN, so adding one of the VIDs 0 or 1 will fail (I don't know the
>>> exact order off-hand). See 1c44ce560b4d ("net: mscc: ocelot: fix
>>> vlan_filtering when enslaving to bridge before link is up") for more
>>> details of how that is going to work.
>>
>> OK, I do wonder if we would be better off just skipping the VLAN
>> programming for VID = 0 and/or just defining a different
>> reserved/default VLAN ID for switches that have global VLAN filtering.
>>
> 
> Oh, right, I remember. This is one of the switches with b53_default_pvid=0?
> So what were you saying... [0]

Yes that is correct, and we also have VLAN filtering being a global
property, which is why we cannot simply reject programming with VID = 0,
since that is the default, and default VID still requires a VLAN entry.

> 
>>>>> Why should we bend the framework because sja1105 and dsa_8021q are
>>>>> special?
> 
> [0]: https://lore.kernel.org/netdev/670c1d7f-4d2c-e9b4-3057-e87a66ad0d33@gmail.com/
> 
> So having 0 as pvid will inevitably cause problems trying to do
> something meaningful with it on egress. Send it tagged, it'll mess
> with your untagged traffic, send it untagged, it'll mess with your
> stack-originated 802.1p-tagged traffic, as well as 802.1p-tagged
> traffic forwarded from other endpoints. Hence the reason why IEEE said
> "don't do that".
> 
> Can't you do whatever workarounds with vid 0 and/or
> NETIF_F_HW_VLAN_CTAG_FILTER that are restricted to b53? The "flags"
> value of 0 for 802.1p tagged frames is fine under the assumption that
> vid 0 is never going to be a pvid, which it'd better not be. The
> bridge doesn't even let you run "bridge vlan add dev swp0 vid 0 pvid
> untagged", that should say something.

Yes, forcing the default VID to be unconditionally untagged (but not
PVID), scoped specifically to b53 works nicely, with, or without VLAN
filtering and I can confirm that no VID 0 tag is sent on the wire (as
expected).

Thanks!
-- 
Florian
