Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3318135A878
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 23:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234764AbhDIVsT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 17:48:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:42310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234079AbhDIVsT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 17:48:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16B5D61007;
        Fri,  9 Apr 2021 21:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618004885;
        bh=Pg38BvQvp3jAvZbNRu4KQbOhLk9b2G/I92GDWMH3ZOI=;
        h=From:To:Cc:Subject:Date:From;
        b=N7VlvcPJf+gclVPs0KqRmLxHw7k7Z2zk5CH4bSo7ogGrrnPYU2jt4bjs0rf+YVyM3
         OjkH6/Zs9E1RmAxYMF41ccOGI/gtPNlOVQuWHwNG6k49Up0eZPNvNEsYn71KVz+oCR
         bwHY97Ed2h8o9nLfAJR6gWtlSTV+HFsJo8ztmukmQZizxyxEw13l7NkSViQS3xZHUR
         IUfGQAKjUR6nxNz4vremNKdA/MVaCyVKQRKIsWkBYGFyNvZ++lD/54tK/zf976ofyW
         3Kvqet4dkfcRMh3QMG6BxV+QcnOR+VUnInP2sluqH9EzH6UYrUuxOnxs+qreVevTz3
         ejWCJ56expaRg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 5.12-rc7
Date:   Fri,  9 Apr 2021 14:48:03 -0700
Message-Id: <20210409214803.1618792-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit 002322402dafd846c424ffa9240a937f49b48c42:

  Merge branch 'akpm' (patches from Andrew) (2021-03-25 11:43:43 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.12-rc7

for you to fetch changes up to 27f0ad71699de41bae013c367b95a6b319cc46a9:

  net: fix hangup on napi_disable for threaded napi (2021-04-09 12:50:31 -0700)

----------------------------------------------------------------
Networking fixes for 5.12-rc7, including fixes from can, ipsec,
mac80211, wireless, and bpf trees. No scary regressions here
or in the works, but small fixes for 5.12 changes keep coming.

Current release - regressions:

 - virtio: do not pull payload in skb->head

 - virtio: ensure mac header is set in virtio_net_hdr_to_skb()

 - Revert "net: correct sk_acceptq_is_full()"

 - mptcp: revert "mptcp: provide subflow aware release function"

 - ethernet: lan743x: fix ethernet frame cutoff issue

 - dsa: fix type was not set for devlink port

 - ethtool: remove link_mode param and derive link params
            from driver

 - sched: htb: fix null pointer dereference on a null new_q

 - wireless: iwlwifi: Fix softirq/hardirq disabling in
                      iwl_pcie_enqueue_hcmd()

 - wireless: iwlwifi: fw: fix notification wait locking

 - wireless: brcmfmac: p2p: Fix deadlock introduced by avoiding
                            the rtnl dependency

Current release - new code bugs:

 - napi: fix hangup on napi_disable for threaded napi

 - bpf: take module reference for trampoline in module

 - wireless: mt76: mt7921: fix airtime reporting and related
                           tx hangs

 - wireless: iwlwifi: mvm: rfi: don't lock mvm->mutex when sending
                                config command

Previous releases - regressions:

 - rfkill: revert back to old userspace API by default

 - nfc: fix infinite loop, refcount & memory leaks in LLCP sockets

 - let skb_orphan_partial wake-up waiters

 - xfrm/compat: Cleanup WARN()s that can be user-triggered

 - vxlan, geneve: do not modify the shared tunnel info when PMTU
                  triggers an ICMP reply

 - can: fix msg_namelen values depending on CAN_REQUIRED_SIZE

 - can: uapi: mark union inside struct can_frame packed

 - sched: cls: fix action overwrite reference counting

 - sched: cls: fix err handler in tcf_action_init()

 - ethernet: mlxsw: fix ECN marking in tunnel decapsulation

 - ethernet: nfp: Fix a use after free in nfp_bpf_ctrl_msg_rx

 - ethernet: i40e: fix receiving of single packets in xsk zero-copy
                   mode

 - ethernet: cxgb4: avoid collecting SGE_QBASE regs during traffic

Previous releases - always broken:

 - bpf: Refuse non-O_RDWR flags in BPF_OBJ_GET

 - bpf: Refcount task stack in bpf_get_task_stack

 - bpf, x86: Validate computation of branch displacements

 - ieee802154: fix many similar syzbot-found bugs
    - fix NULL dereferences in netlink attribute handling
    - reject unsupported operations on monitor interfaces
    - fix error handling in llsec_key_alloc()

 - xfrm: make ipv4 pmtu check honor ip header df

 - xfrm: make hash generation lock per network namespace

 - xfrm: esp: delete NETIF_F_SCTP_CRC bit from features for esp
              offload

 - ethtool: fix incorrect datatype in set_eee ops

 - xdp: fix xdp_return_frame() kernel BUG throw for page_pool
        memory model

 - openvswitch: fix send of uninitialized stack memory in ct limit
                reply

Misc:

 - udp: add get handling for UDP_GRO sockopt

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
A. Cody Schuffelen (1):
      virt_wifi: Return micros for BSS TSF values

Aditya Pakki (1):
      net/rds: Avoid potential use after free in rds_send_remove_from_sock

Ahmed S. Darwish (2):
      net: xfrm: Localize sequence counter per network namespace
      net: xfrm: Use sequence counter with associated spinlock

Alex Shi (1):
      net/ieee802154: remove unused macros to tame gcc

Alexander Aring (19):
      net: ieee802154: fix nl802154 del llsec key
      net: ieee802154: fix nl802154 del llsec dev
      net: ieee802154: fix nl802154 add llsec key
      net: ieee802154: fix nl802154 del llsec devkey
      net: ieee802154: nl-mac: fix check on panid
      net: ieee802154: forbid monitor for set llsec params
      net: ieee802154: stop dump llsec keys for monitors
      net: ieee802154: forbid monitor for add llsec key
      net: ieee802154: forbid monitor for del llsec key
      net: ieee802154: stop dump llsec devs for monitors
      net: ieee802154: forbid monitor for add llsec dev
      net: ieee802154: forbid monitor for del llsec dev
      net: ieee802154: stop dump llsec devkeys for monitors
      net: ieee802154: forbid monitor for add llsec devkey
      net: ieee802154: forbid monitor for del llsec devkey
      net: ieee802154: stop dump llsec seclevels for monitors
      net: ieee802154: forbid monitor for add llsec seclevel
      net: ieee802154: forbid monitor for del llsec seclevel
      net: ieee802154: stop dump llsec params for monitors

Alexei Starovoitov (1):
      Merge branch 'AF_XDP Socket Creation Fixes'

Anirudh Rayabharam (1):
      net: hso: fix null-ptr-deref during tty device unregistration

Anirudh Venkataramanan (2):
      ice: Continue probe on link/PHY errors
      ice: Use port number instead of PF ID for WoL

Antoine Tenart (2):
      vxlan: do not modify the shared tunnel info when PMTU triggers an ICMP reply
      geneve: do not modify the shared tunnel info when PMTU triggers an ICMP reply

Ariel Levkovich (1):
      net/mlx5e: Fix mapping of ct_label zero

Arkadiusz Kubalewski (6):
      i40e: Fix oops at i40e_rebuild()
      i40e: Fix inconsistent indenting
      i40e: Fix sparse errors in i40e_txrx.c
      i40e: Fix sparse error: uninitialized symbol 'ring'
      i40e: Fix sparse error: 'vsi->netdev' could be null
      i40e: Fix sparse warning: missing error code 'err'

Aya Levin (3):
      net/mlx5e: Fix ethtool indication of connector type
      net/mlx5: Fix PPLM register mapping
      net/mlx5: Fix PBMC register mapping

Ben Greear (1):
      mac80211: fix time-is-after bug in mlme

Bruce Allan (1):
      ice: fix memory allocation call

Chinh T Cao (1):
      ice: Recognize 860 as iSCSI port in CEE mode

Ciara Loftus (3):
      libbpf: Ensure umem pointer is non-NULL before dereferencing
      libbpf: Restore umem state after socket create failure
      libbpf: Only create rx and tx XDP rings when necessary

Claudiu Beznea (1):
      net: macb: restore cmp registers on resume path

Claudiu Manoil (1):
      gianfar: Handle error code at MAC address change

Daniel Jurgens (1):
      net/mlx5: Don't request more than supported EQs

Daniel Mack (1):
      net: axienet: allow setups without MDIO

Danielle Ratson (2):
      ethtool: Remove link_mode param and derive link params from driver
      ethtool: Add lanes parameter for ETHTOOL_LINK_MODE_10000baseR_FEC_BIT

Dave Ertman (1):
      ice: remove DCBNL_DEVRESET bit from PF state

Dave Marchevsky (1):
      bpf: Refcount task stack in bpf_get_task_stack

David S. Miller (23):
      Merge branch 'nfc-fixes'
      Merge branch 'tunnel-shinfo'
      Merge branch '40GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      Merge branch 'mlxsw-ecn-marking'
      Merge tag 'linux-can-fixes-for-5.12-20210329' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec
      Merge tag 'mlx5-fixes-2021-03-31' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge branch 'mptcp-deadlock'
      Merge branch '40GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf
      Merge branch 'hns3-fixes'
      Merge tag 'linux-can-fixes-for-5.12-20210406' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can
      Merge branch 'ethtool-doc'
      Merge tag 'mlx5-fixes-2021-04-06' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge branch 'ethtool-link_mode'
      Merge tag 'wireless-drivers-2021-04-07' of git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers
      Merge tag 'ieee802154-for-davem-2021-04-07' of git://git.kernel.org/pub/scm/linux/kernel/git/sschmidt/wpan
      Merge branch 'net-sched-action-init-fixes'
      Merge tag 'mac80211-for-net-2021-04-08.2' of git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf
      Merge branch '40GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      Merge branch 'lantiq-GSWIP-fixes'

Dima Chumak (1):
      net/mlx5e: Consider geneve_opts for encap contexts

Dinh Nguyen (1):
      dt-bindings: net: micrel-ksz90x1.txt: correct documentation

Dmitry Safonov (1):
      xfrm/compat: Cleanup WARN()s that can be user-triggered

Du Cheng (1):
      cfg80211: remove WARN_ON() in cfg80211_sme_connect

Eli Cohen (1):
      net/mlx5: Fix HW spec violation configuring uplink

Eric Dumazet (4):
      sch_red: fix off-by-one checks in red_check_params()
      net: ensure mac header is set in virtio_net_hdr_to_skb()
      Revert "net: correct sk_acceptq_is_full()"
      virtio_net: Do not pull payload in skb->head

Eryk Rybak (2):
      i40e: Fix kernel oops when i40e driver removes VF's
      i40e: Fix display statistics for veb_tc

Evan Nimmo (1):
      xfrm: Use actual socket sk instead of skb socket for xfrm_output_resume

Eyal Birger (3):
      xfrm: interface: fix ipv4 pmtu check to honor ip header df
      vti: fix ipv4 pmtu check to honor ip header df
      vti6: fix ipv4 pmtu check to honor ip header df

Fabio Pricoco (1):
      ice: Increase control queue timeout

Florian Fainelli (1):
      net: phy: broadcom: Only advertise EEE for supported modes

Gregory Greenman (1):
      iwlwifi: mvm: rfi: don't lock mvm->mutex when sending config command

Grzegorz Siwik (1):
      i40e: Fix parameters in aq_get_phy_register()

Guangbin Huang (1):
      net: hns3: clear VF down state bit before request link status

Guenter Roeck (1):
      pcnet32: Use pci_resource_len to validate PCI resource

Hans de Goede (1):
      brcmfmac: p2p: Fix recently introduced deadlock issue

Ido Schimmel (2):
      mlxsw: spectrum: Fix ECN marking in tunnel decapsulation
      selftests: forwarding: vxlan_bridge_1d: Add more ECN decap test cases

Ilya Maximets (1):
      openvswitch: fix send of uninitialized stack memory in ct limit reply

Jacek Bułatek (1):
      ice: Fix for dereference of NULL pointer

Jakub Kicinski (4):
      docs: ethtool: fix some copy-paste errors
      ethtool: un-kdocify extended link state
      ethtool: document reserved fields in the uAPI
      ethtool: fix kdoc in headers

Jiri Kosina (1):
      iwlwifi: Fix softirq/hardirq disabling in iwl_pcie_enqueue_hcmd()

Jiri Olsa (1):
      bpf: Take module reference for trampoline in module

Johannes Berg (8):
      iwlwifi: pcie: properly set LTR workarounds on 22000 devices
      iwlwifi: fw: fix notification wait locking
      iwlwifi: mvm: fix beacon protection checks
      rfkill: revert back to old userspace API by default
      mac80211: fix TXQ AC confusion
      cfg80211: check S1G beacon compat element length
      nl80211: fix potential leak of ACL params
      nl80211: fix beacon head validation

John Fastabend (2):
      bpf, sockmap: Fix sk->prot unhash op reset
      bpf, sockmap: Fix incorrect fwd_alloc accounting

Krzysztof Goreczny (1):
      ice: prevent ice_open and ice_stop during reset

Kumar Kartikeya Dwivedi (1):
      net: sched: bump refcount for new action in ACT replace mode

Kurt Kanzenbach (1):
      net: hsr: Reset MAC header for Tx path

Loic Poulain (1):
      net: qrtr: Fix memory leak on qrtr_tx_wait failure

Lorenz Bauer (2):
      bpf: link: Refuse non-O_RDWR flags in BPF_OBJ_GET
      bpf: program: Refuse non-O_RDWR flags in BPF_OBJ_GET

Lorenzo Bianconi (1):
      mt76: mt7921: fix airtime reporting

Luca Coelho (2):
      iwlwifi: fix 11ax disabled bit in the regulatory capability flags
      iwlwifi: pcie: add support for So-F devices

Lv Yunlong (6):
      drivers/net/wan/hdlc_fr: Fix a double free in pvc_xmit
      ethernet: myri10ge: Fix a use after free in myri10ge_sw_tso
      net:tipc: Fix a double free in tipc_sk_mcast_rcv
      ethernet/netronome/nfp: Fix a use after free in nfp_bpf_ctrl_msg_rx
      net/rds: Fix a use after free in rds_message_map_pages
      net: broadcom: bcm4908enet: Fix a double free in bcm4908_enet_dma_alloc

Maciej Żenczykowski (1):
      net-ipv6: bugfix - raw & sctp - switch to ipv6_can_nonlocal_bind()

Magnus Karlsson (1):
      i40e: fix receiving of single packets in xsk zero-copy mode

Manivannan Sadhasivam (1):
      MAINTAINERS: Add entry for Qualcomm IPC Router (QRTR) driver

Maor Dickman (2):
      net/mlx5: Delete auxiliary bus driver eth-rep first
      net/mlx5: E-switch, Create vport miss group only if src rewrite is supported

Marc Kleine-Budde (2):
      can: uapi: can.h: mark union inside struct can_frame packed
      can: mcp251x: fix support for half duplex SPI host controllers

Martin Blumenstingl (3):
      net: dsa: lantiq_gswip: Let GSWIP automatically set the xMII clock
      net: dsa: lantiq_gswip: Don't use PHY auto polling
      net: dsa: lantiq_gswip: Configure all remaining GSWIP_MII_CFG bits

Mateusz Palczewski (1):
      i40e: Added Asym_Pause to supported link modes

Matt Chen (1):
      iwlwifi: add support for Qu with AX201 device

Maxim Kochetkov (1):
      net: dsa: Fix type was not set for devlink port

Milton Miller (1):
      net/ncsi: Avoid channel_monitor hrtimer deadlock

Muhammad Usama Anjum (1):
      net: ipv6: check for validity before dereferencing cfg->fc_nlinfo.nlh

Norbert Ciosek (1):
      virtchnl: Fix layout of RSS structures

Norman Maurer (1):
      net: udp: Add support for getsockopt(..., ..., UDP_GRO, ..., ...);

Oliver Hartkopp (2):
      can: bcm/raw: fix msg_namelen values depending on CAN_REQUIRED_SIZE
      can: isotp: fix msg_namelen values depending on CAN_REQUIRED_SIZE

Ong Boon Leong (1):
      xdp: fix xdp_return_frame() kernel BUG throw for page_pool memory model

Paolo Abeni (4):
      net: let skb_orphan_partial wake-up waiters.
      mptcp: forbit mcast-related sockopt on MPTCP sockets
      mptcp: revert "mptcp: provide subflow aware release function"
      net: fix hangup on napi_disable for threaded napi

Pavel Skripkin (3):
      drivers: net: fix memory leak in atusb_probe
      drivers: net: fix memory leak in peak_usb_create_dev
      net: mac802154: Fix general protection fault

Pavel Tikhomirov (1):
      net: sched: sch_teql: fix null-pointer dereference

Pedro Tammela (1):
      libbpf: Fix bail out from 'ringbuf_process_ring()' on error

Phillip Potter (1):
      net: tun: set tun->dev->addr_len during TUNSETLINK processing

Piotr Krysiuk (2):
      bpf, x86: Validate computation of branch displacements for x86-64
      bpf, x86: Validate computation of branch displacements for x86-32

Raed Salem (1):
      net/mlx5: Fix placement of log_max_flow_counter

Rafał Miłecki (2):
      dt-bindings: net: ethernet-controller: fix typo in NVMEM
      dt-bindings: net: bcm4908-enet: fix Ethernet generic properties

Rahul Lakkireddy (1):
      cxgb4: avoid collecting SGE_QBASE regs during traffic

Robert Malz (1):
      ice: Cleanup fltr list in case of allocation issues

Salil Mehta (3):
      net: hns3: Remove the left over redundant check & assignment
      net: hns3: Remove un-necessary 'else-if' in the hclge_reset_event()
      net: hns3: Trivial spell fix in hns3 driver

Seevalamuthu Mariappan (1):
      mac80211: clear sta->fast_rx when STA removed from 4-addr VLAN

Shyam Sundar S K (1):
      amd-xgbe: Update DMA coherency values

Stefan Schmidt (1):
      Merge remote-tracking branch 'net/master'

Steffen Klassert (2):
      xfrm: Fix NULL pointer dereference on policy lookup
      xfrm: Provide private skb extensions for segmented and hw offloaded ESP packets

Stephen Hemminger (1):
      ipv6: report errors for iftoken via netlink extack

Sven Van Asbroeck (1):
      lan743x: fix ethernet frame cutoff issue

Tariq Toukan (3):
      net/mlx5e: kTLS, Fix TX counters atomicity
      net/mlx5e: kTLS, Fix RX counters atomicity
      net/mlx5e: Guarantee room for XSK wakeup NOP on async ICOSQ

Tetsuo Handa (1):
      batman-adv: initialize "struct batadv_tvlv_tt_vlan_data"->reserved field

Toke Høiland-Jørgensen (2):
      bpf: Enforce that struct_ops programs be GPL-only
      bpf/selftests: Test that kernel rejects a TCP CC with an invalid license

Tong Zhu (1):
      neighbour: Disregard DEAD dst in neigh_update

Vlad Buslov (3):
      Revert "net: sched: bump refcount for new action in ACT replace mode"
      net: sched: fix action overwrite reference counting
      net: sched: fix err handler in tcf_action_init()

Vladimir Oltean (1):
      net: dsa: only unset VLAN filtering when last port leaves last VLAN-aware bridge

Wong Vee Khee (1):
      ethtool: fix incorrect datatype in set_eee ops

Xiaoming Ni (5):
      nfc: fix refcount leak in llcp_sock_bind()
      nfc: fix refcount leak in llcp_sock_connect()
      nfc: fix memory leak in llcp_sock_connect()
      nfc: Avoid endless loops caused by repeated llcp_sock_connect()
      net/mlx5: fix kfree mismatch in indir_table.c

Xin Long (3):
      esp: delete NETIF_F_SCTP_CRC bit from features for esp offload
      xfrm: BEET mode doesn't support fragments for inner packets
      tipc: increment the tmp aead refcnt before attaching it

Xu Kuohai (1):
      bpf: Fix a spelling typo in bpf_atomic_alu_string disasm

Yinjun Zhang (1):
      nfp: flower: ignore duplicate merge hints from FW

Yongxin Liu (1):
      ice: fix memory leak of aRFS after resuming from suspend

Yunjian Wang (2):
      sch_htb: fix null pointer dereference on a null new_q
      net: cls_api: Fix uninitialised struct field bo->unlocked_driver_cb

Zheng Yongjun (1):
      net: tipc: Fix spelling errors in net/tipc module

 .../devicetree/bindings/net/brcm,bcm4908-enet.yaml |   2 +-
 .../bindings/net/ethernet-controller.yaml          |   2 +-
 .../devicetree/bindings/net/micrel-ksz90x1.txt     |  96 +++++++++-
 Documentation/networking/ethtool-netlink.rst       |  10 +-
 MAINTAINERS                                        |   8 +
 arch/x86/net/bpf_jit_comp.c                        |  11 +-
 arch/x86/net/bpf_jit_comp32.c                      |  11 +-
 drivers/net/can/spi/mcp251x.c                      |  24 ++-
 drivers/net/can/usb/peak_usb/pcan_usb_core.c       |   6 +-
 drivers/net/dsa/lantiq_gswip.c                     | 195 ++++++++++++++++++---
 drivers/net/ethernet/amd/pcnet32.c                 |   5 +-
 drivers/net/ethernet/amd/xgbe/xgbe.h               |   6 +-
 drivers/net/ethernet/broadcom/bcm4908_enet.c       |   1 +
 drivers/net/ethernet/cadence/macb_main.c           |   7 +
 drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c     |  23 ++-
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c         |   3 +-
 drivers/net/ethernet/freescale/gianfar.c           |   6 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |   9 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |   8 +-
 drivers/net/ethernet/intel/i40e/i40e.h             |   1 +
 drivers/net/ethernet/intel/i40e/i40e_debugfs.c     |   3 +
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |  55 +++++-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  30 ++--
 drivers/net/ethernet/intel/i40e/i40e_txrx.c        |  12 +-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |   9 +
 drivers/net/ethernet/intel/i40e/i40e_xsk.c         |   4 +-
 drivers/net/ethernet/intel/ice/ice.h               |   4 +-
 drivers/net/ethernet/intel/ice/ice_common.c        |   2 +-
 drivers/net/ethernet/intel/ice/ice_controlq.h      |   4 +-
 drivers/net/ethernet/intel/ice/ice_dcb.c           |  38 +++-
 drivers/net/ethernet/intel/ice/ice_dcb_nl.c        |   2 -
 drivers/net/ethernet/intel/ice/ice_ethtool.c       |   4 +-
 drivers/net/ethernet/intel/ice/ice_lib.c           |   5 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |  53 ++++--
 drivers/net/ethernet/intel/ice/ice_switch.c        |  15 +-
 drivers/net/ethernet/intel/ice/ice_type.h          |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/dev.c      |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |  36 +++-
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun.h    |  10 ++
 .../ethernet/mellanox/mlx5/core/en/tc_tun_encap.c  |  23 +--
 .../ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c |  29 +++
 .../ethernet/mellanox/mlx5/core/en/tc_tun_gre.c    |   1 +
 .../mellanox/mlx5/core/en/tc_tun_mplsoudp.c        |   1 +
 .../ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c  |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  |   6 +
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c |  40 ++---
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c |   5 +-
 .../net/ethernet/mellanox/mlx5/core/en_accel/tls.h |   3 +
 .../mellanox/mlx5/core/en_accel/tls_stats.c        |  49 ++++--
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  22 +--
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  21 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |  10 --
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.h |   6 -
 drivers/net/ethernet/mellanox/mlx5/core/eq.c       |  13 +-
 .../ethernet/mellanox/mlx5/core/esw/indir_table.c  |  10 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  68 ++++---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h     |  15 ++
 .../net/ethernet/mellanox/mlxsw/spectrum_ethtool.c |  19 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_ipip.c    |   7 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c |   7 +-
 drivers/net/ethernet/microchip/lan743x_main.c      |   8 +-
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c   |   2 +-
 drivers/net/ethernet/netronome/nfp/bpf/cmsg.c      |   1 +
 drivers/net/ethernet/netronome/nfp/flower/main.h   |   8 +
 .../net/ethernet/netronome/nfp/flower/metadata.c   |  16 +-
 .../net/ethernet/netronome/nfp/flower/offload.c    |  48 ++++-
 drivers/net/ethernet/xilinx/xilinx_axienet.h       |  12 ++
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |  12 +-
 drivers/net/geneve.c                               |  24 ++-
 drivers/net/ieee802154/atusb.c                     |   1 +
 drivers/net/phy/bcm-phy-lib.c                      |  13 +-
 drivers/net/tun.c                                  |  48 +++++
 drivers/net/usb/hso.c                              |  33 ++--
 drivers/net/virtio_net.c                           |  10 +-
 drivers/net/vxlan.c                                |  18 +-
 drivers/net/wan/hdlc_fr.c                          |   5 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.c |   2 +-
 drivers/net/wireless/intel/iwlwifi/fw/notif-wait.c |  10 +-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |   1 +
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   |   7 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rfi.c       |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |  17 +-
 .../wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c   |  31 +---
 .../net/wireless/intel/iwlwifi/pcie/ctxt-info.c    |   3 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |  27 ++-
 .../net/wireless/intel/iwlwifi/pcie/trans-gen2.c   |  35 ++++
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       |   7 +-
 drivers/net/wireless/mediatek/mt76/mt7921/regs.h   |   4 +-
 drivers/net/wireless/virt_wifi.c                   |   5 +-
 include/linux/avf/virtchnl.h                       |   2 -
 include/linux/bpf.h                                |   2 +
 include/linux/ethtool.h                            |  22 ++-
 include/linux/mlx5/mlx5_ifc.h                      |  10 +-
 include/linux/skmsg.h                              |   7 +-
 include/linux/virtio_net.h                         |  16 +-
 include/net/act_api.h                              |  12 +-
 include/net/netns/xfrm.h                           |   4 +-
 include/net/red.h                                  |   4 +-
 include/net/rtnetlink.h                            |   4 +-
 include/net/sock.h                                 |  15 +-
 include/net/xfrm.h                                 |   4 +-
 include/uapi/linux/can.h                           |   2 +-
 include/uapi/linux/ethtool.h                       |  54 +++---
 include/uapi/linux/rfkill.h                        |  80 +++++++--
 kernel/bpf/disasm.c                                |   2 +-
 kernel/bpf/inode.c                                 |   4 +-
 kernel/bpf/stackmap.c                              |  12 +-
 kernel/bpf/trampoline.c                            |  30 ++++
 kernel/bpf/verifier.c                              |   5 +
 net/batman-adv/translation-table.c                 |   2 +
 net/can/bcm.c                                      |  10 +-
 net/can/isotp.c                                    |  11 +-
 net/can/raw.c                                      |  14 +-
 net/core/dev.c                                     |   3 +-
 net/core/neighbour.c                               |   2 +-
 net/core/rtnetlink.c                               |   2 +-
 net/core/skmsg.c                                   |  12 +-
 net/core/sock.c                                    |  12 +-
 net/core/xdp.c                                     |   3 +-
 net/dsa/dsa2.c                                     |   8 +-
 net/dsa/switch.c                                   |  15 +-
 net/ethtool/common.c                               |  17 ++
 net/ethtool/eee.c                                  |   4 +-
 net/ethtool/ioctl.c                                |  18 +-
 net/hsr/hsr_device.c                               |   1 +
 net/hsr/hsr_forward.c                              |   6 -
 net/ieee802154/nl-mac.c                            |   7 +-
 net/ieee802154/nl802154.c                          |  68 ++++++-
 net/ipv4/ah4.c                                     |   2 +-
 net/ipv4/devinet.c                                 |   3 +-
 net/ipv4/esp4.c                                    |   2 +-
 net/ipv4/esp4_offload.c                            |  17 +-
 net/ipv4/ip_vti.c                                  |   6 +-
 net/ipv4/udp.c                                     |   4 +
 net/ipv6/addrconf.c                                |  32 +++-
 net/ipv6/ah6.c                                     |   2 +-
 net/ipv6/esp6.c                                    |   2 +-
 net/ipv6/esp6_offload.c                            |  17 +-
 net/ipv6/ip6_vti.c                                 |   6 +-
 net/ipv6/raw.c                                     |   2 +-
 net/ipv6/route.c                                   |   8 +-
 net/mac80211/cfg.c                                 |   4 +-
 net/mac80211/mlme.c                                |   5 +-
 net/mac80211/tx.c                                  |   2 +-
 net/mac802154/llsec.c                              |   2 +-
 net/mptcp/protocol.c                               | 100 +++++------
 net/ncsi/ncsi-manage.c                             |  20 ++-
 net/nfc/llcp_sock.c                                |  10 ++
 net/openvswitch/conntrack.c                        |   8 +-
 net/qrtr/qrtr.c                                    |   5 +-
 net/rds/message.c                                  |   4 +-
 net/rds/send.c                                     |   2 +-
 net/rfkill/core.c                                  |   7 +-
 net/sched/act_api.c                                |  48 +++--
 net/sched/cls_api.c                                |  16 +-
 net/sched/sch_htb.c                                |   5 +-
 net/sched/sch_teql.c                               |   3 +
 net/sctp/ipv6.c                                    |   7 +-
 net/tipc/bearer.h                                  |   6 +-
 net/tipc/crypto.c                                  |   3 +-
 net/tipc/net.c                                     |   2 +-
 net/tipc/node.c                                    |   2 +-
 net/tipc/socket.c                                  |   2 +-
 net/wireless/nl80211.c                             |  10 +-
 net/wireless/scan.c                                |  14 +-
 net/wireless/sme.c                                 |   2 +-
 net/xfrm/xfrm_compat.c                             |  12 +-
 net/xfrm/xfrm_device.c                             |   2 -
 net/xfrm/xfrm_interface.c                          |   3 +
 net/xfrm/xfrm_output.c                             |  23 ++-
 net/xfrm/xfrm_state.c                              |  11 +-
 tools/lib/bpf/ringbuf.c                            |   2 +-
 tools/lib/bpf/xsk.c                                |  57 +++---
 .../testing/selftests/bpf/prog_tests/bpf_tcp_ca.c  |  44 +++++
 tools/testing/selftests/bpf/progs/bpf_tcp_nogpl.c  |  19 ++
 .../selftests/net/forwarding/vxlan_bridge_1d.sh    |  13 +-
 179 files changed, 1872 insertions(+), 715 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_tcp_nogpl.c
