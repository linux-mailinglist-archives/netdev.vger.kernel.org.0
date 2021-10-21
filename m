Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE8FD436657
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 17:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231574AbhJUPey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 11:34:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:50456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231137AbhJUPex (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 11:34:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 32097610C8;
        Thu, 21 Oct 2021 15:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634830357;
        bh=gDM13zQR7map/FY20Ow6ftwrXCQ7zhhLPJy7dqpldVU=;
        h=From:To:Cc:Subject:Date:From;
        b=jjdxssgd94Q3E/zFe+OGcsEo7wVxVfpLXciv5qMP6kpHyycKgjfuKKSskS7D5WFty
         DuByJ53v/2LLTaPNc9KO864WIcu6Al088/Xjm3SmcUVrhDa1HQqVh5KgCiW1t8iT0v
         yJFSmtm7vxuT/xE/MmbP3Fgdt6VVIT3X6MfVtMb1OKSzhyaz1gZNoq57Cp68i3AVwa
         3ekL3a6ZyinQwer9ofNwNQ70yTE1n+OKEZ2YHe4do55mXXb8Zzg2ADhpJgXOOGRu7Y
         dyhJegboIsrPTgSE2AtJcz6+QvYAumMDwLXxjlPlsm4+ER9RTMZe++CRyWleMQen2X
         1Vm7+0v8rBGDA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 5.15-rc7
Date:   Thu, 21 Oct 2021 08:32:26 -0700
Message-Id: <20211021153226.788611-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

We'll have one more fix for a socket accounting regression,
it's still getting polished. Otherwise things look fine.

The following changes since commit ec681c53f8d2d0ee362ff67f5b98dd8263c15002:

  Merge tag 'net-5.15-rc6' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2021-10-14 18:21:39 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.15-rc7

for you to fetch changes up to 397430b50a363d8b7bdda00522123f82df6adc5e:

  usbnet: sanity check for maxpacket (2021-10-21 06:44:53 -0700)

----------------------------------------------------------------
Networking fixes for 5.15-rc7, including fixes from netfilter, and can.

Current release - regressions:

 - revert "vrf: reset skb conntrack connection on VRF rcv",
   there are valid uses for previous behavior

 - can: m_can: fix iomap_read_fifo() and iomap_write_fifo()

Current release - new code bugs:

 - mlx5: e-switch, return correct error code on group creation failure

Previous releases - regressions:

 - sctp: fix transport encap_port update in sctp_vtag_verify

 - stmmac: fix E2E delay mechanism (in PTP timestamping)

Previous releases - always broken:

 - netfilter: ip6t_rt: fix out-of-bounds read of ipv6_rt_hdr

 - netfilter: xt_IDLETIMER: fix out-of-bound read caused by lack of init

 - netfilter: ipvs: make global sysctl read-only in non-init netns

 - tcp: md5: fix selection between vrf and non-vrf keys

 - ipv6: count rx stats on the orig netdev when forwarding

 - bridge: mcast: use multicast_membership_interval for IGMPv3

 - can:
   - j1939: fix UAF for rx_kref of j1939_priv
            abort sessions on receiving bad messages

   - isotp: fix TX buffer concurrent access in isotp_sendmsg()
            fix return error on FC timeout on TX path

 - ice: fix re-init of RDMA Tx queues and crash if RDMA was not inited

 - hns3: schedule the polling again when allocation fails,
   prevent stalls

 - drivers: add missing of_node_put() when aborting
   for_each_available_child_of_node()

 - ptp: fix possible memory leak and UAF in ptp_clock_register()

 - e1000e: fix packet loss in burst mode on Tiger Lake and later

 - mlx5e: ipsec: fix more checksum offload issues

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Aleksander Jan Bajkowski (1):
      net: dsa: lantiq_gswip: fix register definition

Antoine Tenart (1):
      netfilter: ipvs: make global sysctl readonly in non-init netns

Aswath Govindraju (1):
      can: m_can: fix iomap_read_fifo() and iomap_write_fifo()

Brett Creeley (2):
      ice: Fix failure to re-add LAN/RDMA Tx queues
      ice: Print the api_patch as part of the fw.mgmt.api

Christophe JAILLET (1):
      net: dsa: Fix an error handling path in 'dsa_switch_parse_ports_of()'

DENG Qingfang (1):
      net: dsa: mt7530: correct ds->num_ports

Dave Ertman (1):
      ice: Avoid crash from unnecessary IDA free

David S. Miller (7):
      Merge branch 'tcp-md5-vrf-fix'
      Merge tag 'linux-can-fixes-for-5.15-20211017' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can
      Merge tag 'linux-can-fixes-for-5.15-20211019' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can
      Merge branch 'hns3-fixes'
      Merge branch '1GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      Merge tag 'mlx5-fixes-2021-10-20' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf

Davidlohr Bueso (1):
      netfilter: ebtables: allocate chainstack on CPU local nodes

Dmytro Linkin (1):
      net/mlx5: E-switch, Return correct error code on group creation failure

Emeel Hakim (2):
      net/mlx5e: IPsec: Fix a misuse of the software parser's fields
      net/mlx5e: IPsec: Fix work queue entry ethernet segment checksum flags

Erik Ekman (2):
      sfc: Export fibre-specific supported link modes
      sfc: Don't use netif_info before net_device setup

Eugene Crosser (1):
      vrf: Revert "Reset skb conntrack connection..."

Florian Westphal (3):
      netfilter: nf_tables: skip netdev events generated on netns removal
      selftests: nft_nat: add udp hole punch test case
      selftests: netfilter: remove stray bash debug line

Guangbin Huang (2):
      net: hns3: reset DWRR of unused tc to zero
      net: hns3: add limit ets dwrr bandwidth cannot be 0

Jakub Kicinski (1):
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue

Jeremy Kerr (2):
      mctp: unify sockaddr_mctp types
      mctp: Be explicit about struct sockaddr_mctp padding

Jiaran Zhang (1):
      net: hns3: Add configuration of TM QCN error event

Juhee Kang (1):
      netfilter: xt_IDLETIMER: fix panic that occurs when timer_type has garbage value

Kele Huang (1):
      ptp: fix error print of ptp_kvm on X86_64 platform

Kurt Kanzenbach (1):
      net: stmmac: Fix E2E delay mechanism

Leonard Crestez (4):
      tcp: md5: Fix overlap between vrf and non-vrf keys
      tcp: md5: Allow MD5SIG_FLAG_IFINDEX with ifindex=0
      selftests: nettest: Add --{force,no}-bind-key-ifindex
      selftests: net/fcnal: Test --{force,no}-bind-key-ifindex

Maor Dickman (1):
      net/mlx5: Lag, change multipath and bonding to be mutually exclusive

Marc Kleine-Budde (1):
      can: isotp: isotp_sendmsg(): fix return error on FC timeout on TX path

Michal Swiatkowski (1):
      ice: fix getting UDP tunnel entry

Moshe Shemesh (1):
      net/mlx5e: Fix vlan data lost during suspend flow

Nathan Chancellor (1):
      nfp: bpf: silence bitwise vs. logical OR warning

Nikolay Aleksandrov (1):
      net: bridge: mcast: use multicast_membership_interval for IGMPv3

Oliver Neukum (1):
      usbnet: sanity check for maxpacket

Paul Blakey (1):
      net/sched: act_ct: Fix byte count on fragmented packets

Peng Li (1):
      net: hns3: disable sriov before unload hclge layer

Randy Dunlap (1):
      hamradio: baycom_epp: fix build for UML

Sasha Neftin (3):
      e1000e: Separate TGP board type from SPT
      e1000e: Fix packet loss on Tiger Lake and later
      igc: Update I226_K device ID

Stefano Garzarella (1):
      vsock_diag_test: remove free_sock_stat() call in test_no_sockets

Stephane Grosjean (2):
      can: peak_usb: pcan_usb_fd_decode_status(): fix back to ERROR_ACTIVE state notification
      can: peak_usb: pcan_usb_fd_decode_status(): remove unnecessary test on the nullity of a pointer

Stephen Suryaputra (1):
      ipv6: When forwarding count rx stats on the orig netdev

Tianjia Zhang (1):
      selftests/tls: add SM4 algorithm dependency for tls selftests

Tony Nguyen (1):
      ice: Add missing E810 device ids

Uwe Kleine-König (1):
      nfc: st95hf: Make spi remove() callback return zero

Vegard Nossum (2):
      netfilter: Kconfig: use 'default y' instead of 'm' for bool config option
      lan78xx: select CRC32

Vladimir Oltean (2):
      net: enetc: fix ethtool counter name for PM0_TERR
      net: enetc: make sure all traffic classes can send large frames

Wan Jiabing (2):
      net: sparx5: Add of_node_put() before goto
      net: mscc: ocelot: Add of_node_put() before goto

Xin Long (2):
      netfilter: ip6t_rt: fix rt0_hdr parsing in rt_mt6
      sctp: fix transport encap_port update in sctp_vtag_verify

Yang Yingliang (2):
      ptp: Fix possible memory leak in ptp_clock_register()
      ptp: free 'vclock_index' in ptp_clock_release()

Yoshihiro Shimoda (1):
      can: rcar_can: fix suspend/resume

Yufeng Mo (1):
      net: hns3: fix vf reset workqueue cannot exit

Yunsheng Lin (3):
      net: hns3: fix the max tx size according to user manual
      net: hns3: fix for miscalculation of rx unused desc
      net: hns3: schedule the polling again when allocation fails

Zhang Changzhong (2):
      can: j1939: j1939_xtp_rx_dat_one(): cancel session if receive TP.DT with error length
      can: j1939: j1939_xtp_rx_rts_session_new(): abort TP less than 9 bytes

Zheyu Ma (4):
      can: peak_pci: peak_pci_remove(): fix UAF
      cavium: Return negative value when pci_alloc_irq_vectors() fails
      mISDN: Fix return values of the probe function
      cavium: Fix return values of the probe function

Ziyang Xuan (4):
      can: j1939: j1939_tp_rxtimer(): fix errant alert in j1939_tp_rxtimer
      can: j1939: j1939_netdev_start(): fix UAF for rx_kref of j1939_priv
      can: isotp: isotp_sendmsg(): add result check for wait_event_interruptible()
      can: isotp: isotp_sendmsg(): fix TX buffer concurrent access in isotp_sendmsg()

 Documentation/networking/devlink/ice.rst           |   9 +-
 Documentation/networking/mctp.rst                  |  10 +-
 drivers/isdn/hardware/mISDN/hfcpci.c               |   8 +-
 drivers/net/can/m_can/m_can_platform.c             |  14 +-
 drivers/net/can/rcar/rcar_can.c                    |  20 ++-
 drivers/net/can/sja1000/peak_pci.c                 |   9 +-
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c         |   8 +-
 drivers/net/dsa/lantiq_gswip.c                     |   2 +-
 drivers/net/dsa/mt7530.c                           |   8 +-
 drivers/net/ethernet/cavium/thunder/nic_main.c     |   2 +-
 drivers/net/ethernet/cavium/thunder/nicvf_main.c   |   4 +-
 .../net/ethernet/freescale/enetc/enetc_ethtool.c   |   2 +-
 drivers/net/ethernet/freescale/enetc/enetc_pf.c    |   5 +-
 drivers/net/ethernet/hisilicon/hns3/hnae3.c        |  21 +++
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  37 +++--
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |   7 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c |   9 ++
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c |   5 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h |   2 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |   1 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  |   2 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |   6 +-
 drivers/net/ethernet/intel/e1000e/e1000.h          |   4 +-
 drivers/net/ethernet/intel/e1000e/ich8lan.c        |  31 +++-
 drivers/net/ethernet/intel/e1000e/ich8lan.h        |   3 +
 drivers/net/ethernet/intel/e1000e/netdev.c         |  45 +++---
 drivers/net/ethernet/intel/ice/ice_common.c        |   2 +
 drivers/net/ethernet/intel/ice/ice_devids.h        |   4 +
 drivers/net/ethernet/intel/ice/ice_devlink.c       |   3 +-
 drivers/net/ethernet/intel/ice/ice_flex_pipe.c     |   4 +-
 drivers/net/ethernet/intel/ice/ice_lib.c           |   9 ++
 drivers/net/ethernet/intel/ice/ice_main.c          |   8 +-
 drivers/net/ethernet/intel/ice/ice_sched.c         |  13 ++
 drivers/net/ethernet/intel/ice/ice_sched.h         |   1 +
 drivers/net/ethernet/intel/igc/igc_hw.h            |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h    |   3 +
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun.c    |   2 +
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.c       |  51 +++---
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c    |  28 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   7 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |  20 +--
 drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c  |   7 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag.c      |   4 +
 drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c   |  13 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag_mp.h   |   2 +
 .../net/ethernet/microchip/sparx5/sparx5_main.c    |   1 +
 drivers/net/ethernet/mscc/ocelot_vsc7514.c         |   1 +
 drivers/net/ethernet/netronome/nfp/nfp_asm.c       |   4 +-
 drivers/net/ethernet/sfc/mcdi_port_common.c        |  37 +++--
 drivers/net/ethernet/sfc/ptp.c                     |   4 +-
 drivers/net/ethernet/sfc/siena_sriov.c             |   2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   2 +-
 drivers/net/hamradio/baycom_epp.c                  |   6 +-
 drivers/net/usb/Kconfig                            |   1 +
 drivers/net/usb/usbnet.c                           |   4 +
 drivers/net/vrf.c                                  |   4 -
 drivers/nfc/st95hf/core.c                          |   6 +-
 drivers/ptp/ptp_clock.c                            |  16 +-
 drivers/ptp/ptp_kvm_x86.c                          |   4 +-
 include/linux/mlx5/driver.h                        |   1 -
 include/net/mctp.h                                 |   2 +-
 include/net/sctp/sm.h                              |   6 +-
 include/net/tcp.h                                  |   5 +-
 include/uapi/linux/mctp.h                          |   7 +-
 net/bridge/br_private.h                            |   4 +-
 net/bridge/netfilter/ebtables.c                    |   4 +-
 net/can/isotp.c                                    |  51 ++++--
 net/can/j1939/j1939-priv.h                         |   1 +
 net/can/j1939/main.c                               |   7 +-
 net/can/j1939/transport.c                          |  14 +-
 net/dsa/dsa2.c                                     |   9 +-
 net/ipv4/tcp_ipv4.c                                |  45 ++++--
 net/ipv6/ip6_output.c                              |   3 +-
 net/ipv6/netfilter/ip6t_rt.c                       |  48 +-----
 net/ipv6/tcp_ipv6.c                                |  15 +-
 net/netfilter/Kconfig                              |   2 +-
 net/netfilter/ipvs/ip_vs_ctl.c                     |   5 +
 net/netfilter/nft_chain_filter.c                   |   9 +-
 net/netfilter/xt_IDLETIMER.c                       |   2 +-
 net/sched/act_ct.c                                 |   2 +-
 tools/testing/selftests/net/config                 |   1 +
 tools/testing/selftests/net/fcnal-test.sh          |  60 +++++++
 tools/testing/selftests/net/forwarding/Makefile    |   1 +
 .../net/forwarding/forwarding.config.sample        |   2 +
 .../net/forwarding/ip6_forward_instats_vrf.sh      | 172 +++++++++++++++++++++
 tools/testing/selftests/net/forwarding/lib.sh      |   8 +
 tools/testing/selftests/net/nettest.c              |  28 +++-
 tools/testing/selftests/netfilter/nft_flowtable.sh |   1 -
 tools/testing/selftests/netfilter/nft_nat.sh       | 145 +++++++++++++++++
 tools/testing/vsock/vsock_diag_test.c              |   2 -
 92 files changed, 913 insertions(+), 301 deletions(-)
 create mode 100755 tools/testing/selftests/net/forwarding/ip6_forward_instats_vrf.sh
