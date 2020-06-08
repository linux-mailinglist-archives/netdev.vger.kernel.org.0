Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A00F1F10AC
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 02:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728065AbgFHAVp convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 7 Jun 2020 20:21:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727919AbgFHAVp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jun 2020 20:21:45 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 242E8C08C5C3;
        Sun,  7 Jun 2020 17:21:45 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 748AE12744E9B;
        Sun,  7 Jun 2020 17:21:44 -0700 (PDT)
Date:   Sun, 07 Jun 2020 17:21:43 -0700 (PDT)
Message-Id: <20200607.172143.1367434746586532493.davem@davemloft.net>
To:     torvalds@linux-foundation.org
CC:     akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 07 Jun 2020 17:21:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


I still haven't received from Johannes Berg a fix for the wireless
shutdown issues you reported, but I will send that to you as soon
as I have it.  Meanwhile:

1) Fix the build with certain Kconfig combinations for the Chelsio
   inline TLS device, from Rohit Maheshwar and Vinay Kumar Yadavi.

2) Fix leak in genetlink, from Cong Lang.

3) Fix out of bounds packet header accesses in seg6, from Ahmed
   Abdelsalam.

4) Two XDP fixes in the ENA driver, from Sameeh Jubran

5) Use rwsem in device rename instead of a seqcount because this code
   can sleep, from Ahmed S. Darwish.

6) Fix WoL regressions in r8169, from Heiner Kallweit.

7) Fix qed crashes in kdump mode, from Alok Prasad.

8) Fix the callbacks used for certain thermal zones in mlxsw, from
   Vadim Pasternak.

Please pull, thanks a lot!

The following changes since commit cb8e59cc87201af93dfbb6c3dccc8fcad72a09c2:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next (2020-06-03 16:27:18 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net 

for you to fetch changes up to 4d3da2d8d91f66988a829a18a0ce59945e8ae4fb:

  net: dsa: lantiq_gswip: fix and improve the unsupported interface error (2020-06-07 17:09:46 -0700)

----------------------------------------------------------------
Ahmed Abdelsalam (1):
      seg6: fix seg6_validate_srh() to avoid slab-out-of-bounds

Ahmed S. Darwish (4):
      net: core: device_rename: Use rwsem instead of a seqcount
      net: phy: fixed_phy: Remove unused seqcount
      u64_stats: Document writer non-preemptibility requirement
      net: mdiobus: Disable preemption upon u64_stats update

Alexander Lobakin (1):
      net: ethernet: mvneta: fix MVNETA_SKB_HEADROOM alignment

Alok Prasad (1):
      net: qed: fixes crash while running driver in kdump kernel

Antoine Tenart (1):
      net: phy: mscc: fix Serdes configuration in vsc8584_config_init

Cong Wang (1):
      genetlink: fix memory leaks in genl_family_rcv_msg_dumpit()

Dan Carpenter (2):
      net: ethernet: dwmac: Fix an error code in imx_dwmac_probe()
      ethtool: linkinfo: remove an unnecessary NULL check

Dan Murphy (5):
      net: dp83869: Fix OF_MDIO config check
      net: dp83867: Fix OF_MDIO config check
      net: marvell: Fix OF_MDIO config check
      net: mscc: Fix OF_MDIO config check
      net: dp83869: Reset return variable if PHY strap is read

David S. Miller (2):
      Merge branch 'ena-xdp-fixes'
      Merge branch 'Fixes-for-OF_MDIO-flag'

Denis Efremov (1):
      cxgb4: Use kfree() instead kvfree() where appropriate

Heiner Kallweit (1):
      r8169: fix failing WoL

Herbert Xu (1):
      rhashtable: Drop raw RCU deref in nested_table_free

Jiri Benc (1):
      geneve: change from tx_error to tx_dropped on missing metadata

Kees Cook (1):
      net: ethtool: Fix comment mentioning typo in IS_ENABLED()

Martin Blumenstingl (1):
      net: dsa: lantiq_gswip: fix and improve the unsupported interface error

Michal Vok·Ë (1):
      net: dsa: qca8k: Fix "Unexpected gfp" kernel exception

Paolo Abeni (1):
      inet_connection_sock: clear inet_num out of destroy helper

Pavel Machek (1):
      net/xdp: use shift instead of 64 bit division

Roelof Berg (1):
      lan743x: Use correct MAC_CR configuration for 1 GBit speed

Rohit Maheshwari (1):
      crypto/chcr: error seen if CONFIG_CHELSIO_TLS_DEVICE isn't set

Sameeh Jubran (2):
      net: ena: xdp: XDP_TX: fix memory leak
      net: ena: xdp: update napi budget for DROP and ABORTED

Stefano Garzarella (1):
      vsock/vmci: make vmci_vsock_transport_cb() static

Tuong Lien (1):
      tipc: fix NULL pointer dereference in streaming

Vadim Pasternak (1):
      mlxsw: core: Use different get_trend() callbacks for different thermal zones

Valentin Longchamp (1):
      net: ethernet: freescale: remove unneeded include for ucc_geth

Vinay Kumar Yadav (1):
      crypto/chtls:Fix compile error when CONFIG_IPV6 is disabled

Wang Hai (1):
      yam: fix possible memory leak in yam_init_driver

 drivers/crypto/chelsio/chcr_algo.h                 |  4 ----
 drivers/crypto/chelsio/chtls/chtls_cm.c            | 46 ++++++++++++++++++++++++++++-----------
 drivers/crypto/chelsio/chtls/chtls_main.c          |  2 ++
 drivers/net/dsa/lantiq_gswip.c                     |  3 ++-
 drivers/net/dsa/qca8k.c                            |  3 +--
 drivers/net/ethernet/amazon/ena/ena_netdev.c       | 10 ++++-----
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c |  6 +++---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c     |  2 +-
 drivers/net/ethernet/freescale/ucc_geth.c          |  1 -
 drivers/net/ethernet/marvell/mvneta.c              |  2 +-
 drivers/net/ethernet/mellanox/mlxsw/core_thermal.c | 23 ++++++++++++++++----
 drivers/net/ethernet/microchip/lan743x_main.c      |  2 +-
 drivers/net/ethernet/qlogic/qed/qed_sriov.c        |  4 ++++
 drivers/net/ethernet/qlogic/qed/qed_sriov.h        | 10 +++------
 drivers/net/ethernet/qlogic/qede/qede_main.c       |  2 +-
 drivers/net/ethernet/realtek/r8169_main.c          | 13 +++++------
 drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c    |  2 +-
 drivers/net/geneve.c                               |  7 +++---
 drivers/net/hamradio/yam.c                         |  1 +
 drivers/net/phy/dp83867.c                          |  2 +-
 drivers/net/phy/dp83869.c                          |  5 ++++-
 drivers/net/phy/fixed_phy.c                        | 28 ++++++++++--------------
 drivers/net/phy/marvell.c                          |  2 +-
 drivers/net/phy/mdio_bus.c                         |  2 ++
 drivers/net/phy/mscc/mscc.h                        |  2 +-
 drivers/net/phy/mscc/mscc_main.c                   |  8 +++----
 include/linux/ethtool_netlink.h                    |  2 +-
 include/linux/u64_stats_sync.h                     | 43 ++++++++++++++++++++-----------------
 include/net/inet_connection_sock.h                 |  1 -
 include/net/seg6.h                                 |  2 +-
 lib/rhashtable.c                                   | 17 +++++++++++----
 net/core/dev.c                                     | 40 ++++++++++++++++------------------
 net/core/filter.c                                  |  2 +-
 net/ethtool/linkinfo.c                             |  3 +--
 net/ipv4/inet_connection_sock.c                    |  1 +
 net/ipv6/ipv6_sockglue.c                           |  2 +-
 net/ipv6/seg6.c                                    | 16 ++++++++------
 net/ipv6/seg6_iptunnel.c                           |  2 +-
 net/ipv6/seg6_local.c                              |  6 +++---
 net/netlink/genetlink.c                            | 94 +++++++++++++++++++++++++++++++++++++++++++++++++-------------------------------
 net/tipc/msg.c                                     |  4 ++--
 net/vmw_vsock/vmci_transport.c                     |  2 +-
 net/xdp/xdp_umem.c                                 |  2 +-
 43 files changed, 250 insertions(+), 181 deletions(-)
