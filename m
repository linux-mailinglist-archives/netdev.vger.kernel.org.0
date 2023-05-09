Return-Path: <netdev+bounces-1284-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97AA36FD2E3
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 01:00:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 68C60281251
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 23:00:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43B1F13AEE;
	Tue,  9 May 2023 22:59:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3429F11CAB
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 22:59:58 +0000 (UTC)
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFB4240E4;
	Tue,  9 May 2023 15:59:56 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id d75a77b69052e-3f39fd9eea1so5589221cf.1;
        Tue, 09 May 2023 15:59:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683673195; x=1686265195;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=aafVG4yBLLVm1k+fGPzulDd3yEFIbxpX+l1XJ3/shzs=;
        b=oVmrOwIjxYoLU3+sHGB33z4lZMV4ElZcb2yYTQTeN+HY4dsr1GDI/Tj/PiZ4vn7AVb
         EmXFrPn33xMbfOEyhxuUl/TEocCwndHalFWAxiK+KQ4SDMnxyGZrBLlf3TmucLEjOWQD
         xiiXfEvV4fZ+qwY+zVLWhSrLOtgAnWzTQmHNhstRKS9OuPlv+aJfUyRp/u5nWKbNwJPW
         /Wg+D2AEh+9fWP4opnXWYunsmrspUydu0idmw7Mk522uzWCaJuKEukERwvSifhudaNLG
         4P5scNDR2LmLxESXjG/zrRag0PubRODZHm9JYMMqFeJp31dyP1MYxie2ip6CFs+rV+SX
         jzZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683673195; x=1686265195;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aafVG4yBLLVm1k+fGPzulDd3yEFIbxpX+l1XJ3/shzs=;
        b=YHjuc6Atc9oCFEa0urOR21sOgKOsIcvJLktJT6jQz+qQ/vVrBKnjDTc8MVE/hqbiKQ
         L/cKtwCfvPV+NipUT78sI+bQTDMTzuGg6d9Mrsa4V5jC7vfD39oN3X48C6+PqCRGJ3t4
         gkHzsQtXF03DFnovujPKHJ1r/pbHQZC5oRjC0U9CMjF0k9IHfKXAb46U2Pp2bkzObwX7
         cMS8lf005XLsDMFM0bkn62YSSyF3Dsq6kRXM1d1iYa4Szfai7Ga3VXJ1hEKvlwlYadsS
         NaxrsaLA3oOwS2X97/S+2Bz45u4aQJ9phg3wrUjIfDAYCmCLH7d8b307fH1/qyfmqHI3
         Wnzg==
X-Gm-Message-State: AC+VfDyBI102PX+iMtxwx/6W9jHJ/Chj9iB0iVNybVHet7JH6ksQRNo0
	xcP9/iFPdc6LjmOyQZEBKE0Uh4+Wxxo=
X-Google-Smtp-Source: ACHHUZ76OGUw9xqvTd1h19J5JlowwqRRYBsyCmOU087wWKwgRFT+NmyHTec8TZG0U+udotnh6Ig5kA==
X-Received: by 2002:a05:622a:1a27:b0:3f0:b57b:3714 with SMTP id f39-20020a05622a1a2700b003f0b57b3714mr24470951qtb.56.1683673195348;
        Tue, 09 May 2023 15:59:55 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id c23-20020ac81e97000000b003f38b4167e5sm900857qtm.2.2023.05.09.15.59.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 15:59:54 -0700 (PDT)
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
Date: Tue,  9 May 2023 15:59:49 -0700
Message-Id: <20230509225949.1909013-1-f.fainelli@gmail.com>
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
RUNNING state since we are no longer stopping the PHY state machine.

Restore the call to phy_stop() but make it conditional on being called
fro the close or suspend path.

Fixes: 93e0401e0fc0 ("net: bcmgenet: Remove phy_stop() from bcmgenet_netif_stop()")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index bbd9d4b73402..a6fb913fa32e 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -3462,7 +3462,7 @@ static int bcmgenet_open(struct net_device *dev)
 	return ret;
 }
 
-static void bcmgenet_netif_stop(struct net_device *dev)
+static void bcmgenet_netif_stop(struct net_device *dev, bool stop_phy)
 {
 	struct bcmgenet_priv *priv = netdev_priv(dev);
 
@@ -3477,6 +3477,8 @@ static void bcmgenet_netif_stop(struct net_device *dev)
 	/* Disable MAC transmit. TX DMA disabled must be done before this */
 	umac_enable_set(priv, CMD_TX_EN, false);
 
+	if (stop_phy)
+		phy_stop(dev->phydev);
 	bcmgenet_disable_rx_napi(priv);
 	bcmgenet_intr_disable(priv);
 
@@ -3497,7 +3499,7 @@ static int bcmgenet_close(struct net_device *dev)
 
 	netif_dbg(priv, ifdown, dev, "bcmgenet_close\n");
 
-	bcmgenet_netif_stop(dev);
+	bcmgenet_netif_stop(dev, false);
 
 	/* Really kill the PHY state machine and disconnect from it */
 	phy_disconnect(dev->phydev);
@@ -4315,7 +4317,7 @@ static int bcmgenet_suspend(struct device *d)
 
 	netif_device_detach(dev);
 
-	bcmgenet_netif_stop(dev);
+	bcmgenet_netif_stop(dev, true);
 
 	if (!device_may_wakeup(d))
 		phy_suspend(dev->phydev);
-- 
2.34.1


