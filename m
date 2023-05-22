Return-Path: <netdev+bounces-4263-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BEC7F70BD7B
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 14:21:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 94FB41C20A75
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 12:20:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C3831428D;
	Mon, 22 May 2023 12:16:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 713081428A
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 12:16:59 +0000 (UTC)
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7C7A10D4;
	Mon, 22 May 2023 05:16:36 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id a640c23a62f3a-96fbe7fbdd4so306467766b.3;
        Mon, 22 May 2023 05:16:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684757782; x=1687349782;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2+eXnKIFQ1zN+DpEz9mLEIzxzccBJHHMIoobq7TiAKA=;
        b=g2M5feJC+CnCKKXq4Wl51RLxMIWgD5pRAs1W7Qw84KVrsW06zGRUVeS2WCbvjgTdTg
         AXzNuqGyx6Kju4i8Ht8F5QEdVYqoq+rZXA2TMGOXLqgGTs1uaumXbsnQIi/IFzIdFwSr
         vNps/54AD4zty56kHO/bw3tYjUwVB7gA0r9XikpsPjHUEVyzgpkhyWcLt0Ju5qaCobru
         UWpQlEoQm5AWhkxcAUu+cyWqBNBxDy8AbrEoPix7tEpd4EEYSre7Slq2yzB5jFNcqQCq
         y4DQqvhU0NW565fHJ7ihCo+qapFbgU8Cto2w/dd/d66kD8yylqHSF0EPz+5wrlWdBnd5
         KqNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684757782; x=1687349782;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2+eXnKIFQ1zN+DpEz9mLEIzxzccBJHHMIoobq7TiAKA=;
        b=E/0mVSMUeMNVVvsH/MsrTE39NpcaE/T2871dXR/doXb4SfsdXSuuTGLCeEQQcJGDYd
         7OIaGpRlnaPNcJwdui2g/7b3iRUQVPFsP7hYp6f2e+zJy7W6Wfcfy7zxN2hjJwYjcOyI
         gyi1RI4dtK8q10rauf3CoB2P25fmdys4dlj8RoEeIhO3fIQlzgOnci75I4VTLTbSH1cV
         zAtG3PxYln8E1DT0wAM+4incL8RkHRh9BiJ63O0iC2InmC9BifWVKtWVuAtQovL6pKO9
         cVIdc6HF5dYj/MPeYGnpg5RivZj3Ie4rG0861CHRy7rq3zGPAu97+U8VBOwwXLrgo6AG
         c9mA==
X-Gm-Message-State: AC+VfDyhIkJIX3VdvBtduNv/+jISL/fO6g+c75BLDaqamfhxzcBSwU5z
	pXn+/dGP284pYF1t/QxKD5o=
X-Google-Smtp-Source: ACHHUZ4PugStt8I0/0LOWumrxGAi6wD5Ynmitsd3hv1KPGS/xHlV1TbhNrWv3RHYL/0jNbbeP19ATA==
X-Received: by 2002:a17:907:a07:b0:966:3c82:4a95 with SMTP id bb7-20020a1709070a0700b009663c824a95mr10266587ejc.19.1684757781976;
        Mon, 22 May 2023 05:16:21 -0700 (PDT)
Received: from arinc9-PC.. ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id y26-20020a17090614da00b009659fed3612sm2999950ejc.24.2023.05.22.05.16.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 05:16:21 -0700 (PDT)
From: arinc9.unal@gmail.com
X-Google-Original-From: arinc.unal@arinc9.com
To: Sean Wang <sean.wang@mediatek.com>,
	Landen Chao <Landen.Chao@mediatek.com>,
	DENG Qingfang <dqfext@gmail.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Russell King <linux@armlinux.org.uk>
Cc: =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
	Richard van Schagen <richard@routerhints.com>,
	Richard van Schagen <vschagen@cs.com>,
	Frank Wunderlich <frank-w@public-files.de>,
	Bartel Eerdekens <bartel.eerdekens@constell8.be>,
	erkin.bozoglu@xeront.com,
	mithat.guner@xeront.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH net-next 12/30] net: dsa: mt7530: move XTAL check to mt7530_setup()
Date: Mon, 22 May 2023 15:15:14 +0300
Message-Id: <20230522121532.86610-13-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230522121532.86610-1-arinc.unal@arinc9.com>
References: <20230522121532.86610-1-arinc.unal@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Arınç ÜNAL <arinc.unal@arinc9.com>

The crystal frequency concerns the switch core. The frequency should be
checked when the switch is being set up so the driver can reject the
unsupported hardware earlier and without requiring port 6 to be used.

Move it to mt7530_setup().

Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/mt7530.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 049f7be0d790..fa48273269c4 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -408,13 +408,6 @@ mt7530_setup_port6(struct dsa_switch *ds, phy_interface_t interface)
 
 	xtal = mt7530_read(priv, MT7530_HWTRAP) & HWTRAP_XTAL_MASK;
 
-	if (xtal == HWTRAP_XTAL_20MHZ) {
-		dev_err(priv->dev,
-			"%s: MT7530 with a 20MHz XTAL is not supported!\n",
-			__func__);
-		return -EINVAL;
-	}
-
 	switch (interface) {
 	case PHY_INTERFACE_MODE_RGMII:
 		trgint = 0;
@@ -2133,7 +2126,7 @@ mt7530_setup(struct dsa_switch *ds)
 	struct mt7530_dummy_poll p;
 	phy_interface_t interface;
 	struct dsa_port *cpu_dp;
-	u32 id, val;
+	u32 id, val, xtal;
 	int ret, i;
 
 	/* The parent node of master netdev which holds the common system
@@ -2203,6 +2196,15 @@ mt7530_setup(struct dsa_switch *ds)
 		return -ENODEV;
 	}
 
+	xtal = mt7530_read(priv, MT7530_HWTRAP) & HWTRAP_XTAL_MASK;
+
+	if (xtal == HWTRAP_XTAL_20MHZ) {
+		dev_err(priv->dev,
+			"%s: MT7530 with a 20MHz XTAL is not supported!\n",
+			__func__);
+		return -EINVAL;
+	}
+
 	/* Reset the switch through internal reset */
 	mt7530_write(priv, MT7530_SYS_CTRL,
 		     SYS_CTRL_PHY_RST | SYS_CTRL_SW_RST |
-- 
2.39.2


