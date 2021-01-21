Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19FB02FF059
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 17:32:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387928AbhAUQbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 11:31:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387590AbhAUQDC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 11:03:02 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E38DAC06174A
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 08:02:21 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id g12so3310965ejf.8
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 08:02:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fP4Sh2pj8CCXTZDg6dRkM56Vr4c/G80KEeOD79m4Chk=;
        b=aaTwBUg7qiPRu49Pu7PisJR8chaBjCZvqjDQpX16k25RacpI7rmA2R+h1sdefsmuIa
         u/wcdJn7Iyn8aBTZKVzRsNq+7oGeAsr0sBmy9Dz8O7rSXWxLVOmdbhoVXngID2PXkeNl
         Mn2v2IDIr5RF2y2mOam4zB0GhMeaak5OZkCPY2JovQ+oGPaxIFiyiGp0KJUaPCuT02Tj
         08OfxS8qKYlt/SYOC6jvuULPoGgwpWuMb4PEuuHYPClOe7352mH9uXzeYEZrG4oDF8n/
         /ZW8eakFZo1f1Ts9Ks3lIN0GcuGPveiUJfexKxMn8Qc2R4dHWhwRQQ6dlx9KpPclU4Zh
         qINQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fP4Sh2pj8CCXTZDg6dRkM56Vr4c/G80KEeOD79m4Chk=;
        b=IOfByIDbI+s4ST5GQZq2osZjnj6ObfZHGWNrAiHqURr+IwCPk2hPkToUpB2kCqvkF2
         FStk7urZOuL5qqpm9u6Z9zeD2NzhzvFxguvEDH3LjoxewQQiwmeVTA4EljZRmR0TyMnH
         zbOsr2cWxIsfCZh+tb3AmZabx2c/H9JRLf31+sR0GsZuhrjhqkcjCL/LbBY/OFKz/73Z
         zqD7OT0J0LIE1kqU98eNr73QFZnECQDhhpFLIp9/puEYyGah8csMn1tvf+YHQmkqoymo
         od8iebOwq+MbavaEvmEAsscVnkrbMsDzId2xdYVtrKhHML9IL5oUTAHEXSmA8s1NNkbN
         Ej+w==
X-Gm-Message-State: AOAM5321DNCeoLkKC6hWpFZLqtg+vVycYTf/6FHC9VaxGbDERFoWIlGs
        tSRKgXkbadQweRPK/lAo/qM=
X-Google-Smtp-Source: ABdhPJwdoVWk2KvRLjlizdgQuLjgJYoPeqQBjF84thJOm8J/AfvG0marf3G3bA0dE8dyLNlnHyejkg==
X-Received: by 2002:a17:906:758:: with SMTP id z24mr99726ejb.3.1611244940260;
        Thu, 21 Jan 2021 08:02:20 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id zk10sm2419973ejb.10.2021.01.21.08.02.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jan 2021 08:02:19 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Hongbo Wang <hongbo.wang@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Po Liu <po.liu@nxp.com>, Yangbo Lu <yangbo.lu@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Eldar Gasanov <eldargasanov2@gmail.com>,
        Andrey L <al@b4comtech.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v6 net-next 00/10] tag_8021q for Ocelot switches
Date:   Thu, 21 Jan 2021 18:01:21 +0200
Message-Id: <20210121160131.2364236-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

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

Vladimir Oltean (10):
  net: dsa: tag_8021q: add helpers to deduce whether a VLAN ID is RX or
    TX VLAN
  net: mscc: ocelot: export VCAP structures to include/soc/mscc
  net: mscc: ocelot: store a namespaced VCAP filter ID
  net: mscc: ocelot: reapply bridge forwarding mask on bonding
    join/leave
  net: mscc: ocelot: don't use NPI tag prefix for the CPU port module
  net: dsa: document the existing switch tree notifiers and add a new
    one
  net: dsa: allow changing the tag protocol via the "tagging" device
    attribute
  net: dsa: felix: convert to the new .{set,del}_tag_protocol DSA API
  net: dsa: add a second tagger for Ocelot switches based on tag_8021q
  net: dsa: felix: perform switch setup for tag_8021q

 Documentation/ABI/testing/sysfs-class-net-dsa |  11 +-
 MAINTAINERS                                   |   1 +
 drivers/net/dsa/ocelot/Kconfig                |   2 +
 drivers/net/dsa/ocelot/felix.c                | 486 ++++++++++++++++--
 drivers/net/dsa/ocelot/felix.h                |   2 +
 drivers/net/dsa/ocelot/felix_vsc9959.c        |   1 +
 drivers/net/dsa/ocelot/seville_vsc9953.c      |   1 +
 drivers/net/ethernet/mscc/ocelot.c            |  93 ++--
 drivers/net/ethernet/mscc/ocelot_flower.c     |   7 +-
 drivers/net/ethernet/mscc/ocelot_net.c        |   1 +
 drivers/net/ethernet/mscc/ocelot_vcap.c       |  19 +-
 drivers/net/ethernet/mscc/ocelot_vcap.h       | 295 +----------
 drivers/net/ethernet/mscc/ocelot_vsc7514.c    |   2 -
 include/linux/dsa/8021q.h                     |  14 +
 include/net/dsa.h                             |  23 +
 include/soc/mscc/ocelot.h                     |   6 +-
 include/soc/mscc/ocelot_vcap.h                | 297 +++++++++++
 net/dsa/Kconfig                               |  21 +-
 net/dsa/Makefile                              |   1 +
 net/dsa/dsa.c                                 |  20 +
 net/dsa/dsa2.c                                | 126 ++++-
 net/dsa/dsa_priv.h                            |  18 +
 net/dsa/master.c                              |  26 +-
 net/dsa/port.c                                |  44 +-
 net/dsa/slave.c                               |  35 +-
 net/dsa/switch.c                              |  81 +++
 net/dsa/tag_8021q.c                           |  15 +-
 net/dsa/tag_ocelot_8021q.c                    |  68 +++
 28 files changed, 1295 insertions(+), 421 deletions(-)
 create mode 100644 net/dsa/tag_ocelot_8021q.c

-- 
2.25.1

