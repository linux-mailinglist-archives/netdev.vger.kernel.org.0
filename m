Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA493410CD
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 00:19:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232084AbhCRXSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 19:18:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230316AbhCRXSp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 19:18:45 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C76A6C06174A;
        Thu, 18 Mar 2021 16:18:44 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id va9so6625495ejb.12;
        Thu, 18 Mar 2021 16:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SuKOHlGmcBoigQzmxPpTy8Qz36YBu11mC4kz5Z2H8fQ=;
        b=P8raW/3YkxcLQW2d56w2Nbot5t73fJHsy+VzRq7m1IKtdPKP0erem8Qyrq2eeqasf/
         /MMDolOzqNqgvWNTq0cumDBkQsRh0zO22uvYjzR11mBMGrRaKmAIitkc+BYv6sypRuNh
         CHzO6Km3CiM3teNawAmGKl6URFRfFFlvEKY8MBfaGg26Kay+kSi85p4r+EEsACMoVbnR
         3E2lpcolAnCb8TDOCu3tUnMQ3B2tqaU6rffTRXgraMOoOpq/39BSXTJO2mYfVrOqNmwp
         e7Dej0Sd6qz31qjMfpTX/vyL114YkKSE/6mHJM79uBd3PWCP/HKWvYIOqddb0I7T7fV3
         t/pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SuKOHlGmcBoigQzmxPpTy8Qz36YBu11mC4kz5Z2H8fQ=;
        b=kivNfZY3QCRvcWAwBM6WfBW1hQ2WBWQiuhk17wwm6WPCEkC7c4PEKG/nQWt4u9KpJz
         zhWdORpI0SOAxaDfmS8m0hUydRUkBvFqRhqyavqkqYxTQksEhP+cMaq36O/eZ9LmDgA6
         SUWPonhj3vDKsKgZ2UvXjJ1MClpunE75XlOGL4sQbX271wslr/c+N7YMK+TymoH0N8Ez
         PKKIB7qTTddMFNHp2EdeCLfah1pqj+/nE4vVIrRlir64r91i9qHoUBaiSoSYItTB5Hr0
         Y8FdvYhYTFxDRLaHI1J5neTSojIfQJiUeT9LRRYiGnWTS6ChMu5Ikzt/Z4WyD37LNph1
         pl2w==
X-Gm-Message-State: AOAM5310Xizwq7wrpIMepNiziI+E2m6AJnhiVwPh6+83a4WXfJ6eVGk8
        BxUxJuP8P805t1xOAb3wzEE=
X-Google-Smtp-Source: ABdhPJwAIrM+hK+GbjyQq6+tVneUBkpZuxSyq5ZPRNs1JzxBRdRNE8NM0hEFb+Cx1seY6WZlISIwYQ==
X-Received: by 2002:a17:907:2bd7:: with SMTP id gv23mr1097037ejc.351.1616109523368;
        Thu, 18 Mar 2021 16:18:43 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id bx24sm2801131ejc.88.2021.03.18.16.18.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 16:18:43 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [RFC PATCH v2 net-next 00/16] Better support for sandwiched LAGs with bridge and DSA
Date:   Fri, 19 Mar 2021 01:18:13 +0200
Message-Id: <20210318231829.3892920-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This series has two objectives:
- To make LAG uppers on top of DSA ports work regardless of which order
  we link interfaces to their masters (first make the port join the LAG,
  then the LAG join the bridge, or the other way around).
- To make DSA ports support non-offloaded LAG interfaces properly.

There was a design decision to be made in patches 2-4 on whether we
should adopt the "push" model, where the driver just calls:

  switchdev_bridge_port_offloaded(brport_dev,
                                  &atomic_notifier_block,
                                  &blocking_notifier_block,
                                  extack);

and the bridge just replays the entire collection of switchdev port
attributes and objects that it has, in some predefined order and with
some predefined error handling logic;


or the "pull" model, where the driver, apart from calling:

  switchdev_bridge_port_offloaded(brport_dev, extack);

has the task of "dumpster diving" (as Tobias puts it) through the bridge
attributes and objects by itself, by calling:

  - br_vlan_replay
  - br_fdb_replay
  - br_mdb_replay
  - br_vlan_enabled
  - br_port_flag_is_set
  - br_port_get_stp_state
  - br_multicast_router
  - br_get_ageing_time

(not necessarily all of them, and not necessarily in this order, and
with driver-defined error handling).

Even though I'm not in love myself with the "pull" model, I chose it
because there is a fundamental trick with replaying switchdev events
like this:

ip link add br0 type bridge
ip link add bond0 type bond
ip link set bond0 master br0
ip link set swp0 master bond0 <- this will replay the objects once for
                                 the bond0 bridge port, and the swp0
                                 switchdev port will process them
ip link set swp1 master bond0 <- this will replay the objects again for
                                 the bond0 bridge port, and the swp1
                                 switchdev port will see them, but swp0
                                 will see them for the second time now

Basically I believe that it is implementation defined whether the driver
wants to error out on switchdev objects seen twice on a port, and the
bridge should not enforce a certain model for that. For example, for FDB
entries added to a bonding interface, the underling switchdev driver
might have an abstraction for just that: an FDB entry pointing towards a
logical (as opposed to physical) port. So when the second port joins the
bridge, it doesn't realy need to replay FDB entries, since there is
already at least one hardware port which has been receiving those
events, and the FDB entries don't need to be added a second time to the
same logical port.
In the other corner, we have the drivers that handle switchdev port
attributes on a LAG as individual switchdev port attributes on physical
ports (example: VLAN filtering). In fact, the switchdev_handle_port_attr_set
helper facilitates this: it is a fan-out from a single orig_dev towards
multiple lowers that pass the check_cb().
But that's the point: switchdev_handle_port_attr_set is just a helper
which the driver _opts_ to use. The bridge can't enforce the "push"
model, because that would assume that all drivers handle port attributes
in the same way, which is probably false.

For this reason, I preferred to go with the "pull" mode for this patch
set. Just to see how bad it is for other switchdev drivers to copy-paste
this logic, I added the pull support to ocelot too, and I think it's
pretty manageable.

This patch set is RFC because it is minimally tested, and I would like
to get some feedback/agreement regarding the design decisions taken,
before I spend any more time on this.

There are also some things I probably broke, but I couldn't figure any
better. For example, I can't seem to figure out if mlxsw does the right
thing when joining a bonding interface that is already a bridge port.
I think it probably doesn't, so in that case, the placement I found for
the switchdev_bridge_port_offload() probably needs some adjustment when
there exists a LAG upper.

If possible, I would like the maintainers of the switchdev drivers to
tell me if this change introduces any regressions to how packets are
flooded (actually not flooded) in software by the bridge between two
ports belonging to the same ASIC ID.

I should mention that this patch series is written on top of Tobias'
series:
https://patchwork.kernel.org/project/netdevbpf/cover/20210318192540.895062-1-tobias@waldekranz.com/
which should get applied soon.

Vladimir Oltean (16):
  net: dsa: call dsa_port_bridge_join when joining a LAG that is already
    in a bridge
  net: dsa: pass extack to dsa_port_{bridge,lag}_join
  net: dsa: inherit the actual bridge port flags at join time
  net: dsa: sync up with bridge port's STP state when joining
  net: dsa: sync up VLAN filtering state when joining the bridge
  net: dsa: sync multicast router state when joining the bridge
  net: dsa: sync ageing time when joining the bridge
  net: dsa: replay port and host-joined mdb entries when joining the
    bridge
  net: dsa: replay port and local fdb entries when joining the bridge
  net: dsa: replay VLANs installed on port when joining the bridge
  net: ocelot: support multiple bridges
  net: ocelot: call ocelot_netdevice_bridge_join when joining a bridged
    LAG
  net: ocelot: replay switchdev events when joining bridge
  net: dsa: don't set skb->offload_fwd_mark when not offloading the
    bridge
  net: dsa: return -EOPNOTSUPP when driver does not implement
    .port_lag_join
  net: bridge: switchdev: let drivers inform which bridge ports are
    offloaded

 drivers/net/dsa/ocelot/felix.c                |   4 +-
 .../ethernet/freescale/dpaa2/dpaa2-switch.c   |   4 +-
 .../marvell/prestera/prestera_switchdev.c     |   7 +
 .../mellanox/mlxsw/spectrum_switchdev.c       |   4 +-
 drivers/net/ethernet/mscc/ocelot.c            |  90 ++++----
 drivers/net/ethernet/mscc/ocelot_net.c        | 210 +++++++++++++++---
 drivers/net/ethernet/rocker/rocker_ofdpa.c    |   8 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      |   7 +-
 drivers/net/ethernet/ti/cpsw_new.c            |   6 +-
 include/linux/if_bridge.h                     |  56 +++++
 include/net/switchdev.h                       |   1 +
 include/soc/mscc/ocelot.h                     |  13 +-
 net/bridge/br_fdb.c                           |  52 +++++
 net/bridge/br_if.c                            |  11 +-
 net/bridge/br_mdb.c                           |  84 +++++++
 net/bridge/br_private.h                       |   8 +-
 net/bridge/br_stp.c                           |  27 +++
 net/bridge/br_switchdev.c                     |  94 +++++++-
 net/bridge/br_vlan.c                          |  71 ++++++
 net/dsa/dsa_priv.h                            |  23 +-
 net/dsa/port.c                                | 201 +++++++++++++----
 net/dsa/slave.c                               |  11 +-
 net/dsa/switch.c                              |   4 +-
 net/dsa/tag_brcm.c                            |   2 +-
 net/dsa/tag_dsa.c                             |  15 +-
 net/dsa/tag_hellcreek.c                       |   2 +-
 net/dsa/tag_ksz.c                             |   2 +-
 net/dsa/tag_lan9303.c                         |   3 +-
 net/dsa/tag_mtk.c                             |   2 +-
 net/dsa/tag_ocelot.c                          |   2 +-
 net/dsa/tag_ocelot_8021q.c                    |   2 +-
 net/dsa/tag_rtl4_a.c                          |   2 +-
 net/dsa/tag_sja1105.c                         |   4 +-
 net/dsa/tag_xrs700x.c                         |   2 +-
 34 files changed, 845 insertions(+), 189 deletions(-)

-- 
2.25.1

