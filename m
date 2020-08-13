Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 764562441A2
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 01:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbgHMXK7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 13 Aug 2020 19:10:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbgHMXK7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Aug 2020 19:10:59 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DEC3C061757;
        Thu, 13 Aug 2020 16:10:59 -0700 (PDT)
Received: from localhost (50-47-103-195.evrt.wa.frontiernet.net [50.47.103.195])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E92E3128310D2;
        Thu, 13 Aug 2020 15:54:12 -0700 (PDT)
Date:   Thu, 13 Aug 2020 16:10:57 -0700 (PDT)
Message-Id: <20200813.161057.1210508009320036989.davem@davemloft.net>
To:     torvalds@linux-foundation.org
CC:     akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 13 Aug 2020 15:54:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Some merge window fallout, some longer term fixes:

1) Handle headroom properly in lapbether and x25_asy drivers,
   from Xie He.

2) Fetch MAC address from correct r8152 device node, from Thierry
   Reding.

3) In the sw kTLS path we should allow MSG_CMSG_COMPAT in sendmsg,
   from Rouven Czerwinski.

4) Correct fdputs in socket layer, from Miaohe Lin.

5) Revert troublesome sockptr_t optimization, from Christoph Hellwig.

6) Fix TCP TFO key reading on big endian, from Jason Baron.

7) Missing CAP_NET_RAW check in nfc, from Qingyu Li.

8) Fix inet fastreuse optimization with tproxy sockets, from Tim
   Froidcoeur.

9) Fix 64-bit divide in new SFC driver, from Edward Cree.

10) Add a tracepoint for prandom_u32 so that we can more easily perform
    usage analysis.  From Eric Dumazet.

11) Fix rwlock imbalance in AF_PACKET, from John Ogness.

Please pull, thanks a lot!

The following changes since commit bfdd5aaa54b0a44d9df550fe4c9db7e1470a11b8:

  Merge tag 'Smack-for-5.9' of git://github.com/cschaufler/smack-next (2020-08-06 11:02:23 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git 

for you to fetch changes up to 1f3a090b9033f69de380c03db3ea1a1015c850cf:

  net: openvswitch: introduce common code for flushing flows (2020-08-13 15:53:30 -0700)

----------------------------------------------------------------
Alan Maguire (1):
      bpf, doc: Remove references to warning message when using bpf_trace_printk()

Alexei Starovoitov (1):
      Merge branch 'bpf_iter-uapi-fix'

Andrii Nakryiko (2):
      selftests/bpf: Prevent runqslower from racing on building bpftool
      selftests/bpf: Fix silent Makefile output

Christoph Hellwig (1):
      net: Revert "net: optimize the sockptr_t for unified kernel/user address spaces"

Colin Ian King (1):
      net: hns3: fix spelling mistake "could'nt" -> "couldn't"

Daniel T. Lee (1):
      libbf: Fix uninitialized pointer at btf__parse_raw()

David S. Miller (4):
      Merge git://git.kernel.org/.../bpf/bpf
      Merge branch 'net-initialize-fastreuse-on-inet_inherit_port'
      Merge branch 'net-stmmac-Fix-multicast-filter-on-IPQ806x'
      Revert "ipv4: tunnel: fix compilation on ARCH=um"

Edward Cree (1):
      sfc: fix ef100 design-param checking

Eric Dumazet (2):
      net: accept an empty mask in /sys/class/net/*/queues/rx-*/rps_cpus
      random32: add a tracepoint for prandom_u32()

Ira Weiny (1):
      net/tls: Fix kmap usage

Jakub Kicinski (2):
      nfp: update maintainer
      bitfield.h: don't compile-time validate _val in FIELD_FIT

Jason Baron (1):
      tcp: correct read of TFO keys on big endian systems

Jianlin Lv (1):
      bpf: Fix compilation warning of selftests

Jiri Benc (1):
      selftests: bpf: Switch off timeout

Johan Hovold (1):
      net: phy: fix memory leak in device-create error path

Johannes Berg (1):
      ipv4: tunnel: fix compilation on ARCH=um

John Ogness (1):
      af_packet: TPACKET_V3: fix fill status rwlock imbalance

Jonathan McDowell (2):
      net: stmmac: dwmac1000: provide multicast filter fallback
      net: ethernet: stmmac: Disable hardware multicast filter

Luo bin (1):
      hinic: fix strncpy output truncated compile warnings

Marek Behún (1):
      net: phy: marvell10g: fix null pointer dereference

Miaohe Lin (6):
      net: Use helper function fdput()
      net: Set fput_needed iff FDPUT_FPUT is set
      net: Remove meaningless jump label out_fs
      net: Use helper function ip_is_fragment()
      net: Convert to use the fallthrough macro
      net: Fix potential memory leak in proto_register()

Paolo Abeni (3):
      selftests: mptcp: fix dependecies
      mptcp: more stable diag self-tests
      mptcp: fix warn at shutdown time for unaccepted msk sockets

Qingyu Li (1):
      net/nfc/rawsock.c: add CAP_NET_RAW check.

Randy Dunlap (1):
      bpf: Delete repeated words in comments

Ronak Doshi (1):
      vmxnet3: use correct tcp hdr length when packet is encapsulated

Rouven Czerwinski (1):
      net/tls: allow MSG_CMSG_COMPAT in sendmsg

Stanislav Fomichev (2):
      bpf: Add missing return to resolve_btfids
      bpf: Remove inline from bpf_do_trace_printk

Stefano Garzarella (1):
      vsock: fix potential null pointer dereference in vsock_poll()

Thierry Reding (1):
      r8152: Use MAC address from correct device tree node

Tim Froidcoeur (2):
      net: refactor bind_bucket fastreuse into helper
      net: initialize fastreuse on inet_inherit_port

Tonghao Zhang (1):
      net: openvswitch: introduce common code for flushing flows

Wang Hai (1):
      net: qcom/emac: add missed clk_disable_unprepare in error path of emac_clks_phase1_init

Xie He (2):
      drivers/net/wan/lapbether: Added needed_headroom and a skb->len check
      drivers/net/wan/x25_asy: Added needed_headroom and a skb->len check

Xu Wang (1):
      ionic_lif: Use devm_kcalloc() in ionic_qcq_alloc()

Yonghong Song (2):
      bpf: Change uapi for bpf iterator map elements
      tools/bpf: Support new uapi for map element bpf iterator

 Documentation/bpf/bpf_design_QA.rst                              | 11 ----------
 MAINTAINERS                                                      |  3 ++-
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c        |  2 +-
 drivers/net/ethernet/huawei/hinic/hinic_devlink.c                | 32 +++++++++++----------------
 drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h                 |  2 --
 drivers/net/ethernet/pensando/ionic/ionic_lif.c                  |  4 ++--
 drivers/net/ethernet/qualcomm/emac/emac.c                        | 17 ++++++++++++---
 drivers/net/ethernet/sfc/ef100_nic.c                             |  3 ++-
 drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c              |  1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c             |  3 +++
 drivers/net/phy/marvell10g.c                                     | 18 ++++++----------
 drivers/net/phy/phy_device.c                                     |  8 +++----
 drivers/net/usb/r8152.c                                          |  2 +-
 drivers/net/vmxnet3/vmxnet3_drv.c                                |  3 ++-
 drivers/net/wan/lapbether.c                                      | 10 ++++++++-
 drivers/net/wan/x25_asy.c                                        | 14 ++++++++++++
 include/linux/bitfield.h                                         |  2 +-
 include/linux/bpf.h                                              | 10 +++++----
 include/linux/sockptr.h                                          | 26 ++--------------------
 include/net/inet_connection_sock.h                               |  4 ++++
 include/net/tcp.h                                                |  2 ++
 include/trace/events/random.h                                    | 17 +++++++++++++++
 include/uapi/linux/bpf.h                                         | 15 +++++++------
 kernel/bpf/bpf_iter.c                                            | 58 ++++++++++++++++++++++++-------------------------
 kernel/bpf/core.c                                                |  2 +-
 kernel/bpf/map_iter.c                                            | 37 ++++++++++++++++++++++++-------
 kernel/bpf/syscall.c                                             |  2 +-
 kernel/bpf/verifier.c                                            |  2 +-
 kernel/trace/bpf_trace.c                                         |  2 +-
 lib/random32.c                                                   |  2 ++
 net/core/bpf_sk_storage.c                                        | 37 ++++++++++++++++++++++++-------
 net/core/net-sysfs.c                                             | 12 ++++++-----
 net/core/skbuff.c                                                |  2 +-
 net/core/sock.c                                                  | 25 ++++++++++++---------
 net/ipv4/bpfilter/sockopt.c                                      | 14 ++++++------
 net/ipv4/inet_connection_sock.c                                  | 97 +++++++++++++++++++++++++++++++++++++++++++++-------------------------------------
 net/ipv4/inet_hashtables.c                                       |  1 +
 net/ipv4/sysctl_net_ipv4.c                                       | 16 ++++----------
 net/ipv4/tcp.c                                                   | 16 ++++----------
 net/ipv4/tcp_fastopen.c                                          | 23 ++++++++++++++++++++
 net/mptcp/subflow.c                                              |  6 +++---
 net/nfc/rawsock.c                                                |  7 ++++--
 net/openvswitch/datapath.c                                       | 10 ++++++++-
 net/openvswitch/flow_table.c                                     | 35 +++++++++++++-----------------
 net/openvswitch/flow_table.h                                     |  3 +++
 net/packet/af_packet.c                                           |  9 ++++++--
 net/socket.c                                                     | 23 +++++++-------------
 net/tls/tls_device.c                                             |  3 ++-
 net/tls/tls_sw.c                                                 |  3 ++-
 net/vmw_vsock/af_vsock.c                                         |  2 +-
 tools/bpf/bpftool/iter.c                                         |  9 +++++---
 tools/bpf/resolve_btfids/main.c                                  |  1 +
 tools/include/uapi/linux/bpf.h                                   | 15 +++++++------
 tools/lib/bpf/bpf.c                                              |  3 +++
 tools/lib/bpf/bpf.h                                              |  5 ++++-
 tools/lib/bpf/btf.c                                              |  2 +-
 tools/lib/bpf/libbpf.c                                           |  6 ++----
 tools/lib/bpf/libbpf.h                                           |  5 +++--
 tools/testing/selftests/bpf/Makefile                             | 53 ++++++++++++++++++++++++---------------------
 tools/testing/selftests/bpf/prog_tests/bpf_iter.c                | 40 +++++++++++++++++++++++++++-------
 tools/testing/selftests/bpf/prog_tests/send_signal.c             | 18 +++++++---------
 tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c |  4 +++-
 tools/testing/selftests/bpf/settings                             |  1 +
 tools/testing/selftests/bpf/test_tcpnotify_user.c                | 13 ++++++++---
 tools/testing/selftests/net/mptcp/config                         |  2 ++
 tools/testing/selftests/net/mptcp/mptcp_connect.c                |  9 ++++----
 66 files changed, 494 insertions(+), 350 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/settings
