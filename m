Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4D1178183
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 20:02:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388282AbgCCSCq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 13:02:46 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:56228 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388260AbgCCSCh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 13:02:37 -0500
Received: by mail-pj1-f65.google.com with SMTP id a18so1681210pjs.5
        for <netdev@vger.kernel.org>; Tue, 03 Mar 2020 10:02:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3BNhDcBFF8V5haWOmu0cx8wErWJr50xlfT6eJbmurUI=;
        b=Oc1KkkrCQJDQHvh6Do32CGzwijAkiAK3WDkY5sx8IoE7t44HJvFhzS6eyGD48Nk3tx
         hTJGHru3rnaSm5gKhEEBC6EABuPjS3FHf4tbIQ51er4NxTkfR9E0ePxgc7afX/qXqaZm
         +ed1fg6vk42aDOM7K0gTb4iFZ7VwTbo3LRiPQjBJA9WcTDHMGgMsfDOMjSkMiJETdFVe
         19akQp8p0aS9FNEp0rjkvt2fN6cTTGnI9oTzTrkgswJrV9cALnqYPEGhftbzs4JLG+w1
         5I8ouQ8DFh/YAOHmiKpH2ZRPHBQaJwDowBw/6ss9rRWHyZhClR8EbwmnWh4qmcULqktQ
         qf5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=3BNhDcBFF8V5haWOmu0cx8wErWJr50xlfT6eJbmurUI=;
        b=ptDlBOwmSiNlqz+eefZ7DFVX5ZvgwYfVLhNrKxxaiozD6VFMmCyEZORHI4hDXYotUf
         YmMjVEDeq3haMGszSmyxbLZre4nLDryuqYim59c1EI4Wh87gyB/FBkXliEXlthNDFDOX
         OzRCnQQECzfv4bygO7Md2ze0WZj61qnpQ54BYkzF3Psn7uUjk2uAFvVA6xEWuTGmu6rT
         Z9BCkrxoU9tlp00J5F4kiQvOUmfd2BtV+/PUYNGi/+hMGd8LWiAQ7E3zTmzqP87aOSsr
         92pKteN/5eO+hEtqYLawyMSgT37CTRqPCiVQAMDugWk3tdV/0mS8w4/JLNcs1StWsDVy
         LsHA==
X-Gm-Message-State: ANhLgQ3NQUiyRLajj0IGqfV3M+eSd21smLRL9JPrXLCQ2HWGEYhHSWT+
        KJASvVP5Q62nvAPCPdskjQk=
X-Google-Smtp-Source: ADFU+vv2mtZWnMRMZvMRltSSiZ0++sIuJsQZwHERHLYuH5hkqSjwR4dpzA1mdq5dYxrxsusAd3MTAg==
X-Received: by 2002:a17:902:7297:: with SMTP id d23mr5263367pll.63.1583258556401;
        Tue, 03 Mar 2020 10:02:36 -0800 (PST)
Received: from [10.67.50.123] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id j5sm3069900pjz.44.2020.03.03.10.02.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Mar 2020 10:02:35 -0800 (PST)
Subject: Re: [PATCH v3 net-next 2/2] net: dsa: felix: Allow unknown unicast
 traffic towards the CPU port module
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
References: <20200229145003.23751-1-olteanv@gmail.com>
 <20200229145003.23751-3-olteanv@gmail.com>
 <CA+h21hryPYbSUqzEcmHeae5Rknc-TCmBimLjH-M8Fkiv0jqwGA@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 G10n8gCguORqNGMsVRxrlLs7/himep7MrCc=
Message-ID: <11a8cec0-550a-5050-f560-d92550a3adad@gmail.com>
Date:   Tue, 3 Mar 2020 10:02:31 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CA+h21hryPYbSUqzEcmHeae5Rknc-TCmBimLjH-M8Fkiv0jqwGA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/3/20 8:04 AM, Vladimir Oltean wrote:
> On Sat, 29 Feb 2020 at 16:50, Vladimir Oltean <olteanv@gmail.com> wrote:
>>
>> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>>
>> Compared to other DSA switches, in the Ocelot cores, the RX filtering is
>> a much more important concern.
>>
>> Firstly, the primary use case for Ocelot is non-DSA, so there isn't any
>> secondary Ethernet MAC [the DSA master's one] to implicitly drop frames
>> having a DMAC we are not interested in.  So the switch driver itself
>> needs to install FDB entries towards the CPU port module (PGID_CPU) for
>> the MAC address of each switch port, in each VLAN installed on the port.
>> Every address that is not whitelisted is implicitly dropped. This is in
>> order to achieve a behavior similar to N standalone net devices.
>>
>> Secondly, even in the secondary use case of DSA, such as illustrated by
>> Felix with the NPI port mode, that secondary Ethernet MAC is present,
>> but its RX filter is bypassed. This is because the DSA tags themselves
>> are placed before Ethernet, so the DMAC that the switch ports see is
>> not seen by the DSA master too (since it's shifter to the right).
>>
>> So RX filtering is pretty important. A good RX filter won't bother the
>> CPU in case the switch port receives a frame that it's not interested
>> in, and there exists no other line of defense.
>>
>> Ocelot is pretty strict when it comes to RX filtering: non-IP multicast
>> and broadcast traffic is allowed to go to the CPU port module, but
>> unknown unicast isn't. This means that traffic reception for any other
>> MAC addresses than the ones configured on each switch port net device
>> won't work. This includes use cases such as macvlan or bridging with a
>> non-Ocelot (so-called "foreign") interface. But this seems to be fine
>> for the scenarios that the Linux system embedded inside an Ocelot switch
>> is intended for - it is simply not interested in unknown unicast
>> traffic, as explained in Allan Nielsen's presentation [0].
>>
>> On the other hand, the Felix DSA switch is integrated in more
>> general-purpose Linux systems, so it can't afford to drop that sort of
>> traffic in hardware, even if it will end up doing so later, in software.
>>
>> Actually, unknown unicast means more for Felix than it does for Ocelot.
>> Felix doesn't attempt to perform the whitelisting of switch port MAC
>> addresses towards PGID_CPU at all, mainly because it is too complicated
>> to be feasible: while the MAC addresses are unique in Ocelot, by default
>> in DSA all ports are equal and inherited from the DSA master. This adds
>> into account the question of reference counting MAC addresses (delayed
>> ocelot_mact_forget), not to mention reference counting for the VLAN IDs
>> that those MAC addresses are installed in. This reference counting
>> should be done in the DSA core, and the fact that it wasn't needed so
>> far is due to the fact that the other DSA switches don't have the DSA
>> tag placed before Ethernet, so the DSA master is able to whitelist the
>> MAC addresses in hardware.
>>
>> So this means that even regular traffic termination on a Felix switch
>> port happens through flooding (because neither Felix nor Ocelot learn
>> source MAC addresses from CPU-injected frames).
>>
>> So far we've explained that whitelisting towards PGID_CPU:
>> - helps to reduce the likelihood of spamming the CPU with frames it
>>   won't process very far anyway
>> - is implemented in the ocelot driver
>> - is sufficient for the ocelot use cases
>> - is not feasible in DSA
>> - breaks use cases in DSA, in the current status (whitelisting enabled
>>   but no MAC address whitelisted)
>>
>> So the proposed patch allows unknown unicast frames to be sent to the
>> CPU port module. This is done for the Felix DSA driver only, as Ocelot
>> seems to be happy without it.
>>
>> [0]: https://www.youtube.com/watch?v=B1HhxEcU7Jg
>>
>> Suggested-by: Allan W. Nielsen <allan.nielsen@microchip.com>
>> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>> ---
> 
> I see this patch has "Needs Review / ACK" in patchwork.
> 
> There is in fact a tag:
> 
> Reviewed-by: Allan W. Nielsen <allan.nielsen@microchip.com>
> 
> which I had forgotten to copy over from v2:
> https://www.spinics.net/lists/netdev/msg633098.html
> 
> Hope there are no particular issues with this approach from DSA perspective.

Not really, until/if we implement UC and MC filtering on standalone DSA
ports, this will be revisited, but for now, this is what is expected.
-- 
Florian
