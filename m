Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6D29530E56
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 12:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234150AbiEWKnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 06:43:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232553AbiEWKnF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 06:43:05 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4470260D7
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 03:43:03 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id p26so18540128eds.5
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 03:43:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=r8bMavu5qNDxq2Hu0WsDEw0PM7lgR8g4qLw5xmr37gM=;
        b=B+tPFo2FKJBQ9GMu9OtNnFtxtVwPf6MT39f0yFnrtcKuxJ8g6FkS/xgSukVhRKsTZp
         8CKlUNtrQDorQEpb7PtM8DNa3hR6V7V22gagm/KGQMYDjKttT4LiSHzK32CpW7PuAsCo
         cxdu0V0WLHuE+bOkKjVjMd8ZxKyWfBISPAHXM+V4rhlHafoMR7AefvA8ye6m0h2eQ/dd
         CV+27BijX3r4aypNkxGLnCGCxLiO+y4uY0vqrAB9CXkzDTpKL0N2QQ7HbAwg+ZwO6XSk
         hIr5A8O73e9MWVkwqWYVMN3RjEBoEqMiwaEi7qkxssCr29P7vqRY+oEA5koqkM/x5PHj
         T2iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=r8bMavu5qNDxq2Hu0WsDEw0PM7lgR8g4qLw5xmr37gM=;
        b=y1GJWu5YYEhIUeTJhXb7AsvgAObBdQXKb+rLRrAmw3ohOwVSX1+VPO74u753mJTc9j
         K5gi8ODFs7ueuRqYTxuEaRBhtfjO6JUsq9OHwm1QvwSs+HfIIq1BKzlIysNfVDanOg1Z
         8d3aiPmSUP3u9t2aHW8VqPRQ/5yKMVNDmXPmTSy3XrcXmE9Ks0VhdZv9J8fHLr8OvW8K
         wK2qeH+rsgd1adypzb0EJnshExePAi6EdK6G/82YWx7b6Wwn3OB+HucViKy8QkNe0F55
         KfkaJXX/1pIOuzoQFtsjRv8Q7iBRQqFVtVxPmPn/vg/9mpKE/YodRaAsw6TwPSwaqpS2
         SB2A==
X-Gm-Message-State: AOAM5316RtBldk+sP9thHDSNuih+p3NQFgIxdGrCof3RN1REDOwvvc/w
        qyvGWuVV+SQydpgv+6JHtf2s47dsfdA=
X-Google-Smtp-Source: ABdhPJwImfgSHqwFlUExwXzmqisxMItb8hMgysMnyoCdhGPkwHKIMhSFvlM81yndlwYsCdjfh5gjXA==
X-Received: by 2002:a05:6402:d51:b0:42a:b2cc:33b2 with SMTP id ec17-20020a0564020d5100b0042ab2cc33b2mr23117479edb.248.1653302581031;
        Mon, 23 May 2022 03:43:01 -0700 (PDT)
Received: from localhost.localdomain ([188.25.255.186])
        by smtp.gmail.com with ESMTPSA id j18-20020a1709066dd200b006feb875503fsm2584822ejt.78.2022.05.23.03.42.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 May 2022 03:43:00 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Frank Wunderlich <frank-w@public-files.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [RFC PATCH net-next 00/12] DSA changes for multiple CPU ports (part 3)
Date:   Mon, 23 May 2022 13:42:44 +0300
Message-Id: <20220523104256.3556016-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Note: this patch set isn't probably tested nearly well enough, and
contains (at least minor) bugs. Don't do crazy things with it. I'm
posting it to get feedback on the proposed UAPI.

Those who have been following part 1:
https://patchwork.kernel.org/project/netdevbpf/cover/20220511095020.562461-1-vladimir.oltean@nxp.com/
and part 2:
https://patchwork.kernel.org/project/netdevbpf/cover/20220521213743.2735445-1-vladimir.oltean@nxp.com/
will know that I am trying to enable the second internal port pair from
the NXP LS1028A Felix switch for DSA-tagged traffic via "ocelot-8021q".
This series represents part 3 of that effort.

Covered here are some code structure changes so that DSA monitors
changeupper events of its masters, as well as new UAPI introduction via
rtnetlink for changing the current master. Note, in the case of a LAG
DSA master, DSA user ports can be assigned to the LAG in 2 ways, either
through this new IFLA_DSA_MASTER, or simply when their existing DSA
master joins a LAG.

Compared to previous attempts to introduce support for multiple CPU ports:
https://lore.kernel.org/netdev/20210410133454.4768-1-ansuelsmth@gmail.com/

my proposal is to not change anything in the default behavior (i.e.
still start off with the first CPU port from the device tree as the only
active CPU port). But focus is instead put on being able to live-change
what the user-to-CPU-port affinity is. Marek Behun has expressed a
potential use case as being to dynamically load balance the termination
of ports between CPU ports, and that should be best handled by a user
space daemon if it only had the means - this creates the means.

Host address filtering is interesting with multiple CPU ports.
There are 2 types of host filtered addresses to consider:
- standalone MAC addresses of ports. These are either inherited from the
  respective DSA masters of the ports, or from the device tree blob.
- local bridge FDB entries.

Traditionally, DSA manages host-filtered addresses by calling
port_fdb_add(dp->cpu_dp->index) in the appropriate database.
But for example, when we have 2 bridged DSA user ports, one with CPU
port A and the other with CPU port B, and the bridge offloads a local
FDB entry for 00:01:02:03:04:05, DSA would attempt to first call
port_fdb_add(A, 00:01:02:03:04:05, DSA_DB_BRIDGE), then
port_fdb_add(B, 00:01:02:03:04:05, DSA_DB_BRIDGE). And since an FDB
entry can have a single destination, the second port_fdb_add()
overwrites the first one, and locally terminated traffic for the ports
assigned to CPU port A is broken.

What should be done in that situation, at least with the HW I'm working
with, is that the host filtered addresses should be delivered towards a
"multicast" destination that covers both CPU ports, and let the
forwarding matrix eliminate the CPU port that the current user port
isn't affine to.

In my proposed patch set, the Felix driver does exactly that: host
filtered addresses are learned towards a special PGID_CPU that has both
tag_8021q CPU ports as destinations.

I have considered introducing new dsa_switch_ops API in the form of
host_fdb_add(user port) and host_fdb_del(user port) rather than calling
port_fdb_add(cpu port). After all, this would be similar to the newly
introduced port_set_host_flood(user port). But I need to think a bit
more whether it's needed right away.

Finally, there's LAG. Proposals have been made before to describe in DT
that CPU ports are under a LAG, the idea being that we could then do the
same for DSA (cascade) ports. The common problem is that shared (CPU and
DSA) ports have no netdev exposed.

I didn't do that, instead I went for the more natural approach of saying
that if the CPU ports are in a LAG, then the DSA masters are in a
symmetric LAG as well. So why not just monitor when the DSA masters join
a LAG, and piggyback on that configuration and make DSA reconfigure
itself accordingly.

So LAG devices can now be DSA masters, and this is accomplished by
populating their dev->dsa_ptr. Note that we do not create a specific
struct dsa_port to populate their dsa_ptr, instead we reuse the dsa_ptr
of one of the physical DSA masters (the first one, in fact).

Vladimir Oltean (12):
  net: introduce iterators over synced hw addresses
  net: dsa: walk through all changeupper notifier functions
  net: dsa: don't stop at NOTIFY_OK when calling
    ds->ops->port_prechangeupper
  net: bridge: move DSA master bridging restriction to DSA
  net: dsa: existing DSA masters cannot join upper interfaces
  net: dsa: only bring down user ports assigned to a given DSA master
  net: dsa: all DSA masters must be down when changing the tagging
    protocol
  net: dsa: use dsa_tree_for_each_cpu_port in
    dsa_tree_{setup,teardown}_master
  net: dsa: introduce dsa_port_get_master()
  net: dsa: allow the DSA master to be seen and changed through
    rtnetlink
  net: dsa: allow masters to join a LAG
  net: dsa: felix: add support for changing DSA master

 drivers/net/dsa/bcm_sf2.c                     |   4 +-
 drivers/net/dsa/bcm_sf2_cfp.c                 |   4 +-
 drivers/net/dsa/lan9303-core.c                |   4 +-
 drivers/net/dsa/ocelot/felix.c                | 117 ++++-
 drivers/net/dsa/ocelot/felix.h                |   3 +
 .../net/ethernet/mediatek/mtk_ppe_offload.c   |   2 +-
 drivers/net/ethernet/mscc/ocelot.c            |   3 +-
 include/linux/netdevice.h                     |   6 +
 include/net/dsa.h                             |  23 +
 include/soc/mscc/ocelot.h                     |   1 +
 include/uapi/linux/if_link.h                  |  10 +
 net/bridge/br_if.c                            |  20 -
 net/dsa/Makefile                              |  10 +-
 net/dsa/dsa.c                                 |   9 +
 net/dsa/dsa2.c                                |  72 ++--
 net/dsa/dsa_priv.h                            |  18 +-
 net/dsa/master.c                              |  62 ++-
 net/dsa/netlink.c                             |  62 +++
 net/dsa/port.c                                | 162 ++++++-
 net/dsa/slave.c                               | 404 +++++++++++++++++-
 net/dsa/switch.c                              |  22 +-
 net/dsa/tag_8021q.c                           |   4 +-
 22 files changed, 915 insertions(+), 107 deletions(-)
 create mode 100644 net/dsa/netlink.c

-- 
2.25.1

