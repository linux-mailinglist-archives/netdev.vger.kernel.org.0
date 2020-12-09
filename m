Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F7BC2D4D32
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 23:02:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388404AbgLIWCK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 17:02:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388362AbgLIWCJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 17:02:09 -0500
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C90EC0613CF
        for <netdev@vger.kernel.org>; Wed,  9 Dec 2020 14:01:29 -0800 (PST)
Received: by mail-lj1-x243.google.com with SMTP id b10so1969403ljp.6
        for <netdev@vger.kernel.org>; Wed, 09 Dec 2020 14:01:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=miKoPhaR6tge0AOD1ax8PnV3WqppucZ1KoOp5F/obJk=;
        b=kK0rnyxtfW6JuURXq19JwgrdG049nKJ1vCGTuq9NZNoDiI368+yX8Y+9YIYu8FkEQc
         b9vXL4OvtL2KUR94uEEzPg+d8RY4fJZYqfpyzp29X5hrW3+dXBKfBcVjUMSo2pXNjaoY
         96Oeob+00sfwQiLaiyLJjNhJcUyctnxBaevGWL59aeb9RlitFXpoP1hDGU8uvdbm0j+T
         jJhtMzVrylmZC1N92YyB7Hz8vYO8gEsuV3GqgVwjRq9/JVJRrL3mO1PS+cMI3mEbxDmy
         RnCiVcTMmJCFPf18fNe8Su7AZrDLHeim+ouRtMM0JyuLvySfEqcP+XrxlYPHGWzbmJO8
         CeTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=miKoPhaR6tge0AOD1ax8PnV3WqppucZ1KoOp5F/obJk=;
        b=LaeyF+QHbdpFwjzE0wy+LU21izWrGbEDkq49pO7q1MuP+iQmJMoHB/JqWYvzdzkn6d
         hvGjMvYB0qf+dQ+dv73u1YASbHwpO3JMD+nAwgnHpU0wEBXepfY3b4BsNWQjmjyP1pKy
         Ty0+52nmPUgebpcm86lEeRE3ONIDon3MGGfN9IjNC8cbgtXmwPnhP7wovffgNA44nc7Y
         YbqrM0VqcnqqIiMbtxOe0OVM1kLqes7cSKhZkCkDMk2KbLGba/waGtwqSgdepuHqrbdQ
         ub9tv4ul6F0YI9sVZso48svcG1JYd7oRPAaE59tOIyhdCi7XbZJJ+QAG1qmP4dg9Zj5E
         bu4g==
X-Gm-Message-State: AOAM531CIaSNjn75wkk1XA6VjgihRDwK7kO6hdp26jFlmR10znLzBTQN
        A+kAC016ucaaHQg4/IEJ58TdXqjOP0Lj0N/1
X-Google-Smtp-Source: ABdhPJw1u/AEqb1HBFpjDmeUSpVf2vvoen1K2nwt/YdJNY1p1KL9YxLCS81rB0bA0l3SPt2FtNF8TQ==
X-Received: by 2002:a2e:9898:: with SMTP id b24mr1863308ljj.248.1607551287302;
        Wed, 09 Dec 2020 14:01:27 -0800 (PST)
Received: from wkz-x280 (h-236-82.A259.priv.bahnhof.se. [98.128.236.82])
        by smtp.gmail.com with ESMTPSA id p15sm296948lfk.111.2020.12.09.14.01.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 14:01:26 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 2/4] net: dsa: Link aggregation support
In-Reply-To: <20201209160440.evuv26c7cnkqdb22@skbuf>
References: <20201202091356.24075-1-tobias@waldekranz.com> <20201202091356.24075-3-tobias@waldekranz.com> <20201208112350.kuvlaxqto37igczk@skbuf> <87mtyo5n40.fsf@waldekranz.com> <20201208163751.4c73gkdmy4byv3rp@skbuf> <87k0tr5q98.fsf@waldekranz.com> <20201209105326.boulnhj5hoaooppz@skbuf> <87eejz5asi.fsf@waldekranz.com> <20201209160440.evuv26c7cnkqdb22@skbuf>
Date:   Wed, 09 Dec 2020 23:01:25 +0100
Message-ID: <878sa663m2.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 09, 2020 at 18:04, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Wed, Dec 09, 2020 at 03:11:41PM +0100, Tobias Waldekranz wrote:
>> On Wed, Dec 09, 2020 at 12:53, Vladimir Oltean <olteanv@gmail.com> wrote:
>> > And I think that .port_lag_change passes more arguments than needed to
>> > the driver.
>> 
>> You mean the `struct netdev_lag_lower_state_info`? Fine by me, it was
>> mostly to avoid hiding state from the driver if anyone needed it.
>
> There are two approaches really.
> Either you extract the useful information from it, which you already do,
> and in that case you don't need to provide the structure from the netdev
> notifier to the driver, or you let the driver pick it up. Either way is
> fine with me, but having both seems redundant.

Consider it cut.

>> >> > I don't think the DSA switch tree is private to anyone.
>> >>
>> >> Well I need somewhere to store the association from LAG netdev to LAG
>> >> ID. These IDs are shared by all chips in the tree. It could be
>> >> replicated on each ds of course, but that does not feel quite right.
>> >
>> > The LAG ID does not have significance beyond the mv88e6xxx driver, does
>> > it? And even there, it's just a number. You could recalculate all IDs
>> > dynamically upon every join/leave, and they would be consistent by
>> > virtue of the fact that you use a formula which ensures consistency
>> > without storing the LAG ID anywhere. Like, say, the LAG ID is to be
>> > determined by the first struct dsa_port in the DSA switch tree that has
>> > dp->bond == lag_dev. The ID itself can be equal to (dp->ds->index *
>> > MAX_NUM_PORTS + dp->index). All switches will agree on what is the first
>> > dp in dst, since they iterate in the same way, and any LAG join/leave
>> > will notify all of them. It has to be like this anyway.
>> 
>> This will not work for mv88e6xxx. The ID is not just an internal number
>> used by the driver. If that was the case we could just as well use the
>> LAG netdev pointer for this purpose. This ID is configured in hardware,
>> and it is shared between blocks in the switch, we can not just
>> dynamically change them. Neither can we use your formula since this is a
>> 4-bit field.
>> 
>> Another issue is how we are going to handle this in the tagger now,
>> since we can no longer call dsa_lag_dev_by_id. I.e. with `struct
>> dsa_lag` we could resolve the LAG ID (which is the only source
>> information we have in the tag) to the corresponding netdev. This
>> information is now only available in mv88e6xxx driver. I am not sure how
>> I am supposed to conjure it up. Ideas?
>
> Yeah, ok, I get your point. I was going to say that:
> (a) accessing the bonding interface in the fast path seems to be a
>     mv88e6xxx problem
> (b) the LAG IDs that you are making DSA fabricate are not necessarily
>     the ones that other drivers will use, due to various other
>     constraints (e.g. ocelot)

It is not the Fibonacci sequence or anything, it is an integer in the
range 0..num_lags-1. I realize that some hardware probably allocate IDs
from some shared (and thus possibly non-contiguous) pool. Maybe ocelot
works like that. But it seems reasonable to think that at least some
other drivers could make use of a linear range.

> so basically my point was that I think you are adding a lot of infra in
> core DSA that only mv88e6xxx will use.

Message received.

> My practical proposal would have been to keep a 16-entry bonding pointer
> array private in mv88e6xxx, which you could retrieve via:
>
> 	struct dsa_port *cpu_dp = netdev->dsa_ptr;
> 	struct dsa_switch *ds = cpu_dp->ds;
> 	struct mv88e6xxx_chip *chip = ds->priv;
>
> 	skb->dev = chip->lags[source_port];
>
> This is just how I would do it. It would not be the first tagger that
> accesses driver private data prior to knowing the net device. It would,
> however, mean that we know for sure that the mv88e6xxx device will
> always be top-of-tree in a cascaded setup. And this is in conflict with
> what I initially said, that the dst is not private to anyone.

Indeed. I am trying to keep up.

> I think that there is a low practical risk that the assumption will not
> hold true basically forever. But I also see why you might like your
> approach more. Maybe Vivien, Andrew, Florian could also chime in and we
> can see if struct dsa_lag "bothers" anybody else except me (bothers in
> the sense that it's an unnecessary complication to hold in DSA). We
> could, of course, also take the middle ground, which would be to keep
> the 16-entry array of bonding net_device pointers in DSA, and you could
> still call your dsa_lag_dev_by_id() and pretend it's generic, and that
> would just look up that table. Even with this middle ground, we are
> getting rid of the port lists and of the reference counting, which is
> still a welcome simplification in my book.

Yeah I agree that we can trim it down to just the array. Going beyond
that point, i.e. doing something like how sja1105 works, is more painful
but possible if Andrew can live with it.
