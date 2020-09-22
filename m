Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D13B5273828
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 03:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728911AbgIVBor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 21:44:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:37504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728497AbgIVBor (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 21:44:47 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD0E4239D3;
        Tue, 22 Sep 2020 01:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600739086;
        bh=FJlNqxbFXu91ghXkhhiUk5fCK5tYAI5Ncz3I2BjtJdE=;
        h=Date:From:To:Cc:Subject:From;
        b=ivokwf3xcfAimiZoZKhMT+z+Wm78/X1PaBkOpFZDQlNYP7sDifzTBWfRGh4bO7h9B
         fSAvD9olPs7Fqv7Ks5FBnsQcJ2AKm2PHeImATPWp3xwXfrKSbev020hyXdoWbGISSl
         NT+PHsY7uHw0ZBAfJKe6JLKI18v0Nj9ENTxlm2nk=
Date:   Mon, 21 Sep 2020 18:44:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
Message-ID: <20200921184443.72952cb4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

Here are the latest updates from the networking tree:

Ido fixes failure to add bond interfaces to a bridge, the offload-handling
code was too defensive there and recent refactoring unearthed that.
Users complained.

Wei fixes unnecessarily reflecting ECN bits within TOS values /
QoS marking in TCP ACK and reset packets.

Yonghong fixes a deadlock with bpf iterator. Hopefully we're in
the clear on this front now...

In other BPF fixes Daniel fixes clobbering r2 in bpf_gen_ld_abs.

Felix fixes AQL on mt76 devices with FW rate control and adds a couple
of AQL issues in mac80211 code.

Maximilian fixes authentication issue with mwifiex.

In another WiFi connectivity fix Mauro reverts IGTK support in ti/wlcore.

David Ahern fixes exception handling for multipath routes via same
device.

Taehee reverts back to a BH spin lock flavor for nsid_lock after
discovering paths which do require the BH context protection.

Hauke fixes interrupt / queue / NAPI handling in the lantiq driver.

Cong fixes ife module load deadlock.

Michal makes an adjustment to netlink reply message type for code added
in this release (the sole change touching uAPI here).

Number of fixes from Vladimir for small NXP and Microchip switches.


The following changes since commit c70672d8d316ebd46ea447effadfe57ab7a30a50:

  Merge tag 's390-5.9-5' of git://git.kernel.org/pub/scm/linux/kernel/git/s=
390/linux (2020-09-04 13:46:33 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git=20

for you to fetch changes up to b334ec66d4554a0af0471b1f21c477575c8c175d:

  Merge branch 'Fix-broken-tc-flower-rules-for-mscc_ocelot-switches' (2020-=
09-21 17:40:53 -0700)

----------------------------------------------------------------
Alaa Hleihel (1):
      net/mlx5e: Fix using wrong stats_grps in mlx5e_update_ndo_stats()

Alexei Starovoitov (1):
      Merge branch 'hashmap_iter_bucket_lock_fix'

Aloka Dixit (1):
      mac80211: Fix radiotap header channel flag for 6GHz band

Andres Beltran (1):
      hv_netvsc: Add validation for untrusted Hyper-V values

Andrii Nakryiko (2):
      docs/bpf: Fix ringbuf documentation
      docs/bpf: Remove source code links

Bj=C3=B6rn T=C3=B6pel (1):
      xsk: Fix number of pinned pages/umem size discrepancy

Brian Vazquez (1):
      fib: fix fib_rule_ops indirect call wrappers when CONFIG_IPV6=3Dm

Claudiu Manoil (1):
      enetc: Fix mdio bus removal on PF probe bailout

Colin Ian King (1):
      rhashtable: fix indentation of a continue statement

Cong Wang (1):
      act_ife: load meta modules before tcf_idr_check_alloc()

Cristobal Forno (1):
      MAINTAINERS: Update ibmveth maintainer

Dan Carpenter (2):
      hdlc_ppp: add range checks in ppp_cp_parse_cr()
      sfc: Fix error code in probe

Daniel Borkmann (1):
      bpf: Fix clobbering of r2 in bpf_gen_ld_abs

Dany Madden (1):
      ibmvnic: update MAINTAINERS

David Ahern (2):
      ipv4: Initialize flowi4_multipath_hash in data path
      ipv4: Update exception handling for multipath routes via same device

David S. Miller (20):
      Merge git://git.kernel.org/.../pablo/nf
      Merge tag 'ieee802154-for-davem-2020-09-08' of git://git.kernel.org/.=
../sschmidt/wpan
      Merge branch 'net-skb_put_padto-fixes'
      Merge branch 'wireguard-fixes'
      Merge tag 'wireless-drivers-2020-09-09' of git://git.kernel.org/.../k=
valo/wireless-drivers
      Merge branch 'net-qed-disable-aRFS-in-NPAR-and-100G'
      connector: Move maintainence under networking drivers umbrella.
      Merge branch 'mptcp-fix-subflow-s-local_id-remote_id-issues'
      Merge branch 'net-Fix-bridge-enslavement-failure'
      Merge branch '40GbE' of git://git.kernel.org/.../jkirsher/net-queue
      Merge branch 'net-lantiq-Fix-bugs-in-NAPI-handling'
      Merge branch 'net-improve-vxlan-option-process-in-net_sched-and-lwtun=
nel'
      Merge git://git.kernel.org/.../bpf/bpf
      Merge branch 'net-phy-Unbind-fixes'
      Merge branch 'Bugfixes-in-Microsemi-Ocelot-switch-driver'
      Merge tag 'batadv-net-for-davem-20200918' of git://git.open-mesh.org/=
linux-merge
      Merge branch 'bnxt_en-Bug-fixes'
      Merge tag 'mac80211-for-net-2020-09-21' of git://git.kernel.org/.../j=
berg/mac80211
      Merge tag 'mlx5-fixes-2020-09-18' of git://git.kernel.org/.../saeed/l=
inux
      Merge branch 'Fix-broken-tc-flower-rules-for-mscc_ocelot-switches'

Dexuan Cui (3):
      hv_netvsc: Fix hibernation for mlx5 VF driver
      hv_netvsc: Switch the data path at the right time during hibernation
      hv_netvsc: Cache the current data path to avoid duplicate call and me=
ssage

Dmitry Bogdanov (3):
      net: qed: Disable aRFS for NPAR and 100G
      net: qede: Disable aRFS for NPAR and 100G
      net: qed: RDMA personality shouldn't fail VF load

Edwin Peer (1):
      bnxt_en: return proper error codes in bnxt_show_temp

Eelco Chaudron (1):
      netfilter: conntrack: nf_conncount_init is failing with IPv6 disabled

Eric Dumazet (5):
      mac802154: tx: fix use-after-free
      ipv6: avoid lockdep issue in fib6_del()
      net: qrtr: check skb_put_padto() return value
      net: add __must_check to skb_put_padto()
      inet_diag: validate INET_DIAG_REQ_PROTOCOL attribute

Felix Fietkau (5):
      mt76: mt7615: use v1 MCU API on MT7615 to fix issues with adding/remo=
ving stations
      mt76: mt7915: use ieee80211_free_txskb to free tx skbs
      mac80211: extend AQL aggregation estimation to HE and fix unit mismat=
ch
      mac80211: add AQL support for VHT160 tx rates
      mac80211: do not allow bigger VHT MPDUs than the hardware supports

Florian Fainelli (2):
      net: phy: Avoid NPD upon phy_detach() when driver is unbound
      net: phy: Do not warn in phy_stop() on PHY_DOWN

Ganji Aravind (1):
      cxgb4: Fix offset when clearing filter byte counters

Geliang Tang (3):
      mptcp: fix subflow's local_id issues
      mptcp: fix subflow's remote_id issues
      mptcp: fix kmalloc flag in mptcp_pm_nl_get_local_id

Grygorii Strashko (1):
      net: ethernet: ti: cpsw_new: fix suspend/resume

Hauke Mehrtens (4):
      net: lantiq: Wake TX queue again
      net: lantiq: use netif_tx_napi_add() for TX NAPI
      net: lantiq: Use napi_complete_done()
      net: lantiq: Disable IRQs only if NAPI gets scheduled

Helmut Grohne (1):
      net: dsa: microchip: look for phy-mode in port nodes

Henry Ptasinski (1):
      net: sctp: Fix IPv6 ancestor_size calc in sctp_copy_descendant

Ido Schimmel (2):
      net: Fix bridge enslavement failure
      selftests: rtnetlink: Test bridge enslavement with different parent I=
Ds

Jakub Kicinski (5):
      Merge branch 'hinic-BugFixes'
      Merge branch 'bnxt_en-Two-bug-fixes'
      ibmvnic: add missing parenthesis in do_reset()
      MAINTAINERS: remove John Allen from ibmvnic
      nfp: use correct define to return NONE fec

Jason A. Donenfeld (2):
      wireguard: noise: take lock when removing handshake entry from table
      wireguard: peerlookup: take lock before checking hash in replace oper=
ation

Jianbo Liu (1):
      net/mlx5e: Fix memory leak of tunnel info when rule under multipath n=
ot ready

Jing Xiangfeng (1):
      atm: eni: fix the missed pci_disable_device() for eni_init_one()

Johannes Berg (1):
      cfg80211: fix 6 GHz channel conversion

John Crispin (1):
      mac80211: fix 80 MHz association to 160/80+80 AP on 6 GHz

Julian Wiedmann (1):
      s390/qeth: delay draining the TX buffers

Linus L=C3=BCssing (5):
      batman-adv: bla: fix type misuse for backbone_gw hash indexing
      batman-adv: mcast/TT: fix wrongly dropped or rerouted packets
      batman-adv: mcast: fix duplicate mcast packets in BLA backbone from L=
AN
      batman-adv: mcast: fix duplicate mcast packets in BLA backbone from m=
esh
      batman-adv: mcast: fix duplicate mcast packets from BLA backbone to m=
esh

Linus Walleij (1):
      net: dsa: rtl8366: Properly clear member config

Liu Jian (1):
      ieee802154: fix one possible memleak in ca8210_dev_com_init

Lorenzo Bianconi (2):
      net: mvneta: fix possible use-after-free in mvneta_xdp_put_buff
      net: mvneta: recycle the page in case of out-of-order

Lu Wei (3):
      net: tipc: kerneldoc fixes
      net: hns: kerneldoc fixes
      net: hns: kerneldoc fixes

Lucy Yan (1):
      net: dec: de2104x: Increase receive ring size for Tulip

Luo bin (4):
      hinic: bump up the timeout of SET_FUNC_STATE cmd
      hinic: bump up the timeout of UPDATE_FW cmd
      hinic: fix rewaking txq after netif_tx_disable
      hinic: fix sending pkts from core while self testing

Maor Dickman (2):
      net/mlx5e: Enable adding peer miss rules only if merged eswitch is su=
pported
      net/mlx5e: Fix endianness when calculating pedit mask first bit

Maor Gottlieb (1):
      net/mlx5: Fix FTE cleanup

Mark Gray (1):
      geneve: add transport ports in route lookup for geneve

Martin KaFai Lau (1):
      bpf: Bpf_skc_to_* casting helpers require a NULL check on sk

Martin Willi (1):
      netfilter: ctnetlink: fix mark based dump filtering regression

Matthias Schiffer (1):
      net: dsa: microchip: ksz8795: really set the correct number of ports

Mauro Carvalho Chehab (1):
      Revert "wlcore: Adding suppoprt for IGTK key in wlcore driver"

Maxim Mikityanskiy (2):
      net/mlx5e: Use RCU to protect rq->xdp_prog
      net/mlx5e: Use synchronize_rcu to sync with NAPI

Maximilian Luz (1):
      mwifiex: Increase AES key storage size to 256 bits

Miaohe Lin (2):
      net: Correct the comment of dst_dev_put()
      net: Fix broken NETIF_F_CSUM_MASK spell in netdev_features.h

Michael Chan (3):
      bnxt_en: Protect bnxt_set_eee() and bnxt_set_pauseparam() with mutex.
      bnxt_en: Fix HWRM_FUNC_QSTATS_EXT firmware call.
      bnxt_en: Fix wrong flag value passed to HWRM_PORT_QSTATS_EXT fw call.

Michal Kubecek (1):
      ethtool: add and use message type for tunnel info reply

Naveen N. Rao (1):
      libbpf: Remove arch-specific include path in Makefile

Necip Fazil Yildiran (2):
      lib80211: fix unmet direct dependendices config warning when !CRYPTO
      net: ipv6: fix kconfig dependency warning for IPV6_SEG6_HMAC

Nicolas Dichtel (1):
      netlink: fix doc about nlmsg_parse/nla_validate

Olympia Giannou (1):
      rndis_host: increase sleep time in the query-response loop

Pablo Neira Ayuso (2):
      netfilter: nf_tables: coalesce multiple notifications into one skbuff
      netfilter: nft_meta: use socket user_ns to retrieve skuid and skgid

Parshuram Thombare (1):
      net: macb: fix for pause frame receive enable bit

Peilin Ye (1):
      tipc: Fix memory leak in tipc_group_create_member()

Petr Machata (1):
      net: DCB: Validate DCB_ATTR_DCB_BUFFER argument

Raju Rangoju (1):
      cxgb4: fix memory leak during module unload

Randy Dunlap (2):
      netdevice.h: fix proto_down_reason kernel-doc warning
      netdevice.h: fix xdp_state kernel-doc warning

Roi Dayan (1):
      net/mlx5e: CT: Fix freeing ct_label mapping

Ron Diskin (1):
      net/mlx5e: Fix multicast counter not up-to-date in "ip -s"

Saeed Mahameed (4):
      net/mlx5e: kTLS, Add missing dma_unmap in RX resync
      net/mlx5e: kTLS, Fix leak on resync error flow
      net/mlx5e: kTLS, Avoid kzalloc(GFP_KERNEL) under spinlock
      net/mlx5e: mlx5e_fec_in_caps() returns a boolean

Sean Wang (1):
      net: Update MAINTAINERS for MediaTek switch driver

Stefan Assmann (2):
      i40e: fix return of uninitialized aq_ret in i40e_set_vsi_promisc
      i40e: always propagate error value in i40e_set_vsi_promisc()

Sven Eckelmann (1):
      batman-adv: Add missing include for in_interrupt()

Taehee Yoo (1):
      Revert "netns: don't disable BHs when locking "nsid_lock""

Tariq Toukan (2):
      net/mlx5e: TLS, Do not expose FPGA TLS counter if not supported
      net/mlx5e: kTLS, Fix napi sync and possible use-after-free

Tetsuo Handa (1):
      tipc: fix shutdown() of connection oriented socket

Toke H=C3=B8iland-J=C3=B8rgensen (1):
      tools/bpf: build: Make sure resolve_btfids cleans up after itself

Tom Rix (1):
      ieee802154/adf7242: check status of adf7242_read_reg

Tony Ambardar (2):
      libbpf: Fix build failure from uninitialized variable warning
      tools/libbpf: Avoid counting local symbols in ABI check

Vadym Kochan (1):
      net: ipa: fix u32_replace_bits by u32p_xxx version

Vasundhara Volam (4):
      bnxt_en: Avoid sending firmware messages when AER error is detected.
      bnxt_en: Fix NULL ptr dereference crash in bnxt_fw_reset_task()
      bnxt_en: Use memcpy to copy VPD field info.
      bnxt_en: Return -EOPNOTSUPP for ETHTOOL_GREGS on VFs.

Vinicius Costa Gomes (3):
      igc: Fix wrong timestamp latency numbers
      igc: Fix not considering the TX delay for timestamps
      taprio: Fix allowing too small intervals

Vladimir Oltean (12):
      net: dsa: link interfaces with the DSA master to get rid of lockdep w=
arnings
      net: mscc: ocelot: fix race condition with TX timestamping
      net: mscc: ocelot: add locking for the port TX timestamp ID
      net: dsa: seville: fix buffer size of the queue system
      net: mscc: ocelot: check for errors on memory allocation of ports
      net: mscc: ocelot: error checking when calling ocelot_init()
      net: mscc: ocelot: refactor ports parsing code into a dedicated funct=
ion
      net: mscc: ocelot: unregister net devices on unbind
      net: mscc: ocelot: deinitialize only initialized ports
      net: bridge: br_vlan_get_pvid_rcu() should dereference the VLAN group=
 under RCU
      net: dsa: seville: fix some key offsets for IP4_TCP_UDP VCAP IS2 entr=
ies
      net: mscc: ocelot: fix some key offsets for IP4_TCP_UDP VCAP IS2 entr=
ies

Wei Li (1):
      hinic: fix potential resource leak

Wei Wang (1):
      ip: fix tos reflection in ack and reset packets

Wen Gong (1):
      mac80211: do not disable HE if HT is missing on 2.4 GHz

Will McVicker (1):
      netfilter: ctnetlink: add a range check for l3/l4 protonum

Wright Feng (1):
      brcmfmac: reserve tx credit only when txctl is ready to send

Xiaoliang Yang (1):
      net: dsa: felix: fix some key offsets for IP4_TCP_UDP VCAP IS2 entries

Xie He (3):
      drivers/net/wan/hdlc_fr: Add needed_headroom for PVC devices
      drivers/net/wan/lapbether: Make skb->protocol consistent with the hea=
der
      drivers/net/wan/hdlc: Set skb->protocol before transmitting

Xin Long (4):
      tipc: use skb_unshare() instead in tipc_buf_append()
      net: sched: only keep the available bits when setting vxlan md->gbp
      lwtunnel: only keep the available bits when setting vxlan md->gbp
      net: sched: initialize with 0 before setting erspan md->u

Xu Wang (1):
      ipv6: route: convert comma to semicolon

Yangbo Lu (1):
      dpaa2-eth: fix a build warning in dpmac.c

Ye Bin (1):
      hsr: avoid newline at end of message in NL_SET_ERR_MSG_MOD

Yonghong Song (3):
      bpf: Do not use bucket_lock for hashmap iterator
      selftests/bpf: Add bpf_{update, delete}_map_elem in hashmap iter prog=
ram
      bpf: Fix a rcu warning for bpffs map pretty-print

Yoshihiro Shimoda (1):
      net: phy: call phy_disable_interrupts() in phy_attach_direct() instead

Yunsheng Lin (1):
      net: sch_generic: aviod concurrent reset and enqueue op for lockless =
qdisc

 Documentation/bpf/ringbuf.rst                      |   5 +-
 Documentation/networking/ethtool-netlink.rst       |   3 +
 MAINTAINERS                                        |  15 +-
 arch/arm/boot/dts/at91-sama5d2_icp.dts             |   2 +-
 drivers/atm/eni.c                                  |   2 +-
 drivers/net/dsa/microchip/ksz8795.c                |  20 +-
 drivers/net/dsa/microchip/ksz9477.c                |  29 ++-
 drivers/net/dsa/microchip/ksz_common.c             |  13 +-
 drivers/net/dsa/microchip/ksz_common.h             |   3 +-
 drivers/net/dsa/ocelot/felix.c                     |   8 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c             |  16 +-
 drivers/net/dsa/ocelot/seville_vsc9953.c           |  18 +-
 drivers/net/dsa/rtl8366.c                          |  20 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  43 ++--
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |   4 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |  34 ++-
 drivers/net/ethernet/cadence/macb_main.c           |   3 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c  |   9 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_mps.c     |   2 +-
 drivers/net/ethernet/dec/tulip/de2104x.c           |   2 +-
 drivers/net/ethernet/freescale/dpaa2/dpmac-cmd.h   |   4 +-
 drivers/net/ethernet/freescale/enetc/enetc_pf.c    |   2 +-
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c |   4 +-
 drivers/net/ethernet/hisilicon/hns/hns_ethtool.c   |  40 ++--
 drivers/net/ethernet/huawei/hinic/hinic_ethtool.c  |   4 +
 drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c  |  20 +-
 drivers/net/ethernet/huawei/hinic/hinic_main.c     |  24 ++
 drivers/net/ethernet/huawei/hinic/hinic_rx.c       |  21 +-
 drivers/net/ethernet/huawei/hinic/hinic_tx.c       |  24 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |   6 +-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |  22 +-
 drivers/net/ethernet/intel/igc/igc.h               |  20 +-
 drivers/net/ethernet/intel/igc/igc_ptp.c           |  19 ++
 drivers/net/ethernet/lantiq_xrx200.c               |  21 +-
 drivers/net/ethernet/marvell/mvneta.c              |  10 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   3 +-
 .../ethernet/mellanox/mlx5/core/en/monitor_stats.c |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/port.c  |   7 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |  21 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h |  26 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  |   5 +
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c   |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/rx.c    |  14 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.c |   3 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c |  43 ++--
 .../mellanox/mlx5/core/en_accel/tls_stats.c        |  12 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  85 +++----
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |  16 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |  12 +
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.h |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  45 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c  |  17 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  52 +++--
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   8 +-
 drivers/net/ethernet/mscc/ocelot.c                 |  24 +-
 drivers/net/ethernet/mscc/ocelot_net.c             |  12 +-
 drivers/net/ethernet/mscc/ocelot_vsc7514.c         | 249 ++++++++++++-----=
----
 .../net/ethernet/netronome/nfp/nfp_net_ethtool.c   |   4 +-
 drivers/net/ethernet/qlogic/qed/qed_dev.c          |  11 +-
 drivers/net/ethernet/qlogic/qed/qed_l2.c           |   3 +
 drivers/net/ethernet/qlogic/qed/qed_main.c         |   2 +
 drivers/net/ethernet/qlogic/qed/qed_sriov.c        |   1 +
 drivers/net/ethernet/qlogic/qede/qede_filter.c     |   3 +
 drivers/net/ethernet/qlogic/qede/qede_main.c       |  11 +-
 drivers/net/ethernet/sfc/ef100.c                   |   1 +
 drivers/net/ethernet/ti/cpsw_new.c                 |  53 +++++
 drivers/net/geneve.c                               |  37 ++-
 drivers/net/hyperv/hyperv_net.h                    |   7 +
 drivers/net/hyperv/netvsc.c                        | 124 ++++++++--
 drivers/net/hyperv/netvsc_drv.c                    |  35 ++-
 drivers/net/hyperv/rndis_filter.c                  |  73 +++++-
 drivers/net/ieee802154/adf7242.c                   |   4 +-
 drivers/net/ieee802154/ca8210.c                    |   1 +
 drivers/net/ipa/ipa_table.c                        |   4 +-
 drivers/net/phy/phy.c                              |   2 +-
 drivers/net/phy/phy_device.c                       |  11 +-
 drivers/net/usb/rndis_host.c                       |   2 +-
 drivers/net/wan/hdlc_cisco.c                       |   1 +
 drivers/net/wan/hdlc_fr.c                          |   6 +-
 drivers/net/wan/hdlc_ppp.c                         |  17 +-
 drivers/net/wan/lapbether.c                        |   4 +-
 drivers/net/wireguard/noise.c                      |   5 +-
 drivers/net/wireguard/peerlookup.c                 |  11 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |  12 +-
 drivers/net/wireless/marvell/mwifiex/fw.h          |   2 +-
 drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c |   4 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    |   3 +-
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   |   8 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    |   2 +-
 drivers/net/wireless/ti/wlcore/cmd.h               |   1 -
 drivers/net/wireless/ti/wlcore/main.c              |   4 -
 drivers/s390/net/qeth_l2_main.c                    |   2 +-
 drivers/s390/net/qeth_l3_main.c                    |   2 +-
 include/linux/netdev_features.h                    |   2 +-
 include/linux/netdevice.h                          |   2 +
 include/linux/qed/qed_if.h                         |   1 +
 include/linux/skbuff.h                             |   7 +-
 include/net/flow.h                                 |   1 +
 include/net/netlink.h                              |   2 -
 include/net/netns/nftables.h                       |   1 +
 include/net/sctp/structs.h                         |   8 +-
 include/net/vxlan.h                                |   3 +
 include/soc/mscc/ocelot.h                          |   2 +
 include/uapi/linux/ethtool_netlink.h               |   1 +
 kernel/bpf/hashtab.c                               |  15 +-
 kernel/bpf/inode.c                                 |   4 +-
 lib/test_rhashtable.c                              |   2 +-
 net/batman-adv/bridge_loop_avoidance.c             | 145 +++++++++---
 net/batman-adv/bridge_loop_avoidance.h             |   4 +-
 net/batman-adv/multicast.c                         |  46 +++-
 net/batman-adv/multicast.h                         |  15 ++
 net/batman-adv/routing.c                           |   4 +
 net/batman-adv/soft-interface.c                    |  11 +-
 net/bridge/br_vlan.c                               |  27 ++-
 net/core/dev.c                                     |   2 +-
 net/core/dst.c                                     |   2 +-
 net/core/fib_rules.c                               |   2 +-
 net/core/filter.c                                  |  19 +-
 net/core/net_namespace.c                           |  22 +-
 net/dcb/dcbnl.c                                    |   8 +
 net/dsa/slave.c                                    |  18 +-
 net/dsa/tag_ocelot.c                               |  11 +-
 net/ethtool/tunnels.c                              |   4 +-
 net/hsr/hsr_netlink.c                              |   6 +-
 net/ipv4/fib_frontend.c                            |   1 +
 net/ipv4/inet_diag.c                               |  20 +-
 net/ipv4/ip_output.c                               |   3 +-
 net/ipv4/ip_tunnel_core.c                          |   1 +
 net/ipv4/route.c                                   |  14 +-
 net/ipv6/Kconfig                                   |   1 +
 net/ipv6/ip6_fib.c                                 |  13 +-
 net/ipv6/route.c                                   |   2 +-
 net/mac80211/airtime.c                             |  20 +-
 net/mac80211/mlme.c                                |   3 +-
 net/mac80211/rx.c                                  |   3 +-
 net/mac80211/util.c                                |   7 +-
 net/mac80211/vht.c                                 |   8 +-
 net/mac802154/tx.c                                 |   8 +-
 net/mptcp/pm_netlink.c                             |  19 +-
 net/mptcp/subflow.c                                |   7 +-
 net/netfilter/nf_conntrack_netlink.c               |  22 +-
 net/netfilter/nf_conntrack_proto.c                 |   2 +
 net/netfilter/nf_tables_api.c                      |  70 ++++--
 net/netfilter/nft_meta.c                           |   4 +-
 net/qrtr/qrtr.c                                    |  21 +-
 net/sched/act_ife.c                                |  44 +++-
 net/sched/act_tunnel_key.c                         |   1 +
 net/sched/cls_flower.c                             |   5 +-
 net/sched/sch_generic.c                            |  48 ++--
 net/sched/sch_taprio.c                             |  28 ++-
 net/sctp/socket.c                                  |   9 +-
 net/tipc/group.c                                   |  14 +-
 net/tipc/link.c                                    |   3 +-
 net/tipc/msg.c                                     |   3 +-
 net/tipc/socket.c                                  |   5 +-
 net/wireless/Kconfig                               |   1 +
 net/wireless/util.c                                |   2 +-
 net/xdp/xdp_umem.c                                 |  17 +-
 tools/bpf/Makefile                                 |   4 +-
 tools/bpf/resolve_btfids/Makefile                  |   1 +
 tools/lib/bpf/Makefile                             |   4 +-
 tools/lib/bpf/libbpf.c                             |   2 +-
 .../selftests/bpf/progs/bpf_iter_bpf_hash_map.c    |  15 ++
 tools/testing/selftests/net/rtnetlink.sh           |  47 ++++
 165 files changed, 1705 insertions(+), 824 deletions(-)
