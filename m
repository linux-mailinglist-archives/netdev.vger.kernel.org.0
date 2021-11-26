Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 941FD45F619
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 21:56:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234453AbhKZU7p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 15:59:45 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:41824 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230158AbhKZU5o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 15:57:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8AD66B828FE;
        Fri, 26 Nov 2021 20:54:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB0DAC004E1;
        Fri, 26 Nov 2021 20:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637960068;
        bh=GMvOEQFOeLP4oTVEDOXwcPcPMeQUvWaBuHUbPOsuegg=;
        h=From:To:Cc:Subject:Date:From;
        b=RorrdDGPYl41Ggo5Vem05VBgF5+zf7geNJCko4n+rGIMPqLGxvkog7Xa9t+lQQS3c
         +ku2uf9jV219d3jN561Db8wI3NzFepQLBhOfOFBvVcGOK/bz60OLHGBeyFss3E+ye4
         p6j8CZXzIqTm9MfepzeI4xS4knK1iy7gUgi8tFD6LbvQrCuUyc+F+4q9uwJ07AcSQk
         qC6Lx3g7lBoBpuWbaSR12EWfAuJR7W1DEHEL4REpZWGqhaRok37qKuFdQdbCdy0IHA
         4C77kS9p3QKVmj0S68nUUoZFhD/Hm/C0bgF7TSoH/Z5Czq0I55NpIAseQfaXQefFRQ
         gEzSV6zifQiVQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 5.16-rc3
Date:   Fri, 26 Nov 2021 12:53:48 -0800
Message-Id: <20211126205348.1807629-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

The following changes since commit 8d0112ac6fd001f95aabb084ec2ccaa3637bc344:

  Merge tag 'net-5.16-rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2021-11-18 12:54:24 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.16-rc3

for you to fetch changes up to b3612ccdf2841c64ae7a8dd9e780c91240093fe6:

  net: dsa: microchip: implement multi-bridge support (2021-11-26 12:46:38 -0800)

----------------------------------------------------------------
Networking fixes for 5.16-rc3, including fixes from netfilter.

Current release - regressions:

 - r8169: fix incorrect mac address assignment

 - vlan: fix underflow for the real_dev refcnt when vlan creation fails

 - smc: avoid warning of possible recursive locking

Current release - new code bugs:

 - vsock/virtio: suppress used length validation

 - neigh: fix crash in v6 module initialization error path

Previous releases - regressions:

 - af_unix: fix change in behavior in read after shutdown

 - igb: fix netpoll exit with traffic, avoid warning

 - tls: fix splice_read() when starting mid-record

 - lan743x: fix deadlock in lan743x_phy_link_status_change()

 - marvell: prestera: fix bridge port operation

Previous releases - always broken:

 - tcp_cubic: fix spurious Hystart ACK train detections for
   not-cwnd-limited flows

 - nexthop: fix refcount issues when replacing IPv6 groups

 - nexthop: fix null pointer dereference when IPv6 is not enabled

 - phylink: force link down and retrigger resolve on interface change

 - mptcp: fix delack timer length calculation and incorrect early
   clearing

 - ieee802154: handle iftypes as u32, prevent shift-out-of-bounds

 - nfc: virtual_ncidev: change default device permissions

 - netfilter: ctnetlink: fix error codes and flags used for kernel side
   filtering of dumps

 - netfilter: flowtable: fix IPv6 tunnel addr match

 - ncsi: align payload to 32-bit to fix dropped packets

 - iavf: fix deadlock and loss of config during VF interface reset

 - ice: avoid bpf_prog refcount underflow

 - ocelot: fix broken PTP over IP and PTP API violations

Misc:

 - marvell: mvpp2: increase MTU limit when XDP enabled

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Alex Elder (3):
      net: ipa: directly disable ipa-setup-ready interrupt
      net: ipa: separate disabling setup from modem stop
      net: ipa: kill ipa_cmd_pipeline_clear()

Alexander Aring (1):
      net: ieee802154: handle iftypes as u32

Amit Cohen (1):
      mlxsw: spectrum: Protect driver from buggy firmware

Ansuel Smith (1):
      net: dsa: qca8k: fix internal delay applied to the wrong PAD config

Arnd Bergmann (1):
      nixge: fix mac address error handling again

Brett Creeley (1):
      iavf: Fix VLAN feature flags after VFR

Daniel Borkmann (1):
      net, neigh: Fix crash in v6 module initialization error path

Danielle Ratson (1):
      mlxsw: spectrum: Allow driver to load with old firmware versions

David S. Miller (8):
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf
      Merge branch '40GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net- queue
      Merge branch 'mptcp-rtx-timer'
      Merge branch 'nh-group-refcnt'
      Merge branch 'smc-fixes'
      Merge branch 'mlxsw-fixes'
      Merge branch 'ipa-fixes'
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue

Davide Caratti (1):
      net/sched: sch_ets: don't peek at classes beyond 'nbands'

Diana Wang (1):
      nfp: checking parameter process for rx-usecs/tx-usecs is invalid

Dylan Hung (1):
      mdio: aspeed: Fix "Link is Down" issue

Eric Dumazet (4):
      mptcp: fix delack timer
      ipv6: fix typos in __ip6_finish_output()
      tools: sync uapi/linux/if_link.h header
      tcp_cubic: fix spurious Hystart ACK train detections for not-cwnd-limited flows

Florent Fourcot (2):
      netfilter: ctnetlink: fix filtering with CTA_TUPLE_REPLY
      netfilter: ctnetlink: do not erase error code with EINVAL

Florian Fainelli (1):
      MAINTAINERS: Update B53 section to cover SF2 switch driver

Florian Westphal (3):
      selftests: netfilter: add a vrf+conntrack testcase
      selftests: netfilter: extend nfqueue tests to cover vrf device
      selftests: nft_nat: switch port shadow test cases to socat

Guangbin Huang (1):
      net: hns3: fix VF RSS failed problem after PF enable multi-TCs

Guo DaXing (1):
      net/smc: Fix loop in smc_listen

Hao Chen (2):
      net: hns3: add check NULL address for page pool
      net: hns3: fix one incorrect value of page pool info when queried by debugfs

Heiner Kallweit (2):
      r8169: fix incorrect mac address assignment
      lan743x: fix deadlock in lan743x_phy_link_status_change()

Holger Assmann (1):
      net: stmmac: retain PTP clock time during SIOCSHWTSTAMP ioctls

Huang Pei (2):
      hamradio: fix macro redefine warning
      slip: fix macro redefine warning

Jakub Kicinski (16):
      Merge tag 'ieee802154-for-net-2021-11-24' of git://git.kernel.org/pub/scm/linux/kernel/git/sschmidt/wpan
      Merge branch 'phylink-resolve-fixes'
      Merge branch 'net-smc-fixes-2021-11-24'
      selftests: tls: add helper for creating sock pairs
      selftests: tls: factor out cmsg send/receive
      selftests: tls: add tests for handling of bad records
      tls: splice_read: fix record type check
      selftests: tls: test splicing cmsgs
      tls: splice_read: fix accessing pre-processed records
      selftests: tls: test splicing decrypted records
      tls: fix replacing proto_ops
      selftests: tls: test for correct proto_ops
      Merge branch 'tls-splice_read-fixes'
      ptp: fix filter names in the documentation
      Merge branch 'net-hns3-add-some-fixes-for-net'
      Merge branch 'fix-broken-ptp-over-ip-on-ocelot-switches'

Jamal Hadi Salim (1):
      tc-testing: Add link for reviews with TC MAINTAINERS

James Prestwood (1):
      selftests: add arp_ndisc_evict_nocarrier to Makefile

Jedrzej Jagielski (2):
      iavf: Fix deadlock occurrence during resetting VF interface
      iavf: Fix refreshing iavf adapter stats on ethtool request

Jesse Brandeburg (1):
      igb: fix netpoll exit with traffic

Jie Wang (1):
      net: hns3: fix incorrect components info of ethtool --reset command

Jing Yao (1):
      netfilter: xt_IDLETIMER: replace snprintf in show functions with sysfs_emit

Julian Wiedmann (1):
      ethtool: ioctl: fix potential NULL deref in ethtool_set_coalesce()

Karsten Graul (1):
      net/smc: Fix NULL pointer dereferencing in smc_vlan_by_tcpsk()

Kumar Thangavel (1):
      net/ncsi : Add payload to be 32-bit aligned to fix dropped packets

Li Zhijian (2):
      selftests/tc-testing: match any qdisc type
      selftests/tc-testings: Be compatible with newer tc output

Maciej Fijalkowski (1):
      ice: fix vsi->txq_map sizing

Marek Behún (1):
      net: marvell: mvpp2: increase MTU limit when XDP enabled

Marta Plantykow (1):
      ice: avoid bpf_prog refcount underflow

Martyn Welch (1):
      net: usb: Correct PHY handling of smsc95xx

Michael S. Tsirkin (1):
      vsock/virtio: suppress used length validation

Nicolas Iooss (1):
      net: ax88796c: do not receive data in pointer

Nikolay Aleksandrov (4):
      net: ipv6: add fib6_nh_release_dsts stub
      net: nexthop: release IPv6 per-cpu dsts when replacing a nexthop group
      selftests: net: fib_nexthops: add test for group refcount imbalance bug
      net: nexthop: fix null pointer dereference when IPv6 is not enabled

Nitesh B Venkatesh (1):
      iavf: Prevent changing static ITR values if adaptive moderation is on

Oleksij Rempel (1):
      net: dsa: microchip: implement multi-bridge support

Paolo Abeni (1):
      mptcp: use delegate action to schedule 3rd ack retrans

Phil Sutter (2):
      selftests: nft_nat: Improve port shadow test stability
      selftests: nft_nat: Simplify port shadow notrack test

Robert Marko (1):
      net: dsa: qca8k: fix MTU calculation

Russell King (Oracle) (2):
      net: phylink: Force link down and retrigger resolve on interface change
      net: phylink: Force retrigger in case of latched link-fail indicator

Thadeu Lima de Souza Cascardo (1):
      nfc: virtual_ncidev: change default device permissions

Tony Lu (3):
      net/smc: Clean up local struct sock variables
      net/smc: Ensure the active closing peer first closes clcsock
      net/smc: Don't call clcsock shutdown twice when smc shutdown

Vincent Whitchurch (1):
      af_unix: fix regression in read after shutdown

Vladimir Oltean (5):
      net: mscc: ocelot: don't downgrade timestamping RX filters in SIOCSHWTSTAMP
      net: mscc: ocelot: create a function that replaces an existing VCAP filter
      net: ptp: add a definition for the UDP port for IEEE 1588 general messages
      net: mscc: ocelot: set up traps for PTP packets
      net: mscc: ocelot: correctly report the timestamping RX filters in ethtool

Volodymyr Mytnyk (2):
      net: marvell: prestera: fix brige port operation
      net: marvell: prestera: fix double free issue on err path

Wan Jiabing (1):
      netfilter: nft_payload: Remove duplicated include in nft_payload.c

Wen Gu (1):
      net/smc: Avoid warning of possible recursive locking

Will Mortensen (1):
      netfilter: flowtable: fix IPv6 tunnel addr match

Yannick Vignon (1):
      net: stmmac: Disable Tx queues when reconfiguring the interface

Zekun Shen (2):
      atlantic: fix double-free in aq_ring_tx_clean
      stmmac_pci: Fix underflow size in stmmac_rx

Zheyu Ma (1):
      net: chelsio: cxgb4vf: Fix an error code in cxgb4vf_pci_probe()

Ziyang Xuan (1):
      net: vlan: fix underflow for the real_dev refcnt

yangxingwu (1):
      netfilter: ipvs: Fix reuse connection if RS weight is 0

zhangyue (1):
      net: qed: fix the array may be out of bound

 Documentation/networking/ipvs-sysctl.rst           |   3 +-
 Documentation/networking/timestamping.rst          |   4 +-
 MAINTAINERS                                        |   4 +-
 drivers/net/dsa/microchip/ksz8795.c                |  56 +--
 drivers/net/dsa/microchip/ksz9477.c                |  66 +--
 drivers/net/dsa/microchip/ksz_common.c             |  50 +-
 drivers/net/dsa/microchip/ksz_common.h             |   4 -
 drivers/net/dsa/qca8k.c                            |  18 +-
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c   |   3 +-
 drivers/net/ethernet/asix/ax88796c_spi.c           |   2 +-
 .../net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c    |   1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |   8 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |   4 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |   4 +-
 drivers/net/ethernet/intel/iavf/iavf.h             |   3 +
 drivers/net/ethernet/intel/iavf/iavf_ethtool.c     |  33 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |  58 ++-
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c    |  47 +-
 drivers/net/ethernet/intel/ice/ice_lib.c           |   9 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |  18 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |   2 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |  14 +-
 .../ethernet/marvell/prestera/prestera_switchdev.c |   8 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     |  10 +-
 drivers/net/ethernet/microchip/lan743x_main.c      |  12 +-
 drivers/net/ethernet/mscc/ocelot.c                 | 252 +++++++++-
 drivers/net/ethernet/mscc/ocelot_vcap.c            |  16 +
 drivers/net/ethernet/netronome/nfp/nfp_net.h       |   3 -
 .../net/ethernet/netronome/nfp/nfp_net_ethtool.c   |   2 +-
 drivers/net/ethernet/ni/nixge.c                    |   4 +-
 drivers/net/ethernet/qlogic/qed/qed_int.c          |   6 +-
 drivers/net/ethernet/realtek/r8169_main.c          |   5 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       |   1 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  | 136 ++++--
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |   2 +-
 drivers/net/hamradio/mkiss.c                       |   2 +
 drivers/net/ipa/ipa_cmd.c                          |  16 -
 drivers/net/ipa/ipa_cmd.h                          |   6 -
 drivers/net/ipa/ipa_endpoint.c                     |   2 -
 drivers/net/ipa/ipa_main.c                         |   6 +
 drivers/net/ipa/ipa_modem.c                        |   6 +-
 drivers/net/ipa/ipa_smp2p.c                        |  21 +-
 drivers/net/ipa/ipa_smp2p.h                        |   7 +-
 drivers/net/mdio/mdio-aspeed.c                     |   7 +
 drivers/net/phy/phylink.c                          |  26 +-
 drivers/net/slip/slip.h                            |   2 +
 drivers/net/usb/smsc95xx.c                         |  55 +--
 drivers/nfc/virtual_ncidev.c                       |   2 +-
 include/linux/ptp_classify.h                       |   1 +
 include/net/ip6_fib.h                              |   1 +
 include/net/ipv6_stubs.h                           |   1 +
 include/net/nl802154.h                             |   7 +-
 include/soc/mscc/ocelot_vcap.h                     |   2 +
 net/8021q/vlan.c                                   |   3 -
 net/8021q/vlan_dev.c                               |   3 +
 net/core/neighbour.c                               |   1 +
 net/ethtool/ioctl.c                                |   2 +-
 net/ipv4/nexthop.c                                 |  35 +-
 net/ipv4/tcp_cubic.c                               |   5 +-
 net/ipv6/af_inet6.c                                |   1 +
 net/ipv6/ip6_output.c                              |   2 +-
 net/ipv6/route.c                                   |  19 +
 net/mptcp/options.c                                |  32 +-
 net/mptcp/protocol.c                               |  51 +-
 net/mptcp/protocol.h                               |  17 +-
 net/ncsi/ncsi-cmd.c                                |  24 +-
 net/netfilter/ipvs/ip_vs_core.c                    |   8 +-
 net/netfilter/nf_conntrack_netlink.c               |   6 +-
 net/netfilter/nf_flow_table_offload.c              |   4 +-
 net/netfilter/nft_payload.c                        |   1 -
 net/netfilter/xt_IDLETIMER.c                       |   4 +-
 net/sched/sch_ets.c                                |   8 +-
 net/smc/af_smc.c                                   |  14 +-
 net/smc/smc_close.c                                |  10 +-
 net/smc/smc_core.c                                 |  35 +-
 net/tls/tls_main.c                                 |  47 +-
 net/tls/tls_sw.c                                   |  40 +-
 net/unix/af_unix.c                                 |   3 -
 net/vmw_vsock/virtio_transport.c                   |   1 +
 tools/include/uapi/linux/if_link.h                 | 293 ++++++++++--
 tools/testing/selftests/net/Makefile               |   1 +
 tools/testing/selftests/net/fib_nexthops.sh        |  63 +++
 tools/testing/selftests/net/tls.c                  | 521 +++++++++++++++------
 tools/testing/selftests/netfilter/Makefile         |   3 +-
 tools/testing/selftests/netfilter/conntrack_vrf.sh | 219 +++++++++
 tools/testing/selftests/netfilter/nft_nat.sh       |  33 +-
 tools/testing/selftests/netfilter/nft_queue.sh     |  54 +++
 .../selftests/tc-testing/tc-tests/actions/bpf.json |   2 +-
 .../selftests/tc-testing/tc-tests/qdiscs/mq.json   |  12 +-
 89 files changed, 1956 insertions(+), 659 deletions(-)
 create mode 100755 tools/testing/selftests/netfilter/conntrack_vrf.sh
