Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFD746D88CF
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 22:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234117AbjDEUk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 16:40:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234275AbjDEUkC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 16:40:02 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 302AB83F0;
        Wed,  5 Apr 2023 13:39:27 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id n10-20020a05600c4f8a00b003ee93d2c914so24132457wmq.2;
        Wed, 05 Apr 2023 13:39:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680727165;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ccZfgD4+ftjQv7yPb/kHCV5/7qZA3IEA73eZ7Pnga5c=;
        b=bvFO76O+4mQqrUZx4Mm3FNB2nH+NrpS71Z37Z4lv9VtwxMlwNAI7Mg0VVTQ+c1pTbO
         mUn/HmOB2IkOqc7wPnn8l2GJeoBU0OgNv7IpBYJSF0ns3+Y6S7UEbyKFLRMIaWNInbs/
         vrGBNmjgSMWR86c3yc/75BrdQTUlvpHfNgEM0iXWPR3xO0uGAE2XMSC3xGhrPE1arilr
         RzBqpM8sNI6R/1kzAoSFofsFAS0+7EZzbfCw8EMXTBHi9kRVohxpS00rt/A/0SqISSwj
         bXCax3p+WrE/HBdKJPsdw9F7M2dteCEK5aVZCqvjdI/+H1Z34GCSTmnmpFse5fcSKdKB
         bfjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680727165;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ccZfgD4+ftjQv7yPb/kHCV5/7qZA3IEA73eZ7Pnga5c=;
        b=oRryuLrbdr+k4rgPz+8eB/URWWXw3lrnaT6VgOJM8dbX3v4VkBin0Fv/QNmGQTqUNm
         oTOxA77v6Qk8QCKy0OfRXSlWZMB6I+D438Jqj/NdJ/nptAW5mLwOEJPPOpr1cG+PYsfe
         AWC7yONcMTdoBoqxxSLBklQAylTQ9Eg+E8JKNAyhHrF7/qtvzKJdiwRXY2gNQ7g82rSa
         J11AehTao2sDbsti0azSMFYOc7biZ6DS7Bbt1s95zSNiUmZzqv90if/9jm6wrmMCkgRY
         3NM9z1VJZF6u0c1MkFLi2m50v7O4Q3Afat3J1945RaM8jEPDxAdaiovD7pkSYkoTC712
         NXLQ==
X-Gm-Message-State: AAQBX9cIf/i0ijdmzrO2Cf1zX3Eqh9nSZizeBRoRGJGIWyu+UU3LjtJG
        WozrdlS5qhUg02PCm/Ousk0=
X-Google-Smtp-Source: AKy350ZdEE8tqvVToRyuOt+VCUs/QF+vsXg1tVkXot5P9IJK1jRnKbUv9hfZyF/Ef04I09pLSAX/iA==
X-Received: by 2002:a7b:ca48:0:b0:3ee:ed5:6115 with SMTP id m8-20020a7bca48000000b003ee0ed56115mr5638813wml.19.1680727165506;
        Wed, 05 Apr 2023 13:39:25 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id p19-20020a05600c469300b003eda46d6792sm3259867wmo.32.2023.04.05.13.39.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 13:39:25 -0700 (PDT)
From:   arinc9.unal@gmail.com
X-Google-Original-From: arinc.unal@arinc9.com
To:     =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>,
        Sean Wang <sean.wang@mediatek.com>,
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
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        Richard van Schagen <richard@routerhints.com>,
        Richard van Schagen <vschagen@cs.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [RFC PATCH net-next 09/12] net: dsa: mt7530: move enabling port 6 to mt7530_setup_port6()
Date:   Wed,  5 Apr 2023 23:38:56 +0300
Message-Id: <20230405203859.391267-10-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230405203859.391267-1-arinc.unal@arinc9.com>
References: <20230405203859.391267-1-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arınç ÜNAL <arinc.unal@arinc9.com>

Enable port 6 only when port 6 is being used. Read the HWTRAP_XTAL_MASK
value from val now that val is equal to the value of MT7530_MHWTRAP.

Update the comment on mt7530_setup() with a better explanation.

Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---

Do I need to protect the register from being accessed by processes while
this operation is being done? I don't see this on mt7530_setup() but it's
being done on mt7530_setup_port5().

There's an oddity here. The XTAL mask is defined on the MT7530_HWTRAP
register, but it's being read from MT7530_MHWTRAP instead which is at a
different address.

HWTRAP_XTAL_MASK and reading HWTRAP_XTAL_MASK from MT7530_MHWTRAP was both
added with:

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit?id=7ef6f6f8d237fa6724108b57d9706cb5069688e4

I did this to test it:

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 46749aee3c49..7aa3b5828ac3 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -404,7 +404,7 @@ static int
 mt7530_setup_port6(struct dsa_switch *ds, phy_interface_t interface)
 {
 	struct mt7530_priv *priv = ds->priv;
-	u32 ncpo1, ssc_delta, trgint, xtal, val;
+	u32 ncpo1, ssc_delta, trgint, xtal, xtal2, val;
 
 	/* Enable port 6 */
 	val = mt7530_read(priv, MT7530_MHWTRAP);
@@ -413,6 +413,21 @@ mt7530_setup_port6(struct dsa_switch *ds, phy_interface_t interface)
 	mt7530_write(priv, MT7530_MHWTRAP, val);
 
 	xtal = val & HWTRAP_XTAL_MASK;
+	xtal2 = mt7530_read(priv, MT7530_HWTRAP) & HWTRAP_XTAL_MASK;
+
+	if (xtal == HWTRAP_XTAL_20MHZ)
+		dev_info(priv->dev, "xtal 20 Mhz\n");
+	if (xtal == HWTRAP_XTAL_25MHZ)
+		dev_info(priv->dev, "xtal 25 Mhz\n");
+	if (xtal == HWTRAP_XTAL_40MHZ)
+		dev_info(priv->dev, "xtal 40 Mhz\n");
+
+	if (xtal2 == HWTRAP_XTAL_20MHZ)
+		dev_info(priv->dev, "actual xtal 20 Mhz\n");
+	if (xtal2 == HWTRAP_XTAL_25MHZ)
+		dev_info(priv->dev, "actual xtal 25 Mhz\n");
+	if (xtal2 == HWTRAP_XTAL_40MHZ)
+		dev_info(priv->dev, "actual xtal 40 Mhz\n");
 
 	if (xtal == HWTRAP_XTAL_20MHZ) {
 		dev_err(priv->dev,

Both ended up reporting 40 Mhz so I'm not sure if this is a bug or intended
to be done this way.

Please advise.

Arınç

---
 drivers/net/dsa/mt7530.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 0a6d1c0872be..70a673347cf9 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -404,9 +404,13 @@ static int
 mt7530_setup_port6(struct dsa_switch *ds, phy_interface_t interface)
 {
 	struct mt7530_priv *priv = ds->priv;
-	u32 ncpo1, ssc_delta, trgint, xtal;
+	u32 ncpo1, ssc_delta, trgint, xtal, val;
 
-	xtal = mt7530_read(priv, MT7530_MHWTRAP) & HWTRAP_XTAL_MASK;
+	val = mt7530_read(priv, MT7530_MHWTRAP);
+	val &= ~MHWTRAP_P6_DIS;
+	mt7530_write(priv, MT7530_MHWTRAP, val);
+
+	xtal = val & HWTRAP_XTAL_MASK;
 
 	if (xtal == HWTRAP_XTAL_20MHZ) {
 		dev_err(priv->dev,
@@ -2235,9 +2239,9 @@ mt7530_setup(struct dsa_switch *ds)
 		mt7530_rmw(priv, MT7530_TRGMII_RD(i),
 			   RD_TAP_MASK, RD_TAP(16));
 
-	/* Enable port 6 */
+	/* Enable PHY access and operate in manual mode */
 	val = mt7530_read(priv, MT7530_MHWTRAP);
-	val &= ~MHWTRAP_P6_DIS & ~MHWTRAP_PHY_ACCESS;
+	val &= ~MHWTRAP_PHY_ACCESS;
 	val |= MHWTRAP_MANUAL;
 	mt7530_write(priv, MT7530_MHWTRAP, val);
 
-- 
2.37.2

