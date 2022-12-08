Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB2464779C
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 22:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbiLHVAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 16:00:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbiLHVAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 16:00:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C0912A0;
        Thu,  8 Dec 2022 13:00:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A710B8262B;
        Thu,  8 Dec 2022 21:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2BFEC433D2;
        Thu,  8 Dec 2022 21:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670533211;
        bh=9sE6kawQfn0eOlwDYovvOanG5LtxTyNsNTjlfq/lgC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S8diB4sW+ZGsdvDXp/rm1IQPIQeqrWq0cNEDLr3/RcFdgIocF6uKEdjTDpd0RcPk5
         GQ84GEbUoB+bP7ggzGJn2mvSCDPVOFkG9x3RGitS112qgOByeuGT3J5TTh1alvNfXR
         Ssc6vZGvBxT2cLFo7Y0hrTs7Dyji80mkFPvrLOAbOLVsI65fBJPf20LI5xkcZltC6E
         4KCvlMnZE65ejzBcqFt/zfbNyzJCIMYr+zCQkk0c0Utg1AsmYzZUxsGnD2rqs2VIrV
         EorNjoQcsoN2fngHDlRjpeIpYUeZHzOzKDOQAfKJt6WM9AmCPuIw7G5Vc5A3tbgUMP
         KP+hm/gsqrVUQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pabeni@redhat.com
Subject: [PULL] Networking for v6.1 final / v6.1-rc9 (with the diff stat :S)
Date:   Thu,  8 Dec 2022 13:00:09 -0800
Message-Id: <20221208210009.1799399-1-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221208205639.1799257-1-kuba@kernel.org>
References: <20221208205639.1799257-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

Couple of "new code fixes" which is annoying this late, but neither
of those gives me pause.

We pooped it by merging a Xen patch too quickly, and Juergen ended
up sending you a different version via his tree, so you'll see
a conflict. Just keep what you have. Link to the linux-next conflict
report:
https://lore.kernel.org/all/20221208082301.5f7483e8@canb.auug.org.au/

There is an outstanding regression in BPF / Peter's static calls stuff,
you can probably judge this sort of stuff better than I can:
https://lore.kernel.org/all/CACkBjsYioeJLhJAZ=Sq4CAL2O_W+5uqcJynFgLSizWLqEjNrjw@mail.gmail.com/

No other known regressions.

The following changes since commit 01f856ae6d0ca5ad0505b79bf2d22d7ca439b2a1:

  Merge tag 'net-6.1-rc8-2' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-11-29 09:52:10 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.1-rc9

for you to fetch changes up to f8bac7f9fdb0017b32157957ffffd490f95faa07:

  net: dsa: sja1105: avoid out of bounds access in sja1105_init_l2_policing() (2022-12-08 09:38:31 -0800)

----------------------------------------------------------------
Including fixes from bluetooth, can and netfilter.

Current release - new code bugs:

 - bonding: ipv6: correct address used in Neighbour Advertisement
   parsing (src vs dst typo)

 - fec: properly scope IRQ coalesce setup during link up to supported
   chips only

Previous releases - regressions:

 - Bluetooth fixes for fake CSR clones (knockoffs):
   - re-add ERR_DATA_REPORTING quirk
   - fix crash when device is replugged

 - Bluetooth:
   - silence a user-triggerable dmesg error message
   - L2CAP: fix u8 overflow, oob access
   - correct vendor codec definition
   - fix support for Read Local Supported Codecs V2

 - ti: am65-cpsw: fix RGMII configuration at SPEED_10

 - mana: fix race on per-CQ variable NAPI work_done

Previous releases - always broken:

 - af_unix: diag: fetch user_ns from in_skb in unix_diag_get_exact(),
   avoid null-deref

 - af_can: fix NULL pointer dereference in can_rcv_filter

 - can: slcan: fix UAF with a freed work

 - can: can327: flush TX_work on ldisc .close()

 - macsec: add missing attribute validation for offload

 - ipv6: avoid use-after-free in ip6_fragment()

 - nft_set_pipapo: actually validate intervals in fields
   after the first one

 - mvneta: prevent oob access in mvneta_config_rss()

 - ipv4: fix incorrect route flushing when table ID 0 is used,
   or when source address is deleted

 - phy: mxl-gpy: add workaround for IRQ bug on GPY215B and GPY215C

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Akihiko Odaki (2):
      e1000e: Fix TX dispatch condition
      igb: Allocate MSI-X vector when testing

Alexandra Winter (1):
      s390/qeth: fix use-after-free in hsci

Artem Chernyshev (3):
      net: dsa: ksz: Check return value
      net: dsa: hellcreek: Check return value
      net: dsa: sja1105: Check return value

Casper Andersson (1):
      net: microchip: sparx5: correctly free skb in xmit

Chen Zhongjin (1):
      Bluetooth: Fix not cleanup led when bt_init fails

Chethan T N (2):
      Bluetooth: Remove codec id field in vendor codec definition
      Bluetooth: Fix support for Read Local Supported Codecs V2

Dan Carpenter (2):
      net: mvneta: Prevent out of bounds read in mvneta_config_rss()
      net: mvneta: Fix an out of bounds check

David S. Miller (1):
      Merge branch 'vmxnet3-fixes'

Emeel Hakim (1):
      macsec: add missing attribute validation for offload

Eric Dumazet (1):
      ipv6: avoid use-after-free in ip6_fragment()

Florian Westphal (1):
      inet: ping: use hlist_nulls rcu iterator during lookup

Frank Jungclaus (1):
      can: esd_usb: Allow REC and TEC to return to zero

Haiyang Zhang (1):
      net: mana: Fix race on per-CQ variable napi work_done

Hangbin Liu (2):
      ip_gre: do not report erspan version on GRE interface
      bonding: get correct NA dest address

Hauke Mehrtens (1):
      ca8210: Fix crash by zero initializing data

Ido Schimmel (2):
      ipv4: Fix incorrect route flushing when source address is deleted
      ipv4: Fix incorrect route flushing when table ID 0 is used

Ismael Ferreras Morezuelas (2):
      Bluetooth: btusb: Fix CSR clones again by re-adding ERR_DATA_REPORTING quirk
      Bluetooth: btusb: Add debug message for CSR controllers

Jakub Kicinski (6):
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf
      Merge branch '1GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      Merge tag 'for-net-2022-12-02' of git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth
      Merge branch 'ipv4-two-bug-fixes'
      Merge branch '40GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      Merge tag 'linux-can-fixes-for-6.1-20221207' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can

Jiri Slaby (SUSE) (1):
      can: slcan: fix freed work crash

Jisheng Zhang (1):
      net: stmmac: fix "snps,axi-config" node property parsing

Kees Cook (1):
      NFC: nci: Bounds check struct nfc_target arrays

Kuniyuki Iwashima (2):
      af_unix: Get user_ns from in_skb in unix_diag_get_exact().
      af_unix: Add test for sock_diag and UDIAG_SHOW_UID.

Lin Liu (1):
      xen-netfront: Fix NULL sring after live migration

Liu Jian (2):
      net: hisilicon: Fix potential use-after-free in hisi_femac_rx()
      net: hisilicon: Fix potential use-after-free in hix5hd2_rx()

Luiz Augusto von Dentz (1):
      Bluetooth: Fix crash when replugging CSR fake controllers

Mateusz Jończyk (1):
      Bluetooth: silence a dmesg error message in hci_request.c

Max Staudt (1):
      can: can327: flush TX_work on ldisc .close()

Michael Walle (1):
      net: phy: mxl-gpy: add MDINT workaround

Michal Jaron (1):
      i40e: Fix not setting default xps_cpus after reset

Oliver Hartkopp (1):
      can: af_can: fix NULL pointer dereference in can_rcv_filter

Pablo Neira Ayuso (1):
      netfilter: ctnetlink: fix compilation warning after data race fixes in ct mark

Paolo Abeni (2):
      Merge branch 'af_unix-fix-a-null-deref-in-sk_diag_dump_uid'
      Merge tag 'ieee802154-for-net-2022-12-05' of git://git.kernel.org/pub/scm/linux/kernel/git/sschmidt/wpan

Przemyslaw Patynowski (1):
      i40e: Disallow ip4 and ip6 l4_4_bytes

Qiheng Lin (1):
      net: microchip: sparx5: Fix missing destroy_workqueue of mact_queue

Radu Nicolae Pirea (OSS) (1):
      net: dsa: sja1105: avoid out of bounds access in sja1105_init_l2_policing()

Rasmus Villemoes (1):
      net: fec: properly guard irq coalesce setup

Ronak Doshi (2):
      vmxnet3: correctly report encapsulated LRO packet
      vmxnet3: use correct intrConf reference when using extended queues

Siddharth Vadapalli (1):
      net: ethernet: ti: am65-cpsw: Fix RGMII configuration at SPEED_10

Stefano Brivio (1):
      netfilter: nft_set_pipapo: Actually validate intervals in fields after the first one

Sungwoo Kim (1):
      Bluetooth: L2CAP: Fix u8 overflow

Sylwester Dziedziuch (1):
      i40e: Fix for VF MAC address 0

Tianjia Zhang (1):
      selftests/tls: Fix tls selftests dependency to correct algorithm

Tiezhu Yang (1):
      selftests: net: Use "grep -E" instead of "egrep"

Valentina Goncharenko (2):
      net: encx24j600: Add parentheses to fix precedence
      net: encx24j600: Fix invalid logic in reading of MISTAT register

Vladimir Oltean (1):
      net: dsa: mv88e6xxx: accept phy-mode = "internal" for internal PHY ports

Wang ShaoBo (2):
      Bluetooth: 6LoWPAN: add missing hci_dev_put() in get_l2cap_conn()
      Bluetooth: hci_conn: add missing hci_dev_put() in iso_listen_bis()

Wei Yongjun (1):
      mac802154: fix missing INIT_LIST_HEAD in ieee802154_if_add()

Xin Long (3):
      netfilter: flowtable_offload: fix using __this_cpu_add in preemptible
      netfilter: conntrack: fix using __this_cpu_add in preemptible
      tipc: call tipc_lxc_xmit without holding node_read_lock

Yang Yingliang (3):
      net: mdiobus: fix double put fwnode in the error path
      xen/netback: don't call kfree_skb() under spin_lock_irqsave()
      net: plip: don't call kfree_skb/dev_kfree_skb() under spin_lock_irq()

Yinjun Zhang (1):
      nfp: correct desc type when header dma len is 4096

Yongqiang Liu (1):
      net: thunderx: Fix missing destroy_workqueue of nicvf_rx_mode_wq

Yuan Can (1):
      dpaa2-switch: Fix memory leak in dpaa2_switch_acl_entry_add() and dpaa2_switch_acl_entry_remove()

YueHaibing (3):
      net: broadcom: Add PTP_1588_CLOCK_OPTIONAL dependency for BCMGENET under ARCH_BCM2835
      ravb: Fix potential use-after-free in ravb_rx_gbeth()
      tipc: Fix potential OOB in tipc_link_proto_rcv()

Zeng Heng (1):
      net: mdio: fix unbalanced fwnode reference count in mdio_device_release()

Zhang Changzhong (1):
      ethernet: aeroflex: fix potential skb leak in greth_init_rings()

Zhengchao Shao (4):
      selftests: rtnetlink: correct xfrm policy rule in kci_test_ipsec_offload
      net: wwan: iosm: fix memory leak in ipc_mux_init()
      net: dsa: sja1105: fix memory leak in sja1105_setup_devlink_regions()
      net: thunderbolt: fix memory leak in tbnet_open()

Ziyang Xuan (2):
      ieee802154: cc2520: Fix error return code in cc2520_hw_init()
      octeontx2-pf: Fix potential memory leak in otx2_init_tc()

 .clang-format                                      |   1 +
 drivers/bluetooth/btusb.c                          |   6 +
 drivers/net/bonding/bond_main.c                    |   2 +-
 drivers/net/can/can327.c                           |  17 +-
 drivers/net/can/slcan/slcan-core.c                 |  10 +-
 drivers/net/can/usb/esd_usb.c                      |   6 +
 drivers/net/dsa/mv88e6xxx/chip.c                   |   7 +-
 drivers/net/dsa/sja1105/sja1105_devlink.c          |   2 +
 drivers/net/dsa/sja1105/sja1105_main.c             |   2 +-
 drivers/net/ethernet/aeroflex/greth.c              |   1 +
 drivers/net/ethernet/broadcom/Kconfig              |   3 +-
 drivers/net/ethernet/cavium/thunder/nicvf_main.c   |   4 +-
 .../ethernet/freescale/dpaa2/dpaa2-switch-flower.c |   4 +
 drivers/net/ethernet/freescale/fec_main.c          |   3 +-
 drivers/net/ethernet/hisilicon/hisi_femac.c        |   2 +-
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c      |   2 +-
 drivers/net/ethernet/intel/e1000e/netdev.c         |   4 +-
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |  12 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  19 ++-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |   2 +
 drivers/net/ethernet/intel/igb/igb_ethtool.c       |   2 +
 drivers/net/ethernet/marvell/mvneta.c              |   2 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_tc.c   |   7 +-
 drivers/net/ethernet/microchip/encx24j600-regmap.c |   4 +-
 .../net/ethernet/microchip/sparx5/sparx5_fdma.c    |   2 +-
 .../net/ethernet/microchip/sparx5/sparx5_main.c    |   3 +
 .../net/ethernet/microchip/sparx5/sparx5_packet.c  |  41 +++--
 drivers/net/ethernet/microsoft/mana/gdma.h         |   9 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c      |  16 +-
 drivers/net/ethernet/netronome/nfp/nfdk/dp.c       |   6 +-
 drivers/net/ethernet/renesas/ravb_main.c           |   2 +-
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |   8 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |   2 +-
 drivers/net/ieee802154/ca8210.c                    |   2 +-
 drivers/net/ieee802154/cc2520.c                    |   2 +-
 drivers/net/macsec.c                               |   1 +
 drivers/net/mdio/fwnode_mdio.c                     |   4 +-
 drivers/net/mdio/of_mdio.c                         |   3 +-
 drivers/net/phy/mdio_device.c                      |   2 +
 drivers/net/phy/mxl-gpy.c                          |  85 ++++++++++
 drivers/net/plip/plip.c                            |   4 +-
 drivers/net/thunderbolt.c                          |   1 +
 drivers/net/vmxnet3/vmxnet3_drv.c                  |  27 +++-
 drivers/net/wwan/iosm/iosm_ipc_mux.c               |   1 +
 drivers/net/xen-netback/rx.c                       |   2 +-
 drivers/net/xen-netfront.c                         |   6 +
 drivers/s390/net/qeth_l2_main.c                    |   2 +-
 include/net/bluetooth/hci.h                        |  12 +-
 include/net/ping.h                                 |   3 -
 net/bluetooth/6lowpan.c                            |   1 +
 net/bluetooth/af_bluetooth.c                       |   4 +-
 net/bluetooth/hci_codec.c                          |  19 +--
 net/bluetooth/hci_core.c                           |   8 +-
 net/bluetooth/hci_request.c                        |   2 +-
 net/bluetooth/hci_sync.c                           |  19 ++-
 net/bluetooth/iso.c                                |   1 +
 net/bluetooth/l2cap_core.c                         |   3 +-
 net/can/af_can.c                                   |   6 +-
 net/dsa/tag_hellcreek.c                            |   3 +-
 net/dsa/tag_ksz.c                                  |   3 +-
 net/dsa/tag_sja1105.c                              |   3 +-
 net/ipv4/fib_frontend.c                            |   3 +
 net/ipv4/fib_semantics.c                           |   1 +
 net/ipv4/ip_gre.c                                  |  48 +++---
 net/ipv4/ping.c                                    |   7 +-
 net/ipv6/ip6_output.c                              |   5 +
 net/mac802154/iface.c                              |   1 +
 net/netfilter/nf_conntrack_core.c                  |   6 +-
 net/netfilter/nf_conntrack_netlink.c               |  19 +--
 net/netfilter/nf_flow_table_offload.c              |   6 +-
 net/netfilter/nft_set_pipapo.c                     |   5 +-
 net/nfc/nci/ntf.c                                  |   6 +
 net/tipc/link.c                                    |   4 +-
 net/tipc/node.c                                    |  12 +-
 net/unix/diag.c                                    |  20 ++-
 tools/testing/selftests/net/.gitignore             |   1 +
 tools/testing/selftests/net/af_unix/Makefile       |   2 +-
 tools/testing/selftests/net/af_unix/diag_uid.c     | 178 +++++++++++++++++++++
 tools/testing/selftests/net/config                 |   2 +-
 tools/testing/selftests/net/fib_tests.sh           |  37 +++++
 tools/testing/selftests/net/rtnetlink.sh           |   2 +-
 tools/testing/selftests/net/toeplitz.sh            |   2 +-
 82 files changed, 644 insertions(+), 165 deletions(-)
 create mode 100644 tools/testing/selftests/net/af_unix/diag_uid.c
