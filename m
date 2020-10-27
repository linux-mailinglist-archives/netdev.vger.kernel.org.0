Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE0A029CABF
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 21:53:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1829446AbgJ0Uxv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 16:53:51 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:34097 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1829279AbgJ0Uxu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 16:53:50 -0400
Received: by mail-lj1-f193.google.com with SMTP id y16so3379605ljk.1
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 13:53:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=EY7e0M//LBTB3jmWeULG57tZaR02Jfn1Iw7qLFkt/fk=;
        b=trIeEBHzMzBWqvJukLhFZrLE5cFzX7id9cKEg8FgvLldNM1mLsebUvgRn9/OPUvRtU
         nxQ675oDM9WghPSN4rtjFwB5BIvQGllb/IDWhICW9QlWW6/9rzQ2zTdpx+uGy7Qmz6/b
         6xOCH2+i7JHirhgJ88ygaNFDsclc2RRo+0KPlWVD7x8ZnkHwa1P/BF/+qhnPRk6/OEqq
         O0HPXINJYwxD6/NsHrVgp6CWROA3rOA3M3d94ZbmJLXPDSxTqYPHjfbC8Kww3zuIl7zO
         5tDue9k6WoQFJwQ2w+TgqaXV10O57w8XMd+5AfZigmQEpYN5rs5LuL+ssjyz+z+Q0hEk
         25VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=EY7e0M//LBTB3jmWeULG57tZaR02Jfn1Iw7qLFkt/fk=;
        b=dejJ86u/Mjo4lpOW8KtQdivg3/qzLywp5uD23nfMNvU1qZX6J+4A+SDFNHI2Z5xhPJ
         8GQeWJHHFgIELvbJLex81MlBGiQu4GmSKYWtkHfn57KgeM77qgnpRy+LBctioUsbcavW
         1Oibv5uwKYx3yST999Gj1gDGiPdoOmWRfdB/Wjbyk93Rh1vYCKIUFccFCIkfwhbLevNv
         fdnb0Jk/eDOVZRpwTSrPw/oMWPaueGrVBjB4poIP1Ab25cqC8UQwZOjXAz8q5qXo5bNa
         fb2Ad+gk8G5YdflXLLdXTUhBDIeUVQEIiaZnsOHRskkVHnpaeuJ68B80KOWyLGF/64Dv
         fRfg==
X-Gm-Message-State: AOAM531KW2uWZeXMxAcMJfubkOWPqXzIVOY6A1YZswIznOivrUio142X
        vU9AQKstmpkBKfQcUwXSkiu1vjsK+FYFO+MF
X-Google-Smtp-Source: ABdhPJxqO7adrO2mRxWn5vDD/htlZY5w1hgx8n8z5ze8xh4uQaJYaxy/Fl4jpV7LF8K3x9S8s67KXw==
X-Received: by 2002:a2e:9f49:: with SMTP id v9mr1967992ljk.369.1603832026297;
        Tue, 27 Oct 2020 13:53:46 -0700 (PDT)
Received: from wkz-x280 (h-79-28.A259.priv.bahnhof.se. [79.136.79.28])
        by smtp.gmail.com with ESMTPSA id e30sm172309ljp.90.2020.10.27.13.53.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 13:53:45 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Marek Behun <marek.behun@nic.cz>,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] net: dsa: link aggregation support
In-Reply-To: <20201027200220.3ai2lcyrxkvmd2f4@skbuf>
References: <20201027105117.23052-1-tobias@waldekranz.com> <20201027160530.11fc42db@nic.cz> <20201027152330.GF878328@lunn.ch> <87k0vbv84z.fsf@waldekranz.com> <20201027190034.utk3kkywc54zuxfn@skbuf> <87blgnv4rt.fsf@waldekranz.com> <20201027200220.3ai2lcyrxkvmd2f4@skbuf>
Date:   Tue, 27 Oct 2020 21:53:45 +0100
Message-ID: <878sbrv19i.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 27, 2020 at 22:02, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Tue, Oct 27, 2020 at 08:37:58PM +0100, Tobias Waldekranz wrote:
>> >> In order for this to work on transmit, we need to add forward offloading
>> >> to the bridge so that we can, for example, send one FORWARD from the CPU
>> >> to send an ARP broadcast to swp1..4 instead of four FROM_CPUs.
>
> [...]
>
>> In a single-chip system I agree that it is not needed, the CPU can do
>> the load-balancing in software. But in order to have the hardware do
>> load-balancing on a switch-to-switch LAG, you need to send a FORWARD.
>> 
>> FROM_CPUs would just follow whatever is in the device mapping table. You
>> essentially have the inverse of the TO_CPU problem, but on Tx FROM_CPU
>> would make up 100% of traffic.
>
> Woah, hold on, could you explain in more detail for non-expert people
> like myself to understand.
>
> So FROM_CPU frames (what tag_edsa.c uses now in xmit) can encode a
> _single_ destination port in the frame header.

Correct.

> Whereas the FORWARD frames encode a _source_ port in the frame header.
> You inject FORWARD frames from the CPU port, and you just let the L2
> forwarding process select the adequate destination ports (or LAG, if
> any ports are under one) _automatically_. The reason why you do this, is
> because you want to take advantage of the switch's flooding abilities in
> order to replicate the packet into 4 packets. So you will avoid cloning
> that packet in the bridge in the first place.

Exactly so.

> But correct me if I'm wrong, sending a FORWARD frame from the CPU is a
> slippery slope, since you're never sure that the switch will perform the
> replication exactly as you intended to. The switch will replicate a
> FORWARD frame by looking up the FDB, and we don't even attempt in DSA to
> keep the FDB in sync between software and hardware. And that's why we
> send FROM_CPU frames in tag_edsa.c and not FORWARD frames.

I'm not sure if I agree that it's a slippery slope. The whole point of
the switchdev effort is to sync the switch with the bridge. We trust the
fabric to do all the steps you describe for _all_ other ports.

> What you are really looking for is hardware where the destination field
> for FROM_CPU packets is not a single port index, but a port mask.
>
> Right?

Sure, if that's available it's great. Chips from Marvell's Prestera line
can do this, and many others I'm sure. Alas, LinkStreet devices can not,
and I still want the best performance I can get i that case.

> Also, this problem is completely orthogonal to LAG? Where does LAG even
> come into play here?

It matters if you setup switch-to-switch LAGs. FROM_CPU packets encode
the final device/port, and switches will forward those packet according
to their device mapping tables, which selects a _single_ local port to
use to reach a remote device/port. So all FROM_CPU packets to a given
device/port will always travel through the same set of ports.

In the FORWARD case, you look up the destination in the FDB of each
device, find that it is located on the other side of a LAG, and the
hardware will perform load-balancing.

>> Other than that there are some things that, while strictly speaking
>> possible to do without FORWARDs, become much easier to deal with:
>> 
>> - Multicast routing. This is one case where performance _really_ suffers
>>   from having to skb_clone() to each recipient.
>> 
>> - Bridging between virtual interfaces and DSA ports. Typical example is
>>   an L2 VPN tunnel or one end of a veth pair. On FROM_CPUs, the switch
>>   can not perform SA learning, which means that once you bridge traffic
>>   from the VPN out to a DSA port, the return traffic will be classified
>>   as unknown unicast by the switch and be flooded everywhere.
>
> And how is this going to solve that problem? You mean that the switch
> learns only from FORWARD, but not from FROM_CPU?

Yes, so when you send the FORWARD the switch knows that the station is
located somewhere behind the CPU port. It does not know exactly where,
i.e. it has no knowledge of the VPN tunnel or anything. It just directs
it towards the CPU and the bridge's FDB will take care of the rest.

> Why don't you attempt to solve this more generically somehow? Your
> switch is not the only one that can't perform source address learning
> for injected traffic, there are tons more, some are not even DSA. We
> can't have everybody roll their own solution.

Who said anything about rolling my solution? I'm going for a generic
solution where a netdev can announce to the bridge it is being added to
that it can offload forwarding of packets for all ports belonging to the
same switchdev device. Most probably modeled after how the macvlan
offloading stuff is done.

In the case of mv88e6xxx that would kill two birds with one stone -
great! In other cases you might have to have the DSA subsystem listen to
new neighbors appearing on the bridge and sync those to hardware or
something. Hopefully someone working with that kind of hardware can
solve that problem.
