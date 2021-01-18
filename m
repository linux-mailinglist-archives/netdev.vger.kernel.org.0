Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 306812FADAB
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 00:10:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732751AbhARXJA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 18:09:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731817AbhARXI6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 18:08:58 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D51BC061574
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 15:08:14 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id e7so19900631ljg.10
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 15:08:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=YAZF+0rzTTaoA3ShRgxgRULM9HNzfXGfeF7VgwUC4c4=;
        b=BYAYDrqD7o+6JkdfWR7m5GhHsYNLWWICQhApIUWpN6yJRI3TqksKv49pZe3mfGfWPW
         Ak3+x8CqTf1UoZgEi8YMWaXbsVONlfMVYf7QDaFtcZnZxUbpQ6ZeKTmXmx1IwARhWNS0
         s6yjGPNmfQ/XCjlhRyL4H32CjNvF32zLsb1rQpiHsyWpmmM9D1cNhD6U0flc+Mr5xEHk
         o8Iy96yYp8TTEe1/K2CAu1tO+OIumYHn9Aqw5DBuSyMWdn30450CBSrzZ2G2+ZVJGIYy
         KHpfzDj1M9Eo8qhwQUkIp0FKfq3CuoFLVOia7pa3/hVVrUrutn0JNKHWSeirsl995v/G
         tQow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=YAZF+0rzTTaoA3ShRgxgRULM9HNzfXGfeF7VgwUC4c4=;
        b=HqYGp02eGJ74YjU+syaptaBBhg124jwNYpPUcsgrdQetiH5TvCR4rBxuZMDpwIXAwF
         Mao2hjAIY38Rx8LQ1v8VIGZskFJO5GFOwSXUqRVlIcDvmVNZTfKRaSx0rmoa4f32+kQo
         B7uPtPzgFA5R3H/NaLJwG6vZVac4HgRi14V4i2o0BPpg6jKukpSrccTFIkT4poaxoFGa
         n7JYnXMIwjTQj8X2u0RApQcRVHSMHV+rhUUtotjPRFn51ETKpxJa7f/+C/x+QhXQ6AKf
         YFm9hg4lMD7A41lidLaEnz6aT2XucoOmHrw3F2zMKHfEfNH+yJzD+L0yadj1zsKo4HEt
         UX2w==
X-Gm-Message-State: AOAM533yKIdwwMICpyoVtAl2bv07MV35fUqywVDmhbxMzMINGHEoTT/t
        0RoP+o/ZNTp8JwXc7ZfyxqnBSg==
X-Google-Smtp-Source: ABdhPJyLoBjv1L+nJ4zUK6QLZfbu2kvsnNippaFpqdnj4+fh/YQr5XgTtt3z1Z0doTmnba+23KzM/g==
X-Received: by 2002:a2e:780a:: with SMTP id t10mr730206ljc.67.1611011292977;
        Mon, 18 Jan 2021 15:08:12 -0800 (PST)
Received: from wkz-x280 (h-236-82.A259.priv.bahnhof.se. [98.128.236.82])
        by smtp.gmail.com with ESMTPSA id a24sm1800630ljn.85.2021.01.18.15.08.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 15:08:12 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Network Development <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: Re: commit 4c7ea3c0791e (net: dsa: mv88e6xxx: disable SA learning for DSA and CPU ports)
In-Reply-To: <5c5b243e-389d-cca8-cf3f-7e2833d24c29@prevas.dk>
References: <6106e3d5-31fc-388e-d4ac-c84ac0746a72@prevas.dk> <87h7nhlksr.fsf@waldekranz.com> <20210118211924.u2bl6ynmo5kdyyff@skbuf> <5c5b243e-389d-cca8-cf3f-7e2833d24c29@prevas.dk>
Date:   Tue, 19 Jan 2021 00:08:11 +0100
Message-ID: <87k0s9kfms.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 18, 2021 at 23:07, Rasmus Villemoes <rasmus.villemoes@prevas.dk> wrote:
> On 18/01/2021 22.19, Vladimir Oltean wrote:
>> On Sat, Jan 16, 2021 at 02:42:12AM +0100, Tobias Waldekranz wrote:
>>>> What I'm _really_ trying to do is to get my mv88e6250 to participate in
>>>> an MRP ring, which AFAICT will require that the master device's MAC gets
>>>> added as a static entry in the ATU: Otherwise, when the ring goes from
>>>> open to closed, I've seen the switch wrongly learn the node's own mac
>>>> address as being in the direction of one of the normal ports, which
>>>> obviously breaks all traffic. So if the topology is
>>>>
>>>>    M
>>>>  /   \
>>>> C1 *** C2
>>>>
>>>> with the link between C1 and C2 being broken, both M-C1 and M-C2 links
>>>> are in forwarding (hence learning) state, so when the C1-C2 link gets
>>>> reestablished, it will take at least one received test packet for M to
>>>> decide to put one of the ports in blocking state - by which time the
>>>> damage is done, and the ATU now has a broken entry for M's own mac address.
>> 
>> What hardware offload features do you need to use for MRP on mv88e6xxx?
>> If none, then considering that Tobias's bridge series may stall, I think
>> by far the easiest approach would be for DSA to detect that it can't
>> offload the bridge+MRP configuration, and keep all ports as standalone.
>> When in standalone mode, the ports don't offload any bridge flags, i.e.
>> they don't do address learning, and the only forwarding destination
>> allowed is the CPU. The only disadvantage is that this is software-based
>> forwarding.

Just put some context around how these protocols are typically deployed:
The ring is the backbone of the whole network and can span hundreds of
switches. Applications range from low-bandwidth process automation to
high-definition IPTV. But even when you can meet the throughput demands
with a CPU, your latency will be off the charts, far beyond what is
acceptable in most cases.

> Which would be an unacceptable regression for my customer's use case. We
> really need some ring redundancy protocol, while also having the switch
> act as, well, a switch and do most forwarding in hardware. We used to
> use ERPS with some gross out-of-tree patches to set up the switch as
> required (much of the same stuff we're discussing here).
>
> Then when MRP got added to the kernel, and apparently some switches with
> hardware support for that are in the pipeline somewhere, we decided to
> try to switch to that - newer revisions of the hardware might include an
> MRP-capable switch, but the existing hardware with the marvell switches
> would (with a kernel and userspace upgrade) be able to coexist with that
> newer hardware.
>
> I took it for granted that MRP had been tested with existing
> switches/switchdev/DSA, but AFAICT (Horatiu, correct me if I'm wrong),
> currently MRP only works with a software bridge and with some
> out-of-tree driver for some not-yet-released hardware? I think I've
> identified what is needed to make it work with mv88e6xxx (and likely
> also other switchdev switches):
>
> (1) the port state as set on the software bridge must be
> offloaded/synchronized to the switch.
>
> (2) the bridge's hardware address must be made a static entry in the
> switch's database to avoid the switch accidentally learning a wrong port
> for that when the ring becomes closed.

I do not know MRP well enough, but that sounds reasonable if the same SA
is used for control packets sent through both ports.

> (3) the cpu must be made the only recipient of frames with an MRP
> multicast DA, 01:15:e4:...

I would possibly add (4): MRP comes in different "profiles". Some of
them require sending test packets at ridiculously high frequencies (more
than 1kHz IIRC). I would guess that Microchip has a programmable packet
generator that they can use for such things. We could potentially solve
that on newer 6xxx chips with the built-in IMP, but that is perhaps a
bit pie in the sky :)

> For (1), I think the only thing we need is to agree on where in the
> stack we translate from MRP to STP, because the like-named states in the
> two protocols really do behave exactly the same, AFAICT. So it can be
> done all the way up in MRP, perhaps even by getting completely rid of
> the distinction, or anywhere down the notifier stack, towards the actual
> switch driver.

You should search the archives. I distinctly remember somebody bringing
up this point before MRP was merged. So there ought to be some reason
for the existence of SWITCHDEV_ATTR_ID_MRP_PORT_STATE.

> For (2), I still have to see how far Tobias' patches will get me, but at
> least there's some reason independent of MRP to do that.

Like Vladimir said, do not count on that implementation making
it. Though something similar hopefully will.
