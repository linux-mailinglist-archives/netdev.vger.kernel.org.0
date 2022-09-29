Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0F535EF41A
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 13:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234810AbiI2LQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 07:16:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbiI2LQq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 07:16:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 383A813E7E7
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 04:16:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664450204;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=nwUR8ZUx03O4k7AXQqgEr6oJcUg1sZbXu+yFA3Igo1g=;
        b=cXK+gAGCXGFJkCH+Wl9jIf5NJG4aLCRdR7s3xDS6exoI7yHm2shRhm5GrhJceIEUpBkRM3
        YQFRVAeyIhInHBEgfaCgLhG3/UlYINK5FwLdNAP7kRVg6dqIKOD6tBGhtbt9QDwVGJyt5n
        eBTCYenzPdG6HunpeGEsSTemygGR2SQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-623-w4yGM6joNZKIyZAGRjrRjA-1; Thu, 29 Sep 2022 07:16:40 -0400
X-MC-Unique: w4yGM6joNZKIyZAGRjrRjA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BF7538582B9;
        Thu, 29 Sep 2022 11:16:39 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.192.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A91C62166B2A;
        Thu, 29 Sep 2022 11:16:38 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 6.0-rc8
Date:   Thu, 29 Sep 2022 13:16:05 +0200
Message-Id: <20220929111605.32358-1-pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

This includes the fix for the phy regression mentioned in the
previous net PR.
There are no other known left-over regressions.

The following changes since commit 504c25cb76a9cb805407f7701b25a1fbd48605fa:

  Merge tag 'net-6.0-rc7' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-09-22 10:58:13 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.0-rc8

for you to fetch changes up to 3b04cba7add093d0d8267cf70a333ca8fe8233ca:

  Merge branch 'mptcp-properly-clean-up-unaccepted-subflows' (2022-09-28 19:05:40 -0700)

----------------------------------------------------------------
Networking fixes for 6.0-rc8, including fixes from wifi and can.

Current release - regressions:

 - phy: don't WARN for PHY_UP state in mdio_bus_phy_resume()

 - wifi: fix locking in mac80211 mlme

 - eth:
   - revert "net: mvpp2: debugfs: fix memory leak when using debugfs_lookup()"
   - mlxbf_gige: fix an IS_ERR() vs NULL bug in mlxbf_gige_mdio_probe

Previous releases - regressions:

 - wifi: fix regression with non-QoS drivers

Previous releases - always broken:

 - mptcp: fix unreleased socket in accept queue

 - wifi:
   - don't start TX with fq->lock to fix deadlock
   - fix memory corruption in minstrel_ht_update_rates()

 - eth:
   - macb: fix ZynqMP SGMII non-wakeup source resume failure
   - mt7531: only do PLL once after the reset
   - usbnet: fix memory leak in usbnet_disconnect()

Misc:

 - usb: qmi_wwan: add new usb-id for Dell branded EM7455

Signed-off-by: Paolo Abeni <pabeni@redhat.com>

----------------------------------------------------------------
Alexander Couzens (2):
      net: mt7531: only do PLL once after the reset
      net: mt7531: ensure all MACs are powered down before reset

Alexander Wetzel (2):
      wifi: mac80211: don't start TX with fq->lock to fix deadlock
      wifi: mac80211: ensure vif queues are operational after start

Andy Moreton (1):
      sfc: correct filter_table_remove method for EF10 PFs

Daniel Golle (1):
      net: ethernet: mtk_eth_soc: fix mask of RX_DMA_GET_SPORT{,_V2}

Frank Wunderlich (1):
      net: usb: qmi_wwan: Add new usb-id for Dell branded EM7455

Hangyu Hua (1):
      net: sched: act_ct: fix possible refcount leak in tcf_ct_init()

Hans de Goede (1):
      wifi: mac80211: fix regression with non-QoS drivers

Jakub Kicinski (5):
      Merge branch 'net-mt7531-pll-reset-fixes'
      Merge tag 'wireless-2022-09-27' of git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless
      Merge tag 'linux-can-fixes-for-6.0-20220928' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      Merge branch 'mptcp-properly-clean-up-unaccepted-subflows'

Junxiao Chang (1):
      net: stmmac: power up/down serdes in stmmac_open/release

Lukas Bulwahn (1):
      MAINTAINERS: rectify file entry in TEAM DRIVER

Lukas Wunner (1):
      net: phy: Don't WARN for PHY_UP state in mdio_bus_phy_resume()

Maciej Fijalkowski (2):
      ice: xsk: change batched Tx descriptor cleaning
      ice: xsk: drop power of 2 ring size restriction for AF_XDP

Marc Kleine-Budde (1):
      can: c_can: don't cache TX messages for C_CAN cores

Menglong Dong (2):
      mptcp: factor out __mptcp_close() without socket lock
      mptcp: fix unreleased socket in accept queue

Patrick Rohr (1):
      tun: support not enabling carrier in TUNSETIFF

Paweł Lenkow (1):
      wifi: mac80211: fix memory corruption in minstrel_ht_update_rates()

Peilin Ye (1):
      usbnet: Fix memory leak in usbnet_disconnect()

Peng Wu (1):
      net/mlxbf_gige: Fix an IS_ERR() vs NULL bug in mlxbf_gige_mdio_probe

Radhey Shyam Pandey (1):
      net: macb: Fix ZynqMP SGMII non-wakeup source resume failure

Rafael Mendonca (3):
      cxgb4: fix missing unlock on ETHOFLD desc collect fail path
      wifi: mac80211: mlme: Fix missing unlock on beacon RX
      wifi: mac80211: mlme: Fix double unlock on assoc success handling

Sasha Levin (1):
      Revert "net: mvpp2: debugfs: fix memory leak when using debugfs_lookup()"

Tamizh Chelvam Raja (1):
      wifi: cfg80211: fix MCS divisor value

Vladimir Oltean (1):
      net: mscc: ocelot: fix tagged VLAN refusal while under a VLAN-unaware bridge

Wang Yufen (1):
      selftests: Fix the if conditions of in test_extra_filter()

ruanjinjie (1):
      net: hippi: Add missing pci_disable_device() in rr_init_one()

 MAINTAINERS                                        |   2 +-
 drivers/net/can/c_can/c_can.h                      |  17 ++-
 drivers/net/can/c_can/c_can_main.c                 |  11 +-
 drivers/net/dsa/mt7530.c                           |  19 ++-
 drivers/net/ethernet/cadence/macb_main.c           |   4 +
 drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c     |  28 ++--
 drivers/net/ethernet/intel/ice/ice_txrx.c          |   2 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c           | 163 +++++++++------------
 drivers/net/ethernet/intel/ice/ice_xsk.h           |   7 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c |   4 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.h        |   4 +-
 .../ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c |   4 +-
 drivers/net/ethernet/mscc/ocelot.c                 |   7 +
 drivers/net/ethernet/sfc/ef10.c                    |   2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  23 +--
 drivers/net/hippi/rrunner.c                        |   1 +
 drivers/net/phy/phy_device.c                       |  10 +-
 drivers/net/tun.c                                  |   9 +-
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/net/usb/usbnet.c                           |   7 +-
 include/uapi/linux/if_tun.h                        |   2 +
 net/mac80211/mlme.c                                |   9 +-
 net/mac80211/rc80211_minstrel_ht.c                 |   6 +-
 net/mac80211/status.c                              |   2 +-
 net/mac80211/tx.c                                  |   4 +
 net/mac80211/util.c                                |   4 +-
 net/mptcp/protocol.c                               |  16 +-
 net/mptcp/protocol.h                               |   2 +
 net/mptcp/subflow.c                                |  33 +----
 net/sched/act_ct.c                                 |   5 +-
 net/wireless/util.c                                |   4 +-
 tools/testing/selftests/net/reuseport_bpf.c        |   2 +-
 32 files changed, 223 insertions(+), 191 deletions(-)

