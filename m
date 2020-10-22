Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A85C72966CD
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 23:48:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S372504AbgJVVsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 17:48:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:59790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S372495AbgJVVsb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Oct 2020 17:48:31 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A33622245F;
        Thu, 22 Oct 2020 21:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603403308;
        bh=+H0db8rZYnEbxU1gDk+RpeEHUnhCTHJOuS3ETY70Tis=;
        h=Date:From:To:Cc:Subject:From;
        b=erSSGKKnJj+285pm6gL3oO6vAEZXtkSjdaZdRjmzwrmdnvV4LHTZmD5popQjkHS11
         hKkfKkuRN5D6WE18mLa7MubTCcMh8ZltSzW2CoQjnw+0dWJF3m1dlO9XDBfTlfAjv0
         l98FmItdqSkjc8I8y2xjT1KjdNnL2BF9iJNLOz/s=
Date:   Thu, 22 Oct 2020 14:48:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking
Message-ID: <20201022144826.45665c12@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

Latest fixes from the networking tree. Experimenting with the format=20
of the description further, I'll find out if you liked it based on how=20
it ends up looking in the tree :)

The following changes since commit 9ff9b0d392ea08090cd1780fb196f36dbb586529:

  Merge tag 'net-next-5.10' of git://git.kernel.org/pub/scm/linux/kernel/gi=
t/netdev/net-next (2020-10-15 18:42:13 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.1=
0-rc1

for you to fetch changes up to 18ded910b589839e38a51623a179837ab4cc3789:

  tcp: fix to update snd_wl1 in bulk receiver fast path (2020-10-22 12:26:5=
7 -0700)

----------------------------------------------------------------
Fixes for 5.10-rc1 from the networking tree:

Cross-tree/merge window issues:

 - rtl8150: don't incorrectly assign random MAC addresses; fix late
   in the 5.9 cycle started depending on a return code from
   a function which changed with the 5.10 PR from the usb subsystem

Current release - regressions:

 - Revert "virtio-net: ethtool configurable RXCSUM", it was causing
   crashes at probe when control vq was not negotiated/available

Previous releases - regressions:

 - ixgbe: fix probing of multi-port 10 Gigabit Intel NICs with an MDIO
   bus, only first device would be probed correctly

 - nexthop: Fix performance regression in nexthop deletion by
   effectively switching from recently added synchronize_rcu()
   to synchronize_rcu_expedited()

 - netsec: ignore 'phy-mode' device property on ACPI systems;
   the property is not populated correctly by the firmware,
   but firmware configures the PHY so just keep boot settings

Previous releases - always broken:

 - tcp: fix to update snd_wl1 in bulk receiver fast path, addressing
   bulk transfers getting "stuck"

 - icmp: randomize the global rate limiter to prevent attackers from
   getting useful signal

 - r8169: fix operation under forced interrupt threading, make the
   driver always use hard irqs, even on RT, given the handler is
   light and only wants to schedule napi (and do so through
   a _irqoff() variant, preferably)

 - bpf: Enforce pointer id generation for all may-be-null register
   type to avoid pointers erroneously getting marked as null-checked

 - tipc: re-configure queue limit for broadcast link

 - net/sched: act_tunnel_key: fix OOB write in case of IPv6 ERSPAN
   tunnels

 - fix various issues in chelsio inline tls driver

Misc:

 - bpf: improve just-added bpf_redirect_neigh() helper api to support
   supplying nexthop by the caller - in case BPF program has already
   done a lookup we can avoid doing another one

 - remove unnecessary break statements

 - make MCTCP not select IPV6, but rather depend on it

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Alexander Ovechkin (1):
      mpls: load mpls_gso after mpls_iptunnel

Anant Thazhemadam (1):
      net: usb: rtl8150: don't incorrectly assign random MAC addresses

Ard Biesheuvel (1):
      netsec: ignore 'phy-mode' device property on ACPI systems

Bartosz Golaszewski (1):
      net: ethernet: mtk-star-emac: select REGMAP_MMIO

Christian Eggers (1):
      net: dsa: tag_ksz: KSZ8795 and KSZ9477 also use tail tags

Colin Ian King (1):
      net: dsa: bcm_sf2: make const array static, makes object smaller

Daniel Borkmann (2):
      bpf, doc: Fix patchwork URL to point to kernel.org instance
      bpf, libbpf: Guard bpf inline asm from bpf_tail_call_static

Davide Caratti (1):
      net/sched: act_tunnel_key: fix OOB write in case of IPv6 ERSPAN tunne=
ls

Defang Bo (1):
      nfc: Ensure presence of NFC_ATTR_FIRMWARE_NAME attribute in nfc_genl_=
fw_download()

Di Zhu (1):
      rtnetlink: fix data overflow in rtnl_calcit()

Dylan Hung (1):
      net: ftgmac100: Fix Aspeed ast2600 TX hang issue

Edward Cree (1):
      sfc: move initialisation of efx->filter_sem to efx_init_struct()

Eelco Chaudron (1):
      net: openvswitch: fix to make sure flow_lookup() is not preempted

Eric Dumazet (1):
      icmp: randomize the global rate limiter

Francesco Ruggeri (1):
      netfilter: conntrack: connection timeout after re-register

Geert Uytterhoeven (2):
      mptcp: MPTCP_KUNIT_TESTS should depend on MPTCP instead of selecting =
it
      mptcp: MPTCP_IPV6 should depend on IPV6 instead of selecting it

Geliang Tang (2):
      mptcp: initialize mptcp_options_received's ahmac
      mptcp: move mptcp_options_received's port initialization

Georg Kohmann (1):
      netfilter: Drop fragmented ndisc packets assembled in netfilter

Guillaume Nault (1):
      net/sched: act_gate: Unlock ->tcfa_lock in tc_setup_flow_action()

Heiner Kallweit (1):
      r8169: fix operation under forced interrupt threading

Hoang Huu Le (2):
      tipc: re-configure queue limit for broadcast link
      tipc: fix incorrect setting window for bcast link

Ido Schimmel (2):
      selftests: forwarding: Add missing 'rp_filter' configuration
      nexthop: Fix performance regression in nexthop deletion

Ioana Ciornei (1):
      net: pcs-xpcs: depend on MDIO_BUS instead of selecting it

Jakub Kicinski (5):
      ixgbe: fix probing of multi-port devices with one MDIO
      Merge branch 'init-ahmac-and-port-of-mptcp_options_received'
      Merge branch 'chelsio-chtls-fix-inline-tls-bugs'
      Merge git://git.kernel.org/.../bpf/bpf
      Merge git://git.kernel.org/.../pablo/nf

Jeremy Sowden (1):
      docs: nf_flowtable: fix typo.

Ke Li (1):
      net: Properly typecast int values to set sk_max_pacing_rate

Lijun Pan (1):
      ibmvnic: save changed mac address to adapter->mac_addr

Martin KaFai Lau (3):
      bpf: Enforce id generation for all may-be-null register type
      bpf: selftest: Ensure the return value of bpf_skc_to helpers must be =
checked
      bpf: selftest: Ensure the return value of the bpf_per_cpu_ptr() must =
be checked

Matthieu Baerts (2):
      mptcp: depends on IPV6 but not as a module
      selftests: mptcp: depends on built-in IPv6

Maxim Kochetkov (1):
      net: dsa: seville: the packet buffer is 2 megabits, not megabytes

Michael S. Tsirkin (1):
      Revert "virtio-net: ethtool configurable RXCSUM"

Neal Cardwell (1):
      tcp: fix to update snd_wl1 in bulk receiver fast path

Pablo Neira Ayuso (1):
      netfilter: nf_fwd_netdev: clear timestamp in forwarding path

Po-Hsu Lin (1):
      selftests: rtnetlink: load fou module for kci_test_encap_fou() test

Randy Dunlap (1):
      net: chelsio: inline_crypto: fix Kconfig and build errors

Roi Dayan (1):
      net/sched: act_ct: Fix adding udp port mangle operation

Saeed Mirzamohammadi (1):
      netfilter: nftables_offload: KASAN slab-out-of-bounds Read in nft_flo=
w_rule_create

Taehee Yoo (1):
      net: core: use list_del_init() instead of list_del() in netdev_run_to=
do()

Timoth=C3=A9e COCAULT (1):
      netfilter: ebtables: Fixes dropping of small packets in bridge nat

Toke H=C3=B8iland-J=C3=B8rgensen (2):
      bpf: Fix bpf_redirect_neigh helper api to support supplying nexthop
      bpf, selftests: Extend test_tc_redirect to use modified bpf_redirect_=
neigh()

Tom Rix (3):
      bpf: Remove unneeded break
      net: remove unneeded break
      nfc: remove unneeded break

Valentin Vidic (1):
      net: korina: cast KSEG0 address to pointer in kfree

Vinay Kumar Yadav (6):
      chelsio/chtls: fix socket lock
      chelsio/chtls: correct netdevice for vlan interface
      chelsio/chtls: fix panic when server is on ipv6
      chelsio/chtls: Fix panic when listen on multiadapter
      chelsio/chtls: correct function return and return type
      chelsio/chtls: fix writing freed memory

Xie He (2):
      net: hdlc: In hdlc_rcv, check to make sure dev is an HDLC device
      net: hdlc_raw_eth: Clear the IFF_TX_SKB_SHARING flag after calling et=
her_setup

longguang.yue (1):
      ipvs: adjust the debug info in function set_tcp_state

 .../devicetree/bindings/net/socionext-netsec.txt   |   4 +-
 Documentation/networking/ip-sysctl.rst             |   4 +-
 Documentation/networking/nf_flowtable.rst          |   2 +-
 MAINTAINERS                                        |   3 +-
 drivers/net/dsa/bcm_sf2.c                          |   2 +-
 drivers/net/dsa/ocelot/seville_vsc9953.c           |   2 +-
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c    |   1 -
 drivers/net/ethernet/chelsio/inline_crypto/Kconfig |   1 +
 .../chelsio/inline_crypto/chtls/chtls_cm.c         |  19 ++-
 .../chelsio/inline_crypto/chtls/chtls_io.c         |   5 +-
 drivers/net/ethernet/cisco/enic/enic_ethtool.c     |   1 -
 drivers/net/ethernet/faraday/ftgmac100.c           |   5 +
 drivers/net/ethernet/faraday/ftgmac100.h           |   8 +
 drivers/net/ethernet/ibm/ibmvnic.c                 |   5 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c       |  23 +--
 drivers/net/ethernet/intel/ixgbe/ixgbe_x540.c      |   1 -
 drivers/net/ethernet/korina.c                      |   4 +-
 drivers/net/ethernet/mediatek/Kconfig              |   1 +
 drivers/net/ethernet/realtek/r8169_main.c          |   8 +-
 drivers/net/ethernet/sfc/efx_common.c              |   1 +
 drivers/net/ethernet/sfc/rx_common.c               |   1 -
 drivers/net/ethernet/socionext/netsec.c            |  24 ++-
 drivers/net/pcs/Kconfig                            |   3 +-
 drivers/net/usb/rtl8150.c                          |   2 +-
 drivers/net/virtio_net.c                           |  48 ++----
 drivers/net/wan/hdlc.c                             |  10 +-
 drivers/net/wan/hdlc_raw_eth.c                     |   1 +
 drivers/net/wan/lmc/lmc_proto.c                    |   4 -
 drivers/nfc/st21nfca/core.c                        |   1 -
 drivers/nfc/trf7970a.c                             |   1 -
 include/linux/filter.h                             |   9 ++
 include/linux/netlink.h                            |   2 +-
 include/net/netfilter/nf_tables.h                  |   6 +
 include/uapi/linux/bpf.h                           |  22 ++-
 kernel/bpf/syscall.c                               |   1 -
 kernel/bpf/verifier.c                              |  11 +-
 net/bridge/netfilter/ebt_dnat.c                    |   2 +-
 net/bridge/netfilter/ebt_redirect.c                |   2 +-
 net/bridge/netfilter/ebt_snat.c                    |   2 +-
 net/core/dev.c                                     |   2 +-
 net/core/filter.c                                  | 161 +++++++++++++----=
----
 net/core/rtnetlink.c                               |  13 +-
 net/core/sock.c                                    |   2 +-
 net/dsa/tag_ksz.c                                  |   2 +
 net/ipv4/icmp.c                                    |   7 +-
 net/ipv4/nexthop.c                                 |   2 +-
 net/ipv4/tcp_input.c                               |   2 +
 net/ipv6/netfilter/nf_conntrack_reasm.c            |   1 +
 net/mpls/mpls_iptunnel.c                           |   1 +
 net/mptcp/Kconfig                                  |   6 +-
 net/mptcp/options.c                                |   3 +-
 net/netfilter/ipvs/ip_vs_proto_tcp.c               |  10 +-
 net/netfilter/nf_conntrack_proto_tcp.c             |  19 ++-
 net/netfilter/nf_dup_netdev.c                      |   1 +
 net/netfilter/nf_tables_api.c                      |   6 +-
 net/netfilter/nf_tables_offload.c                  |   4 +-
 net/netfilter/nft_fwd_netdev.c                     |   1 +
 net/nfc/netlink.c                                  |   2 +-
 net/openvswitch/flow_table.c                       |  58 +++++---
 net/openvswitch/flow_table.h                       |   8 +-
 net/sched/act_ct.c                                 |   4 +-
 net/sched/act_tunnel_key.c                         |   2 +-
 net/sched/cls_api.c                                |   2 +-
 net/tipc/bcast.c                                   |  10 +-
 samples/bpf/sockex3_kern.c                         |   8 +-
 scripts/bpf_helpers_doc.py                         |   1 +
 tools/include/uapi/linux/bpf.h                     |  22 ++-
 tools/lib/bpf/bpf_helpers.h                        |   2 +
 tools/testing/selftests/bpf/prog_tests/ksyms_btf.c |  57 +++++---
 .../bpf/progs/test_ksyms_btf_null_check.c          |  31 ++++
 tools/testing/selftests/bpf/progs/test_tc_neigh.c  |   5 +-
 .../selftests/bpf/progs/test_tc_neigh_fib.c        | 155 +++++++++++++++++=
+++
 tools/testing/selftests/bpf/test_tc_redirect.sh    |  18 ++-
 tools/testing/selftests/bpf/verifier/sock.c        |  25 ++++
 tools/testing/selftests/net/config                 |   1 +
 .../selftests/net/forwarding/vxlan_asymmetric.sh   |  10 ++
 .../selftests/net/forwarding/vxlan_symmetric.sh    |  10 ++
 tools/testing/selftests/net/mptcp/config           |   1 +
 tools/testing/selftests/net/rtnetlink.sh           |   5 +
 79 files changed, 676 insertions(+), 256 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/test_ksyms_btf_null_c=
heck.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_tc_neigh_fib.c
