Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E51C035FE82
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 01:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbhDNXke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 19:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232631AbhDNXk2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 19:40:28 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E68BC061574;
        Wed, 14 Apr 2021 16:40:05 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id z22-20020a17090a0156b029014d4056663fso11678744pje.0;
        Wed, 14 Apr 2021 16:40:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hBs1SCYEMaK2SfRfVSUqrILQFgxsmBlNJfj1PYbSrGI=;
        b=tmloqNoFpaSsqVsuLBVXbA+Fq4wTyzASadonLd7zh51qPnlsKVVoLdbO5gXH6jqZ1H
         7t5XL4p2Ed5f8cyNVCkx6cmf0Ph3EUppto1fwzgKcwfRRbLGTh2Zwp+V9PmNY9SiUxCH
         8M22DVlNaVLmxYjhVJWVxaTRmLZMeafYKgTEVhFQc4nngMQ2AgHDlAp7MdCYpMFpgTRq
         LRBRoyZtmp/qBxXBuWW8pVvZlkpun39cxZqTM42bCkLCpxCA5AmSN47l8Ty6K/Lmhs2e
         Mw2Mfl0zRg7osYwx8TbJsSKrEIkjXphfS6nCaOzHSEcfYE4HFHgpSNXd/6Qp6GGMK3mL
         ME4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hBs1SCYEMaK2SfRfVSUqrILQFgxsmBlNJfj1PYbSrGI=;
        b=kPLt+r+rSJXoSqpIo4VTVk2BfKhgUA646f/UXlORXDpNadwWjOu/sUUsGZVyrvnU6O
         c3vJkn9lCx9iY+t8sZFdQZJHw9JzACLiQi/2okZ9yc/EDjrAS4cf/+gwD7vnVeULoFMO
         XEEak6AmWielu5WhSQFg+FSOztzb7dmzIej7eyOcIylFB8o077UT0w+mtAHH0WigxBCu
         DSW2sMxfC2NDsUZmOMCPZzYDyLUUuFZLxbheWwYzDqZxHVH2c+x82I207sXZp4TKMIMZ
         GXvfH5ui0wOUtrN67rbip13apQkth14qHhNgTpzDDJT0lPO8UWEooWnqNsijJ/dsXAQI
         jBKg==
X-Gm-Message-State: AOAM532kA5ZvD65IZWZaBpZCuNLQdIjVzJ0LnN7zXeweaozsVVyXWT3J
        DS3268syUX7aLpm12t5/Mk0=
X-Google-Smtp-Source: ABdhPJxNTnK3B1/m0MJU4y7fQ3PdxEXVqR7z1D/jIvQSv0sYmK3rwq6PlMaUOFNhUeJD4AIup2ab0Q==
X-Received: by 2002:a17:902:b68c:b029:e6:bb9f:7577 with SMTP id c12-20020a170902b68cb02900e6bb9f7577mr772156pls.0.1618443604484;
        Wed, 14 Apr 2021 16:40:04 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id p24sm425600pfn.11.2021.04.14.16.39.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 16:40:04 -0700 (PDT)
Date:   Thu, 15 Apr 2021 02:39:48 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
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
Message-ID: <20210414233948.cqohy42edoicwk46@skbuf>
References: <20210413005518.2f9b9cef@thinkpad>
 <87r1jfje26.fsf@waldekranz.com>
 <87o8ejjdu6.fsf@waldekranz.com>
 <20210413015450.1ae597da@thinkpad>
 <20210413022730.2a51c083@thinkpad>
 <87im4qjl87.fsf@waldekranz.com>
 <20210413171443.1b2b2f88@thinkpad>
 <87fszujbif.fsf@waldekranz.com>
 <20210414171439.1a2e7c1a@thinkpad>
 <87blagk8w6.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87blagk8w6.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 14, 2021 at 08:39:53PM +0200, Tobias Waldekranz wrote:
> In order to have two entries for the same destination, they must belong
> to different FIDs. But that FID is also used for automatic learning. So
> if all ports use their own FID, all the switched traffic will have to be
> flooded instead, since any address learned on lan0 will be invisible to
> lan1,2,3 and vice versa.

Can you explain a bit more what do you mean when you say that the FID
for the CPU port is also used for automatic learning? Since when does
mv88e6xxx learn frames sent by tag_dsa.c?

The way Ocelot switches work, and this is also the mechanism that I plan
to build on top of, is explained in include/soc/mscc/ocelot.h (copied
here for your convenience):

/* Port Group IDs (PGID) are masks of destination ports.
 *
 * For L2 forwarding, the switch performs 3 lookups in the PGID table for each
 * frame, and forwards the frame to the ports that are present in the logical
 * AND of all 3 PGIDs.
 *
 * These PGID lookups are:
 * - In one of PGID[0-63]: for the destination masks. There are 2 paths by
 *   which the switch selects a destination PGID:
 *     - The {DMAC, VID} is present in the MAC table. In that case, the
 *       destination PGID is given by the DEST_IDX field of the MAC table entry
 *       that matched.
 *     - The {DMAC, VID} is not present in the MAC table (it is unknown). The
 *       frame is disseminated as being either unicast, multicast or broadcast,
 *       and according to that, the destination PGID is chosen as being the
 *       value contained by ANA_FLOODING_FLD_UNICAST,
 *       ANA_FLOODING_FLD_MULTICAST or ANA_FLOODING_FLD_BROADCAST.
 *   The destination PGID can be an unicast set: the first PGIDs, 0 to
 *   ocelot->num_phys_ports - 1, or a multicast set: the PGIDs from
 *   ocelot->num_phys_ports to 63. By convention, a unicast PGID corresponds to
 *   a physical port and has a single bit set in the destination ports mask:
 *   that corresponding to the port number itself. In contrast, a multicast
 *   PGID will have potentially more than one single bit set in the destination
 *   ports mask.
 * - In one of PGID[64-79]: for the aggregation mask. The switch classifier
 *   dissects each frame and generates a 4-bit Link Aggregation Code which is
 *   used for this second PGID table lookup. The goal of link aggregation is to
 *   hash multiple flows within the same LAG on to different destination ports.
 *   The first lookup will result in a PGID with all the LAG members present in
 *   the destination ports mask, and the second lookup, by Link Aggregation
 *   Code, will ensure that each flow gets forwarded only to a single port out
 *   of that mask (there are no duplicates).
 * - In one of PGID[80-90]: for the source mask. The third time, the PGID table
 *   is indexed with the ingress port (plus 80). These PGIDs answer the
 *   question "is port i allowed to forward traffic to port j?" If yes, then
 *   BIT(j) of PGID 80+i will be found set. The third PGID lookup can be used
 *   to enforce the L2 forwarding matrix imposed by e.g. a Linux bridge.
 */

/* Reserve some destination PGIDs at the end of the range:
 * PGID_BLACKHOLE: used for not forwarding the frames
 * PGID_CPU: used for whitelisting certain MAC addresses, such as the addresses
 *           of the switch port net devices, towards the CPU port module.
 * PGID_UC: the flooding destinations for unknown unicast traffic.
 * PGID_MC: the flooding destinations for non-IP multicast traffic.
 * PGID_MCIPV4: the flooding destinations for IPv4 multicast traffic.
 * PGID_MCIPV6: the flooding destinations for IPv6 multicast traffic.
 * PGID_BC: the flooding destinations for broadcast traffic.
 */

Basically the frame is forwarded towards:

PGID_DST[MAC table -> destination] & PGID_AGGR[aggregation code] & PGID_SRC[source port]

This is also how we set up LAGs in ocelot_set_aggr_pgids: as far as
PGID_DST is concerned, all traffic towards a LAG is 'sort of multicast'
(even for unicast traffic), in the sense that the destination port mask
is all ones for the physical ports in that LAG. We then reduce the
destination port mask through PGID_AGGR, in the sense that every
aggregation code (of which there can be 16) has a single bit set,
corresponding to either one of the physical ports in the LAG. So every
packet does indeed see no more than one destination port in the end.

For multiple CPU ports with static assignment to user ports, it would be
sufficient, given the Ocelot architecture, to install a single 'multicast'
entry per address in the MAC table, with a DEST_IDX having two bits set,
one for each CPU port. Then, we would let the third lookup (PGID_SRC,
equivalent to the Marvell's port VLANs, AFAIU) enforce the bounding box
for every packet such that it goes to one CPU port or to another.

This, however, has implications upon the DSA API. In my current attempts
for the 'RX filtering in DSA' series, host addresses are reference-counted
by DSA, and passed on to the driver through .port_fdb_add and .port_mdb_add
calls, where the "port" parameter is the CPU port. Which CPU port? Yes.
It is clear now that DSA should take its hands off of these addresses,
and we should define a new API for .port_host_uc_add and .port_host_mc_add,
which is per user port. If the driver doesn't have anything better to do
or it doesn't support multiple CPU ports for whatever reason, it can go
ahead and implement .port_host_uc_add(ds, port) as
.port_fdb_add(ds, dsa_to_port(ds, port)->cpu_dp->index). But it also has
the option of doing smarter tricks like adding a TCAM trapping entry
(unknown to tc, why would it be exposed to tc?) or doing this 'multicast'
MAC table entry thing. But it must also manage potentially duplicate
entries all by itself. For example, DSA will call .port_host_uc_add at
probe time with the MAC address of every port. Then, the bridge will
also notify of static FDB entries, and at least some of those have the
same MAC address as the port itself. Then, the bridge will be deleted,
and the expectation is that the driver is smart enough to not remove the
entry for the port, because that's still needed for standalone traffic
termination.

It won't be ideal from a driver writer's perspective, but it will be
flexible.

I've started already to send some patches for RX filtering, little by
little. Don't get your hopes up, it's been almost a year since I started
working on them with no end in sight, so one thing that's clear is that
nothing spectacular is going to happen at least until the upcoming merge
window closes. It also has some dependencies it seems, like for example
the fact that br_fdb_replay and br_mdb_replay are still far from perfect,
and the refcounting is still impossible to do without leaks. I have yet
another non-trivial and insufficiently tested patch series for that,
which I've been delaying due to the need to work on some other stuff.
