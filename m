Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB4EB4D56BF
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 01:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343884AbiCKAaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 19:30:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236618AbiCKAaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 19:30:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EDF81A272C;
        Thu, 10 Mar 2022 16:29:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 85226B82963;
        Fri, 11 Mar 2022 00:29:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED59FC340F3;
        Fri, 11 Mar 2022 00:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646958553;
        bh=+f145bq0y4Y908dr0xQoAoOcCOlLzUF/zwjJSj93Rlk=;
        h=From:To:Cc:Subject:Date:From;
        b=jm7TbzLBsZSnHozd5X7FbWQMsc7laXZb+pm1UalYgBVeOQXkrRG3xVG+sG6YPRe7q
         hJvVJ1vJAgHBBRtA9J3jSwosP9cMXQ9cGwXcoTGPf7CVi844ZMosXTSsLz/F61KcFy
         /gOP6TSPyQH+55NbyLknzzqxwoFFAEmKKCY/ho39mzS/6UWULuPObLNDpzZlGNZ+IQ
         Cg4UxbyyUY2Ke9vnjJk/uC9PCMLaEasOeOQ9HQIruuDLQQfTmh5zrzpq0xk7HSaYtA
         74E0KvyGyd4/+M2WigkvXNYXdETL2pGmLnwtTxsGRA+G9p6TR7mkY0UuYkTckrIwh2
         984c6WuRgu5og==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 5.17-rc8
Date:   Thu, 10 Mar 2022 16:29:12 -0800
Message-Id: <20220311002912.437871-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

A little late this week due to dentistry.

The only 5.17 regression I'm aware of is the bnx2x firmware
loading thing. I can send a patch or respin the PR to include
the revert but I'd rather leave bandaging it up to people who
have the HW. The bad commits are in stable since v5.16.4, I'm
worried someone out there has initramfs with just the new FW
present.

The following changes since commit b949c21fc23ecaccef89582f251e6281cad1f81e:

  Merge tag 'net-5.17-rc7' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-03-03 11:10:56 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.17-rc8

for you to fetch changes up to e0ae713023a9d09d6e1b454bdc8e8c1dd32c586e:

  xdp: xdp_mem_allocator can be NULL in trace_mem_connect(). (2022-03-10 16:09:29 -0800)

----------------------------------------------------------------
Networking fixes for 5.17-rc8/final, including fixes from bluetooth,
and ipsec.

Current release - regressions:

 - Bluetooth: fix unbalanced unlock in set_device_flags()

 - Bluetooth: fix not processing all entries on cmd_sync_work,
   make connect with qualcomm and intel adapters reliable

 - Revert "xfrm: state and policy should fail if XFRMA_IF_ID 0"

 - xdp: xdp_mem_allocator can be NULL in trace_mem_connect()

 - eth: ice: fix race condition and deadlock during interface enslave

Current release - new code bugs:

 - tipc: fix incorrect order of state message data sanity check

Previous releases - regressions:

 - esp: fix possible buffer overflow in ESP transformation

 - dsa: unlock the rtnl_mutex when dsa_master_setup() fails

 - phy: meson-gxl: fix interrupt handling in forced mode

 - smsc95xx: ignore -ENODEV errors when device is unplugged

Previous releases - always broken:

 - xfrm: fix tunnel mode fragmentation behavior

 - esp: fix inter address family tunneling on GSO

 - tipc: fix null-deref due to race when enabling bearer

 - sctp: fix kernel-infoleak for SCTP sockets

 - eth: macb: fix lost RX packet wakeup race in NAPI receive

 - eth: intel stop disabling VFs due to PF error responses

 - eth: bcmgenet: don't claim WOL when its not available

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Aleksander Jan Bajkowski (1):
      net: lantiq_xrx200: fix use after free bug

Alexey Khoroshilov (1):
      mISDN: Fix memory leak in dsp_pipeline_build()

Ben Ben-Ishay (1):
      net/mlx5e: SHAMPO, reduce TIR indication

Christophe JAILLET (1):
      ice: Don't use GFP_KERNEL in atomic context

Clément Léger (1):
      net: phy: DP83822: clear MISR2 register to disable interrupts

Colin Foster (1):
      net: phy: correct spelling error of media in documentation

Dave Ertman (1):
      ice: Fix error with handling of bonding MTU

David S. Miller (2):
      Merge branch '40GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec

Dima Chumak (1):
      net/mlx5: Fix offloading with ESWITCH_IPV4_TTL_MODIFY_ENABLE

Duoming Zhou (1):
      ax25: Fix NULL pointer dereference in ax25_kill_by_device

Eric Dumazet (1):
      sctp: fix kernel-infoleak for SCTP sockets

Fabio Estevam (1):
      smsc95xx: Ignore -ENODEV errors when device is unplugged

Guillaume Nault (2):
      selftests: pmtu.sh: Kill tcpdump processes launched by subshell.
      selftests: pmtu.sh: Kill nettest processes launched in subshell.

Hans de Goede (1):
      Bluetooth: hci_core: Fix unbalanced unlock in set_device_flags()

Heiner Kallweit (2):
      net: phy: meson-gxl: fix interrupt handling in forced mode
      net: phy: meson-gxl: improve link-up behavior

Ivan Vecera (1):
      ice: Fix race condition during interface enslave

Jacob Keller (2):
      i40e: stop disabling VFs due to PF error responses
      ice: stop disabling VFs due to PF error responses

Jakub Kicinski (3):
      Merge tag 'for-net-2022-03-03' of git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth
      Merge branch 'selftests-pmtu-sh-fix-cleanup-of-processes-launched-in-subshell'
      Merge tag 'mlx5-fixes-2022-03-09' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux

Jedrzej Jagielski (1):
      ice: Fix curr_link_speed advertised speed

Jeremy Linton (1):
      net: bcmgenet: Don't claim WOL when its not available

Jia-Ju Bai (2):
      isdn: hfcpci: check the return value of dma_set_mask() in setup_hw()
      net: qlogic: check the return value of dma_alloc_coherent() in qed_vf_hw_prepare()

Jianglei Nie (1):
      net: arc_emac: Fix use after free in arc_mdio_probe()

Jiasheng Jiang (2):
      net: ethernet: ti: cpts: Handle error for clk_enable
      net: ethernet: lpc_eth: Handle error for clk_enable

Kai Lueke (1):
      Revert "xfrm: state and policy should fail if XFRMA_IF_ID 0"

Lina Wang (1):
      xfrm: fix tunnel model fragmentation behavior

Luiz Augusto von Dentz (1):
      Bluetooth: hci_sync: Fix not processing all entries on cmd_sync_work

Miaoqian Lin (3):
      ethernet: Fix error handling in xemaclite_of_probe
      net: marvell: prestera: Add missing of_node_put() in prestera_switch_set_base_mac_addr
      gianfar: ethtool: Fix refcount leak in gfar_get_ts_info

Michal Maloszewski (2):
      iavf: Fix handling of vlan strip virtual channel messages
      iavf: Fix adopting new combined setting

Minghao Chi (CGEL ZTE) (1):
      net:mcf8390: Use platform_get_irq() to get the interrupt

Mohammad Kabat (1):
      net/mlx5: Fix size field in bufferx_reg struct

Moshe Shemesh (1):
      net/mlx5: Fix a race on command flush flow

Pavel Skripkin (1):
      NFC: port100: fix use-after-free in port100_send_complete

Robert Hancock (1):
      net: macb: Fix lost RX packet wakeup race in NAPI receive

Roi Dayan (1):
      net/mlx5e: Lag, Only handle events from highest priority multipath entry

Russell King (Oracle) (1):
      net: dsa: mt7530: fix incorrect test in mt753x_phylink_validate()

Sebastian Andrzej Siewior (1):
      xdp: xdp_mem_allocator can be NULL in trace_mem_connect().

Steffen Klassert (3):
      esp: Fix possible buffer overflow in ESP transformation
      esp: Fix BEET mode inter address family tunneling on GSO
      net: Fix esp GSO on inter address family tunnels.

Tom Rix (1):
      qed: return status of qed_iov_get_link

Tung Nguyen (2):
      tipc: fix kernel panic when enabling bearer
      tipc: fix incorrect order of state message data sanity check

Vladimir Oltean (1):
      net: dsa: unlock the rtnl_mutex when dsa_master_setup() fails

Zheyu Ma (1):
      ethernet: sun: Free the coherent when failing in probing

 drivers/isdn/hardware/mISDN/hfcpci.c               |  6 ++-
 drivers/isdn/mISDN/dsp_pipeline.c                  |  6 +--
 drivers/net/dsa/mt7530.c                           |  2 +-
 drivers/net/ethernet/8390/mcf8390.c                | 10 ++--
 drivers/net/ethernet/arc/emac_mdio.c               |  5 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c |  7 +++
 drivers/net/ethernet/cadence/macb_main.c           | 25 +++++++++-
 drivers/net/ethernet/freescale/gianfar_ethtool.c   |  1 +
 drivers/net/ethernet/intel/i40e/i40e_debugfs.c     |  6 +--
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 57 +++-------------------
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h |  5 --
 drivers/net/ethernet/intel/iavf/iavf.h             |  1 +
 drivers/net/ethernet/intel/iavf/iavf_main.c        | 13 +++--
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c    | 40 +++++++++++++++
 drivers/net/ethernet/intel/ice/ice.h               | 12 ++++-
 drivers/net/ethernet/intel/ice/ice_ethtool.c       |  2 +-
 drivers/net/ethernet/intel/ice/ice_main.c          | 43 +++++++++-------
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c   | 18 -------
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h   |  3 --
 drivers/net/ethernet/lantiq_xrx200.c               |  2 +-
 .../net/ethernet/marvell/prestera/prestera_main.c  |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      | 15 +++---
 drivers/net/ethernet/mellanox/mlx5/core/en/tir.c   |  3 --
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  3 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c   | 11 +++--
 .../ethernet/mellanox/mlx5/core/lib/fs_chains.c    |  3 --
 drivers/net/ethernet/nxp/lpc_eth.c                 |  5 +-
 drivers/net/ethernet/qlogic/qed/qed_sriov.c        | 18 ++++---
 drivers/net/ethernet/qlogic/qed/qed_vf.c           |  7 +++
 drivers/net/ethernet/sun/sunhme.c                  |  6 ++-
 drivers/net/ethernet/ti/cpts.c                     |  4 +-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c      |  4 +-
 drivers/net/phy/dp83822.c                          |  2 +-
 drivers/net/phy/meson-gxl.c                        | 31 +++++++-----
 drivers/net/usb/smsc95xx.c                         | 28 ++++++++---
 drivers/nfc/port100.c                              |  2 +
 include/linux/mlx5/mlx5_ifc.h                      |  5 +-
 include/linux/netdevice.h                          |  2 +
 include/linux/phy.h                                |  4 +-
 include/net/esp.h                                  |  2 +
 net/ax25/af_ax25.c                                 |  7 +++
 net/bluetooth/hci_sync.c                           | 49 +++++++++----------
 net/bluetooth/mgmt.c                               |  2 +-
 net/core/gro.c                                     | 25 ++++++++++
 net/core/xdp.c                                     |  3 +-
 net/dsa/dsa2.c                                     |  6 +--
 net/ipv4/esp4.c                                    |  5 ++
 net/ipv4/esp4_offload.c                            |  6 ++-
 net/ipv6/esp6.c                                    |  5 ++
 net/ipv6/esp6_offload.c                            |  6 ++-
 net/ipv6/xfrm6_output.c                            | 16 ++++++
 net/sctp/diag.c                                    |  9 ++--
 net/tipc/bearer.c                                  | 12 +++--
 net/tipc/link.c                                    |  9 ++--
 net/xfrm/xfrm_interface.c                          |  5 +-
 net/xfrm/xfrm_user.c                               | 21 ++------
 tools/testing/selftests/net/pmtu.sh                | 21 ++++++--
 57 files changed, 383 insertions(+), 244 deletions(-)
