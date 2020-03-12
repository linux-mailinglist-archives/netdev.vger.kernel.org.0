Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05F83183D26
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 00:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbgCLXOw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 12 Mar 2020 19:14:52 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36338 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726608AbgCLXOv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 19:14:51 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 06406158477D4;
        Thu, 12 Mar 2020 16:14:50 -0700 (PDT)
Date:   Thu, 12 Mar 2020 16:14:50 -0700 (PDT)
Message-Id: <20200312.161450.250161317006618802.davem@davemloft.net>
To:     torvalds@linux-foundation.org
CC:     akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 12 Mar 2020 16:14:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


It looks like a decent sized set of fixes, but a lot of these are one
liner off-by-one and similar type changes:

1) Fix netlink header pointer to calcular bad attribute offset
   reported to user.  From Pablo Neira Ayuso.

2) Don't double clear PHY interrupts when ->did_interrupt is set, from
   Heiner Kallweit.

3) Add missing validation of various (devlink, nl802154, fib, etc.)
   attributes, from Jakub Kicinski.

4) Missing *pos increments in various netfilter seq_next ops, from
   Vasily Averin.

5) Missing break in of_mdiobus_register() loop, from Dajun Jin.

6) Don't double bump tx_dropped in veth driver, from Jiang Lidong.

7) Work around FMAN erratum A050385, from Madalin Bucur.

8) Make sure ARP header is pulled early enough in bonding driver, from
   Eric Dumazet.

9) Do a cond_resched() during multicast processing of ipvlan and
   macvlan, from Mahesh Bandewar.

10) Don't attach cgroups to unrelated sockets when in interrupt
    context, from Shakeel Butt.

11) Fix tpacket ring state management when encountering unknown GSO
    types.  From Willem de Bruijn.

12) Fix MDIO bus PHY resume by checking mdio_bus_phy_may_suspend() only
    in the suspend context.  From Heiner Kallweit.

Please pull, thanks a lot!

The following changes since commit 7058b837899fc978c9f8a033fa29ab07360a85c8:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2020-02-27 16:34:41 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git 

for you to fetch changes up to c0368595c1639947839c0db8294ee96aca0b3b86:

  net: systemport: fix index check to avoid an array out of bounds access (2020-03-12 15:50:18 -0700)

----------------------------------------------------------------
Amol Grover (1):
      net: caif: Add lockdep expression to RCU traversal primitive

Andrew Lunn (2):
      net: dsa: Don't instantiate phylink for CPU/DSA ports unless needed
      net: dsa: mv88e6xxx: Add missing mask of ATU occupancy register

Chris Packham (1):
      net: mvmdio: avoid error message for optional IRQ

Colin Ian King (1):
      net: systemport: fix index check to avoid an array out of bounds access

Dajun Jin (1):
      drivers/of/of_mdio.c:fix of_mdiobus_register()

Dan Carpenter (1):
      net: nfc: fix bounds checking bugs on "pipe"

Dan Moulding (1):
      iwlwifi: mvm: Do not require PHY_SKU NVM section for 3168 devices

David S. Miller (12):
      Merge branch 'bnxt_en-2-bug-fixes'
      Merge branch 'net-add-missing-netlink-policies'
      Merge branch 'Fix-IPv6-peer-route-update'
      Merge tag 'wireless-drivers-2020-03-05' of git://git.kernel.org/.../kvalo/wireless-drivers
      Merge git://git.kernel.org/.../pablo/nf
      Merge branch 'QorIQ-DPAA-FMan-erratum-A050385-workaround'
      Merge tag 'batadv-net-for-davem-20200306' of git://git.open-mesh.org/linux-merge
      Merge branch 'MACSec-bugfixes-related-to-MAC-address-change'
      Merge branch 's390-qeth-fixes'
      Merge tag 'mac80211-for-net-2020-03-11' of git://git.kernel.org/.../jberg/mac80211
      Merge branch 's390-qeth-fixes'
      Merge branch 'hns3-fixes'

Davide Caratti (1):
      tc-testing: add ETS scheduler to tdc build configuration

Dmitry Bogdanov (2):
      net: macsec: update SCI upon MAC address change.
      net: macsec: invoke mdo_upd_secy callback when mac address changed

Dmitry Yakunin (2):
      inet_diag: return classid for all socket types
      cgroup, netclassid: periodically release file_lock on classid updating

Dominik Czarnota (1):
      sxgbe: Fix off by one in samsung driver strncpy size arg

Edward Cree (1):
      sfc: detach from cb_page in efx_copy_channel()

Edwin Peer (1):
      bnxt_en: fix error handling when flashing from file

Eric Dumazet (5):
      slip: make slhc_compress() more robust against malicious packets
      bonding/alb: make sure arp header is pulled before accessing it
      gre: fix uninit-value in __iptunnel_pull_header
      ipvlan: do not use cond_resched_rcu() in ipvlan_process_multicast()
      net: memcg: fix lockdep splat in inet_csk_accept()

Felix Fietkau (1):
      mt76: fix array overflow on receiving too many fragments for a packet

Florian Westphal (2):
      netfilter: nf_tables: free flowtable hooks on hook register error
      netfilter: nf_tables: fix infinite loop when expr is not available

Hangbin Liu (5):
      net/ipv6: use configured metric when add peer route
      net/ipv6: need update peer route when modify metric
      net/ipv6: remove the old peer route if change it to a new one
      selftests/net/fib_tests: update addr_metric_test for peer route testing
      ipv6/addrconf: call ipv6_mc_up() for non-Ethernet interface

Hauke Mehrtens (1):
      phylink: Improve error message when validate failed

Heiner Kallweit (2):
      net: phy: avoid clearing PHY interrupts twice in irq handler
      net: phy: fix MDIO bus PM PHY resuming

Jacob Keller (1):
      devlink: remove trigger command from devlink-region.rst

Jakub Kicinski (26):
      devlink: validate length of param values
      devlink: validate length of region addr/len
      fib: add missing attribute validation for tun_id
      nl802154: add missing attribute validation
      nl802154: add missing attribute validation for dev_type
      can: add missing attribute validation for termination
      macsec: add missing attribute validation for port
      openvswitch: add missing attribute validation for hash
      net: fq: add missing attribute validation for orphan mask
      net: taprio: add missing attribute validation for txtime delay
      team: add missing attribute validation for port ifindex
      team: add missing attribute validation for array index
      tipc: add missing attribute validation for MTU property
      nfc: add missing attribute validation for SE API
      nfc: add missing attribute validation for deactivate target
      nfc: add missing attribute validation for vendor subcommand
      netfilter: cthelper: add missing attribute validation for cthelper
      netfilter: nft_payload: add missing attribute validation for payload csum flags
      netfilter: nft_tunnel: add missing attribute validation for tunnels
      MAINTAINERS: remove bouncing pkaustub@cisco.com from enic
      MAINTAINERS: update cxgb4vf maintainer to Vishal
      nl80211: add missing attribute validation for critical protocol indication
      nl80211: add missing attribute validation for beacon report scanning
      nl80211: add missing attribute validation for channel switch
      net: fec: validate the new settings in fec_enet_set_coalesce()
      MAINTAINERS: remove Sathya Perla as Emulex NIC maintainer

Jian Shen (4):
      net: hns3: fix a not link up issue when fibre port supports autoneg
      net: hns3: fix VF VLAN table entries inconsistent issue
      net: hns3: fix RMW issue for VLAN filter switch
      net: hns3: clear port base VLAN when unload PF

Jiang Lidong (1):
      veth: ignore peer tx_dropped when counting local rx_dropped

Jiri Wiesner (1):
      ipvlan: do not add hardware address of master to its unicast filter list

Jonas Gorski (1):
      net: phy: bcm63xx: fix OOPS due to missing driver name

Jonathan Neuschäfer (2):
      docs: networking: net_failover: Fix a few typos
      rhashtable: Document the right function parameters

Julian Wiedmann (6):
      s390/qeth: don't reset default_out_queue
      s390/qeth: handle error when backing RX buffer
      s390/qeth: cancel RX reclaim work earlier
      s390/qeth: use page pointers to manage RX buffer pool
      s390/qeth: refactor buffer pool code
      s390/qeth: implement smarter resizing of the RX buffer pool

Juliet Kim (1):
      ibmvnic: Do not process device remove during device reset

Karsten Graul (1):
      net/smc: cancel event worker during device removal

Madalin Bucur (4):
      dt-bindings: net: FMan erratum A050385
      arm64: dts: ls1043a: FMan erratum A050385
      fsl/fman: detect FMan erratum A050385
      dpaa_eth: FMan erratum A050385 workaround

Mahesh Bandewar (3):
      ipvlan: don't deref eth hdr before checking it's set
      ipvlan: add cond_resched_rcu() while processing muticast backlog
      macvlan: add cond_resched() during multicast processing

Masanari Iida (1):
      linux-next: DOC: RDS: Fix a typo in rds.txt

Nathan Chancellor (1):
      dpaa_eth: Remove unnecessary boolean expression in dpaa_get_headroom

Nicolas Cavallari (1):
      mac80211: Do not send mesh HWMP PREQ if HWMP is disabled

Pablo Neira Ayuso (3):
      netlink: Use netlink header as base to calculate bad attribute offset
      netfilter: nf_tables: dump NFTA_CHAIN_FLAGS attribute
      netfilter: nft_chain_nat: inet family is missing module ownership

Paolo Abeni (1):
      mptcp: always include dack if possible.

Paolo Lungaroni (1):
      seg6: fix SRv6 L2 tunnels to use IANA-assigned protocol number

Randy Dunlap (1):
      atm: nicstar: fix if-statement empty body warning

Remi Pommarel (1):
      net: stmmac: dwmac1000: Disable ACS if enhanced descs are not used

Russell King (2):
      net: dsa: mv88e6xxx: fix lockup on warm boot
      net: dsa: fix phylink_start()/phylink_stop() calls

Shakeel Butt (2):
      cgroup: memcg: net: do not associate sock with unrelated cgroup
      net: memcg: late association of sock to memcg

Shannon Nelson (1):
      ionic: fix vf op lock usage

Sven Eckelmann (1):
      batman-adv: Don't schedule OGM for disabled interface

Tom Zhao (1):
      sfc: complete the next packet when we receive a timestamp

Vasily Averin (4):
      netfilter: nf_conntrack: ct_cpu_seq_next should increase position index
      netfilter: synproxy: synproxy_cpu_seq_next should increase position index
      netfilter: xt_recent: recent_seq_next should increase position index
      netfilter: x_tables: xt_mttg_seq_next should increase position index

Vasundhara Volam (1):
      bnxt_en: reinitialize IRQs when MTU is modified

Vinicius Costa Gomes (1):
      taprio: Fix sending packets without dequeueing them

Vishal Kulkarni (1):
      cxgb4: fix checks for max queues to allocate

Vladimir Oltean (2):
      net: dsa: sja1105: Don't destroy not-yet-created xmit_worker
      net: mscc: ocelot: properly account for VLAN header length when setting MRU

Willem de Bruijn (1):
      net/packet: tpacket_rcv: do not increment ring index on drop

Yonglong Liu (1):
      net: hns3: fix "tc qdisc del" failed issue

You-Sheng Yang (1):
      r8152: check disconnect status after long sleep

 Documentation/devicetree/bindings/net/fsl-fman.txt        |   7 +++
 Documentation/networking/devlink/devlink-region.rst       |   3 --
 Documentation/networking/net_failover.rst                 |   6 +--
 Documentation/networking/rds.txt                          |   2 +-
 MAINTAINERS                                               |   4 +-
 arch/arm64/boot/dts/freescale/fsl-ls1043-post.dtsi        |   2 +
 drivers/atm/nicstar.c                                     |   2 +-
 drivers/net/bonding/bond_alb.c                            |  20 ++++-----
 drivers/net/can/dev.c                                     |   1 +
 drivers/net/dsa/mv88e6xxx/chip.c                          |   2 +
 drivers/net/dsa/mv88e6xxx/global2.c                       |   8 +++-
 drivers/net/dsa/sja1105/sja1105_main.c                    |   3 +-
 drivers/net/ethernet/broadcom/bcmsysport.c                |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                 |   4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c         |  24 +++++------
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c           |  49 +++++++++++----------
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c            | 114 ++++++++++++++++++++++++++++++++++++++++++++++---
 drivers/net/ethernet/freescale/fec_main.c                 |   6 +--
 drivers/net/ethernet/freescale/fman/Kconfig               |  28 ++++++++++++
 drivers/net/ethernet/freescale/fman/fman.c                |  18 ++++++++
 drivers/net/ethernet/freescale/fman/fman.h                |   5 +++
 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h           |   1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c           |   2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c   |  47 ++++++++++++++++++---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c    |   1 +
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c |   3 ++
 drivers/net/ethernet/ibm/ibmvnic.c                        |  24 ++++++++++-
 drivers/net/ethernet/ibm/ibmvnic.h                        |   6 ++-
 drivers/net/ethernet/marvell/mvmdio.c                     |   6 +--
 drivers/net/ethernet/mscc/ocelot.c                        |  28 +++++++-----
 drivers/net/ethernet/pensando/ionic/ionic_lif.c           |   8 ++--
 drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c           |   2 +-
 drivers/net/ethernet/sfc/ef10.c                           |  32 +++++++-------
 drivers/net/ethernet/sfc/efx.h                            |   1 +
 drivers/net/ethernet/sfc/efx_channels.c                   |   1 +
 drivers/net/ethernet/sfc/net_driver.h                     |   3 --
 drivers/net/ethernet/sfc/tx.c                             |  38 +++++++++++++++++
 drivers/net/ethernet/sfc/tx_common.c                      |  29 +++++++------
 drivers/net/ethernet/sfc/tx_common.h                      |   6 +++
 drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c      |   3 +-
 drivers/net/ipvlan/ipvlan_core.c                          |  19 +++++----
 drivers/net/ipvlan/ipvlan_main.c                          |   5 +--
 drivers/net/macsec.c                                      |  25 ++++++++---
 drivers/net/macvlan.c                                     |   2 +
 drivers/net/phy/bcm63xx.c                                 |   1 +
 drivers/net/phy/phy.c                                     |   3 +-
 drivers/net/phy/phy_device.c                              |   6 ++-
 drivers/net/phy/phylink.c                                 |   8 +++-
 drivers/net/slip/slhc.c                                   |  14 ++++--
 drivers/net/team/team.c                                   |   2 +
 drivers/net/usb/r8152.c                                   |   8 ++++
 drivers/net/veth.c                                        |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c              |   3 +-
 drivers/net/wireless/mediatek/mt76/dma.c                  |   9 ++--
 drivers/of/of_mdio.c                                      |   1 +
 drivers/s390/net/qeth_core.h                              |   4 +-
 drivers/s390/net/qeth_core_main.c                         | 176 +++++++++++++++++++++++++++++++++++++++++++++++++++-------------------------
 drivers/s390/net/qeth_core_sys.c                          |   9 ++--
 drivers/s390/net/qeth_l2_main.c                           |   1 +
 drivers/s390/net/qeth_l3_main.c                           |   1 +
 drivers/s390/net/qeth_l3_sys.c                            |   9 ++--
 include/linux/inet_diag.h                                 |  18 +++++---
 include/linux/phy.h                                       |   3 ++
 include/linux/rhashtable.h                                |   2 +-
 include/net/fib_rules.h                                   |   1 +
 include/soc/mscc/ocelot_dev.h                             |   2 +-
 include/uapi/linux/in.h                                   |   2 +
 kernel/cgroup/cgroup.c                                    |   4 ++
 mm/memcontrol.c                                           |  14 +-----
 net/batman-adv/bat_iv_ogm.c                               |   4 ++
 net/caif/caif_dev.c                                       |   3 +-
 net/core/devlink.c                                        |  33 +++++++++------
 net/core/netclassid_cgroup.c                              |  47 ++++++++++++++++-----
 net/core/sock.c                                           |   5 ++-
 net/dsa/dsa_priv.h                                        |   2 +
 net/dsa/port.c                                            |  44 +++++++++++++++----
 net/dsa/slave.c                                           |   8 +---
 net/ieee802154/nl_policy.c                                |   6 +++
 net/ipv4/gre_demux.c                                      |  12 +++++-
 net/ipv4/inet_connection_sock.c                           |  20 +++++++++
 net/ipv4/inet_diag.c                                      |  44 +++++++++----------
 net/ipv4/raw_diag.c                                       |   5 ++-
 net/ipv4/udp_diag.c                                       |   5 ++-
 net/ipv6/addrconf.c                                       |  51 +++++++++++++++++-----
 net/ipv6/seg6_iptunnel.c                                  |   2 +-
 net/ipv6/seg6_local.c                                     |   2 +-
 net/mac80211/mesh_hwmp.c                                  |   3 +-
 net/mptcp/options.c                                       |  19 ++++++++-
 net/netfilter/nf_conntrack_standalone.c                   |   2 +-
 net/netfilter/nf_synproxy_core.c                          |   2 +-
 net/netfilter/nf_tables_api.c                             |  22 ++++++----
 net/netfilter/nfnetlink_cthelper.c                        |   2 +
 net/netfilter/nft_chain_nat.c                             |   1 +
 net/netfilter/nft_payload.c                               |   1 +
 net/netfilter/nft_tunnel.c                                |   2 +
 net/netfilter/x_tables.c                                  |   6 +--
 net/netfilter/xt_recent.c                                 |   2 +-
 net/netlink/af_netlink.c                                  |   2 +-
 net/nfc/hci/core.c                                        |  19 +++++++--
 net/nfc/netlink.c                                         |   4 ++
 net/openvswitch/datapath.c                                |   1 +
 net/packet/af_packet.c                                    |  13 +++---
 net/sched/sch_fq.c                                        |   1 +
 net/sched/sch_taprio.c                                    |  13 ++++--
 net/sctp/diag.c                                           |   8 +---
 net/smc/smc_ib.c                                          |   1 +
 net/tipc/netlink.c                                        |   1 +
 net/wireless/nl80211.c                                    |   5 +++
 tools/testing/selftests/net/fib_tests.sh                  |  34 +++++++++++++--
 tools/testing/selftests/tc-testing/config                 |   1 +
 110 files changed, 993 insertions(+), 370 deletions(-)
