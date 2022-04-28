Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ABCA513D76
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 23:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348215AbiD1V0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 17:26:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235380AbiD1V0w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 17:26:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 111FCAAB65
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 14:23:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0C97B82FD9
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 21:23:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 810F3C385AD;
        Thu, 28 Apr 2022 21:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651181014;
        bh=+iP7PWOBCyPy12bZ9fXscFGfktjBX9OsA64YmmFymoY=;
        h=From:To:Cc:Subject:Date:From;
        b=tdd7xy+EgcGzv8QN7YHOcPemJOWTD5MZvHwyTN2REfJ7dMKWhhyggMyFxYs+Cu9cy
         n7v9HSskwLMq6htKORLxWgMm0f6hN1w0v8WNUP2KwBPPSeT8Bdiza3rcK/KKp5oyPY
         uz445cyzZMtbTmn1NhMxqMz+2D0GBaRXNgYXCdmsCSrjhf5jjm+xtsgpOdJky+2xvp
         In1ynUrsmeYWVo/6m2dyLIlqxgI7edsTbcZnkkLOnXUIix/+SR9msMMRt3EclX04y7
         wNQ3s/n7VPD9+Ml4RBv97K3qBK1v3X9IQI+/Jju1FLxFtuYDMMisdCfPx5D62GkWHP
         qTWfv9mRMyIYQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, pabeni@redhat.com
Cc:     edumazet@google.com, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 00/15] remove copies of the NAPI_POLL_WEIGHT define
Date:   Thu, 28 Apr 2022 14:23:08 -0700
Message-Id: <20220428212323.104417-1-kuba@kernel.org>
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

v2:
 - drop staging bits (patch 2)
 - fix subject (patch 8)
 - add qeth change (patch 15)

Jakub Kicinski (15):
  eth: remove copies of the NAPI_POLL_WEIGHT define
  eth: smsc: remove a copy of the NAPI_POLL_WEIGHT define
  eth: cpsw: remove a copy of the NAPI_POLL_WEIGHT define
  eth: pch_gbe: remove a copy of the NAPI_POLL_WEIGHT define
  eth: mtk_eth_soc: remove a copy of the NAPI_POLL_WEIGHT define
  usb: lan78xx: remove a copy of the NAPI_POLL_WEIGHT define
  slic: remove a copy of the NAPI_POLL_WEIGHT define
  net: bgmac: remove a copy of the NAPI_POLL_WEIGHT define
  eth: atlantic: remove a copy of the NAPI_POLL_WEIGHT define
  eth: benet: remove a copy of the NAPI_POLL_WEIGHT define
  eth: gfar: remove a copy of the NAPI_POLL_WEIGHT define
  eth: vxge: remove a copy of the NAPI_POLL_WEIGHT define
  eth: spider: remove a copy of the NAPI_POLL_WEIGHT define
  eth: velocity: remove a copy of the NAPI_POLL_WEIGHT define
  qeth: remove a copy of the NAPI_POLL_WEIGHT define

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
 drivers/s390/net/qeth_core.h                         |  2 --
 drivers/s390/net/qeth_core_main.c                    |  2 +-
 drivers/s390/net/qeth_l2_main.c                      |  2 +-
 drivers/s390/net/qeth_l3_main.c                      |  2 +-
 38 files changed, 40 insertions(+), 72 deletions(-)

-- 
2.34.1

