Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB1DE4D354D
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 18:41:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234356AbiCIQgf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 11:36:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237676AbiCIQbE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 11:31:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D89EF145E25;
        Wed,  9 Mar 2022 08:24:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34E41B82222;
        Wed,  9 Mar 2022 16:24:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A1D2C340E8;
        Wed,  9 Mar 2022 16:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646843072;
        bh=DS1Q7YDfa5cQlvAG52m1EPyp6K26+bOqkCOC/XXA3n4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kA2lHJ6Q32Jvls1JeatYX9xhAA9MxTDF8xkna06AD/4Hg+doT4OgoFOwDIg49tg3Z
         GFY6HfuIRPZNl9F7nWetdvpuGIpya8iOC2HsDBmQHccQSMfhziXDQBrxE+3GlJelpT
         a44yCqhtQXYyLWzlu8sO9sGbK3zyvGBAJU8xNGYP5+QPrzTI7g/MjZoiRtIHer7fqj
         4QYiEk48+bHuZZC2VpD1SnE2kATaBJYJ/X7sXbTk2jXqMr9ZKUabE+Ki2ds70n7+Nc
         LqHseJJPsL47xw02LxUnMOSBgvx4BvwdmYVZtO4Sj8wvh3JxbrF58cO9xGN2SM8oqY
         v245og4FR/UeQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Pavel Machek <pavel@denx.de>,
        Ulrich Hecht <uli+renesas@fpond.eu>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>, wg@grandegger.com,
        davem@davemloft.net, kuba@kernel.org, mailhol.vincent@wanadoo.fr,
        stefan.maetje@esd.eu, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 11/19] can: rcar_canfd: rcar_canfd_channel_probe(): register the CAN device when fully ready
Date:   Wed,  9 Mar 2022 11:23:28 -0500
Message-Id: <20220309162337.136773-11-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220309162337.136773-1-sashal@kernel.org>
References: <20220309162337.136773-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit c5048a7b2c23ab589f3476a783bd586b663eda5b ]

Register the CAN device only when all the necessary initialization is
completed. This patch makes sure all the data structures and locks are
initialized before registering the CAN device.

Link: https://lore.kernel.org/all/20220221225935.12300-1-prabhakar.mahadev-lad.rj@bp.renesas.com
Reported-by: Pavel Machek <pavel@denx.de>
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Pavel Machek <pavel@denx.de>
Reviewed-by: Ulrich Hecht <uli+renesas@fpond.eu>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/rcar/rcar_canfd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index edaa1ca972c1..d4e9815ca26f 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -1598,15 +1598,15 @@ static int rcar_canfd_channel_probe(struct rcar_canfd_global *gpriv, u32 ch,
 
 	netif_napi_add(ndev, &priv->napi, rcar_canfd_rx_poll,
 		       RCANFD_NAPI_WEIGHT);
+	spin_lock_init(&priv->tx_lock);
+	devm_can_led_init(ndev);
+	gpriv->ch[priv->channel] = priv;
 	err = register_candev(ndev);
 	if (err) {
 		dev_err(&pdev->dev,
 			"register_candev() failed, error %d\n", err);
 		goto fail_candev;
 	}
-	spin_lock_init(&priv->tx_lock);
-	devm_can_led_init(ndev);
-	gpriv->ch[priv->channel] = priv;
 	dev_info(&pdev->dev, "device registered (channel %u)\n", priv->channel);
 	return 0;
 
-- 
2.34.1

