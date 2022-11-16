Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4045A62C56E
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 17:51:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239215AbiKPQvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 11:51:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239079AbiKPQur (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 11:50:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F223EBFD;
        Wed, 16 Nov 2022 08:49:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F47C61EEE;
        Wed, 16 Nov 2022 16:49:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8684C433C1;
        Wed, 16 Nov 2022 16:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668617367;
        bh=16nnj3/xX+6iwyOgTVs9QzovzYa3SNqQYQfd1VXyLeo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cRlE3TGR1U6cSXl9fCHIs/XV+TdWdcs1TMYAMDX5IWHXUGnSlu2GVTDFRuKhE4VOl
         +abfIUsa9kbUOuYcqWi7o4oDK+DCRpCYUNAC0nXEAqzWT5dGEgam3hyrxSPVyCdl7j
         oU2woeD6kE4BKXBAw98UQ5WEAXiNatFhBmHIqd5brvAI3eS9nhYBuoApAp+fYZ4p3d
         F0091tTLQTi7S4kWOZv9wBUX3PYpw1HBskoCE1MstIiJ5eWwR4mIcFp7XGOYFCqytb
         7rfAdNldYJd88eUIHV+EOgK1PQ3rqyrsnPbcQaibnCEKtCWWEWohoH6EiMXkTnBzL4
         eYweCjtYAAKLA==
From:   Roger Quadros <rogerq@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     edumazet@google.com, pabeni@redhat.com, vigneshr@ti.com,
        linux-omap@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Roger Quadros <rogerq@kernel.org>
Subject: [PATCH 2/4] net: ethernet: ti: am65-cpsw-nuss: Remove redundant ALE_CLEAR
Date:   Wed, 16 Nov 2022 18:49:13 +0200
Message-Id: <20221116164915.13236-3-rogerq@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221116164915.13236-1-rogerq@kernel.org>
References: <20221116164915.13236-1-rogerq@kernel.org>
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
index f8899ac5e249..4107e9df65cd 100644
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

