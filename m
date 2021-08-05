Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15CB43E1876
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 17:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242508AbhHEPod (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 11:44:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:48006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242469AbhHEPnu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 11:43:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3181C61131;
        Thu,  5 Aug 2021 15:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628178216;
        bh=Od3r7blUP8259lLUtMQfNUBmcPQ7dH40P9iBonzpcCU=;
        h=From:To:Cc:Subject:Date:From;
        b=Au0bkH7F0biOGCZAk1NheMQtJfIspTOAvzacZbFqb8QyaARwy47bsyWN9O/kvxVKU
         /9eXUx9TtSzY0M7ovcE0izT7Aowggyv1vE+lqFqnLIXHTbB535zkMtm1CT8iElkwit
         CoK19dzcZJUhp6Ih3LVFIV5t//Ams5WLuVO8cVzqKUYPKV1ktl7O0CbCoGf7PIlIzA
         RFGwqPuzQ/qFv8bFOTiAOl5onwzXvSDlvG2joxY9LhkbgVgjn53LtAVVex0xFwovzK
         uOBi9ajVX8BwuubAmLZ7j3321SiyXM2ZonpZneNLbm60a7XICWPzLOx/wU1oZ6Q0TB
         eJZD+xI3zSiVw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 5.14-rc5
Date:   Thu,  5 Aug 2021 08:43:35 -0700
Message-Id: <20210805154335.1070064-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

Small PR this week, maybe it's cucumber time, maybe just bad
timing vs subtree PRs, maybe both. The share of v5.14 bugs
vs bugs in older code seems to be skewing the right way for rc5,
so no cause for alarm.

The following changes since commit c7d102232649226a69dddd58a4942cf13cff4f7c:

  Merge tag 'net-5.14-rc4' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2021-07-30 16:01:36 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.14-rc5

for you to fetch changes up to 6bb5318ce501cb744e58105ba56cd5308e75004d:

  Merge branch 'net-fix-use-after-free-bugs' (2021-08-05 07:29:55 -0700)

----------------------------------------------------------------
Networking fixes for 5.14-rc5, including fixes from ipsec.

Current release - regressions:

 - sched: taprio: fix init procedure to avoid inf loop when dumping

 - sctp: move the active_key update after sh_keys is added

Current release - new code bugs:

 - sparx5: fix build with old GCC & bitmask on 32-bit targets

Previous releases - regressions:

 - xfrm: redo the PREEMPT_RT RCU vs hash_resize_mutex deadlock fix

 - xfrm: fixes for the compat netlink attribute translator

 - phy: micrel: Fix detection of ksz87xx switch

Previous releases - always broken:

 - gro: set inner transport header offset in tcp/udp GRO hook to avoid
        crashes when such packets reach GSO

 - vsock: handle VIRTIO_VSOCK_OP_CREDIT_REQUEST, as required by spec

 - dsa: sja1105: fix static FDB entries on SJA1105P/Q/R/S and SJA1110

 - bridge: validate the NUD_PERMANENT bit when adding an extern_learn FDB entry

 - usb: lan78xx: don't modify phy_device state concurrently

 - usb: pegasus: check for errors of IO routines

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Antoine Tenart (1):
      net: ipv6: fix returned variable type in ip6_skb_dst_mtu

Arnd Bergmann (1):
      net: sparx5: fix bitmask on 32-bit targets

Bijie Xu (2):
      net: flow_offload: correct comments mismatch with code
      net: sched: provide missing kdoc for tcf_pkt_info and tcf_ematch_ops

Dan Carpenter (1):
      bnx2x: fix an error code in bnx2x_nic_load()

David S. Miller (6):
      mhi: Fix networking tree build.
      Merge branch 'sja1105-fdb-fixes'
      net: really fix the build...
      Merge branch 'pegasus-errors'
      Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec
      Merge branch 'eean-iosm-fixes'

Dmitry Safonov (2):
      net/xfrm/compat: Copy xfrm_spdattr_type_t atributes
      selftests/net/ipsec: Add test for xfrm_spdattr_type_t

Fei Qin (1):
      nfp: update ethtool reporting of pauseframe control

Frederic Weisbecker (1):
      xfrm: Fix RCU vs hash_resize_mutex lock inversion

Geliang Tang (1):
      mptcp: drop unused rcu member in mptcp_pm_addr_entry

Grygorii Strashko (1):
      net: ethernet: ti: am65-cpsw: fix crash in am65_cpsw_port_offload_fwd_mark_update()

Harshavardhan Unnibhavi (1):
      VSOCK: handle VIRTIO_VSOCK_OP_CREDIT_REQUEST

Harshvardhan Jha (1):
      net: xfrm: Fix end of loop tests for list_for_each_entry

Ivan T. Ivanov (1):
      net: usb: lan78xx: don't modify phy_device state concurrently

Jakub Kicinski (6):
      net: sparx5: fix compiletime_assert for GCC 4.9
      docs: operstates: fix typo
      docs: operstates: document IF_OPER_TESTING
      Revert "mhi: Fix networking tree build."
      docs: networking: netdevsim rules
      Merge branch 'net-fix-use-after-free-bugs'

Jakub Sitnicki (1):
      net, gro: Set inner transport header offset in tcp/udp GRO hook

Leon Romanovsky (1):
      net/prestera: Fix devlink groups leakage in error flow

M Chetan Kumar (4):
      net: wwan: iosm: fix lkp buildbot warning
      net: wwan: iosm: endianness type correction
      net: wwan: iosm: correct data protocol mask bit
      net: wwan: iosm: fix recursive lock acquire in unregister

Oleksij Rempel (1):
      net: dsa: qca: ar9331: reorder MDIO write sequence

Pavel Skripkin (4):
      net: xfrm: fix memory leak in xfrm_user_rcv_msg
      net: pegasus: fix uninit-value in get_interrupt_interval
      net: fec: fix use-after-free in fec_drv_remove
      net: vxge: fix use-after-free in vxge_device_unregister

Petko Manolov (2):
      net: usb: pegasus: Check the return value of get_geristers() and friends;
      net: usb: pegasus: Remove the changelog and DRIVER_VERSION.

Prabhakar Kushwaha (1):
      qede: fix crash in rmmod qede while automatic debug collection

Steffen Klassert (2):
      Revert "xfrm: policy: Read seqcount outside of rcu-read side in xfrm_policy_lookup_bytype"
      Merge branch 'xfrm/compat: Fix xfrm_spdattr_type_t copying'

Steve Bennett (1):
      net: phy: micrel: Fix detection of ksz87xx switch

Vladimir Oltean (7):
      net: dsa: sja1105: fix static FDB writes for SJA1110
      net: dsa: sja1105: overwrite dynamic FDB entries with static ones in .port_fdb_add
      net: dsa: sja1105: invalidate dynamic FDB entries learned concurrently with statically added ones
      net: dsa: sja1105: ignore the FDB entry for unknown multicast when adding a new address
      net: dsa: sja1105: be stateless with FDB entries on SJA1105P/Q/R/S/SJA1110 too
      net: dsa: sja1105: match FDB entries regardless of inner/outer VLAN tag
      net: bridge: validate the NUD_PERMANENT bit when adding an extern_learn FDB entry

Wang Hai (1):
      net: natsemi: Fix missing pci_disable_device() in probe and remove

Xin Long (1):
      sctp: move the active_key update after sh_keys is added

Yannick Vignon (1):
      net/sched: taprio: Fix init procedure

Yunsheng Lin (1):
      net: sched: fix lockdep_set_class() typo error for sch->seqlock

 Documentation/networking/netdev-FAQ.rst            |  17 +++
 Documentation/networking/operstates.rst            |   6 +-
 drivers/bus/mhi/core/internal.h                    |   2 +-
 drivers/bus/mhi/core/main.c                        |   9 +-
 drivers/net/dsa/qca/ar9331.c                       |  14 +-
 drivers/net/dsa/sja1105/sja1105_dynamic_config.c   |  27 ++--
 drivers/net/dsa/sja1105/sja1105_main.c             |  94 +++++++++---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c    |   3 +-
 drivers/net/ethernet/freescale/fec_main.c          |   2 +-
 .../ethernet/marvell/prestera/prestera_devlink.c   |   2 +
 .../net/ethernet/microchip/sparx5/sparx5_netdev.c  |  21 ++-
 drivers/net/ethernet/natsemi/natsemi.c             |   8 +-
 drivers/net/ethernet/neterion/vxge/vxge-main.c     |   6 +-
 .../net/ethernet/netronome/nfp/nfp_net_ethtool.c   |   2 +
 drivers/net/ethernet/qlogic/qede/qede.h            |   1 +
 drivers/net/ethernet/qlogic/qede/qede_main.c       |   8 +
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |   6 +-
 drivers/net/mhi/net.c                              |   2 +-
 drivers/net/phy/micrel.c                           |  10 +-
 drivers/net/usb/lan78xx.c                          |  16 +-
 drivers/net/usb/pegasus.c                          | 152 +++++++++++--------
 drivers/net/wwan/iosm/iosm_ipc_mmio.h              |   4 +-
 drivers/net/wwan/iosm/iosm_ipc_mux_codec.c         |   4 +-
 drivers/net/wwan/iosm/iosm_ipc_mux_codec.h         |   2 +-
 drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c      |   4 +-
 drivers/net/wwan/iosm/iosm_ipc_wwan.c              |   2 +-
 drivers/net/wwan/mhi_wwan_ctrl.c                   |   2 +-
 include/linux/mhi.h                                |   7 +-
 include/net/flow_offload.h                         |   2 +-
 include/net/ip6_route.h                            |   2 +-
 include/net/netns/xfrm.h                           |   1 +
 include/net/pkt_cls.h                              |   4 +
 net/bridge/br.c                                    |   3 +-
 net/bridge/br_fdb.c                                |  30 +++-
 net/bridge/br_private.h                            |   2 +-
 net/ipv4/tcp_offload.c                             |   3 +
 net/ipv4/udp_offload.c                             |   4 +
 net/mptcp/pm_netlink.c                             |   1 -
 net/qrtr/mhi.c                                     |  16 +-
 net/sched/sch_generic.c                            |   2 +-
 net/sched/sch_taprio.c                             |   2 -
 net/sctp/auth.c                                    |  14 +-
 net/vmw_vsock/virtio_transport_common.c            |   3 +
 net/xfrm/xfrm_compat.c                             |  49 +++++-
 net/xfrm/xfrm_ipcomp.c                             |   2 +-
 net/xfrm/xfrm_policy.c                             |  32 ++--
 net/xfrm/xfrm_user.c                               |  10 ++
 tools/testing/selftests/net/ipsec.c                | 165 ++++++++++++++++++++-
 48 files changed, 583 insertions(+), 197 deletions(-)
