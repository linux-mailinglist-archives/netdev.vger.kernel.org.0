Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6192183DD9
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 01:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbfHFXgR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 6 Aug 2019 19:36:17 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:51380 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726375AbfHFXgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 19:36:17 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1663415248636;
        Tue,  6 Aug 2019 16:36:16 -0700 (PDT)
Date:   Tue, 06 Aug 2019 16:35:57 -0700 (PDT)
Message-Id: <20190806.163557.192717542972894245.davem@davemloft.net>
To:     torvalds@linux-foundation.org
CC:     akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 06 Aug 2019 16:36:16 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Yeah I should have sent a pull request last week, so there is a lot
more here than usual.  Sorry about that:

1) Fix memory leak in ebtables compat code, from Wenwen Wang.

2) Several kTLS bug fixes from Jakub Kicinski (circular close on
   disconnect etc.)

3) Force slave speed check on link state recovery in bonding 802.3ad
   mode, from Thomas Falcon.

4) Clear RX descriptor bits before assigning buffers to them in
   stmmac, from Jose Abreu.

5) Several missing of_node_put() calls, mostly wrt. for_each_*()
   OF loops, from Nishka Dasgupta.

6) Double kfree_skb() in peak_usb can driver, from Stephane Grosjean.

7) Need to hold sock across skb->destructor invocation, from Cong
   Wang.

8) IP header length needs to be validated in ipip tunnel xmit, from
   Haishuang Yan.

9) Use after free in ip6 tunnel driver, also from Haishuang Yan.

10) Do not use MSI interrupts on r8169 chips before RTL8168d, from
    Heiner Kallweit.

11) Upon bridge device init failure, we need to delete the local fdb.
    From Nikolay Aleksandrov.

12) Handle erros from of_get_mac_address() properly in stmmac, from
    Martin Blumenstingl.

13) Handle concurrent rename vs. dump in netfilter ipset, from Jozsef
    Kadlecsik.

14) Setting NETIF_F_LLTX on mac80211 causes complete breakage with
    some devices, so revert.  From Johannes Berg.

15) Fix deadlock in rxrpc, from David Howells.

16) Fix Kconfig deps of enetc driver, we must have PHYLIB.  From Yue
    Haibing.

17) Fix mvpp2 crash on module removal, from Matteo Croce.

18) Fix race in genphy_update_link, from Heiner Kallweit.

19)  bpf_xdp_adjust_head() stopped working with generic XDP when we
     fixes generic XDP to support stacked devices properly, fix from
     Jesper Dangaard Brouer.

20) Unbalanced RCU locking in rt6_update_exception_stamp_rt(), from
    David Ahern.

21) Several memory leaks in new sja1105 driver, from Vladimir Oltean.

Please pull, thanks a lot!

The following changes since commit 7b5cf701ea9c395c792e2a7e3b7caf4c68b87721:

  Merge branch 'sched-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip (2019-07-22 09:30:34 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git 

for you to fetch changes up to feac1d680233a48603213d52230f92222462a1c8:

  Merge branch 'sja1105-fixes' (2019-08-06 14:37:02 -0700)

----------------------------------------------------------------
Alexei Starovoitov (1):
      Merge branch 'fix-gso_segs'

Alexis Bauvin (1):
      tun: mark small packets as owned by the tap sock

Andreas Schwab (1):
      net: phy: mscc: initialize stats array

Andrii Nakryiko (3):
      libbpf: fix SIGSEGV when BTF loading fails, but .BTF.ext exists
      libbpf: sanitize VAR to conservative 1-byte INT
      libbpf: silence GCC8 warning about string truncation

Andy Shevchenko (1):
      net: thunderx: Use fwnode_get_mac_address()

Ariel Levkovich (1):
      net/mlx5e: Prevent encap flow counter update async to user query

Arnaldo Carvalho de Melo (2):
      libbpf: Fix endianness macro usage for some compilers
      libbpf: Avoid designated initializers for unnamed union members

Arnaud Patard (1):
      drivers/net/ethernet/marvell/mvmdio.c: Fix non OF case

Arnd Bergmann (2):
      ovs: datapath: hide clang frame-overflow warnings
      compat_ioctl: pppoe: fix PPPOEIOCSFWD handling

Arseny Solokha (1):
      net: phylink: don't start and stop SGMII PHYs in SFP modules twice

Aya Levin (1):
      net/mlx5e: Fix matching of speed to PRM link modes

Bob Ham (1):
      net: usb: qmi_wwan: Add the BroadMobi BM818 card

Brian Norris (2):
      mac80211: don't WARN on short WMM parameters from AP
      mwifiex: fix 802.11n/WPA detection

Catherine Sullivan (1):
      gve: Fix case where desc_cnt and data_cnt can get out of sync

Chen-Yu Tsai (1):
      net: ethernet: sun4i-emac: Support phy-handle property for finding PHYs

Chris Packham (1):
      fsl/fman: Remove comment referring to non-existent function

Christophe JAILLET (3):
      net: ethernet: et131x: Use GFP_KERNEL instead of GFP_ATOMIC when allocating tx_ring->tcb_ring
      net: ag71xx: Use GFP_KERNEL instead of GFP_ATOMIC in 'ag71xx_rings_init()'
      net: cxgb3_main: Fix a resource leak in a error path in 'init_one()'

Claudiu Manoil (1):
      ocelot: Cancel delayed work before wq destruction

Colin Ian King (3):
      rocker: fix memory leaks of fib_work on two error return paths
      iwlwifi: mvm: fix comparison of u32 variable with less than zero
      mlxsw: spectrum_ptp: fix duplicated check on orig_egr_types

Cong Wang (2):
      netrom: hold sock when setting skb->destructor
      ife: error out when nla attributes are empty

Daniel Borkmann (1):
      Merge branch 'bpf-sockmap-tls-fixes'

David Ahern (1):
      ipv6: Fix unbalanced rcu locking in rt6_update_exception_stamp_rt

David Howells (2):
      rxrpc: Fix potential deadlock
      rxrpc: Fix the lack of notification when sendmsg() fails on a DATA packet

David S. Miller (20):
      Merge branch 'stmmac-fixes'
      Revert "net: hns: fix LED configuration for marvell phy"
      Merge branch 'selftests-forwarding-GRE-multipath-fixes'
      Merge tag 'linux-can-fixes-for-5.3-20190724' of git://git.kernel.org/.../mkl/linux-can
      Merge branch 'dim-fixes'
      Merge git://git.kernel.org/.../bpf/bpf
      Merge tag 'mlx5-fixes-2019-07-25' of git://git.kernel.org/.../saeed/linux
      Merge tag 'rxrpc-fixes-20190730' of git://git.kernel.org/.../dhowells/linux-fs
      Merge branch 'mlxsw-Two-small-fixes'
      Merge git://git.kernel.org/.../pablo/nf
      Merge tag 'mac80211-for-davem-2019-07-31' of git://git.kernel.org/.../jberg/mac80211
      Merge branch 'net-Manufacturer-names-and-spelling-fixes'
      Merge branch 'net-fix-regressions-for-generic-XDP'
      Merge tag 'linux-can-fixes-for-5.3-20190802' of git://git.kernel.org/.../mkl/linux-can
      Merge tag 'wireless-drivers-for-davem-2019-08-06' of git://git.kernel.org/.../kvalo/wireless-drivers
      Merge branch 'stmmac-fixes'
      Merge branch 'Fix-batched-event-generation-for-vlan-action'
      Merge branch 'hisilicon-fixes'
      Merge branch 'flow_offload-action-fixes'
      Merge branch 'sja1105-fixes'

Denis Kirjanov (2):
      net: usb: pegasus: fix improper read if get_registers() fail
      be2net: disable bh with spin_lock in be_process_mcc

Dexuan Cui (1):
      hv_sock: Fix hang when a connection is closed

Dmytro Linkin (1):
      net: sched: use temporary variable for actions indexes

Edward Srouji (1):
      net/mlx5: Fix modify_cq_in alignment

Emmanuel Grumbach (8):
      iwlwifi: mvm: prepare the ground for more RSS notifications
      iwlwifi: mvm: add a new RSS sync notification for NSSN sync
      iwlwiif: mvm: refactor iwl_mvm_notify_rx_queue
      iwlwifi: mvm: add a loose synchronization of the NSSN across Rx queues
      iwlwifi: mvm: fix frame drop from the reordering buffer
      iwlwifi: don't unmap as page memory that was mapped as single
      iwlwifi: mvm: fix an out-of-bound access
      iwlwifi: mvm: fix a use-after-free bug in iwl_mvm_tx_tso_segment

Enrico Weigelt (1):
      net: sctp: drop unneeded likely() call around IS_ERR()

Eric Dumazet (2):
      bpf: fix access to skb_shared_info->gso_segs
      selftests/bpf: add another gso_segs access

Florian Westphal (1):
      netfilter: ebtables: also count base chain policies

Frode Isaksen (1):
      net: stmmac: Use netif_tx_napi_add() for TX polling function

Geert Uytterhoeven (9):
      net: mediatek: Drop unneeded dependency on NET_VENDOR_MEDIATEK
      net: 8390: Fix manufacturer name in Kconfig help text
      net: amd: Spelling s/case/cause/
      net: apple: Fix manufacturer name in Kconfig help text
      net: broadcom: Fix manufacturer name in Kconfig help text
      net: ixp4xx: Spelling s/XSacle/XScale/
      net: nixge: Spelling s/Instrument/Instruments/
      net: packetengines: Fix manufacturer spelling and capitalization
      net: samsung: Spelling s/case/cause/

Gregory Greenman (4):
      iwlwifi: mvm: add a wrapper around rs_tx_status to handle locks
      iwlwifi: mvm: send LQ command always ASYNC
      iwlwifi: mvm: replace RS mutex with a spin_lock
      iwlwifi: mvm: fix possible out-of-bounds read when accessing lq_info

Gustavo A. R. Silva (11):
      arcnet: com90xx: Mark expected switch fall-throughs
      arcnet: com90io: Mark expected switch fall-throughs
      arcnet: arc-rimi: Mark expected switch fall-throughs
      arcnet: com20020-isa: Mark expected switch fall-throughs
      net/af_iucv: mark expected switch fall-throughs
      net: ehea: Mark expected switch fall-through
      net: spider_net: Mark expected switch fall-through
      net: wan: sdla: Mark expected switch fall-through
      net: hamradio: baycom_epp: Mark expected switch fall-through
      net: smc911x: Mark expected switch fall-through
      atm: iphase: Fix Spectre v1 vulnerability

Haishuang Yan (3):
      ip6_gre: reload ipv6h in prepare_ip6gre_xmit_ipv6
      ipip: validate header length in ipip_tunnel_xmit
      ip6_tunnel: fix possible use-after-free on xmit

Heiner Kallweit (3):
      Revert ("r8169: remove 1000/Half from supported modes")
      r8169: don't use MSI before RTL8168d
      net: phy: fix race in genphy_update_link

Hubert Feurstein (3):
      net: phy: fixed_phy: print gpio error only if gpio node is present
      net: dsa: mv88e6xxx: use link-down-define instead of plain value
      net: dsa: mv88e6xxx: drop adjust_link to enabled phylink

Ido Schimmel (3):
      selftests: forwarding: gre_multipath: Enable IPv4 forwarding
      selftests: forwarding: gre_multipath: Fix flower filters
      drop_monitor: Add missing uAPI file to MAINTAINERS file

Ihab Zhaika (1):
      iwlwifi: add 3 new IDs for the 9000 series (iwl9260_2ac_160_cfg)

Ilya Leoshkevich (2):
      selftests/bpf: fix sendmsg6_prog on s390
      bpf: fix narrower loads on s390

Ilya Maximets (1):
      libbpf: fix using uninitialized ioctl results

Jakub Kicinski (12):
      net/tls: don't arm strparser immediately in tls_set_sw_offload()
      net/tls: don't call tls_sk_proto_close for hw record offload
      selftests/tls: add a test for ULP but no keys
      selftests/tls: test error codes around TLS ULP installation
      selftests/tls: add a bidirectional test
      selftests/tls: close the socket with open record
      selftests/tls: add shutdown tests
      net/tls: add myself as a co-maintainer
      selftests/net: add missing gitignores (ipv6_flowlabel)
      selftests/tls: fix TLS tests with CONFIG_TLS=n
      net/tls: partially revert fix transition through disconnect with close
      selftests/tls: add a litmus test for the socket reuse through shutdown

Jesper Dangaard Brouer (5):
      MAINTAINERS: Remove mailing-list entry for XDP (eXpress Data Path)
      bpf: fix XDP vlan selftests test_xdp_vlan.sh
      selftests/bpf: add wrapper scripts for test_xdp_vlan.sh
      selftests/bpf: reduce time to execute test_xdp_vlan.sh
      net: fix bpf_xdp_adjust_head regression for generic-XDP

Jia-Ju Bai (5):
      isdn: mISDN: hfcsusb: Fix possible null-pointer dereferences in start_isoc_chain()
      net: rds: Fix possible null-pointer dereferences in rds_rdma_cm_event_handler_cmn()
      mac80211_hwsim: Fix possible null-pointer dereferences in hwsim_dump_radio_nl()
      net: sched: Fix a possible null-pointer dereference in dequeue_func()
      net: phy: phy_led_triggers: Fix a possible null-pointer dereference in phy_led_trigger_change_speed()

Jiangfeng Xiao (3):
      net: hisilicon: make hip04_tx_reclaim non-reentrant
      net: hisilicon: fix hip04-xmit never return TX_BUSY
      net: hisilicon: Fix dma_map_single failed on arm64

Jiri Pirko (2):
      net: fix ifindex collision during namespace removal
      mlxsw: spectrum: Fix error path in mlxsw_sp_module_init()

Joakim Zhang (1):
      can: flexcan: fix stop mode acknowledgment

Johan Hovold (1):
      NFC: nfcmrvl: fix gpio-handling regression

Johannes Berg (3):
      Revert "mac80211: set NETIF_F_LLTX when using intermediate tx queues"
      iwlwifi: mvm: disable TX-AMSDU on older NICs
      iwlwifi: fix locking in delayed GTK setting

John Fastabend (7):
      net/tls: remove close callback sock unlock/lock around TX work flush
      net/tls: remove sock unlock/lock around strp_done()
      net/tls: fix transition through disconnect with close
      bpf: sockmap, sock_map_delete needs to use xchg
      bpf: sockmap, synchronize_rcu before free'ing map
      bpf: sockmap, only create entry if ulp is not already enabled
      bpf: sockmap/tls, close can race with map free

Jon Maloy (1):
      tipc: fix unitilized skb list crash

Jose Abreu (7):
      net: stmmac: RX Descriptors need to be clean before setting buffers
      net: stmmac: Use kcalloc() instead of kmalloc_array()
      net: stmmac: Do not cut down 1G modes
      net: stmmac: Sync RX Buffer upon allocation
      net: stmmac: xgmac: Fix XGMAC selftests
      net: stmmac: Fix issues when number of Queues >= 4
      net: stmmac: tc: Do not return a fragment entry

Jozsef Kadlecsik (1):
      netfilter: ipset: Fix rename concurrency with listing

Juliana Rodrigueiro (1):
      isdn: hfcsusb: Fix mISDN driver crash caused by transfer buffer on the stack

Kalle Valo (1):
      Merge tag 'iwlwifi-fixes-for-kvalo-2019-07-30' of git://git.kernel.org/.../iwlwifi/iwlwifi-fixes

Kevin Lo (1):
      r8152: fix typo in register name

Leon Romanovsky (1):
      lib/dim: Fix -Wunused-const-variable warnings

Luca Coelho (2):
      iwlwifi: mvm: don't send GEO_TX_POWER_LIMIT on version < 41
      iwlwifi: mvm: fix version check for GEO_TX_POWER_LIMIT support

Manikanta Pubbisetty (1):
      {nl,mac}80211: fix interface combinations on crypto controlled devices

Maor Gottlieb (1):
      net/mlx5: Add missing RDMA_RX capabilities

Mark Zhang (1):
      net/mlx5: Use reversed order when unregister devices

Martin Blumenstingl (1):
      net: stmmac: manage errors returned by of_get_mac_address()

Masahiro Yamada (1):
      netfilter: add include guard to xt_connlabel.h

Matteo Croce (3):
      mvpp2: refactor MTU change code
      mvpp2: refactor the HW checksum setup
      mvpp2: fix panic on module removal

Mauro Rossi (1):
      iwlwifi: dbg_ini: fix compile time assert build errors

Maxime Chevallier (1):
      net: mvpp2: Don't check for 3 consecutive Idle frames for 10G links

Michal Kalderon (1):
      qed: RDMA - Fix the hw_ver returned in device attributes

Mordechay Goodstein (1):
      iwlwifi: mvm: avoid races in rate init and rate perform

Navid Emamdoost (2):
      st21nfca_connectivity_event_received: null check the allocation
      st_nci_hci_connectivity_event_received: null check the allocation

Nikita Yushchenko (1):
      can: rcar_canfd: fix possible IRQ storm on high load

Nikolay Aleksandrov (3):
      net: bridge: delete local fdb on device init failure
      net: bridge: mcast: don't delete permanent entries when fast leave is enabled
      net: bridge: move default pvid init/deinit to NETDEV_REGISTER/UNREGISTER

Nishka Dasgupta (3):
      net: dsa: mv88e6xxx: chip: Add of_node_put() before return
      net: dsa: sja1105: sja1105_main: Add of_node_put()
      net: dsa: qca8k: Add of_node_put() in qca8k_setup_mdio_bus()

Pablo Neira Ayuso (1):
      Merge branch 'master' of git://blackhole.kfki.hu/nf

Paul Bolle (1):
      gigaset: stop maintaining seperately

Pavel Machek (1):
      net/ipv4: cleanup error condition testing

Petr Machata (2):
      mlxsw: spectrum_ptp: Increase parsing depth when PTP is enabled
      mlxsw: spectrum_buffers: Further reduce pool size on Spectrum-2

Phil Sutter (2):
      netfilter: nf_tables: Make nft_meta expression more robust
      netfilter: nft_meta_bridge: Eliminate 'out' label

Qian Cai (2):
      net/socket: fix GCC8+ Wpacked-not-aligned warnings
      net/mlx5e: always initialize frag->last_in_page

Rasmus Villemoes (1):
      can: dev: call netif_carrier_off() in register_candev()

René van Dorst (1):
      net: phylink: Fix flow control for fixed-link

Roman Mashak (2):
      net sched: update vlan action for batched events operations
      tc-testing: updated vlan action tests with batch create/delete

Shahar S Matityahu (2):
      iwlwifi: dbg_ini: move iwl_dbg_tlv_load_bin out of debug override ifdef
      iwlwifi: dbg_ini: move iwl_dbg_tlv_free outside of debugfs ifdef

Stefano Brivio (2):
      netfilter: ipset: Actually allow destination MAC address for hash:ip,mac sets too
      netfilter: ipset: Copy the right MAC address in bitmap:ip,mac and hash:ip,mac sets

Stephane Grosjean (1):
      can: peak_usb: fix potential double kfree_skb()

Subash Abhinov Kasiviswanathan (1):
      net: qualcomm: rmnet: Fix incorrect UL checksum offload logic

Sudarsana Reddy Kalluru (1):
      bnx2x: Disable multi-cos feature.

Takashi Iwai (1):
      sky2: Disable MSI on ASUS P6T

Taras Kondratiuk (1):
      tipc: compat: allow tipc commands without arguments

Tariq Toukan (4):
      net/mlx5e: Fix wrong max num channels indication
      net/mlx5e: kTLS, Call WARN_ONCE on netdev mismatch
      nfp: tls: rename tls packet counters
      Documentation: TLS: fix stat counters description

Thomas Falcon (1):
      bonding: Force slave speed check after link state recovery for 802.3ad

Tomas Bortoli (2):
      can: peak_usb: pcan_usb_fd: Fix info-leaks to USB devices
      can: peak_usb: pcan_usb_pro: Fix info-leaks to USB devices

Ursula Braun (2):
      net/smc: do not schedule tx_work in SMC_CLOSED state
      net/smc: avoid fallback in case of non-blocking connect

Vlad Buslov (2):
      net: sched: police: allow accessing police->params with rtnl
      net: sched: sample: allow accessing psample_group with rtnl

Vladimir Oltean (5):
      net: dsa: sja1105: Fix broken learning with vlan_filtering disabled
      net: dsa: sja1105: Use the LOCKEDS bit for SJA1105 E/T as well
      net: dsa: sja1105: Really fix panic on unregistering PTP clock
      net: dsa: sja1105: Fix memory leak on meta state machine normal path
      net: dsa: sja1105: Fix memory leak on meta state machine error path

Wang Xiayang (3):
      can: sja1000: force the string buffer NULL-terminated
      can: peak_usb: force the string buffer NULL-terminated
      net/ethernet/qlogic/qed: force the string buffer NULL-terminated

Weitao Hou (1):
      can: mcp251x: add error check when wq alloc failed

Wen Yang (1):
      can: flexcan: fix an use-after-free in flexcan_setup_stop_mode()

Wenwen Wang (1):
      netfilter: ebtables: fix a memory leak bug in compat

Yamin Friedman (1):
      linux/dim: Fix overflow in dim calculation

Yonglong Liu (1):
      net: hns: fix LED configuration for marvell phy

YueHaibing (3):
      can: gw: Fix error path of cgw_module_init
      enetc: Fix build error without PHYLIB
      enetc: Select PHYLIB while CONFIG_FSL_ENETC_VF is set

xiaofeis (1):
      net: dsa: qca8k: enable port flow control

 Documentation/networking/tls-offload.rst                      |  23 +++-
 MAINTAINERS                                                   |  10 +-
 drivers/atm/iphase.c                                          |   8 +-
 drivers/isdn/hardware/mISDN/hfcsusb.c                         |  13 +-
 drivers/net/arcnet/arc-rimi.c                                 |   3 +
 drivers/net/arcnet/com20020-isa.c                             |   6 +
 drivers/net/arcnet/com90io.c                                  |   2 +
 drivers/net/arcnet/com90xx.c                                  |   3 +
 drivers/net/bonding/bond_main.c                               |   9 ++
 drivers/net/can/dev.c                                         |   2 +
 drivers/net/can/flexcan.c                                     |  39 ++++--
 drivers/net/can/rcar/rcar_canfd.c                             |   9 +-
 drivers/net/can/sja1000/peak_pcmcia.c                         |   2 +-
 drivers/net/can/spi/mcp251x.c                                 |  49 ++++----
 drivers/net/can/usb/peak_usb/pcan_usb_core.c                  |  10 +-
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c                    |   2 +-
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c                   |   2 +-
 drivers/net/dsa/mv88e6xxx/chip.c                              |  29 +----
 drivers/net/dsa/qca8k.c                                       |  10 +-
 drivers/net/dsa/sja1105/sja1105_dynamic_config.c              |  14 ++-
 drivers/net/dsa/sja1105/sja1105_main.c                        | 143 +++++++++------------
 drivers/net/dsa/sja1105/sja1105_ptp.c                         |   7 +-
 drivers/net/ethernet/8390/Kconfig                             |   4 +-
 drivers/net/ethernet/agere/et131x.c                           |   2 +-
 drivers/net/ethernet/allwinner/sun4i-emac.c                   |   4 +-
 drivers/net/ethernet/amd/Kconfig                              |   2 +-
 drivers/net/ethernet/apple/Kconfig                            |   4 +-
 drivers/net/ethernet/atheros/ag71xx.c                         |   2 +-
 drivers/net/ethernet/broadcom/Kconfig                         |   6 +-
 drivers/net/ethernet/broadcom/bcmsysport.c                    |   2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c               |   3 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                     |   2 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c                |   2 +-
 drivers/net/ethernet/cavium/thunder/thunder_bgx.c             |  18 +--
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c               |   5 +-
 drivers/net/ethernet/emulex/benet/be_cmds.c                   |   6 +-
 drivers/net/ethernet/emulex/benet/be_main.c                   |   2 -
 drivers/net/ethernet/freescale/enetc/Kconfig                  |   2 +
 drivers/net/ethernet/freescale/fman/fman.c                    |   3 -
 drivers/net/ethernet/google/gve/gve.h                         |   8 +-
 drivers/net/ethernet/google/gve/gve_ethtool.c                 |   4 +-
 drivers/net/ethernet/google/gve/gve_rx.c                      |  34 +++--
 drivers/net/ethernet/hisilicon/hip04_eth.c                    |  28 +++--
 drivers/net/ethernet/ibm/ehea/ehea_main.c                     |   2 +-
 drivers/net/ethernet/marvell/mvmdio.c                         |  31 +++--
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c               |  87 ++++++-------
 drivers/net/ethernet/marvell/sky2.c                           |   7 ++
 drivers/net/ethernet/mediatek/Kconfig                         |   1 -
 drivers/net/ethernet/mellanox/mlx5/core/dev.c                 |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h                  |  12 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/params.h           |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/port.c             |  27 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en/port.h             |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c    |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c          |  69 +++++++----
 drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c       |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c             |  41 +++----
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c              |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c            |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c               |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c             |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h             |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c         |   5 +
 drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c         |   7 +-
 drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c    |   1 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c                |   2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h                |   4 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c        |   4 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c            |   1 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.h            |   1 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum_nve_vxlan.c      |  76 +++++++++---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c            |  17 +++
 drivers/net/ethernet/mscc/ocelot.c                            |   1 +
 drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c          |   4 +-
 drivers/net/ethernet/ni/Kconfig                               |   2 +-
 drivers/net/ethernet/packetengines/Kconfig                    |   6 +-
 drivers/net/ethernet/packetengines/Makefile                   |   2 +-
 drivers/net/ethernet/qlogic/qed/qed_int.c                     |   2 +-
 drivers/net/ethernet/qlogic/qed/qed_rdma.c                    |   2 +-
 drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c          |  13 +-
 drivers/net/ethernet/realtek/r8169_main.c                     |  14 ++-
 drivers/net/ethernet/rocker/rocker_main.c                     |   2 +
 drivers/net/ethernet/samsung/Kconfig                          |   2 +-
 drivers/net/ethernet/smsc/smc911x.c                           |   1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c             |   4 +
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h                |   7 +-
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c           |  87 +++++++++++--
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c             |  50 ++++----
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c         |   7 ++
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c               |   2 +-
 drivers/net/ethernet/toshiba/spider_net.c                     |   1 +
 drivers/net/ethernet/xscale/Kconfig                           |   2 +-
 drivers/net/hamradio/baycom_epp.c                             |   3 +-
 drivers/net/phy/fixed_phy.c                                   |   6 +-
 drivers/net/phy/mscc.c                                        |  16 +--
 drivers/net/phy/phy_device.c                                  |   6 +
 drivers/net/phy/phy_led_triggers.c                            |   3 +-
 drivers/net/phy/phylink.c                                     |  10 +-
 drivers/net/ppp/pppoe.c                                       |   3 +
 drivers/net/ppp/pppox.c                                       |  13 ++
 drivers/net/ppp/pptp.c                                        |   3 +
 drivers/net/tun.c                                             |   9 +-
 drivers/net/usb/pegasus.c                                     |   2 +-
 drivers/net/usb/qmi_wwan.c                                    |   1 +
 drivers/net/usb/r8152.c                                       |  12 +-
 drivers/net/wan/sdla.c                                        |   1 +
 drivers/net/wireless/intel/iwlwifi/fw/api/rx.h                |   3 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c                   |  22 ++--
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c                  |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c                   |  29 +++--
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c             |  58 ++++++---
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h                  |   8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c                  |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c                  |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c                   | 539 +++++++++++++++++++++++++++++++++++++++++++-------------------------------------
 drivers/net/wireless/intel/iwlwifi/mvm/rs.h                   |   3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c                 | 185 ++++++++++++++++++++--------
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c                  |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h                  |  12 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c                   |   3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c                |   4 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c                 |   3 +
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c                  |   2 +
 drivers/net/wireless/mac80211_hwsim.c                         |   8 +-
 drivers/net/wireless/marvell/mwifiex/main.h                   |   1 +
 drivers/net/wireless/marvell/mwifiex/scan.c                   |   3 +-
 drivers/nfc/nfcmrvl/main.c                                    |   4 +-
 drivers/nfc/nfcmrvl/uart.c                                    |   4 +-
 drivers/nfc/nfcmrvl/usb.c                                     |   1 +
 drivers/nfc/st-nci/se.c                                       |   2 +
 drivers/nfc/st21nfca/se.c                                     |   2 +
 fs/compat_ioctl.c                                             |   3 -
 include/linux/dim.h                                           |  56 ---------
 include/linux/filter.h                                        |  13 ++
 include/linux/if_pppox.h                                      |   3 +
 include/linux/if_rmnet.h                                      |   4 +-
 include/linux/mlx5/fs.h                                       |   1 +
 include/linux/mlx5/mlx5_ifc.h                                 |   6 +-
 include/linux/skmsg.h                                         |   8 +-
 include/net/cfg80211.h                                        |  15 +++
 include/net/tc_act/tc_police.h                                |   4 +-
 include/net/tc_act/tc_sample.h                                |   2 +-
 include/net/tcp.h                                             |   3 +
 include/net/tls.h                                             |  13 +-
 include/uapi/linux/netfilter/xt_connlabel.h                   |   6 +
 include/uapi/linux/socket.h                                   |  19 ++-
 kernel/bpf/verifier.c                                         |   4 +-
 lib/dim/dim.c                                                 |   4 +-
 lib/dim/net_dim.c                                             |  56 +++++++++
 net/bridge/br.c                                               |   5 +-
 net/bridge/br_multicast.c                                     |   3 +
 net/bridge/br_private.h                                       |   9 +-
 net/bridge/br_vlan.c                                          |  29 +++--
 net/bridge/netfilter/ebtables.c                               |  32 +++--
 net/bridge/netfilter/nft_meta_bridge.c                        |  10 +-
 net/can/gw.c                                                  |  48 +++++---
 net/core/dev.c                                                |  17 ++-
 net/core/filter.c                                             |   6 +-
 net/core/skmsg.c                                              |   4 +-
 net/core/sock_map.c                                           |  19 ++-
 net/dsa/tag_sja1105.c                                         |  12 +-
 net/ipv4/inet_fragment.c                                      |   2 +-
 net/ipv4/ipip.c                                               |   3 +
 net/ipv4/tcp_ulp.c                                            |  13 ++
 net/ipv6/ip6_gre.c                                            |   3 +-
 net/ipv6/ip6_tunnel.c                                         |   6 +-
 net/ipv6/route.c                                              |   2 +-
 net/iucv/af_iucv.c                                            |  14 ++-
 net/l2tp/l2tp_ppp.c                                           |   3 +
 net/mac80211/iface.c                                          |   1 -
 net/mac80211/mlme.c                                           |  10 ++
 net/mac80211/util.c                                           |   7 +-
 net/netfilter/ipset/ip_set_bitmap_ipmac.c                     |   2 +-
 net/netfilter/ipset/ip_set_core.c                             |   2 +-
 net/netfilter/ipset/ip_set_hash_ipmac.c                       |   6 +-
 net/netfilter/nft_meta.c                                      |  16 +--
 net/netrom/af_netrom.c                                        |   1 +
 net/openvswitch/datapath.c                                    |  15 +--
 net/rds/rdma_transport.c                                      |   5 +-
 net/rxrpc/ar-internal.h                                       |   1 +
 net/rxrpc/peer_event.c                                        |   2 +-
 net/rxrpc/peer_object.c                                       |  18 +++
 net/rxrpc/sendmsg.c                                           |   1 +
 net/sched/act_bpf.c                                           |   9 +-
 net/sched/act_connmark.c                                      |   9 +-
 net/sched/act_csum.c                                          |   9 +-
 net/sched/act_ct.c                                            |   9 +-
 net/sched/act_ctinfo.c                                        |   9 +-
 net/sched/act_gact.c                                          |   8 +-
 net/sched/act_ife.c                                           |  13 +-
 net/sched/act_mirred.c                                        |  13 +-
 net/sched/act_mpls.c                                          |   8 +-
 net/sched/act_nat.c                                           |   9 +-
 net/sched/act_pedit.c                                         |  10 +-
 net/sched/act_police.c                                        |   8 +-
 net/sched/act_sample.c                                        |  10 +-
 net/sched/act_simple.c                                        |  10 +-
 net/sched/act_skbedit.c                                       |  11 +-
 net/sched/act_skbmod.c                                        |  11 +-
 net/sched/act_tunnel_key.c                                    |   8 +-
 net/sched/act_vlan.c                                          |  25 ++--
 net/sched/sch_codel.c                                         |   6 +-
 net/sctp/socket.c                                             |   4 +-
 net/smc/af_smc.c                                              |  15 ++-
 net/tipc/netlink_compat.c                                     |  11 +-
 net/tipc/socket.c                                             |   3 +-
 net/tls/tls_main.c                                            |  97 +++++++++------
 net/tls/tls_sw.c                                              |  83 +++++++++----
 net/vmw_vsock/hyperv_transport.c                              |   8 ++
 net/wireless/core.c                                           |   6 +-
 net/wireless/nl80211.c                                        |   4 +-
 net/wireless/util.c                                           |  27 +++-
 tools/lib/bpf/btf.c                                           |   5 +-
 tools/lib/bpf/libbpf.c                                        |  34 +++--
 tools/lib/bpf/xsk.c                                           |  11 +-
 tools/testing/selftests/bpf/Makefile                          |   3 +-
 tools/testing/selftests/bpf/progs/sendmsg6_prog.c             |   3 +-
 tools/testing/selftests/bpf/test_xdp_vlan.sh                  |  57 +++++++--
 tools/testing/selftests/bpf/test_xdp_vlan_mode_generic.sh     |   9 ++
 tools/testing/selftests/bpf/test_xdp_vlan_mode_native.sh      |   9 ++
 tools/testing/selftests/bpf/verifier/ctx_skb.c                |  11 ++
 tools/testing/selftests/net/.gitignore                        |   4 +-
 tools/testing/selftests/net/forwarding/gre_multipath.sh       |  28 +++--
 tools/testing/selftests/net/tls.c                             | 223 +++++++++++++++++++++++++++++++++
 tools/testing/selftests/tc-testing/tc-tests/actions/vlan.json |  94 ++++++++++++++
 225 files changed, 2402 insertions(+), 1274 deletions(-)
 create mode 100755 tools/testing/selftests/bpf/test_xdp_vlan_mode_generic.sh
 create mode 100755 tools/testing/selftests/bpf/test_xdp_vlan_mode_native.sh
