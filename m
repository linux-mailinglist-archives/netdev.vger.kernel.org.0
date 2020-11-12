Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE81F2B0D5E
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 20:06:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727161AbgKLTCt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 14:02:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:49202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727151AbgKLTCr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 14:02:47 -0500
Received: from cakuba.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B25A206FB;
        Thu, 12 Nov 2020 19:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605207766;
        bh=qU3FIwF5esnEoUW9gj+mC+tQk8lUt+5mtp1vS7vMdMA=;
        h=From:To:Cc:Subject:Date:From;
        b=QuKean4d6K/BwlHQYRYxw/r1uR7sH2ok4Ewsg6xi64KD+0GrSO8fIehJOh4VgfeMl
         GU9xEMHLO1edM8ncZ80s7cwE9AWxkM983yeIySsKObHxRHaQGkZZ2LNTY9baQeA5fd
         SmXK3NKT1Jk1bGytj/debZ7ZmrCuvxB/WjJTL5Vw=
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking
Date:   Thu, 12 Nov 2020 11:02:45 -0800
Message-Id: <20201112190245.2041381-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit bf3e76289cd28b87f679cd53e26d67fd708d718a:

  Merge branch 'mtd/fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux (2020-11-06 13:08:25 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.10-rc4

for you to fetch changes up to edbc21113bde13ca3d06eec24b621b1f628583dd:

  lan743x: fix use of uninitialized variable (2020-11-12 10:03:16 -0800)

----------------------------------------------------------------
Networking fixes for 5.10-rc4, including fixes from the bpf subtree.

Current release - regressions:

 - arm64: dts: fsl-ls1028a-kontron-sl28: specify in-band mode for ENETC

Current release - bugs in new features:

 - mptcp: provide rmem[0] limit offset to fix oops

Previous release - regressions:

 - IPv6: Set SIT tunnel hard_header_len to zero to fix path MTU
   calculations

 - lan743x: correctly handle chips with internal PHY

 - bpf: Don't rely on GCC __attribute__((optimize)) to disable GCSE

 - mlx5e: Fix VXLAN port table synchronization after function reload

Previous release - always broken:

 - bpf: Zero-fill re-used per-cpu map element

 - net: udp: fix out-of-order packets when forwarding with UDP GSO
             fraglists turned on
   - fix UDP header access on Fast/frag0 UDP GRO
   - fix IP header access and skb lookup on Fast/frag0 UDP GRO

 - ethtool: netlink: add missing netdev_features_change() call

 - net: Update window_clamp if SOCK_RCVBUF is set

 - igc: Fix returning wrong statistics

 - ch_ktls: fix multiple leaks and corner cases in Chelsio TLS offload

 - tunnels: Fix off-by-one in lower MTU bounds for ICMP/ICMPv6 replies

 - r8169: disable hw csum for short packets on all chip versions

 - vrf: Fix fast path output packet handling with async Netfilter rules

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Alexander Lobakin (3):
      ethtool: netlink: add missing netdev_features_change() call
      net: udp: fix UDP header access on Fast/frag0 UDP GRO
      net: udp: fix IP header access and skb lookup on Fast/frag0 UDP GRO

Andrii Nakryiko (2):
      selftest/bpf: Fix profiler test using CO-RE relocation for enums
      bpf: Add struct bpf_redir_neigh forward declaration to BPF helper defs

Ard Biesheuvel (1):
      bpf: Don't rely on GCC __attribute__((optimize)) to disable GCSE

Arnd Bergmann (1):
      bpf: Fix -Wshadow warnings

Aya Levin (1):
      net/mlx5e: Fix VXLAN synchronization after function reload

Dan Carpenter (1):
      i40e, xsk: uninitialized variable in i40e_clean_rx_irq_zc()

David Verbeiren (1):
      bpf: Zero-fill re-used per-cpu map element

Heiner Kallweit (3):
      r8169: fix potential skb double free in an error path
      r8169: disable hw csum for short packets on all chip versions
      net: phy: realtek: support paged operations on RTL8201CP

Ian Rogers (3):
      tools, bpftool: Avoid array index warnings.
      tools, bpftool: Remove two unused variables.
      libbpf, hashmap: Fix undefined behavior in hash_bits

Jakub Kicinski (7):
      Merge git://git.kernel.org/.../bpf/bpf
      Merge tag 'mlx5-fixes-2020-11-03' of git://git.kernel.org/.../saeed/linux
      Merge branch 'net-iucv-fixes-2020-11-09'
      Merge branch 'cxgb4-ch_ktls-fixes-in-nic-tls-code'
      net: switch to the kernel.org patchwork instance
      Merge branch '40GbE' of git://git.kernel.org/.../tnguy/net-queue
      Merge branch 'net-udp-fix-fast-frag0-udp-gro'

Jonathan Neuschäfer (1):
      docs: networking: phy: s/2.5 times faster/2.5 times as fast/

KP Singh (1):
      bpf: Update verification logic for LSM programs

Lorenz Bauer (1):
      tools/bpftool: Fix attaching flow dissector

Magnus Karlsson (3):
      xsk: Fix possible memory leak at socket close
      libbpf: Fix null dereference in xsk_socket__delete
      libbpf: Fix possible use after free in xsk_socket__delete

Mao Wenan (1):
      net: Update window_clamp if SOCK_RCVBUF is set

Maor Dickman (1):
      net/mlx5e: Fix modify header actions memory leak

Maor Gottlieb (1):
      net/mlx5: Fix deletion of duplicate rules

Martin Schiller (1):
      net/x25: Fix null-ptr-deref in x25_connect

Martin Willi (1):
      vrf: Fix fast path output packet handling with async Netfilter rules

Maxim Mikityanskiy (2):
      net/mlx5e: Use spin_lock_bh for async_icosq_lock
      net/mlx5e: Fix incorrect access of RCU-protected xdp_prog

Michael Walle (1):
      arm64: dts: fsl-ls1028a-kontron-sl28: specify in-band mode for ENETC

Oliver Herms (1):
      IPv6: Set SIT tunnel hard_header_len to zero

Paolo Abeni (1):
      mptcp: provide rmem[0] limit

Parav Pandit (2):
      net/mlx5: E-switch, Avoid extack error log for disabled vport
      devlink: Avoid overwriting port attributes of registered port

Paul Moore (1):
      netlabel: fix our progress tracking in netlbl_unlabel_staticlist()

Randy Dunlap (1):
      bpf: BPF_PRELOAD depends on BPF_SYSCALL

Rohit Maheshwari (12):
      cxgb4/ch_ktls: decrypted bit is not enough
      ch_ktls: Correction in finding correct length
      ch_ktls: Update cheksum information
      cxgb4/ch_ktls: creating skbs causes panic
      ch_ktls: Correction in trimmed_len calculation
      ch_ktls: missing handling of header alone
      ch_ktls: Correction in middle record handling
      ch_ktls: packet handling prior to start marker
      ch_ktls: don't free skb before sending FIN
      ch_ktls/cxgb4: handle partial tag alone SKBs
      ch_ktls: tcb update fails sometimes
      ch_ktls: stop the txq if reaches threshold

Slawomir Laba (1):
      i40e: Fix MAC address setting for a VF via Host/VM

Stefano Brivio (1):
      tunnels: Fix off-by-one in lower MTU bounds for ICMP/ICMPv6 replies

Sven Van Asbroeck (3):
      lan743x: correctly handle chips with internal PHY
      lan743x: fix "BUG: invalid wait context" when setting rx mode
      lan743x: fix use of uninitialized variable

Toke Høiland-Jørgensen (1):
      samples/bpf: Set rlimit for memlock to infinity in all samples

Tony Nguyen (1):
      MAINTAINERS: Update repositories for Intel Ethernet Drivers

Ursula Braun (2):
      net/af_iucv: fix null pointer dereference on shutdown
      MAINTAINERS: remove Ursula Braun as s390 network maintainer

Vadym Kochan (1):
      net: marvell: prestera: fix compilation with CONFIG_BRIDGE=m

Vinicius Costa Gomes (1):
      igc: Fix returning wrong statistics

Vlad Buslov (2):
      net/mlx5e: Protect encap route dev from concurrent release
      selftest: fix flower terse dump tests

Wang Hai (2):
      tipc: fix memory leak in tipc_topsrv_start()
      cosa: Add missing kfree in error path of cosa_write

zhangxiaoxu (1):
      net: dsa: mv88e6xxx: Fix memleak in mv88e6xxx_region_atu_snapshot

 Documentation/networking/netdev-FAQ.rst            |   4 +-
 Documentation/networking/phy.rst                   |   4 +-
 Documentation/process/stable-kernel-rules.rst      |   2 +-
 .../it_IT/process/stable-kernel-rules.rst          |   2 +-
 MAINTAINERS                                        |  27 +-
 .../dts/freescale/fsl-ls1028a-kontron-sl28.dts     |   1 +
 drivers/net/dsa/mv88e6xxx/devlink.c                |   4 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h         |   3 +
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c |   2 +
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |   1 +
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h     |   6 +
 drivers/net/ethernet/chelsio/cxgb4/sge.c           | 111 +++-
 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c      | 582 +++++++++++++--------
 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.h      |   1 +
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |  26 +-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c         |   2 +-
 drivers/net/ethernet/intel/igc/igc_main.c          |  14 +-
 drivers/net/ethernet/marvell/prestera/Kconfig      |   1 +
 .../net/ethernet/mellanox/mlx5/core/en/rep/tc.c    |   6 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun.c    |  72 ++-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.c |   4 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/tx.c    |   4 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c |  14 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |   2 -
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   7 +-
 .../net/ethernet/mellanox/mlx5/core/lib/vxlan.c    |  23 +-
 .../net/ethernet/mellanox/mlx5/core/lib/vxlan.h    |   2 +
 drivers/net/ethernet/microchip/lan743x_main.c      |  24 +-
 drivers/net/ethernet/microchip/lan743x_main.h      |   3 -
 drivers/net/ethernet/realtek/r8169_main.c          |  18 +-
 drivers/net/phy/realtek.c                          |   2 +
 drivers/net/vrf.c                                  |  92 +++-
 drivers/net/wan/cosa.c                             |   1 +
 include/linux/compiler-gcc.h                       |   2 -
 include/linux/compiler_types.h                     |   4 -
 include/linux/filter.h                             |  22 +-
 include/net/xsk_buff_pool.h                        |   2 +-
 kernel/bpf/Makefile                                |   6 +-
 kernel/bpf/bpf_lsm.c                               |  10 +-
 kernel/bpf/core.c                                  |   2 +-
 kernel/bpf/hashtab.c                               |  30 +-
 kernel/bpf/preload/Kconfig                         |   1 +
 net/core/devlink.c                                 |   8 +-
 net/ethtool/features.c                             |   2 +-
 net/ipv4/ip_tunnel_core.c                          |   4 +-
 net/ipv4/syncookies.c                              |   9 +-
 net/ipv4/udp_offload.c                             |  19 +-
 net/ipv6/sit.c                                     |   2 -
 net/ipv6/syncookies.c                              |  10 +-
 net/ipv6/udp_offload.c                             |  17 +-
 net/iucv/af_iucv.c                                 |   3 +-
 net/mptcp/protocol.c                               |   1 +
 net/netlabel/netlabel_unlabeled.c                  |  17 +-
 net/tipc/topsrv.c                                  |  10 +-
 net/x25/af_x25.c                                   |   2 +-
 net/xdp/xsk.c                                      |   3 +-
 net/xdp/xsk_buff_pool.c                            |   7 +-
 samples/bpf/task_fd_query_user.c                   |   2 +-
 samples/bpf/tracex2_user.c                         |   2 +-
 samples/bpf/tracex3_user.c                         |   2 +-
 samples/bpf/xdp_redirect_cpu_user.c                |   2 +-
 samples/bpf/xdp_rxq_info_user.c                    |   2 +-
 scripts/bpf_helpers_doc.py                         |   1 +
 tools/bpf/bpftool/feature.c                        |   7 +-
 tools/bpf/bpftool/prog.c                           |   2 +-
 tools/bpf/bpftool/skeleton/profiler.bpf.c          |   4 +-
 tools/lib/bpf/hashmap.h                            |  15 +-
 tools/lib/bpf/xsk.c                                |   9 +-
 tools/testing/selftests/bpf/prog_tests/map_init.c  | 214 ++++++++
 tools/testing/selftests/bpf/progs/profiler.inc.h   |  11 +-
 tools/testing/selftests/bpf/progs/test_map_init.c  |  33 ++
 .../tc-testing/tc-tests/filters/tests.json         |   4 +-
 76 files changed, 1138 insertions(+), 439 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/map_init.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_map_init.c
