Return-Path: <netdev+bounces-1278-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C37C66FD2BF
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 00:35:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 67F5B1C20C75
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 22:35:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CD1311CA2;
	Tue,  9 May 2023 22:34:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51F0B13AC1
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 22:34:39 +0000 (UTC)
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22B6819A2;
	Tue,  9 May 2023 15:34:38 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-643b7b8f8ceso2905300b3a.1;
        Tue, 09 May 2023 15:34:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683671677; x=1686263677;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7H4aUzk9O0HSo71mKo4xYqrEbVfwlYZS2aRn8IbuLRE=;
        b=fM7jytHoFrKiELsVKEQV6nExVkg8Qu7aTBuHap0fWorYOsfaMeMeRRn3kY+8D9vtBE
         kXTp7q0HkbUb2eexmd30LuhCSLjP8va5a5ldeSNW+YUGVJOx8SQrg9BR2MuaEwGRjG3R
         ujagQnNqHARCJ5XIXua9SC3PV8e3GKrl13YDz5wE/cj653zTb8Ru4MVhTuFLarVn4zfC
         TzNtBCQR4vUL5s+LGn//81WBKazhMj1NtE2msp7fBFeK1lnbB9UCrC0eE055/K/I3lNM
         Q8a+JvWNgZrII0P9zDVqluLGeXNcyoYUXNr1r49cW3DlohI+dOrqfA9sOjejlYfJsYZY
         kpdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683671677; x=1686263677;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7H4aUzk9O0HSo71mKo4xYqrEbVfwlYZS2aRn8IbuLRE=;
        b=gYCDQZ6PlnmqlZ1RBWo1eZkM3o+Uac8f4eydWD3pINpUG+WjyxGo+we2Xt59Loy/Lv
         JvkTz3I3ct334w4zmSdF/8D4fTLw33UcNo8ht3CNfjay2ysg6tnB8lXq20uVPpGixGn4
         yRaHca3UiQe4l4jIxmvrc8i8QUJV7+Gpc87B4kDz7yOXclqxYg5esuRyxWrrpkqMKG16
         YveAVP445+PxPut5tlJ26e+Xpmp+3xIh9JX6w+vN8QkQkYjxFozLJAix5+uGMOdAgp2s
         5dto5oBgx+t7qPFz+FjuCB5M2RX4u1YSn/T3KzhZxSKYMFGoi+eXyUYlTySrH2yUHMx9
         aSZQ==
X-Gm-Message-State: AC+VfDz6Fjn6J5rXmXFoqV4IX7WcZmdl84y1p+KRUgt+b/mp9RMC9w86
	gAGM+5aPHbYP5GDOGTvyT8itM9mLtl4=
X-Google-Smtp-Source: ACHHUZ7Psi+ZtnuMiB09+IT2BGW69Wp+UfI9SOdb42U8SDQMgJLxNfRMhCDtuJ+fzM4DnJCEHRZfaw==
X-Received: by 2002:a05:6a00:2384:b0:63f:34d9:d725 with SMTP id f4-20020a056a00238400b0063f34d9d725mr21565317pfc.14.1683671677154;
        Tue, 09 May 2023 15:34:37 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id p5-20020aa78605000000b006438898ce82sm2317274pfn.140.2023.05.09.15.34.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 15:34:36 -0700 (PDT)
From: Florian Fainelli <f.fainelli@gmail.com>
To: netdev@vger.kernel.org
Cc: Florian Fainelli <f.fainelli@gmail.com>,
	Doug Berger <opendmb@gmail.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Peter Geis <pgwipeout@gmail.com>,
	Frank <Frank.Sae@motor-comm.com>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next v2 3/3] net: bcmgenet: Add support for PHY-based Wake-on-LAN
Date: Tue,  9 May 2023 15:34:03 -0700
Message-Id: <20230509223403.1852603-4-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230509223403.1852603-1-f.fainelli@gmail.com>
References: <20230509223403.1852603-1-f.fainelli@gmail.com>
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

If available, interrogate the PHY to find out whether we can use it for
Wake-on-LAN. This can be a more power efficient way of implementing
that feature, especially when the MAC is powered off in low power
states.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
index 3a4b6cb7b7b9..7a41cad5788f 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
@@ -42,6 +42,12 @@ void bcmgenet_get_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
 	struct bcmgenet_priv *priv = netdev_priv(dev);
 	struct device *kdev = &priv->pdev->dev;
 
+	if (dev->phydev) {
+		phy_ethtool_get_wol(dev->phydev, wol);
+		if (wol->supported)
+			return;
+	}
+
 	if (!device_can_wakeup(kdev)) {
 		wol->supported = 0;
 		wol->wolopts = 0;
@@ -63,6 +69,14 @@ int bcmgenet_set_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
 {
 	struct bcmgenet_priv *priv = netdev_priv(dev);
 	struct device *kdev = &priv->pdev->dev;
+	int ret;
+
+	/* Try Wake-on-LAN from the PHY first */
+	if (dev->phydev) {
+		ret = phy_ethtool_set_wol(dev->phydev, wol);
+		if (ret != -EOPNOTSUPP)
+			return ret;
+	}
 
 	if (!device_can_wakeup(kdev))
 		return -ENOTSUPP;
-- 
2.34.1


