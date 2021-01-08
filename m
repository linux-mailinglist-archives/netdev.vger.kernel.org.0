Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A87BD2EF5D3
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 17:33:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728272AbhAHQdA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 11:33:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727132AbhAHQc7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 11:32:59 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0699C061381
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 08:32:18 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id g24so11745181edw.9
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 08:32:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5MgND3cId1SAkKL0isxHlG5pO0Pk3LM6RCLvWXGl0NM=;
        b=e0GKqUtHlfpge75yGsK+TOtk2A8wWe4ri3v/sehu2ld0HCe8t5Pt/BWZrwsJaR1MWA
         idWCZZ27f1BhDCHVW/LqIT/k2/bx+juY0swdI8A6tFdBe9b6lQF/Q/ZJl3LbVuauVBpg
         lywA0ru/NXbx9fDvb0/mTfSsWgsWlF2sHiFtI1lUF5VKMmx8RNWvWm7/T+oNzglUokKn
         PHR1jAOaS1P500eIwXwryS5ukuWgsIlVql4wJ018HwJ9ZU4RxCbfFoIGAYusoxH37ZAm
         eGtHCVCtWqvmQeoomrEJdByoS5Ib9e0eXsUIVxQZJuLrlKzgm3l8JXQO298hrBPo3uqx
         r26w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5MgND3cId1SAkKL0isxHlG5pO0Pk3LM6RCLvWXGl0NM=;
        b=asu7Eh/IkvILLtUcKEjB/ZZtpMmynvdjwrUz1VdXaRAukLCbY0/qLWie5EJYxEgZQ4
         jhK5ZEiInUzUwH1HO2Iav94ZocXNRsB1tNzjZ0jHCuiad/Xu9b6Y126t2IYKi3OEM2wF
         7J7QggNf1zti3EV4RxwTzTwZOLSCLtsyqjuJUh4syWSbuCmzjjuF1lblHFrQVZWJV2R6
         x7otM36zQ3eJLnOdPmYmbR7WhsKLpp5dEJu06lcZ5mpljvjmYDugbJRx7YsKzm5NI8RT
         cVvIpHYQtIl3U4ovEnMkoos7PBP6faGq1TGFNgl98NkabzfObJ+d0PaabsAwWOKxIiPa
         zRYg==
X-Gm-Message-State: AOAM5319ls0WvX3CKb+3EERR2iuCBpnQGbEU0XyfPlCcoVPy6VrI0Uuw
        rSxKxChIakov8d7QjmUg/a4=
X-Google-Smtp-Source: ABdhPJwN3JPxjSNg2fn7OjiRZf8w9h6oemODhjgWN9h1ranirnv55P1Ro6xb29y96kYp4W9Q8W1PXw==
X-Received: by 2002:a50:a6c2:: with SMTP id f2mr5828553edc.7.1610123537458;
        Fri, 08 Jan 2021 08:32:17 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id x6sm3957737edl.67.2021.01.08.08.32.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 08:32:16 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <edumazet@google.com>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Arnd Bergmann <arnd@arndb.de>, Taehee Yoo <ap420073@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, Florian Westphal <fw@strlen.de>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH v5 net-next 00/16] Make .ndo_get_stats64 sleepable
Date:   Fri,  8 Jan 2021 18:31:43 +0200
Message-Id: <20210108163159.358043-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

There is a desire to standardize the counters that have previously been
reported through ethtool statistics into something that can be more
uniformly queried from user space. The ndo_get_stats64 are a good
candidate to keep standardized counters, as well as add new ones (like
RMON MIBs) but unfortunately, as things stand, migration will not be
smooth sailing if the ndo_get_stats64 does not offer the same calling
context as ethtool does. Namely, currently ndo_get_stats64 assumes
atomic context, and this series would like to change that.

The reason why sleeping while retrieving counters would be desirable in
the first place is that if we have hardware that needs to be accessed
through a slow bus like SPI, or through a firmware. Today we cannot do
that directly in .ndo_get_stats64, so we would have to poll counters
periodically and return a cached (not up to date) copy in the atomic NDO
callback. This is undesirable on both ends: more work than strictly
needed is being done, and the end result is also worse (not guaranteed
to be up to date). Also, retrieving counters from the hardware rather
than software counters incremented by the driver is more compatible with
the concept of interfaces with offload for L2 or L3 forwarding, where
the CPU otherwise never has a chance to keep accurate counters for most
of the traffic.

I could not test most of the drivers that were modified, so the only
guarantee is that make allyesconfig passes.

Changes in v5:
- Changed bonding and net_failover to use rcu_read_lock().
- Actually propagating errors from bond_get_stats now.

Changes in v4:
- Propagated errors from ndo_get_stats64.

Changes in v3:
- Resolved some memory leak issues in the bonding patch 10/12.

Changes in v2:
- Addressed the recursion issues in .ndo_get_stats64 from bonding and
  net_failover.
- Renamed netdev_lists_lock to netif_lists_lock
- Stopped taking netif_lists_lock from drivers as much as possible.

Vladimir Oltean (16):
  net: mark dev_base_lock for deprecation
  net: introduce a mutex for the netns interface lists
  net: procfs: hold netif_lists_lock when retrieving device statistics
  net: sysfs: don't hold dev_base_lock while retrieving device
    statistics
  s390/appldata_net_sum: hold the netdev lists lock when retrieving
    device statistics
  parisc/led: hold the netdev lists lock when retrieving device
    statistics
  net: remove return value from dev_get_stats
  net: allow ndo_get_stats64 to return an int error code
  scsi: fcoe: propagate errors from dev_get_stats
  net: openvswitch: propagate errors from dev_get_stats
  net: propagate errors from dev_get_stats
  net: terminate errors from dev_get_stats
  net: openvswitch: ensure dev_get_stats can sleep
  net: net_failover: ensure .ndo_get_stats64 can sleep
  net: bonding: ensure .ndo_get_stats64 can sleep
  net: mark ndo_get_stats64 as being able to sleep

 Documentation/networking/netdevices.rst       |   8 +-
 Documentation/networking/statistics.rst       |   9 +-
 arch/s390/appldata/appldata_net_sum.c         |  41 +++---
 drivers/infiniband/hw/hfi1/vnic_main.c        |   6 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c     |   9 +-
 .../infiniband/ulp/opa_vnic/opa_vnic_netdev.c |   9 +-
 drivers/leds/trigger/ledtrig-netdev.c         |  16 ++-
 drivers/net/bonding/bond_main.c               | 131 ++++++++++--------
 drivers/net/dummy.c                           |   6 +-
 drivers/net/ethernet/alacritech/slicoss.c     |   6 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c  |   8 +-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c      |   6 +-
 drivers/net/ethernet/apm/xgene-v2/main.c      |   6 +-
 .../ethernet/apm/xgene/xgene_enet_ethtool.c   |   9 +-
 .../net/ethernet/apm/xgene/xgene_enet_main.c  |   7 +-
 drivers/net/ethernet/atheros/alx/main.c       |   6 +-
 drivers/net/ethernet/broadcom/b44.c           |   6 +-
 drivers/net/ethernet/broadcom/bcmsysport.c    |   6 +-
 drivers/net/ethernet/broadcom/bnx2.c          |   5 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |   6 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c |   4 +-
 drivers/net/ethernet/broadcom/tg3.c           |   8 +-
 drivers/net/ethernet/brocade/bna/bnad.c       |   4 +-
 drivers/net/ethernet/calxeda/xgmac.c          |   4 +-
 .../net/ethernet/cavium/liquidio/lio_main.c   |   6 +-
 .../ethernet/cavium/liquidio/lio_vf_main.c    |   6 +-
 .../net/ethernet/cavium/liquidio/lio_vf_rep.c |   8 +-
 .../net/ethernet/cavium/thunder/nicvf_main.c  |   5 +-
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   |   8 +-
 drivers/net/ethernet/cisco/enic/enic_main.c   |   8 +-
 drivers/net/ethernet/cortina/gemini.c         |   6 +-
 drivers/net/ethernet/ec_bhf.c                 |   4 +-
 drivers/net/ethernet/emulex/benet/be_main.c   |   6 +-
 .../net/ethernet/freescale/dpaa/dpaa_eth.c    |   6 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |   6 +-
 drivers/net/ethernet/google/gve/gve_main.c    |   4 +-
 drivers/net/ethernet/hisilicon/hns/hns_enet.c |   6 +-
 .../net/ethernet/hisilicon/hns/hns_ethtool.c  |  56 ++++----
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   |   8 +-
 .../net/ethernet/huawei/hinic/hinic_main.c    |   6 +-
 drivers/net/ethernet/ibm/ehea/ehea_main.c     |   6 +-
 drivers/net/ethernet/intel/e1000e/e1000.h     |   4 +-
 drivers/net/ethernet/intel/e1000e/ethtool.c   |   9 +-
 drivers/net/ethernet/intel/e1000e/netdev.c    |   6 +-
 .../net/ethernet/intel/fm10k/fm10k_netdev.c   |   6 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c   |  10 +-
 drivers/net/ethernet/intel/ice/ice_main.c     |   6 +-
 drivers/net/ethernet/intel/igb/igb_main.c     |  10 +-
 drivers/net/ethernet/intel/igc/igc_main.c     |   6 +-
 .../net/ethernet/intel/ixgbe/ixgbe_ethtool.c  |  14 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |   6 +-
 drivers/net/ethernet/intel/ixgbevf/ethtool.c  |  14 +-
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c |   6 +-
 drivers/net/ethernet/marvell/mvneta.c         |   4 +-
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |   4 +-
 .../marvell/octeontx2/nic/otx2_common.c       |   6 +-
 .../marvell/octeontx2/nic/otx2_common.h       |   4 +-
 .../ethernet/marvell/prestera/prestera_main.c |   6 +-
 drivers/net/ethernet/marvell/sky2.c           |   6 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c   |   6 +-
 drivers/net/ethernet/mediatek/mtk_star_emac.c |   6 +-
 .../net/ethernet/mellanox/mlx4/en_netdev.c    |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |   4 +-
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |   4 +-
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib.c |   4 +-
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib.h |   2 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |   4 +-
 .../net/ethernet/mellanox/mlxsw/switchx2.c    |   4 +-
 drivers/net/ethernet/microchip/lan743x_main.c |   6 +-
 drivers/net/ethernet/mscc/ocelot_net.c        |   6 +-
 .../net/ethernet/myricom/myri10ge/myri10ge.c  |  12 +-
 .../net/ethernet/neterion/vxge/vxge-main.c    |   4 +-
 .../ethernet/netronome/nfp/nfp_net_common.c   |   6 +-
 .../net/ethernet/netronome/nfp/nfp_net_repr.c |   6 +-
 drivers/net/ethernet/nvidia/forcedeth.c       |   4 +-
 .../net/ethernet/pensando/ionic/ionic_lif.c   |   6 +-
 .../net/ethernet/pensando/ionic/ionic_lif.h   |   4 +-
 .../ethernet/qlogic/netxen/netxen_nic_main.c  |  10 +-
 drivers/net/ethernet/qlogic/qede/qede_main.c  |   6 +-
 drivers/net/ethernet/qualcomm/emac/emac.c     |   6 +-
 .../net/ethernet/qualcomm/rmnet/rmnet_vnd.c   |   8 +-
 drivers/net/ethernet/realtek/8139too.c        |   8 +-
 drivers/net/ethernet/realtek/r8169_main.c     |   4 +-
 .../net/ethernet/samsung/sxgbe/sxgbe_main.c   |   6 +-
 drivers/net/ethernet/sfc/efx_common.c         |   4 +-
 drivers/net/ethernet/sfc/efx_common.h         |   2 +-
 drivers/net/ethernet/sfc/falcon/efx.c         |   6 +-
 drivers/net/ethernet/socionext/sni_ave.c      |   6 +-
 drivers/net/ethernet/sun/niu.c                |   6 +-
 .../net/ethernet/synopsys/dwc-xlgmac-net.c    |   6 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      |   6 +-
 drivers/net/ethernet/ti/netcp_core.c          |   4 +-
 drivers/net/ethernet/via/via-rhine.c          |   8 +-
 drivers/net/fjes/fjes_main.c                  |   6 +-
 drivers/net/hyperv/netvsc_drv.c               |   6 +-
 drivers/net/ifb.c                             |   5 +-
 drivers/net/ipvlan/ipvlan_main.c              |   6 +-
 drivers/net/loopback.c                        |   6 +-
 drivers/net/macsec.c                          |   8 +-
 drivers/net/macvlan.c                         |   6 +-
 drivers/net/mhi_net.c                         |   6 +-
 drivers/net/net_failover.c                    |  96 +++++++++----
 drivers/net/netdevsim/netdev.c                |   4 +-
 drivers/net/nlmon.c                           |   4 +-
 drivers/net/ppp/ppp_generic.c                 |   4 +-
 drivers/net/slip/slip.c                       |   4 +-
 drivers/net/team/team.c                       |   4 +-
 drivers/net/thunderbolt.c                     |   6 +-
 drivers/net/tun.c                             |   4 +-
 drivers/net/veth.c                            |   6 +-
 drivers/net/virtio_net.c                      |   6 +-
 drivers/net/vmxnet3/vmxnet3_ethtool.c         |   4 +-
 drivers/net/vmxnet3/vmxnet3_int.h             |   4 +-
 drivers/net/vrf.c                             |   6 +-
 drivers/net/vsockmon.c                        |   4 +-
 drivers/net/xen-netfront.c                    |   6 +-
 drivers/parisc/led.c                          |  42 +++---
 drivers/s390/net/qeth_core.h                  |   2 +-
 drivers/s390/net/qeth_core_main.c             |   4 +-
 drivers/scsi/fcoe/fcoe_sysfs.c                |   9 +-
 drivers/scsi/fcoe/fcoe_transport.c            |  28 ++--
 drivers/scsi/libfc/fc_rport.c                 |   5 +-
 drivers/staging/fsl-dpaa2/ethsw/ethsw.c       |   8 +-
 drivers/staging/netlogic/xlr_net.c            |   4 +-
 drivers/usb/gadget/function/rndis.c           |  47 +++----
 include/linux/netdevice.h                     |  22 ++-
 include/net/bonding.h                         |  54 ++++++++
 include/net/net_namespace.h                   |   6 +
 include/scsi/fcoe_sysfs.h                     |  12 +-
 include/scsi/libfc.h                          |   2 +-
 include/scsi/libfcoe.h                        |   8 +-
 net/8021q/vlan_dev.c                          |   6 +-
 net/8021q/vlanproc.c                          |  20 +--
 net/core/dev.c                                |  79 +++++++----
 net/core/net-procfs.c                         |  62 +++++----
 net/core/net-sysfs.c                          |  12 +-
 net/core/rtnetlink.c                          |  15 +-
 net/l2tp/l2tp_eth.c                           |   6 +-
 net/mac80211/iface.c                          |   4 +-
 net/openvswitch/datapath.c                    |  63 +++++----
 net/openvswitch/vport.c                       |  35 +++--
 net/openvswitch/vport.h                       |   2 +-
 net/sched/sch_teql.c                          |   6 +-
 144 files changed, 1009 insertions(+), 563 deletions(-)

-- 
2.25.1

