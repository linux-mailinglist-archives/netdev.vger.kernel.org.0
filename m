Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2CF55F90EF
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:28:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232206AbiJIW20 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:28:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231812AbiJIW00 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:26:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D99233D59F;
        Sun,  9 Oct 2022 15:18:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55DB6B80DE4;
        Sun,  9 Oct 2022 22:12:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0EC1C433C1;
        Sun,  9 Oct 2022 22:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665353576;
        bh=Cq0O6Lq0YGpcmM8L/xBbBUGYACre6Ya9iOwxDcgfiwU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n9SECNYNYPD/e+wBMW315UieKupYUpByz84uLB/6mEaGLqFCumTXI81JpypWwj6BH
         JBoa3bUXh/F57tNDjEdBmRSeRs215BwSBUUcl5z0pUh4HQ3Ei0ULEb8rSDIvSKGyLQ
         xrL8aSa2YO3kB61y4GhOJxOXZMdJtxEeI6+6lHAD3/wLAMPFyoR377OT2S4p+h9//U
         lu6s4DRf60/LLxm4C1UoPYxKRQnmBrlG80Ruf+kSbvl0Q99vCXsr00gKJp5LLVQ+L6
         SsOUX+x9g6jtZesvdFPcvCRKd1ITvnwz3AxmC3oWKIhDHyhkGXG4eceroqYwawpcnG
         9VvhodCfcNlmA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ziyang Xuan <william.xuanziyang@huawei.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 61/77] can: bcm: check the result of can_send() in bcm_can_tx()
Date:   Sun,  9 Oct 2022 18:07:38 -0400
Message-Id: <20221009220754.1214186-61-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009220754.1214186-1-sashal@kernel.org>
References: <20221009220754.1214186-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ziyang Xuan <william.xuanziyang@huawei.com>

[ Upstream commit 3fd7bfd28cfd68ae80a2fe92ea1615722cc2ee6e ]

If can_send() fail, it should not update frames_abs counter
in bcm_can_tx(). Add the result check for can_send() in bcm_can_tx().

Suggested-by: Marc Kleine-Budde <mkl@pengutronix.de>
Suggested-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Link: https://lore.kernel.org/all/9851878e74d6d37aee2f1ee76d68361a46f89458.1663206163.git.william.xuanziyang@huawei.com
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/bcm.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/can/bcm.c b/net/can/bcm.c
index e60161bec850..f16271a7ae2e 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -274,6 +274,7 @@ static void bcm_can_tx(struct bcm_op *op)
 	struct sk_buff *skb;
 	struct net_device *dev;
 	struct canfd_frame *cf = op->frames + op->cfsiz * op->currframe;
+	int err;
 
 	/* no target device? => exit */
 	if (!op->ifindex)
@@ -298,11 +299,11 @@ static void bcm_can_tx(struct bcm_op *op)
 	/* send with loopback */
 	skb->dev = dev;
 	can_skb_set_owner(skb, op->sk);
-	can_send(skb, 1);
+	err = can_send(skb, 1);
+	if (!err)
+		op->frames_abs++;
 
-	/* update statistics */
 	op->currframe++;
-	op->frames_abs++;
 
 	/* reached last frame? */
 	if (op->currframe >= op->nframes)
-- 
2.35.1

