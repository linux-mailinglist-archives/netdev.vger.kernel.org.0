Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC0F11E95C3
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 07:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728712AbgEaFNM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 31 May 2020 01:13:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbgEaFNL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 May 2020 01:13:11 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7821CC05BD43;
        Sat, 30 May 2020 22:13:11 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6250D12905C1B;
        Sat, 30 May 2020 22:13:10 -0700 (PDT)
Date:   Sat, 30 May 2020 22:13:09 -0700 (PDT)
Message-Id: <20200530.221309.1347376729998812574.davem@davemloft.net>
To:     torvalds@linux-foundation.org
CC:     akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 30 May 2020 22:13:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Another week, another set of bug fixes:

1) Fix pskb_pull length in __xfrm_transport_prep(), from Xin Long.

2) Fix double xfrm_state put in esp{4,6}_gro_receive(), also from Xin
   Long.

3) Re-arm discovery timer properly in mac80211 mesh code, from Linus
   Lüssing.

4) Prevent buffer overflows in nf_conntrack_pptp debug code, from Pablo
   Neira Ayuso.

5) Fix race in ktls code between tls_sw_recvmsg() and
   tls_decrypt_done(), from Vinay Kumar Yadav.

6) Fix crashes on TCP fallback in MPTCP code, from Paolo Abeni.

7) More validation is necessary of untrusted GSO packets coming from
   virtualization devices, from Willem de Bruijn.

8) Fix endianness of bnxt_en firmware message length accesses, from
   Edwin Peer.

9) Fix infinite loop in sch_fq_pie, from Davide Caratti.

10) Fix lockdep splat in DSA by setting lockless TX in netdev features
    for slave ports, from Vladimir Oltean.

11) Fix suspend/resume crashes in mlx5, from Mark Bloch.

12) Fix use after free in bpf fmod_ret, from Alexei Starovoitov.

13) ARP retransmit timer guard uses wrong offset, from Hongbin Liu.

14) Fix leak in inetdev_init(), from Yang Yingliang.

15) Don't try to use inet hash and unhash in l2tp code, results in
    crashes.  From Eric Dumazet.

Please pull, thanks a lot!

The following changes since commit 98790bbac4db1697212ce9462ec35ca09c4a2810:

  Merge tag 'efi-urgent-2020-05-24' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip (2020-05-24 10:24:10 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git 

for you to fetch changes up to d9a81a225277686eb629938986d97629ea102633:

  l2tp: add sk_family checks to l2tp_validate_socket (2020-05-30 21:56:55 -0700)

----------------------------------------------------------------
Alexei Starovoitov (1):
      bpf: Fix use-after-free in fmod_ret check

Antony Antony (1):
      xfrm: fix error in comment

Arnd Bergmann (1):
      bridge: multicast: work around clang bug

Aya Levin (1):
      net/mlx5e: Fix arch depending casting issue in FEC

Björn Töpel (1):
      xsk: Add overflow check for u64 division, stored into u32

Chris Lew (1):
      net: qrtr: Allocate workqueue before kernel_bind

Chris Packham (1):
      net: sctp: Fix spelling in Kconfig help

Chuhong Yuan (1):
      NFC: st21nfca: add missed kfree_skb() in an error path

Daniele Palmas (1):
      net: usb: qmi_wwan: add Telit LE910C1-EUX composition

David Ahern (4):
      nexthops: Move code from remove_nexthop_from_groups to remove_nh_grp_entry
      nexthop: Expand nexthop_is_multipath in a few places
      ipv4: Refactor nhc evaluation in fib_table_lookup
      ipv4: nexthop version of fib_info_nh_uses_dev

David S. Miller (9):
      Merge tag 'mac80211-for-net-2020-05-25' of git://git.kernel.org/.../jberg/mac80211
      Merge git://git.kernel.org/.../pablo/nf
      Merge branch 'nexthop-group-fixes'
      Merge branch 'bnxt_en-Bug-fixes'
      Merge git://git.kernel.org/.../pablo/nf
      Merge branch 'master' of git://git.kernel.org/.../klassert/ipsec
      Merge git://git.kernel.org/.../bpf/bpf
      Merge tag 'mlx5-fixes-2020-05-28' of git://git.kernel.org/.../saeed/linux
      Merge branch 'mptcp-a-bunch-of-fixes'

Davide Caratti (1):
      net/sched: fix infinite loop in sch_fq_pie

Edwin Peer (1):
      bnxt_en: fix firmware message length endianness

Eric Dumazet (4):
      crypto: chelsio/chtls: properly set tp->lsndtime
      net: be more gentle about silly gso requests coming from user
      l2tp: do not use inet_hash()/inet_unhash()
      l2tp: add sk_family checks to l2tp_validate_socket

Fugang Duan (1):
      net: stmmac: enable timestamp snapshot for required PTP packets in dwmac v5.10a

Hangbin Liu (1):
      neigh: fix ARP retransmit timer guard

Heinrich Kuhn (1):
      nfp: flower: fix used time of merge flow statistics

Jia He (1):
      virtio_vsock: Fix race condition in virtio_transport_recv_pkt

Johannes Berg (1):
      cfg80211: fix debugfs rename crash

John Fastabend (3):
      bpf: Fix a verifier issue when assigning 32bit reg states to 64bit ones
      bpf, selftests: Verifier bounds tests need to be updated
      bpf, selftests: Add a verifier test for assigning 32bit reg states to 64bit ones

Jonas Falkevik (1):
      sctp: check assoc before SCTP_ADDR_{MADE_PRIM, ADDED} event

Linus Lüssing (1):
      mac80211: mesh: fix discovery timer re-arming issue / crash

Maor Dickman (1):
      net/mlx5e: Remove warning "devices are not on same switch HW"

Mark Bloch (1):
      net/mlx5: Fix crash upon suspend/resume

Michael Braun (1):
      netfilter: nft_reject_bridge: enable reject with bridge vlan

Michael Chan (1):
      bnxt_en: Fix accumulation of bp->net_stats_prev.

Nathan Chancellor (1):
      netfilter: conntrack: Pass value of ctinfo to __nf_conntrack_update

Nicolas Dichtel (1):
      xfrm interface: fix oops when deleting a x-netns interface

Nikolay Aleksandrov (1):
      nexthops: don't modify published nexthop groups

Pablo Neira Ayuso (6):
      netfilter: nf_conntrack_pptp: prevent buffer overflows in debug code
      netfilter: conntrack: make conntrack userspace helpers work again
      netfilter: nfnetlink_cthelper: unbreak userspace helper support
      netfilter: conntrack: comparison of unsigned in cthelper confirmation
      netfilter: nf_conntrack_pptp: fix compilation warning with W=1 build
      net/mlx5e: replace EINVAL in mlx5e_flower_parse_meta()

Paolo Abeni (4):
      mptcp: avoid NULL-ptr derefence on fallback
      mptcp: fix unblocking connect()
      mptcp: fix race between MP_JOIN and close
      mptcp: remove msk from the token container at destruction time.

Petr Mladek (1):
      powerpc/bpf: Enable bpf_probe_read{, str}() on powerpc again

Phil Sutter (1):
      netfilter: ipset: Fix subcounter update skip

Pradeep Kumar Chitrapu (1):
      ieee80211: Fix incorrect mask for default PE duration

Qiushi Wu (2):
      qlcnic: fix missing release in qlcnic_83xx_interrupt_test.
      bonding: Fix reference count leak in bond_sysfs_slave_add.

Roi Dayan (1):
      net/mlx5e: Fix stats update for matchall classifier

Sabrina Dubroca (1):
      xfrm: espintcp: save and call old ->sk_destruct

Stefano Garzarella (1):
      vsock: fix timeout in vsock_accept()

Tal Gilboa (1):
      net/mlx5e: Properly set default values when disabling adaptive moderation

Thomas Falcon (1):
      drivers/net/ibmvnic: Update VNIC protocol version reporting

Vasundhara Volam (1):
      bnxt_en: Fix return code to "flash_device".

Vinay Kumar Yadav (1):
      net/tls: fix race condition causing kernel panic

Vlad Buslov (1):
      net/mlx5e: Fix MLX5_TC_CT dependencies

Vladimir Oltean (3):
      dpaa_eth: fix usage as DSA master, try 3
      net: dsa: felix: send VLANs on CPU port as egress-tagged
      net: dsa: declare lockless TX feature for slave ports

Willem de Bruijn (1):
      net: check untrusted gso_size at kernel entry

Xin Long (12):
      xfrm: allow to accept packets with ipv6 NEXTHDR_HOP in xfrm_input
      xfrm: do pskb_pull properly in __xfrm_transport_prep
      esp6: get the right proto for transport mode in esp6_gso_encap
      xfrm: remove the xfrm_state_put call becofe going to out_reset
      esp6: support ipv6 nexthdrs process for beet gso segment
      esp4: support ipv6 nexthdrs process for beet gso segment
      xfrm: call xfrm_output_gso when inner_protocol is set in xfrm_output
      ip_vti: receive ipip packet by calling ip_tunnel_rcv
      esp6: calculate transport_header correctly when sel.family != AF_INET6
      esp4: improve xfrm4_beet_gso_segment() to be more readable
      xfrm: fix a warning in xfrm_policy_insert_list
      xfrm: fix a NULL-ptr deref in xfrm_local_error

Yang Yingliang (1):
      devinet: fix memleak in inetdev_init()

wenxu (1):
      net/sched: act_ct: add nat mangle action only for NAT-conntrack

 arch/powerpc/Kconfig                                           |   1 +
 drivers/crypto/chelsio/chtls/chtls_io.c                        |   2 +-
 drivers/net/bonding/bond_sysfs_slave.c                         |   4 ++-
 drivers/net/dsa/ocelot/felix.c                                 |   8 +++--
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                      |  16 +++------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h                      |   5 ---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c              |   9 ++---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c                 |   2 +-
 drivers/net/ethernet/ibm/ibmvnic.c                             |   8 ++---
 drivers/net/ethernet/mellanox/mlx5/core/Kconfig                |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h                   |  10 +++---
 drivers/net/ethernet/mellanox/mlx5/core/en/port.c              |  24 +++++++------
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c           |  41 +++++++++++++++-------
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c              |  20 +++++++----
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c                |  12 +++----
 drivers/net/ethernet/mellanox/mlx5/core/main.c                 |  18 ++++++++++
 drivers/net/ethernet/netronome/nfp/flower/offload.c            |   3 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c            |   4 ++-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c              |   3 +-
 drivers/net/usb/qmi_wwan.c                                     |   1 +
 drivers/nfc/st21nfca/dep.c                                     |   4 ++-
 include/linux/ieee80211.h                                      |   2 +-
 include/linux/netfilter/nf_conntrack_pptp.h                    |   2 +-
 include/linux/virtio_net.h                                     |  25 ++++++++++----
 include/net/espintcp.h                                         |   1 +
 include/net/ip_fib.h                                           |  12 +++++++
 include/net/nexthop.h                                          | 100 ++++++++++++++++++++++++++++++++++++++++++++---------
 include/net/tls.h                                              |   4 +++
 include/uapi/linux/xfrm.h                                      |   2 +-
 kernel/bpf/verifier.c                                          |  34 +++++++++----------
 net/bridge/br_multicast.c                                      |   3 +-
 net/bridge/netfilter/nft_reject_bridge.c                       |   6 ++++
 net/core/neighbour.c                                           |   4 +--
 net/dsa/slave.c                                                |   1 +
 net/ipv4/devinet.c                                             |   1 +
 net/ipv4/esp4_offload.c                                        |  30 +++++++++-------
 net/ipv4/fib_frontend.c                                        |  19 ++++++-----
 net/ipv4/fib_trie.c                                            |  51 ++++++++++++++++++++--------
 net/ipv4/ip_vti.c                                              |  23 ++++++++++++-
 net/ipv4/netfilter/nf_nat_pptp.c                               |   7 ++--
 net/ipv4/nexthop.c                                             | 102 ++++++++++++++++++++++++++++++++++---------------------
 net/ipv6/esp6_offload.c                                        |  37 +++++++++++++-------
 net/l2tp/l2tp_core.c                                           |   3 ++
 net/l2tp/l2tp_ip.c                                             |  29 ++++++++++++----
 net/l2tp/l2tp_ip6.c                                            |  30 +++++++++++-----
 net/mac80211/mesh_hwmp.c                                       |   7 ++++
 net/mptcp/protocol.c                                           |  67 +++++++++++++++++++++++++-----------
 net/netfilter/ipset/ip_set_list_set.c                          |   2 +-
 net/netfilter/nf_conntrack_core.c                              |  80 +++++++++++++++++++++++++++++++++++++++----
 net/netfilter/nf_conntrack_pptp.c                              |  62 ++++++++++++++++++---------------
 net/netfilter/nfnetlink_cthelper.c                             |   3 +-
 net/qrtr/ns.c                                                  |  10 +++---
 net/sched/act_ct.c                                             |   3 ++
 net/sched/sch_fq_pie.c                                         |   4 +--
 net/sctp/Kconfig                                               |   2 +-
 net/sctp/ulpevent.c                                            |   3 ++
 net/tls/tls_sw.c                                               |  33 ++++++++++++++----
 net/vmw_vsock/af_vsock.c                                       |   2 +-
 net/vmw_vsock/virtio_transport_common.c                        |   8 +++++
 net/wireless/core.c                                            |   2 +-
 net/xdp/xdp_umem.c                                             |   8 +++--
 net/xfrm/espintcp.c                                            |   2 ++
 net/xfrm/xfrm_device.c                                         |   8 ++---
 net/xfrm/xfrm_input.c                                          |   2 +-
 net/xfrm/xfrm_interface.c                                      |  21 ++++++++++++
 net/xfrm/xfrm_output.c                                         |  15 ++++----
 net/xfrm/xfrm_policy.c                                         |   7 +---
 tools/testing/selftests/bpf/verifier/bounds.c                  |  46 +++++++++++++++++--------
 tools/testing/selftests/tc-testing/tc-tests/qdiscs/fq_pie.json |  21 ++++++++++++
 69 files changed, 806 insertions(+), 337 deletions(-)
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/fq_pie.json
