Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4ED12F0234
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 18:29:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726001AbhAIR2D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 12:28:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725926AbhAIR2C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jan 2021 12:28:02 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBCA8C061786
        for <netdev@vger.kernel.org>; Sat,  9 Jan 2021 09:27:21 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id q22so18900935eja.2
        for <netdev@vger.kernel.org>; Sat, 09 Jan 2021 09:27:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j7VlAAIiu2fF/8RLmkctxKGGYKfaz9nh0Z8R4Tc0CTs=;
        b=tA0lfO1tv7lMCBY2YJYb5+VnNAZQCq40wOGJ/IACb2kHCcN3GlnVyT+ZG4YFKZ90Ps
         f/wH+Z0JJhKlC1b+yjXV1sbzar43b21sHNWimEfeBo7z6S2/X86QJJgF0SKDOSd6Pygd
         /a9UZhDwPyMrrl/CGrXVkjqAKCi1I6MDIYOEaS+kd6+dlwhfeArGOvL9i/d7VPtWktEv
         FGyeIdePcl8m1yuawXSvwZm55S8iDpj/NjDD8xJDAmLmKLLFOLH8MKgg6SkU7T+acKD4
         FtuvQmCgcKhVR4rXV6fHODmUgIagiWaYfAqckPVqReGEf5vYCA60FZf/OQAI/EdkJqF0
         9Frw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j7VlAAIiu2fF/8RLmkctxKGGYKfaz9nh0Z8R4Tc0CTs=;
        b=kCr98RdNN+var5m+fjD6MAtCAaVzv6eL/g7cFSCwULzHzsBEDzNxQ4f8b9CTp4etTC
         5hRQ00IQF8f/VtQrEL02QWbkrFjd7BdE/l+dTo8PdWUaUyecL0mRiiZOjhf5vZBj58pq
         s3Cef0BGUqEVYqnEYNwpX6YaRla1/xbSH1CZWvRX9M7R58JBnwKKkJomshDnwEueu4Jr
         h27tOJGEg6WzYT1nY5oULcJG4kxjFWlQuFbb48JT5rGzVbBXH+Y3gJssu24mHkpk/hiC
         NES44G4k7TMl9d1Cln7LYDCL6KGW6OR3fyE8HyXGmuaMv/luzhBHHAA56mkt8ERXIS/u
         ABSw==
X-Gm-Message-State: AOAM531sjpK8aPGMT7obyuS5Vf/BVCAu2fOqNIVu6oTcGMq1Y3XZZOSn
        xMaFW++J0nFVzo8mPYTrrXY=
X-Google-Smtp-Source: ABdhPJzRGjzkQbqwSPlhrcWdU4tWQRl9VGcyHTpY675g43yCOmMXPiNXo6UvCM5WZ2uL9iHOEV8hSA==
X-Received: by 2002:a17:906:29c2:: with SMTP id y2mr6258235eje.518.1610213240477;
        Sat, 09 Jan 2021 09:27:20 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id h16sm4776714eji.110.2021.01.09.09.27.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Jan 2021 09:27:19 -0800 (PST)
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
Subject: [PATCH v6 net-next 00/15] Make .ndo_get_stats64 sleepable
Date:   Sat,  9 Jan 2021 19:26:09 +0200
Message-Id: <20210109172624.2028156-1-olteanv@gmail.com>
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

Changes in v6:
- Rebase on top of Jakub's patch 9f9d41f03bb0 ("docs: net: fix
  documentation on .ndo_get_stats").
- s/break/return -ENOMEM/ in bond_get_slaves.
- Fixed rtnetlink incorrectly returning 0 in rtnl_fill_ifinfo on
  nla_put_failure and causing "ip a" to not show any interfaces.
- Squashed the patch to propagate errors with the one to terminate them.
- Removed the unused "int err" in __bond_release_one from patch 08 and
  added it in the patch it belongs to.

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
*** SUBJECT HERE ***

*** BLURB HERE ***

Vladimir Oltean (15):
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
  net: catch errors from dev_get_stats
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
 drivers/net/bonding/bond_main.c               | 135 ++++++++++--------
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
 drivers/usb/gadget/function/rndis.c           |  47 +++---
 include/linux/netdevice.h                     |  22 ++-
 include/net/bonding.h                         |  53 +++++++
 include/net/net_namespace.h                   |   6 +
 include/scsi/fcoe_sysfs.h                     |  12 +-
 include/scsi/libfc.h                          |   2 +-
 include/scsi/libfcoe.h                        |   8 +-
 net/8021q/vlan_dev.c                          |   6 +-
 net/8021q/vlanproc.c                          |  20 +--
 net/core/dev.c                                |  79 ++++++----
 net/core/net-procfs.c                         |  62 ++++----
 net/core/net-sysfs.c                          |  12 +-
 net/core/rtnetlink.c                          |  23 ++-
 net/l2tp/l2tp_eth.c                           |   6 +-
 net/mac80211/iface.c                          |   4 +-
 net/openvswitch/datapath.c                    |  63 ++++----
 net/openvswitch/vport.c                       |  35 +++--
 net/openvswitch/vport.h                       |   2 +-
 net/sched/sch_teql.c                          |   6 +-
 144 files changed, 1016 insertions(+), 567 deletions(-)

-- 
2.25.1

