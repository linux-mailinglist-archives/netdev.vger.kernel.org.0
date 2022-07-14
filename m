Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 709265742D5
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 06:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233972AbiGNE1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 00:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235574AbiGNE0e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 00:26:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8E68DF54;
        Wed, 13 Jul 2022 21:23:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 68AADB82371;
        Thu, 14 Jul 2022 04:23:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 863E1C36AE7;
        Thu, 14 Jul 2022 04:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657772622;
        bh=YGB2Y6+ruG1k6sJM1H3ucWmg5fcVAC+DaG+pHm9VLSM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CwchJq8223p7jNNZOWiot+nghzOYOeuWh2dj28iuT3usV/4Tmw61tYOB0mjEBDAav
         jQqrK6VxWfrd1bEpfkqDu6zWi3r+/4BionrpRUfbCVnttWr9t5zRmV4/JIX+k7aLLk
         Smp158vC/l8CCEn0Q5Hb40t+oZNAy/QtuflhSuuoomC742+BbewJeezt8aDuaGLjW4
         4vSRKuiOV6TR51L8vucDFwIngHGfeErMAXZxUkU2jadAvrlZo2AFm11WtKldTwvjB0
         yke4wp4pmOz6fMdi82fSHsv7DoGRTtnke6LqIIjbN78NWPzi4YGofOuuCFAgovYLeg
         ooiC/U9Qhr24g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Srinivas Neeli <srinivas.neeli@xilinx.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>, appana.durga.rao@xilinx.com,
        wg@grandegger.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, michal.simek@xilinx.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.18 32/41] Revert "can: xilinx_can: Limit CANFD brp to 2"
Date:   Thu, 14 Jul 2022 00:22:12 -0400
Message-Id: <20220714042221.281187-32-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220714042221.281187-1-sashal@kernel.org>
References: <20220714042221.281187-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Srinivas Neeli <srinivas.neeli@xilinx.com>

[ Upstream commit c6da4590fe819dfe28a4f8037a8dc1e056542fb4 ]

This reverts commit 05ca14fdb6fe65614e0652d03e44b02748d25af7.

On early silicon engineering samples observed bit shrinking issue when
we use brp as 1. Hence updated brp_min as 2. As in production silicon
this issue is fixed, so reverting the patch.

Link: https://lore.kernel.org/all/20220609082433.1191060-2-srinivas.neeli@xilinx.com
Signed-off-by: Srinivas Neeli <srinivas.neeli@xilinx.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/xilinx_can.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
index 43f0c6a064ba..75b4db4d050b 100644
--- a/drivers/net/can/xilinx_can.c
+++ b/drivers/net/can/xilinx_can.c
@@ -259,7 +259,7 @@ static const struct can_bittiming_const xcan_bittiming_const_canfd2 = {
 	.tseg2_min = 1,
 	.tseg2_max = 128,
 	.sjw_max = 128,
-	.brp_min = 2,
+	.brp_min = 1,
 	.brp_max = 256,
 	.brp_inc = 1,
 };
@@ -272,7 +272,7 @@ static const struct can_bittiming_const xcan_data_bittiming_const_canfd2 = {
 	.tseg2_min = 1,
 	.tseg2_max = 16,
 	.sjw_max = 16,
-	.brp_min = 2,
+	.brp_min = 1,
 	.brp_max = 256,
 	.brp_inc = 1,
 };
-- 
2.35.1

