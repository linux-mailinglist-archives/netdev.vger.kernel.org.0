Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 897E0247A56
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 00:15:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730532AbgHQWPV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 17 Aug 2020 18:15:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729002AbgHQWPS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 18:15:18 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17ED8C061389;
        Mon, 17 Aug 2020 15:15:18 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6238E15D97832;
        Mon, 17 Aug 2020 14:58:31 -0700 (PDT)
Date:   Mon, 17 Aug 2020 15:15:16 -0700 (PDT)
Message-Id: <20200817.151516.165813635830933647.davem@davemloft.net>
To:     torvalds@linux-foundation.org
CC:     akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 17 Aug 2020 14:58:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Another batch of fixes:

1) Remove nft_compat counter flush optimization, it generates warnings from
   the refcount infrastructure.  From Florian Westphal.

2) Fix BPF to search for build id more robustly, from Jiri Olsa.

3) Handle bogus getopt lengths in ebtables, from Florian Westphal.

4) Infoleak and other fixes to j1939 CAN driver, from Eric Dumazet and
   Oleksij Rempel.

5) Reset iter properly on mptcp sendmsg() error, from Florian Westphal.

6) Show a saner speed in bonding broadcast mode, from Jarod Wilson.

7) Various kerneldoc fixes in bonding and elsewhere, from Lee Jones.

8) Fix double unregister in bonding during namespace tear down, from
   Cong Wang.

9) Disable RP filter during icmp_redirect selftest, from David Ahern.

Please pull, thanks a lot!

The following changes since commit 7fca4dee610dffbe119714231cac0d59496bc193:

  Merge tag 'powerpc-5.9-2' of git://git.kernel.org/pub/scm/linux/kernel/git/powerpc/linux (2020-08-14 13:40:27 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git 

for you to fetch changes up to bf2bcd6f1a8822ea45465f86d705951725883ee8:

  otx2_common: Use devm_kcalloc() in otx2_config_npa() (2020-08-17 15:08:39 -0700)

----------------------------------------------------------------
Andrew Lunn (1):
      net: devlink: Remove overzealous WARN_ON with snapshots

Andrii Nakryiko (11):
      bpf: Fix XDP FD-based attach/detach logic around XDP_FLAGS_UPDATE_IF_NOEXIST
      tools/bpftool: Make skeleton code C++17-friendly by dropping typeof()
      tools/bpftool: Fix compilation warnings in 32-bit mode
      selftest/bpf: Fix compilation warnings in 32-bit mode
      libbpf: Fix BTF-defined map-in-map initialization on 32-bit host arches
      libbpf: Handle BTF pointer sizes more carefully
      selftests/bpf: Fix btf_dump test cases on 32-bit arches
      libbpf: Enforce 64-bitness of BTF for BPF object files
      selftests/bpf: Correct various core_reloc 64-bit assumptions
      tools/bpftool: Generate data section struct with conservative alignment
      selftests/bpf: Make test_varlen work with 32-bit user-space arch

Cong Wang (2):
      bonding: fix a potential double-unregister
      tipc: fix uninit skb->data in tipc_nl_compat_dumpit()

David Ahern (1):
      selftests: disable rp_filter for icmp_redirect.sh

David S. Miller (6):
      Merge tag 'linux-can-fixes-for-5.9-20200814' of git://git.kernel.org/.../mkl/linux-can
      Merge branch '40GbE' of git://git.kernel.org/.../jkirsher/net-queue
      Merge git://git.kernel.org/.../bpf/bpf
      Merge tag 'linux-can-fixes-for-5.9-20200815' of git://git.kernel.org/.../mkl/linux-can
      Merge git://git.kernel.org/.../pablo/nf
      Revert "net: xdp: pull ethernet header off packet after computing skb->protocol"

Edward Cree (1):
      sfc: check hash is valid before using it

Eric Dumazet (1):
      can: j1939: fix kernel-infoleak in j1939_sk_sock2sockaddr_can()

Fabian Frederick (3):
      selftests: netfilter: add checktool function
      selftests: netfilter: add MTU arguments to flowtables
      selftests: netfilter: kill running process only

Florian Westphal (6):
      netfilter: nft_compat: remove flush counter optimization
      netfilter: avoid ipv6 -> nf_defrag_ipv6 module dependency
      netfilter: nf_tables: free chain context when BINDING flag is missing
      netfilter: ebtables: reject bogus getopt len value
      mptcp: sendmsg: reset iter on error
      mptcp: sendmsg: reset iter on error redux

Fugang Duan (1):
      net: fec: correct the error path for regulator disable in probe

Grzegorz Szczurek (1):
      i40e: Fix crash during removing i40e driver

Jarod Wilson (1):
      bonding: show saner speed for broadcast mode

Jason A. Donenfeld (1):
      net: xdp: pull ethernet header off packet after computing skb->protocol

Jean-Philippe Brucker (1):
      libbpf: Handle GCC built-in types for Arm NEON

Jianlin Lv (1):
      selftests/bpf: Fix segmentation fault in test_progs

Jiri Olsa (1):
      bpf: Iterate through all PT_NOTE sections when looking for build id

Joe Stringer (1):
      doc: Add link to bpf helpers man page

John Fastabend (5):
      bpf: sock_ops ctx access may stomp registers in corner case
      bpf: sock_ops sk access may stomp registers when dst_reg = src_reg
      bpf, selftests: Add tests for ctx access in sock_ops with single register
      bpf, selftests: Add tests for sock_ops load with r9, r8.r7 registers
      bpf, selftests: Add tests to sock_ops for loading sk

Lee Jones (12):
      net: bonding: bond_3ad: Fix a bunch of kerneldoc parameter issues
      net: bonding: bond_main: Document 'proto' and rename 'new_active' parameters
      net: ethernet: 3com: 3c574_cs: Remove set but unused variables 'tx' and 'rx'
      net: bonding: bond_alb: Describe alb_handle_addr_collision_on_attach()'s 'bond' and 'addr' params
      net: ethernet: 8390: axnet_cs: Document unused parameter 'txqueue'
      net: wan: dlci: Remove set but not used variable 'err'
      net: fddi: skfp: hwmtm: Remove seemingly unused variable 'ID_sccs'
      net: fddi: skfp: fplustm: Remove seemingly unused variable 'ID_sccs'
      net: fddi: skfp: smt: Place definition of 'smt_pdef' under same stipulations as its use
      net: fddi: skfp: smt: Remove seemingly unused variable 'ID_sccs'
      net: fddi: skfp: cfm: Remove set but unused variable 'oldstate'
      net: fddi: skfp: cfm: Remove seemingly unused variable 'ID_sccs'

Mahesh Bandewar (1):
      ipvlan: fix device features

Miaohe Lin (1):
      net: Fix potential wrong skb->protocol in skb_vlan_untag()

Necip Fazil Yildiran (1):
      net: qrtr: fix usage of idr in port assignment to socket

Nivedita Singhvi (1):
      docs: networking: bonding.rst resources section cleanup

Oleksij Rempel (5):
      can: j1939: transport: j1939_simple_recv(): ignore local J1939 messages send not by J1939 stack
      can: j1939: transport: j1939_session_tx_dat(): fix use-after-free read in j1939_tp_txtimer()
      can: j1939: socket: j1939_sk_bind(): make sure ml_priv is allocated
      can: j1939: transport: add j1939_session_skb_find_by_offset() function
      can: j1939: transport: j1939_xtp_rx_dat_one(): compare own packets to detect corruptions

Przemyslaw Patynowski (1):
      i40e: Set RX_ONLY mode for unicast promiscuous on VLAN

Randy Dunlap (1):
      phylink: <linux/phylink.h>: fix function prototype kernel-doc warning

Stanislav Fomichev (1):
      selftests/bpf: Fix v4_to_v6 in sk_lookup

Stephen Suryaputra (1):
      netfilter: nf_tables: nft_exthdr: the presence return value should be little-endian

Toke Høiland-Jørgensen (1):
      libbpf: Prevent overriding errno when logging errors

Vinicius Costa Gomes (1):
      igc: Fix PTP initialization

Xie He (1):
      drivers/net/wan/hdlc_x25: Added needed_headroom and a skb->len check

Xin Long (1):
      tipc: not enable tipc when ipv6 works as a module

Xu Wang (1):
      otx2_common: Use devm_kcalloc() in otx2_config_npa()

Yonghong Song (1):
      libbpf: Do not use __builtin_offsetof for offsetof

Zhang Changzhong (4):
      can: j1939: fix support for multipacket broadcast message
      can: j1939: cancel rxtimer on multipacket broadcast session complete
      can: j1939: abort multipacket broadcast session when timeout occurs
      can: j1939: add rxtimer for multipacket broadcast session

 Documentation/bpf/index.rst                              |   7 +++++++
 Documentation/networking/bonding.rst                     |  18 ----------------
 drivers/net/bonding/bond_3ad.c                           |  15 ++++++-------
 drivers/net/bonding/bond_alb.c                           |   4 ++--
 drivers/net/bonding/bond_main.c                          |  28 ++++++++++++++++++++-----
 drivers/net/ethernet/3com/3c574_cs.c                     |   6 +++---
 drivers/net/ethernet/8390/axnet_cs.c                     |   1 +
 drivers/net/ethernet/freescale/fec_main.c                |   4 ++--
 drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h        |   2 +-
 drivers/net/ethernet/intel/i40e/i40e_common.c            |  35 ++++++++++++++++++++++++-------
 drivers/net/ethernet/intel/i40e/i40e_main.c              |   3 +++
 drivers/net/ethernet/intel/igc/igc_main.c                |   5 ++---
 drivers/net/ethernet/intel/igc/igc_ptp.c                 |   2 --
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c |   4 ++--
 drivers/net/ethernet/sfc/ef100_rx.c                      |   5 +++++
 drivers/net/ethernet/sfc/ef100_rx.h                      |   1 +
 drivers/net/ethernet/sfc/efx.h                           |   8 +++++++
 drivers/net/ethernet/sfc/net_driver.h                    |   2 ++
 drivers/net/ethernet/sfc/rx_common.c                     |   3 ++-
 drivers/net/fddi/skfp/cfm.c                              |  17 ++-------------
 drivers/net/fddi/skfp/fplustm.c                          |   4 ----
 drivers/net/fddi/skfp/hwmtm.c                            |   4 ----
 drivers/net/fddi/skfp/smt.c                              |   7 ++-----
 drivers/net/ipvlan/ipvlan_main.c                         |  27 +++++++++++++++++++-----
 drivers/net/wan/dlci.c                                   |   3 +--
 drivers/net/wan/hdlc.c                                   |   1 +
 drivers/net/wan/hdlc_x25.c                               |  17 ++++++++++++++-
 include/linux/netfilter_ipv6.h                           |  18 ----------------
 include/linux/phylink.h                                  |   3 ++-
 kernel/bpf/stackmap.c                                    |  24 ++++++++++++---------
 net/bridge/netfilter/ebtables.c                          |   4 ++++
 net/bridge/netfilter/nf_conntrack_bridge.c               |   8 +++++--
 net/can/j1939/socket.c                                   |  14 +++++++++++++
 net/can/j1939/transport.c                                | 104 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------------------
 net/core/dev.c                                           |   8 +++----
 net/core/devlink.c                                       |   2 +-
 net/core/filter.c                                        |  75 +++++++++++++++++++++++++++++++++++++++++++++++++++++------------
 net/core/skbuff.c                                        |   4 ++--
 net/ipv6/netfilter.c                                     |   3 ---
 net/mptcp/protocol.c                                     |  14 +++++++++----
 net/netfilter/nf_tables_api.c                            |   6 ++++--
 net/netfilter/nft_compat.c                               |  37 +++++++++++++--------------------
 net/netfilter/nft_exthdr.c                               |   4 ++--
 net/qrtr/qrtr.c                                          |  20 ++++++++++--------
 net/tipc/Kconfig                                         |   1 +
 net/tipc/netlink_compat.c                                |  12 ++++++++++-
 tools/bpf/bpftool/btf_dumper.c                           |   2 +-
 tools/bpf/bpftool/gen.c                                  |  22 ++++++++++++++++----
 tools/bpf/bpftool/link.c                                 |   4 ++--
 tools/bpf/bpftool/main.h                                 |  10 ++++++++-
 tools/bpf/bpftool/prog.c                                 |  16 +++++++-------
 tools/lib/bpf/bpf_helpers.h                              |   2 +-
 tools/lib/bpf/btf.c                                      |  83 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 tools/lib/bpf/btf.h                                      |   2 ++
 tools/lib/bpf/btf_dump.c                                 |  39 ++++++++++++++++++++++++++++++++--
 tools/lib/bpf/libbpf.c                                   |  32 ++++++++++++++++++----------
 tools/lib/bpf/libbpf.map                                 |   2 ++
 tools/testing/selftests/bpf/prog_tests/bpf_obj_id.c      |   8 +++----
 tools/testing/selftests/bpf/prog_tests/btf_dump.c        |  27 +++++++++++++++++-------
 tools/testing/selftests/bpf/prog_tests/core_extern.c     |   4 ++--
 tools/testing/selftests/bpf/prog_tests/core_reloc.c      |  20 +++++++++---------
 tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c   |   6 +++---
 tools/testing/selftests/bpf/prog_tests/flow_dissector.c  |   2 +-
 tools/testing/selftests/bpf/prog_tests/global_data.c     |   6 +++---
 tools/testing/selftests/bpf/prog_tests/mmap.c            |  19 +++++++++++------
 tools/testing/selftests/bpf/prog_tests/prog_run_xattr.c  |   2 +-
 tools/testing/selftests/bpf/prog_tests/sk_lookup.c       |   1 +
 tools/testing/selftests/bpf/prog_tests/skb_ctx.c         |   2 +-
 tools/testing/selftests/bpf/prog_tests/varlen.c          |   8 +++----
 tools/testing/selftests/bpf/progs/core_reloc_types.h     |  69 ++++++++++++++++++++++++++++++++----------------------------
 tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c     |  41 ++++++++++++++++++++++++++++++++++++
 tools/testing/selftests/bpf/progs/test_varlen.c          |   6 +++---
 tools/testing/selftests/bpf/test_btf.c                   |   8 +++----
 tools/testing/selftests/bpf/test_progs.h                 |   5 +++++
 tools/testing/selftests/net/icmp_redirect.sh             |   2 ++
 tools/testing/selftests/netfilter/nft_flowtable.sh       |  73 ++++++++++++++++++++++++++++++++++++++--------------------------
 76 files changed, 768 insertions(+), 349 deletions(-)
