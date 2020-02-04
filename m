Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD3AC151A79
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 13:25:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727156AbgBDMZI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 4 Feb 2020 07:25:08 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:42898 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727119AbgBDMZI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 07:25:08 -0500
Received: from localhost (unknown [IPv6:2001:982:756:1:57a7:3bfd:5e85:defb])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A773213CF2FCF;
        Tue,  4 Feb 2020 04:25:06 -0800 (PST)
Date:   Tue, 04 Feb 2020 13:25:03 +0100 (CET)
Message-Id: <20200204.132503.783799057091958363.davem@davemloft.net>
To:     torvalds@linux-foundation.org
CC:     akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 04 Feb 2020 04:25:07 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


1) Use after free in rxrpc_put_local(), from David Howells.

2) Fix 64-bit division error in mlxsw, from Nathan Chancellor.

3) Make sure we clear various bits of TCP state in response to
   tcp_disconnect().  From Eric Dumazet.

4) Fix netlink attribute policy in cls_rsvp, from Eric Dumazet.

5) txtimer must be deleted in stmmac suspend(), from Nicolin Chen.

6) Fix TC queue mapping in bnxt_en driver, from Michael Chan.

7) Various netdevsim fixes from Taehee Yoo (use of uninitialized
   data, snapshot panics, stack out of bounds, etc.)

8) cls_tcindex changes hash table size after allocating the table,
   fix from Cong Wang.

9) Fix regression in the enforcement of session ID uniqueness in
   l2tp.  We only have to enforce uniqueness for IP based tunnels
   not UDP ones.  From Ridge Kennedy.

Please pull, thanks a lot!

The following changes since commit 9f68e3655aae6d49d6ba05dd263f99f33c2567af:

  Merge tag 'drm-next-2020-01-30' of git://anongit.freedesktop.org/drm/drm (2020-01-30 08:04:01 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git 

for you to fetch changes up to bd5cd35b782abf5437fbd01dfaee12437d20e832:

  gtp: use __GFP_NOWARN to avoid memalloc warning (2020-02-04 12:38:50 +0100)

----------------------------------------------------------------
Cong Wang (1):
      net_sched: fix an OOB access in cls_tcindex

Dan Carpenter (2):
      octeontx2-pf: Fix an IS_ERR() vs NULL bug
      qed: Fix a error code in qed_hw_init()

David Howells (4):
      rxrpc: Fix use-after-free in rxrpc_put_local()
      rxrpc: Fix insufficient receive notification generation
      rxrpc: Fix missing active use pinning of rxrpc_local object
      rxrpc: Fix NULL pointer deref due to call->conn being cleared on disconnect

David S. Miller (1):
      Merge branch 'unbreak-basic-and-bpf-tdc-testcases'

Davide Caratti (2):
      tc-testing: fix eBPF tests failure on linux fresh clones
      tc-testing: add missing 'nsPlugin' to basic.json

Eric Dumazet (6):
      tcp: clear tp->total_retrans in tcp_disconnect()
      tcp: clear tp->delivered in tcp_disconnect()
      tcp: clear tp->data_segs{in|out} in tcp_disconnect()
      tcp: clear tp->segs_{in|out} in tcp_disconnect()
      cls_rsvp: fix rsvp_policy
      net: hsr: fix possible NULL deref in hsr_handle_frame()

Jakub Kicinski (5):
      Merge git://git.kernel.org/.../pablo/nf
      Merge branch 'Fix-reconnection-latency-caused-by-FIN-ACK-handling-race'
      Merge tag 'rxrpc-fixes-20200203' of git://git.kernel.org/.../dhowells/linux-fs
      Merge branch 'bnxt_en-Bug-fixes'
      Merge branch 'netdevsim-fix-several-bugs-in-netdevsim-module'

Joe Perches (1):
      netfilter: Use kvcalloc

Kadlecsik József (1):
      netfilter: ipset: fix suspicious RCU usage in find_set_and_id

Kai-Heng Feng (1):
      r8152: Add MAC passthrough support to new device

Lukas Bulwahn (1):
      MAINTAINERS: correct entries for ISDN/mISDN section

Matteo Croce (1):
      netfilter: nf_flowtable: fix documentation

Michael Chan (3):
      bnxt_en: Refactor logic to re-enable SRIOV after firmware reset detected.
      bnxt_en: Fix RDMA driver failure with SRIOV after firmware reset.
      bnxt_en: Fix TC queue mapping.

Michael Walle (3):
      net: mdio: of: fix potential NULL pointer derefernce
      net: mii_timestamper: fix static allocation by PHY driver
      net: phy: at803x: disable vddio regulator

Nathan Chancellor (1):
      mlxsw: spectrum_qdisc: Fix 64-bit division error in mlxsw_sp_qdisc_tbf_rate_kbps

Nicolin Chen (1):
      net: stmmac: Delete txtimer in suspend()

Paul Blakey (3):
      netfilter: flowtable: Fix hardware flush order on nf_flow_table_cleanup
      netfilter: flowtable: Fix missing flush hardware on table free
      netfilter: flowtable: Fix setting forgotten NF_FLOW_HW_DEAD flag

Ridge Kennedy (1):
      l2tp: Allow duplicate session creation with UDP

SeongJae Park (2):
      tcp: Reduce SYN resend delay if a suspicous ACK is received
      selftests: net: Add FIN_ACK processing order related latency spike test

Shannon Nelson (1):
      ionic: fix rxq comp packet type mask

Sven Eckelmann (1):
      MAINTAINERS: Orphan HSR network protocol

Taehee Yoo (8):
      netdevsim: fix using uninitialized resources
      netdevsim: disable devlink reload when resources are being used
      netdevsim: fix panic in nsim_dev_take_snapshot_write()
      netdevsim: fix stack-out-of-bounds in nsim_dev_debugfs_init()
      netdevsim: use IS_ERR instead of IS_ERR_OR_NULL for debugfs
      netdevsim: use __GFP_NOWARN to avoid memalloc warning
      netdevsim: remove unused sdev code
      gtp: use __GFP_NOWARN to avoid memalloc warning

Vasundhara Volam (1):
      bnxt_en: Fix logic that disables Bus Master during firmware reset.

YueHaibing (1):
      qed: Remove set but not used variable 'p_link'

 Documentation/networking/nf_flowtable.txt                        |   2 +-
 MAINTAINERS                                                      |   9 ++++---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                        |  37 ++++++++++++++++----------
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c         |   4 +--
 drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c             |   2 +-
 drivers/net/ethernet/pensando/ionic/ionic_if.h                   |   2 +-
 drivers/net/ethernet/qlogic/qed/qed_cxt.c                        |   3 ---
 drivers/net/ethernet/qlogic/qed/qed_dev.c                        |   1 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c                |   4 +++
 drivers/net/gtp.c                                                |   4 +--
 drivers/net/netdevsim/bpf.c                                      |  10 +++++---
 drivers/net/netdevsim/bus.c                                      |  64 ++++++++++++++++++++++++++++++++++++++++++---
 drivers/net/netdevsim/dev.c                                      |  31 ++++++++++++++--------
 drivers/net/netdevsim/health.c                                   |   6 ++---
 drivers/net/netdevsim/netdevsim.h                                |   4 +++
 drivers/net/netdevsim/sdev.c                                     |  69 -------------------------------------------------
 drivers/net/phy/at803x.c                                         |  11 ++++++++
 drivers/net/phy/mii_timestamper.c                                |   7 +++++
 drivers/net/usb/r8152.c                                          |  13 +++++++---
 drivers/of/of_mdio.c                                             |  17 +++++++++---
 net/hsr/hsr_slave.c                                              |   2 ++
 net/ipv4/tcp.c                                                   |   6 +++++
 net/ipv4/tcp_input.c                                             |   8 +++++-
 net/l2tp/l2tp_core.c                                             |   7 ++++-
 net/netfilter/ipset/ip_set_core.c                                |  41 ++++++++++++++---------------
 net/netfilter/nf_conntrack_core.c                                |   3 +--
 net/netfilter/nf_flow_table_core.c                               |   3 ++-
 net/netfilter/nf_flow_table_offload.c                            |   1 +
 net/netfilter/x_tables.c                                         |   4 +--
 net/rxrpc/af_rxrpc.c                                             |   2 ++
 net/rxrpc/ar-internal.h                                          |  11 ++++++++
 net/rxrpc/call_object.c                                          |   4 +--
 net/rxrpc/conn_client.c                                          |   3 +--
 net/rxrpc/conn_event.c                                           |  30 ++++++++++++++--------
 net/rxrpc/conn_object.c                                          |   4 +--
 net/rxrpc/input.c                                                |   6 ++---
 net/rxrpc/local_object.c                                         |  23 ++++++++---------
 net/rxrpc/output.c                                               |  27 +++++++------------
 net/rxrpc/peer_event.c                                           |  42 ++++++++++++++++--------------
 net/sched/cls_rsvp.h                                             |   6 ++---
 net/sched/cls_tcindex.c                                          |  40 ++++++++++++++---------------
 tools/testing/selftests/net/.gitignore                           |   1 +
 tools/testing/selftests/net/Makefile                             |   2 ++
 tools/testing/selftests/net/fin_ack_lat.c                        | 151 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/testing/selftests/net/fin_ack_lat.sh                       |  35 +++++++++++++++++++++++++
 tools/testing/selftests/tc-testing/plugin-lib/buildebpfPlugin.py |   2 +-
 tools/testing/selftests/tc-testing/tc-tests/filters/basic.json   |  51 ++++++++++++++++++++++++++++++++++++
 47 files changed, 569 insertions(+), 246 deletions(-)
 delete mode 100644 drivers/net/netdevsim/sdev.c
 create mode 100644 tools/testing/selftests/net/fin_ack_lat.c
 create mode 100755 tools/testing/selftests/net/fin_ack_lat.sh
