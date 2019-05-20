Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37B2022C11
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 08:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730745AbfETG2J convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 20 May 2019 02:28:09 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48130 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728634AbfETG2J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 02:28:09 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1046E14D3AC65;
        Sun, 19 May 2019 23:28:08 -0700 (PDT)
Date:   Sun, 19 May 2019 23:28:05 -0700 (PDT)
Message-Id: <20190519.232805.495214807000862867.davem@davemloft.net>
To:     torvalds@linux-foundation.org
CC:     akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 19 May 2019 23:28:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


1) Use after free in __dev_map_entry_free(), from Eric Dumazet.

2) Fix TCP retransmission timestamps on passive Fast Open, from
   Yuchung Cheng.

3) Orphan NFC, we'll take the patches directly into my tree.  From
   Johannes Berg.

4) We can't recycle cloned TCP skbs, from Eric Dumazet.

5) Some flow dissector bpf test fixes, from Stanislav Fomichev.

6) Fix RCU marking and warnings in rhashtable, from Herbert Xu.

7) Fix some potential fib6 leaks, from Eric Dumazet.

8) Fix a _decode_session4 uninitialized memory read bug fix that got
   lost in a merge.  From Florian Westphal.

9) Fix ipv6 source address routing wrt. exception route entries, from
   Wei Wang.

10) The netdev_xmit_more() conversion was not done %100 properly in mlx5
    driver, fix from Tariq Toukan.

11) Clean up botched merge on netfilter kselftest, from Florian Westphal.

Please pull, thanks a lot!

The following changes since commit 35c99ffa20edd3c24be352d28a63cd3a23121282:

  Merge tag 'for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost (2019-05-14 14:12:59 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git 

for you to fetch changes up to 6a0a923dfa1480df41fb486323b8375e387d516f:

  of_net: fix of_get_mac_address retval if compiled without CONFIG_OF (2019-05-19 10:35:20 -0700)

----------------------------------------------------------------
Alexei Starovoitov (2):
      Merge branch 'lru-map-fix'
      selftests/bpf: fix bpf_get_current_task

Andrii Nakryiko (2):
      libbpf: move logging helpers into libbpf_internal.h
      bpftool: fix BTF raw dump of FWD's fwd_kind

Bodong Wang (1):
      net/mlx5: Fix peer pf disable hca command

Chenbo Feng (1):
      bpf: relax inode permission check for retrieving bpf program

Claudiu Manoil (3):
      enetc: Fix NULL dma address unmap for Tx BD extensions
      enetc: Allow to disable Tx SG
      enetc: Add missing link state info for ethtool

Daniel Borkmann (3):
      bpf: add map_lookup_elem_sys_only for lookups from syscall side
      bpf, lru: avoid messing with eviction heuristics upon syscall lookup
      bpf: test ref bit from data path and add new tests for syscall path

Daniele Palmas (1):
      net: usb: qmi_wwan: add Telit 0x1260 and 0x1261 compositions

David Ahern (1):
      selftests: pmtu.sh: Remove quotes around commands in setup_xfrm

David S. Miller (8):
      Merge git://git.kernel.org/.../bpf/bpf
      Merge branch 'rhashtable-Fix-sparse-warnings'
      Merge branch 'flow_offload-fix-CVLAN-support'
      Merge branch 'aqc111-revert-endianess-fixes-and-cleanup-mtu-logic'
      Revert "tipc: fix modprobe tipc failed after switch order of device registration"
      Merge tag 'mlx5-fixes-2019-05-17' of git://git.kernel.org/.../saeed/linux
      Merge git://git.kernel.org/.../bpf/bpf
      Merge branch 'mlxsw-Two-port-module-fixes'

Dmytro Linkin (2):
      net/mlx5e: Add missing ethtool driver info for representors
      net/mlx5e: Additional check for flow destination comparison

Edward Cree (1):
      flow_offload: support CVLAN match

Eli Britstein (3):
      net/mlx5e: Fix number of vports for ingress ACL configuration
      net/mlx5e: Fix no rewrite fields with the same match
      net/mlx5e: Fix possible modify header actions memory leak

Eric Dumazet (4):
      bpf: devmap: fix use-after-free Read in __dev_map_entry_free
      tcp: do not recycle cloned skbs
      ipv6: prevent possible fib6 leaks
      net: avoid weird emergency message

Florian Fainelli (1):
      net: Always descend into dsa/

Florian Westphal (2):
      xfrm: ressurrect "Fix uninitialized memory read in _decode_session4"
      kselftests: netfilter: fix leftover net/net-next merge conflict

Fuqian Huang (1):
      atm: iphase: Avoid copying pointers to user space.

Gary Lin (2):
      bpf: btf: fix the brackets of BTF_INT_OFFSET()
      tools/bpf: Sync kernel btf.h header

Herbert Xu (2):
      rhashtable: Remove RCU marking from rhash_lock_head
      rhashtable: Fix cmpxchg RCU warnings

Igor Russkikh (3):
      Revert "aqc111: fix double endianness swap on BE"
      Revert "aqc111: fix writing to the phy on BE"
      aqc111: cleanup mtu related logic

Jianbo Liu (1):
      net/mlx5e: Fix calling wrong function to get inner vlan key and mask

Johannes Berg (1):
      NFC: Orphan the subsystem

John Fastabend (4):
      bpf: sockmap, only stop/flush strp if it was enabled at some point
      bpf: sockmap remove duplicate queue free
      bpf: sockmap fix msg->sg.size account on ingress skb
      bpf, tcp: correctly handle DONT_WAIT flags and timeo == 0

Jorge E. Moreira (1):
      vsock/virtio: Initialize core virtio vsock before registering the driver

Junwei Hu (2):
      tipc: switch order of device registration to fix a crash
      tipc: fix modprobe tipc failed after switch order of device registration

Konstantin Khlebnikov (1):
      net: bpfilter: fallback to netfilter if failed to load bpfilter kernel module

Luca Ceresoli (1):
      net: macb: fix error format in dev_err()

Madalin-cristian Bucur (1):
      net: phy: aquantia: readd XGMII support for AQR107

Parav Pandit (1):
      net/mlx5: E-Switch, Correct type to u16 for vport_num and int for vport_index

Patrick Talbert (1):
      net: Treat sock->sk_drops as an unsigned int when printing

Petr ¦tetiar (1):
      of_net: fix of_get_mac_address retval if compiled without CONFIG_OF

Philippe Mazenauer (1):
      lib: Correct comment of prandom_seed

Pieter Jansen van Vuuren (1):
      nfp: flower: add rcu locks when accessing netdev for tunnels

Randy Dunlap (1):
      net: fix kernel-doc warnings for socket.c

Sabrina Dubroca (1):
      rtnetlink: always put IFLA_LINK for links with a link-netnsid

Saeed Mahameed (2):
      net/mlx5: Imply MLXFW in mlx5_core
      net/mlx5e: Fix ethtool rxfh commands when CONFIG_MLX5_EN_RXNFC is disabled

Stanislav Fomichev (5):
      bpf: mark bpf_event_notify and bpf_event_init as static
      libbpf: don't fail when feature probing fails
      selftests/bpf: add missing \n to flow_dissector CHECK errors
      selftests/bpf: add prog detach to flow_dissector test
      selftests/bpf: add test_sysctl and map_tests/tests.h to .gitignore

Stefano Garzarella (1):
      vsock/virtio: free packets during the socket release

Sunil Muthuswamy (1):
      hv_sock: Add support for delayed close

Tariq Toukan (1):
      net/mlx5e: Fix wrong xmit_more application

Vadim Pasternak (2):
      mlxsw: core: Prevent QSFP module initialization for old hardware
      mlxsw: core: Prevent reading unsupported slave address from SFP EEPROM

Valentine Fatiev (1):
      net/mlx5: Add meaningful return codes to status_to_err function

Wei Wang (1):
      ipv6: fix src addr routing with the exception table

Willem de Bruijn (1):
      net: test nouarg before dereferencing zerocopy pointers

Yonghong Song (1):
      tools/bpftool: move set_max_rlimit() before __bpf_object__open_xattr()

Yuchung Cheng (1):
      tcp: fix retrans timestamp on passive Fast Open

YueHaibing (1):
      ppp: deflate: Fix possible crash in deflate_init

Yunjian Wang (1):
      net/mlx4_core: Change the error print to info print

swkhack (1):
      net: caif: fix the value of size argument of snprintf

 Documentation/bpf/btf.rst                                  |   2 +-
 MAINTAINERS                                                |   6 +-
 drivers/atm/iphase.c                                       |   6 --
 drivers/infiniband/hw/mlx5/ib_rep.c                        |  13 ++--
 drivers/infiniband/hw/mlx5/ib_rep.h                        |  12 ++--
 drivers/net/Makefile                                       |   2 +-
 drivers/net/ethernet/cadence/macb_main.c                   |  16 ++---
 drivers/net/ethernet/freescale/enetc/enetc.c               |   4 +-
 drivers/net/ethernet/freescale/enetc/enetc_ethtool.c       |   2 +
 drivers/net/ethernet/freescale/enetc/enetc_pf.c            |   2 +-
 drivers/net/ethernet/freescale/enetc/enetc_vf.c            |   2 +-
 drivers/net/ethernet/mellanox/mlx4/mcg.c                   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/Kconfig            |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c              |  22 ++++++-
 drivers/net/ethernet/mellanox/mlx5/core/ecpf.c             |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c       |  18 +++++-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c           |  19 +++++-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c            |  29 ++++++---
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c            |   9 +--
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c          |  20 +++---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h          |  22 +++----
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c |  20 +++---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c          |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c      |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h      |   3 +-
 drivers/net/ethernet/mellanox/mlxsw/core.c                 |   6 ++
 drivers/net/ethernet/mellanox/mlxsw/core.h                 |   2 +
 drivers/net/ethernet/mellanox/mlxsw/core_env.c             |  18 +++++-
 drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c           |   3 +
 drivers/net/ethernet/mellanox/mlxsw/core_thermal.c         |   6 ++
 drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c    |  17 +++--
 drivers/net/phy/aquantia_main.c                            |   1 +
 drivers/net/ppp/ppp_deflate.c                              |  20 ++++--
 drivers/net/usb/aqc111.c                                   |  35 +++-------
 drivers/net/usb/qmi_wwan.c                                 |   2 +
 include/linux/bpf.h                                        |   1 +
 include/linux/mlx5/eswitch.h                               |   6 +-
 include/linux/of_net.h                                     |   2 +-
 include/linux/rhashtable.h                                 |  58 +++++++++--------
 include/linux/skbuff.h                                     |   9 ++-
 include/net/flow_offload.h                                 |   2 +
 include/net/ip6_fib.h                                      |   3 +-
 include/net/sock.h                                         |   2 +-
 include/uapi/linux/btf.h                                   |   2 +-
 kernel/bpf/devmap.c                                        |   3 +
 kernel/bpf/hashtab.c                                       |  23 +++++--
 kernel/bpf/inode.c                                         |   2 +-
 kernel/bpf/syscall.c                                       |   5 +-
 kernel/trace/bpf_trace.c                                   |   5 +-
 lib/random32.c                                             |   4 +-
 lib/rhashtable.c                                           |  33 +++++-----
 net/caif/cfdbgl.c                                          |   2 +-
 net/caif/cfdgml.c                                          |   3 +-
 net/caif/cfutill.c                                         |   2 +-
 net/caif/cfveil.c                                          |   2 +-
 net/caif/cfvidl.c                                          |   2 +-
 net/core/dev.c                                             |   2 +-
 net/core/flow_offload.c                                    |   7 ++
 net/core/rtnetlink.c                                       |  16 +++--
 net/core/skmsg.c                                           |   7 +-
 net/ipv4/bpfilter/sockopt.c                                |   6 +-
 net/ipv4/ping.c                                            |   2 +-
 net/ipv4/raw.c                                             |   2 +-
 net/ipv4/tcp.c                                             |   2 +-
 net/ipv4/tcp_bpf.c                                         |   7 +-
 net/ipv4/tcp_input.c                                       |   3 +
 net/ipv4/udp.c                                             |   2 +-
 net/ipv6/datagram.c                                        |   2 +-
 net/ipv6/ip6_fib.c                                         |  12 +++-
 net/ipv6/route.c                                           |  58 ++++++++++-------
 net/netlink/af_netlink.c                                   |   2 +-
 net/phonet/socket.c                                        |   2 +-
 net/socket.c                                               |  34 +++++-----
 net/tipc/core.c                                            |  14 ++--
 net/vmw_vsock/hyperv_transport.c                           | 108 ++++++++++++++++++++++---------
 net/vmw_vsock/virtio_transport.c                           |  13 ++--
 net/vmw_vsock/virtio_transport_common.c                    |   7 ++
 net/xfrm/xfrm_policy.c                                     |  24 +++----
 tools/bpf/bpftool/btf.c                                    |   4 +-
 tools/bpf/bpftool/prog.c                                   |   4 +-
 tools/include/uapi/linux/btf.h                             |   2 +-
 tools/lib/bpf/btf.c                                        |   2 +-
 tools/lib/bpf/libbpf.c                                     |   3 +-
 tools/lib/bpf/libbpf_internal.h                            |  13 ++++
 tools/lib/bpf/libbpf_util.h                                |  13 ----
 tools/lib/bpf/xsk.c                                        |   2 +-
 tools/testing/selftests/bpf/.gitignore                     |   1 +
 tools/testing/selftests/bpf/bpf_helpers.h                  |   2 +-
 tools/testing/selftests/bpf/map_tests/.gitignore           |   1 +
 tools/testing/selftests/bpf/prog_tests/flow_dissector.c    |   9 +--
 tools/testing/selftests/bpf/test_lru_map.c                 | 288 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----
 tools/testing/selftests/net/pmtu.sh                        |  18 +++---
 tools/testing/selftests/netfilter/nft_nat.sh               |  77 ++++++++--------------
 93 files changed, 874 insertions(+), 416 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/map_tests/.gitignore
