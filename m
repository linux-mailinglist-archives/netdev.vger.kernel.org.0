Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE14A22D51B
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 07:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbgGYFMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 01:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726273AbgGYFMK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jul 2020 01:12:10 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4AB2C0619D3;
        Fri, 24 Jul 2020 22:12:09 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 20F5612786F1D;
        Fri, 24 Jul 2020 21:55:22 -0700 (PDT)
Date:   Fri, 24 Jul 2020 22:12:04 -0700 (PDT)
Message-Id: <20200724.221204.1658413840252419526.davem@davemloft.net>
To:     torvalds@linux-foundation.org
CC:     akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 24 Jul 2020 21:55:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


1) Fix RCU locaking in iwlwifi, from Johannes Berg.

2) mt76 can access uninitialized NAPI struct, from Felix Fietkau.

3) Fix race in updating pause settings in bnxt_en, from Vasundhara Volam.

4) Propagate error return properly during unbind failures in ax88172a,
   from George Kennedy.

5) Fix memleak in adf7242_probe, from Liu Jian.

6) smc_drv_probe() can leak, from Wang Hai.

7) Don't muck with the carrier state if register_netdevice() fails in
   the bonding driver, from Taehee Yoo.

8) Fix memleak in dpaa_eth_probe, from Liu Jian.

9) Need to check skb_put_padto() return value in hsr_fill_tag(), from
   Murali Karicheri.

10) Don't lose ionic RSS hash settings across FW update, from Shannon
    Nelson.

11) Fix clobbered SKB control block in act_ct, from Wen Xu.

12) Missing newlink in "tx_timeout" sysfs output, from Xiongfeng Wang.

13) IS_UDPLITE cleanup a long time ago, incorrectly handled transformations
    involving UDPLITE_RECV_CC.  From Miaohe Lin.

14) Unbalanced locking in netdevsim, from Taehee Yoo.

15) Suppress false-positive error messages in qed driver, from
    Alexander Lobakin.

16) Out of bounds read in ax25_connect and ax25_sendmsg, from Peilin Ye.

17) Missing SKB release in cxgb4's uld_send(), from Navid Emamdoost.

18) Uninitialized value in geneve_changelink(), from Cong Wang.

19) Fix deadlock in xen-netfront, from Andera Righi.

19) flush_backlog() frees skbs with IRQs disabled, so should use
    dev_kfree_skb_irq() instead of kfree_skb().  From Subash Abhinov
    Kasiviswanathan.

Please pull, thanks a lot!

The following changes since commit 1df0d8960499e58963fd6c8ac75e544f2b417b29:

  Merge tag 'libnvdimm-fix-v5.8-rc5' of git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm (2020-07-10 21:23:10 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net 

for you to fetch changes up to 8754e1379e7089516a449821f88e1fe1ebbae5e1:

  drivers/net/wan: lapb: Corrected the usage of skb_cow (2020-07-24 20:17:42 -0700)

----------------------------------------------------------------
Alessio Bonfiglio (1):
      iwlwifi: Make some Killer Wireless-AC 1550 cards work again

Alexander A. Klimov (1):
      net: ieee802154: adf7242: Replace HTTP links with HTTPS ones

Alexander Lobakin (2):
      qed: suppress "don't support RoCE & iWARP" flooding on HW init
      qed: suppress false-positives interrupt error messages on HW init

Alexandre Belloni (1):
      net: macb: use phy_interface_mode_is_rgmii everywhere

Andrea Righi (1):
      xen-netfront: fix potential deadlock in xennet_remove()

Bixuan Cui (1):
      net: neterion: vxge: reduce stack usage in VXGE_COMPLETE_VPATH_TX

Christophe JAILLET (1):
      hippi: Fix a size used in a 'pci_free_consistent()' in an error handling path

Claudiu Manoil (1):
      enetc: Remove the mdio bus on PF probe bailout

Cong Wang (3):
      bonding: check return value of register_netdevice() in bond_newlink()
      geneve: fix an uninitialized value in geneve_changelink()
      qrtr: orphan socket in qrtr_release()

Dan Carpenter (1):
      AX.25: Prevent integer overflows in connect and sendmsg

David Howells (1):
      rxrpc: Fix sendmsg() returning EPIPE due to recvmsg() returning ENODATA

David S. Miller (13):
      Merge branch 'bnxt_en-fixes'
      Merge tag 'wireless-drivers-2020-07-13' of git://git.kernel.org/.../kvalo/wireless-drivers
      Merge branch 'bcmgenet-WAKE_FILTER'
      Merge branch 'net-smc-fixes'
      Merge tag 'ieee802154-for-davem-2020-07-20' of git://git.kernel.org/.../sschmidt/wpan
      Merge branch 'smc-fixes'
      Merge branch 'ionic-locking-and-filter-fixes'
      Merge branch 'udp-Fix-reuseport-selection-with-connected-sockets'
      Merge branch 'hns3-fixes'
      Merge branch 'qed-suppress-irrelevant-error-messages-on-HW-init'
      Merge branch 'sctp-shrink-stream-outq-in-the-right-place'
      Merge git://git.kernel.org/.../pablo/nf
      Merge tag 'wireless-drivers-2020-07-24' of git://git.kernel.org/.../kvalo/wireless-drivers

Doug Berger (3):
      net: bcmgenet: test MPD_EN when resuming
      net: bcmgenet: test RBUF_ACPI_EN when resuming
      net: bcmgenet: restore HFB filters on resume

Egor Pomozov (1):
      net: atlantic: fix PTP on AQC10X

Felix Fietkau (2):
      mt76: mt76x02: do not access uninitialized NAPI structs
      mt76: mt7615: fix EEPROM buffer size

Florian Westphal (1):
      netfilter: nf_tables: fix nat hook table deletion

Geert Uytterhoeven (1):
      usb: hso: Fix debug compile warning on sparc32

George Kennedy (1):
      ax88172a: fix ax88172a_unbind() failures

Guillaume Nault (1):
      Documentation: bareudp: update iproute2 sample commands

Hauke Mehrtens (1):
      ath10k: Fix NULL pointer dereference in AHB device probe

Helmut Grohne (1):
      net: dsa: microchip: call phy_remove_link_mode during probe

Herbert Xu (1):
      flow_offload: Move rhashtable inclusion to the source file

Huang Guobin (1):
      net: ag71xx: add missed clk_disable_unprepare in error path of probe

Ioana Ciornei (1):
      dpaa2-eth: check fsl_mc_get_endpoint for IS_ERR_OR_NULL()

Jian Shen (1):
      net: hns3: fix return value error when query MAC link status fail

Jiri Slaby (1):
      iwlwifi: fix crash in iwl_dbg_tlv_alloc_trigger

Johannes Berg (1):
      iwlwifi: mvm: don't call iwl_mvm_free_inactive_queue() under RCU

Kalle Valo (1):
      Merge tag 'mt76-for-kvalo-2020-06-07' of https://github.com/nbd168/wireless

Karsten Graul (12):
      net/smc: handle unexpected response types for confirm link
      net/smc: clear link during SMC client link down processing
      net/smc: fix link lookup for new rdma connections
      net/smc: protect smc ib device initialization
      net/smc: drop out-of-flow llc response messages
      net/smc: move add link processing for new device into llc layer
      net/smc: fix handling of delete link requests
      net/smc: do not call dma sync for unmapped memory
      net/smc: remove freed buffer from list
      net/smc: fix restoring of fallback changes
      net/smc: put slot when connection is killed
      net/smc: fix dmb buffer shortage

Kuniyuki Iwashima (2):
      udp: Copy has_conns in reuseport_grow().
      udp: Improve load balancing for SO_REUSEPORT.

Laurence Oberman (1):
      qed: Disable "MFW indication via attention" SPAM every 5 minutes

Liu Jian (3):
      ieee802154: fix one possible memleak in adf7242_probe
      dpaa_eth: Fix one possible memleak in dpaa_eth_probe
      mlxsw: destroy workqueue when trap_register in mlxsw_emad_init

Lorenzo Bianconi (5):
      mt76: add missing lock configuring coverage class
      mt76: mt7615: fix lmac queue debugsfs entry
      mt76: mt7615: fix hw queue mapping
      mt76: overwrite qid for non-bufferable mgmt frames
      mt76: mt7663u: fix memory leaks in mt7663u_probe

Mark O'Donovan (1):
      ath9k: Fix regression with Atheros 9271

Maxim Kochetkov (1):
      gianfar: Use random MAC address when none is given

Miaohe Lin (1):
      net: udp: Fix wrong clean up for IS_UDPLITE macro

Michael Chan (1):
      bnxt_en: Fix completion ring sizing with TPA enabled.

Min Li (1):
      docs: ptp.rst: add support for Renesas (IDT) ClockMatrix

Murali Karicheri (4):
      net: hsr: fix incorrect lsdu size in the tag of HSR frames for small frames
      net: hsr: validate address B before copying to skb
      net: hsr: check for return value of skb_put_padto()
      net: ethernet: ti: add NETIF_F_HW_TC hw feature flag for taprio offload

Navid Emamdoost (2):
      nfc: s3fwrn5: add missing release on skb in s3fwrn5_recv_frame
      cxgb4: add missing release on skb in uld_send()

Nikita Danilov (1):
      net: atlantic: disable PTP on AQC111, AQC112

Paolo Pisati (3):
      selftests: fib_nexthop_multiprefix: fix cleanup() netns deletion
      selftests: net: ip_defrag: modprobe missing nf_defrag_ipv6 support
      selftest: txtimestamp: fix net ns entry logic

Peilin Ye (2):
      AX.25: Fix out-of-bounds read in ax25_connect()
      AX.25: Prevent out-of-bounds read in ax25_sendmsg()

Randy Dunlap (1):
      rhashtable: drop duplicated word in <linux/rhashtable.h>

Russell King (2):
      net: dsa: mv88e6xxx: fix in-band AN link establishment
      arm64: dts: clearfog-gt-8k: fix switch link configuration

Sergey Organov (2):
      net: fec: fix hardware time stamping by external devices
      net: dp83640: fix SIOCSHWTSTAMP to update the struct with actual configuration

Shannon Nelson (5):
      ionic: use offset for ethtool regs data
      ionic: fix up filter locks and debug msgs
      ionic: update filter id after replay
      ionic: keep rss hash after fw update
      ionic: use mutex to protect queue operations

Stefano Garzarella (1):
      vsock/virtio: annotate 'the_virtio_vsock' RCU pointer

Subash Abhinov Kasiviswanathan (1):
      dev: Defer free of skbs in flush_backlog

Taehee Yoo (2):
      bonding: check error value of register_netdevice() immediately
      netdevsim: fix unbalaced locking in nsim_create()

Tung Nguyen (1):
      tipc: allow to build NACK message in link timeout function

Vadim Pasternak (1):
      mlxsw: core: Fix wrong SFP EEPROM reading for upper pages 1-3

Vasundhara Volam (2):
      bnxt_en: Fix race when modifying pause settings.
      bnxt_en: Init ethtool link settings after reading updated PHY configuration.

Vinay Kumar Yadav (2):
      crypto/chtls: fix tls alert messages corrupted by tls data
      crypto/chtls: correct net_device reference count

Wang Hai (3):
      net: smc91x: Fix possible memory leak in smc_drv_probe()
      nfc: nci: add missed destroy_workqueue in nci_register_device
      net: ethernet: ave: Fix error returns in ave_init

Wei Yongjun (1):
      ip6_gre: fix null-ptr-deref in ip6gre_init_net()

Weilong Chen (1):
      rtnetlink: Fix memory(net_device) leak when ->newlink fails

Xie He (2):
      drivers/net/wan/x25_asy: Fix to make it work
      drivers/net/wan: lapb: Corrected the usage of skb_cow

Xin Long (2):
      sctp: shrink stream outq only when new outcnt < old outcnt
      sctp: shrink stream outq when fails to do addstream reconf

Xiongfeng Wang (1):
      net-sysfs: add a newline when printing 'tx_timeout' by sysfs

Yoshihiro Shimoda (1):
      net: ethernet: ravb: exit if re-initialization fails in tx timeout

Yuchung Cheng (1):
      tcp: allow at most one TLP probe per flight

Yunsheng Lin (3):
      net: hns3: fix for not unmapping TX buffer correctly
      net: hns3: fix for not calculating TX BD send size correctly
      net: hns3: fix error handling for desc filling

Zhang Changzhong (2):
      net: bcmgenet: fix error returns in bcmgenet_probe()
      net: bcmgenet: add missed clk_disable_unprepare in bcmgenet_probe

guodeqing (1):
      ipvs: fix the connection sync failed in some cases

wenxu (1):
      net/sched: act_ct: fix restore the qdisc_skb_cb after defrag

 Documentation/driver-api/ptp.rst                           |  12 +++++++
 Documentation/networking/bareudp.rst                       |  19 +++++++----
 arch/arm64/boot/dts/marvell/armada-8040-clearfog-gt-8k.dts |   5 +--
 drivers/crypto/chelsio/chtls/chtls_cm.c                    |   2 +-
 drivers/crypto/chelsio/chtls/chtls_io.c                    |   7 ++--
 drivers/net/bonding/bond_main.c                            |  10 ++++--
 drivers/net/bonding/bond_netlink.c                         |   3 +-
 drivers/net/dsa/microchip/ksz9477.c                        |  42 +++++++++++++-----------
 drivers/net/dsa/microchip/ksz_common.c                     |   2 --
 drivers/net/dsa/microchip/ksz_common.h                     |   2 --
 drivers/net/dsa/mv88e6xxx/chip.c                           |  22 +++++++++++--
 drivers/net/dsa/mv88e6xxx/chip.h                           |   1 +
 drivers/net/ethernet/aquantia/atlantic/aq_hw.h             |   1 +
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c            |   9 ++++++
 drivers/net/ethernet/aquantia/atlantic/aq_nic.h            |   2 ++
 drivers/net/ethernet/aquantia/atlantic/aq_phy.c            |  29 +++++++++++++++--
 drivers/net/ethernet/aquantia/atlantic/aq_phy.h            |   8 +++--
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c  |  26 ++++++++++++++-
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.h  |  10 +++---
 drivers/net/ethernet/atheros/ag71xx.c                      |   3 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                  |  22 +++++++++----
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c          |   5 ++-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c             | 144 +++++++++++++++++++++++++++++++++++++---------------------------------------------
 drivers/net/ethernet/broadcom/genet/bcmgenet.h             |   1 -
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c         |  22 +++++++++----
 drivers/net/ethernet/cadence/macb_main.c                   |   2 +-
 drivers/net/ethernet/chelsio/cxgb4/sge.c                   |   1 +
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c             |   2 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c           |   2 +-
 drivers/net/ethernet/freescale/enetc/enetc_pf.c            |   1 +
 drivers/net/ethernet/freescale/fec.h                       |   1 +
 drivers/net/ethernet/freescale/fec_main.c                  |  23 +++++++++----
 drivers/net/ethernet/freescale/fec_ptp.c                   |  12 +++++++
 drivers/net/ethernet/freescale/gianfar.c                   |   6 +++-
 drivers/net/ethernet/hisilicon/hns3/hnae3.h                |   1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c            |  24 +++++++-------
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h            |   2 --
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  49 +++++++++++++---------------
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   3 ++
 drivers/net/ethernet/mellanox/mlxsw/core.c                 |   3 +-
 drivers/net/ethernet/mellanox/mlxsw/core_env.c             |  48 ++++++++++++++++++----------
 drivers/net/ethernet/neterion/vxge/vxge-main.c             |   2 +-
 drivers/net/ethernet/pensando/ionic/ionic_ethtool.c        |   7 ++--
 drivers/net/ethernet/pensando/ionic/ionic_lif.c            |  50 ++++++++++++++---------------
 drivers/net/ethernet/pensando/ionic/ionic_lif.h            |   8 +----
 drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c      |  29 +++++++++++++++++
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c           |   6 ----
 drivers/net/ethernet/qlogic/qed/qed_cxt.c                  |   4 +--
 drivers/net/ethernet/qlogic/qed/qed_dev.c                  |   2 +-
 drivers/net/ethernet/qlogic/qed/qed_int.c                  |  53 +++++++++++++++++-------------
 drivers/net/ethernet/qlogic/qed/qed_int.h                  |   4 +--
 drivers/net/ethernet/renesas/ravb_main.c                   |  26 +++++++++++++--
 drivers/net/ethernet/smsc/smc91x.c                         |   4 +--
 drivers/net/ethernet/socionext/sni_ave.c                   |   2 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c                   |   3 +-
 drivers/net/geneve.c                                       |   2 +-
 drivers/net/hippi/rrunner.c                                |   2 +-
 drivers/net/ieee802154/adf7242.c                           |   6 ++--
 drivers/net/netdevsim/netdev.c                             |   4 +--
 drivers/net/phy/dp83640.c                                  |   4 +++
 drivers/net/usb/ax88172a.c                                 |   1 +
 drivers/net/usb/hso.c                                      |   5 +--
 drivers/net/wan/hdlc_x25.c                                 |   4 ++-
 drivers/net/wan/lapbether.c                                |   8 +++--
 drivers/net/wan/x25_asy.c                                  |  21 ++++++++----
 drivers/net/wireless/ath/ath10k/ahb.c                      |   2 +-
 drivers/net/wireless/ath/ath10k/pci.c                      |  78 +++++++++++++++++++++-----------------------
 drivers/net/wireless/ath/ath9k/hif_usb.c                   |   4 ++-
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c           |  16 ++++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c               |   8 ++---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c              |   2 ++
 drivers/net/wireless/mediatek/mt76/mt76.h                  |   1 +
 drivers/net/wireless/mediatek/mt76/mt7603/main.c           |   2 ++
 drivers/net/wireless/mediatek/mt76/mt7615/debugfs.c        |   9 +++---
 drivers/net/wireless/mediatek/mt76/mt7615/dma.c            |   9 +++---
 drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c         |   3 +-
 drivers/net/wireless/mediatek/mt76/mt7615/eeprom.h         |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c            |  20 ++++--------
 drivers/net/wireless/mediatek/mt76/mt7615/mac.h            |  15 ---------
 drivers/net/wireless/mediatek/mt76/mt7615/main.c           |   4 +++
 drivers/net/wireless/mediatek/mt76/mt7615/mmio.c           |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h         |  30 +++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt7615/usb.c            |  13 ++++----
 drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c          |   5 +--
 drivers/net/wireless/mediatek/mt76/mt7915/main.c           |   3 ++
 drivers/net/wireless/mediatek/mt76/tx.c                    |   7 ++++
 drivers/net/wireless/mediatek/mt76/usb.c                   |  39 ++++++++++++++--------
 drivers/net/xen-netfront.c                                 |  64 ++++++++++++++++++++++++-------------
 drivers/nfc/s3fwrn5/core.c                                 |   1 +
 include/linux/rhashtable.h                                 |   2 +-
 include/linux/tcp.h                                        |   6 ++--
 include/net/flow_offload.h                                 |   1 -
 net/ax25/af_ax25.c                                         |  10 ++++--
 net/core/dev.c                                             |   2 +-
 net/core/flow_offload.c                                    |   1 +
 net/core/net-sysfs.c                                       |   2 +-
 net/core/rtnetlink.c                                       |   3 +-
 net/core/sock_reuseport.c                                  |   1 +
 net/hsr/hsr_forward.c                                      |  18 ++++++++---
 net/hsr/hsr_framereg.c                                     |   3 +-
 net/ipv4/tcp_input.c                                       |  11 ++++---
 net/ipv4/tcp_output.c                                      |  13 +++++---
 net/ipv4/udp.c                                             |  17 ++++++----
 net/ipv6/ip6_gre.c                                         |  11 ++++---
 net/ipv6/udp.c                                             |  17 ++++++----
 net/netfilter/ipvs/ip_vs_sync.c                            |  12 ++++---
 net/netfilter/nf_tables_api.c                              |  41 ++++++++----------------
 net/nfc/nci/core.c                                         |   5 ++-
 net/qrtr/qrtr.c                                            |   1 +
 net/rxrpc/recvmsg.c                                        |   2 +-
 net/rxrpc/sendmsg.c                                        |   2 +-
 net/sched/act_ct.c                                         |  16 ++++++++--
 net/sched/cls_api.c                                        |   1 -
 net/sctp/stream.c                                          |  27 ++++++++++------
 net/smc/af_smc.c                                           |  12 ++++---
 net/smc/smc_cdc.c                                          |   6 +++-
 net/smc/smc_core.c                                         | 109 ++++++++++++++------------------------------------------------
 net/smc/smc_core.h                                         |   5 +++
 net/smc/smc_ib.c                                           |  16 ++++++++--
 net/smc/smc_ib.h                                           |   1 +
 net/smc/smc_llc.c                                          | 127 ++++++++++++++++++++++++++++++++++++++++++++++++------------------------
 net/smc/smc_llc.h                                          |   2 +-
 net/tipc/link.c                                            |   2 +-
 net/vmw_vsock/virtio_transport.c                           |   2 +-
 tools/testing/selftests/net/fib_nexthop_multiprefix.sh     |   2 +-
 tools/testing/selftests/net/ip_defrag.sh                   |   2 ++
 tools/testing/selftests/net/txtimestamp.sh                 |   2 +-
 127 files changed, 1022 insertions(+), 676 deletions(-)
