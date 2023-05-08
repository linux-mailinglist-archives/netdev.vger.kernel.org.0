Return-Path: <netdev+bounces-929-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C9F4C6FB665
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 20:44:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A80BD1C20A47
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 18:44:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D6111119F;
	Mon,  8 May 2023 18:43:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DEFE1119C
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 18:43:43 +0000 (UTC)
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECD2B5BBC;
	Mon,  8 May 2023 11:43:41 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id d75a77b69052e-3ef59098519so23077551cf.1;
        Mon, 08 May 2023 11:43:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683571420; x=1686163420;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7H4aUzk9O0HSo71mKo4xYqrEbVfwlYZS2aRn8IbuLRE=;
        b=RJf4B2GX7Um8hYq5h0lhBcJQWAkO7/LoIzdWoj/yffU59aPl31EMRzY+sXODa7mgHq
         YL6WRDqCUQD2q6DvbvfNJkpqfoBYAqU5B+V2f015BtznaOv40aOEtQGMi3tLYCSCf66a
         CZ/a7yUcCTWSlHuOBkSGahfa59zDiIC1sPcPK9a+eKI7DpW2ExA4N5C+AvgJUrkZints
         REkuh1MLD31fOm5n9w+ZE/e83giVrbvp0o8dK0luB9ES7AnObz1PXgDdlyFVgpUixJ/q
         74iVbSLaCFdE5Aus15IczOagO176ONV45VZBn+eQi7gWc2Z/cN8kVQGgSomidIP8Yp9s
         i1wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683571420; x=1686163420;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7H4aUzk9O0HSo71mKo4xYqrEbVfwlYZS2aRn8IbuLRE=;
        b=Ac8r40ZyNxRUiZcEqhorC34sfOKrnWXRqq8Ei/yErNnnY5j0bRT6Ysl/H6YFzlxver
         SmvR/2lQXQYQ0i6vHJpEgq5kBK+PsQucoO3N97yy7xJDGmWgI+XypEMeI1FO6PkM2N9M
         Zjw+sPzfKM5VWKWjzfLP9NHbWkvFfOTbWh8Oiisbmjmm3CBGs2wetk3wLzSsC+Vd7IDX
         9BGYdy7RhnKoQVCGLEygmga9YP3vw6qmUkfRfYzTZGkdbj5hH+uPxt4NCgBdvaw+OKio
         t8E125yzU6qet0QmJ1CVlmjHdxdtJYGtovlvoBSM6aSF3vrVBuk460LWVbsdLli2BkO1
         vg3g==
X-Gm-Message-State: AC+VfDx+4vOw6hsDNku721WJyh/IVQCHbqUDljRTu6prXt/okfsYSfP3
	40k5sA0YuIKDyFm6ZzjE3ibOXhCeuoc=
X-Google-Smtp-Source: ACHHUZ7GacSmAR3OEXzHHULrm8M+nqoQTai+I7GN3nXVIB782NEorOGdFMXHIKixYuGYZE3xzHcBBQ==
X-Received: by 2002:ac8:5a83:0:b0:3f0:a511:174f with SMTP id c3-20020ac85a83000000b003f0a511174fmr16610757qtc.20.1683571420564;
        Mon, 08 May 2023 11:43:40 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v26-20020ac83d9a000000b003d3a34d2eb2sm3193988qtf.41.2023.05.08.11.43.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 11:43:40 -0700 (PDT)
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
Subject: [PATCH net-next 3/3] net: bcmgenet: Add support for PHY-based Wake-on-LAN
Date: Mon,  8 May 2023 11:43:09 -0700
Message-Id: <20230508184309.1628108-4-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230508184309.1628108-1-f.fainelli@gmail.com>
References: <20230508184309.1628108-1-f.fainelli@gmail.com>
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


