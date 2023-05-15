Return-Path: <netdev+bounces-2469-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A06D57021DF
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 04:56:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A873B1C20A0C
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 02:56:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD8C015D2;
	Mon, 15 May 2023 02:56:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0DF1EA0
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 02:56:13 +0000 (UTC)
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87095E78;
	Sun, 14 May 2023 19:56:12 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id 41be03b00d2f7-528cdc9576cso8362373a12.0;
        Sun, 14 May 2023 19:56:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684119371; x=1686711371;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=X4xhz39Eaz6LAnCrMNzbKA/+Cn9J+aJWsPIquB3prFM=;
        b=J6n5ChuF+lyefafB9qQpBzw//WZCeagGw0SDWgzNgpzkx+cSwJ84iAOI6xRf3DtKPC
         Waeuj1yjyd/HG6zp6JPxGZJXNT/rVnRvzTExckiLUwJ5KTSDiyhfgNC6GP0/gFNtcihq
         yboS8kIPV5N48ITOVKYpxq3Us/JOvBnvyCOXx5Zt1Gn/1h7+JX6+GG1RaK6BAiIr6IFD
         +FfRfZRMXZYSW/d+sAQthDvM5JyNIAxBCkJDh2HmnHEoXPb0lbFBCPrQ8hPCpGHQa7ON
         lYsgva/ASsKaRhcqn8xUm/V3G8urORLdtNKjPQCcn31noSGe1/luxc4lZaolaQUBiRxA
         RUrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684119371; x=1686711371;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X4xhz39Eaz6LAnCrMNzbKA/+Cn9J+aJWsPIquB3prFM=;
        b=MVF4jWY+R7Jsu8O5Th+RTk35lNXdEo4DLckijRW9kS6vss7N/ULf44XNecbXozGHty
         2cfwax/X6r5wMGf7NU6wcbd0082jTBgSfkzHslz1rUYZiWBWlkTZi8m2Wids9/2yyrY8
         Gcko0ABGOQyGWT9DN8XlN1FWqJY2fhEKRYJxk9rvNCLssdhTAe0DLYKh8jE5jn8QKLW4
         6w+0y20PEH7Y/LrUiTe59mhKeW/A0SSzHVqErjpjjM2iQA+UhF+rh4cdaoGkOa0U2r03
         Q6LuqT85VvKsLCuCzKbVppcHKOqGweXBsoaKOuNzf+mfLzNumE/n4s++UxLct+rWoGQX
         OscA==
X-Gm-Message-State: AC+VfDxGHShilZSZgZ1fovQkS+zoE1a4AyG0DREvg97Lx/3XzdllZ1ps
	toG/UQ7ac1IyqA6hK6fONkT5vV8mxfc=
X-Google-Smtp-Source: ACHHUZ55O7cwRUE3BGMWAH5ypbjwCv+kyOBAl6bmYRMzY5cz0vBaghfVaPejTXm/+3f1uk5QugTQTw==
X-Received: by 2002:a17:902:ab5c:b0:1ae:1f8a:8a9c with SMTP id ij28-20020a170902ab5c00b001ae1f8a8a9cmr1091146plb.64.1684119371400;
        Sun, 14 May 2023 19:56:11 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h11-20020a170902b94b00b00194d14d8e54sm12201194pls.96.2023.05.14.19.56.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 May 2023 19:56:10 -0700 (PDT)
From: Florian Fainelli <f.fainelli@gmail.com>
To: netdev@vger.kernel.org
Cc: Florian Fainelli <f.fainelli@gmail.com>,
	Doug Berger <opendmb@gmail.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] net: bcmgenet: Restore phy_stop() depending upon suspend/close
Date: Sun, 14 May 2023 19:56:07 -0700
Message-Id: <20230515025608.2587012-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Removing the phy_stop() from bcmgenet_netif_stop() ended up causing
warnings from the PHY library that phy_start() is called from the
RUNNING state since we are no longer stopping the PHY state machine
during bcmgenet_suspend().

Restore the call to phy_stop() but make it conditional on being called
from the close or suspend path.

Fixes: c96e731c93ff ("net: bcmgenet: connect and disconnect from the PHY state machine")
Fixes: 93e0401e0fc0 ("net: bcmgenet: Remove phy_stop() from bcmgenet_netif_stop()")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index f28ffc31df22..eca0c92c0c84 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -3450,7 +3450,7 @@ static int bcmgenet_open(struct net_device *dev)
 	return ret;
 }
 
-static void bcmgenet_netif_stop(struct net_device *dev)
+static void bcmgenet_netif_stop(struct net_device *dev, bool stop_phy)
 {
 	struct bcmgenet_priv *priv = netdev_priv(dev);
 
@@ -3465,6 +3465,8 @@ static void bcmgenet_netif_stop(struct net_device *dev)
 	/* Disable MAC transmit. TX DMA disabled must be done before this */
 	umac_enable_set(priv, CMD_TX_EN, false);
 
+	if (stop_phy)
+		phy_stop(dev->phydev);
 	bcmgenet_disable_rx_napi(priv);
 	bcmgenet_intr_disable(priv);
 
@@ -3485,7 +3487,7 @@ static int bcmgenet_close(struct net_device *dev)
 
 	netif_dbg(priv, ifdown, dev, "bcmgenet_close\n");
 
-	bcmgenet_netif_stop(dev);
+	bcmgenet_netif_stop(dev, false);
 
 	/* Really kill the PHY state machine and disconnect from it */
 	phy_disconnect(dev->phydev);
@@ -4303,7 +4305,7 @@ static int bcmgenet_suspend(struct device *d)
 
 	netif_device_detach(dev);
 
-	bcmgenet_netif_stop(dev);
+	bcmgenet_netif_stop(dev, true);
 
 	if (!device_may_wakeup(d))
 		phy_suspend(dev->phydev);
-- 
2.34.1


