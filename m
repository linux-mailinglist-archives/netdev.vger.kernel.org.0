Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3CC342FED
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 23:36:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbhCTWf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Mar 2021 18:35:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbhCTWfV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Mar 2021 18:35:21 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7FE9C061574;
        Sat, 20 Mar 2021 15:35:20 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id k10so15306752ejg.0;
        Sat, 20 Mar 2021 15:35:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=56MFAA25ScjspCNXUgesPKP9J74UMp/NV1soUeZ2qzA=;
        b=Dub9neJlKkrqY40yvd7djwqjMc5CB0p/vR06C4zo/4a+dsVToVO3hJlUMjSMvMk1gA
         6swhR+nc1+ohZdhjP01QtmZ3e+RyU+AH3SfXYL44BA0ljwNN0BOJtafe1GVv5+sNOoA2
         BuObSQmUBhMyIY7AjXbutE5dvZxWYwMsRcgHWRjI8aF3d0bkUsvA9u2qeDnnMAinlo61
         jQkjPrLhAB11NSn4psuP6g0tZkSKbFuoPyYs5BlL/Yf5P1dct8Tc2E01BBs+UOODctKs
         9Ud6K0GDTrSo8lI6AUx9GShdNsslUKUvQ0JVn7XZxFUpDg7ly6Dt+FLKG4/7ls+YwCAS
         RxGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=56MFAA25ScjspCNXUgesPKP9J74UMp/NV1soUeZ2qzA=;
        b=sYUUfegUsh/URgDoptT4x2xsxrREyiJslNNBOqvhOVBfIvg7vQlepPgU1OiKR0K54b
         L+Yo/HFVz9kqHrs+ccYJV9RBI1BExMhO0pgYVbjRAsBNiq9ecXggpOx86+7X+2r3P44I
         Zk6KQSdUJ0BU60J6Wci5x3po7Q7MREUGjisglhuh977Iu4KlCgKXg/UzwWCnYASOMHF8
         qS1YFfIeq8KJgIdH44kB65VWQpBMmH7eauWTMboTgsOC3zCpR++kSZSCBzl50Ed/+sZk
         0GJ5AQiPt1KgYdCdqBs3TiNHTihsKYGboGiF719O5rDR3Os/6hNVVw/65pgyqkIa9LeA
         4Rig==
X-Gm-Message-State: AOAM5321E/emc4Q9/Oo+ztof2xBf1WSVPkLoBV+geZgd5UJbbky//hKs
        xgTJXFWrURcpntMpP5KyIqg=
X-Google-Smtp-Source: ABdhPJwdldMmqcKHRSR7afSL+pynmpegElbrYiqcCjoWWp8Dx+DQBY/q99jA12DGsC+5v+Eozvk/OA==
X-Received: by 2002:a17:906:6bd1:: with SMTP id t17mr11798865ejs.319.1616279719480;
        Sat, 20 Mar 2021 15:35:19 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id n2sm6090850ejl.1.2021.03.20.15.35.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Mar 2021 15:35:18 -0700 (PDT)
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
Subject: [PATCH v3 net-next 00/12] Better support for sandwiched LAGs with bridge and DSA
Date:   Sun, 21 Mar 2021 00:34:36 +0200
Message-Id: <20210320223448.2452869-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

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

Vladimir Oltean (12):
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
  net: ocelot: call ocelot_netdevice_bridge_join when joining a bridged
    LAG
  net: ocelot: replay switchdev events when joining bridge

 drivers/net/dsa/ocelot/felix.c         |   4 +-
 drivers/net/ethernet/mscc/ocelot.c     |  18 +--
 drivers/net/ethernet/mscc/ocelot_net.c | 208 +++++++++++++++++++++----
 include/linux/if_bridge.h              |  40 +++++
 include/net/switchdev.h                |   1 +
 include/soc/mscc/ocelot.h              |   6 +-
 net/bridge/br_fdb.c                    |  52 +++++++
 net/bridge/br_mdb.c                    |  84 ++++++++++
 net/bridge/br_stp.c                    |  27 ++++
 net/bridge/br_vlan.c                   |  71 +++++++++
 net/dsa/dsa_priv.h                     |   9 +-
 net/dsa/port.c                         | 203 ++++++++++++++++++------
 net/dsa/slave.c                        |  11 +-
 13 files changed, 631 insertions(+), 103 deletions(-)

-- 
2.25.1

