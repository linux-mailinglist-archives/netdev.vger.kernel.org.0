Return-Path: <netdev+bounces-4266-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EAED70BD84
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 14:22:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CD8AA281031
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 12:22:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2790914A8E;
	Mon, 22 May 2023 12:17:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 166FE14A85
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 12:17:03 +0000 (UTC)
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3298A1BE5;
	Mon, 22 May 2023 05:16:41 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id a640c23a62f3a-96f6e83e12fso489609266b.1;
        Mon, 22 May 2023 05:16:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684757791; x=1687349791;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dlwuz8s8MG9ZZ2zJmGEfllL6UDiR42hxKGeFHL77wpU=;
        b=UEIShbHZWhZsbZeQbvyhXu/8Kq1bhc3dzJxhf5mfe6olRkFTrfLEijjwFLQKWL97YC
         5WStn3RP1m8lgVuDZ1p+umTtHFVh4UwI8Nl0wmhKbHSUXJqDRtVH9lpHzpiQswkEw8vS
         EoYmqxNQgxt0os1uzsopMY3dPAgjhDyR8rdHEFFAlLKg7UBx+LJzSJm9YoEQ78XhCyd1
         JfslVUBJrtI6Wc3++0vzZz8VSO4eGWNl2mm/AdqCy/yo3eFxEdVPjM2r9H1S2HPi8IQe
         rdMHeufvf8xKWlPY0LnoN3pkY6nDoL+O71K61V5a+batec74NzjJnpRXiSGwFUjCjTjs
         XVcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684757791; x=1687349791;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dlwuz8s8MG9ZZ2zJmGEfllL6UDiR42hxKGeFHL77wpU=;
        b=LHnP0tZLj+OX+eDXvrvR4PqUsgGwnnclRWgdAO0E1yw3XD+8qUQvh7JgyMebfCHjbY
         Ugh953mGJIF9OS+iOV/dnqnJZBvslkbJWYFg3fytmN67MnL20AP/hwS4pP4n6UFeR1rm
         aOr2ZJvPCSSf5xmeJ4Li7jd9S3myOBetvlK34yFQP61OalGnE6FmaMUA9CD4FlBMQ+dw
         h6wC7Y1uK09g37AXmYNBJFapWTP6R2fsSXpBdljESDY1VcRLEAJeplQvH+v93y/pQPWZ
         LU//cBFKOuwZwhHUztWWus7hsKaRAALDnBNMz445Sc/ku9mt0U5UVEV59eTYedGuoUSL
         4YfQ==
X-Gm-Message-State: AC+VfDxuKrVrA3LsM8H6y1Q/m3LxVJ0D9clRYkGQFMd4cEY7d98/zYmT
	sbqlGtqWIpj9dO8j1Y6vldw=
X-Google-Smtp-Source: ACHHUZ5K0fPYC0TlTCr56XwGyY9dtgGsEV/w/6Bdf+rf3wZGm0fO0vJJ3i0TQL/6KIzBTJ8yzBpuIA==
X-Received: by 2002:a17:907:2ce4:b0:966:a691:678d with SMTP id hz4-20020a1709072ce400b00966a691678dmr8553648ejc.51.1684757790936;
        Mon, 22 May 2023 05:16:30 -0700 (PDT)
Received: from arinc9-PC.. ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id y26-20020a17090614da00b009659fed3612sm2999950ejc.24.2023.05.22.05.16.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 05:16:30 -0700 (PDT)
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
Subject: [PATCH net-next 15/30] net: dsa: mt7530: set TRGMII RD TAP if trgmii is being used
Date: Mon, 22 May 2023 15:15:17 +0300
Message-Id: <20230522121532.86610-16-arinc.unal@arinc9.com>
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

This code sets the Read Data (RD) TAP value to 16 for all TRGMII control
registers.

The for loop iterates over all the TRGMII control registers, and
mt7530_rmw() function is used to perform a read-modify-write operation on
each register's RD_TAP field to set its value to 16.

This operation is used to tune the timing of the read data signal in
TRGMII to match the TX signal of the link partner.

Run this if trgmii is being used. Since this code doesn't lower the
driving, there's no apparent benefit to run this if trgmii is not being
used.

Add a comment to explain the code.

Thanks to 趙皎宏 (Landen Chao) for pointing out what the code does.

Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/mt7530.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 744787e38ecc..f2c1aa9cf7f7 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -404,7 +404,7 @@ static void
 mt7530_setup_port6(struct dsa_switch *ds, phy_interface_t interface)
 {
 	struct mt7530_priv *priv = ds->priv;
-	u32 ncpo1, ssc_delta, xtal;
+	u32 ncpo1, ssc_delta, i, xtal;
 
 	mt7530_clear(priv, MT7530_MHWTRAP, MHWTRAP_P6_DIS);
 
@@ -455,6 +455,11 @@ mt7530_setup_port6(struct dsa_switch *ds, phy_interface_t interface)
 
 		/* Enable the MT7530 TRGMII clocks */
 		core_set(priv, CORE_TRGMII_GSW_CLK_CG, REG_TRGMIICK_EN);
+
+		/* Set the Read Data TAP value of the MT7530 TRGMII */
+		for (i = 0; i < NUM_TRGMII_CTRL; i++)
+			mt7530_rmw(priv, MT7530_TRGMII_RD(i),
+				   RD_TAP_MASK, RD_TAP(16));
 	}
 }
 
@@ -2209,10 +2214,6 @@ mt7530_setup(struct dsa_switch *ds)
 		mt7530_write(priv, MT7530_TRGMII_TD_ODT(i),
 			     TD_DM_DRVP(8) | TD_DM_DRVN(8));
 
-	for (i = 0; i < NUM_TRGMII_CTRL; i++)
-		mt7530_rmw(priv, MT7530_TRGMII_RD(i),
-			   RD_TAP_MASK, RD_TAP(16));
-
 	/* Directly access the PHY registers via C_MDC/C_MDIO. The bit that
 	 * enables modifying the hardware trap must be set for this.
 	 */
-- 
2.39.2


