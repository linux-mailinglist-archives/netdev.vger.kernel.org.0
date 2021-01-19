Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35AE12FC4B8
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 00:26:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730097AbhASXXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 18:23:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729379AbhASXIn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 18:08:43 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CB76C061573
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 15:08:01 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id gx5so11658831ejb.7
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 15:08:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wuZ280gUOvMNdAh/rEJKeK04tgXC+nSstpr3AfY6vMQ=;
        b=KIk/5j4qchP4ut+DaGxMliDp7uoeStJum/fu05n2z44mGPLIgkAe+j2V9Jeg6rrDXx
         DBvB9sesv8I/EjDvIlkGC71Ii4H4Nc986ud0OPVN8PQn4gaKLDKuQGEOE0BkMIuB72dD
         /p9DjzAwMSt78I7U4dyMLgqJ9vs6kpBOUISLrQ99oIUmhGpDNb/d7DohnsSE044BLUPv
         fgnMj5KHQ+HUgQ4cg/EDRFnakRcl/pB/AVLAK0ic35ZKFRlXrd6REK1KFvRMHdcuGQA7
         LT/if9FvfibRHVpUvrWfXjB96kDbbrjLvHl3fj+udiaG8HJIBnnFh/QZCA/Y5nxnMaD8
         BAbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wuZ280gUOvMNdAh/rEJKeK04tgXC+nSstpr3AfY6vMQ=;
        b=Iz/44j+CYk9r1LA5/aH1kIMZ8x2xKeSlDB5XHISv2kQAMRo2r+kf7FBx/w7PHKAi7w
         lkrVKJMkYmK4LesgvE7zKyRj59ACNib4yYXA6aSc0T03RgFyxzXvo3OuMtAe+Bw2P2BS
         Ik8HcvL4DyXlMjaeWywWPaZcNZQYraKdZ+LHgf/hNUS4QZB8AmxXwohwqF5bevQdcHzD
         a67t7/VI4Dtug3qeg6XlAHdJ3IFpwH+kfrYR0wI3rcai6lWbTYULyyxEcIxySrJ84jkC
         yDyF+hkGjsIQlr8fPgj2nk5HJps3j2A5ff7OkOnmY77E9gVkZOUl1RaSzQnXJn8Qgd7e
         Ynyw==
X-Gm-Message-State: AOAM533JFBemDBnqaVV4OemnKCumuT6QOP0rH2Fa6gxpkQ7cbHhZRmjj
        VvPzKOfumaVbpa7VpppCKjs=
X-Google-Smtp-Source: ABdhPJwFcrXO8/R1zWPHRIQdwjWSmVqkN7dqPxzSt2Il9EMzJFkdBg6f0De5EWHYJRDExKmCknOM3A==
X-Received: by 2002:a17:906:14ce:: with SMTP id y14mr4283974ejc.366.1611097679119;
        Tue, 19 Jan 2021 15:07:59 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id lh26sm94197ejb.119.2021.01.19.15.07.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 15:07:58 -0800 (PST)
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
        Andrey L <al@b4comtech.com>, UNGLinuxDriver@microchip.com
Subject: [PATCH v4 net-next 00/16] tag_8021q for Ocelot switches
Date:   Wed, 20 Jan 2021 01:07:33 +0200
Message-Id: <20210119230749.1178874-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

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

I determined that a Kconfig option would be a sufficiently good
configuration interface for selecting between the existing NPI-based
tagged and the tag_8021q software-defined tagger. However, this is one
of the things that is up for debate today.

Changes in v2:
Posted the entire rework necessary for PTP support using tag_8021q.c.
Added a larger audience to the series.

Changes in v3:
Use a per-port bool is_dsa_8021q_cpu instead of a single dsa_8021q_cpu
variable, to be compatible with future work where there may be
potentially multiple tag_8021q CPU ports in a LAG.

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

Vladimir Oltean (16):
  net: dsa: tag_8021q: add helpers to deduce whether a VLAN ID is RX or
    TX VLAN
  net: mscc: ocelot: export VCAP structures to include/soc/mscc
  net: mscc: ocelot: store a namespaced VCAP filter ID
  net: mscc: ocelot: reapply bridge forwarding mask on bonding
    join/leave
  net: mscc: ocelot: don't use NPI tag prefix for the CPU port module
  net: dsa: allow changing the tag protocol via the "tagging" device
    attribute
  net: dsa: felix: add new VLAN-based tagger
  net: mscc: ocelot: stop returning IRQ_NONE in ocelot_xtr_irq_handler
  net: mscc: ocelot: only drain extraction queue on error
  net: mscc: ocelot: better error handling in ocelot_xtr_irq_handler
  net: mscc: ocelot: use DIV_ROUND_UP helper in ocelot_port_inject_frame
  net: mscc: ocelot: refactor ocelot_port_inject_frame out of
    ocelot_port_xmit
  net: mscc: ocelot: export struct ocelot_frame_info
  net: mscc: ocelot: refactor ocelot_xtr_irq_handler into
    ocelot_xtr_poll
  net: dsa: felix: setup MMIO filtering rules for PTP when using
    tag_8021q
  net: dsa: tag_ocelot_8021q: add support for PTP timestamping

 MAINTAINERS                                |   1 +
 drivers/net/dsa/ocelot/Kconfig             |   2 +
 drivers/net/dsa/ocelot/felix.c             | 677 +++++++++++++++++++--
 drivers/net/dsa/ocelot/felix.h             |  15 +
 drivers/net/dsa/ocelot/felix_vsc9959.c     |   2 +
 drivers/net/dsa/ocelot/seville_vsc9953.c   |   1 +
 drivers/net/ethernet/mscc/ocelot.c         | 345 ++++++++++-
 drivers/net/ethernet/mscc/ocelot.h         |   9 -
 drivers/net/ethernet/mscc/ocelot_flower.c  |   7 +-
 drivers/net/ethernet/mscc/ocelot_net.c     |  82 +--
 drivers/net/ethernet/mscc/ocelot_vcap.c    |  19 +-
 drivers/net/ethernet/mscc/ocelot_vcap.h    | 295 +--------
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 170 +-----
 include/linux/dsa/8021q.h                  |  14 +
 include/net/dsa.h                          |  19 +
 include/soc/mscc/ocelot.h                  |  26 +-
 include/soc/mscc/ocelot_vcap.h             | 297 +++++++++
 net/dsa/Kconfig                            |  21 +-
 net/dsa/Makefile                           |   1 +
 net/dsa/dsa.c                              |  20 +
 net/dsa/dsa2.c                             |  84 ++-
 net/dsa/dsa_priv.h                         |  18 +
 net/dsa/master.c                           |  26 +-
 net/dsa/port.c                             |  10 +-
 net/dsa/slave.c                            |  35 +-
 net/dsa/switch.c                           |  96 +++
 net/dsa/tag_8021q.c                        |  15 +-
 net/dsa/tag_ocelot_8021q.c                 |  93 +++
 28 files changed, 1766 insertions(+), 634 deletions(-)
 create mode 100644 net/dsa/tag_ocelot_8021q.c

-- 
2.25.1

