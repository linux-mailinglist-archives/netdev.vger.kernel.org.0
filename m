Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9E95DDABA
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 21:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbfJSTj3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 19 Oct 2019 15:39:29 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42960 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbfJSTj3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Oct 2019 15:39:29 -0400
Received: from localhost (unknown [64.79.112.2])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3A38714990E49;
        Sat, 19 Oct 2019 12:39:28 -0700 (PDT)
Date:   Sat, 19 Oct 2019 12:39:27 -0700 (PDT)
Message-Id: <20191019.123927.593477780203351647.davem@davemloft.net>
To:     torvalds@linux-foundation.org
CC:     akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 19 Oct 2019 12:39:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


I was battling a cold after some recent trips, so quite a bit piled up
meanwhile, sorry about that.

Highlights:

1) Fix fd leak in various bpf selftests, from Brian Vazquez.

2) Fix crash in xsk when device doesn't support some methods, from
   Magnus Karlsson.

3) Fix various leaks and use-after-free in rxrpc, from David Howells.

4) Fix several SKB leaks due to confusion of who owns an SKB and who
   should release it in the llc code.  From Eric Biggers.

5) Kill a bunc of KCSAN warnings in TCP, from Eric Dumazet.

6) Jumbo packets don't work after resume on r8169, as the BIOS
   resets the chip into non-jumbo mode during suspend.  From
   Heiner Kallweit.

7) Corrupt L2 header during MPLS push, from Davide Caratti.

8) Prevent possible infinite loop in tc_ctl_action, from Eric
   Dumazet.

9) Get register bits right in bcmgenet driver, based upon chip
   version.  From Florian Fainelli.

10) Fix mutex problems in microchip DSA driver, from Marek Vasut.

11) Cure race between route lookup and invalidation in ipv4, from
    Wei Wang.

12) Fix performance regression due to false sharing in 'net'
    structure, from Eric Dumazet.

Please pull, thanks a lot!

The following changes since commit 2d00aee21a5d4966e086d98f9d710afb92fb14e8:

  Merge tag 'kbuild-fixes-v5.4' of git://git.kernel.org/pub/scm/linux/kernel/git/masahiroy/linux-kbuild (2019-10-05 12:56:59 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git 

for you to fetch changes up to 2a06b8982f8f2f40d03a3daf634676386bd84dbc:

  net: reorder 'struct net' fields to avoid false sharing (2019-10-19 12:21:53 -0700)

----------------------------------------------------------------
Aaron Komisar (1):
      mac80211: fix scan when operating on DFS channels in ETSI domains

Alex Vesker (1):
      net/mlx5: DR, Allow insertion of duplicate rules

Alexandra Winter (2):
      s390/qeth: Fix error handling during VNICC initialization
      s390/qeth: Fix initialization of vnicc cmd masks during set online

Alexandre Belloni (1):
      net: lpc_eth: avoid resetting twice

Andrew Lunn (1):
      net: usb: lan78xx: Connect PHY before registering MAC

Antonio Borneo (3):
      ptp: fix typo of "mechanism" in Kconfig help text
      net: stmmac: fix length of PTP clock's name string
      net: stmmac: fix disabling flexible PPS output

Ben Dooks (Codethink) (3):
      davinci_cpdma: make cpdma_chan_split_pool static
      net: stmmac: make tc_flow_parsers static
      net: stmmac: fix argument to stmmac_pcs_ctrl_ane()

Biao Huang (1):
      net: stmmac: disable/enable ptp_ref_clk in suspend/resume flow

Björn Töpel (1):
      samples/bpf: Fix build for task_fd_query_user.c

Brian Vazquez (2):
      selftests/bpf: test_progs: Don't leak server_fd in tcp_rtt
      selftests/bpf: test_progs: Don't leak server_fd in test_sockopt_inherit

Chenwandun (1):
      net: aquantia: add an error handling in aq_nic_set_multicast_list

Cong Wang (2):
      net_sched: fix backward compatibility for TCA_KIND
      net_sched: fix backward compatibility for TCA_ACT_KIND

Cédric Le Goater (1):
      net/ibmvnic: Fix EOI when running in XIVE mode.

Daniele Palmas (1):
      net: usb: qmi_wwan: add Telit 0x1050 composition

David Ahern (1):
      net: Update address for vrf and l3mdev in MAINTAINERS

David Howells (7):
      rxrpc: Fix call ref leak
      rxrpc: Fix trace-after-put looking at the put peer record
      rxrpc: Fix trace-after-put looking at the put connection record
      rxrpc: Fix trace-after-put looking at the put call record
      rxrpc: rxrpc_peer needs to hold a ref on the rxrpc_local record
      rxrpc: Fix call crypto state cleanup
      rxrpc: Fix possible NULL pointer access in ICMP handling

David S. Miller (12):
      Merge branch 'stmmac-fixes'
      Merge tag 'rxrpc-fixes-20191007' of git://git.kernel.org/.../dhowells/linux-fs
      Merge git://git.kernel.org/.../bpf/bpf
      Merge branch 'tcp-address-KCSAN-reports-in-tcp_poll-part-I'
      Merge branch 'aquantia-fixes'
      Merge tag 'wireless-drivers-for-davem-2019-10-15' of git://git.kernel.org/.../kvalo/wireless-drivers
      Merge branch 'mpls-push-pop-fix'
      Merge branch 'Update-MT7629-to-support-PHYLINK-API'
      Merge branch 'dpaa2-eth-misc-fixes'
      Merge branch 'net-bcmgenet-restore-internal-EPHY-support'
      Merge branch 'vsock-virtio-make-the-credit-mechanism-more-robust'
      Merge branch 'netem-fix-further-issues-with-packet-corruption'

Davide Caratti (2):
      net: avoid errors when trying to pop MLPS header on non-MPLS packets
      net/sched: fix corrupted L2 header with MPLS 'push' and 'pop' actions

Dmitry Bogdanov (2):
      net: aquantia: do not pass lro session with invalid tcp checksum
      net: aquantia: correctly handle macvlan and multicast coexistence

Dmitry Torokhov (1):
      rt2x00: remove input-polldev.h header

Doug Berger (4):
      net: bcmgenet: don't set phydev->link from MAC
      net: phy: bcm7xxx: define soft_reset for 40nm EPHY
      net: bcmgenet: soft reset 40nm EPHYs before MAC init
      net: bcmgenet: reset 40nm EPHY on energy detect

Eric Biggers (4):
      llc: fix sk_buff leak in llc_sap_state_process()
      llc: fix sk_buff leak in llc_conn_service()
      llc: fix another potential sk_buff leak in llc_ui_sendmsg()
      llc: fix sk_buff refcounting in llc_conn_state_process()

Eric Dumazet (23):
      bonding: fix potential NULL deref in bond_update_slave_arr
      netfilter: conntrack: avoid possible false sharing
      tun: remove possible false sharing in tun_flow_update()
      net: avoid possible false sharing in sk_leave_memory_pressure()
      net: add {READ|WRITE}_ONCE() annotations on ->rskq_accept_head
      tcp: annotate lockless access to tcp_memory_pressure
      net: silence KCSAN warnings around sk_add_backlog() calls
      net: annotate sk->sk_rcvlowat lockless reads
      net: silence KCSAN warnings about sk->sk_backlog.len reads
      tcp: add rcu protection around tp->fastopen_rsk
      tcp: annotate tp->rcv_nxt lockless reads
      tcp: annotate tp->copied_seq lockless reads
      tcp: annotate tp->write_seq lockless reads
      tcp: annotate tp->snd_nxt lockless reads
      tcp: annotate tp->urg_seq lockless reads
      tcp: annotate sk->sk_rcvbuf lockless reads
      tcp: annotate sk->sk_sndbuf lockless reads
      tcp: annotate sk->sk_wmem_queued lockless reads
      tcp: fix a possible lockdep splat in tcp_done()
      net: avoid potential infinite loop in tc_ctl_action()
      rxrpc: use rcu protection while reading sk->sk_user_data
      net: ensure correct skb->tstamp in various fragmenters
      net: reorder 'struct net' fields to avoid false sharing

Florian Fainelli (3):
      net: dsa: b53: Do not clear existing mirrored port mask
      net: bcmgenet: Set phydev->dev_flags only for internal PHYs
      net: bcmgenet: Fix RGMII_MODE_EN value for GENET v1/2/3

Florin Chiculita (1):
      dpaa2-eth: add irq for the dpmac connect/disconnect event

Haim Dreyfuss (1):
      iwlwifi: mvm: force single phy init

Haishuang Yan (1):
      ip6erspan: remove the incorrect mtu limit for ip6erspan

Heiner Kallweit (1):
      r8169: fix jumbo packet handling on resume from suspend

Ido Schimmel (1):
      mlxsw: spectrum_trap: Push Ethernet header before reporting trap

Igor Russkikh (2):
      net: aquantia: temperature retrieval fix
      net: aquantia: when cleaning hw cache it should be toggled

Ioana Radulescu (1):
      dpaa2-eth: Fix TX FQID values

Jacob Keller (1):
      net: update net_dim documentation after rename

Jakub Kicinski (6):
      Merge branch 'llc-fix-sk_buff-refcounting'
      Merge tag 'mac80211-for-davem-2019-10-08' of git://git.kernel.org/.../jberg/mac80211
      Merge branch 's390-qeth-fixes'
      Merge branch 'smc-fixes'
      net: netem: fix error path for corrupted GSO frames
      net: netem: correct the parent's backlog when corrupted packet was dropped

Jiri Benc (2):
      selftests/bpf: Set rp_filter in test_flow_dissector
      selftests/bpf: More compatible nc options in test_lwt_ip_encap

Johan Hovold (1):
      NFC: pn533: fix use-after-free and memleaks

Johannes Berg (3):
      mac80211: accept deauth frames in IBSS mode
      iwlwifi: pcie: fix indexing in command dump for new HW
      iwlwifi: pcie: fix rb_allocator workqueue allocation

Jose Abreu (3):
      net: stmmac: selftests: Check if filtering is available before running
      net: stmmac: gmac4+: Not all Unicast addresses may be available
      net: stmmac: selftests: Fix L2 Hash Filter test

Juergen Gross (1):
      xen/netback: fix error path of xenvif_connect_data()

KP Singh (1):
      samples/bpf: Add a workaround for asm_inline

Kalle Valo (1):
      Merge tag 'iwlwifi-for-kalle-2019-10-09' of git://git.kernel.org/.../iwlwifi/iwlwifi-fixes

Karsten Graul (2):
      net/smc: receive returns without data
      net/smc: receive pending data after RCV_SHUTDOWN

Luca Coelho (4):
      iwlwifi: don't access trans_cfg via cfg
      iwlwifi: fix ACPI table revision checks
      iwlwifi: exclude GEO SAR support for 3168
      iwlwifi: pcie: change qu with jf devices to use qu configuration

Magnus Karlsson (1):
      xsk: Fix crash in poll when device does not support ndo_xsk_wakeup

Mahesh Bandewar (2):
      blackhole_netdev: fix syzkaller reported issue
      Revert "blackhole_netdev: fix syzkaller reported issue"

Mans Rullgard (1):
      net: ethernet: dwmac-sun8i: show message only when switching to promisc

Marek Vasut (4):
      net: dsa: microchip: Do not reinit mutexes on KSZ87xx
      net: dsa: microchip: Add shared regmap mutex
      net: phy: micrel: Discern KSZ8051 and KSZ8795 PHYs
      net: phy: micrel: Update KSZ87xx PHY name

MarkLee (2):
      net: ethernet: mediatek: Fix MT7629 missing GMII mode support
      arm: dts: mediatek: Update mt7629 dts to reflect the latest dt-binding

Miaoqing Pan (1):
      ath10k: fix latency issue for QCA988x

Michael Tretter (1):
      macb: propagate errors when getting optional clocks

Michael Vassernis (1):
      mac80211_hwsim: fix incorrect dev_alloc_name failure goto

Naftali Goldstein (1):
      iwlwifi: mvm: fix race in sync rx queue notification

Navid Emamdoost (3):
      nl80211: fix memory leak in nl80211_get_ftm_responder_stats
      iwlwifi: dbg_ini: fix memory leak in alloc_sgtable
      iwlwifi: pcie: fix memory leaks in iwl_pcie_ctxt_info_gen3_init

Nicolas Dichtel (1):
      netns: fix NLM_F_ECHO mechanism for RTM_NEWNSID

Nishad Kamdar (3):
      net: dsa: microchip: Use the correct style for SPDX License Identifier
      net: cavium: Use the correct style for SPDX License Identifier
      net: dsa: sja1105: Use the correct style for SPDX License Identifier

Oliver Neukum (1):
      usb: hso: obey DMA rules in tiocmget

Randy Dunlap (3):
      Doc: networking/device_drivers/pensando: fix ionic.rst warnings
      phylink: fix kernel-doc warnings
      net: ethernet: broadcom: have drivers select DIMLIB as needed

Sara Sharon (1):
      cfg80211: fix a bunch of RCU issues in multi-bssid code

Sean Wang (1):
      net: Update address for MediaTek ethernet driver in MAINTAINERS

Shannon Nelson (1):
      ionic: fix stats memory dereference

Shuah Khan (1):
      tools: bpf: Use !building_out_of_srctree to determine srctree

Stanislaw Gruszka (1):
      rt2x00: initialize last_reset

Stefano Brivio (1):
      ipv4: Return -ENETUNREACH if we can't create route but saddr is valid

Stefano Garzarella (2):
      vsock/virtio: send a credit update when buffer size is changed
      vsock/virtio: discard packets if credit is not respected

Thomas Bogendoerfer (1):
      net: i82596: fix dma_alloc_attr for sni_82596

Ursula Braun (1):
      net/smc: fix SMCD link group creation with VLAN id

Valentin Vidic (1):
      net: usb: sr9800: fix uninitialized local variable

Vinicius Costa Gomes (2):
      net: taprio: Fix returning EINVAL when configuring without flags
      sched: etf: Fix ordering of packets with same txtime

Vivien Didelot (1):
      net: dsa: fix switch tree list

Wei Wang (1):
      ipv4: fix race condition between route lookup and invalidation

Will Deacon (2):
      mac80211: Reject malformed SSID elements
      cfg80211: wext: avoid copying malformed SSIDs

Xin Long (2):
      sctp: add chunks to sk_backlog when the newsk sk_socket is not set
      sctp: change sctp_prot .no_autobind with true

Yonghong Song (1):
      libbpf: handle symbol versioning properly for libbpf.a

Yonglong Liu (2):
      net: phy: Fix "link partner" information disappear issue
      net: hns3: fix mis-counting IRQ vector numbers issue

YueHaibing (2):
      act_mirred: Fix mirred_init_module error handling
      netdevsim: Fix error handling in nsim_fib_init and nsim_fib_exit

 Documentation/networking/device_drivers/pensando/ionic.rst          |   4 +-
 Documentation/networking/net_dim.txt                                |  36 +++++++--------
 MAINTAINERS                                                         |   6 +--
 arch/arm/boot/dts/mt7629-rfb.dts                                    |  13 +++++-
 arch/arm/boot/dts/mt7629.dtsi                                       |   2 -
 drivers/net/bonding/bond_main.c                                     |   2 +-
 drivers/net/dsa/b53/b53_common.c                                    |   1 -
 drivers/net/dsa/microchip/ksz8795.c                                 |   4 --
 drivers/net/dsa/microchip/ksz8795_spi.c                             |   7 +--
 drivers/net/dsa/microchip/ksz9477_i2c.c                             |   6 ++-
 drivers/net/dsa/microchip/ksz9477_reg.h                             |   4 +-
 drivers/net/dsa/microchip/ksz9477_spi.c                             |   6 ++-
 drivers/net/dsa/microchip/ksz_common.c                              |   2 +-
 drivers/net/dsa/microchip/ksz_common.h                              |  20 +++++++--
 drivers/net/dsa/sja1105/sja1105.h                                   |   4 +-
 drivers/net/dsa/sja1105/sja1105_dynamic_config.h                    |   4 +-
 drivers/net/dsa/sja1105/sja1105_ptp.h                               |   4 +-
 drivers/net/dsa/sja1105/sja1105_static_config.h                     |   4 +-
 drivers/net/dsa/sja1105/sja1105_tas.h                               |   4 +-
 drivers/net/ethernet/aquantia/atlantic/aq_main.c                    |   4 +-
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c                     |  34 +++++++-------
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c                    |   3 +-
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c           |  23 +++++++---
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c          |  17 ++++++-
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.h          |   7 ++-
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh_internal.h |  19 ++++++++
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c   |   2 +-
 drivers/net/ethernet/broadcom/Kconfig                               |   4 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c                      |  41 ++++++++++-------
 drivers/net/ethernet/broadcom/genet/bcmgenet.h                      |   3 +-
 drivers/net/ethernet/broadcom/genet/bcmmii.c                        | 117 +++++++++++++++++++++++-------------------------
 drivers/net/ethernet/cadence/macb_main.c                            |  12 ++---
 drivers/net/ethernet/cavium/common/cavium_ptp.h                     |   2 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c                    |  50 ++++++++++++++++++++-
 drivers/net/ethernet/freescale/dpaa2/dpni.h                         |   5 ++-
 drivers/net/ethernet/hisilicon/hns3/hnae3.h                         |   2 +
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c             |  21 ++++++++-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h             |   1 +
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c               |  11 ++++-
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c           |  28 ++++++++++--
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h           |   1 +
 drivers/net/ethernet/i825xx/lasi_82596.c                            |   4 +-
 drivers/net/ethernet/i825xx/lib82596.c                              |   4 +-
 drivers/net/ethernet/i825xx/sni_82596.c                             |   4 +-
 drivers/net/ethernet/ibm/ibmvnic.c                                  |   8 ++--
 drivers/net/ethernet/mediatek/mtk_eth_soc.c                         |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c          |  10 ++---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c                 |   1 +
 drivers/net/ethernet/nxp/lpc_eth.c                                  |   3 --
 drivers/net/ethernet/pensando/ionic/ionic_lif.h                     |   2 +
 drivers/net/ethernet/pensando/ionic/ionic_stats.c                   |  29 +++++++-----
 drivers/net/ethernet/realtek/r8169_main.c                           |  35 +++++----------
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c                   |   3 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c                   |   2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac5.c                        |   1 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c                   |  14 +++---
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c                    |   2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c              |  11 ++++-
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c                     |   2 +-
 drivers/net/ethernet/ti/davinci_cpdma.c                             |   2 +-
 drivers/net/netdevsim/fib.c                                         |   3 +-
 drivers/net/phy/bcm7xxx.c                                           |   1 +
 drivers/net/phy/micrel.c                                            |  42 +++++++++++++++---
 drivers/net/phy/phy-c45.c                                           |   2 +
 drivers/net/phy/phy.c                                               |   3 --
 drivers/net/phy/phy_device.c                                        |  11 ++++-
 drivers/net/phy/phylink.c                                           |   2 +-
 drivers/net/tun.c                                                   |   4 +-
 drivers/net/usb/hso.c                                               |  13 ++++--
 drivers/net/usb/lan78xx.c                                           |  12 ++---
 drivers/net/usb/qmi_wwan.c                                          |   1 +
 drivers/net/usb/sr9800.c                                            |   2 +-
 drivers/net/wireless/ath/ath10k/core.c                              |  15 ++++---
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c                        |  10 +++--
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c                         |   1 +
 drivers/net/wireless/intel/iwlwifi/iwl-io.h                         |  12 ++---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c                         |  43 ++++++++++++------
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c                   |   9 ++--
 drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c            |  36 ++++++++++-----
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c                       | 274 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------------------------------------------------
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c                     |  25 ++++++++---
 drivers/net/wireless/mac80211_hwsim.c                               |   2 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00.h                         |   1 -
 drivers/net/wireless/ralink/rt2x00/rt2x00debug.c                    |   2 +-
 drivers/net/xen-netback/interface.c                                 |   1 -
 drivers/nfc/pn533/usb.c                                             |   9 +++-
 drivers/ptp/Kconfig                                                 |   4 +-
 drivers/s390/net/qeth_l2_main.c                                     |  23 ++++++----
 drivers/xen/pvcalls-back.c                                          |   2 +-
 include/linux/micrel_phy.h                                          |   2 +-
 include/linux/skbuff.h                                              |   5 ++-
 include/linux/tcp.h                                                 |   6 +--
 include/net/cfg80211.h                                              |   8 ++++
 include/net/llc_conn.h                                              |   2 +-
 include/net/net_namespace.h                                         |  25 +++++++----
 include/net/request_sock.h                                          |   4 +-
 include/net/sctp/sctp.h                                             |   5 +++
 include/net/sock.h                                                  |  33 +++++++++-----
 include/net/tcp.h                                                   |  10 +++--
 include/trace/events/rxrpc.h                                        |  18 ++++----
 include/trace/events/sock.h                                         |   4 +-
 net/bridge/netfilter/nf_conntrack_bridge.c                          |   3 ++
 net/core/datagram.c                                                 |   2 +-
 net/core/filter.c                                                   |   8 ++--
 net/core/net_namespace.c                                            |  17 ++++---
 net/core/request_sock.c                                             |   2 +-
 net/core/skbuff.c                                                   |  23 +++++-----
 net/core/sock.c                                                     |  32 +++++++------
 net/dsa/dsa2.c                                                      |   2 +-
 net/ipv4/inet_connection_sock.c                                     |   6 +--
 net/ipv4/inet_diag.c                                                |   2 +-
 net/ipv4/ip_output.c                                                |   3 ++
 net/ipv4/route.c                                                    |  11 +++--
 net/ipv4/tcp.c                                                      |  75 ++++++++++++++++++-------------
 net/ipv4/tcp_diag.c                                                 |   5 ++-
 net/ipv4/tcp_fastopen.c                                             |   2 +-
 net/ipv4/tcp_input.c                                                |  37 ++++++++-------
 net/ipv4/tcp_ipv4.c                                                 |  30 +++++++------
 net/ipv4/tcp_minisocks.c                                            |  17 ++++---
 net/ipv4/tcp_output.c                                               |  32 ++++++-------
 net/ipv4/tcp_timer.c                                                |  11 ++---
 net/ipv6/ip6_gre.c                                                  |   1 +
 net/ipv6/ip6_output.c                                               |   3 ++
 net/ipv6/netfilter.c                                                |   3 ++
 net/ipv6/tcp_ipv6.c                                                 |  18 ++++----
 net/llc/af_llc.c                                                    |  34 ++++++++------
 net/llc/llc_c_ac.c                                                  |   8 +++-
 net/llc/llc_conn.c                                                  |  69 ++++++++--------------------
 net/llc/llc_if.c                                                    |  12 +++--
 net/llc/llc_s_ac.c                                                  |  12 +++--
 net/llc/llc_sap.c                                                   |  23 ++++------
 net/mac80211/mlme.c                                                 |   5 ++-
 net/mac80211/rx.c                                                   |  11 ++++-
 net/mac80211/scan.c                                                 |  30 ++++++++++++-
 net/netfilter/nf_conntrack_core.c                                   |   4 +-
 net/openvswitch/actions.c                                           |   5 ++-
 net/rxrpc/ar-internal.h                                             |   1 +
 net/rxrpc/call_accept.c                                             |   5 ++-
 net/rxrpc/call_object.c                                             |  34 ++++++++------
 net/rxrpc/conn_client.c                                             |   9 +++-
 net/rxrpc/conn_object.c                                             |  13 +++---
 net/rxrpc/conn_service.c                                            |   2 +-
 net/rxrpc/peer_event.c                                              |  11 ++++-
 net/rxrpc/peer_object.c                                             |  16 ++++---
 net/rxrpc/recvmsg.c                                                 |   6 +--
 net/rxrpc/sendmsg.c                                                 |   3 +-
 net/sched/act_api.c                                                 |  23 +++++-----
 net/sched/act_mirred.c                                              |   6 ++-
 net/sched/act_mpls.c                                                |  12 +++--
 net/sched/cls_api.c                                                 |  36 +++++++++++++--
 net/sched/em_meta.c                                                 |   4 +-
 net/sched/sch_api.c                                                 |   3 +-
 net/sched/sch_etf.c                                                 |   2 +-
 net/sched/sch_netem.c                                               |  11 +++--
 net/sched/sch_taprio.c                                              |   4 ++
 net/sctp/diag.c                                                     |   2 +-
 net/sctp/input.c                                                    |  16 ++++---
 net/sctp/socket.c                                                   |   4 +-
 net/smc/smc_core.c                                                  |   5 ++-
 net/smc/smc_rx.c                                                    |  29 ++++++++----
 net/tipc/socket.c                                                   |   8 ++--
 net/vmw_vsock/virtio_transport_common.c                             |  17 +++++--
 net/wireless/nl80211.c                                              |   2 +-
 net/wireless/reg.c                                                  |   1 +
 net/wireless/reg.h                                                  |   8 ----
 net/wireless/scan.c                                                 |  23 +++++-----
 net/wireless/wext-sme.c                                             |   8 +++-
 net/x25/x25_dev.c                                                   |   2 +-
 net/xdp/xsk.c                                                       |  42 +++++++++++-------
 samples/bpf/asm_goto_workaround.h                                   |  13 +++++-
 samples/bpf/task_fd_query_user.c                                    |   1 +
 tools/bpf/Makefile                                                  |   6 ++-
 tools/lib/bpf/Makefile                                              |  33 +++++++++-----
 tools/lib/bpf/libbpf_internal.h                                     |  16 +++++++
 tools/lib/bpf/xsk.c                                                 |   4 +-
 tools/testing/selftests/bpf/prog_tests/sockopt_inherit.c            |   2 +-
 tools/testing/selftests/bpf/prog_tests/tcp_rtt.c                    |   3 +-
 tools/testing/selftests/bpf/test_flow_dissector.sh                  |   3 ++
 tools/testing/selftests/bpf/test_lwt_ip_encap.sh                    |   6 +--
 179 files changed, 1486 insertions(+), 892 deletions(-)
