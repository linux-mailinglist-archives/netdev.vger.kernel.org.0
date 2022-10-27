Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3111161018A
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 21:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236438AbiJ0TYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 15:24:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236247AbiJ0TYs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 15:24:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 516B25E31A;
        Thu, 27 Oct 2022 12:24:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D579EB827D2;
        Thu, 27 Oct 2022 19:24:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16400C433C1;
        Thu, 27 Oct 2022 19:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666898683;
        bh=PV5TjS5edK0s9Z78Mp0hQTfAlm2jKs1vvvF8Wag6FXk=;
        h=From:To:Cc:Subject:Date:From;
        b=ft+B/2+mQMF7StRFqOatjzmJDRYRNKhk+KB62OMV1eoSCR3QT+CZVa5hJRBo2CfGJ
         O28T31uMGKtmmAbSMAPFBZQT94306WVA/+H6ox2QTJ50aB4r0PKoGzL2xeZ3V3Boh1
         tEKiD7VVKO5QC1cx/biCNUmMse/NNzncU821rgDJdo6T3hS+awN5whUYB9dWOfTKM7
         7GNY70ztFVdUMXt8KgxprkRGVAWhEP2M4WgmrwOOziLQ5mBiVKzg26ZVbhO3cHrYlN
         J6PidNP9RNa/Q7cz7eARWflP8m4lisgXuqfn6jjnl2ISN7W0dXu2IhiZLJSva2u9xC
         rRTwy4OZ03T8g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pabeni@redhat.com
Subject: [PULL] Networking for v6.1-rc3-2
Date:   Thu, 27 Oct 2022 12:24:42 -0700
Message-Id: <20221027192442.2855654-1-kuba@kernel.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

Back to regularly scheduled programming.
Nothing huge here, the large test and code move in MPTCP make
the PR seem bigger than it is.

The following changes since commit 337a0a0b63f1c30195733eaacf39e4310a592a68:

  Merge tag 'net-6.1-rc3-1' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-10-24 12:43:51 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.1-rc3-2

for you to fetch changes up to 84ce1ca3fe9e1249bf21176ff162200f1c4e5ed1:

  net: enetc: survive memory pressure without crashing (2022-10-27 11:32:25 -0700)

----------------------------------------------------------------
Including fixes from 802.15.4 (Zigbee et al.).

Current release - regressions:

 - ipa: fix bugs in the register conversion for IPA v3.1 and v3.5.1

Current release - new code bugs:

 - mptcp: fix abba deadlock on fastopen

 - eth: stmmac: rk3588: allow multiple gmac controllers in one system

Previous releases - regressions:

 - ip: rework the fix for dflt addr selection for connected nexthop

 - net: couple more fixes for misinterpreting bits in struct page after
   the signature was added

Previous releases - always broken:

 - ipv6: ensure sane device mtu in tunnels

 - openvswitch: switch from WARN to pr_warn on a user-triggerable path

 - ethtool: eeprom: fix null-deref on genl_info in dump

 - ieee802154: more return code fixes for corner cases in dgram_sendmsg

 - mac802154: fix link-quality-indicator recording

 - eth: mlx5: fixes for IPsec, PTP timestamps, OvS and conntrack offload

 - eth: fec: limit register access on i.MX6UL

 - eth: bcm4908_enet: update TX stats after actual transmission

 - can: rcar_canfd: improve IRQ handling for RZ/G2L

Misc:

 - genetlink: piggy back on the newly added resv_op_start to enforce
   more sanity checks on new commands

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Aaron Conole (2):
      openvswitch: switch from WARN to pr_warn
      selftests: add openvswitch selftest suite

Alexander Aring (1):
      net: ieee802154: return -EINVAL for unknown addr type

Anssi Hannula (1):
      can: kvaser_usb: Fix possible completions during init_completion

Ariel Levkovich (1):
      net/mlx5e: TC, Reject forwarding from internal port to internal port

Aya Levin (1):
      net/mlx5e: Extend SKB room check to include PTP-SQ

Benjamin Gaignard (1):
      net: stmmac: rk3588: Allow multiple gmac controller

Biju Das (2):
      can: rcar_canfd: rcar_canfd_handle_global_receive(): fix IRQ storm on global FIFO receive
      can: rcar_canfd: fix channel specific IRQ handling for RZ/G2L

Caleb Connolly (3):
      net: ipa: fix v3.5.1 resource limit max values
      net: ipa: fix v3.1 resource limit masks
      net: ipa: don't configure IDLE_INDICATION on v3.1

Dongliang Mu (2):
      can: mscan: mpc5xxx: mpc5xxx_can_probe(): add missing put_clock() in error path
      can: mcp251x: mcp251x_can_probe(): add missing unregister_candev() in error path

Eric Dumazet (3):
      ipv6: ensure sane device mtu in tunnels
      net: do not sense pfmemalloc status in skb_append_pagefrags()
      kcm: do not sense pfmemalloc status in kcm_sendpage()

Florian Fainelli (1):
      net: bcmsysport: Indicate MAC is in charge of PHY PM

Horatiu Vultur (1):
      net: lan966x: Stop replacing tx dcbs and dcbs_buf when changing MTU

Hyong Youb Kim (1):
      net/mlx5e: Do not increment ESN when updating IPsec ESN state

Jakub Kicinski (8):
      genetlink: piggy back on resv_op to default to a reject policy
      Merge branch 'mptcp-fixes-for-6-1'
      Merge tag 'ieee802154-for-net-2022-10-24' of git://git.kernel.org/pub/scm/linux/kernel/git/sschmidt/wpan
      Merge tag 'linux-can-fixes-for-6.1-20221025' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can
      genetlink: limit the use of validation workarounds to old ops
      Merge branch 'ip-rework-the-fix-for-dflt-addr-selection-for-connected-nexthop'
      Merge tag 'linux-can-fixes-for-6.1-20221027' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can
      Merge branch 'fix-some-issues-in-netdevsim-driver'

Juergen Borleis (1):
      net: fec: limit register access on i.MX6UL

Kunihiko Hayashi (1):
      net: ethernet: ave: Fix MAC to be in charge of PHY PM

Marc Kleine-Budde (1):
      Merge patch series "R-Car CAN-FD fixes"

Miquel Raynal (1):
      mac802154: Fix LQI recording

Moshe Shemesh (1):
      net/mlx5: Wait for firmware to enable CRS before pci_restore_state

Nicolas Dichtel (3):
      Revert "ip: fix triggering of 'icmp redirect'"
      Revert "ip: fix dflt addr selection for connected nexthop"
      nh: fix scope used to find saddr when adding non gw nh

Paolo Abeni (4):
      mptcp: set msk local address earlier
      mptcp: factor out mptcp_connect()
      mptcp: fix abba deadlock on fastopen
      Merge branch 'openvswitch-syzbot-splat-fix-and-introduce-selftest'

Paul Blakey (1):
      net/mlx5e: Update restore chain id for slow path packets

Raed Salem (4):
      net/mlx5e: Fix macsec coverity issue at rx sa update
      net/mlx5e: Fix macsec rx security association (SA) update/delete
      net/mlx5e: Fix wrong bitwise comparison usage in macsec_fs_rx_add_rule function
      net/mlx5e: Fix macsec sci endianness at rx sa update

Rafał Miłecki (1):
      net: broadcom: bcm4908_enet: update TX stats after actual transmission

Roi Dayan (1):
      net/mlx5e: TC, Fix cloned flow attr instance dests are not zeroed

Rolf Eike Beer (1):
      rhashtable: make test actually random

Rongwei Liu (1):
      net/mlx5: DR, Fix matcher disconnect error flow

Roy Novich (1):
      net/mlx5: Update fw fatal reporter state on PCI handlers successful recover

Saeed Mahameed (1):
      net/mlx5: ASO, Create the ASO SQ with the correct timestamp format

Slawomir Laba (2):
      i40e: Fix ethtool rx-flow-hash setting for X722
      i40e: Fix flow-type by setting GL_HASH_INSET registers

Suresh Devarakonda (1):
      net/mlx5: Fix crash during sync firmware reset

Sylwester Dziedziuch (1):
      i40e: Fix VF hang when reset is triggered on another VF

Tariq Toukan (1):
      net/mlx5: Fix possible use-after-free in async command interface

Vladimir Oltean (1):
      net: enetc: survive memory pressure without crashing

Wei Yongjun (1):
      net: ieee802154: fix error return code in dgram_bind()

Xin Long (1):
      ethtool: eeprom: fix null-deref on genl_info in dump

Yang Yingliang (3):
      net: ksz884x: fix missing pci_disable_device() on error in pcidev_init()
      net: ehea: fix possible memory leak in ehea_register_port()
      can: j1939: transport: j1939_session_skb_drop_old(): spin_unlock_irqrestore() before kfree_skb()

Zhengchao Shao (3):
      netdevsim: fix memory leak in nsim_bus_dev_new()
      netdevsim: fix memory leak in nsim_drv_probe() when nsim_dev_resources_register() failed
      netdevsim: remove dir in nsim_dev_debugfs_init() when creating ports dir failed

 MAINTAINERS                                        |   1 +
 drivers/net/can/mscan/mpc5xxx_can.c                |   8 +-
 drivers/net/can/rcar/rcar_canfd.c                  |  24 +-
 drivers/net/can/spi/mcp251x.c                      |   5 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c  |   4 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c   |   4 +-
 drivers/net/ethernet/broadcom/bcm4908_enet.c       |  12 +-
 drivers/net/ethernet/broadcom/bcmsysport.c         |   3 +
 drivers/net/ethernet/freescale/enetc/enetc.c       |   5 +
 drivers/net/ethernet/freescale/fec_main.c          |  46 ++-
 drivers/net/ethernet/ibm/ehea/ehea_main.c          |   1 +
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     | 100 +++---
 drivers/net/ethernet/intel/i40e/i40e_type.h        |   4 +
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |  43 ++-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |  10 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h   |   9 +
 .../net/ethernet/mellanox/mlx5/core/en/tc_priv.h   |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  |   6 +
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.c   |   3 -
 .../ethernet/mellanox/mlx5/core/en_accel/macsec.c  |  16 +-
 .../mellanox/mlx5/core/en_accel/macsec_fs.c        |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  78 ++++-
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |   6 +
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c |  17 +
 drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c  |   7 +
 drivers/net/ethernet/mellanox/mlx5/core/lib/mpfs.c |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   4 +
 .../ethernet/mellanox/mlx5/core/steering/dr_rule.c |   3 +-
 drivers/net/ethernet/micrel/ksz884x.c              |   2 +-
 .../net/ethernet/microchip/lan966x/lan966x_fdma.c  |  24 +-
 drivers/net/ethernet/socionext/sni_ave.c           |   6 +
 drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c     |   6 +
 drivers/net/ipa/data/ipa_data-v3.5.1.c             |   4 +-
 drivers/net/ipa/ipa_main.c                         |   3 +
 drivers/net/ipa/reg/ipa_reg-v3.1.c                 |  96 ++----
 drivers/net/netdevsim/bus.c                        |   9 +-
 drivers/net/netdevsim/dev.c                        |  31 +-
 include/linux/mlx5/driver.h                        |   2 +-
 include/net/genetlink.h                            |  10 +-
 lib/test_rhashtable.c                              |  58 ++--
 net/can/j1939/transport.c                          |   4 +-
 net/core/skbuff.c                                  |   2 +-
 net/ethtool/eeprom.c                               |   2 +-
 net/ieee802154/socket.c                            |   4 +-
 net/ipv4/fib_frontend.c                            |   4 +-
 net/ipv4/fib_semantics.c                           |   2 +-
 net/ipv4/nexthop.c                                 |   2 +-
 net/ipv6/ip6_gre.c                                 |  12 +-
 net/ipv6/ip6_tunnel.c                              |  11 +-
 net/ipv6/sit.c                                     |   8 +-
 net/kcm/kcmsock.c                                  |   2 +-
 net/mac802154/rx.c                                 |   5 +-
 net/mptcp/protocol.c                               | 182 ++++++-----
 net/mptcp/protocol.h                               |   5 +-
 net/mptcp/subflow.c                                |   7 +
 net/netlink/genetlink.c                            |  25 ++
 net/openvswitch/datapath.c                         |   3 +-
 tools/testing/selftests/Makefile                   |   1 +
 tools/testing/selftests/net/openvswitch/Makefile   |  13 +
 .../selftests/net/openvswitch/openvswitch.sh       | 218 +++++++++++++
 .../testing/selftests/net/openvswitch/ovs-dpctl.py | 351 +++++++++++++++++++++
 62 files changed, 1197 insertions(+), 347 deletions(-)
 create mode 100644 tools/testing/selftests/net/openvswitch/Makefile
 create mode 100755 tools/testing/selftests/net/openvswitch/openvswitch.sh
 create mode 100644 tools/testing/selftests/net/openvswitch/ovs-dpctl.py
