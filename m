Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B413924EAE7
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 04:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbgHWCT4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 22 Aug 2020 22:19:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725924AbgHWCTz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 22:19:55 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F0E7C061573;
        Sat, 22 Aug 2020 19:19:54 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BEED511E4577C;
        Sat, 22 Aug 2020 19:03:04 -0700 (PDT)
Date:   Sat, 22 Aug 2020 19:19:48 -0700 (PDT)
Message-Id: <20200822.191948.1640751494477385125.davem@davemloft.net>
To:     torvalds@linux-foundation.org
CC:     akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 22 Aug 2020 19:03:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Nothing earth shattering here, lots of small fixes (f.e. missing RCU
protection, bad ref counting, missing memset(), etc.) all over the
place:

1) Use get_file_rcu() in task_file iterator, from Yonghong Song.

2) There are two ways to set remote source MAC addresses in macvlan
   driver, but only one of which validates things properly.  Fix
   this.  From Alvin ¦ipraga.

3) Missing of_node_put() in gianfar probing, from Sumera Priyadarsini.

4) Preserve device wanted feature bits across multiple netlink ethtool
   requests, from Maxim Mikityanskiy.

5) Fix rcu_sched stall in task and task_file bpf iterators, from
   Yonghong Song.

6) Avoid reset after device destroy in ena driver, from Shay Agroskin.

7) Missing memset() in netlink policy export reallocation path, from
   Johannes Berg.

8) Fix info leak in __smc_diag_dump(), from Peilin Ye.

9) Decapsulate ECN properly for ipv6 in ipv4 tunnels, from Mark
   Tomlinson.

10) Fix number of data stream negotiation in SCTP, from David Laight.

11) Fix double free in connection tracker action module, from Alaa
    Hleihel.

12) Don't allow empty NHA_GROUP attributes, from Nikolay Aleksandrov.

Please pull, thanks a lot!

The following changes since commit 06a4ec1d9dc652e17ee3ac2ceb6c7cf6c2b75cdd:

  Merge tag 'pstore-v5.9-rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux (2020-08-17 17:15:23 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git 

for you to fetch changes up to eeaac3634ee0e3f35548be35275efeca888e9b23:

  net: nexthop: don't allow empty NHA_GROUP (2020-08-22 12:39:55 -0700)

----------------------------------------------------------------
Alaa Hleihel (1):
      net/sched: act_ct: Fix skb double-free in tcf_ct_handle_fragments() error flow

Alvin ¦ipraga (1):
      macvlan: validate setting of multiple remote source MAC addresses

Andrii Nakryiko (2):
      libbpf: Fix build on ppc64le architecture
      bpf: xdp: Fix XDP mode when no mode flags specified

Colin Ian King (2):
      net: mscc: ocelot: remove duplicate "the the" phrase in Kconfig text
      net: ipv4: remove duplicate "the the" phrase in Kconfig text

David Laight (1):
      net: sctp: Fix negotiation of the number of data streams.

David S. Miller (6):
      Merge branch 'sfc-more-EF100-fixes'
      Merge branch 'cxgb4-Fix-ethtool-selftest-flits-calculation'
      Merge branch 'ethtool-netlink-bug-fixes'
      Merge branch 'Bug-fixes-for-ENA-ethernet-driver'
      Merge branch 'hv_netvsc-Some-fixes-for-the-select_queue'
      Merge git://git.kernel.org/.../bpf/bpf

Edward Cree (5):
      sfc: really check hash is valid before using it
      sfc: take correct lock in ef100_reset()
      sfc: null out channel->rps_flow_id after freeing it
      sfc: don't free_irq()s if they were never requested
      sfc: fix build warnings on 32-bit

Ganji Aravind (2):
      cxgb4: Fix work request size calculation for loopback test
      cxgb4: Fix race between loopback and normal Tx path

Geert Uytterhoeven (1):
      dt-bindings: net: renesas, ether: Improve schema validation

Haiyang Zhang (2):
      hv_netvsc: Remove "unlikely" from netvsc_select_queue
      hv_netvsc: Fix the queue_mapping in netvsc_vf_xmit()

Jiri Olsa (1):
      tools/resolve_btfids: Fix sections with wrong alignment

Jiri Wiesner (1):
      bonding: fix active-backup failover for current ARP slave

Johannes Berg (1):
      netlink: fix state reallocation in policy export

Kaige Li (1):
      net: phy: mscc: Fix a couple of spelling mistakes "spcified" -> "specified"

Mark Tomlinson (1):
      gre6: Fix reception with IP6_TNL_F_RCV_DSCP_COPY

Maxim Mikityanskiy (3):
      ethtool: Fix preserving of wanted feature bits in netlink interface
      ethtool: Account for hw_features in netlink interface
      ethtool: Don't omit the netlink reply if no features were changed

Miaohe Lin (1):
      net: handle the return value of pskb_carve_frag_list() correctly

Min Li (1):
      ptp: ptp_clockmatrix: use i2c_master_send for i2c write

Nikolay Aleksandrov (1):
      net: nexthop: don't allow empty NHA_GROUP

Peilin Ye (1):
      net/smc: Prevent kernel-infoleak in __smc_diag_dump()

Sebastian Andrzej Siewior (1):
      net: atlantic: Use readx_poll_timeout() for large timeout

Shay Agroskin (3):
      net: ena: Prevent reset after device destruction
      net: ena: Change WARN_ON expression in ena_del_napi_in_range()
      net: ena: Make missed_tx stat incremental

Sumera Priyadarsini (1):
      net: gianfar: Add of_node_put() before goto statement

Tobias Klauser (1):
      bpf: Fix two typos in uapi/linux/bpf.h

Toke Høiland-Jørgensen (1):
      libbpf: Fix map index used in error message

Tom Rix (1):
      net: dsa: b53: check for timeout

Veronika Kabatova (1):
      selftests/bpf: Remove test_align leftovers

Wang Hai (1):
      net: gemini: Fix missing free_netdev() in error path of gemini_ethernet_port_probe()

Xin Long (2):
      ipv6: some fixes for ipv6_dev_find()
      tipc: call rcu_read_lock() in tipc_aead_encrypt_done()

Yauheni Kaliuta (1):
      bpf: selftests: global_funcs: Check err_str before strstr

Yonghong Song (4):
      bpf: Use get_file_rcu() instead of get_file() for task_file iterator
      bpf: Fix a rcu_sched stall issue with bpf task/task_file iterator
      bpf: Avoid visit same object multiple times
      bpftool: Handle EAGAIN error code properly in pids collection

 Documentation/devicetree/bindings/net/renesas,ether.yaml   | 22 +++++++++++++++-------
 drivers/net/bonding/bond_main.c                            | 18 ++++++++++++++++--
 drivers/net/dsa/b53/b53_common.c                           |  2 ++
 drivers/net/dsa/ocelot/Kconfig                             |  2 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c               | 35 ++++++++++++++++++-----------------
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c  |  4 ++--
 drivers/net/ethernet/chelsio/cxgb4/sge.c                   | 10 +++++++---
 drivers/net/ethernet/cortina/gemini.c                      |  4 +---
 drivers/net/ethernet/freescale/gianfar.c                   |  4 +++-
 drivers/net/ethernet/sfc/ef100.c                           |  8 ++++----
 drivers/net/ethernet/sfc/ef100_nic.c                       | 10 ++++++----
 drivers/net/ethernet/sfc/net_driver.h                      |  2 ++
 drivers/net/ethernet/sfc/nic.c                             |  4 ++++
 drivers/net/ethernet/sfc/rx_common.c                       |  1 +
 drivers/net/hyperv/netvsc_drv.c                            |  4 ++--
 drivers/net/macvlan.c                                      | 21 +++++++++++++++++----
 drivers/net/phy/mscc/mscc_main.c                           |  4 ++--
 drivers/ptp/ptp_clockmatrix.c                              | 56 +++++++++++++++++++++++++++++++++++++++++++-------------
 drivers/ptp/ptp_clockmatrix.h                              |  2 ++
 include/net/addrconf.h                                     |  3 ++-
 include/uapi/linux/bpf.h                                   | 10 +++++-----
 kernel/bpf/bpf_iter.c                                      | 15 ++++++++++++++-
 kernel/bpf/task_iter.c                                     |  6 ++++--
 net/core/dev.c                                             | 14 ++++++++------
 net/core/skbuff.c                                          | 10 +++++++---
 net/ethtool/features.c                                     | 19 ++++++++++---------
 net/ipv4/Kconfig                                           | 14 +++++++-------
 net/ipv4/nexthop.c                                         |  5 ++++-
 net/ipv6/addrconf.c                                        | 60 +++++++++++++++++++++++-------------------------------------
 net/ipv6/ip6_tunnel.c                                      | 10 +++++++++-
 net/netlink/policy.c                                       |  3 +++
 net/sched/act_ct.c                                         |  2 +-
 net/sctp/stream.c                                          |  6 ++++--
 net/smc/smc_diag.c                                         | 16 +++++++++-------
 net/tipc/crypto.c                                          |  2 ++
 net/tipc/udp_media.c                                       |  8 +++-----
 tools/bpf/bpftool/pids.c                                   |  2 ++
 tools/bpf/resolve_btfids/main.c                            | 36 ++++++++++++++++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h                             | 10 +++++-----
 tools/lib/bpf/btf_dump.c                                   |  2 +-
 tools/lib/bpf/libbpf.c                                     |  2 +-
 tools/testing/selftests/bpf/.gitignore                     |  1 -
 tools/testing/selftests/bpf/Makefile                       |  2 +-
 tools/testing/selftests/bpf/prog_tests/test_global_funcs.c |  2 +-
 44 files changed, 310 insertions(+), 163 deletions(-)
