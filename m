Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC7D6D0F97
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 22:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbjC3UBI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 16:01:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjC3UBH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 16:01:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64B957692;
        Thu, 30 Mar 2023 13:01:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0BCE0B82A13;
        Thu, 30 Mar 2023 20:01:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 937F8C433D2;
        Thu, 30 Mar 2023 20:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680206461;
        bh=PYKd29ps6N67LeZvsmVnYBhuTVwdyeGRiChtNIXSeHQ=;
        h=From:To:Cc:Subject:Date:From;
        b=S+oibyQxxpYvubGfh5KQbWiJbB7VA5yBttxCH59NKsKves+SC2lGFGg17rlXQf7Vh
         Xh93zVN5FL1eRz6Jx4YxiG0tkmedKnOHLr+TvhkXWItwWI1Ey5J3KNecbcfsrsxWtC
         q/taQ2IbFZNzScPZugnF6wXfbgN0R7AnNHR3RA3190SNQHnDZBFVayQV+djU65dgpb
         3Z+4memLcUYdMhbEMtiiqqQ3qgFhBcQ8j4o9AYqWJQj4BeEjTFHPkqh0b+Yhq2tmj6
         W7WTLVbq+YC/GrNQiDd+DREY52IcS571oOYAA87JLx9ohutHX1c4klumVBDQy9xKf+
         T/wvEHb93OQ1Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pabeni@redhat.com
Subject: [PULL] Networking for v6.3-rc5
Date:   Thu, 30 Mar 2023 13:01:00 -0700
Message-Id: <20230330200100.78996-1-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

Still quite a few bugs from this release. PR is a bit smaller
because major subtrees went into the previous one. Or maybe
people took spring break off?

The following changes since commit 608f1b136616ff09d717776922c9ea9e9f9f3947:

  Merge tag 'net-6.3-rc4' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2023-03-24 08:48:12 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.3-rc5

for you to fetch changes up to 924531326e2dd4ceabe7240f2b55a88e7d894ec2:

  net: ethernet: mtk_eth_soc: add missing ppe cache flush when deleting a flow (2023-03-30 11:44:59 -0700)

----------------------------------------------------------------
Including fixes from CAN and WPAN.

Current release - regressions:

 - phy: micrel: correct KSZ9131RNX EEE capabilities and advertisement

Current release - new code bugs:

 - eth: wangxun: fix vector length of interrupt cause

 - vsock/loopback: consistently protect the packet queue with
   sk_buff_head.lock

 - virtio/vsock: fix header length on skb merging

 - wpan: ca8210: fix unsigned mac_len comparison with zero

Previous releases - regressions:

 - eth: stmmac: don't reject VLANs when IFF_PROMISC is set

 - eth: smsc911x: avoid PHY being resumed when interface is not up

 - eth: mtk_eth_soc: fix tx throughput regression with direct 1G links

 - eth: bnx2x: use the right build_skb() helper after core rework

 - wwan: iosm: fix 7560 modem crash on use on unsupported channel

Previous releases - always broken:

 - eth: sfc: don't overwrite offload features at NIC reset

 - eth: r8169: fix RTL8168H and RTL8107E rx crc error

 - can: j1939: prevent deadlock by moving j1939_sk_errqueue()

 - virt: vmxnet3: use GRO callback when UPT is enabled

 - virt: xen: don't do grant copy across page boundary

 - phy: dp83869: fix default value for tx-/rx-internal-delay

 - dsa: ksz8: fix multiple issues with ksz8_fdb_dump

 - eth: mvpp2: fix classification/RSS of VLAN and fragmented packets

 - eth: mtk_eth_soc: fix flow block refcounting logic

Misc:

 - constify fwnode pointers in SFP handling

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Ahmad Fatoum (1):
      net: dsa: realtek: fix out-of-bounds access

Alex Elder (1):
      net: ipa: compute DMA pool size properly

Arseniy Krasnov (3):
      virtio/vsock: fix header length on skb merging
      virtio/vsock: WARN_ONCE() for invalid state of socket
      test/vsock: new skbuff appending test

Brett Creeley (1):
      ice: Fix ice_cfg_rdma_fltr() to only update relevant fields

ChunHao Lin (1):
      r8169: fix RTL8168H and RTL8107E rx crc error

David S. Miller (2):
      Merge branch 'ksz-fixes'
      Merge branch 'constify-sfp-phy-nodes'

Dongliang Mu (1):
      net: ieee802154: remove an unnecessary null pointer check

Faicker Mo (1):
      net/net_failover: fix txq exceeding warning

Felix Fietkau (4):
      net: ethernet: mtk_eth_soc: fix tx throughput regression with direct 1G links
      net: ethernet: mtk_eth_soc: fix flow block refcounting logic
      net: ethernet: mtk_eth_soc: fix L2 offloading with DSA untag offload
      net: ethernet: mtk_eth_soc: add missing ppe cache flush when deleting a flow

Harshit Mogalapalli (1):
      ca8210: Fix unsigned mac_len comparison with zero in ca8210_skb_tx()

Ivan Orlov (1):
      can: bcm: bcm_tx_setup(): fix KMSAN uninit-value in vfs_write

Jakob Koschel (1):
      ice: fix invalid check for empty list in ice_sched_assoc_vsi_to_agg()

Jakub Kicinski (5):
      Merge tag 'linux-can-fixes-for-6.3-20230327' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can
      bnx2x: use the right build_skb() helper
      Merge tag 'ieee802154-for-net-2023-03-29' of git://git.kernel.org/pub/scm/linux/kernel/git/wpan/wpan
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      Merge branch 'bnxt_en-3-bug-fixes'

Jesse Brandeburg (1):
      ice: fix W=1 headers mismatch

Jiawen Wu (1):
      net: wangxun: Fix vector length of interrupt cause

Josua Mayer (1):
      net: phy: dp83869: fix default value for tx-/rx-internal-delay

Juergen Gross (3):
      xen/netback: don't do grant copy across page boundary
      xen/netback: remove not needed test in xenvif_tx_build_gops()
      xen/netback: use same error messages for same errors

Junfeng Guo (1):
      ice: add profile conflict check for AVF FDIR

Kalesh AP (2):
      bnxt_en: Fix reporting of test result in ethtool selftest
      bnxt_en: Fix typo in PCI id to device description string mapping

Lukas Bulwahn (1):
      MAINTAINERS: remove the linux-nfc@lists.01.org list

M Chetan Kumar (1):
      net: wwan: iosm: fixes 7560 modem crash

Michael Chan (1):
      bnxt_en: Add missing 200G link speed reporting

Oleksij Rempel (8):
      net: dsa: microchip: ksz8: fix ksz8_fdb_dump()
      net: dsa: microchip: ksz8: fix ksz8_fdb_dump() to extract all 1024 entries
      net: dsa: microchip: ksz8: fix offset for the timestamp filed
      net: dsa: microchip: ksz8: ksz8_fdb_dump: avoid extracting ghost entry from empty dynamic MAC table.
      net: dsa: microchip: ksz8863_smi: fix bulk access
      net: dsa: microchip: ksz8: fix MDB configuration with non-zero VID
      net: phy: micrel: correct KSZ9131RNX EEE capabilities and advertisement
      can: j1939: prevent deadlock by moving j1939_sk_errqueue()

Paolo Abeni (3):
      Merge branch 'net-mvpp2-rss-fixes'
      Merge branch 'xen-netback-fix-issue-introduced-recently'
      Merge branch 'fix-header-length-on-skb-merging'

Radoslaw Tyl (1):
      i40e: fix registers dump after run ethtool adapter self test

Ronak Doshi (1):
      vmxnet3: use gro callback when UPT is enabled

Russell King (Oracle) (4):
      net: sfp: make sfp_bus_find_fwnode() take a const fwnode
      net: sfp: constify sfp-bus internal fwnode uses
      net: phy: constify fwnode_get_phy_node() fwnode argument
      net: mvneta: fix potential double-frees in mvneta_txq_sw_deinit()

Sean Anderson (1):
      net: fman: Add myself as a reviewer

SongJingyi (1):
      ptp_qoriq: fix memory leak in probe()

Stefano Garzarella (1):
      vsock/loopback: use only sk_buff_head.lock to protect the packet queue

Steffen Bätz (1):
      net: dsa: mv88e6xxx: Enable IGMP snooping on user ports only

Sven Auhagen (3):
      net: mvpp2: classifier flow fix fragmentation flags
      net: mvpp2: parser fix QinQ
      net: mvpp2: parser fix PPPoE

Vladimir Oltean (2):
      net: stmmac: don't reject VLANs when IFF_PROMISC is set
      net: dsa: sync unicast and multicast addresses for VLAN filters too

Wolfram Sang (1):
      smsc911x: avoid PHY being resumed when interface is not up

Álvaro Fernández Rojas (1):
      net: dsa: b53: mmap: add phy ops

Íñigo Huguet (1):
      sfc: ef10: don't overwrite offload features at NIC reset

 MAINTAINERS                                        |   7 +-
 drivers/net/dsa/b53/b53_mmap.c                     |  14 +++
 drivers/net/dsa/microchip/ksz8795.c                |  11 +-
 drivers/net/dsa/microchip/ksz8863_smi.c            |   9 --
 drivers/net/dsa/microchip/ksz_common.c             |  12 +-
 drivers/net/dsa/mv88e6xxx/chip.c                   |   9 +-
 drivers/net/dsa/realtek/realtek-mdio.c             |   5 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c    |  16 ++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   8 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |   1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |   3 +
 drivers/net/ethernet/intel/i40e/i40e_diag.c        |  11 +-
 drivers/net/ethernet/intel/i40e/i40e_diag.h        |   2 +-
 drivers/net/ethernet/intel/ice/ice_sched.c         |   8 +-
 drivers/net/ethernet/intel/ice/ice_switch.c        |  26 ++++-
 drivers/net/ethernet/intel/ice/ice_txrx.c          |   2 +-
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c      |   1 +
 drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c |  73 +++++++++++++
 drivers/net/ethernet/marvell/mvneta.c              |   2 +
 drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c     |  30 +++--
 drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c     |  86 ++++++---------
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |   8 +-
 drivers/net/ethernet/mediatek/mtk_ppe.c            |   6 +-
 drivers/net/ethernet/mediatek/mtk_ppe_offload.c    |   3 +-
 drivers/net/ethernet/realtek/r8169_phy_config.c    |   3 +
 drivers/net/ethernet/sfc/ef10.c                    |  38 +++++--
 drivers/net/ethernet/sfc/efx.c                     |  17 ++-
 drivers/net/ethernet/smsc/smsc911x.c               |   7 +-
 drivers/net/ethernet/stmicro/stmmac/common.h       |   1 -
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c  |  61 +----------
 drivers/net/ethernet/wangxun/libwx/wx_type.h       |   2 +-
 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c      |   2 +-
 drivers/net/ethernet/wangxun/txgbe/txgbe_main.c    |   3 +-
 drivers/net/ieee802154/ca8210.c                    |   3 +-
 drivers/net/ipa/gsi_trans.c                        |   2 +-
 drivers/net/net_failover.c                         |   8 +-
 drivers/net/phy/dp83869.c                          |   6 +-
 drivers/net/phy/micrel.c                           |   1 +
 drivers/net/phy/phy_device.c                       |   2 +-
 drivers/net/phy/sfp-bus.c                          |   6 +-
 drivers/net/vmxnet3/vmxnet3_drv.c                  |   4 +-
 drivers/net/wwan/iosm/iosm_ipc_imem.c              |   7 ++
 drivers/net/xen-netback/common.h                   |   2 +-
 drivers/net/xen-netback/netback.c                  |  35 ++++--
 drivers/ptp/ptp_qoriq.c                            |   2 +-
 include/linux/phy.h                                |   2 +-
 include/linux/sfp.h                                |   5 +-
 net/can/bcm.c                                      |  16 ++-
 net/can/j1939/transport.c                          |   8 +-
 net/dsa/slave.c                                    | 121 ++++++++++++++++++++-
 net/ieee802154/nl802154.c                          |   3 +-
 net/vmw_vsock/virtio_transport_common.c            |   9 +-
 net/vmw_vsock/vsock_loopback.c                     |  10 +-
 tools/testing/vsock/vsock_test.c                   |  90 +++++++++++++++
 54 files changed, 567 insertions(+), 262 deletions(-)
