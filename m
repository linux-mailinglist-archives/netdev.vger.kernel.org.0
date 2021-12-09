Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E56B346F185
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 18:21:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242747AbhLIRZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 12:25:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242745AbhLIRZK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 12:25:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 777E9C061746;
        Thu,  9 Dec 2021 09:21:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 185DBB825CC;
        Thu,  9 Dec 2021 17:21:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A733C004DD;
        Thu,  9 Dec 2021 17:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639070493;
        bh=dFm/yKsP0tLbFPrh4KDLLSE/DeK+Io5iRJhbfgNKOBQ=;
        h=From:To:Cc:Subject:Date:From;
        b=UGhryAvNMAui9R+sN0ziK0MN9SOhUcnW6Ot9ISUkd0Dojuyt3XJUJn1+gP2nuxu5k
         mOhUcNI9zkk+n9P9hicuKxw2JpRoKkH8ZwnFtIgrqYogskxtk74Rx5/XUtri4IktFc
         QmKsbAgQ1x0Jaor1LDqgG0KE4MZ7K8Fgi3lYwlvj0OD5ttCwWOLRQfbQh5AQYmDksr
         gI/9yU3tUCXG/heWNWthxmbqrTdEtdcATyKelpqpsDup18M2oSeqY8bOwsmngrKYh0
         Zjj1nddPmgIBxc6R4rI5y45CbLUKlFXbv4B40Zo3bESIGTjUSrRCsdQsHdsZUCIxy/
         yc/U6iNyj8q6g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, linux-can@vger.kernel.org
Subject: [GIT PULL] Networking for 5.16-rc5
Date:   Thu,  9 Dec 2021 09:20:32 -0800
Message-Id: <20211209172032.610738-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

The following changes since commit a51e3ac43ddbad891c2b1a4f3aa52371d6939570:

  Merge tag 'net-5.16-rc4' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2021-12-02 11:22:06 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.16-rc5

for you to fetch changes up to 04ec4e6250e5f58b525b08f3dca45c7d7427620e:

  net: dsa: mv88e6xxx: allow use of PHYs on CPU and DSA ports (2021-12-09 08:48:40 -0800)

----------------------------------------------------------------
Networking fixes for 5.16-rc5, including fixes from bpf, can and netfilter.

Current release - regressions:

 - bpf, sockmap: re-evaluate proto ops when psock is removed from sockmap

Current release - new code bugs:

 - bpf: fix bpf_check_mod_kfunc_call for built-in modules

 - ice: fixes for TC classifier offloads

 - vrf: don't run conntrack on vrf with !dflt qdisc

Previous releases - regressions:

 - bpf: fix the off-by-two error in range markings

 - seg6: fix the iif in the IPv6 socket control block

 - devlink: fix netns refcount leak in devlink_nl_cmd_reload()

 - dsa: mv88e6xxx: fix "don't use PHY_DETECT on internal PHY's"

 - dsa: mv88e6xxx: allow use of PHYs on CPU and DSA ports

Previous releases - always broken:

 - ethtool: do not perform operations on net devices being unregistered

 - udp: use datalen to cap max gso segments

 - ice: fix races in stats collection

 - fec: only clear interrupt of handling queue in fec_enet_rx_queue()

 - m_can: pci: fix incorrect reference clock rate

 - m_can: disable and ignore ELO interrupt

 - mvpp2: fix XDP rx queues registering

Misc:

 - treewide: add missing includes masked by cgroup -> bpf.h dependency

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Ameer Hamza (2):
      gve: fix for null pointer dereference.
      net: dsa: mv88e6xxx: error handling for serdes_power functions

Andrea Mayer (1):
      seg6: fix the iif in the IPv6 socket control block

Andrii Nakryiko (1):
      Merge branch 'Fixes for kfunc-mod regressions and warnings'

Antoine Tenart (1):
      ethtool: do not perform operations on net devices being unregistered

Björn Töpel (1):
      bpf, x86: Fix "no previous prototype" warning

Brian Silverman (1):
      can: m_can: Disable and ignore ELO interrupt

Dan Carpenter (3):
      net: altera: set a couple error code in probe()
      can: sja1000: fix use after free in ems_pcmcia_add_card()
      net/qla3xxx: fix an error code in ql_adapter_up()

Dave Ertman (1):
      ice: Fix problems with DSCP QoS implementation

Eric Dumazet (7):
      inet: use #ifdef CONFIG_SOCK_RX_QUEUE_MAPPING consistently
      tcp: fix another uninit-value (sk_rx_queue_mapping)
      bonding: make tx_rebalance_counter an atomic
      devlink: fix netns refcount leak in devlink_nl_cmd_reload()
      netfilter: conntrack: annotate data-races around ct->timeout
      net, neigh: clear whole pneigh_entry at alloc time
      net/sched: fq_pie: prevent dismantle issue

Florian Westphal (2):
      netfilter: nfnetlink_queue: silence bogus compiler warning
      selftests: netfilter: switch zone stress to socat

Jakub Kicinski (10):
      treewide: Add missing includes masked by cgroup -> bpf dependency
      Merge tag 'linux-can-fixes-for-5.16-20211207' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can
      Merge branch 'net-tls-cover-all-ciphers-with-tests'
      Merge branch 'net-phy-fix-doc-build-warning'
      Merge branch '40GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      Merge https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf
      Merge tag 'linux-can-fixes-for-5.16-20211209' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can
      Merge branch 'net-wwan-iosm-bug-fixes'

Jesse Brandeburg (2):
      ice: ignore dropped packets during init
      ice: safer stats processing

Jianglei Nie (1):
      nfp: Fix memory leak in nfp_cpp_area_cache_add()

Jianguo Wu (1):
      udp: using datalen to cap max gso segments

Jiasheng Jiang (1):
      net: bcm4908: Handle dma_set_coherent_mask error codes

Jimmy Assarsson (2):
      can: kvaser_pciefd: kvaser_pciefd_rx_error_frame(): increase correct stats->{rx,tx}_errors counter
      can: kvaser_usb: get CAN clock frequency from device

Joakim Zhang (1):
      net: fec: only clear interrupt of handling queue in fec_enet_rx_queue()

Johan Almbladh (1):
      mips, bpf: Fix reference to non-existing Kconfig symbol

John Fastabend (2):
      bpf, sockmap: Attach map progs to psock early for feature probes
      bpf, sockmap: Re-evaluate proto ops when psock is removed from sockmap

José Expósito (2):
      net: mana: Fix memory leak in mana_hwc_create_wq
      net: dsa: felix: Fix memory leak in felix_setup_mmio_filtering

Julian Wiedmann (1):
      MAINTAINERS: s390/net: remove myself as maintainer

Karen Sornek (1):
      i40e: Fix failed opcode appearing if handling messages from VF

Krzysztof Kozlowski (1):
      nfc: fix potential NULL pointer deref in nfc_genl_dump_ses_done

Kumar Kartikeya Dwivedi (3):
      bpf: Make CONFIG_DEBUG_INFO_BTF depend upon CONFIG_BPF_SYSCALL
      bpf: Fix bpf_check_mod_kfunc_call for built-in modules
      tools/resolve_btfids: Skip unresolved symbol warning for empty BTF sets

Lee Jones (1):
      net: cdc_ncm: Allow for dwNtbOutMaxSize to be unset or zero

Li Zhijian (4):
      selftests/tc-testing: add exit code
      selftests/tc-testing: add missing config
      selftests/tc-testing: Fix cannot create /sys/bus/netdevsim/new_device: Directory nonexistent
      selftests: net/fcnal-test.sh: add exit code

Louis Amas (1):
      net: mvpp2: fix XDP rx queues registering

M Chetan Kumar (3):
      net: wwan: iosm: fixes unnecessary doorbell send
      net: wwan: iosm: fixes net interface nonfunctional after fw flash
      net: wwan: iosm: fixes unable to send AT command during mbim tx

Manish Chopra (1):
      qede: validate non LSO skb length

Mateusz Palczewski (1):
      i40e: Fix pre-set max number of queues for VF

Matthias Schiffer (5):
      can: m_can: pci: fix iomap_read_fifo() and iomap_write_fifo()
      can: m_can: pci: fix incorrect reference clock rate
      Revert "can: m_can: remove support for custom bit timing"
      can: m_can: make custom bittiming fields const
      can: m_can: pci: use custom bit timings for Elkhart Lake

Maxim Mikityanskiy (2):
      bpf: Fix the off-by-two error in range markings
      bpf: Add selftests to cover packet access corner cases

Michal Maloszewski (1):
      iavf: Fix reporting when setting descriptor count

Michal Swiatkowski (2):
      ice: fix choosing UDP header type
      ice: fix adding different tunnels

Mitch Williams (1):
      iavf: restore MSI state on reset

Nicolas Dichtel (1):
      vrf: don't run conntrack on vrf with !dflt qdisc

Norbert Zulinski (1):
      i40e: Fix NULL pointer dereference in i40e_dbg_dump_desc

Pablo Neira Ayuso (1):
      netfilter: nft_exthdr: break evaluation if setting TCP option fails

Paul Greenwalt (1):
      ice: rearm other interrupt cause register after enabling VFs

Peilin Ye (1):
      selftests/fib_tests: Rework fib_rp_filter_test()

Petr Machata (1):
      MAINTAINERS: net: mlxsw: Remove Jiri as a maintainer, add myself

Ronak Doshi (1):
      vmxnet3: fix minimum vectors alloc issue

Russell King (Oracle) (2):
      net: dsa: mv88e6xxx: fix "don't use PHY_DETECT on internal PHY's"
      net: dsa: mv88e6xxx: allow use of PHYs on CPU and DSA ports

Sebastian Andrzej Siewior (2):
      Documentation/locking/locktypes: Update migrate_disable() bits.
      bpf: Make sure bpf_disable_instrumentation() is safe vs preemption.

Stefano Brivio (2):
      nft_set_pipapo: Fix bucket load in AVX2 lookup routine for six 8-bit groups
      selftests: netfilter: Add correctness test for mac,net set type

Tadeusz Struk (1):
      nfc: fix segfault in nfc_genl_dump_devices_done

Vadim Fedorenko (2):
      selftests: tls: add missing AES-CCM cipher tests
      selftests: tls: add missing AES256-GCM cipher

Vincent Mailhol (2):
      can: pch_can: pch_can_rx_normal: fix use after free
      can: m_can: m_can_read_fifo: fix memory leak in error branch

Yahui Cao (1):
      ice: fix FDIR init missing when reset VF

Yanteng Si (2):
      net: phy: Remove unnecessary indentation in the comments of phy_device
      net: phy: Add the missing blank line in the phylink_suspend comment

 Documentation/locking/locktypes.rst                |   9 +-
 MAINTAINERS                                        |   4 +-
 arch/mips/net/bpf_jit_comp.h                       |   2 +-
 block/fops.c                                       |   1 +
 drivers/gpu/drm/drm_gem_shmem_helper.c             |   1 +
 drivers/gpu/drm/i915/gt/intel_gtt.c                |   1 +
 drivers/gpu/drm/i915/i915_request.c                |   1 +
 drivers/gpu/drm/lima/lima_device.c                 |   1 +
 drivers/gpu/drm/msm/msm_gem_shrinker.c             |   1 +
 drivers/gpu/drm/ttm/ttm_tt.c                       |   1 +
 drivers/net/bonding/bond_alb.c                     |  14 +-
 drivers/net/can/kvaser_pciefd.c                    |   8 +-
 drivers/net/can/m_can/m_can.c                      |  42 +-
 drivers/net/can/m_can/m_can.h                      |   3 +
 drivers/net/can/m_can/m_can_pci.c                  |  62 +-
 drivers/net/can/pch_can.c                          |   2 +-
 drivers/net/can/sja1000/ems_pcmcia.c               |   7 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c   | 101 +++-
 drivers/net/dsa/mv88e6xxx/chip.c                   |  85 +--
 drivers/net/dsa/mv88e6xxx/serdes.c                 |   8 +-
 drivers/net/dsa/ocelot/felix.c                     |   5 +-
 drivers/net/ethernet/altera/altera_tse_main.c      |   9 +-
 drivers/net/ethernet/broadcom/bcm4908_enet.c       |   4 +-
 drivers/net/ethernet/freescale/fec.h               |   3 +
 drivers/net/ethernet/freescale/fec_main.c          |   2 +-
 drivers/net/ethernet/google/gve/gve_utils.c        |   3 +
 drivers/net/ethernet/huawei/hinic/hinic_sriov.c    |   1 +
 drivers/net/ethernet/intel/i40e/i40e_debugfs.c     |   8 +
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |  75 ++-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h |   2 +
 drivers/net/ethernet/intel/iavf/iavf_ethtool.c     |  43 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |   1 +
 drivers/net/ethernet/intel/ice/ice_dcb_nl.c        |  18 +-
 drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c  |   4 +-
 drivers/net/ethernet/intel/ice/ice_fdir.c          |   2 +-
 drivers/net/ethernet/intel/ice/ice_flex_pipe.c     |   7 +-
 drivers/net/ethernet/intel/ice/ice_flex_pipe.h     |   3 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |  32 +-
 drivers/net/ethernet/intel/ice/ice_switch.c        |  19 +-
 drivers/net/ethernet/intel/ice/ice_tc_lib.c        |  30 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c   |   6 +
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |   4 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_ptp.c  |   2 +
 drivers/net/ethernet/microsoft/mana/hw_channel.c   |  10 +-
 .../ethernet/netronome/nfp/nfpcore/nfp_cppcore.c   |   4 +-
 drivers/net/ethernet/qlogic/qede/qede_fp.c         |   7 +
 drivers/net/ethernet/qlogic/qla3xxx.c              |  19 +-
 drivers/net/phy/phylink.c                          |   1 +
 drivers/net/usb/cdc_ncm.c                          |   2 +
 drivers/net/vmxnet3/vmxnet3_drv.c                  |  13 +-
 drivers/net/vrf.c                                  |   8 +-
 drivers/net/wwan/iosm/iosm_ipc_imem.c              |  26 +-
 drivers/net/wwan/iosm/iosm_ipc_imem.h              |   4 +-
 drivers/net/wwan/iosm/iosm_ipc_imem_ops.c          |   7 +-
 drivers/pci/controller/dwc/pci-exynos.c            |   1 +
 drivers/pci/controller/dwc/pcie-qcom-ep.c          |   1 +
 drivers/usb/cdns3/host.c                           |   1 +
 include/linux/bpf.h                                |  17 +-
 include/linux/btf.h                                |  14 +-
 include/linux/cacheinfo.h                          |   1 -
 include/linux/device/driver.h                      |   1 +
 include/linux/filter.h                             |   5 +-
 include/linux/phy.h                                |  11 +-
 include/net/bond_alb.h                             |   2 +-
 include/net/busy_poll.h                            |  13 +
 include/net/netfilter/nf_conntrack.h               |   6 +-
 kernel/bpf/btf.c                                   |  11 +-
 kernel/bpf/verifier.c                              |   2 +-
 lib/Kconfig.debug                                  |   1 +
 mm/damon/vaddr.c                                   |   1 +
 mm/memory_hotplug.c                                |   1 +
 mm/swap_slots.c                                    |   1 +
 net/core/devlink.c                                 |  16 +-
 net/core/neighbour.c                               |   3 +-
 net/core/skmsg.c                                   |   5 +
 net/core/sock_map.c                                |  15 +-
 net/ethtool/netlink.c                              |   3 +-
 net/ipv4/inet_connection_sock.c                    |   2 +-
 net/ipv4/tcp_minisocks.c                           |   4 +-
 net/ipv4/udp.c                                     |   2 +-
 net/ipv6/seg6_iptunnel.c                           |   8 +
 net/netfilter/nf_conntrack_core.c                  |   6 +-
 net/netfilter/nf_conntrack_netlink.c               |   2 +-
 net/netfilter/nf_flow_table_core.c                 |   4 +-
 net/netfilter/nfnetlink_queue.c                    |   2 +-
 net/netfilter/nft_exthdr.c                         |  11 +-
 net/netfilter/nft_set_pipapo_avx2.c                |   2 +-
 net/nfc/netlink.c                                  |  12 +-
 net/sched/sch_fq_pie.c                             |   1 +
 tools/bpf/resolve_btfids/main.c                    |   8 +-
 .../bpf/verifier/xdp_direct_packet_access.c        | 632 +++++++++++++++++++--
 tools/testing/selftests/net/fcnal-test.sh          |   8 +
 tools/testing/selftests/net/fib_tests.sh           |  59 +-
 tools/testing/selftests/net/tls.c                  |  36 ++
 tools/testing/selftests/netfilter/conntrack_vrf.sh |  30 +-
 .../selftests/netfilter/nft_concat_range.sh        |  24 +-
 .../testing/selftests/netfilter/nft_zones_many.sh  |  19 +-
 tools/testing/selftests/tc-testing/config          |   2 +
 tools/testing/selftests/tc-testing/tdc.py          |   8 +-
 tools/testing/selftests/tc-testing/tdc.sh          |   1 +
 100 files changed, 1370 insertions(+), 383 deletions(-)
