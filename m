Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67ECD3F2055
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 21:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234126AbhHSTCv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 15:02:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:45888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233673AbhHSTCn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 15:02:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 66B2B610A0;
        Thu, 19 Aug 2021 19:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629399726;
        bh=sFK1Nqe/4wq7dMQYN2L5GqYHqYJoHdjK/FUQ4s3vVvs=;
        h=From:To:Cc:Subject:Date:From;
        b=aICUevfcS/m5yic0jIcQxcA8SL2ot2Ai57OKbfBtwSFDGdIJawTKV3cjf5z+LMjes
         h02E0B2Tac2i0I6JwVrjH/Si0e0Prsntp9mCyNTz0BDRtewkk98WFNWvBMvl8VE0Ze
         bXKlbwU+ecMwA+/zTjfXrWMV9TMRZ0ZTVcVCG3pKVVcLDn2+06uph+wdUFkGRt55nv
         USk3clHpN0nt4eLoU+mqqeShw41aa79kDHG3YI/g9FFGV3vrv2Sx5gAV2Wpmy11Muq
         GRhepwu4oPAhvBEd/L2vQEurRV1sY2USr0UoeRq8mxo0DTkb9U63mhd39rtTVx0nFE
         zzEJIeEQZj8uQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: [GIT PULL] Networking for 5.14-rc7
Date:   Thu, 19 Aug 2021 12:02:05 -0700
Message-Id: <20210819190205.2996753-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

Smaller PR this week, and no major regressions undergoing
investigation AFAIK.

The following changes since commit f8e6dfc64f6135d1b6c5215c14cd30b9b60a0008:

  Merge tag 'net-5.14-rc6' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2021-08-12 16:24:03 -1000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.14-rc7

for you to fetch changes up to cd0a719fbd702eb4b455a6ad986483750125588a:

  net: dpaa2-switch: disable the control interface on error path (2021-08-19 10:00:59 -0700)

----------------------------------------------------------------
Networking fixes for 5.14-rc7, including fixes from bpf, wireless and
mac80211 trees.

Current release - regressions:

 - tipc: call tipc_wait_for_connect only when dlen is not 0

 - mac80211: fix locking in ieee80211_restart_work()

Current release - new code bugs:

 - bpf: add rcu_read_lock in bpf_get_current_[ancestor_]cgroup_id()

 - ethernet: ice: fix perout start time rounding

 - wwan: iosm: prevent underflow in ipc_chnl_cfg_get()

Previous releases - regressions:

 - bpf: clear zext_dst of dead insns

 - sch_cake: fix srchost/dsthost hashing mode

 - vrf: reset skb conntrack connection on VRF rcv

 - net/rds: dma_map_sg is entitled to merge entries

Previous releases - always broken:

 - ethernet: bnxt: fix Tx path locking and races, add Rx path barriers

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Andy Shevchenko (1):
      ptp_pch: Restore dependency on PCI

Arkadiusz Kubalewski (1):
      i40e: Fix ATR queue selection

Arnd Bergmann (1):
      mt76: fix enum type mismatch

Dan Carpenter (1):
      net: iosm: Prevent underflow in ipc_chnl_cfg_get()

David S. Miller (4):
      Merge branch 'bnxt_en-fixes'
      Merge branch 'mdio-fixes'
      Merge branch 'mptcp-fixes'
      Merge branch 'r8152-bp-settings'

Dinghao Liu (1):
      net: qlcnic: add missed unlock in qlcnic_83xx_flash_read32

Gerd Rausch (1):
      net/rds: dma_map_sg is entitled to merge entries

Hayes Wang (2):
      r8152: fix writing USB_BP2_EN
      r8152: fix the maximum number of PLA bp for RTL8153C

Ido Schimmel (1):
      Revert "flow_offload: action should not be NULL when it is referenced"

Ilya Leoshkevich (2):
      bpf: Clear zext_dst of dead insns
      selftests, bpf: Test that dead ldx_w insns are accepted

Jakub Kicinski (8):
      bnxt: don't lock the tx queue from napi poll
      bnxt: disable napi before canceling DIM
      bnxt: make sure xmit_more + errors does not miss doorbells
      bnxt: count Tx drops
      Merge branch 'bnxt-tx-napi-disabling-resiliency-improvements'
      Merge tag 'wireless-drivers-2021-08-17' of git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers
      Merge https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf
      Merge branch 'intel-wired-lan-driver-updates-2021-08-18'

Jason Wang (1):
      virtio-net: use NETIF_F_GRO_HW instead of NETIF_F_LRO

Johannes Berg (2):
      iwlwifi: pnvm: accept multiple HW-type TLVs
      mac80211: fix locking in ieee80211_restart_work()

Lahav Schlesinger (1):
      vrf: Reset skb conntrack connection on VRF rcv

Maciej Machnikowski (1):
      ice: Fix perout start time rounding

Matthieu Baerts (1):
      mptcp: full fully established support after ADD_ADDR

Michael Chan (2):
      bnxt_en: Disable aRFS if running on 212 firmware
      bnxt_en: Add missing DMA memory barriers

Paolo Abeni (1):
      mptcp: fix memory leak on address flush

Pavel Skripkin (2):
      net: 6pack: fix slab-out-of-bounds in decode_data
      net: asix: fix uninit value bugs

Saravana Kannan (3):
      net: mdio-mux: Delete unnecessary devm_kfree
      net: mdio-mux: Don't ignore memory allocation errors
      net: mdio-mux: Handle -EPROBE_DEFER correctly

Shai Malin (2):
      qed: qed ll2 race condition fixes
      qed: Fix null-pointer dereference in qed_rdma_create_qp()

Sylwester Dziedziuch (1):
      iavf: Fix ping is lost after untrusted VF had tried to change MAC

Toke Høiland-Jørgensen (1):
      sch_cake: fix srchost/dsthost hashing mode

Vladimir Oltean (3):
      net: dsa: sja1105: fix use-after-free after calling of_find_compatible_node, or worse
      net: mscc: ocelot: allow forwarding from bridge ports to the tag_8021q CPU port
      net: dpaa2-switch: disable the control interface on error path

Wang Hai (1):
      ixgbe, xsk: clean up the resources in ixgbe_xsk_pool_enable error path

Xin Long (1):
      tipc: call tipc_wait_for_connect only when dlen is not 0

Yaara Baruch (2):
      iwlwifi: add new SoF with JF devices
      iwlwifi: add new so-jf devices

Yonghong Song (1):
      bpf: Add rcu_read_lock in bpf_get_current_[ancestor_]cgroup_id() helpers

kaixi.fan (1):
      ovs: clear skb->tstamp in forwarding path

 drivers/net/dsa/sja1105/sja1105_mdio.c             |   6 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          | 113 ++++++++++++++-------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |   1 +
 .../net/ethernet/freescale/dpaa2/dpaa2-switch.c    |  36 +++----
 drivers/net/ethernet/intel/i40e/i40e_txrx.c        |   3 +-
 drivers/net/ethernet/intel/iavf/iavf.h             |   1 +
 drivers/net/ethernet/intel/iavf/iavf_main.c        |   1 +
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c    |  47 ++++++++-
 drivers/net/ethernet/intel/ice/ice_ptp.c           |   2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c       |   5 +-
 drivers/net/ethernet/mscc/ocelot.c                 |   1 +
 drivers/net/ethernet/qlogic/qed/qed_ll2.c          |  20 ++++
 drivers/net/ethernet/qlogic/qed/qed_rdma.c         |   3 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c    |   4 +-
 drivers/net/hamradio/6pack.c                       |   6 ++
 drivers/net/mdio/mdio-mux.c                        |  37 ++++---
 drivers/net/usb/asix_common.c                      |  70 ++++++-------
 drivers/net/usb/r8152.c                            |  23 ++++-
 drivers/net/virtio_net.c                           |  14 +--
 drivers/net/vrf.c                                  |   4 +
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.c       |  25 +++--
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |  70 ++++++++++++-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.h    |   3 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.h    |   3 +-
 drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.c          |   7 +-
 drivers/ptp/Kconfig                                |   3 +-
 include/net/flow_offload.h                         |  12 +--
 kernel/bpf/helpers.c                               |  22 ++--
 kernel/bpf/verifier.c                              |   1 +
 net/mac80211/main.c                                |   2 +
 net/mptcp/options.c                                |  10 +-
 net/mptcp/pm_netlink.c                             |  44 +++-----
 net/openvswitch/vport.c                            |   1 +
 net/rds/ib_frmr.c                                  |   4 +-
 net/sched/sch_cake.c                               |   2 +-
 net/tipc/socket.c                                  |   2 +-
 tools/testing/selftests/bpf/verifier/dead_code.c   |  12 +++
 39 files changed, 418 insertions(+), 206 deletions(-)
