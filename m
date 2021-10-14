Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F129442DE06
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 17:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233082AbhJNP0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 11:26:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:37110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233071AbhJNP0B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 11:26:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2691E61053;
        Thu, 14 Oct 2021 15:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634225036;
        bh=rrSkA5IDlL7zHavWeasHsffiidaM4Ee8pKN5vxEqsPo=;
        h=From:To:Cc:Subject:Date:From;
        b=uHElOSmfvGWLN1lwHEjf/lAgDEQ+2FCDM83gs/zXfb1SMdc9RvQDp2fnX+hjizkdr
         ncL4sQhocJUIeFIW1d3eDCtO3F6ixx83mx+3/9v7fR+8OpmOYB+BYCkg0fZmh/gx5o
         5LFNBFqR6+mVqV9m3xTQVHEwuXFEFzWeQu31nfPtWlulrLQjEdxVicYxVxz0eH7LSW
         Rj8F1H9Kf01FLLVslAD1NPIMTHQZaceW/+tKNLtHSjon7ab9JAW5CTt6XZ0PYC2IcJ
         vGtoglcUOUZNOnS2hXAwjzCInFsC3gwbpRqWvLczv2I8RDGrVr7pBcO66kxW8hyrFL
         eFw/r6fPthUDg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 5.15-rc6
Date:   Thu, 14 Oct 2021 08:23:55 -0700
Message-Id: <20211014152355.2109412-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

Quite calm. The noisy DSA driver (embedded switches) changes, and
adjustment to IPv6 IOAM behavior add to diffstat's bottom line but
are not scary.

The following changes since commit 1da38549dd64c7f5dd22427f12dfa8db3d8a722b:

  Merge tag 'nfsd-5.15-3' of git://git.kernel.org/pub/scm/linux/kernel/git/cel/linux (2021-10-07 14:11:40 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.15-rc6

for you to fetch changes up to 1fcd794518b7644169595c66b1bfe726d1f498ab:

  icmp: fix icmp_ext_echo_iio parsing in icmp_build_probe (2021-10-14 07:54:47 -0700)

----------------------------------------------------------------
Networking fixes for 5.15-rc6.

Current release - regressions:

 - af_unix: rename UNIX-DGRAM to UNIX to maintain backwards compatibility

 - procfs: revert "add seq_puts() statement for dev_mcast",
   minor format change broke user space

Current release - new code bugs:

 - dsa: fix bridge_num not getting cleared after ports leaving
   the bridge, resource leak

 - dsa: tag_dsa: send packets with TX fwd offload from VLAN-unaware
   bridges using VID 0, prevent packet drops if pvid is removed

 - dsa: mv88e6xxx: keep the pvid at 0 when VLAN-unaware, prevent
   HW getting confused about station to VLAN mapping

Previous releases - regressions:

 - virtio-net: fix for skb_over_panic inside big mode

 - phy: do not shutdown PHYs in READY state

 - dsa: mv88e6xxx: don't use PHY_DETECT on internal PHY's,
   fix link LED staying lit after ifdown

 - mptcp: fix possible infinite wait on recvmsg(MSG_WAITALL)

 - mqprio: Correct stats in mqprio_dump_class_stats()

 - ice: fix deadlock for Tx timestamp tracking flush

 - stmmac: fix feature detection on old hardware

Previous releases - always broken:

 - sctp: account stream padding length for reconf chunk

 - icmp: fix icmp_ext_echo_iio parsing in icmp_build_probe()

 - isdn: cpai: check ctr->cnr to avoid array index out of bound

 - isdn: mISDN: fix sleeping function called from invalid context

 - nfc: nci: fix potential UAF of rf_conn_info object

 - dsa: microchip: prevent ksz_mib_read_work from kicking back
   in after it's canceled in .remove and crashing

 - dsa: mv88e6xxx: isolate the ATU databases of standalone and
   bridged ports

 - dsa: sja1105, ocelot: break circular dependency between switch
   and tag drivers

 - dsa: felix: improve timestamping in presence of packe loss

 - mlxsw: thermal: fix out-of-bounds memory accesses

Misc:

 - ipv6: ioam: move the check for undefined bits to improve
   interoperability

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Alvin Šipraga (1):
      net: dsa: fix spurious error message when unoffloaded port leaves bridge

Arnd Bergmann (1):
      ethernet: s2io: fix setting mac address during resume

Arun Ramadoss (1):
      net: dsa: microchip: Added the condition for scheduling ksz_mib_read_work

Aya Levin (1):
      net/mlx5e: Mutually exclude RX-FCS and RX-port-timestamp

Baowen Zheng (1):
      nfp: flow_offload: move flow_indr_dev_register from app init to app start

Cai Huoqing (1):
      MAINTAINERS: Update the devicetree documentation path of imx fec driver

David S. Miller (2):
      Merge branch 'stmmac-regression-fix'
      Merge branch 'ioam-fixes'

Eiichi Tsukata (1):
      sctp: account stream padding length for reconf chunk

Florian Fainelli (1):
      net: phy: Do not shutdown PHYs in READY state

Haiyang Zhang (1):
      net: mana: Fix error handling in mana_create_rxq()

Herve Codina (4):
      net: stmmac: fix get_hw_feature() on old hardware
      dt-bindings: net: snps,dwmac: add dwmac 3.40a IP version
      net: stmmac: add support for dwmac 3.40a
      ARM: dts: spear3xx: Fix gmac node

Ido Schimmel (1):
      mlxsw: thermal: Fix out-of-bounds memory accesses

Jacob Keller (1):
      ice: fix locking for Tx timestamp tracking flush

Jakub Kicinski (5):
      Merge branch 'dsa-bridge-tx-forwarding-offload-fixes-part-1'
      Merge branch 'fix-circular-dependency-between-sja1105-and-tag_sja1105'
      Merge branch 'felix-dsa-driver-fixes'
      Merge tag 'mlx5-fixes-2021-10-12' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge branch 'fix-two-possible-memory-leak-problems-in-nfc-digital-module'

Justin Iurman (2):
      ipv6: ioam: move the check for undefined bits
      selftests: net: modify IOAM tests for undef bits

Karsten Graul (1):
      net/smc: improved fix wait on already cleared link

Lin Ma (1):
      nfc: nci: fix the UAF of rf_conn_info object

Maarten Zanders (1):
      net: dsa: mv88e6xxx: don't use PHY_DETECT on internal PHY's

Maxim Mikityanskiy (1):
      net/mlx5e: Fix division by 0 in mlx5e_select_queue for representors

Nanyong Sun (1):
      net: encx24j600: check error in devm_regmap_init_encx24j600

Paolo Abeni (1):
      mptcp: fix possible stall on recvmsg()

Saeed Mahameed (1):
      net/mlx5e: Switchdev representors are not vlan challenged

Sebastian Andrzej Siewior (1):
      mqprio: Correct stats in mqprio_dump_class_stats().

Shannon Nelson (1):
      ionic: don't remove netdev->dev_addr when syncing uc list

Shay Drory (1):
      net/mlx5: Fix cleanup of bridge delayed work

Stephen Boyd (1):
      af_unix: Rename UNIX-DGRAM to UNIX to maintain backwards compatability

Tariq Toukan (1):
      net/mlx5e: Allow only complete TXQs partition in MQPRIO channel mode

Valentine Fatiev (1):
      net/mlx5e: Fix memory leak in mlx5_core_destroy_cq() error path

Vegard Nossum (3):
      r8152: select CRC32 and CRYPTO/CRYPTO_HASH/CRYPTO_SHA256
      net: arc: select CRC32
      net: korina: select CRC32

Vladimir Oltean (18):
      net: dsa: fix bridge_num not getting cleared after ports leaving the bridge
      net: dsa: tag_dsa: send packets with TX fwd offload from VLAN-unaware bridges using VID 0
      net: dsa: mv88e6xxx: keep the pvid at 0 when VLAN-unaware
      net: dsa: mv88e6xxx: isolate the ATU databases of standalone and bridged ports
      net: dsa: hold rtnl_lock in dsa_switch_setup_tag_protocol
      net: dsa: move sja1110_process_meta_tstamp inside the tagging protocol driver
      net: dsa: sja1105: break dependency between dsa_port_is_sja1105 and switch driver
      net: mscc: ocelot: make use of all 63 PTP timestamp identifiers
      net: mscc: ocelot: avoid overflowing the PTP timestamp FIFO
      net: mscc: ocelot: warn when a PTP IRQ is raised for an unknown skb
      net: mscc: ocelot: deny TX timestamping of non-PTP packets
      net: mscc: ocelot: cross-check the sequence id from the timestamp FIFO with the skb PTP header
      net: dsa: tag_ocelot: break circular dependency with ocelot switch lib driver
      net: dsa: tag_ocelot_8021q: break circular dependency with ocelot switch lib
      net: dsa: felix: purge skb from TX timestamping queue if it cannot be sent
      net: dsa: tag_ocelot_8021q: fix inability to inject STP BPDUs into BLOCKING ports
      net: dsa: felix: break at first CPU port during init and teardown
      Revert "net: procfs: add seq_puts() statement for dev_mcast"

Wan Jiabing (1):
      net: mscc: ocelot: Fix dumplicated argument in ocelot

Xiaolong Huang (1):
      isdn: cpai: check ctr->cnr to avoid array index out of bound

Xin Long (1):
      icmp: fix icmp_ext_echo_iio parsing in icmp_build_probe

Xuan Zhuo (1):
      virtio-net: fix for skb_over_panic inside big mode

Zheyu Ma (1):
      isdn: mISDN: Fix sleeping function called from invalid context

Ziyang Xuan (3):
      nfc: fix error handling of nfc_proto_register()
      NFC: digital: fix possible memory leak in digital_tg_listen_mdaa()
      NFC: digital: fix possible memory leak in digital_in_send_sdd_req()

chongjiapeng (1):
      qed: Fix missing error code in qed_slowpath_start()

 .../devicetree/bindings/net/snps,dwmac.yaml        |   2 +
 MAINTAINERS                                        |   3 +-
 arch/arm/boot/dts/spear3xx.dtsi                    |   2 +-
 drivers/isdn/capi/kcapi.c                          |   5 +
 drivers/isdn/hardware/mISDN/netjet.c               |   2 +-
 drivers/net/dsa/microchip/ksz_common.c             |   4 +-
 drivers/net/dsa/mv88e6xxx/chip.c                   | 125 +++++++++++++---
 drivers/net/dsa/mv88e6xxx/chip.h                   |   9 ++
 drivers/net/dsa/mv88e6xxx/port.c                   |  21 +++
 drivers/net/dsa/mv88e6xxx/port.h                   |   2 +
 drivers/net/dsa/ocelot/felix.c                     | 149 +++++++++++++++++--
 drivers/net/dsa/ocelot/felix.h                     |   1 +
 drivers/net/dsa/sja1105/sja1105_main.c             |   3 +-
 drivers/net/dsa/sja1105/sja1105_ptp.c              |  45 +-----
 drivers/net/dsa/sja1105/sja1105_ptp.h              |  19 ---
 drivers/net/ethernet/Kconfig                       |   1 +
 drivers/net/ethernet/arc/Kconfig                   |   1 +
 drivers/net/ethernet/intel/ice/ice_ptp.c           |  15 +-
 drivers/net/ethernet/mellanox/mlx5/core/cq.c       |   7 +-
 .../ethernet/mellanox/mlx5/core/en/rep/bridge.c    |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  61 +++++++-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |   6 +-
 drivers/net/ethernet/mellanox/mlxsw/core_thermal.c |  52 +------
 drivers/net/ethernet/microchip/encx24j600-regmap.c |  10 +-
 drivers/net/ethernet/microchip/encx24j600.c        |   5 +-
 drivers/net/ethernet/microchip/encx24j600_hw.h     |   4 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c      |   4 +-
 drivers/net/ethernet/mscc/ocelot.c                 | 107 +++++++++-----
 drivers/net/ethernet/mscc/ocelot_net.c             |   3 +-
 drivers/net/ethernet/neterion/s2io.c               |   2 +-
 drivers/net/ethernet/netronome/nfp/flower/main.c   |  19 ++-
 drivers/net/ethernet/pensando/ionic/ionic_lif.c    |   4 +
 drivers/net/ethernet/qlogic/qed/qed_main.c         |   1 +
 .../net/ethernet/stmicro/stmmac/dwmac-generic.c    |   1 +
 .../net/ethernet/stmicro/stmmac/dwmac1000_dma.c    |  13 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c   |   6 +-
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c |   6 +-
 drivers/net/ethernet/stmicro/stmmac/hwif.h         |   6 +-
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |   8 +
 drivers/net/phy/phy_device.c                       |   3 +
 drivers/net/usb/Kconfig                            |   4 +
 drivers/net/virtio_net.c                           |   2 +-
 include/linux/dsa/mv88e6xxx.h                      |  13 ++
 include/linux/dsa/ocelot.h                         |  49 ++++++
 include/linux/dsa/sja1105.h                        |  40 ++---
 include/linux/mlx5/mlx5_ifc.h                      |  10 +-
 include/soc/mscc/ocelot.h                          |  55 +------
 include/soc/mscc/ocelot_ptp.h                      |   3 +
 net/core/net-procfs.c                              |  24 ++-
 net/dsa/Kconfig                                    |   5 -
 net/dsa/dsa2.c                                     |   4 +-
 net/dsa/switch.c                                   |   2 +-
 net/dsa/tag_dsa.c                                  |  28 ++--
 net/dsa/tag_ocelot.c                               |   1 -
 net/dsa/tag_ocelot_8021q.c                         |  40 +++--
 net/dsa/tag_sja1105.c                              |  43 ++++++
 net/ipv4/icmp.c                                    |  23 ++-
 net/ipv6/ioam6.c                                   |  70 ++++++++-
 net/ipv6/ioam6_iptunnel.c                          |   6 +-
 net/mptcp/protocol.c                               |  55 ++-----
 net/nfc/af_nfc.c                                   |   3 +
 net/nfc/digital_core.c                             |   9 +-
 net/nfc/digital_technology.c                       |   8 +-
 net/nfc/nci/rsp.c                                  |   2 +
 net/sched/sch_mqprio.c                             |  30 ++--
 net/sctp/sm_make_chunk.c                           |   2 +-
 net/smc/smc_cdc.c                                  |   7 +-
 net/smc/smc_core.c                                 |  20 +--
 net/smc/smc_llc.c                                  |  63 ++++++--
 net/smc/smc_tx.c                                   |  22 +--
 net/smc/smc_wr.h                                   |  14 ++
 net/unix/af_unix.c                                 |   2 +-
 tools/testing/selftests/net/ioam6.sh               |  26 +++-
 tools/testing/selftests/net/ioam6_parser.c         | 164 ++++++++-------------
 74 files changed, 1009 insertions(+), 585 deletions(-)
 create mode 100644 include/linux/dsa/mv88e6xxx.h
