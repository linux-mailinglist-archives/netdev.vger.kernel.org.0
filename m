Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAA50511F13
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240131AbiD0Poo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 11:44:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240070AbiD0Pom (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 11:44:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E2EC29CA0
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 08:41:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A7938B82872
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 15:41:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 397D8C385A9;
        Wed, 27 Apr 2022 15:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651074081;
        bh=qhqu1Mm2Hf8o9WTqyf/zbq5T8B7npihZChAczpuNjSc=;
        h=From:To:Cc:Subject:Date:From;
        b=Y6L8qgEKmDTq06c74o8sCJ/DxlOIliC+AFCtCG+HZ5tNyTAh7PN4odye5fU8Cicmr
         NAXadOLvq+cCbF5u/WwbXfFFKctCAvPSPNidHWB3Uj9p9kVblPlaaENhf6Ed1aiv0s
         nF6Qou5ShM/RYDt/3Al1vH4muKRo6ZOFTr25lnViCpYw1GtT9WsDezvRZlMy1ClDU/
         7TldfdPTF9UQB+k9plH8LSoXx5ZuLSiSyGWWA72IJT/0wAqnSfqxXHvlruNOSsLXWi
         yqK27qbuUrROq5ulUXv3FxcLw/mSbmLjvH+1cy2XMwR2wQDQHJapVqTOlugHx12Vxw
         nINvklS5UeRQg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 00/14] remove copies of the NAPI_POLL_WEIGHT define
Date:   Wed, 27 Apr 2022 08:40:57 -0700
Message-Id: <20220427154111.529975-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

netif_napi_add() takes weight as the last argument. The value of
that parameter is hard to come up with and depends on many factors,
so driver authors are encouraged to use NAPI_POLL_WEIGHT.

We should probably move weight to an "advanced" version of the API
(__netif_napi_add()?) and simplify the life of most driver authors.

In preparation for such API changes this series removes local
defines equivalent to NAPI_POLL_WEIGHT from drivers, so that a simple
coccinelle / spatch script does not get thrown off by them.

Jakub Kicinski (14):
  eth: remove copies of the NAPI_POLL_WEIGHT define
  eth: remove NAPI_WEIGHT defines
  eth: cpsw: remove a copy of the NAPI_POLL_WEIGHT define
  eth: pch_gbe: remove a copy of the NAPI_POLL_WEIGHT define
  eth: mtk_eth_soc: remove a copy of the NAPI_POLL_WEIGHT define
  usb: lan78xx: remove a copy of the NAPI_POLL_WEIGHT define
  slic: remove a copy of the NAPI_POLL_WEIGHT define
  eth: bgnet: remove a copy of the NAPI_POLL_WEIGHT define
  eth: atlantic: remove a copy of the NAPI_POLL_WEIGHT define
  eth: benet: remove a copy of the NAPI_POLL_WEIGHT define
  eth: gfar: remove a copy of the NAPI_POLL_WEIGHT define
  eth: vxge: remove a copy of the NAPI_POLL_WEIGHT define
  eth: spider: remove a copy of the NAPI_POLL_WEIGHT define
  eth: velocity: remove a copy of the NAPI_POLL_WEIGHT define

 drivers/net/ethernet/alacritech/slic.h               |  2 --
 drivers/net/ethernet/alacritech/slicoss.c            |  2 +-
 drivers/net/ethernet/aquantia/atlantic/aq_cfg.h      |  2 --
 drivers/net/ethernet/aquantia/atlantic/aq_ptp.c      |  2 +-
 drivers/net/ethernet/aquantia/atlantic/aq_vec.c      |  2 +-
 drivers/net/ethernet/broadcom/bgmac.c                |  2 +-
 drivers/net/ethernet/broadcom/bgmac.h                |  2 --
 drivers/net/ethernet/cortina/gemini.c                |  4 +---
 drivers/net/ethernet/emulex/benet/be.h               |  3 +--
 drivers/net/ethernet/emulex/benet/be_main.c          |  2 +-
 drivers/net/ethernet/freescale/gianfar.c             |  2 +-
 drivers/net/ethernet/freescale/gianfar.h             |  3 ---
 drivers/net/ethernet/marvell/skge.c                  |  3 +--
 drivers/net/ethernet/marvell/sky2.c                  |  3 +--
 drivers/net/ethernet/mediatek/mtk_eth_soc.c          |  4 ++--
 drivers/net/ethernet/mediatek/mtk_eth_soc.h          |  1 -
 drivers/net/ethernet/mediatek/mtk_star_emac.c        |  3 +--
 drivers/net/ethernet/neterion/vxge/vxge-main.c       |  2 +-
 drivers/net/ethernet/neterion/vxge/vxge-main.h       |  2 --
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c | 12 +++++-------
 drivers/net/ethernet/smsc/smsc9420.c                 |  2 +-
 drivers/net/ethernet/smsc/smsc9420.h                 |  1 -
 drivers/net/ethernet/ti/cpsw.c                       |  4 ++--
 drivers/net/ethernet/ti/cpsw_new.c                   |  4 ++--
 drivers/net/ethernet/ti/cpsw_priv.c                  | 12 ++++++------
 drivers/net/ethernet/ti/cpsw_priv.h                  |  1 -
 drivers/net/ethernet/ti/davinci_emac.c               |  3 +--
 drivers/net/ethernet/ti/netcp_core.c                 |  5 ++---
 drivers/net/ethernet/toshiba/spider_net.c            |  2 +-
 drivers/net/ethernet/toshiba/spider_net.h            |  1 -
 drivers/net/ethernet/via/via-velocity.c              |  3 +--
 drivers/net/ethernet/via/via-velocity.h              |  1 -
 drivers/net/usb/lan78xx.c                            |  4 +---
 drivers/net/xen-netback/interface.c                  |  3 +--
 drivers/staging/unisys/visornic/visornic_main.c      |  4 ++--
 35 files changed, 39 insertions(+), 69 deletions(-)

-- 
2.34.1

