Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E2B9632595
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 15:23:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbiKUOXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 09:23:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230437AbiKUOXO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 09:23:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2908515715;
        Mon, 21 Nov 2022 06:23:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B19D161278;
        Mon, 21 Nov 2022 14:23:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 768A5C433C1;
        Mon, 21 Nov 2022 14:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669040592;
        bh=HFpo77BQsl9Ohhe2NaWGfq8emkBB12mjiU/sde8Xnzg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gx+uBKz7w78qUyoXj7z1zrl3gBMfjuCsa7QUoh8o5+YzvncgLa3L4jK1hzipWMa7i
         SKUX4DYjNnl3rfH7/RQuZYRk1W19cxngraxbbfMH1dcDlYfB/Wf2A3p6ULrPK505S6
         alydqN8o14100jPPXUpJM5b8cEXtqQVa+ySaSaUYiN3dbEwKCn+fcH5ZHeB+kCpYUh
         P5BnsfCVwQYoQOMgjNz22gNJX/bBlJ37qXy4cXSh0/gjJvdEotvBmtqPZFXTj8ShJT
         rTU7eaRDu5Oi3YGj0QM7gagWTqnbAktkYvdUCaG3h4mSRyLkhNts2MVqBVknDp0Vto
         W/ojNxR2r4DRg==
From:   Roger Quadros <rogerq@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     edumazet@google.com, pabeni@redhat.com, vigneshr@ti.com,
        linux-omap@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Roger Quadros <rogerq@kernel.org>
Subject: [PATCH v2 2/4] net: ethernet: ti: am65-cpsw-nuss: Remove redundant ALE_CLEAR
Date:   Mon, 21 Nov 2022 16:22:58 +0200
Message-Id: <20221121142300.9320-3-rogerq@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221121142300.9320-1-rogerq@kernel.org>
References: <20221121142300.9320-1-rogerq@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ALE_CLEAR command is issued in cpsw_ale_start() so no need
to issue it before the call to cpsw_ale_start().

Fixes: fd23df72f2be ("net: ethernet: ti: am65-cpsw: Add suspend/resume support")
Signed-off-by: Roger Quadros <rogerq@kernel.org>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 505c9edf98ff..2acde5b14516 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -404,7 +404,6 @@ static int am65_cpsw_nuss_common_open(struct am65_cpsw_common *common)
 	/* disable priority elevation */
 	writel(0, common->cpsw_base + AM65_CPSW_REG_PTYPE);
 
-	cpsw_ale_control_set(common->ale, 0, ALE_CLEAR, 1);
 	cpsw_ale_start(common->ale);
 
 	/* limit to one RX flow only */
-- 
2.17.1

