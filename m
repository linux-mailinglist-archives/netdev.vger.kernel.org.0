Return-Path: <netdev+bounces-4264-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A9AD770BD7D
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 14:21:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 63783280FE8
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 12:21:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D385D14296;
	Mon, 22 May 2023 12:16:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B66A514292
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 12:16:59 +0000 (UTC)
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 619101BD5;
	Mon, 22 May 2023 05:16:37 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id a640c23a62f3a-96f5685f902so569189366b.2;
        Mon, 22 May 2023 05:16:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684757785; x=1687349785;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=of7dhH8J3ho1PfuXe76W3u3tJHukqwcuraQIJQcYN60=;
        b=qWTaVgWkUzAJ06YY3hTPNp7zErtB8/KIq1sA0UBFKANHLaNi9kTWG+Iexjhx7sRc7T
         CUf0F+oRPCaTCziA8nv9p8qnq6S4K24BbLoTxpLz7Y1Z0XoRJmOkAUwHZy+2qDaIqbMd
         mIse49HGrVml3HYhG4vcUKquF4PmGXv7Fi7QEpUx/SvXtNIaYpNQiatHJYY+o7N4A8Ss
         zx2vZKFl88Z7svGALWMdOnDStY+Rl6aupg/ESSpiYsi9SUg2Q6mXgNIYnm0CG186vd/9
         CmhaR795SFKc8ntDNgXSJRdiQ6JJJW8BhviqYiMFe7E8IK13/+pRazkfFYUeqV+BlgRz
         m2Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684757785; x=1687349785;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=of7dhH8J3ho1PfuXe76W3u3tJHukqwcuraQIJQcYN60=;
        b=j5exVz/wQSqFfkgqgR4BcHXZS9eaSI2G13ZlUbXEkJozN67yd5dA3vdPdO5YHFX71m
         DlABZoBzGGEfgwVvAN1oOHY40kyuAtVQ6Se72W76rRQTaV5RQjQNBKqoM4ICi6ZCS+1d
         FfSyUQYEzLaivPfcr0yo0JNW9y7cglgd5IG/UMwbZq9wk6RyUFLi7JozOirDUA2oS2l8
         0in6vL6R0HeZRU1vajRnN5By1//P4F6VfGuuw/p5aZ+nGhlhcpvWDEpQCb3SB1tvI+7U
         1OZ8/FnAlalOesY9ZJjM8xV6H5R/9YUZR8hUTumjeKng62PmACHE99SlekiDLGYrVRVN
         1doQ==
X-Gm-Message-State: AC+VfDzTzAOsBCFS1ZYF+qqAuJ0RZjNrCvjLb3nLg5s6IBGB4SZeVUeZ
	5KnogGHdjwyTH2zkEcX9dOc=
X-Google-Smtp-Source: ACHHUZ5iPQRvAzfYeHS21dOJr4kXanM4mzWwkMni0MAf/pp0FexpqhAICo6YCIZpRsHeEJUcw9e59Q==
X-Received: by 2002:a17:906:5d08:b0:961:8570:4589 with SMTP id g8-20020a1709065d0800b0096185704589mr11089592ejt.30.1684757784983;
        Mon, 22 May 2023 05:16:24 -0700 (PDT)
Received: from arinc9-PC.. ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id y26-20020a17090614da00b009659fed3612sm2999950ejc.24.2023.05.22.05.16.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 05:16:24 -0700 (PDT)
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
Subject: [PATCH net-next 13/30] net: dsa: mt7530: move enabling port 6 to mt7530_setup_port6()
Date: Mon, 22 May 2023 15:15:15 +0300
Message-Id: <20230522121532.86610-14-arinc.unal@arinc9.com>
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

Enable port 6 only when port 6 is being used. Update the comment on
mt7530_setup() with a better explanation. Do not set MHWTRAP_MANUAL on
mt7530_setup_port5() as it's already done on mt7530_setup() beforehand.

Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/mt7530.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index fa48273269c4..47b89193d4cc 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -406,6 +406,8 @@ mt7530_setup_port6(struct dsa_switch *ds, phy_interface_t interface)
 	struct mt7530_priv *priv = ds->priv;
 	u32 ncpo1, ssc_delta, trgint, xtal;
 
+	mt7530_clear(priv, MT7530_MHWTRAP, MHWTRAP_P6_DIS);
+
 	xtal = mt7530_read(priv, MT7530_HWTRAP) & HWTRAP_XTAL_MASK;
 
 	switch (interface) {
@@ -897,7 +899,7 @@ static void mt7530_setup_port5(struct dsa_switch *ds, phy_interface_t interface)
 
 	val = mt7530_read(priv, MT7530_MHWTRAP);
 
-	val |= MHWTRAP_MANUAL | MHWTRAP_P5_MAC_SEL | MHWTRAP_P5_DIS;
+	val |= MHWTRAP_P5_MAC_SEL | MHWTRAP_P5_DIS;
 	val &= ~MHWTRAP_P5_RGMII_MODE & ~MHWTRAP_PHY0_SEL;
 
 	switch (priv->p5_intf_sel) {
@@ -2221,9 +2223,11 @@ mt7530_setup(struct dsa_switch *ds)
 		mt7530_rmw(priv, MT7530_TRGMII_RD(i),
 			   RD_TAP_MASK, RD_TAP(16));
 
-	/* Enable port 6 */
+	/* Directly access the PHY registers via C_MDC/C_MDIO. The bit that
+	 * enables modifying the hardware trap must be set for this.
+	 */
 	val = mt7530_read(priv, MT7530_MHWTRAP);
-	val &= ~MHWTRAP_P6_DIS & ~MHWTRAP_PHY_ACCESS;
+	val &= ~MHWTRAP_PHY_ACCESS;
 	val |= MHWTRAP_MANUAL;
 	mt7530_write(priv, MT7530_MHWTRAP, val);
 
-- 
2.39.2


