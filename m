Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDADD6EAD2D
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 16:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232705AbjDUOit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 10:38:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232766AbjDUOiE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 10:38:04 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A471F1447F;
        Fri, 21 Apr 2023 07:37:29 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id 4fb4d7f45d1cf-504eb1155d3so12779087a12.1;
        Fri, 21 Apr 2023 07:37:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682087848; x=1684679848;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iqk+YQP+i1PdHjajC4dyLWTaH2it3zPPQXlXdlRzGds=;
        b=cf0zqaREVOCi7KHT07q3yLerukZj1DdsamHxw3nAfGf21FvfVLMwaFHxjD2YoWIXgI
         drCjiWM9q8hPTIOp6pBsWcDaK+ikNLb8nOIDTI0LrEBkHUGePoE4jjq2G/ZJY4nG2At6
         GiS/p0NHBqabpE1dl14vNEzHRQ7K3rShpPZ7SqjkNqNYYGcgRFdctl+YBgEvha1KLeDB
         KE9P5pZ1Z9ktkTocVlxJX+5IgZvQD35YupLPh/asFLqJuHBHM95yTQKH5fbKpK2bgLAH
         IQBr1GfuK67lufwBpuT2FZeXAcqjch52zWBszntCOrp6Nts1CMenoOi9yX4ScYqpz13Y
         lfxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682087848; x=1684679848;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iqk+YQP+i1PdHjajC4dyLWTaH2it3zPPQXlXdlRzGds=;
        b=FEjTGS3lqEUgXLV/TpGkHDbzscucC+Pw+r7LP1zK6WNWAHUsowFJ2WBkwVdreYXu/i
         rhFd4Mqlkyum071QTv1YdkboLd8lWrFeDX52bvJmGERHmFoBjeVZIdUIGpXlfxdsyXdp
         PsnlMQLY7yHmiPHIJRFseKukDHm9OWRrBP1ZHPGRESVlABPvJ0YWtpHfEaJQDFLlp5zO
         1wb5W4dpSyWaIUcMW0YpeL6OqNDpRzaFF7gUWHsxCRRPvB5gYFfqQmi9AaZ736k2aQ5A
         x7T+b/Zn1CStLJL4u7Z16EUD05Hnhg776VXa5zYNrng+CaamtZWwV0/zw9DhTtxVtQaH
         DTJw==
X-Gm-Message-State: AAQBX9d1kkCs2V9cPFvbdZbqJ7RzttirvzTR31D8HrrYF5/Ff1DeEd6/
        QElawucwPSkSVrp+69ZGRdQ=
X-Google-Smtp-Source: AKy350aPdNFYI49dGLs5/XT2/bnUBnFqKOWqWRnqhq9XX7GP1nm0/K86h6KfOywXTrmQtK7UoDHnWg==
X-Received: by 2002:a17:906:1387:b0:94a:6229:8fc1 with SMTP id f7-20020a170906138700b0094a62298fc1mr2596198ejc.31.1682087847872;
        Fri, 21 Apr 2023 07:37:27 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id q27-20020a170906361b00b0094e1026bc66sm2168244ejb.140.2023.04.21.07.37.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Apr 2023 07:37:27 -0700 (PDT)
From:   arinc9.unal@gmail.com
X-Google-Original-From: arinc.unal@arinc9.com
To:     Sean Wang <sean.wang@mediatek.com>,
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
        Richard van Schagen <richard@routerhints.com>,
        Richard van Schagen <vschagen@cs.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [RFC PATCH net-next 15/22] net: dsa: mt7530: set TRGMII RD TAP if trgmii is being used
Date:   Fri, 21 Apr 2023 17:36:41 +0300
Message-Id: <20230421143648.87889-16-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230421143648.87889-1-arinc.unal@arinc9.com>
References: <20230421143648.87889-1-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
index 610828b56eac..029d3129bb8b 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -404,7 +404,7 @@ static void
 mt7530_setup_port6(struct dsa_switch *ds, phy_interface_t interface)
 {
 	struct mt7530_priv *priv = ds->priv;
-	u32 ncpo1, ssc_delta, xtal, val;
+	u32 ncpo1, ssc_delta, i, xtal, val;
 
 	val = mt7530_read(priv, MT7530_MHWTRAP);
 	val &= ~MHWTRAP_P6_DIS;
@@ -457,6 +457,11 @@ mt7530_setup_port6(struct dsa_switch *ds, phy_interface_t interface)
 
 		/* Enable the MT7530 TRGMII clocks */
 		core_set(priv, CORE_TRGMII_GSW_CLK_CG, REG_TRGMIICK_EN);
+
+		/* Set the Read Data TAP value of the MT7530 TRGMII */
+		for (i = 0; i < NUM_TRGMII_CTRL; i++)
+			mt7530_rmw(priv, MT7530_TRGMII_RD(i),
+				   RD_TAP_MASK, RD_TAP(16));
 	}
 }
 
@@ -2214,10 +2219,6 @@ mt7530_setup(struct dsa_switch *ds)
 		mt7530_write(priv, MT7530_TRGMII_TD_ODT(i),
 			     TD_DM_DRVP(8) | TD_DM_DRVN(8));
 
-	for (i = 0; i < NUM_TRGMII_CTRL; i++)
-		mt7530_rmw(priv, MT7530_TRGMII_RD(i),
-			   RD_TAP_MASK, RD_TAP(16));
-
 	/* Enable PHY access and operate in manual mode */
 	val = mt7530_read(priv, MT7530_MHWTRAP);
 	val &= ~MHWTRAP_PHY_ACCESS;
-- 
2.37.2

