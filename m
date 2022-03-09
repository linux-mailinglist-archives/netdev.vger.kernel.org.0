Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B54FD4D3488
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 17:25:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235182AbiCIQZe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 11:25:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238401AbiCIQWF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 11:22:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 948DF3A5;
        Wed,  9 Mar 2022 08:21:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3085C6194C;
        Wed,  9 Mar 2022 16:21:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83353C340F6;
        Wed,  9 Mar 2022 16:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646842865;
        bh=xYDt82oztVLPKZHK4RGXMtKudy0jz5x/oNRMn0IWQ5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GSkfG+9WFJbpiObp8Z3W88v9WxgMy3aGrnieGD2iMt9+mqp3Fs9n4OMI+1wl0LhZJ
         iGlnsbdeaCf52b9G4pmphTxtkCHxWekNWHpVL6p5uRKq6XTAlHN1nrHOy/6/yuPiGj
         esXhgW/2U2GcDDC5vKXQqzd9TGapNf7N+EuUSlEyc3SPnHXG9yOTp0q+bXaNaGs0TJ
         hDggtrFhQ+hBFflaHGagU49RhM5mF0ufFxTaBNowRQwDE55odagRk0jwejPgJAohJQ
         FnbZ7BOboEHrxC2Ofda9R4Y6dfcGD9NFkLiqW0bEGt47qqMPihoei5oIcpu6Sob6Ee
         NYk35zWcvu3YA==
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
Subject: [PATCH AUTOSEL 5.15 14/24] can: rcar_canfd: rcar_canfd_channel_probe(): register the CAN device when fully ready
Date:   Wed,  9 Mar 2022 11:19:33 -0500
Message-Id: <20220309161946.136122-14-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220309161946.136122-1-sashal@kernel.org>
References: <20220309161946.136122-1-sashal@kernel.org>
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
index 388521e70837..2f44c567ebd7 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -1720,15 +1720,15 @@ static int rcar_canfd_channel_probe(struct rcar_canfd_global *gpriv, u32 ch,
 
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

