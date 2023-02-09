Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEB2C690C1A
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 15:45:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbjBIOo7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 09:44:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231150AbjBIOow (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 09:44:52 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 466F5EB4A
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 06:44:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675953843;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=dx1WFhuru97TXbKr743lMhpAHRlKr7+HVqCxIDBtFoQ=;
        b=eqNCWT5mJ14E2wv9b5WLwLHFq6No5XTyzpy+ywO4ott8HCyWDfVYc0WWg5qEWLz1FF1rp7
        ZIosxoy6D6wuH30cLYx1iMcyV1LF6GBgpwGgl5zasO4d2juNqYrueKM6/Ubz3/kTGOqj2r
        Xe0jIxIvCONQmm0Vs6JfJwA/GPf9bWM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-493-gXgQnXU3NLywGs5w4Us0zA-1; Thu, 09 Feb 2023 09:44:00 -0500
X-MC-Unique: gXgQnXU3NLywGs5w4Us0zA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AF894382C971;
        Thu,  9 Feb 2023 14:43:59 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.193.146])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6D4772166B2A;
        Thu,  9 Feb 2023 14:43:58 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 6.2-rc8
Date:   Thu,  9 Feb 2023 15:42:27 +0100
Message-Id: <20230209144227.37380-1-pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

To the better of my knowledge, no outstanding regressions.

The following changes since commit edb9b8f380c3413bf783475279b1a941c7e5cec1:

  Merge tag 'net-6.2-rc7' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2023-02-02 14:03:31 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.2-rc8

for you to fetch changes up to 3a082086aa200852545cf15159213582c0c80eba:

  selftests: forwarding: lib: quote the sysctl values (2023-02-09 11:05:38 +0100)

----------------------------------------------------------------
Networking fixes for 6.2-rc8, including fixes from can and
ipsec subtrees

Current release - regressions:

 - sched: fix off by one in htb_activate_prios()

 - eth: mana: fix accessing freed irq affinity_hint

 - eth: ice: fix out-of-bounds KASAN warning in virtchnl

Current release - new code bugs:

 - eth: mtk_eth_soc: enable special tag when any MAC uses DSA

Previous releases - always broken:

 - core: fix sk->sk_txrehash default

 - neigh: make sure used and confirmed times are valid

 - mptcp: be careful on subflow status propagation on errors

 - xfrm: prevent potential spectre v1 gadget in xfrm_xlate32_attr()

 - phylink: move phy_device_free() to correctly release phy device

 - eth: mlx5:
   - fix crash unsetting rx-vlan-filter in switchdev mode
   - fix hang on firmware reset
   - serialize module cleanup with reload and remove

Signed-off-by: Paolo Abeni <pabeni@redhat.com>

----------------------------------------------------------------
Adham Faris (1):
      net/mlx5e: Update rx ring hw mtu upon each rx-fcs flag change

Alan Stern (1):
      net: USB: Fix wrong-direction WARNING in plusb.c

Allen Hubbe (1):
      ionic: missed doorbell workaround

Amir Tzin (1):
      net/mlx5e: Fix crash unsetting rx-vlan-filter in switchdev mode

Anastasia Belova (1):
      xfrm: compat: change expression for switch in xfrm_xlate64

Anirudh Venkataramanan (1):
      ice: Do not use WQ_MEM_RECLAIM flag for workqueue

Arınç ÜNAL (1):
      net: ethernet: mtk_eth_soc: enable special tag when any MAC uses DSA

Benedict Wong (1):
      Fix XFRM-I support for nested ESP tunnels

Brett Creeley (1):
      ice: Fix disabling Rx VLAN filtering with port VLAN enabled

Casper Andersson (1):
      net: microchip: sparx5: fix PTP init/deinit not checking all ports

Christian Hopps (1):
      xfrm: fix bug with DSCP copy to v6 from v4 tunnel

Clément Léger (1):
      net: phylink: move phy_device_free() to correctly release phy device

Dan Carpenter (2):
      ice: Fix off by one in ice_tc_forward_to_queue()
      net: sched: sch: Fix off by one in htb_activate_prios()

David S. Miller (1):
      Merge branch 'mptcp-fixes'

Devid Antonio Filoni (1):
      can: j1939: do not wait 250 ms if the same addr was already claimed

Dragos Tatulea (1):
      net/mlx5e: IPoIB, Show unknown speed instead of error

Eric Dumazet (3):
      xfrm/compat: prevent potential spectre v1 gadget in xfrm_xlate32_attr()
      xfrm: consistently use time64_t in xfrm_timer_handler()
      xfrm: annotate data-race around use_time

Haiyang Zhang (1):
      net: mana: Fix accessing freed irq affinity_hint

Hangbin Liu (1):
      selftests: forwarding: lib: quote the sysctl values

Heiner Kallweit (1):
      net: phy: meson-gxl: use MMD access dummy stubs for GXL, internal PHY

Herton R. Krzesinski (1):
      uapi: add missing ip/ipv6 header dependencies for linux/stddef.h

Ido Schimmel (1):
      selftests: Fix failing VXLAN VNI filtering test

Jakub Kicinski (5):
      Merge branch 'ionic-code-maintenance'
      Merge tag 'linux-can-fixes-for-6.2-20230207' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      Merge tag 'mlx5-fixes-2023-02-07' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge tag 'ipsec-2023-02-08' of git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec

Jiawen Wu (1):
      net: txgbe: Update support email address

Jiri Pirko (1):
      devlink: change port event netdev notifier from per-net to global

Julian Anastasov (1):
      neigh: make sure used and confirmed times are valid

Kevin Yang (1):
      txhash: fix sk->sk_txrehash default

Maher Sanalla (2):
      net/mlx5: Store page counters in a single array
      net/mlx5: Expose SF firmware pages counter

Matthieu Baerts (1):
      selftests: mptcp: stop tests earlier

Michael Kelley (1):
      hv_netvsc: Allocate memory in netvsc_dma_map() with GFP_ATOMIC

Michal Swiatkowski (1):
      ice: fix out-of-bounds KASAN warning in virtchnl

Neel Patel (1):
      ionic: clean interrupt before enabling queue to avoid credit race

Paolo Abeni (5):
      mptcp: do not wait for bare sockets' timeout
      mptcp: fix locking for setsockopt corner-case
      mptcp: fix locking for in-kernel listener creation
      mptcp: be careful on subflow status propagation on errors
      selftests: mptcp: allow more slack for slow test-case

Pietro Borrello (1):
      rds: rds_rm_zerocopy_callback() use list_first_entry()

Qi Zheng (1):
      bonding: fix error checking in bond_debug_reregister()

Radhey Shyam Pandey (1):
      net: macb: Perform zynqmp dynamic configuration only for SGMII interface

Sasha Neftin (1):
      igc: Add ndo_tx_timeout support

Shannon Nelson (1):
      ionic: clear up notifyq alloc commentary

Shay Drory (3):
      net/mlx5: fw_tracer, Clear load bit when freeing string DBs buffers
      net/mlx5: fw_tracer, Zero consumer index when reloading the tracer
      net/mlx5: Serialize module cleanup with reload and remove

Tariq Toukan (1):
      net: ethernet: mtk_eth_soc: fix wrong parameters order in __xdp_rxq_info_reg()

Vlad Buslov (1):
      net/mlx5: Bridge, fix ageing of peer FDB entries

Vladimir Oltean (5):
      net: dsa: mt7530: don't change PVC_EG_TAG when CPU port becomes VLAN-aware
      net: mscc: ocelot: fix VCAP filters not matching on MAC with "protocol 802.1Q"
      selftests: ocelot: tc_flower_chains: make test_vlan_ingress_modify() more comprehensive
      net: ethernet: mtk_eth_soc: fix DSA TX tag hwaccel for switch port 0
      net: mscc: ocelot: fix all IPv6 getting trapped to CPU when PTP timestamping is used

Yevgeny Kliteynik (1):
      net/mlx5: DR, Fix potential race in dr_rule_create_rule_nic

Yu Xiao (1):
      nfp: ethtool: fix the bug of setting unsupported port speed

Zhang Changzhong (1):
      ice: switch: fix potential memleak in ice_add_adv_recipe()

 .../device_drivers/ethernet/wangxun/txgbe.rst      |   2 +-
 drivers/net/bonding/bond_debugfs.c                 |   2 +-
 drivers/net/dsa/mt7530.c                           |  26 ++-
 drivers/net/ethernet/cadence/macb_main.c           |  31 ++--
 drivers/net/ethernet/intel/ice/ice_common.c        |   9 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |   2 +-
 drivers/net/ethernet/intel/ice/ice_switch.c        |   2 +-
 drivers/net/ethernet/intel/ice/ice_tc_lib.c        |   2 +-
 drivers/net/ethernet/intel/ice/ice_vf_mbx.c        |  21 +--
 .../net/ethernet/intel/ice/ice_vf_vsi_vlan_ops.c   |  16 +-
 drivers/net/ethernet/intel/igc/igc_main.c          |  25 ++-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |  36 ++--
 drivers/net/ethernet/mellanox/mlx5/core/debugfs.c  |   5 +-
 .../ethernet/mellanox/mlx5/core/diag/fw_tracer.c   |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/ecpf.c     |   2 +-
 .../ethernet/mellanox/mlx5/core/en/rep/bridge.c    |   4 -
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c    |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  90 ++--------
 .../net/ethernet/mellanox/mlx5/core/esw/bridge.c   |   2 +-
 .../ethernet/mellanox/mlx5/core/ipoib/ethtool.c    |  13 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  14 +-
 .../net/ethernet/mellanox/mlx5/core/pagealloc.c    |  37 ++--
 drivers/net/ethernet/mellanox/mlx5/core/sriov.c    |   2 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_rule.c |  25 +--
 drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c |   4 +-
 drivers/net/ethernet/microsoft/mana/gdma_main.c    |  37 ++--
 drivers/net/ethernet/mscc/ocelot_flower.c          |  24 +--
 drivers/net/ethernet/mscc/ocelot_ptp.c             |   8 +-
 .../net/ethernet/netronome/nfp/nfp_net_ethtool.c   | 194 +++++++++++++++++----
 drivers/net/ethernet/netronome/nfp/nfp_port.h      |  12 ++
 drivers/net/ethernet/pensando/ionic/ionic_dev.c    |   9 +-
 drivers/net/ethernet/pensando/ionic/ionic_dev.h    |  12 ++
 drivers/net/ethernet/pensando/ionic/ionic_lif.c    |  68 +++++++-
 drivers/net/ethernet/pensando/ionic/ionic_lif.h    |   2 +
 drivers/net/ethernet/pensando/ionic/ionic_main.c   |  29 +++
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c   |  87 ++++++++-
 drivers/net/hyperv/netvsc.c                        |   2 +-
 drivers/net/phy/meson-gxl.c                        |   2 +
 drivers/net/phy/phylink.c                          |   5 +-
 drivers/net/usb/plusb.c                            |   4 +-
 include/linux/mlx5/driver.h                        |  13 +-
 include/uapi/linux/ip.h                            |   1 +
 include/uapi/linux/ipv6.h                          |   1 +
 net/can/j1939/address-claim.c                      |  40 +++++
 net/core/devlink.c                                 |   9 +-
 net/core/neighbour.c                               |  18 +-
 net/core/sock.c                                    |   3 +-
 net/ipv4/af_inet.c                                 |   1 +
 net/ipv4/inet_connection_sock.c                    |   3 -
 net/ipv6/af_inet6.c                                |   1 +
 net/mptcp/pm_netlink.c                             |  10 +-
 net/mptcp/protocol.c                               |   9 +
 net/mptcp/sockopt.c                                |  11 +-
 net/mptcp/subflow.c                                |  12 +-
 net/rds/message.c                                  |   6 +-
 net/sched/sch_htb.c                                |   2 +-
 net/xfrm/xfrm_compat.c                             |   4 +-
 net/xfrm/xfrm_input.c                              |   3 +-
 net/xfrm/xfrm_interface_core.c                     |  54 +++++-
 net/xfrm/xfrm_policy.c                             |  14 +-
 net/xfrm/xfrm_state.c                              |  18 +-
 .../drivers/net/ocelot/tc_flower_chains.sh         |   2 +-
 tools/testing/selftests/net/forwarding/lib.sh      |   4 +-
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |  22 ++-
 .../selftests/net/test_vxlan_vnifiltering.sh       |  18 +-
 65 files changed, 798 insertions(+), 353 deletions(-)

