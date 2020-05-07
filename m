Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5481C8094
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 05:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbgEGDku convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 6 May 2020 23:40:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725857AbgEGDkt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 23:40:49 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 363F4C061A0F;
        Wed,  6 May 2020 20:40:49 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AFC07120ED540;
        Wed,  6 May 2020 20:40:48 -0700 (PDT)
Date:   Wed, 06 May 2020 20:40:39 -0700 (PDT)
Message-Id: <20200506.204039.425872525231159617.davem@davemloft.net>
To:     torvalds@linux-foundation.org
CC:     akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 May 2020 20:40:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


1) Fix reference count leaks in various parts of batman-adv, from
   Xiyu Yang.

2) Update NAT checksum even when it is zero, from Guillaume Nault.

3) sk_psock reference count leak in tls code, also from Xiyu Yang.

4) Sanity check TCA_FQ_CODEL_DROP_BATCH_SIZE netlink attribute in
   fq_codel, from Eric Dumazet.

5) Fix panic in choke_reset(), also from Eric Dumazet.

6) Fix VLAN accel handling in bnxt_fix_features(), from Michael Chan.

7) Disallow out of range quantum values in sch_sfq, from Eric Dumazet.

8) Fix crash in x25_disconnect(), from Yue Haibing.

9) Don't pass pointer to local variable back to the caller in
   nf_osf_hdr_ctx_init(), from Arnd Bergmann.

10) Wireguard should use the ECN decap helper functions, from
    Toke Høiland-Jørgensen.

11) Fix command entry leak in mlx5 driver, from Moshe Shemesh.

12) Fix uninitialized variable access in mptcp's
    subflow_syn_recv_sock(), from Paolo Abeni.

13) Fix unnecessary out-of-order ingress frame ordering in
    macsec, from Scott Dial.

14) IPv6 needs to use a global serial number for dst validation just
    like ipv4, from David Ahern.

15) Fix up PTP_1588_CLOCK deps, from Clay McClure.

16) Missing NLM_F_MULTI flag in gtp driver netlink messages, from
    Yoshiyuki Kurauchi.

17) Fix a regression in that dsa user port errors should not be fatal,
    from Florian Fainelli.

18) Fix iomap leak in enetc driver, from Dejin Zheng.

19) Fix use after free in lec_arp_clear_vccs(), from Cong Wang.

20) Initialize protocol value earlier in neigh code paths when
    generating events, from Roman Mashak.

21) netdev_update_features() must be called with RTNL mutex in
    macsec driver, from Antoine Tenart.

22) Validate untrusted GSO packets even more strictly, from Willem
    de Bruijn.

23) Wireguard decrypt worker needs a cond_resched(), from Jason
    A. Donenfeld.

Please pull, thanks a lot.

The following changes since commit b2768df24ec400dd4f7fa79542f797e904812053:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace (2020-04-25 12:25:32 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git 

for you to fetch changes up to 16f8036086a929694c3c62f577bb5925fe4fd607:

  net: flow_offload: skip hw stats check for FLOW_ACTION_HW_STATS_DONT_CARE (2020-05-06 20:13:10 -0700)

----------------------------------------------------------------
Ahmed Abdelsalam (1):
      seg6: fix SRH processing to comply with RFC8754

Alex Elder (3):
      net: ipa: fix a bug in ipa_endpoint_stop()
      net: ipa: fix an error message in gsi_channel_init_one()
      net: ipa: zero return code before issuing generic EE command

Andy Shevchenko (2):
      net: macb: Fix runtime PM refcounting
      stmmac: intel: Fix kernel crash due to wrong error path

Anthony Felice (1):
      net: tc35815: Fix phydev supported/advertising mask

Antoine Tenart (1):
      net: macsec: fix rtnl locking issue

Arnd Bergmann (3):
      netfilter: nf_osf: avoid passing pointer to local var
      drop_monitor: work around gcc-10 stringop-overflow warning
      cxgb4/chcr: avoid -Wreturn-local-addr warning

Aya Levin (1):
      devlink: Fix reporter's recovery condition

Baruch Siach (1):
      net: phy: marvell10g: fix temperature sensor on 2110

Christophe JAILLET (2):
      net/sonic: Fix a resource leak in an error handling path in 'jazz_sonic_probe()'
      net: moxa: Fix a potential double 'free_irq()'

Clay McClure (1):
      net: Make PTP-specific drivers depend on PTP_1588_CLOCK

Colin Ian King (1):
      net: stmmac: gmac5+: fix potential integer overflow on 32 bit multiply

Cong Wang (3):
      net_sched: fix tcm_parent in tc filter dump
      atm: fix a UAF in lec_arp_clear_vccs()
      atm: fix a memory leak of vcc->user_back

Dan Carpenter (2):
      net: mvpp2: prevent buffer overflow in mvpp22_rss_ctx()
      net: mvpp2: cls: Prevent buffer overflow in mvpp2_ethtool_cls_rule_del()

Dan Murphy (2):
      net: phy: DP83822: Fix WoL in config init to be disabled
      net: phy: DP83TC811: Fix WoL in config init to be disabled

David Ahern (1):
      ipv6: Use global sernum for dst validation with nexthop objects

David S. Miller (12):
      Merge branch 'vsock-virtio-fixes-about-packet-delivery-to-monitoring-devices'
      Merge branch 'bnxt_en-fixes'
      Merge tag 'batadv-net-for-davem-20200427' of git://git.open-mesh.org/linux-merge
      Merge branch 'wireguard-fixes'
      Merge branch 'mptcp-fix-incoming-options-parsing'
      Merge tag 'mlx5-fixes-2020-04-29' of git://git.kernel.org/.../saeed/linux
      Merge branch 'ionic-fw-upgrade-bug-fixes'
      Merge branch 'net-ipa-three-bug-fixes'
      Merge git://git.kernel.org/.../pablo/nf
      Merge branch 'WoL-fixes-for-DP83822-and-DP83tc811'
      Merge branch 'FDB-fixes-for-Felix-and-Ocelot-switches'
      Merge branch 'wireguard-fixes'

Dejin Zheng (3):
      net: macb: fix an issue about leak related system resources
      net: enetc: fix an issue about leak system resources
      net: broadcom: fix a mistake about ioremap resource

Erez Shitrit (1):
      net/mlx5: DR, On creation set CQ's arm_db member to right value

Eric Dumazet (7):
      net: remove obsolete comment
      fq_codel: fix TCA_FQ_CODEL_DROP_BATCH_SIZE sanity checks
      sch_choke: avoid potential panic in choke_reset()
      sch_sfq: validate silly quantum values
      net_sched: sch_skbprio: add message validation to skbprio_change()
      selftests: net: tcp_mmap: clear whole tcp_zerocopy_receive struct
      selftests: net: tcp_mmap: fix SO_RCVLOWAT setting

Florian Fainelli (2):
      net: dsa: Do not make user port errors fatal
      net: dsa: Do not leave DSA master with NULL netdev_ops

Florian Westphal (1):
      mptcp: replace mptcp_disconnect with a stub

Gavin Shan (1):
      net/ena: Fix build warning in ena_xdp_set()

Geert Uytterhoeven (1):
      ionic: Use debugfs_create_bool() to export bool

George Spelvin (1):
      batman-adv: fix batadv_nc_random_weight_tq

Grygorii Strashko (1):
      net: ethernet: ti: am65-cpsw-nuss: fix irqs type

Guillaume Nault (1):
      netfilter: nat: never update the UDP checksum when it's 0

Ido Schimmel (1):
      net: bridge: vlan: Add a schedule point during VLAN processing

Jacob Keller (1):
      ice: cleanup language in ice.rst for fw.app

Jakub Kicinski (1):
      devlink: fix return value after hitting end in region read

Jason A. Donenfeld (6):
      wireguard: queueing: cleanup ptr_ring in error path of packet_queue_init
      wireguard: selftests: use normal kernel stack size on ppc64
      wireguard: socket: remove errant restriction on looping to self
      wireguard: send/receive: cond_resched() when processing worker ringbuffers
      wireguard: selftests: initalize ipv6 members to NULL to squelch clang warning
      wireguard: send/receive: use explicit unlikely branch instead of implicit coalescing

Jason Yan (1):
      net: dsa: mv88e6xxx: remove duplicate assignment of struct members

Jiri Pirko (1):
      mlxsw: spectrum_acl_tcam: Position vchunk in a vregion list properly

Jules Irenge (1):
      cxgb4: Add missing annotation for service_ofldq()

Julia Lawall (1):
      dp83640: reverse arguments to list_add_tail

Julian Wiedmann (1):
      s390/qeth: fix cancelling of TX timer on dev_close()

Juliet Kim (1):
      ibmvnic: Skip fatal error reset after passive init

Lukas Bulwahn (1):
      MAINTAINERS: put DYNAMIC INTERRUPT MODERATION in proper order

Matt Jolly (1):
      net: usb: qmi_wwan: add support for DW5816e

Maxim Petrov (1):
      stmmac: fix pointer check after utilization in stmmac_interrupt

Michael Chan (4):
      bnxt_en: Fix VF anti-spoof filter setup.
      bnxt_en: Improve AER slot reset.
      bnxt_en: Return error when allocating zero size context memory.
      bnxt_en: Fix VLAN acceleration handling in bnxt_fix_features().

Moshe Shemesh (2):
      net/mlx5: Fix forced completion access non initialized command entry
      net/mlx5: Fix command entry leak in Internal Error State

Murali Karicheri (1):
      net: hsr: fix incorrect type usage for protocol variable

Nathan Chancellor (1):
      hv_netvsc: Fix netvsc_start_xmit's return type

Pablo Neira Ayuso (1):
      net: flow_offload: skip hw stats check for FLOW_ACTION_HW_STATS_DONT_CARE

Paolo Abeni (7):
      mptcp: fix race in msk status update
      mptcp: consolidate synack processing.
      mptcp: move option parsing into mptcp_incoming_options()
      mptcp: avoid a WARN on bad input.
      mptcp: fix 'use_ack' option access.
      mptcp: initialize the data_fin field for mpc packets
      mptcp: fix uninitialized value access

Parav Pandit (3):
      net/mlx5: E-switch, Fix error unwinding flow for steering init failure
      net/mlx5: E-switch, Fix printing wrong error value
      net/mlx5: E-switch, Fix mutex init order

Qiushi Wu (1):
      nfp: abm: fix a memory leak bug

Rahul Lakkireddy (1):
      cxgb4: fix EOTID leak when disabling TC-MQPRIO offload

Richard Clark (1):
      aquantia: Fix the media type of AQC100 ethernet controller in the driver

Roi Dayan (1):
      net/mlx5e: Fix q counters on uplink representors

Roman Mashak (1):
      neigh: send protocol value in neighbor create notification

Scott Dial (1):
      net: macsec: preserve ingress frame ordering

Shannon Nelson (3):
      ionic: no link check until after probe
      ionic: refresh devinfo after fw-upgrade
      ionic: add device reset to fw upgrade down

Stefano Garzarella (2):
      vhost/vsock: fix packet delivery order to monitoring devices
      vsock/virtio: fix multiple packet delivery to monitoring devices

Sultan Alsawaf (1):
      wireguard: send: remove errant newline from packet_encrypt_worker

Tariq Toukan (1):
      net/mlx4_core: Fix use of ENOSPC around mlx4_counter_alloc()

Toke Høiland-Jørgensen (2):
      wireguard: receive: use tunnel helpers for decapsulating ECN markings
      tunnel: Propagate ECT(1) when decapsulating as recommended by RFC6040

Tuong Lien (1):
      tipc: fix partial topology connection closure

Vasundhara Volam (1):
      bnxt_en: Reduce BNXT_MSIX_VEC_MAX value to supported CQs per PF.

Vladimir Oltean (4):
      net: dsa: sja1105: the PTP_CLK extts input reacts on both edges
      net: dsa: ocelot: the MAC table on Felix is twice as large
      net: mscc: ocelot: ANA_AUTOAGE_AGE_PERIOD holds a value in seconds, not ms
      net: dsa: remove duplicate assignment in dsa_slave_add_cls_matchall_mirred

Willem de Bruijn (1):
      net: stricter validation of untrusted gso packets

Xiyu Yang (6):
      batman-adv: Fix refcnt leak in batadv_show_throughput_override
      batman-adv: Fix refcnt leak in batadv_store_throughput_override
      batman-adv: Fix refcnt leak in batadv_v_ogm_process
      net/tls: Fix sk_psock refcnt leak in bpf_exec_tx_verdict()
      net/x25: Fix x25_neigh refcnt leak when x25 disconnect
      net/tls: Fix sk_psock refcnt leak when in tls_data_ready()

Yoshiyuki Kurauchi (1):
      gtp: set NLM_F_MULTI flag in gtp_genl_dump_pdp()

YueHaibing (1):
      net/x25: Fix null-ptr-deref in x25_disconnect

 Documentation/networking/devlink/ice.rst                       |  4 +--
 MAINTAINERS                                                    |  2 +-
 drivers/crypto/chelsio/chcr_ktls.c                             | 83 ++++++++++++++++++++++++++---------------------
 drivers/net/dsa/mv88e6xxx/Kconfig                              |  2 +-
 drivers/net/dsa/mv88e6xxx/chip.c                               |  4 ---
 drivers/net/dsa/ocelot/felix.c                                 |  1 +
 drivers/net/dsa/ocelot/felix.h                                 |  1 +
 drivers/net/dsa/ocelot/felix_vsc9959.c                         |  1 +
 drivers/net/dsa/sja1105/Kconfig                                |  1 +
 drivers/net/dsa/sja1105/sja1105_ptp.c                          | 26 ++++++++++-----
 drivers/net/ethernet/amazon/ena/ena_netdev.h                   |  2 +-
 drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c           |  2 +-
 drivers/net/ethernet/broadcom/bgmac-platform.c                 | 24 ++++++++------
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                      | 20 ++++++++----
 drivers/net/ethernet/broadcom/bnxt/bnxt.h                      |  1 -
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h              |  2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c                | 10 ++----
 drivers/net/ethernet/cadence/Kconfig                           |  2 +-
 drivers/net/ethernet/cadence/macb_main.c                       | 24 +++++++-------
 drivers/net/ethernet/cavium/Kconfig                            |  2 +-
 drivers/net/ethernet/chelsio/cxgb4/sge.c                       | 40 +++++++++++++++++++++--
 drivers/net/ethernet/freescale/enetc/enetc_pci_mdio.c          |  2 +-
 drivers/net/ethernet/ibm/ibmvnic.c                             |  3 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c                 |  3 ++
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c                |  2 ++
 drivers/net/ethernet/mellanox/mlx4/main.c                      |  4 ++-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c                  |  6 +++-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c               |  9 ++----
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c     | 18 +++++------
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c     | 14 +++++++-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c        | 12 +++++--
 drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c          |  3 +-
 drivers/net/ethernet/moxa/moxart_ether.c                       |  2 +-
 drivers/net/ethernet/mscc/ocelot.c                             | 17 ++++++----
 drivers/net/ethernet/mscc/ocelot_regs.c                        |  1 +
 drivers/net/ethernet/natsemi/jazzsonic.c                       |  6 ++--
 drivers/net/ethernet/netronome/nfp/abm/main.c                  |  1 +
 drivers/net/ethernet/pensando/ionic/ionic_debugfs.c            |  3 +-
 drivers/net/ethernet/pensando/ionic/ionic_lif.c                |  4 +--
 drivers/net/ethernet/stmicro/stmmac/dwmac5.c                   |  2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c              | 11 +++----
 drivers/net/ethernet/ti/Kconfig                                |  3 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c                       |  5 +--
 drivers/net/ethernet/toshiba/tc35815.c                         |  2 +-
 drivers/net/gtp.c                                              |  9 +++---
 drivers/net/hyperv/netvsc_drv.c                                |  3 +-
 drivers/net/ipa/gsi.c                                          | 11 +++++--
 drivers/net/ipa/gsi_reg.h                                      |  2 ++
 drivers/net/ipa/ipa_endpoint.c                                 |  7 ++--
 drivers/net/macsec.c                                           |  6 ++--
 drivers/net/phy/dp83640.c                                      |  2 +-
 drivers/net/phy/dp83822.c                                      | 30 ++++++++---------
 drivers/net/phy/dp83tc811.c                                    | 21 ++++++------
 drivers/net/phy/marvell10g.c                                   | 27 +++++++++++++++-
 drivers/net/usb/qmi_wwan.c                                     |  1 +
 drivers/net/wireguard/queueing.c                               |  4 ++-
 drivers/net/wireguard/receive.c                                | 21 ++++++------
 drivers/net/wireguard/selftest/ratelimiter.c                   |  4 +--
 drivers/net/wireguard/send.c                                   | 20 ++++++------
 drivers/net/wireguard/socket.c                                 | 12 -------
 drivers/s390/net/qeth_core_main.c                              | 10 +++---
 drivers/vhost/vsock.c                                          | 16 ++++++---
 include/linux/tcp.h                                            | 51 -----------------------------
 include/linux/virtio_net.h                                     | 26 +++++++++++++--
 include/linux/virtio_vsock.h                                   |  1 +
 include/net/flow_offload.h                                     |  9 +++++-
 include/net/inet_ecn.h                                         | 57 ++++++++++++++++++++++++++++++--
 include/net/ip6_fib.h                                          |  4 +++
 include/net/mptcp.h                                            |  3 --
 include/net/net_namespace.h                                    |  7 ++++
 include/net/sch_generic.h                                      |  1 +
 include/soc/mscc/ocelot.h                                      |  1 +
 net/atm/common.c                                               | 22 ++++++-------
 net/atm/lec.c                                                  |  6 ++++
 net/batman-adv/bat_v_ogm.c                                     |  2 +-
 net/batman-adv/network-coding.c                                |  9 +-----
 net/batman-adv/sysfs.c                                         |  3 +-
 net/bridge/br_netlink.c                                        |  1 +
 net/core/devlink.c                                             | 12 +++++--
 net/core/drop_monitor.c                                        | 11 ++++---
 net/core/neighbour.c                                           |  6 ++--
 net/core/sock.c                                                |  1 -
 net/dsa/dsa2.c                                                 |  2 +-
 net/dsa/master.c                                               |  3 +-
 net/dsa/slave.c                                                |  8 ++---
 net/hsr/hsr_slave.c                                            |  2 +-
 net/ipv4/tcp_input.c                                           |  7 ----
 net/ipv6/route.c                                               | 25 ++++++++++++++
 net/ipv6/seg6.c                                                | 10 ++++--
 net/mptcp/options.c                                            | 95 +++++++++++++++++++++++-------------------------------
 net/mptcp/protocol.c                                           | 17 +++++-----
 net/mptcp/protocol.h                                           | 43 ++++++++++++++++++++++--
 net/mptcp/subflow.c                                            | 86 ++++++++++++++++++++++++++++++------------------
 net/netfilter/nf_nat_proto.c                                   |  4 +--
 net/netfilter/nfnetlink_osf.c                                  | 12 ++++---
 net/sched/cls_api.c                                            | 22 +++++++++----
 net/sched/sch_choke.c                                          |  3 +-
 net/sched/sch_fq_codel.c                                       |  2 +-
 net/sched/sch_sfq.c                                            |  9 ++++++
 net/sched/sch_skbprio.c                                        |  3 ++
 net/tipc/topsrv.c                                              |  5 +--
 net/tls/tls_sw.c                                               |  7 ++--
 net/vmw_vsock/virtio_transport_common.c                        |  4 +++
 net/x25/x25_subr.c                                             |  6 ++++
 tools/testing/selftests/net/tcp_mmap.c                         |  7 ++--
 tools/testing/selftests/wireguard/netns.sh                     | 54 +++++++++++++++++++++++++++++--
 tools/testing/selftests/wireguard/qemu/arch/powerpc64le.config |  1 +
 107 files changed, 801 insertions(+), 462 deletions(-)
