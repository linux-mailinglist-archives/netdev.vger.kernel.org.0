Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA90D3082CD
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 02:03:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231448AbhA2BBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 20:01:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231325AbhA2BBL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 20:01:11 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BBA4C061574
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 17:00:30 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id d22so8762288edy.1
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 17:00:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2gf0tTYqhsXIxZ/0yw2TdVEKLNpt7jZPOCqcnsX8xFo=;
        b=g7yGJp4FHJ4yj1OhOEOrGYO25M6sW5Jur0zPQi8uUcwuX3ZfwUuT9vwigOIQtJ7qPI
         MrNLk+b6lYD/pGAHdG2yojZ5bUtvF8k1LqqSbHSb1nxbxLnzhTUhrnzz3FmTS5WN5hKx
         BVaEBSoTuW4U0pkG4ok6zuuGPzpPQWHAFbzNJcuLBrq1/rSil/qNFK8hkusFvuJufkuk
         Y4x1MeBJ8LdjZpHIYPvQ4Zr1x6AUpAwUwSInLXPfmLrAQoG8Sc0Uffp4tHpWZmTBr7cN
         hA9nMuQunA1j3EHYCLCTk/rmpgbzzWjKapzGcmq8WphCNK1hq+aRuEU/q96xC/k4D70h
         TSuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2gf0tTYqhsXIxZ/0yw2TdVEKLNpt7jZPOCqcnsX8xFo=;
        b=II/GmeN2IGhg5PZp72SO58XXSd8C/86RqKTnVwrnJw7dnF13P8L2EsHAOFUtdZ7yBh
         qOXyHDQi7tzLd34RR8XJJ+HLAySgkEmRgCNx79r/kophQ5xN8yzxkz/yfflhxBJbJook
         hP8GnjvamosHCc/UmUuekQFeNoEHnuUte8+9J1sPFO0RjoziTWyhv7QGshhZwOF3AcCH
         FX8SdCPTepyoekTvu3o3ZEZCexfCS7a1eQMy4dW0AzxC/yr1PRUW6SIlAkame8qQAK9Z
         bh/SJvQvKj+WuP6tmZ6px2alnXka3o5Xw0kbrvBGy3iS2cM4CFsqTP6PwhhLhz2426Q8
         T1gQ==
X-Gm-Message-State: AOAM532KRXI/vDiY8mwaNo6V+8FUwIX9/EJG4Bb4wn73F1/ArSkLGgRT
        lBIdSTipg7aLL+Y2KDN8AIVhuUk1pf4=
X-Google-Smtp-Source: ABdhPJz38tghpLdA/GN007rEdEPKyPpdDBG3GSJDjtIcLOSowAIBKZA93fohKL4jCpjKjk4LXfp/NQ==
X-Received: by 2002:a50:cf02:: with SMTP id c2mr2474910edk.333.1611882029204;
        Thu, 28 Jan 2021 17:00:29 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id f22sm3049256eje.34.2021.01.28.17.00.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 17:00:28 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v8 net-next 00/11] tag_8021q for Ocelot switches
Date:   Fri, 29 Jan 2021 02:59:58 +0200
Message-Id: <20210129010009.3959398-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Changes in v8:
- Make tagging driver module reference counting work per DSA switch tree
  instead of per CPU port, to be compatible with the tag protocol changing
  through sysfs.
- Refactor ocelot_apply_bridge_fwd_mask and call it immediately after
  the is_dsa_8021q_cpu variable changes, i.e. in
  felix_8021q_cpu_port_init and felix_8021q_cpu_port_deinit.
- Take reference on tagging driver module in dsa_find_tagger_by_name.
- Replaced DSA_NOTIFIER_TAG_PROTO_SET and DSA_NOTIFIER_TAG_PROTO_DEL
  with a single DSA_NOTIFIER_TAG_PROTO.
- Combined .set_tag_protocol and .del_tag_protocol into a single
  .change_tag_protocol, and we're no longer calling those 2 functions at
  probe and unbind time.
- Adapted Felix to .change_tag_protocol. Kept felix_set_tag_protocol and
  felix_del_tag_protocol, but now calling them privately from
  felix_setup and felix_teardown.
- Used -EPROTONOSUPPORT instead of -EOPNOTSUPP as return code.
- Dropped some review tags due to amount of changes.

Changes in v7:
- Keep a copy of the tagging protocol in the DSA switch tree (patch 7/11)
- Call {set,del}_tag_protocol for DSA links with the tag_ops of the DSA
  tree and not of their own dp, since the latter is an invalid pointer
  never set up by anybody.
- Wrap the calls done at probe and remove time into some helper
  functions called dsa_switch_inform_initial_tag_proto and
  dsa_switch_inform_tag_proto_gone. Call dsa_switch_inform_tag_proto_gone
  more vigorously during the probe error path.

- Hold the rtnl_mutex in dsa_tree_change_tag_proto and change the calling
  convention such that drivers now expect rtnl_mutex to be held.
- Drop the rtnl_lock surrounding dsa_8021q_setup in the felix driver,
  since some callers of .{set,del}_tag_protocol now hold the rtnl_mutex
  and we'd run into a deadlock if we took it. That's also why all
  callers needed to be converted to hold the lock, since otherwise
  dsa_8021q_setup would have no guarantees short of passing it a bool
  rtnl_is_held variable.

Changes in v6:
- Removed redundant tree_index from dsa_notifier_tag_proto_info.
- Call .{set,del}_tag_protocol for the DSA links too.
- Check for ops::set_tag_protocol only once instead of in a loop.
- Check for ops::set_tag_protocol in dsa_switch_tag_proto_set too.

Changes in v5:
- Split patch series in half, removing PTP bits.
- Split previous monolithic patch "net: dsa: felix: add new VLAN-based
  tagger" into 3 smaller patches.
- Updated the sysfs documentation
- Made the tagger_lock per DSA switch tree instead of per DSA switch
- Using dsa_tree_notify instead of dsa_broadcast.

Changes in v4:
- Support simultaneous compilation of tag_ocelot.c and
  tag_ocelot_8021q.c.
- Support runtime switchover between the two taggers, by using
  echo ocelot-8021q > /sys/class/net/eno2/dsa/tagging
- We are now actually performing cleanup instead of just probe-time
  setup, which is required for supporting tagger switchover.
- Now draining the CPU queues by continuously reading QS_XTR_READ, same
  as Ocelot, instead of one-time asserting QS_XTR_FLUSH, which actually
  needed a sleep to be effective.

Changes in v3:
Use a per-port bool is_dsa_8021q_cpu instead of a single dsa_8021q_cpu
variable, to be compatible with future work where there may be
potentially multiple tag_8021q CPU ports in a LAG.

Changes in v2:
Posted the entire rework necessary for PTP support using tag_8021q.c.
Added a larger audience to the series.



The Felix switch inside LS1028A has an issue. It has a 2.5G CPU port,
and the external ports, in the majority of use cases, run at 1G. This
means that, when the CPU injects traffic into the switch, it is very
easy to run into congestion. This is not to say that it is impossible to
enter congestion even with all ports running at the same speed, just
that the default configuration is already very prone to that by design.

Normally, the way to deal with that is using Ethernet flow control
(PAUSE frames).

However, this functionality is not working today with the ENETC - Felix
switch pair. The hardware issue is undergoing documentation right now as
an erratum within NXP, but several customers have been requesting a
reasonable workaround for it.

In truth, the LS1028A has 2 internal port pairs. The lack of flow control
is an issue only when NPI mode (Node Processor Interface, aka the mode
where the "CPU port module", which carries DSA-style tagged packets, is
connected to a regular Ethernet port) is used, and NPI mode is supported
by Felix on a single port.

In past BSPs, we have had setups where both internal port pairs were
enabled. We were advertising the following setup:

"data port"     "control port"
  (2.5G)            (1G)

   eno2             eno3
    ^                ^
    |                |
    | regular        | DSA-tagged
    | frames         | frames
    |                |
    v                v
   swp4             swp5

This works but is highly unpractical, due to NXP shifting the task of
designing a functional system (choosing which port to use, depending on
type of traffic required) up to the end user. The swpN interfaces would
have to be bridged with swp4, in order for the eno2 "data port" to have
access to the outside network. And the swpN interfaces would still be
capable of IP networking. So running a DHCP client would give us two IP
interfaces from the same subnet, one assigned to eno2, and the other to
swpN (0, 1, 2, 3).

Also, the dual port design doesn't scale. When attaching another DSA
switch to a Felix port, the end result is that the "data port" cannot
carry any meaningful data to the external world, since it lacks the DSA
tags required to traverse the sja1105 switches below. All that traffic
needs to go through the "control port".

So in newer BSPs there was a desire to simplify that setup, and only
have one internal port pair:

   eno2            eno3
    ^
    |
    | DSA-tagged    x disabled
    | frames
    |
    v
   swp4            swp5

However, this setup only exacerbates the issue of not having flow
control on the NPI port, since that is the only port now. Also, there
are use cases that still require the "data port", such as IEEE 802.1CB
(TSN stream identification doesn't work over an NPI port), source
MAC address learning over NPI, etc.

Again, there is a desire to keep the simplicity of the single internal
port setup, while regaining the benefits of having a dedicated data port
as well. And this series attempts to deliver just that.

So the NPI functionality is disabled conditionally. Its purpose was:
- To ensure individually addressable ports on TX. This can be replaced
  by using some designated VLAN tags which are pushed by the DSA tagger
  code, then removed by the switch (so they are invisible to the outside
  world and to the user).
- To ensure source port identification on RX. Again, this can be
  replaced by using some designated VLAN tags to encapsulate all RX
  traffic (each VLAN uniquely identifies a source port). The DSA tagger
  determines which port it was based on the VLAN number, then removes
  that header.
- To deliver PTP timestamps. This cannot be obtained through VLAN
  headers, so we need to take a step back and see how else we can do
  that. The Microchip Ocelot-1 (VSC7514 MIPS) driver performs manual
  injection/extraction from the CPU port module using register-based
  MMIO, and not over Ethernet. We will need to do the same from DSA,
  which makes this tagger a sort of hybrid between DSA and pure
  switchdev.

Vladimir Oltean (11):
  net: dsa: tag_8021q: add helpers to deduce whether a VLAN ID is RX or
    TX VLAN
  net: mscc: ocelot: export VCAP structures to include/soc/mscc
  net: mscc: ocelot: store a namespaced VCAP filter ID
  net: mscc: ocelot: reapply bridge forwarding mask on bonding
    join/leave
  net: mscc: ocelot: don't use NPI tag prefix for the CPU port module
  net: dsa: document the existing switch tree notifiers and add a new
    one
  net: dsa: keep a copy of the tagging protocol in the DSA switch tree
  net: dsa: allow changing the tag protocol via the "tagging" device
    attribute
  net: dsa: felix: convert to the new .change_tag_protocol DSA API
  net: dsa: add a second tagger for Ocelot switches based on tag_8021q
  net: dsa: felix: perform switch setup for tag_8021q

 Documentation/ABI/testing/sysfs-class-net-dsa |  11 +-
 MAINTAINERS                                   |   1 +
 drivers/net/dsa/ocelot/Kconfig                |   2 +
 drivers/net/dsa/ocelot/felix.c                | 525 ++++++++++++++++--
 drivers/net/dsa/ocelot/felix.h                |   2 +
 drivers/net/dsa/ocelot/felix_vsc9959.c        |   1 +
 drivers/net/dsa/ocelot/seville_vsc9953.c      |   1 +
 drivers/net/ethernet/mscc/ocelot.c            | 120 ++--
 drivers/net/ethernet/mscc/ocelot_flower.c     |   7 +-
 drivers/net/ethernet/mscc/ocelot_net.c        |   1 +
 drivers/net/ethernet/mscc/ocelot_vcap.c       |  19 +-
 drivers/net/ethernet/mscc/ocelot_vcap.h       | 295 +---------
 drivers/net/ethernet/mscc/ocelot_vsc7514.c    |   2 -
 include/linux/dsa/8021q.h                     |  14 +
 include/net/dsa.h                             |  18 +-
 include/soc/mscc/ocelot.h                     |   6 +-
 include/soc/mscc/ocelot_vcap.h                | 297 ++++++++++
 net/dsa/Kconfig                               |  21 +-
 net/dsa/Makefile                              |   1 +
 net/dsa/dsa.c                                 |  26 +
 net/dsa/dsa2.c                                | 128 ++++-
 net/dsa/dsa_priv.h                            |  17 +
 net/dsa/master.c                              |  39 +-
 net/dsa/port.c                                |  44 +-
 net/dsa/slave.c                               |  35 +-
 net/dsa/switch.c                              |  55 ++
 net/dsa/tag_8021q.c                           |  15 +-
 net/dsa/tag_ocelot_8021q.c                    |  68 +++
 28 files changed, 1341 insertions(+), 430 deletions(-)
 create mode 100644 net/dsa/tag_ocelot_8021q.c

-- 
2.25.1

