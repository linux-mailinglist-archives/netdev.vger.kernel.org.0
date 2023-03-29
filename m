Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2D4E6CD22F
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 08:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbjC2GlN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 02:41:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbjC2GlL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 02:41:11 -0400
Received: from xavier.telenet-ops.be (xavier.telenet-ops.be [IPv6:2a02:1800:120:4::f00:14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEDFB2D5E
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 23:41:04 -0700 (PDT)
Received: from ramsan.of.borg ([84.195.187.55])
        by xavier.telenet-ops.be with bizsmtp
        id e6gy2900J1C8whw016gyme; Wed, 29 Mar 2023 08:41:02 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtp (Exim 4.95)
        (envelope-from <geert@linux-m68k.org>)
        id 1phPTi-00FCaj-HO;
        Wed, 29 Mar 2023 08:40:58 +0200
Received: from geert by rox.of.borg with local (Exim 4.95)
        (envelope-from <geert@linux-m68k.org>)
        id 1phPUQ-006YmR-JE;
        Wed, 29 Mar 2023 08:40:58 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] can: rcar_canfd: Fix plain integer in transceivers[] init
Date:   Wed, 29 Mar 2023 08:40:55 +0200
Message-Id: <7f7b0dde0caa2d2977b4fb5b65b63036e75f5022.1680071972.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.4 required=5.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With C=1:

    drivers/net/can/rcar/rcar_canfd.c:1852:59: warning: Using plain integer as NULL pointer

Fixes: a0340df7eca4f28e ("can: rcar_canfd: Add transceiver support")
Reported-by: Jakub Kicinski <kuba@kernel.org>
Link: https://lore.kernel.org/r/20230328145658.7fdbc394@kernel.org
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/net/can/rcar/rcar_canfd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index ecdb8ffe2f670c9b..11626d2a0afb1a90 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -1848,7 +1848,7 @@ static void rcar_canfd_channel_remove(struct rcar_canfd_global *gpriv, u32 ch)
 
 static int rcar_canfd_probe(struct platform_device *pdev)
 {
-	struct phy *transceivers[RCANFD_NUM_CHANNELS] = { 0, };
+	struct phy *transceivers[RCANFD_NUM_CHANNELS] = { NULL, };
 	const struct rcar_canfd_hw_info *info;
 	struct device *dev = &pdev->dev;
 	void __iomem *addr;
-- 
2.34.1

