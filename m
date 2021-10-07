Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 812574256F4
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 17:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242506AbhJGPrk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 11:47:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:50594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240964AbhJGPri (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 11:47:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 724E46113E;
        Thu,  7 Oct 2021 15:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633621544;
        bh=PbNnO8/x11PPJ0zGrulpmjn6kvycHwbf+J7Lsu05J1M=;
        h=From:To:Cc:Subject:Date:From;
        b=QFg7baxdj6htzey0nWGSlmLikIYy+JTvSyqBAPBNk7qjwaVtkALRktWMgqRIdMAVN
         yokjQIb2uMZufaN3hV4AN4g8gfHAPTwBIQ2RIAoO460r3betF3lBi4AvGFIv11FAxv
         gY9Aq8qRNE2q2bX4qs4SP33ip9zfR81+T2mFWi97BOUZDrmn+urdb8bqHwAQyWBs92
         LtrWGLE4FMzxP2mB09qvf2cEFSrpsgEQbpRYfTXu1JbjQ9mWl/bPBEmTnC+mLIb9oK
         TL2BjfgJaiNYNq9Q6VpFDqeH2kR8BwriWmQFzp9c7idd7rYseHVYAUWOalf1ajjPdY
         KAChOT5Q/8Dbw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, daniel@iogearbox.net,
        steffen.klassert@secunet.com, kvalo@codeaurora.org,
        pablo@netfilter.org
Subject: [GIT PULL] Networking for 5.15-rc5
Date:   Thu,  7 Oct 2021 08:45:20 -0700
Message-Id: <20211007154520.3189432-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

The following changes since commit 4de593fb965fc2bd11a0b767e0c65ff43540a6e4:

  Merge tag 'net-5.15-rc4' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2021-09-30 14:28:05 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.15-rc5

for you to fetch changes up to 8d6c414cd2fb74aa6812e9bfec6178f8246c4f3a:

  net: prefer socket bound to interface when not in VRF (2021-10-07 07:27:55 -0700)

----------------------------------------------------------------
Networking fixes for 5.15-rc5, including fixes from xfrm, bpf,
netfilter, and wireless.

Current release - regressions:

 - xfrm: fix XFRM_MSG_MAPPING ABI breakage caused by inserting
   a new value in the middle of an enum

 - unix: fix an issue in unix_shutdown causing the other end
   read/write failures

 - phy: mdio: fix memory leak

Current release - new code bugs:

 - mlx5e: improve MQPRIO resiliency against bad configs

Previous releases - regressions:

 - bpf: fix integer overflow leading to OOB access in map element
   pre-allocation

 - stmmac: dwmac-rk: fix ethernet on rk3399 based devices

 - netfilter: conntrack: fix boot failure with nf_conntrack.enable_hooks=1

 - brcmfmac: revert using ISO3166 country code and 0 rev as fallback

 - i40e: fix freeing of uninitialized misc IRQ vector

 - iavf: fix double unlock of crit_lock

Previous releases - always broken:

 - bpf, arm: fix register clobbering in div/mod implementation

 - netfilter: nf_tables: correct issues in netlink rule change
   event notifications

 - dsa: tag_dsa: fix mask for trunked packets

 - usb: r8152: don't resubmit rx immediately to avoid soft lockup
   on device unplug

 - i40e: fix endless loop under rtnl if FW fails to correctly
   respond to capability query

 - mlx5e: fix rx checksum offload coexistence with ipsec offload

 - mlx5: force round second at 1PPS out start time and allow it
   only in supported clock modes

 - phy: pcs: xpcs: fix incorrect CL37 AN sequence, EEE disable
   sequence

Misc:

 - xfrm: slightly rejig the new policy uAPI to make it less cryptic

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Andrew Lunn (1):
      dsa: tag_dsa: Fix mask for trunked packets

Andrii Nakryiko (1):
      libbpf: Fix memory leak in strset

Andy Shevchenko (1):
      ptp_pch: Load module automatically if ID matches

Arnd Bergmann (2):
      ath5k: fix building with LEDS=m
      mwifiex: avoid null-pointer-subtraction warning

Aya Levin (3):
      net/mlx5: Force round second at 1PPS out start time
      net/mlx5: Avoid generating event after PPS out in Real time mode
      net/mlx5e: Mutually exclude setting of TX-port-TS and MQPRIO in channel mode

Catherine Sullivan (2):
      gve: Correct available tx qpl check
      gve: Properly handle errors in gve_assign_qpl

Dan Carpenter (2):
      iwlwifi: mvm: d3: Fix off by ones in iwl_mvm_wowlan_get_rsc_v5_data()
      iwlwifi: mvm: d3: missing unlock in iwl_mvm_wowlan_program_keys()

David S. Miller (7):
      Merge tag 'wireless-drivers-2021-10-01' of git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers
      Merge tag 'mlx5-fixes-2021-09-30' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf
      Merge branch 'bridge-fixes'
      Merge branch 'stmmac-eee-fix'
      Merge branch '40GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net- queue
      Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ ipsec

Eric Dumazet (9):
      net: add kerneldoc comment for sk_peer_lock
      net_sched: fix NULL deref in fifo_set_limit()
      net: bridge: use nla_total_size_64bit() in br_get_linkxstats_size()
      net: bridge: fix under estimation in br_get_linkxstats_size()
      net/sched: sch_taprio: properly cancel timer from taprio_destroy()
      netlink: annotate data races around nlk->bound
      rtnetlink: fix if_nlmsg_stats_size() under estimation
      gve: fix gve_get_stats()
      gve: report 64bit tx_bytes counter from gve_handle_report_stats()

Eugene Syromiatnikov (1):
      include/uapi/linux/xfrm.h: Fix XFRM_MSG_MAPPING ABI breakage

Florian Westphal (1):
      netfilter: conntrack: fix boot failure with nf_conntrack.enable_hooks=1

Hayes Wang (1):
      r8152: avoid to resubmit rx immediately

Ilan Peer (1):
      iwlwifi: mvm: Fix possible NULL dereference

Jakub Kicinski (2):
      etherdevice: use __dev_addr_set()
      Merge https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf

Jiang Wang (1):
      unix: Fix an issue in unix_shutdown causing the other end read/write failures

Jiri Benc (1):
      i40e: fix endless loop under rtnl

Johan Almbladh (1):
      bpf, arm: Fix register clobbering in div/mod implementation

Krzysztof Kozlowski (1):
      MAINTAINERS: Move Daniel Drake to credits

Kumar Kartikeya Dwivedi (2):
      samples: bpf: Fix vmlinux.h generation for XDP samples
      libbpf: Fix segfault in light skeleton for objects without BTF

Lama Kayal (1):
      net/mlx5e: Fix the presented RQ index in PTP stats

Leon Romanovsky (1):
      MAINTAINERS: Remove Bin Luo as his email bounces

Luca Boccassi (1):
      samples/bpf: Relicense bpf_insn.h as GPL-2.0-only OR BSD-2-Clause

Marcel Ziswiler (1):
      dt-bindings: net: dsa: marvell: fix compatible in example

Mike Manning (1):
      net: prefer socket bound to interface when not in VRF

Moshe Shemesh (1):
      net/mlx5: E-Switch, Fix double allocation of acl flow counter

Nicolas Dichtel (3):
      xfrm: make user policy API complete
      xfrm: notify default policy on update
      xfrm: fix rcu lock in xfrm_notify_userpolicy()

Pablo Neira Ayuso (3):
      netfilter: nf_tables: add position handle in event notification
      netfilter: nf_tables: reverse order in rule replacement expansion
      netfilter: nf_tables: honor NLM_F_CREATE and NLM_F_EXCL in event notification

Pali Rohár (1):
      powerpc/fsl/dts: Fix phy-connection-type for fm1mac3

Pavel Skripkin (3):
      net: xfrm: fix shift-out-of-bounds in xfrm_get_default
      Revert "net: mdiobus: Fix memory leak in __mdiobus_register"
      phy: mdio: fix memory leak

Punit Agrawal (1):
      net: stmmac: dwmac-rk: Fix ethernet on rk3399 based devices

Raed Salem (1):
      net/mlx5e: IPSEC RX, enable checksum complete

Sean Anderson (1):
      net: sfp: Fix typo in state machine debug string

Shannon Nelson (1):
      ionic: move filter sync_needed bit set

Shay Drory (2):
      net/mlx5: Fix length of irq_index in chars
      net/mlx5: Fix setting number of EQs of SFs

Soeren Moch (1):
      Revert "brcmfmac: use ISO3166 country code and 0 rev as fallback"

Stefan Assmann (1):
      iavf: fix double unlock of crit_lock

Steffen Klassert (1):
      Merge branch 'xfrm: fix uapi for the default policy'

Sylwester Dziedziuch (1):
      i40e: Fix freeing of uninitialized misc IRQ vector

Tao Liu (1):
      gve: Avoid freeing NULL pointer

Tariq Toukan (2):
      net/mlx5e: Keep the value for maximum number of channels in-sync
      net/mlx5e: Improve MQPRIO resiliency

Tatsuhiko Yasumatsu (1):
      bpf: Fix integer overflow in prealloc_elems_and_freelist()

Vladimir Oltean (1):
      net: mscc: ocelot: fix VCAP filters remaining active after being deleted

Vladimir Zapolskiy (1):
      iwlwifi: pcie: add configuration of a Wi-Fi adapter on Dell XPS 15

Wong Vee Khee (3):
      net: pcs: xpcs: fix incorrect CL37 AN sequence
      net: pcs: xpcs: fix incorrect steps on disable EEE
      net: stmmac: trigger PCS EEE to turn off on link down

 CREDITS                                            |   1 +
 .../devicetree/bindings/net/dsa/marvell.txt        |   2 +-
 MAINTAINERS                                        |   5 +-
 arch/arm/net/bpf_jit_32.c                          |  19 +++
 arch/powerpc/boot/dts/fsl/t1023rdb.dts             |   2 +-
 drivers/net/ethernet/google/gve/gve.h              |   2 +-
 drivers/net/ethernet/google/gve/gve_main.c         |  45 ++++--
 drivers/net/ethernet/google/gve/gve_rx.c           |   8 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |   5 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |   1 -
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  12 +-
 .../ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c   |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h   |   2 +
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  11 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 178 +++++++++++++++------
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |   7 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |  11 +-
 .../mellanox/mlx5/core/esw/acl/egress_lgcy.c       |  12 +-
 .../mellanox/mlx5/core/esw/acl/ingress_lgcy.c      |   4 +-
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |   4 +-
 .../net/ethernet/mellanox/mlx5/core/lib/clock.c    |  37 ++---
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c  |   9 +-
 drivers/net/ethernet/mscc/ocelot_vcap.c            |   4 +-
 drivers/net/ethernet/pensando/ionic/ionic_lif.c    |   4 +-
 .../net/ethernet/pensando/ionic/ionic_rx_filter.c  |   3 -
 drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c     |   5 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   6 +-
 drivers/net/pcs/pcs-xpcs.c                         |  45 ++++--
 drivers/net/phy/mdio_bus.c                         |   8 +-
 drivers/net/phy/sfp.c                              |   2 +-
 drivers/net/usb/r8152.c                            |  16 +-
 drivers/net/wireless/ath/ath5k/Kconfig             |   4 +-
 drivers/net/wireless/ath/ath5k/led.c               |  10 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |  17 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |   5 +-
 .../net/wireless/intel/iwlwifi/mvm/time-event.c    |   3 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |   2 +
 drivers/net/wireless/marvell/mwifiex/sta_tx.c      |   4 +-
 drivers/net/wireless/marvell/mwifiex/uap_txrx.c    |   4 +-
 drivers/ptp/ptp_pch.c                              |   1 +
 include/linux/etherdevice.h                        |   2 +-
 include/net/netfilter/ipv6/nf_defrag_ipv6.h        |   1 -
 include/net/netfilter/nf_tables.h                  |   2 +-
 include/net/netns/netfilter.h                      |   6 +
 include/net/sock.h                                 |   1 +
 include/soc/mscc/ocelot_vcap.h                     |   4 +-
 include/uapi/linux/xfrm.h                          |  15 +-
 kernel/bpf/stackmap.c                              |   3 +-
 net/bridge/br_netlink.c                            |   3 +-
 net/core/rtnetlink.c                               |   2 +-
 net/dsa/tag_dsa.c                                  |   2 +-
 net/ipv4/inet_hashtables.c                         |   4 +-
 net/ipv4/netfilter/nf_defrag_ipv4.c                |  30 ++--
 net/ipv4/udp.c                                     |   3 +-
 net/ipv6/inet6_hashtables.c                        |   2 +-
 net/ipv6/netfilter/nf_conntrack_reasm.c            |   2 +-
 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c          |  25 ++-
 net/ipv6/udp.c                                     |   3 +-
 net/netfilter/nf_tables_api.c                      |  91 +++++++----
 net/netfilter/nft_quota.c                          |   2 +-
 net/netlink/af_netlink.c                           |  14 +-
 net/sched/sch_fifo.c                               |   3 +
 net/sched/sch_taprio.c                             |   4 +
 net/unix/af_unix.c                                 |   9 +-
 net/xfrm/xfrm_user.c                               |  67 ++++++--
 samples/bpf/Makefile                               |  17 +-
 samples/bpf/bpf_insn.h                             |   2 +-
 samples/bpf/xdp_redirect_map_multi.bpf.c           |   5 -
 security/selinux/nlmsgtab.c                        |   4 +-
 tools/lib/bpf/libbpf.c                             |   3 +-
 tools/lib/bpf/strset.c                             |   1 +
 73 files changed, 566 insertions(+), 298 deletions(-)
