Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37BC268890E
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 22:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231614AbjBBVeo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 16:34:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbjBBVen (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 16:34:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D90D76B03B;
        Thu,  2 Feb 2023 13:34:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6FFC061D03;
        Thu,  2 Feb 2023 21:34:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B310C433D2;
        Thu,  2 Feb 2023 21:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675373680;
        bh=dS9qvWMBe5alhwHU+UsYZ35oy5ua4fzl14ve0YZ5STE=;
        h=From:To:Cc:Subject:Date:From;
        b=kgwuyF8V3V7iHlh3zTthdVqXfmVm/WhHWLQvw8/fAMZE/rfHe8Qzn1kQqB+29wUJ0
         z26U6HjlmVIGu+C1Jc87NT0xLAHK+hpTmaXUeY71LFW6zBzwvz8FC8wvjLNRtsXqeu
         kI+AAgl8FjbZhmMsdGSg2XGu+rXgw/PCDw9KqQDyZpix3EVmza2JMsv7sNZIEi0oWj
         mj0uiiwf43++mCacuTfE6qgZWEl39tPg28Pl7LIfYyso48cLaKdwab/JB4Rtyn07Ul
         zeAtrY0z5kz5+QfkmR2ba3CX0lCncNBmwSC5nsOdbD7ZUdDIUQl+hAgWg3pvmtS1jn
         XjlTn+hQGGL9w==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pabeni@redhat.com
Subject: [PULL] Networking for v6.2-rc7
Date:   Thu,  2 Feb 2023 13:34:39 -0800
Message-Id: <20230202213439.3065404-1-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

No outstanding regressions, quite calm (knock wood).

The following changes since commit 28b4387f0ec08d48634fcc3e3687c93edc1503f9:

  Merge tag 'net-6.2-rc6' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2023-01-26 10:20:12 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.2-rc7

for you to fetch changes up to 9983a2c986534db004b50d95b7fe64bb9b925dca:

  Merge branch 'fixes-for-mtk_eth_soc' (2023-02-02 11:55:55 -0800)

----------------------------------------------------------------
Including fixes from bpf, can and netfilter.

Current release - regressions:

 - phy: fix null-deref in phy_attach_direct

 - mac802154: fix possible double free upon parsing error

Previous releases - regressions:

 - bpf: preserve reg parent/live fields when copying range info,
   prevent mis-verification of programs as safe

 - ip6: fix GRE tunnels not generating IPv6 link local addresses

 - phy: dp83822: fix null-deref on DP83825/DP83826 devices

 - sctp: do not check hb_timer.expires when resetting hb_timer

 - eth: mtk_sock: fix SGMII configuration after phylink conversion

Previous releases - always broken:

 - eth: xdp: execute xdp_do_flush() before napi_complete_done()

 - skb: do not mix page pool and page referenced frags in GRO

 - bpf:
   - fix a possible task gone issue with bpf_send_signal[_thread]()
   - fix an off-by-one bug in bpf_mem_cache_idx() to select
     the right cache
   - add missing btf_put to register_btf_id_dtor_kfuncs
   - sockmap: fon't let sock_map_{close,destroy,unhash} call itself

 - gso: fix null-deref in skb_segment_list()

 - mctp: purge receive queues on sk destruction

 - fix UaF caused by accept on already connected socket in exotic
   socket families

 - tls: don't treat list head as an entry in tls_is_tx_ready()

 - netfilter: br_netfilter: disable sabotage_in hook after first
   suppression

 - wwan: t7xx: fix runtime PM implementation

Misc:

 - MAINTAINERS: spring cleanup of networking maintainers

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Alexander Couzens (2):
      net: mediatek: sgmii: ensure the SGMII PHY is powered down on configuration
      mtk_sgmii: enable PCS polling to allow SFP work

Alexander Duyck (1):
      skb: Do mix page pool and page referenced frags in GRO

Alexei Starovoitov (2):
      Merge branch 'bpf: Fix to preserve reg parent/live fields when copying range info'
      Merge branch 'bpf, sockmap: Fix infinite recursion in sock_map_close'

Andre Kalb (1):
      net: phy: dp83822: Fix null pointer access on DP83825/DP83826 devices

Andrei Gherzan (5):
      selftest: net: Improve IPV6_TCLASS/IPV6_HOPLIMIT tests apparmor compatibility
      selftests: net: udpgso_bench_rx: Fix 'used uninitialized' compiler warning
      selftests: net: udpgso_bench_rx/tx: Stop when wrong CLI args are provided
      selftests: net: udpgso_bench: Fix racing bug between the rx/tx programs
      selftests: net: udpgso_bench_tx: Cater for pending datagrams zerocopy benchmarking

Andrey Konovalov (1):
      net: stmmac: do not stop RX_CLK in Rx LPI state for qcs404 SoC

Arınç ÜNAL (2):
      net: dsa: mt7530: fix tristate and help description
      net: ethernet: mtk_eth_soc: disable hardware DSA untagging for second MAC

Bjørn Mork (1):
      net: mediatek: sgmii: fix duplex configuration

Chris Healy (1):
      net: phy: meson-gxl: Add generic dummy stubs for MMD register access

Colin Foster (1):
      net: phy: fix null dereference in phy_attach_direct

Dave Ertman (1):
      ice: Prevent set_channel from changing queues while RDMA active

David S. Miller (1):
      Merge branch 't7xx-pm-fixes'

Eduard Zingerman (2):
      bpf: Fix to preserve reg parent/live fields when copying range info
      selftests/bpf: Verify copy_register_state() preserves parent/live fields

Fedor Pchelkin (1):
      net: openvswitch: fix flow memory leak in ovs_flow_cmd_new

Florian Westphal (2):
      netfilter: br_netfilter: disable sabotage_in hook after first suppression
      Revert "netfilter: conntrack: fix bug in for_each_sctp_chunk"

Hou Tao (1):
      bpf: Fix off-by-one error in bpf_mem_cache_idx()

Hyunwoo Kim (2):
      net/rose: Fix to not accept on connected socket
      netrom: Fix use-after-free caused by accept on already connected socket

Jakub Kicinski (13):
      Merge branch 'net-xdp-execute-xdp_do_flush-before-napi_complete_done'
      Merge tag 'for-netdev' of https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      Merge tag 'ieee802154-for-net-2023-01-30' of git://git.kernel.org/pub/scm/linux/kernel/git/sschmidt/wpan
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf
      Merge branch 'ip-ip6_gre-fix-gre-tunnels-not-generating-ipv6-link-local-addresses'
      MAINTAINERS: bonding: move Veaceslav Falico to CREDITS
      mailmap: add John Crispin's entry
      MAINTAINERS: ipv6: retire Hideaki Yoshifuji
      MAINTAINERS: update SCTP maintainers
      Merge branch 'maintainers-spring-refresh-of-networking-maintainers'
      Merge tag 'linux-can-fixes-for-6.2-20230202' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can
      Merge branch 'fixes-for-mtk_eth_soc'

Jakub Sitnicki (4):
      bpf, sockmap: Don't let sock_map_{close,destroy,unhash} call itself
      bpf, sockmap: Check for any of tcp_bpf_prots when cloning a listener
      selftests/bpf: Pass BPF skeleton to sockmap_listen ops tests
      selftests/bpf: Cover listener cloning with progs attached to sockmap

Jeremy Kerr (1):
      net: mctp: purge receive queues on sk destruction

Jiri Olsa (1):
      bpf: Add missing btf_put to register_btf_id_dtor_kfuncs

Kees Cook (2):
      net: ethernet: mtk_eth_soc: Avoid truncating allocation
      net: sched: sch: Bounds check priority

Kornel Dulęba (2):
      net: wwan: t7xx: Fix Runtime PM resume sequence
      net: wwan: t7xx: Fix Runtime PM initialization

Kui-Feng Lee (1):
      bpf: Fix the kernel crash caused by bpf_setsockopt().

Magnus Karlsson (5):
      qede: execute xdp_do_flush() before napi_complete_done()
      lan966x: execute xdp_do_flush() before napi_complete_done()
      virtio-net: execute xdp_do_flush() before napi_complete_done()
      dpaa_eth: execute xdp_do_flush() before napi_complete_done()
      dpaa2-eth: execute xdp_do_flush() before napi_complete_done()

Marc Kleine-Budde (1):
      can: mcp251xfd: mcp251xfd_ring_set_ringparam(): assign missing tx_obj_num_coalesce_irq

Michael Kelley (1):
      hv_netvsc: Fix missed pagebuf entries in netvsc_dma_map/unmap()

Michal Wilczynski (1):
      ice: Fix broken link in ice NAPI doc

Miquel Raynal (1):
      mac802154: Fix possible double free upon parsing error

Natalia Petrova (1):
      net: qrtr: free memory on error path in radix_tree_insert()

Oliver Hartkopp (3):
      can: raw: fix CAN FD frame transmissions over CAN XL devices
      can: isotp: handle wait_event_interruptible() return values
      can: isotp: split tx timer into transmission and timeout

Parav Pandit (1):
      virtio-net: Keep stop() to follow mirror sequence of open()

Pietro Borrello (1):
      net/tls: tls_is_tx_ready() checked list_entry

Ratheesh Kannoth (1):
      octeontx2-af: Fix devlink unregister

Thomas Winter (2):
      ip/ip6_gre: Fix changing addr gen mode not generating IPv6 link local address
      ip/ip6_gre: Fix non-point-to-point tunnel not generating IPv6 link local address

Tom Rix (1):
      igc: return an error if the mac type is unknown in igc_ptp_systim_to_hwtstamp()

Vladimir Oltean (1):
      net: fman: memac: free mdio device if lynx_pcs_create() fails

Xin Long (1):
      sctp: do not check hb_timer.expires when resetting hb_timer

Yan Zhai (1):
      net: fix NULL pointer in skb_segment_list

Yanguo Li (1):
      nfp: flower: avoid taking mutex in atomic context

Yonghong Song (1):
      bpf: Fix a possible task gone issue with bpf_send_signal[_thread]() helpers

Ziyang Xuan (1):
      can: j1939: fix errant WARN_ON_ONCE in j1939_session_deactivate

Íñigo Huguet (1):
      sfc: correctly advertise tunneled IPv6 segmentation

 .mailmap                                           |  1 +
 CREDITS                                            |  8 +++
 .../device_drivers/ethernet/intel/ice.rst          |  2 +-
 MAINTAINERS                                        |  4 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-ethtool.c  |  1 +
 drivers/net/dsa/Kconfig                            |  7 +-
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c     |  6 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |  9 ++-
 drivers/net/ethernet/freescale/fman/fman_memac.c   |  3 +
 drivers/net/ethernet/intel/ice/ice.h               |  2 +-
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c       | 23 +++---
 drivers/net/ethernet/intel/ice/ice_dcb_lib.h       |  4 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c       | 28 ++++++--
 drivers/net/ethernet/intel/ice/ice_main.c          |  5 +-
 drivers/net/ethernet/intel/igc/igc_ptp.c           | 14 ++--
 .../ethernet/marvell/octeontx2/af/rvu_devlink.c    | 35 +++++++---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |  6 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.h        |  4 +-
 drivers/net/ethernet/mediatek/mtk_ppe.c            |  3 +-
 drivers/net/ethernet/mediatek/mtk_ppe.h            |  1 -
 drivers/net/ethernet/mediatek/mtk_sgmii.c          | 46 ++++++++----
 .../net/ethernet/microchip/lan966x/lan966x_fdma.c  |  6 +-
 .../ethernet/netronome/nfp/flower/tunnel_conf.c    |  8 ++-
 drivers/net/ethernet/qlogic/qede/qede_fp.c         |  7 +-
 drivers/net/ethernet/sfc/efx.c                     |  5 +-
 .../ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c    |  2 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  3 +-
 drivers/net/hyperv/netvsc.c                        |  9 +--
 drivers/net/phy/dp83822.c                          |  6 +-
 drivers/net/phy/meson-gxl.c                        |  2 +
 drivers/net/phy/phy_device.c                       |  2 +-
 drivers/net/virtio_net.c                           |  8 +--
 drivers/net/wwan/t7xx/t7xx_hif_dpmaif.c            | 11 ++-
 drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c         | 29 +++++---
 drivers/net/wwan/t7xx/t7xx_netdev.c                | 16 ++++-
 drivers/net/wwan/t7xx/t7xx_pci.c                   |  2 +
 include/linux/stmmac.h                             |  1 +
 include/linux/util_macros.h                        | 12 ++++
 kernel/bpf/bpf_lsm.c                               |  1 -
 kernel/bpf/btf.c                                   |  4 +-
 kernel/bpf/memalloc.c                              |  2 +-
 kernel/bpf/verifier.c                              | 25 +++++--
 kernel/trace/bpf_trace.c                           |  3 +-
 net/bridge/br_netfilter_hooks.c                    |  1 +
 net/can/isotp.c                                    | 69 +++++++++---------
 net/can/j1939/transport.c                          |  4 --
 net/can/raw.c                                      | 47 ++++++++-----
 net/core/gro.c                                     |  9 +++
 net/core/skbuff.c                                  |  5 +-
 net/core/sock_map.c                                | 61 ++++++++--------
 net/ipv4/tcp_bpf.c                                 |  4 +-
 net/ipv6/addrconf.c                                | 59 ++++++++--------
 net/mac802154/rx.c                                 |  1 -
 net/mctp/af_mctp.c                                 |  6 ++
 net/netfilter/nf_conntrack_proto_sctp.c            |  5 +-
 net/netrom/af_netrom.c                             |  5 ++
 net/openvswitch/datapath.c                         | 12 ++--
 net/qrtr/ns.c                                      |  5 +-
 net/rose/af_rose.c                                 |  8 +++
 net/sched/sch_htb.c                                |  5 +-
 net/sctp/transport.c                               |  4 +-
 net/tls/tls_sw.c                                   |  2 +-
 .../selftests/bpf/prog_tests/sockmap_listen.c      | 81 +++++++++++++++++-----
 .../selftests/bpf/verifier/search_pruning.c        | 36 ++++++++++
 tools/testing/selftests/net/cmsg_ipv6.sh           |  2 +-
 tools/testing/selftests/net/udpgso_bench.sh        | 24 +++++--
 tools/testing/selftests/net/udpgso_bench_rx.c      |  4 +-
 tools/testing/selftests/net/udpgso_bench_tx.c      | 36 ++++++++--
 68 files changed, 599 insertions(+), 272 deletions(-)
