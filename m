Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C04C1E506B
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 23:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbgE0VZj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 17:25:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726718AbgE0VZj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 17:25:39 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38583C05BD1E
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 14:25:39 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id i17so2157631pli.13
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 14:25:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6kV8Dkezyb5UgWlLi2qsTU60tuPmZldK8CY3zGrToAM=;
        b=gGX5wNiQnovr3FoA6EC0i8yeBltT2y0mXyXIEusDrHNDzS/pH34I4Htn0Topac/caq
         Ua24S3xOFL5MZho74Ee5Q9xdBiV7gx7r56BVVm5LUNPCpXO+LtkbNZs8wnFjy44xRdQ8
         VNuO2e26SRfose2GPE/rlD3k/BH/oqkfNSRJs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6kV8Dkezyb5UgWlLi2qsTU60tuPmZldK8CY3zGrToAM=;
        b=GIMfnGgC93uUOFSCrhY2eXhaMpZ/mdgz216U73zqmZv3lMQdErF6LF4aADHfdlnMdf
         Sy/4OwTiGOii0V+29mZzU7TpQxlykturvyhbcwTgOvX8+uaR7tpcKA9GOx8Af3LTAECX
         pNjqUVKeE0QTbcKai2/oFIvPxklhsdowF77jXdWQvQljK+Qmut3zQ1UCA2O5nM5riL5Z
         fJPh391lWYmWoelBrAGwzwZ/wN8PAcHPpGYz2RpTKLGaYzgsGjuWpv8mDkxMGDOtbKFD
         76nVAlILPtQ0wAxDc9SWf1M6fi7Og76q+cqGRcoSbdQJmpT44EmxzTgzASxxZ3qojtO3
         RYsA==
X-Gm-Message-State: AOAM5325oXON9DmTVpppAgsGv6McA1UiyI3ukw0rgs7oPV0D13sYEHrr
        kfpCcjAYyoUT3GmC3ELWg6Dys8Kgg519Jko6E/3b1Pnqm75pCBwhIjeumvGyejBjPDTmHye3aL9
        f4FZrcoagA8XXh8IFgvwaiE5GF725JDraHDSWerW0sc0B4rjOYDy/oo2PKDdk7y0GGbfByixm
X-Google-Smtp-Source: ABdhPJz1fdBXEqRC7VyWfTZnVVwokiZ8z/VQ4M5B3wETmE0VHAf2k3/V/39U5LbHgmb0A3UHWqDZDQ==
X-Received: by 2002:a17:90a:bf08:: with SMTP id c8mr342156pjs.13.1590614737854;
        Wed, 27 May 2020 14:25:37 -0700 (PDT)
Received: from localhost.localdomain ([2600:8802:202:f600::ddf])
        by smtp.gmail.com with ESMTPSA id c4sm2770344pfb.130.2020.05.27.14.25.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 14:25:37 -0700 (PDT)
From:   Edwin Peer <edwin.peer@broadcom.com>
To:     netdev@vger.kernel.org
Cc:     Edwin Peer <edwin.peer@broadcom.com>, edumazet@google.com,
        linville@tuxdriver.com, shemminger@vyatta.com,
        mirq-linux@rere.qmqm.pl, jesse.brandeburg@intel.com,
        jchapman@katalix.com, david@weave.works, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, sridhar.samudrala@intel.com,
        jiri@mellanox.com, geoff@infradead.org, mokuno@sm.sony.co.jp,
        msink@permonline.ru, mporter@kernel.crashing.org,
        inaky.perez-gonzalez@intel.com, jwi@linux.ibm.com,
        kgraul@linux.ibm.com, ubraun@linux.ibm.com,
        grant.likely@secretlab.ca, hadi@cyberus.ca, dsahern@kernel.org,
        shrijeet@gmail.com, jon.mason@intel.com, dave.jiang@intel.com,
        saeedm@mellanox.com, hadarh@mellanox.com, ogerlitz@mellanox.com,
        allenbh@gmail.com, michael.chan@broadcom.com
Subject: [RFC PATCH net-next 00/11] Nested VLANs - decimate flags and add another
Date:   Wed, 27 May 2020 14:25:01 -0700
Message-Id: <20200527212512.17901-1-edwin.peer@broadcom.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series began life as a modest attempt to fix two issues pertaining
to VLANs nested inside Geneve tunnels and snowballed from there. The
first issue, addressed by a simple one-liner, is that GSO is not enabled
for upper VLAN devices on top of Geneve. The second issue, addressed by
the balance of the series, deals largely with MTU handling. VLAN devices
above L2 in L3 tunnels inherit the MTU of the underlying device. This
causes IP fragmentation because the inner L2 cannot be expanded within
the same maximum L3 size to accommodate the additional VLAN tag.

As a first attempt, a new flag was introduced to generalize what was
already being done for MACsec devices. This flag was unconditionally
set for all devices that have a size constrained L2, such as is the
case for Geneve and VXLAN tunnel devices. This doesn't quite do the
right thing, however, if the underlying device MTU happens to be
configured to a lower MTU than is supported. Thus, the approach was
further refined to set IFF_NO_VLAN_ROOM when changing MTU, based on
whether the underlying device L2 still has room for VLAN tags, but
stopping short of registering device notifiers to update upper device
MTU whenever a lower device changes. VLAN devices will thus do the
sensible thing if they are applied to an already configured device,
but will not dynamically update whenever the underlying device's MTU
is subsequently changed (this seemed a bridge too far).

Aggregate devices presented the next challenge. Transitively propagating
IFF_NO_VLAN_ROOM via bonds, teams and the like seemed similar in
principle to the handling of IFF_XMIT_DST_RELEASE (only the opposite),
but IFF_XMIT_DST_RELEASE_PERM evaded understanding. Ultimately this flag
failed to justify its existence, allowing the new flag to take its place
and avoid taking up the last bit in the enum.

Finally, an audit of the other net devices in the tree was conducted to
discover where else this new behavior may be appropriate. At this point
it was also discovered that GRE devices would happily allow VLANs to be
added even when L3 is being tunneled in L3, hence restricting VLANs to
ARPHRD_ETHER devices. Between ARPHRD_ETHER and IFF_NO_VLAN_ROOM, it now
seemed only a hop and a skip to eliminate NET_F_VLAN_CHALLENGED too, but
alas there are still a few holdouts that would appear to require more of
a moonshot to address.

Edwin Peer (11):
  net: geneve: enable vlan offloads
  net: do away with the IFF_XMIT_DST_RELEASE_PERM flag
  net: vlan: add IFF_NO_VLAN_ROOM to constrain MTU
  net: geneve: constrain upper VLAN MTU using IFF_NO_VLAN_ROOM
  net: vxlan: constrain upper VLAN MTU using IFF_NO_VLAN_ROOM
  net: l2tp_eth: constrain upper VLAN MTU using IFF_NO_VLAN_ROOM
  net: gre: constrain upper VLAN MTU using IFF_NO_VLAN_ROOM
  net: distribute IFF_NO_VLAN_ROOM into aggregate devs
  net: ntb_netdev: support VLAN using IFF_NO_VLAN_ROOM
  net: vlan: disallow non-Ethernet devices
  net: leverage IFF_NO_VLAN_ROOM to limit NETIF_F_VLAN_CHALLENGED

 Documentation/networking/netdev-features.rst  |   4 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c     |   3 +-
 drivers/net/bonding/bond_main.c               |  15 ++-
 drivers/net/ethernet/intel/e100.c             |  15 ++-
 .../net/ethernet/mellanox/mlxsw/switchx2.c    |  52 ++++++--
 drivers/net/ethernet/toshiba/ps3_gelic_net.c  |  12 +-
 drivers/net/ethernet/wiznet/w5100.c           |   6 +-
 drivers/net/ethernet/wiznet/w5300.c           |   6 +-
 drivers/net/ethernet/xilinx/ll_temac_main.c   |   1 -
 drivers/net/geneve.c                          |  17 ++-
 drivers/net/ifb.c                             |   4 +
 drivers/net/loopback.c                        |   1 -
 drivers/net/macsec.c                          |   6 +-
 drivers/net/net_failover.c                    |  31 +++--
 drivers/net/ntb_netdev.c                      |   8 +-
 drivers/net/rionet.c                          |   3 +
 drivers/net/sb1000.c                          |   1 +
 drivers/net/team/team.c                       |  16 +--
 drivers/net/vrf.c                             |   4 +-
 drivers/net/vxlan.c                           |  10 +-
 drivers/net/wimax/i2400m/netdev.c             |   5 +-
 drivers/s390/net/qeth_l2_main.c               |  12 +-
 include/linux/if_vlan.h                       |  48 ++++++++
 include/linux/netdevice.h                     |  12 +-
 net/8021q/vlan.c                              |   2 +-
 net/8021q/vlan_dev.c                          |   9 ++
 net/8021q/vlan_netlink.c                      |   2 +
 net/core/dev.c                                |   2 +-
 net/ipv4/ip_tunnel.c                          |   2 +
 net/ipv6/ip6_gre.c                            |   4 +-
 net/l2tp/l2tp_eth.c                           | 114 ++++++++++--------
 net/sched/sch_teql.c                          |   3 +
 32 files changed, 290 insertions(+), 140 deletions(-)

-- 
2.26.2

