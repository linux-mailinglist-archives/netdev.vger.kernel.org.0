Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A571574338
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 06:32:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237483AbiGNEb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 00:31:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237244AbiGNEbU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 00:31:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 594B132BB1;
        Wed, 13 Jul 2022 21:25:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0734FB82372;
        Thu, 14 Jul 2022 04:25:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 178A1C341C6;
        Thu, 14 Jul 2022 04:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657772721;
        bh=Gf0LKqlKu1/jTIdxolSfG0iMtIyumwv6zYWKDbpiuJ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RIdVum7J9lj9jybfXFRb9QlTsFCvWSfLOih+HWUlokgEVt9fMLOUMBPZAHCWiSDw6
         LnnIV2FMLzW7LUtHXHvGAZSEdedv7KT82MooUwWL5Tao9Kp/C8DYy+fBvi8NbcGHgy
         XLGetisnrKtkhx2YSRNdZ4h/qwfZImPly+jIDPkUV5vUYz2OI4noEw8ushr2eOZZrZ
         wGPxF/OMQH3K9Co0OmlPUTsfHrjFJjK4RlGl8R2sU69dAgKzDRGnuWcwGhKt+As6XE
         e8Oz0jCKAie3Nl2u0MMDIQuohzr6P38hbkwgh1Gj/6H9f4AIX0s0NczKhe/QiFma5B
         p1Po3q70qoSUA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Srinivas Neeli <srinivas.neeli@xilinx.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>, appana.durga.rao@xilinx.com,
        wg@grandegger.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, michal.simek@xilinx.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 23/28] Revert "can: xilinx_can: Limit CANFD brp to 2"
Date:   Thu, 14 Jul 2022 00:24:24 -0400
Message-Id: <20220714042429.281816-23-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220714042429.281816-1-sashal@kernel.org>
References: <20220714042429.281816-1-sashal@kernel.org>
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
index 262b783d1df8..a2e751f0ae0b 100644
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

