Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 151AB345341
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 00:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbhCVXwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 19:52:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230401AbhCVXwD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 19:52:03 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86823C061574;
        Mon, 22 Mar 2021 16:52:02 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id x21so21431025eds.4;
        Mon, 22 Mar 2021 16:52:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J0lerce/czsjf5vh/tq+DrEp1Se5SpioCye7avD0uJE=;
        b=Q8HWP57izxflfR5CmyqQX0QY6AUuyvWzC4qikphPjWwvI4gL7x9mUnKRuPtQwP1F1r
         gGAPAc6JWaPEirkwX7UYEx0V+wSZwwU2b5u7BmsEp1PcjW/IQ7ch9Z783ZeH+m2nL+ML
         aa3C8UAzk50sJSaCK6trmsarjI97cgrAElmRZM2hr/9lWb1+XFT301YumfAc4E6e6Vbc
         27kWwFDGInlTkwYS+LgRRK425y84oWb1FpodOkgsg0GjzbxRi+XVW1lqCTRSHA3Siaaz
         3WIzlc94Kv7D4Ks50ueRb24ZwXU9MsrRCu7UQDsLcumLnHr8LE5165706L1MkF7vSWuE
         8iqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J0lerce/czsjf5vh/tq+DrEp1Se5SpioCye7avD0uJE=;
        b=Wpeo2kmpdVbravYWWmQJlO4e6x7dglCOlbog4h96ylqphi8hYQ2vYyD5RXD2s4CDCt
         1bGBcq399HQFzYwcgK2Cl6kSP48Zl7RbbBsXdCV1DrVivOyg70S+zA4kv7fT7iKfVGU6
         lwY0q4Pl3et2YmJUX+NBAhhlwnIeEVa0hFIUtcZYx3UrhdXJn5zYs9i7Sl5E/9eLA2EJ
         aaIWy96G5apZRwr4fue8eY62G0IfrGA62baO+cSTtdCvK5wub12am98HZuI3UvvX64eY
         xFPg9sJ0qyAze1UM/kAscJDG6RagDmF/yP7vifd9YDoUrtuU/UnYDTC+hQnBw6MKsgn/
         SGXA==
X-Gm-Message-State: AOAM532XUbZdJMOaSBNNdUvfIC/vmTUIPN+MF2O9i1KiG55JBMM8NgUy
        z/avX9krvc2IBuKUeXchMR8rOZYQbO4=
X-Google-Smtp-Source: ABdhPJxZC7vKgRmYGxmBLqQOIiHM/SU31Up48TGWH4hxtw7SXplIYSC1vaZtgFeSYPu/A3gxY5nbGA==
X-Received: by 2002:a05:6402:26ce:: with SMTP id x14mr1930219edd.359.1616457121147;
        Mon, 22 Mar 2021 16:52:01 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id q16sm12436933edv.61.2021.03.22.16.51.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 16:52:00 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Ivan Vecera <ivecera@redhat.com>,
        linux-omap@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v4 net-next 00/11] Better support for sandwiched LAGs with bridge and DSA
Date:   Tue, 23 Mar 2021 01:51:41 +0200
Message-Id: <20210322235152.268695-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Changes in v4:
- Added missing EXPORT_SYMBOL_GPL
- Using READ_ONCE(fdb->dst)
- Split patches into (a) adding the bridge helpers (b) making DSA use them
- br_mdb_replay went back to the v1 approach where it allocated memory
  in atomic context
- Created a br_switchdev_mdb_populate which reduces some of the code
  duplication
- Fixed the error message in dsa_port_clear_brport_flags
- Replaced "dsa_port_vlan_filtering(dp, br, extack)" with
  "dsa_port_vlan_filtering(dp, br_vlan_enabled(br), extack)" (duh)
- Added review tags (sorry if I missed any)

The objective of this series is to make LAG uppers on top of switchdev
ports work regardless of which order we link interfaces to their masters
(first make the port join the LAG, then the LAG join the bridge, or the
other way around).

There was a design decision to be made in patches 2-4 on whether we
should adopt the "push" model (which attempts to solve the problem
centrally, in the bridge layer) where the driver just calls:

  switchdev_bridge_port_offloaded(brport_dev,
                                  &atomic_notifier_block,
                                  &blocking_notifier_block,
                                  extack);

and the bridge just replays the entire collection of switchdev port
attributes and objects that it has, in some predefined order and with
some predefined error handling logic;


or the "pull" model (which attempts to solve the problem by giving the
driver the rope to hang itself), where the driver, apart from calling:

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

Vladimir Oltean (11):
  net: bridge: add helper for retrieving the current bridge port STP
    state
  net: bridge: add helper to retrieve the current ageing time
  net: bridge: add helper to replay port and host-joined mdb entries
  net: bridge: add helper to replay port and local fdb entries
  net: bridge: add helper to replay VLANs installed on port
  net: dsa: call dsa_port_bridge_join when joining a LAG that is already
    in a bridge
  net: dsa: pass extack to dsa_port_{bridge,lag}_join
  net: dsa: inherit the actual bridge port flags at join time
  net: dsa: sync up switchdev objects and port attributes when joining
    the bridge
  net: ocelot: call ocelot_netdevice_bridge_join when joining a bridged
    LAG
  net: ocelot: replay switchdev events when joining bridge

 drivers/net/dsa/ocelot/felix.c         |   4 +-
 drivers/net/ethernet/mscc/Kconfig      |   3 +-
 drivers/net/ethernet/mscc/ocelot.c     |  18 +--
 drivers/net/ethernet/mscc/ocelot_net.c | 208 +++++++++++++++++++++----
 include/linux/if_bridge.h              |  40 +++++
 include/net/switchdev.h                |   1 +
 include/soc/mscc/ocelot.h              |   6 +-
 net/bridge/br_fdb.c                    |  50 ++++++
 net/bridge/br_mdb.c                    | 148 ++++++++++++++++--
 net/bridge/br_stp.c                    |  27 ++++
 net/bridge/br_vlan.c                   |  73 +++++++++
 net/dsa/dsa_priv.h                     |   9 +-
 net/dsa/port.c                         | 197 +++++++++++++++++------
 net/dsa/slave.c                        |  11 +-
 14 files changed, 675 insertions(+), 120 deletions(-)

-- 
2.25.1

