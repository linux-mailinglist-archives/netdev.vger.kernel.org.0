Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2D44D35CF
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 18:42:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236640AbiCIQgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 11:36:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238569AbiCIQbc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 11:31:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5916C199D75;
        Wed,  9 Mar 2022 08:25:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA2AEB821FD;
        Wed,  9 Mar 2022 16:25:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F267FC340F9;
        Wed,  9 Mar 2022 16:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646843154;
        bh=nJtRHfaLe5NTL07RaKpu2Xj7ndP+2DVwsE9w+qaCDaI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AVRVCY4gDjwIT56WAXJo1HIXXGcVsbs4DahHXhvYrh+gzZmogWGGkazFZT1kl5Yfi
         RZU5Cjc4PzfvPspxfU4vdGCqd84tm8ZST2KUDtzN0bTkbxvNxu+W+M2ON57+tDcDH5
         R3wZKrjTm1mrYqY4sYsdp69Hl7VeNTTFDPtmetMnpqspyC31Sw+zMpxuJyE8wbCA0Q
         63DrgSzqE7wO1SbO24xoFYfxhG1t2F0AmDHPy9f2MOW1KuNA60K8PUQxqdE/K6Eqt9
         s5p49COjSTz/M7cMSYtJYmTVhGzM+abddqaGTQ3pR2I9B/Ir2VO0gMV6SHnFD23kkM
         mLA4eb1wcjVPA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Pavel Machek <pavel@denx.de>,
        Ulrich Hecht <uli+renesas@fpond.eu>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>, wg@grandegger.com,
        davem@davemloft.net, kuba@kernel.org, stefan.maetje@esd.eu,
        mailhol.vincent@wanadoo.fr, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 08/14] can: rcar_canfd: rcar_canfd_channel_probe(): register the CAN device when fully ready
Date:   Wed,  9 Mar 2022 11:25:01 -0500
Message-Id: <20220309162508.137035-8-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220309162508.137035-1-sashal@kernel.org>
References: <20220309162508.137035-1-sashal@kernel.org>
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
index 786d852a70d5..a1634834b640 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -1602,15 +1602,15 @@ static int rcar_canfd_channel_probe(struct rcar_canfd_global *gpriv, u32 ch,
 
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

