Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C55A3B6AD0
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 00:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235643AbhF1WIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 18:08:22 -0400
Received: from www62.your-server.de ([213.133.104.62]:59050 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234077AbhF1WIR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 18:08:17 -0400
Received: from 30.101.7.85.dynamic.wline.res.cust.swisscom.ch ([85.7.101.30] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lxzO1-0003HJ-8B; Tue, 29 Jun 2021 00:05:49 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        andrii@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf-next 2021-06-28
Date:   Tue, 29 Jun 2021 00:05:48 +0200
Message-Id: <20210628220548.622-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26215/Mon Jun 28 13:09:26 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 37 non-merge commits during the last 12 day(s) which contain
a total of 56 files changed, 394 insertions(+), 380 deletions(-).

The main changes are:

1) XDP driver RCU cleanups, from Toke Høiland-Jørgensen and Paul E. McKenney.

2) Fix bpf_skb_change_proto() IPv4/v6 GSO handling, from Maciej Żenczykowski.

3) Fix false positive kmemleak report for BPF ringbuf alloc, from Rustam Kovhaev.

4) Fix x86 JIT's extable offset calculation for PROBE_LDX NULL, from Ravi Bangoria.

5) Enable libbpf fallback probing with tracing under RHEL7, from Jonathan Edwards.

6) Clean up x86 JIT to remove unused cnt tracking from EMIT macro, from Jiri Olsa.

7) Netlink cleanups for libbpf to please Coverity, from Kumar Kartikeya Dwivedi.

8) Allow to retrieve ancestor cgroup id in tracing programs, from Namhyung Kim.

9) Fix lirc BPF program query to use user-provided prog_cnt, from Sean Young.

10) Add initial libbpf doc including generated kdoc for its API, from Grant Seltzer.

11) Make xdp_rxq_info_unreg_mem_model() more robust, from Jakub Kicinski.

12) Fix up bpfilter startup log-level to info level, from Gary Lin.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Andrii Nakryiko, Camelia Groza, Dmitrii Banshchikov, Edward Cree, 
Grygorii Strashko, Ilias Apalodimas, Jesper Dangaard Brouer, Magnus 
Karlsson, Martin KaFai Lau, Martin Loviska, Simon Horman, Tariq Toukan, 
Toke Høiland-Jørgensen

----------------------------------------------------------------

The following changes since commit 8fe088bd4fd12f4c8899b51d5bc3daad98767d49:

  Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue (2021-06-17 12:11:28 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to a78cae2476812cecaa4a33d0086bbb53986906bc:

  xdp: Move the rxq_info.mem clearing to unreg_mem_model() (2021-06-28 23:07:59 +0200)

----------------------------------------------------------------
Andrii Nakryiko (1):
      selftests/bpf: Fix ringbuf test fetching map FD

Gary Lin (1):
      bpfilter: Specify the log level for the kmsg message

Grant Seltzer (1):
      bpf: Add documentation for libbpf including API autogen

Ilya Maximets (1):
      docs, af_xdp: Consistent indentation in examples

Jakub Kicinski (1):
      xdp: Move the rxq_info.mem clearing to unreg_mem_model()

Jiri Olsa (1):
      bpf, x86: Remove unused cnt increase from EMIT macro

Jonathan Edwards (1):
      libbpf: Add extra BPF_PROG_TYPE check to bpf_object__probe_loading

Kumar Kartikeya Dwivedi (2):
      libbpf: Add request buffer type for netlink messages
      libbpf: Switch to void * casting in netlink helpers

Maciej Żenczykowski (3):
      Revert "bpf: Check for BPF_F_ADJ_ROOM_FIXED_GSO when bpf_skb_change_proto"
      bpf: Do not change gso_size during bpf_skb_change_proto()
      bpf: Support all gso types in bpf_skb_change_proto()

Namhyung Kim (1):
      bpf: Allow bpf_get_current_ancestor_cgroup_id for tracing

Paul E. McKenney (2):
      rcu: Create an unrcu_pointer() to remove __rcu from a pointer
      doc: Clarify and expand RCU updaters and corresponding readers

Ravi Bangoria (1):
      bpf, x86: Fix extable offset calculation

Rustam Kovhaev (1):
      bpf: Fix false positive kmemleak report in bpf_ringbuf_area_alloc()

Sean Young (1):
      media, bpf: Do not copy more entries than user space requested

Toke Høiland-Jørgensen (17):
      doc: Give XDP as example of non-obvious RCU reader/updater pairing
      bpf: Allow RCU-protected lookups to happen from bh context
      xdp: Add proper __rcu annotations to redirect map entries
      bpf, sched: Remove unneeded rcu_read_lock() around BPF program invocation
      ena: Remove rcu_read_lock() around XDP program invocation
      bnxt: Remove rcu_read_lock() around XDP program invocation
      thunderx: Remove rcu_read_lock() around XDP program invocation
      freescale: Remove rcu_read_lock() around XDP program invocation
      intel: Remove rcu_read_lock() around XDP program invocation
      marvell: Remove rcu_read_lock() around XDP program invocation
      mlx4: Remove rcu_read_lock() around XDP program invocation
      nfp: Remove rcu_read_lock() around XDP program invocation
      qede: Remove rcu_read_lock() around XDP program invocation
      sfc: Remove rcu_read_lock() around XDP program invocation
      netsec: Remove rcu_read_lock() around XDP program invocation
      stmmac: Remove rcu_read_lock() around XDP program invocation
      ti: Remove rcu_read_lock() around XDP program invocation

Wang Hai (2):
      samples/bpf: Fix Segmentation fault for xdp_redirect command
      samples/bpf: Fix the error return code of xdp_redirect's main()

 Documentation/RCU/checklist.rst                    |  55 ++++++----
 Documentation/bpf/index.rst                        |  13 +++
 Documentation/bpf/libbpf/libbpf.rst                |  14 +++
 Documentation/bpf/libbpf/libbpf_api.rst            |  27 +++++
 Documentation/bpf/libbpf/libbpf_build.rst          |  37 +++++++
 .../bpf/libbpf/libbpf_naming_convention.rst        |  30 +++---
 Documentation/networking/af_xdp.rst                |  32 +++---
 arch/x86/net/bpf_jit_comp.c                        |  46 +++------
 drivers/media/rc/bpf-lirc.c                        |   3 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c       |   3 -
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c      |   2 -
 drivers/net/ethernet/cavium/thunder/nicvf_main.c   |   2 -
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c     |   8 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |   3 -
 drivers/net/ethernet/intel/i40e/i40e_txrx.c        |   2 -
 drivers/net/ethernet/intel/i40e/i40e_xsk.c         |   3 -
 drivers/net/ethernet/intel/ice/ice_txrx.c          |   6 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c           |   3 -
 drivers/net/ethernet/intel/igb/igb_main.c          |   2 -
 drivers/net/ethernet/intel/igc/igc_main.c          |   7 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |   2 -
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c       |   3 -
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c  |   2 -
 drivers/net/ethernet/marvell/mvneta.c              |   2 -
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |   4 -
 drivers/net/ethernet/mellanox/mlx4/en_rx.c         |   8 +-
 .../net/ethernet/netronome/nfp/nfp_net_common.c    |   2 -
 drivers/net/ethernet/qlogic/qede/qede_fp.c         |   6 --
 drivers/net/ethernet/sfc/rx.c                      |   9 +-
 drivers/net/ethernet/socionext/netsec.c            |   3 -
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  10 +-
 drivers/net/ethernet/ti/cpsw_priv.c                |  10 +-
 include/linux/filter.h                             |   8 +-
 include/linux/rcupdate.h                           |  14 +++
 include/net/xdp_sock.h                             |   2 +-
 kernel/bpf/cpumap.c                                |  13 ++-
 kernel/bpf/devmap.c                                |  49 ++++-----
 kernel/bpf/hashtab.c                               |  21 ++--
 kernel/bpf/helpers.c                               |   6 +-
 kernel/bpf/lpm_trie.c                              |   6 +-
 kernel/bpf/ringbuf.c                               |   2 +
 kernel/trace/bpf_trace.c                           |   2 +
 net/bpfilter/main.c                                |   2 +-
 net/core/filter.c                                  |  72 ++++++-------
 net/core/xdp.c                                     |  11 +-
 net/sched/act_bpf.c                                |   2 -
 net/sched/cls_bpf.c                                |   3 -
 net/xdp/xsk.c                                      |   4 +-
 net/xdp/xsk.h                                      |   4 +-
 net/xdp/xskmap.c                                   |  29 +++---
 samples/bpf/xdp_redirect_user.c                    |   4 +-
 tools/lib/bpf/libbpf.c                             |   4 +
 tools/lib/bpf/netlink.c                            | 115 ++++++++-------------
 tools/lib/bpf/nlattr.c                             |   2 +-
 tools/lib/bpf/nlattr.h                             |  38 ++++---
 tools/testing/selftests/bpf/prog_tests/ringbuf.c   |   2 +-
 56 files changed, 394 insertions(+), 380 deletions(-)
 create mode 100644 Documentation/bpf/libbpf/libbpf.rst
 create mode 100644 Documentation/bpf/libbpf/libbpf_api.rst
 create mode 100644 Documentation/bpf/libbpf/libbpf_build.rst
 rename tools/lib/bpf/README.rst => Documentation/bpf/libbpf/libbpf_naming_convention.rst (90%)
