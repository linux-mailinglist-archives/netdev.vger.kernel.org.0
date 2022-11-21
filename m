Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92384632590
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 15:23:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbiKUOXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 09:23:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230386AbiKUOXJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 09:23:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35D5311C12;
        Mon, 21 Nov 2022 06:23:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5F1F61236;
        Mon, 21 Nov 2022 14:23:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F18DBC433D6;
        Mon, 21 Nov 2022 14:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669040586;
        bh=cUULGy4mgdbSd468FijsWaJOzVXL6DoDInK2H/YTWCA=;
        h=From:To:Cc:Subject:Date:From;
        b=fNDGIKafaZDaj/M/kzfmZuJBs5SF53P0Pclx3NvCmL5hAj/dTl+lwzNbUTKhowCcC
         Y+PHJmTQTreeAC4kKQseKQ+PXb4QczWC9lHkJdvy2jnu22JZGkCFUvAmzCXn9Td/WD
         GlOtGPYYutUdjZYu6RUMI+eI/SipKfLuYapcMSp72fsHIQPpwt+TznChinqcJ5WLkC
         igpNFZSml8zHtlPLM5kUvodC9zV2qVed9ds5mF9N4cGmE8YIermuTcwU0C3KLSnBA0
         LLT2pRwKV7LaCfItaScEA6IF/AtBPWQPlqvgkmrcgax6aXUEhusl9SIEDFu7s1mqJK
         74VktjC25xd4g==
From:   Roger Quadros <rogerq@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     edumazet@google.com, pabeni@redhat.com, vigneshr@ti.com,
        linux-omap@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Roger Quadros <rogerq@kernel.org>
Subject: [PATCH v2 0/4] net: ethernet: ti: am65-cpsw: Fix set channel operation
Date:   Mon, 21 Nov 2022 16:22:56 +0200
Message-Id: <20221121142300.9320-1-rogerq@kernel.org>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This contains a critical bug fix for the recently merged suspend/resume
support that broke set channel operation. (ethtool -L eth0 tx <n>)

Remaining patches are optimizations.

cheers,
-roger

Changelog:
v2:
-Fix build warning
 drivers/net/ethernet/ti/am65-cpsw-nuss.c:562:13: warning: variable 'tmo' set but not used [-Wunused-but-set-variable]

Roger Quadros (4):
  net: ethernet: ti: am65-cpsw: Fix set channel operation
  net: ethernet: ti: am65-cpsw-nuss: Remove redundant ALE_CLEAR
  net: ethernet: ti: am65-cpsw: Restore ALE only if any interface was up
  net: ethernet: ti: cpsw_ale: optimize cpsw_ale_restore()

 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 167 +++++++++++++----------
 drivers/net/ethernet/ti/cpsw_ale.c       |   7 +-
 2 files changed, 99 insertions(+), 75 deletions(-)

-- 
2.17.1

