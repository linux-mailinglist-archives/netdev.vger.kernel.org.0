Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01C9E4560D1
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 17:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233647AbhKRQqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 11:46:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:38344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232964AbhKRQqS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 11:46:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4AC1C610A5;
        Thu, 18 Nov 2021 16:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637253798;
        bh=eba2Ht3UtKXS0rCd0sbTrn7iAQmc+spvH5BhUf6pN8g=;
        h=From:To:Cc:Subject:Date:From;
        b=U982T9g55kj0lEkJuJ1t/2zka8nxF1+t82LfL60LDFc93ODb+iXfglpzHkFpePqIK
         KnW3PhPvUuzAVR3c/DzuFN9jgpD6GgCjFr5QLymF3jYsrzuXEA+IMMqjkdb4dlvSZh
         kcz1STn0MdZuT6IEBWxHIE9+0Y3JcsRKZPIPaDBtoSuM2luiLVjExJnMQp94Uim8rJ
         1NnQDrIFitHBn/7bTFoljgG2is7DX8V/19Kda/2qEoQqfF65vS9ZpUuCfTuiOEYk7i
         4YdeusrXPZsHsp/6cTawjoKLBJP+CkxnIkacxNIsSH8Pi5rX9DxbMorfvxzISebmTu
         6FaYOj1Tv7Rrg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        johannes@sipsolutions.net
Subject: [GIT PULL] Networking for 5.16-rc2
Date:   Thu, 18 Nov 2021 08:42:53 -0800
Message-Id: <20211118164253.1751486-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

The following changes since commit 66f4beaa6c1d28161f534471484b2daa2de1dce0:

  Merge branch 'linus' of git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6 (2021-11-12 12:35:46 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.16-rc2

for you to fetch changes up to c7521d3aa2fa7fc785682758c99b5bcae503f6be:

  ptp: ocp: Fix a couple NULL vs IS_ERR() checks (2021-11-18 12:12:55 +0000)

----------------------------------------------------------------
Networking fixes for 5.16-rc2, including fixes from bpf, mac80211.

Current release - regressions:

 - devlink: don't throw an error if flash notification sent before
   devlink visible

 - page_pool: Revert "page_pool: disable dma mapping support...",
   turns out there are active arches who need it

Current release - new code bugs:

 - amt: cancel delayed_work synchronously in amt_fini()

Previous releases - regressions:

 - xsk: fix crash on double free in buffer pool

 - bpf: fix inner map state pruning regression causing program
   rejections

 - mac80211: drop check for DONT_REORDER in __ieee80211_select_queue,
   preventing mis-selecting the best effort queue

 - mac80211: do not access the IV when it was stripped

 - mac80211: fix radiotap header generation, off-by-one

 - nl80211: fix getting radio statistics in survey dump

 - e100: fix device suspend/resume

Previous releases - always broken:

 - tcp: fix uninitialized access in skb frags array for Rx 0cp

 - bpf: fix toctou on read-only map's constant scalar tracking

 - bpf: forbid bpf_ktime_get_coarse_ns and bpf_timer_* in tracing progs

 - tipc: only accept encrypted MSG_CRYPTO msgs

 - smc: transfer remaining wait queue entries during fallback,
   fix missing wake ups

 - udp: validate checksum in udp_read_sock() (when sockmap is used)

 - sched: act_mirred: drop dst for the direction from egress to ingress

 - virtio_net_hdr_to_skb: count transport header in UFO, prevent
   allowing bad skbs into the stack

 - nfc: reorder the logic in nfc_{un,}register_device, fix unregister

 - ipsec: check return value of ipv6_skip_exthdr

 - usb: r8152: add MAC passthrough support for more Lenovo Docks

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Aaron Ma (1):
      net: usb: r8152: Add MAC passthrough support for more Lenovo Docks

Akeem G Abodunrin (1):
      iavf: Restore VLAN filters after link down

Alex Elder (2):
      net: ipa: HOLB register sometimes must be written twice
      net: ipa: disable HOLB drop when updating timer

Alexander Lobakin (2):
      samples/bpf: Fix summary per-sec stats in xdp_sample_user
      samples/bpf: Fix build error due to -isystem removal

Alexei Starovoitov (2):
      bpf: Fix inner map state pruning regression.
      Merge branch 'Forbid bpf_ktime_get_coarse_ns and bpf_timer_* in tracing progs'

Arjun Roy (1):
      tcp: Fix uninitialized access in skb frags array for Rx 0cp.

Avihai Horon (1):
      net/mlx5: Fix flow counters SF bulk query len

Cong Wang (1):
      udp: Validate checksum in udp_read_sock()

Dan Carpenter (2):
      octeontx2-af: debugfs: don't corrupt user memory
      ptp: ocp: Fix a couple NULL vs IS_ERR() checks

Daniel Borkmann (1):
      bpf: Fix toctou on read-only map's constant scalar tracking

David S. Miller (5):
      Merge branch 'net-ipa-fixes'
      Merge branch 'bnxt_en-fixes'
      Merge branch '40GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      Merge tag 'mlx5-fixes-2021-11-16' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge branch '40GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net- queue

Davide Caratti (1):
      selftests: add a test case for mirred egress to ingress

Dmitrii Banshchikov (2):
      bpf: Forbid bpf_ktime_get_coarse_ns and bpf_timer_* in tracing progs
      selftests/bpf: Add tests for restricted helpers

Edwin Peer (2):
      bnxt_en: extend RTNL to VF check in devlink driver_reinit
      bnxt_en: fix format specifier in live patch error message

Eryk Rybak (3):
      i40e: Fix correct max_pkt_size on VF RX queue
      i40e: Fix changing previously set num_queue_pairs for PFs
      i40e: Fix ping is lost after configuring ADq on VF

Felix Fietkau (2):
      mac80211: drop check for DONT_REORDER in __ieee80211_select_queue
      mac80211: fix throughput LED trigger

Grzegorz Szczurek (2):
      iavf: Fix for setting queues to 0
      i40e: Fix display error code in dmesg

Jacob Keller (1):
      iavf: prevent accidental free of filter structure

Jakub Kicinski (5):
      selftests: net: switch to socat in the GSO GRE test
      ethernet: sis900: fix indentation
      Merge https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf
      Merge tag 'mac80211-for-net-2021-11-16' of git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211
      Merge branch 'net-fix-the-mirred-packet-drop-due-to-the-incorrect-dst'

Jean-Philippe Brucker (1):
      tools/runqslower: Fix cross-build

Jedrzej Jagielski (1):
      i40e: Fix creation of first queue by omitting it if is not power of two

Jesse Brandeburg (1):
      e100: fix device suspend/resume

Jiapeng Chong (1):
      net: Clean up some inconsistent indenting

Johannes Berg (3):
      nl80211: fix radio statistics in survey dump
      mac80211: fix radiotap header generation
      mac80211: fix monitor_sdata RCU/locking assertions

Jonathan Davies (1):
      net: virtio_net_hdr_to_skb: count transport header in UFO

Jordy Zomer (1):
      ipv6: check return value of ipv6_skip_exthdr

Karen Sornek (1):
      i40e: Fix warning message and call stack during rmmod i40e driver

Konrad Dybcio (1):
      net/ipa: ipa_resource: Fix wrong for loop range

Kumar Kartikeya Dwivedi (2):
      samples/bpf: Fix incorrect use of strlen in xdp_redirect_cpu
      libbpf: Perform map fd cleanup for gen_loader in case of error

Leon Romanovsky (1):
      devlink: Don't throw an error if flash notification sent before devlink visible

Lin Ma (4):
      hamradio: remove needs_free_netdev to avoid UAF
      NFC: reorganize the functions in nci_request
      NFC: reorder the logic in nfc_{un,}register_device
      NFC: add NCI_UNREG flag to eliminate the race

Lorenz Bauer (1):
      selftests/bpf: Check map in map pruning

Magnus Karlsson (1):
      xsk: Fix crash on double free in buffer pool

Maher Sanalla (1):
      net/mlx5: Lag, update tracker when state change event received

Marcin Wojtas (1):
      net: mvmdio: fix compilation warning

Mark Bloch (1):
      net/mlx5: E-Switch, rebuild lag only when needed

Mateusz Palczewski (1):
      iavf: Fix return of set the new channel count

Meng Li (1):
      net: stmmac: socfpga: add runtime suspend/resume callback for stratix10 platform

Michael Chan (1):
      bnxt_en: Fix compile error regression when CONFIG_BNXT_SRIOV is not set

Michal Maloszewski (1):
      i40e: Fix NULL ptr dereference on VSI filter sync

Mitch Williams (1):
      iavf: validate pointers

Neta Ostrovsky (1):
      net/mlx5: Update error handler for UCTX and UMEM

Nguyen Dinh Phi (1):
      cfg80211: call cfg80211_stop_ap when switch from P2P_GO type

Nicholas Nunley (3):
      iavf: check for null in iavf_fix_features
      iavf: free q_vectors before queues in iavf_disable_vf
      iavf: don't clear a lock we don't hold

Nicolas Dichtel (1):
      tun: fix bonding active backup with arp monitoring

Paul Blakey (1):
      net/mlx5: E-Switch, Fix resetting of encap mode when entering switchdev

Paul Moore (1):
      net,lsm,selinux: revert the security_sctp_assoc_established() hook

Pavel Skripkin (3):
      net: bnx2x: fix variable dereferenced before check
      MAINTAINERS: remove GR-everest-linux-l2@marvell.com
      net: dpaa2-eth: fix use-after-free in dpaa2_eth_remove

Piotr Marczak (1):
      iavf: Fix failure to exit out from last all-multicast mode

Raed Salem (1):
      net/mlx5: E-Switch, return error if encap isn't supported

Randy Dunlap (2):
      ptp: ptp_clockmatrix: repair non-kernel-doc comment
      net: ethernet: lantiq_etop: fix build errors/warnings

Roi Dayan (1):
      net/mlx5e: CT, Fix multiple allocations and memleak of mod acts

Sriharsha Basavapatna (1):
      bnxt_en: reject indirect blk offload when hw-tc-offload is off

Surabhi Boob (1):
      iavf: Fix for the false positive ASQ/ARQ errors while issuing VF reset

Tadeusz Struk (2):
      tipc: use consistent GFP flags
      tipc: check for null after calling kmemdup

Taehee Yoo (1):
      amt: cancel delayed_work synchronously in amt_fini()

Tariq Toukan (1):
      net/mlx5e: kTLS, Fix crash in RX resync flow

Teng Qi (2):
      ethernet: hisilicon: hns: hns_dsaf_misc: fix a possible array overflow in hns_dsaf_ge_srst_by_port()
      net: ethernet: dec: tulip: de4x5: fix possible array overflows in type3_infoblock()

Tetsuo Handa (1):
      sock: fix /proc/net/sockstat underflow in sk_clone_lock()

Thomas Gleixner (1):
      net: stmmac: Fix signed/unsigned wreckage

Valentine Fatiev (1):
      net/mlx5e: nullify cq->dbg pointer in mlx5_debug_cq_remove()

Vlad Buslov (1):
      net/mlx5e: Wait for concurrent flow deletion during neigh/fib events

Wen Gu (2):
      net/smc: Transfer remaining wait queue entries during fallback
      net/smc: Make sure the link_id is unique

Xin Long (2):
      tipc: only accept encrypted MSG_CRYPTO msgs
      net: sched: act_mirred: drop dst for the direction from egress to ingress

Xing Song (1):
      mac80211: do not access the IV when it was stripped

Yevgeny Kliteynik (2):
      net/mlx5: DR, Handle eswitch manager and uplink vports separately
      net/mlx5: DR, Fix check for unsupported fields in match param

Yunsheng Lin (1):
      page_pool: Revert "page_pool: disable dma mapping support..."

Zekun Shen (1):
      atlantic: Fix OOB read and write in hw_atl_utils_fw_rpc_wait

liuguoqiang (1):
      net: return correct error code

zhangyue (1):
      net: tulip: de4x5: fix the problem that the array 'lp->phy[8]' may be out of bound

Łukasz Stelmach (1):
      net: ax88796c: use bit numbers insetad of bit masks

 Documentation/security/SCTP.rst                    |  22 +--
 MAINTAINERS                                        |   4 +-
 drivers/net/amt.c                                  |   2 +-
 .../aquantia/atlantic/hw_atl/hw_atl_utils.c        |  10 ++
 drivers/net/ethernet/asix/ax88796c_main.h          |   6 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_init_ops.h   |   4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |  10 ++
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c  |   9 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c       |   2 +-
 drivers/net/ethernet/dec/tulip/de4x5.c             |  34 ++--
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |   4 +-
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c |   4 +
 drivers/net/ethernet/intel/e100.c                  |  18 +-
 drivers/net/ethernet/intel/i40e/i40e.h             |   2 +
 drivers/net/ethernet/intel/i40e/i40e_main.c        | 160 +++++++++++------
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 121 +++++--------
 drivers/net/ethernet/intel/iavf/iavf.h             |   1 +
 drivers/net/ethernet/intel/iavf/iavf_ethtool.c     |  30 +++-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |  55 ++++--
 drivers/net/ethernet/lantiq_etop.c                 |  20 ++-
 drivers/net/ethernet/marvell/mvmdio.c              |   2 +
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    |  17 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/cq.c       |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/debugfs.c  |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |  26 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h |   2 +
 .../net/ethernet/mellanox/mlx5/core/en/tc_priv.h   |   1 +
 .../ethernet/mellanox/mlx5/core/en/tc_tun_encap.c  |   8 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c |  23 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  10 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |  21 ++-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |   9 +-
 .../net/ethernet/mellanox/mlx5/core/fs_counters.c  |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c  |  28 ++-
 .../mellanox/mlx5/core/steering/dr_domain.c        |  56 +++---
 .../mellanox/mlx5/core/steering/dr_matcher.c       |  11 +-
 .../mellanox/mlx5/core/steering/dr_types.h         |   1 +
 drivers/net/ethernet/sis/sis900.c                  |   2 +-
 .../net/ethernet/stmicro/stmmac/dwmac-socfpga.c    |  24 ++-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  23 ++-
 drivers/net/hamradio/6pack.c                       |   1 -
 drivers/net/ipa/ipa_endpoint.c                     |   5 +
 drivers/net/ipa/ipa_resource.c                     |   2 +-
 drivers/net/tun.c                                  |   5 +
 drivers/net/usb/r8152.c                            |   9 +-
 drivers/ptp/ptp_clockmatrix.c                      |   5 +-
 drivers/ptp/ptp_ocp.c                              |   9 +-
 include/linux/bpf.h                                |   3 +-
 include/linux/lsm_hook_defs.h                      |   2 -
 include/linux/lsm_hooks.h                          |   5 -
 include/linux/mlx5/eswitch.h                       |   4 +-
 include/linux/mm_types.h                           |  13 +-
 include/linux/security.h                           |   7 -
 include/linux/skbuff.h                             |   2 +-
 include/linux/virtio_net.h                         |   7 +-
 include/net/nfc/nci_core.h                         |   1 +
 include/net/page_pool.h                            |  12 +-
 kernel/bpf/cgroup.c                                |   2 +
 kernel/bpf/helpers.c                               |   2 -
 kernel/bpf/syscall.c                               |  57 +++---
 kernel/bpf/verifier.c                              |  27 ++-
 kernel/trace/bpf_trace.c                           |   2 -
 net/core/devlink.c                                 |   4 +-
 net/core/filter.c                                  |   6 +
 net/core/page_pool.c                               |  10 +-
 net/core/sock.c                                    |   6 +-
 net/ipv4/bpf_tcp_ca.c                              |   2 +
 net/ipv4/devinet.c                                 |   2 +-
 net/ipv4/tcp.c                                     |   3 +
 net/ipv4/udp.c                                     |  11 ++
 net/ipv6/esp6.c                                    |   6 +
 net/mac80211/cfg.c                                 |  12 +-
 net/mac80211/iface.c                               |   4 +-
 net/mac80211/led.h                                 |   8 +-
 net/mac80211/rx.c                                  |  12 +-
 net/mac80211/tx.c                                  |  34 ++--
 net/mac80211/util.c                                |   7 +-
 net/mac80211/wme.c                                 |   3 +-
 net/nfc/core.c                                     |  32 ++--
 net/nfc/nci/core.c                                 |  30 +++-
 net/sched/act_mirred.c                             |  11 +-
 net/sctp/sm_statefuns.c                            |   2 +-
 net/smc/af_smc.c                                   |  14 ++
 net/smc/smc_core.c                                 |   3 +-
 net/tipc/crypto.c                                  |  12 +-
 net/tipc/link.c                                    |   7 +-
 net/wireless/nl80211.c                             |  34 ++--
 net/wireless/nl80211.h                             |   6 +-
 net/wireless/util.c                                |   1 +
 net/xdp/xsk_buff_pool.c                            |   7 +-
 samples/bpf/hbm_kern.h                             |   2 -
 samples/bpf/xdp_redirect_cpu_user.c                |   5 +-
 samples/bpf/xdp_sample_user.c                      |  28 +--
 security/security.c                                |   7 -
 security/selinux/hooks.c                           |  14 +-
 tools/bpf/runqslower/Makefile                      |   3 +-
 tools/lib/bpf/bpf_gen_internal.h                   |   4 +-
 tools/lib/bpf/gen_loader.c                         |  47 +++--
 tools/lib/bpf/libbpf.c                             |   4 +-
 tools/testing/selftests/bpf/Makefile               |   2 +-
 .../selftests/bpf/prog_tests/helper_restricted.c   |  33 ++++
 .../selftests/bpf/progs/test_helper_restricted.c   | 123 +++++++++++++
 tools/testing/selftests/bpf/test_verifier.c        |  46 ++++-
 .../selftests/bpf/verifier/helper_restricted.c     | 196 +++++++++++++++++++++
 tools/testing/selftests/bpf/verifier/map_in_map.c  |  34 ++++
 tools/testing/selftests/net/forwarding/config      |   1 +
 .../testing/selftests/net/forwarding/tc_actions.sh |  47 ++++-
 tools/testing/selftests/net/gre_gso.sh             |  16 +-
 109 files changed, 1328 insertions(+), 552 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/helper_restricted.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_helper_restricted.c
 create mode 100644 tools/testing/selftests/bpf/verifier/helper_restricted.c
