Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11FD736057F
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 11:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231388AbhDOJVY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 05:21:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbhDOJVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 05:21:23 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5618EC061574
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 02:21:00 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id j18so38166016lfg.5
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 02:21:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=5kreNoPgnSvaqhwhgaGwS2WH9f506d6RC1qhZP+lFyQ=;
        b=UptM/Ka4BzZ4sms7NJCcQeM0nFxDwIPtbL6gp6Xq7nNOn4l8/nnXDEJNlXIgVEDfW5
         96YvLkOa9XPLd0ji+XkMTzlhxySwQq+u79LgezPYwYo35xIUkOz+BaMy9jSr9nk+LLDr
         2c0vhTEtyDBHrdJQCHvJMlLyqb/AzhM1/LpWnDD7gHpcXpUJaoD4RlzXYeyECI8u+3qN
         VuqP4Ye9/zXgZJiAmgXUijnxaZTcTPz8w4mLyZTS4UrSla3Sm9BH1yjV9JOcCdo44My+
         2/7w5Up9DAuofmAzXDoySe6od5CiWqTQKn+mkqRXdjEf5GsRaNznyvSTXJ+9KGBMIo8n
         cDow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=5kreNoPgnSvaqhwhgaGwS2WH9f506d6RC1qhZP+lFyQ=;
        b=OZob5nEObIrRwDohNvdWgXnktB1kASZ8dMaSekTSIcS4TlJ2ZCOFMDMYXwPGJ+i3U4
         QIowX9sVZyvxbbfQ3nwQ+PhGpixk83HKjeY8JX4puJSz7nahPE25pa7hIyMek6NlCEoR
         i6ra0AgMSgrvgUbgcEx5n//OHsdABqs2WiCEiGwkCDx9lVhct/3sBOAi8DQrQenlNiQw
         KSq1lxbcNgHP72NKdozSmxd/ngr/2w2fnQMFCVPhdwI+LwCYS8Njj9rrpqqdRpmYXTvJ
         IbUGHEjVWIAzKgV1szxa8ZWDLuj9qU5rliMRpegV5aKnwVfvxTXgVKeypb/Ieb2cCUzZ
         fwXg==
X-Gm-Message-State: AOAM532MKYm0mnCnc/JZz00jg74Au0SdZerIda4aBcLEYi5i3Iis5A2z
        fEoJHpNW+OIUmM3BCI10r5hG+Q==
X-Google-Smtp-Source: ABdhPJy0PoISlkKHaQkfGyJmreIsn+rwGJGaSyQAbl9UMQ4Gly5YKBS3uknTb5xjd3uSkiF0jReK0g==
X-Received: by 2002:ac2:5e64:: with SMTP id a4mr1959442lfr.655.1618478458779;
        Thu, 15 Apr 2021 02:20:58 -0700 (PDT)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id i6sm593739lfu.41.2021.04.15.02.20.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 02:20:58 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Marek Behun <marek.behun@nic.cz>,
        Ansuel Smith <ansuelsmth@gmail.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        zhang kai <zhangkaiheb@126.com>,
        Weilong Chen <chenweilong@huawei.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Di Zhu <zhudi21@huawei.com>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC net-next 0/3] Multi-CPU DSA support
In-Reply-To: <20210414233948.cqohy42edoicwk46@skbuf>
References: <20210413005518.2f9b9cef@thinkpad> <87r1jfje26.fsf@waldekranz.com> <87o8ejjdu6.fsf@waldekranz.com> <20210413015450.1ae597da@thinkpad> <20210413022730.2a51c083@thinkpad> <87im4qjl87.fsf@waldekranz.com> <20210413171443.1b2b2f88@thinkpad> <87fszujbif.fsf@waldekranz.com> <20210414171439.1a2e7c1a@thinkpad> <87blagk8w6.fsf@waldekranz.com> <20210414233948.cqohy42edoicwk46@skbuf>
Date:   Thu, 15 Apr 2021 11:20:57 +0200
Message-ID: <878s5jkio6.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 15, 2021 at 02:39, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Wed, Apr 14, 2021 at 08:39:53PM +0200, Tobias Waldekranz wrote:
>> In order to have two entries for the same destination, they must belong
>> to different FIDs. But that FID is also used for automatic learning. So
>> if all ports use their own FID, all the switched traffic will have to be
>> flooded instead, since any address learned on lan0 will be invisible to
>> lan1,2,3 and vice versa.
>
> Can you explain a bit more what do you mean when you say that the FID
> for the CPU port is also used for automatic learning? Since when does
> mv88e6xxx learn frames sent by tag_dsa.c?

I was thinking about the incoming traffic on the LAN ports, not the CPU
port. We are still exclusively sending FROM_CPUs from tag_dsa.c, nothing
has changed there.

> The way Ocelot switches work, and this is also the mechanism that I plan
> to build on top of, is explained in include/soc/mscc/ocelot.h (copied
> here for your convenience):
>
> /* Port Group IDs (PGID) are masks of destination ports.
>  *
>  * For L2 forwarding, the switch performs 3 lookups in the PGID table for each
>  * frame, and forwards the frame to the ports that are present in the logical
>  * AND of all 3 PGIDs.
>  *
>  * These PGID lookups are:
>  * - In one of PGID[0-63]: for the destination masks. There are 2 paths by
>  *   which the switch selects a destination PGID:
>  *     - The {DMAC, VID} is present in the MAC table. In that case, the
>  *       destination PGID is given by the DEST_IDX field of the MAC table entry
>  *       that matched.
>  *     - The {DMAC, VID} is not present in the MAC table (it is unknown). The
>  *       frame is disseminated as being either unicast, multicast or broadcast,
>  *       and according to that, the destination PGID is chosen as being the
>  *       value contained by ANA_FLOODING_FLD_UNICAST,
>  *       ANA_FLOODING_FLD_MULTICAST or ANA_FLOODING_FLD_BROADCAST.
>  *   The destination PGID can be an unicast set: the first PGIDs, 0 to
>  *   ocelot->num_phys_ports - 1, or a multicast set: the PGIDs from
>  *   ocelot->num_phys_ports to 63. By convention, a unicast PGID corresponds to
>  *   a physical port and has a single bit set in the destination ports mask:
>  *   that corresponding to the port number itself. In contrast, a multicast
>  *   PGID will have potentially more than one single bit set in the destination
>  *   ports mask.
>  * - In one of PGID[64-79]: for the aggregation mask. The switch classifier
>  *   dissects each frame and generates a 4-bit Link Aggregation Code which is
>  *   used for this second PGID table lookup. The goal of link aggregation is to
>  *   hash multiple flows within the same LAG on to different destination ports.
>  *   The first lookup will result in a PGID with all the LAG members present in
>  *   the destination ports mask, and the second lookup, by Link Aggregation
>  *   Code, will ensure that each flow gets forwarded only to a single port out
>  *   of that mask (there are no duplicates).
>  * - In one of PGID[80-90]: for the source mask. The third time, the PGID table
>  *   is indexed with the ingress port (plus 80). These PGIDs answer the
>  *   question "is port i allowed to forward traffic to port j?" If yes, then
>  *   BIT(j) of PGID 80+i will be found set. The third PGID lookup can be used
>  *   to enforce the L2 forwarding matrix imposed by e.g. a Linux bridge.
>  */
>
> /* Reserve some destination PGIDs at the end of the range:
>  * PGID_BLACKHOLE: used for not forwarding the frames
>  * PGID_CPU: used for whitelisting certain MAC addresses, such as the addresses
>  *           of the switch port net devices, towards the CPU port module.
>  * PGID_UC: the flooding destinations for unknown unicast traffic.
>  * PGID_MC: the flooding destinations for non-IP multicast traffic.
>  * PGID_MCIPV4: the flooding destinations for IPv4 multicast traffic.
>  * PGID_MCIPV6: the flooding destinations for IPv6 multicast traffic.
>  * PGID_BC: the flooding destinations for broadcast traffic.
>  */
>
> Basically the frame is forwarded towards:
>
> PGID_DST[MAC table -> destination] & PGID_AGGR[aggregation code] & PGID_SRC[source port]
>
> This is also how we set up LAGs in ocelot_set_aggr_pgids: as far as
> PGID_DST is concerned, all traffic towards a LAG is 'sort of multicast'
> (even for unicast traffic), in the sense that the destination port mask
> is all ones for the physical ports in that LAG. We then reduce the
> destination port mask through PGID_AGGR, in the sense that every
> aggregation code (of which there can be 16) has a single bit set,
> corresponding to either one of the physical ports in the LAG. So every
> packet does indeed see no more than one destination port in the end.

This is all very similar to how mv88e6xxx works. The only minor
difference is that the MAC table is wide enough to include the vector
directly. Unicast entries mapped to LAGs are then handled as a special
case for some reason, most likely having to do with supporting
cross-chip configurations correctly I think.

> For multiple CPU ports with static assignment to user ports, it would be
> sufficient, given the Ocelot architecture, to install a single 'multicast'
> entry per address in the MAC table, with a DEST_IDX having two bits set,
> one for each CPU port. Then, we would let the third lookup (PGID_SRC,
> equivalent to the Marvell's port VLANs, AFAIU) enforce the bounding box
> for every packet such that it goes to one CPU port or to another.

Yeah I also considered this approach. Basically you create a broadcast
LAG and then rely on the third component in your expression (or port
based VLANs on mv88e6xxx) above to avoid duplicates?

I dismissed it because I thought that it would break down once you need
to support multiple chips, as the LAGs are managed separately in the
PVT. But I now realize that the PVT is indexed based on the FORWARD tag,
which contains the _source_ information. So that might work for
mv88e6xxx as well!

Marek, what do you think? If this works, it would be great if we could
also allow the hash based approach since that would work better in cases
where you have many flows coming in on a single port that you would like
to spread over multiple cores.

> This, however, has implications upon the DSA API. In my current attempts
> for the 'RX filtering in DSA' series, host addresses are reference-counted
> by DSA, and passed on to the driver through .port_fdb_add and .port_mdb_add
> calls, where the "port" parameter is the CPU port. Which CPU port? Yes.
> It is clear now that DSA should take its hands off of these addresses,
> and we should define a new API for .port_host_uc_add and .port_host_mc_add,
> which is per user port. If the driver doesn't have anything better to do
> or it doesn't support multiple CPU ports for whatever reason, it can go
> ahead and implement .port_host_uc_add(ds, port) as
> .port_fdb_add(ds, dsa_to_port(ds, port)->cpu_dp->index). But it also has
> the option of doing smarter tricks like adding a TCAM trapping entry
> (unknown to tc, why would it be exposed to tc?) or doing this 'multicast'
> MAC table entry thing. But it must also manage potentially duplicate
> entries all by itself. For example, DSA will call .port_host_uc_add at
> probe time with the MAC address of every port. Then, the bridge will
> also notify of static FDB entries, and at least some of those have the
> same MAC address as the port itself. Then, the bridge will be deleted,
> and the expectation is that the driver is smart enough to not remove the
> entry for the port, because that's still needed for standalone traffic
> termination.
>
> It won't be ideal from a driver writer's perspective, but it will be
> flexible.

Yeah I think it is the right approach. We could also supply a default
implementation to handle the default single-CPU-port-case to make it
easier.

> I've started already to send some patches for RX filtering, little by
> little. Don't get your hopes up, it's been almost a year since I started
> working on them with no end in sight, so one thing that's clear is that
> nothing spectacular is going to happen at least until the upcoming merge
> window closes. It also has some dependencies it seems, like for example
> the fact that br_fdb_replay and br_mdb_replay are still far from perfect,
> and the refcounting is still impossible to do without leaks. I have yet
> another non-trivial and insufficiently tested patch series for that,
> which I've been delaying due to the need to work on some other stuff.
