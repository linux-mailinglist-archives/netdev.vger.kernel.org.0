Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7C401D5A18
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 21:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbgEOTjC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 15 May 2020 15:39:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726168AbgEOTjB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 15:39:01 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2CF8C061A0C;
        Fri, 15 May 2020 12:39:01 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2C5D41539B80A;
        Fri, 15 May 2020 12:39:01 -0700 (PDT)
Date:   Fri, 15 May 2020 12:39:00 -0700 (PDT)
Message-Id: <20200515.123900.727024514724458944.davem@davemloft.net>
To:     torvalds@linux-foundation.org
CC:     akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 15 May 2020 12:39:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


1) Fix sk_psock reference count leak on receive, from Xiyu Yang.

2) CONFIG_HNS should be invisible, from Geert Uytterhoeven.

3) Don't allow locking route MTUs in ipv6, RFCs actually forbid
   this, from Maciej ¯enczykowski.

4) ipv4 route redirect backoff wasn't actually enforced, from
   Paolo Abeni.

5) Fix netprio cgroup v2 leak, from Zefan Li.

6) Fix infinite loop on rmmod in conntrack, from Florian Westphal.

7) Fix tcp SO_RCVLOWAT hangs, from Eric Dumazet.

8) Various bpf probe handling fixes, from Daniel Borkmann.

Please pull, thanks a lot!

The following changes since commit a811c1fa0a02c062555b54651065899437bacdbe:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2020-05-06 20:53:22 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net 

for you to fetch changes up to 8e1381049ed5d213e7a1a7f95bbff83af8c59234:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf (2020-05-15 10:57:21 -0700)

----------------------------------------------------------------
Alex Elder (2):
      net: ipa: set DMA length in gsi_trans_cmd_add()
      net: ipa: use tag process on modem crash

Alexei Starovoitov (1):
      Merge branch 'restrict-bpf_probe_read'

Amol Grover (2):
      ipmr: Fix RCU list debugging warning
      ipmr: Add lockdep expression to ipmr_for_each_table macro

Anders Roxell (1):
      security: Fix the default value of secid_to_secctx hook

Andrii Nakryiko (1):
      bpf: Fix bug in mmap() implementation for BPF array map

Arnd Bergmann (3):
      net: bareudp: avoid uninitialized variable warning
      net: freescale: select CONFIG_FIXED_PHY where needed
      netfilter: conntrack: avoid gcc-10 zero-length-bounds warning

Christoph Paasch (1):
      mptcp: Initialize map_seq upon subflow establishment

Chuhong Yuan (1):
      net: microchip: encx24j600: add missed kthread_stop

Clay McClure (1):
      net: ethernet: ti: Remove TI_CPTS_MOD workaround

Cong Wang (1):
      net: fix a potential recursive NETDEV_FEAT_CHANGE

Dan Carpenter (1):
      dpaa2-eth: prevent array underflow in update_cls_rule()

Daniel Borkmann (3):
      bpf: Restrict bpf_probe_read{, str}() only to archs where they work
      bpf: Add bpf_probe_read_{user, kernel}_str() to do_refine_retval_range
      bpf: Restrict bpf_trace_printk()'s %s usage and add %pks, %pus specifier

David S. Miller (8):
      Merge branch 'net-ipa-fix-cleanup-after-modem-crash'
      Merge branch 'ionic-fixes'
      Merge branch 's390-fixes'
      Merge branch 'tipc-fixes'
      MAINTAINERS: Add Jakub to networking drivers.
      Merge git://git.kernel.org/.../pablo/nf
      MAINTAINERS: Mark networking drivers as Maintained.
      Merge git://git.kernel.org/.../bpf/bpf

Eric Dumazet (2):
      tcp: fix SO_RCVLOWAT hangs with fat skbs
      tcp: fix error recovery in tcp_zerocopy_receive()

Florian Fainelli (2):
      net: dsa: loop: Add module soft dependency
      net: broadcom: Select BROADCOM_PHY for BCMGENET

Florian Westphal (1):
      netfilter: conntrack: fix infinite loop on rmmod

Geert Uytterhoeven (1):
      net: hisilicon: Make CONFIG_HNS invisible

Guillaume Nault (1):
      pppoe: only process PADT targeted at local interfaces

Heiner Kallweit (2):
      r8169: re-establish support for RTL8401 chip version
      net: phy: fix aneg restart in phy_ethtool_set_eee

Ioana Ciornei (1):
      dpaa2-eth: properly handle buffer size restrictions

Jacob Keller (1):
      ptp: fix struct member comment for do_aux_work

Jakub Kicinski (1):
      Merge git://git.kernel.org/.../bpf/bpf

John Fastabend (2):
      bpf, sockmap: msg_pop_data can incorrecty set an sge length
      bpf, sockmap: bpf_tcp_ingress needs to subtract bytes from sg.size

Kelly Littlepage (1):
      net: tcp: fix rx timestamp behavior for tcp_recvmsg

Kevin Lo (1):
      net: phy: broadcom: fix BCM54XX_SHD_SCR3_TRDDAPD value for BCM54810

Luo bin (1):
      hinic: fix a bug of ndo_stop

Maciej ¯enczykowski (2):
      net: remove spurious declaration of tcp_default_init_rwnd()
      Revert "ipv6: add mtu lock check in __ip6_rt_update_pmtu"

Madhuparna Bhowmik (1):
      drivers: net: hamradio: Fix suspicious RCU usage warning in bpqether.c

Matteo Croce (1):
      samples: bpf: Fix build error

Matthieu Baerts (1):
      selftests: mptcp: pm: rm the right tmp file

Michael S. Tsirkin (1):
      virtio_net: fix lockdep warning on 32 bit

Oliver Neukum (1):
      usb: hso: correct debug message

Pablo Neira Ayuso (1):
      netfilter: flowtable: set NF_FLOW_TEARDOWN flag on entry expiration

Paolo Abeni (3):
      mptcp: set correct vfs info for subflows
      net: ipv4: really enforce backoff for redirects
      netlabel: cope with NULL catmap

Paul Blakey (1):
      netfilter: flowtable: Add pending bit for offload work

Phil Sutter (1):
      netfilter: nft_set_rbtree: Add missing expired checks

Roi Dayan (1):
      netfilter: flowtable: Remove WQ_MEM_RECLAIM from workqueue

Shannon Nelson (2):
      ionic: leave netdev mac alone after fw-upgrade
      ionic: call ionic_port_init after fw-upgrade

Sumanth Korikkar (1):
      libbpf: Fix register naming in PT_REGS s390 macros

Tuong Lien (3):
      tipc: fix large latency in smart Nagle streaming
      tipc: fix memory leak in service subscripting
      tipc: fix failed service subscription deletion

Ursula Braun (2):
      MAINTAINERS: add Karsten Graul as S390 NETWORK DRIVERS maintainer
      MAINTAINERS: another add of Karsten Graul for S390 networking

Vincent Minet (1):
      umh: fix memory leak on execve failure

Vinod Koul (1):
      net: stmmac: fix num_por initialization

Wang Wenhu (1):
      drivers: ipa: fix typos for ipa_smp2p structure doc

Wei Yongjun (4):
      bpf: Fix error return code in map_lookup_and_delete_elem()
      nfp: abm: fix error return code in nfp_abm_vnic_alloc()
      octeontx2-vf: Fix error return code in otx2vf_probe()
      s390/ism: fix error return code in ism_probe()

Xiyu Yang (1):
      bpf: Fix sk_psock refcnt leak when receiving message

Yonghong Song (2):
      bpf: Enforce returning 0 for fentry/fexit progs
      selftests/bpf: Enforce returning 0 for fentry/fexit programs

Zefan Li (1):
      netprio_cgroup: Fix unlimited memory leak of v2 cgroups

 Documentation/core-api/printk-formats.rst               |  14 +++++++++
 MAINTAINERS                                             |   5 +++-
 arch/arm/Kconfig                                        |   1 +
 arch/arm/configs/keystone_defconfig                     |   1 +
 arch/arm/configs/omap2plus_defconfig                    |   1 +
 arch/arm64/Kconfig                                      |   1 +
 arch/x86/Kconfig                                        |   1 +
 drivers/net/bareudp.c                                   |  18 +++--------
 drivers/net/dsa/dsa_loop.c                              |   1 +
 drivers/net/ethernet/broadcom/Kconfig                   |   1 +
 drivers/net/ethernet/freescale/Kconfig                  |   2 ++
 drivers/net/ethernet/freescale/dpaa/Kconfig             |   1 +
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c        |  29 ++++++++++--------
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h        |   1 +
 drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c    |   2 +-
 drivers/net/ethernet/hisilicon/Kconfig                  |   2 +-
 drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c       |  16 +++++++---
 drivers/net/ethernet/huawei/hinic/hinic_main.c          |  16 ++--------
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c    |   8 +++--
 drivers/net/ethernet/microchip/encx24j600.c             |   5 +++-
 drivers/net/ethernet/netronome/nfp/abm/main.c           |   4 ++-
 drivers/net/ethernet/pensando/ionic/ionic_lif.c         |  19 +++++++-----
 drivers/net/ethernet/pensando/ionic/ionic_main.c        |  18 +++++------
 drivers/net/ethernet/realtek/r8169_main.c               |   2 ++
 drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c |  17 +++++++++--
 drivers/net/ethernet/ti/Kconfig                         |  16 ++++------
 drivers/net/ethernet/ti/Makefile                        |   2 +-
 drivers/net/hamradio/bpqether.c                         |   3 +-
 drivers/net/ipa/gsi_trans.c                             |   5 ++--
 drivers/net/ipa/ipa_cmd.c                               |  14 ++-------
 drivers/net/ipa/ipa_smp2p.c                             |   2 +-
 drivers/net/phy/broadcom.c                              |   8 +++--
 drivers/net/phy/phy.c                                   |   8 +++--
 drivers/net/ppp/pppoe.c                                 |   3 ++
 drivers/net/usb/hso.c                                   |   2 +-
 drivers/net/virtio_net.c                                |   6 ++--
 drivers/s390/net/ism_drv.c                              |   4 ++-
 include/linux/brcmphy.h                                 |   1 +
 include/linux/lsm_hook_defs.h                           |   2 +-
 include/linux/ptp_clock_kernel.h                        |   8 ++---
 include/linux/skmsg.h                                   |   1 +
 include/net/netfilter/nf_conntrack.h                    |   2 +-
 include/net/netfilter/nf_flow_table.h                   |   1 +
 include/net/tcp.h                                       |  14 ++++++++-
 include/net/udp_tunnel.h                                |   2 --
 init/Kconfig                                            |   3 ++
 kernel/bpf/arraymap.c                                   |   7 ++++-
 kernel/bpf/syscall.c                                    |   4 ++-
 kernel/bpf/verifier.c                                   |  21 ++++++++++++-
 kernel/trace/bpf_trace.c                                | 100 +++++++++++++++++++++++++++++++++++++++++---------------------
 kernel/umh.c                                            |   6 ++++
 lib/vsprintf.c                                          |  12 ++++++++
 net/core/dev.c                                          |   4 ++-
 net/core/filter.c                                       |   2 +-
 net/core/netprio_cgroup.c                               |   2 ++
 net/ipv4/cipso_ipv4.c                                   |   6 ++--
 net/ipv4/ipmr.c                                         |   6 ++--
 net/ipv4/route.c                                        |   2 +-
 net/ipv4/tcp.c                                          |  27 ++++++++++++-----
 net/ipv4/tcp_bpf.c                                      |  10 ++++---
 net/ipv4/tcp_input.c                                    |   3 +-
 net/ipv6/calipso.c                                      |   3 +-
 net/ipv6/route.c                                        |   6 ++--
 net/mptcp/protocol.c                                    |   2 ++
 net/mptcp/subflow.c                                     |  10 +++++++
 net/netfilter/nf_conntrack_core.c                       |  17 +++++++++--
 net/netfilter/nf_flow_table_core.c                      |   8 +++--
 net/netfilter/nf_flow_table_offload.c                   |  10 +++++--
 net/netfilter/nft_set_rbtree.c                          |  11 +++++++
 net/netlabel/netlabel_kapi.c                            |   6 ++++
 net/tipc/socket.c                                       |  42 +++++++++++++++++++-------
 net/tipc/subscr.h                                       |  10 +++++++
 net/tipc/topsrv.c                                       |  13 ++++----
 samples/bpf/lwt_len_hist_user.c                         |   2 --
 tools/lib/bpf/bpf_tracing.h                             |   4 +--
 tools/testing/selftests/bpf/prog_tests/mmap.c           |   8 +++++
 tools/testing/selftests/bpf/progs/test_overhead.c       |   4 +--
 tools/testing/selftests/net/mptcp/pm_netlink.sh         |   2 +-
 78 files changed, 459 insertions(+), 204 deletions(-)
