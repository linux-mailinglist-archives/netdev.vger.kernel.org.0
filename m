Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5BFA20A954
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 01:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726398AbgFYXnv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 25 Jun 2020 19:43:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726360AbgFYXnu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 19:43:50 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E79BC08C5C1;
        Thu, 25 Jun 2020 16:43:50 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5396B1551C3B6;
        Thu, 25 Jun 2020 16:43:49 -0700 (PDT)
Date:   Thu, 25 Jun 2020 16:43:48 -0700 (PDT)
Message-Id: <20200625.164348.1339174087524887583.davem@davemloft.net>
To:     torvalds@linux-foundation.org
CC:     akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 25 Jun 2020 16:43:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


1) Don't insert ESP trailer twice in IPSEC code, from Huy Nguyen.

2) The default crypto algorithm selection in Kconfig for IPSEC is
   out of touch with modern reality, fix this up.  From Eric Biggers.

3) bpftool is missing an entry for BPF_MAP_TYPE_RINGBUF, from Andrii
   Nakryiko.

4) Missing init of ->frame_sz in xdp_convert_zc_to_xdp_frame(), from
   Hangbin Liu.

5) Adjust packet alignment handling in ax88179_178a driver to match
   what the hardware actually does.  From Jeremy Kerr.

6) register_netdevice can leak in the case one of the notifiers fail,
   from Yang Yingliang.

7) Use after free in ip_tunnel_lookup(), from Taehee Yoo.

8) VLAN checks in sja1105 DSA driver need adjustments, from Vladimir
   Oltean.

9) tg3 driver can sleep forever when we get enough EEH errors, fix
   from David Christensen.

10) Missing {READ,WRITE}_ONCE() annotations in various Intel ethernet
    drivers, from Ciara Loftus.

11) Fix scanning loop break condition in of_mdiobus_register(), from
    Florian Fainelli.

12) MTU limit is incorrect in ibmveth driver, from Thomas Falcon.

13) Endianness fix in mlxsw, from Ido Schimmel.

14) Use after free in smsc95xx usbnet driver, from Tuomas Tynkkynen.

15) Missing bridge mrp configuration validation, from Horatiu Vultur.

16) Fix circular netns references in wireguard, from Jason A. Donenfeld.

17) PTP initialization on recovery is not done properly in qed driver,
    from Alexander Lobakin.

18) Endian conversion of L4 ports in filters of cxgb4 driver is wrong,
    from Rahul Lakkireddy.

19) Don't clear bound device TX queue of socket prematurely otherwise
    we get problems with ktls hw offloading, from Tariq Toukan.

20) ipset can do atomics on unaligned memory, fix from Russell King.

21) Align ethernet addresses properly in bridging code, from Thomas
    Martitz.

22) Don't advertise ipv4 addresses on SCTP sockets having ipv6only
    set, from Marcelo Ricardo Leitner.

Please pull, thanks a lot!

The following changes since commit 69119673bd50b176ded34032fadd41530fb5af21:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2020-06-16 17:44:54 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net 

for you to fetch changes up to 4c342f778fe234e0c2a2601d87fec8ba42f0d2c6:

  rds: transport module should be auto loaded when transport is set (2020-06-25 16:26:25 -0700)

----------------------------------------------------------------
Aiden Leong (1):
      GUE: Fix a typo

Alexander Lobakin (11):
      net: ethtool: add missing NETIF_F_GSO_FRAGLIST feature string
      net: ethtool: add missing string for NETIF_F_GSO_TUNNEL_REMCSUM
      net: qed: fix left elements count calculation
      net: qed: fix async event callbacks unregistering
      net: qede: stop adding events on an already destroyed workqueue
      net: qed: fix NVMe login fails over VFs
      net: qed: fix excessive QM ILT lines consumption
      net: qede: fix PTP initialization on recovery
      net: qede: fix use-after-free on recovery and AER handling
      net: qed: reset ILT block sizes before recomputing to fix crashes
      net: qed: fix "maybe uninitialized" warning

Andrew Lunn (1):
      net: ethtool: Handle missing cable test TDR parameters

Andrii Nakryiko (3):
      bpf: Fix definition of bpf_ringbuf_output() helper in UAPI comments
      tools/bpftool: Add ringbuf map to a list of known map types
      bpf: bpf_probe_read_kernel_str() has to return amount of data read on success

Ard Biesheuvel (1):
      net: phy: mscc: avoid skcipher API for single block AES encryption

Björn Töpel (1):
      i40e: fix crash when Rx descriptor count is changed

Briana Oursler (1):
      tc-testing: avoid action cookies with odd length.

Ciara Loftus (3):
      ixgbe: protect ring accesses with READ- and WRITE_ONCE
      i40e: protect ring accesses with READ- and WRITE_ONCE
      ice: protect ring accesses with WRITE_ONCE

Claudiu Beznea (3):
      net: macb: undo operations in case of failure
      net: macb: call pm_runtime_put_sync on failure path
      net: macb: free resources on failure path of at91ether_open()

Claudiu Manoil (1):
      enetc: Fix HW_VLAN_CTAG_TX|RX toggling

Colin Ian King (1):
      qed: add missing error test for DBG_STATUS_NO_MATCHING_FRAMING_MODE

Daniel Mack (1):
      dsa: Allow forwarding of redirected IGMP traffic

Dany Madden (1):
      ibmvnic: continue to init in CRQ reset returns H_CLOSED

David Christensen (1):
      tg3: driver sleeps indefinitely when EEH errors exceed eeh_max_freezes

David Howells (4):
      rxrpc: Fix trace string
      rxrpc: Fix handling of rwind from an ACK packet
      rxrpc: Fix afs large storage transmission performance drop
      rxrpc: Fix notification call on completion of discarded calls

David S. Miller (24):
      Merge git://git.kernel.org/.../bpf/bpf
      Merge branch 'act_gate-fixes'
      Merge branch 'sja1105-fixes'
      Merge branch 'mptcp-cope-with-syncookie-on-MP_JOINs'
      Merge branch 's390-qeth-fixes'
      Merge branch '40GbE' of git://git.kernel.org/.../jkirsher/net-queue
      Merge branch 'master' of git://git.kernel.org/.../klassert/ipsec
      Merge branch 'net-phy-MDIO-bus-scanning-fixes'
      Merge tag 'rxrpc-fixes-20200618' of git://git.kernel.org/.../dhowells/linux-fs
      Merge branch 'several-fixes-for-indirect-flow_blocks-offload'
      Merge tag 'ieee802154-for-davem-2020-06-19' of git://git.kernel.org/.../sschmidt/wpan
      Merge branch 'bridge-mrp-Update-MRP_PORT_ROLE'
      Merge branch 'wg-fixes'
      Merge branch 'net-qed-qede-various-stability-fixes'
      Merge branch 'cxgb4-cxgb4vf-fix-warnings-reported-by-sparse'
      Merge branch 'bnxt_en-Bug-fixes'
      Merge branch 'Two-phylink-pause-fixes'
      Merge branch 'net-phy-call-phy_disable_interrupts-in-phy_init_hw'
      Merge branch 'net-bcmgenet-use-hardware-padding-of-runt-frames'
      Merge git://git.kernel.org/.../pablo/nf
      Merge branch 'Fixes-for-SJA1105-DSA-tc-gate-action'
      Merge branch 'tcp_cubic-fix-spurious-HYSTART_DELAY-on-RTT-decrease'
      Merge branch 'napi_gro_receive-caller-return-value-cleanups'
      Merge branch 'sched-A-couple-of-fixes-for-sch_cake'

David Wilder (4):
      netfilter: iptables: Split ipt_unregister_table() into pre_exit and exit helpers.
      netfilter: iptables: Add a .pre_exit hook in all iptable_foo.c.
      netfilter: ip6tables: Split ip6t_unregister_table() into pre_exit and exit helpers.
      netfilter: ip6tables: Add a .pre_exit hook in all ip6table_foo.c.

Davide Caratti (2):
      net/sched: act_gate: fix NULL dereference in tcf_gate_init()
      net/sched: act_gate: fix configuration of the periodic timer

Dejin Zheng (1):
      net: phy: smsc: fix printing too many logs

Denis Kirjanov (1):
      tcp: don't ignore ECN CWR on pure ACK

Doug Berger (3):
      net: bcmgenet: re-remove bcmgenet_hfb_add_filter
      net: bcmgenet: use __be16 for htons(ETH_P_IP)
      net: bcmgenet: use hardware padding of runt frames

Eric Biggers (3):
      esp, ah: consolidate the crypto algorithm selections
      esp: select CRYPTO_SEQIV
      esp, ah: modernize the crypto algorithm selections

Eric Dumazet (1):
      net: increment xmit_recursion level in dev_direct_xmit()

Felix Fietkau (1):
      MAINTAINERS: update email address for Felix Fietkau

Flavio Suligoi (2):
      net: ethernet: neterion: vxge: fix spelling mistake
      net: ethernet: oki-semi: pch_gbe: fix spelling mistake

Florian Fainelli (3):
      net: dsa: bcm_sf2: Fix node reference count
      of: of_mdio: Correct loop scanning logic
      net: phy: Check harder for errors in get_phy_id()

Florian Westphal (1):
      selftests: netfilter: add test case for conntrack helper assignment

Frank Werner-Krippendorf (1):
      wireguard: noise: do not assign initiation time in if condition

Gaurav Singh (2):
      bpf, xdp, samples: Fix null pointer dereference in *_user code
      ethtool: Fix check in ethtool_rx_flow_rule_create

Geliang Tang (1):
      mptcp: drop sndr_key in mptcp_syn_options

Hangbin Liu (2):
      xdp: Handle frame_sz in xdp_convert_zc_to_xdp_frame()
      tc-testing: update geneve options match in tunnel_key unit tests

Heiner Kallweit (1):
      r8169: fix firmware not resetting tp->ocp_base

Horatiu Vultur (2):
      bridge: uapi: mrp: Fix MRP_PORT_ROLE
      bridge: mrp: Validate when setting the port role

Huy Nguyen (1):
      xfrm: Fix double ESP trailer insertion in IPsec crypto offload.

Ido Schimmel (1):
      mlxsw: spectrum: Do not rely on machine endianness

Ilya Ponetayev (1):
      sch_cake: don't try to reallocate or unshare skb unconditionally

Jason A. Donenfeld (5):
      wireguard: device: avoid circular netns references
      wireguard: receive: account for napi_gro_receive never returning GRO_DROP
      socionext: account for napi_gro_receive never returning GRO_DROP
      hns: do not cast return value of napi_gro_receive to null
      wil6210: account for napi_gro_receive never returning GRO_DROP

Jeremy Kerr (1):
      net: usb: ax88179_178a: fix packet alignment padding

Jisheng Zhang (2):
      net: phy: make phy_disable_interrupts() non-static
      net: phy: call phy_disable_interrupts() in phy_init_hw()

Julian Wiedmann (2):
      s390/qeth: fix error handling for isolation mode cmds
      s390/qeth: let isolation mode override HW offload restrictions

Lorenzo Bianconi (1):
      openvswitch: take into account de-fragmentation/gso_size in execute_check_pkt_len

Marcelo Ricardo Leitner (1):
      sctp: Don't advertise IPv4 addresses if ipv6only is set on the socket

Martin (1):
      bareudp: Fixed multiproto mode configuration

Michael Chan (3):
      bnxt_en: Store the running firmware version code.
      bnxt_en: Do not enable legacy TX push on older firmware.
      bnxt_en: Fix statistics counters issue during ifdown with older firmware.

Michal Kubecek (1):
      ethtool: fix error handling in linkstate_prepare_data()

Neal Cardwell (2):
      tcp_cubic: fix spurious HYSTART_DELAY exit upon drop in min RTT
      bpf: tcp: bpf_cubic: fix spurious HYSTART_DELAY exit upon drop in min RTT

Paolo Abeni (2):
      mptcp: cache msk on MP_JOIN init_req
      mptcp: drop MP_JOIN request sock on syn cookies

Rahul Lakkireddy (12):
      cxgb4: move handling L2T ARP failures to caller
      cxgb4: move PTP lock and unlock to caller in Tx path
      cxgb4: use unaligned conversion for fetching timestamp
      cxgb4: parse TC-U32 key values and masks natively
      cxgb4: fix endian conversions for L4 ports in filters
      cxgb4: use correct type for all-mask IP address comparison
      cxgb4: fix SGE queue dump destination buffer context
      cxgb4: remove cast when saving IPv4 partial checksum
      cxgb4: move DCB version extern to header file
      cxgb4: fix set but unused variable when DCB is disabled
      cxgb4: update kernel-doc line comments
      cxgb4vf: update kernel-doc line comments

Rao Shoaib (1):
      rds: transport module should be auto loaded when transport is set

Rob Gill (2):
      net: Add MODULE_DESCRIPTION entries to network modules
      netfilter: Add MODULE_DESCRIPTION entries to kernel modules

Roopa Prabhu (1):
      vxlan: fix last fdb index during dump of fdb with nhid

Russell King (3):
      net: phylink: fix ethtool -A with attached PHYs
      net: phylink: ensure manual pause mode configuration takes effect
      netfilter: ipset: fix unaligned atomic access

Sabrina Dubroca (1):
      geneve: allow changing DF behavior after creation

Sascha Hauer (4):
      net: ethernet: mvneta: Fix Serdes configuration for SoCs without comphy
      net: ethernet: mvneta: Add 2500BaseX support for SoCs without comphy
      net: ethernet: mvneta: Do not error out in non serdes modes
      net: ethernet: mvneta: Add back interface mode validation

Shannon Nelson (3):
      ionic: no link check while resetting queues
      ionic: export features for vlans to use
      ionic: tame the watchdog timer on reconfig

Stanislav Fomichev (3):
      bpf: Don't return EINVAL from {get,set}sockopt when optlen > PAGE_SIZE
      selftests/bpf: Make sure optvals > PAGE_SIZE are bypassed
      bpf: Document optval > PAGE_SIZE behavior for sockopt hooks

Stefan Schmidt (2):
      docs: net: ieee802154: change link to new project URL
      MAINTAINERS: update ieee802154 project website URL

Stephen Rothwell (1):
      xfrm: merge fixup for "remove output_finish indirection from xfrm_state_afinfo"

Taehee Yoo (4):
      net: core: reduce recursion limit value
      ip6_gre: fix use-after-free in ip6gre_tunnel_lookup()
      ip_tunnel: fix use-after-free in ip_tunnel_lookup()
      hsr: avoid to create proc file after unregister

Tariq Toukan (1):
      net: Do not clear the sock TX queue in sk_set_socket()

Thomas Falcon (1):
      ibmveth: Fix max MTU limit

Thomas Martitz (1):
      net: bridge: enfore alignment for ethernet address

Tobias Klauser (1):
      tools, bpftool: Add ringbuf map type to map command docs

Toke Høiland-Jørgensen (3):
      devmap: Use bpf_map_area_alloc() for allocating hash buckets
      sch_cake: don't call diffserv parsing code when it is not needed
      sch_cake: fix a few style nits

Tuomas Tynkkynen (1):
      usbnet: smsc95xx: Fix use-after-free after removal

Vasundhara Volam (1):
      bnxt_en: Read VPD info only for PFs

Vladimir Oltean (7):
      net: dsa: sja1105: remove debugging code in sja1105_vl_gate
      net: dsa: sja1105: fix checks for VLAN state in redirect action
      net: dsa: sja1105: fix checks for VLAN state in gate action
      net: dsa: sja1105: move sja1105_compose_gating_subschedule at the top
      net: dsa: sja1105: unconditionally free old gating config
      net: dsa: sja1105: recalculate gating subschedule after deleting tc-gate rules
      net: dsa: sja1105: fix tc-gate schedule with single element

Willem de Bruijn (1):
      selftests/net: report etf errors correctly

Yang Yingliang (1):
      net: fix memleak in register_netdevice()

guodeqing (1):
      net: Fix the arp error in some cases

wenxu (4):
      flow_offload: add flow_indr_block_cb_alloc/remove function
      flow_offload: use flow_indr_block_cb_alloc/remove function
      net: flow_offload: fix flow_indr_dev_unregister path
      net/sched: cls_api: fix nooffloaddevcnt warning dmesg log

 Documentation/bpf/prog_cgroup_sockopt.rst                           |  14 ++++
 Documentation/networking/ieee802154.rst                             |   4 +-
 MAINTAINERS                                                         |   4 +-
 drivers/net/bareudp.c                                               |   3 +
 drivers/net/dsa/bcm_sf2.c                                           |   2 +
 drivers/net/dsa/sja1105/sja1105_vl.c                                | 339 +++++++++++++++++++++++++++++++++++++++-------------------------------------
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                           |  36 ++++++--
 drivers/net/ethernet/broadcom/bnxt/bnxt.h                           |   5 ++
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c                        |  21 +++--
 drivers/net/ethernet/broadcom/genet/bcmgenet.c                      |  88 ++------------------
 drivers/net/ethernet/broadcom/tg3.c                                 |   4 +-
 drivers/net/ethernet/cadence/macb_main.c                            | 128 ++++++++++++++++++-----------
 drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c                      |   6 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_dcb.h                      |   3 +
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c                  |   1 -
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c                  |   2 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c                   |  25 ++++--
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c                     |  11 +--
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_ptp.c                      |   3 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c                |  30 +++----
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.c                   |  18 ++--
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32_parse.h             | 122 ++++++++++++++++++---------
 drivers/net/ethernet/chelsio/cxgb4/l2t.c                            |  53 ++++++------
 drivers/net/ethernet/chelsio/cxgb4/sched.c                          |   2 +-
 drivers/net/ethernet/chelsio/cxgb4/sge.c                            |  47 +++++------
 drivers/net/ethernet/chelsio/cxgb4/smt.c                            |   2 +
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c                          |  36 ++++----
 drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c                 |   3 +-
 drivers/net/ethernet/chelsio/cxgb4vf/sge.c                          |   7 +-
 drivers/net/ethernet/chelsio/cxgb4vf/t4vf_hw.c                      |   9 +-
 drivers/net/ethernet/freescale/enetc/enetc.c                        |  26 ++++++
 drivers/net/ethernet/freescale/enetc/enetc_hw.h                     |  16 ++--
 drivers/net/ethernet/freescale/enetc/enetc_pf.c                     |   8 --
 drivers/net/ethernet/hisilicon/hns/hns_enet.c                       |   2 +-
 drivers/net/ethernet/ibm/ibmveth.c                                  |   2 +-
 drivers/net/ethernet/ibm/ibmvnic.c                                  |   9 +-
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c                      |   3 +
 drivers/net/ethernet/intel/i40e/i40e_main.c                         |  29 ++++---
 drivers/net/ethernet/intel/ice/ice_lib.c                            |   8 +-
 drivers/net/ethernet/intel/ice/ice_main.c                           |   2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c                        |  12 +--
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c                       |  14 +++-
 drivers/net/ethernet/marvell/mvneta.c                               |  76 +++++++++++------
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c                 |  24 ++++--
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c                      |   4 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h                      |   8 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c              |   2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c                 |   2 +-
 drivers/net/ethernet/neterion/vxge/vxge-config.h                    |   2 +-
 drivers/net/ethernet/netronome/nfp/flower/main.c                    |   2 +-
 drivers/net/ethernet/netronome/nfp/flower/main.h                    |   7 +-
 drivers/net/ethernet/netronome/nfp/flower/offload.c                 |  24 +++---
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe.h                     |   2 +-
 drivers/net/ethernet/pensando/ionic/ionic_lif.c                     |  19 +++--
 drivers/net/ethernet/qlogic/qed/qed_cxt.c                           |  21 ++++-
 drivers/net/ethernet/qlogic/qed/qed_debug.c                         |   3 +-
 drivers/net/ethernet/qlogic/qed/qed_dev.c                           |  11 ++-
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c                         |   2 -
 drivers/net/ethernet/qlogic/qed/qed_roce.c                          |   1 -
 drivers/net/ethernet/qlogic/qed/qed_vf.c                            |  23 ++++--
 drivers/net/ethernet/qlogic/qede/qede_main.c                        |   3 +-
 drivers/net/ethernet/qlogic/qede/qede_ptp.c                         |  31 +++----
 drivers/net/ethernet/qlogic/qede/qede_ptp.h                         |   2 +-
 drivers/net/ethernet/qlogic/qede/qede_rdma.c                        |   3 +-
 drivers/net/ethernet/realtek/r8169_main.c                           |   5 +-
 drivers/net/ethernet/socionext/netsec.c                             |   5 +-
 drivers/net/geneve.c                                                |   1 +
 drivers/net/phy/Kconfig                                             |   3 +-
 drivers/net/phy/mscc/mscc_macsec.c                                  |  40 ++-------
 drivers/net/phy/phy.c                                               |   2 +-
 drivers/net/phy/phy_device.c                                        |  10 ++-
 drivers/net/phy/phylink.c                                           |  45 +++++++---
 drivers/net/phy/smsc.c                                              |  11 ++-
 drivers/net/usb/ax88179_178a.c                                      |  11 +--
 drivers/net/usb/smsc95xx.c                                          |   2 +-
 drivers/net/vxlan.c                                                 |   4 +
 drivers/net/wireguard/device.c                                      |  58 ++++++-------
 drivers/net/wireguard/device.h                                      |   3 +-
 drivers/net/wireguard/netlink.c                                     |  14 ++--
 drivers/net/wireguard/noise.c                                       |   4 +-
 drivers/net/wireguard/receive.c                                     |  10 +--
 drivers/net/wireguard/socket.c                                      |  25 ++++--
 drivers/net/wireless/ath/wil6210/txrx.c                             |  39 +++------
 drivers/of/of_mdio.c                                                |   9 +-
 drivers/s390/net/qeth_core_main.c                                   |  11 ++-
 include/linux/netdevice.h                                           |   2 +-
 include/linux/netfilter_ipv4/ip_tables.h                            |   6 ++
 include/linux/netfilter_ipv6/ip6_tables.h                           |   3 +
 include/linux/phy.h                                                 |   1 +
 include/linux/qed/qed_chain.h                                       |  26 +++---
 include/net/flow_offload.h                                          |  21 ++++-
 include/net/gue.h                                                   |   2 +-
 include/net/sctp/constants.h                                        |   8 +-
 include/net/sock.h                                                  |   1 -
 include/net/xfrm.h                                                  |   1 +
 include/trace/events/rxrpc.h                                        |   2 +-
 include/uapi/linux/bpf.h                                            |   2 +-
 include/uapi/linux/mrp_bridge.h                                     |   1 -
 include/uapi/linux/rds.h                                            |   4 +-
 kernel/bpf/cgroup.c                                                 |  53 +++++++-----
 kernel/bpf/devmap.c                                                 |  10 ++-
 kernel/trace/bpf_trace.c                                            |   2 +-
 net/9p/mod.c                                                        |   1 +
 net/bridge/br_mrp.c                                                 |  10 ++-
 net/bridge/br_private.h                                             |   2 +-
 net/bridge/netfilter/nft_meta_bridge.c                              |   1 +
 net/bridge/netfilter/nft_reject_bridge.c                            |   1 +
 net/core/dev.c                                                      |   9 ++
 net/core/drop_monitor.c                                             |   1 +
 net/core/flow_offload.c                                             |  47 ++++++-----
 net/core/sock.c                                                     |   4 +-
 net/core/xdp.c                                                      |   1 +
 net/dsa/tag_edsa.c                                                  |  37 ++++++++-
 net/ethtool/cabletest.c                                             |  17 ++--
 net/ethtool/common.c                                                |   2 +
 net/ethtool/ioctl.c                                                 |   2 +-
 net/ethtool/linkstate.c                                             |  11 ++-
 net/hsr/hsr_device.c                                                |  21 +----
 net/hsr/hsr_device.h                                                |   2 +-
 net/hsr/hsr_main.c                                                  |   9 +-
 net/hsr/hsr_netlink.c                                               |  17 ++++
 net/ipv4/Kconfig                                                    |  34 ++++----
 net/ipv4/esp4_offload.c                                             |   1 +
 net/ipv4/fib_semantics.c                                            |   2 +-
 net/ipv4/fou.c                                                      |   1 +
 net/ipv4/ip_tunnel.c                                                |  14 ++--
 net/ipv4/netfilter/ip_tables.c                                      |  15 +++-
 net/ipv4/netfilter/ipt_SYNPROXY.c                                   |   1 +
 net/ipv4/netfilter/iptable_filter.c                                 |  10 ++-
 net/ipv4/netfilter/iptable_mangle.c                                 |  10 ++-
 net/ipv4/netfilter/iptable_nat.c                                    |  10 ++-
 net/ipv4/netfilter/iptable_raw.c                                    |  10 ++-
 net/ipv4/netfilter/iptable_security.c                               |  11 ++-
 net/ipv4/netfilter/nf_flow_table_ipv4.c                             |   1 +
 net/ipv4/netfilter/nft_dup_ipv4.c                                   |   1 +
 net/ipv4/netfilter/nft_fib_ipv4.c                                   |   1 +
 net/ipv4/netfilter/nft_reject_ipv4.c                                |   1 +
 net/ipv4/tcp_cubic.c                                                |   5 +-
 net/ipv4/tcp_input.c                                                |  14 +++-
 net/ipv6/Kconfig                                                    |  34 ++++----
 net/ipv6/esp6_offload.c                                             |   1 +
 net/ipv6/fou6.c                                                     |   1 +
 net/ipv6/ila/ila_main.c                                             |   1 +
 net/ipv6/ip6_gre.c                                                  |   9 +-
 net/ipv6/netfilter/ip6_tables.c                                     |  15 +++-
 net/ipv6/netfilter/ip6t_SYNPROXY.c                                  |   1 +
 net/ipv6/netfilter/ip6table_filter.c                                |  10 ++-
 net/ipv6/netfilter/ip6table_mangle.c                                |  10 ++-
 net/ipv6/netfilter/ip6table_nat.c                                   |  10 ++-
 net/ipv6/netfilter/ip6table_raw.c                                   |  10 ++-
 net/ipv6/netfilter/ip6table_security.c                              |  10 ++-
 net/ipv6/netfilter/nf_flow_table_ipv6.c                             |   1 +
 net/ipv6/netfilter/nft_dup_ipv6.c                                   |   1 +
 net/ipv6/netfilter/nft_fib_ipv6.c                                   |   1 +
 net/ipv6/netfilter/nft_reject_ipv6.c                                |   1 +
 net/mptcp/options.c                                                 |   2 -
 net/mptcp/protocol.h                                                |   1 +
 net/mptcp/subflow.c                                                 |  57 ++++++-------
 net/netfilter/ipset/ip_set_core.c                                   |   2 +
 net/netfilter/nf_dup_netdev.c                                       |   1 +
 net/netfilter/nf_flow_table_core.c                                  |   1 +
 net/netfilter/nf_flow_table_inet.c                                  |   1 +
 net/netfilter/nf_flow_table_offload.c                               |   1 +
 net/netfilter/nf_synproxy_core.c                                    |   1 +
 net/netfilter/nf_tables_offload.c                                   |   1 +
 net/netfilter/nfnetlink.c                                           |   1 +
 net/netfilter/nft_compat.c                                          |   1 +
 net/netfilter/nft_connlimit.c                                       |   1 +
 net/netfilter/nft_counter.c                                         |   1 +
 net/netfilter/nft_ct.c                                              |   1 +
 net/netfilter/nft_dup_netdev.c                                      |   1 +
 net/netfilter/nft_fib_inet.c                                        |   1 +
 net/netfilter/nft_fib_netdev.c                                      |   1 +
 net/netfilter/nft_flow_offload.c                                    |   1 +
 net/netfilter/nft_hash.c                                            |   1 +
 net/netfilter/nft_limit.c                                           |   1 +
 net/netfilter/nft_log.c                                             |   1 +
 net/netfilter/nft_masq.c                                            |   1 +
 net/netfilter/nft_nat.c                                             |   1 +
 net/netfilter/nft_numgen.c                                          |   1 +
 net/netfilter/nft_objref.c                                          |   1 +
 net/netfilter/nft_osf.c                                             |   1 +
 net/netfilter/nft_queue.c                                           |   1 +
 net/netfilter/nft_quota.c                                           |   1 +
 net/netfilter/nft_redir.c                                           |   1 +
 net/netfilter/nft_reject.c                                          |   1 +
 net/netfilter/nft_reject_inet.c                                     |   1 +
 net/netfilter/nft_synproxy.c                                        |   1 +
 net/netfilter/nft_tunnel.c                                          |   1 +
 net/netfilter/xt_nat.c                                              |   1 +
 net/openvswitch/actions.c                                           |   9 +-
 net/rds/transport.c                                                 |  26 ++++--
 net/rxrpc/call_accept.c                                             |   7 ++
 net/rxrpc/call_event.c                                              |   2 +-
 net/rxrpc/input.c                                                   |   7 +-
 net/sched/act_gate.c                                                | 126 +++++++++++++++-------------
 net/sched/cls_api.c                                                 |  25 +++---
 net/sched/sch_cake.c                                                |  58 +++++++++----
 net/sched/sch_fq.c                                                  |   1 +
 net/sched/sch_fq_codel.c                                            |   1 +
 net/sched/sch_hhf.c                                                 |   1 +
 net/sctp/associola.c                                                |   5 +-
 net/sctp/bind_addr.c                                                |   1 +
 net/sctp/protocol.c                                                 |   3 +-
 net/xfrm/Kconfig                                                    |  24 ++++++
 net/xfrm/xfrm_device.c                                              |   4 +-
 net/xfrm/xfrm_output.c                                              |   4 -
 samples/bpf/xdp_monitor_user.c                                      |   8 +-
 samples/bpf/xdp_redirect_cpu_user.c                                 |   7 +-
 samples/bpf/xdp_rxq_info_user.c                                     |  13 +--
 tools/bpf/bpftool/Documentation/bpftool-map.rst                     |   2 +-
 tools/bpf/bpftool/map.c                                             |   3 +-
 tools/include/uapi/linux/bpf.h                                      |   2 +-
 tools/testing/selftests/bpf/prog_tests/sockopt_sk.c                 |  46 +++++++++--
 tools/testing/selftests/bpf/progs/bpf_cubic.c                       |   5 +-
 tools/testing/selftests/bpf/progs/sockopt_sk.c                      |  54 +++++++++++-
 tools/testing/selftests/net/so_txtime.c                             |  33 ++++++--
 tools/testing/selftests/netfilter/Makefile                          |   2 +-
 tools/testing/selftests/netfilter/nft_conntrack_helper.sh           | 175 +++++++++++++++++++++++++++++++++++++++
 tools/testing/selftests/tc-testing/tc-tests/actions/bpf.json        |   4 +-
 tools/testing/selftests/tc-testing/tc-tests/actions/csum.json       |   4 +-
 tools/testing/selftests/tc-testing/tc-tests/actions/tunnel_key.json |  20 ++---
 tools/testing/selftests/wireguard/netns.sh                          |  13 ++-
 223 files changed, 1973 insertions(+), 1156 deletions(-)
 create mode 100755 tools/testing/selftests/netfilter/nft_conntrack_helper.sh
