Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 844C26C20FE
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 20:13:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231337AbjCTTNq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 15:13:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231246AbjCTTNZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 15:13:25 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D5E425E2D;
        Mon, 20 Mar 2023 12:05:53 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id x3so50809075edb.10;
        Mon, 20 Mar 2023 12:05:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679339131;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=garNebGGDyvyBMATQaX/1lhxEv3banNkHxmIaDOYQf4=;
        b=LzdJDtIeTF7AZbGh4JgVbxVd9p4iLmSw0oJHgTEZonaQgV3vnRzql67y6AjYpCQx9Q
         dI2WSaLvHXfGQJjJFHCHVk2Pc+i1UJXTx0YgGiL5IMVghXjsolNc0u3ssqjNZuQuGGWj
         RH7D9RdYW4syYlDgJeTwWM0Ri8DZXvYNotFuaeJGIqUsPfEgqpkoTprySd5ug0Jn2Rcl
         MYIIjAiP7AgaR9TRnjfd8MBmGew+8PpZ27D+p9NvgWlxVSmBlZF4VV0HhX1kW/diiyOd
         uN5CEpdNhEfsBGtZwoR7/CGjh2DCX/zfPLZIzM6F52Ke3X1+9t2sd5pJRDbdNB7UxBGz
         PqCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679339131;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=garNebGGDyvyBMATQaX/1lhxEv3banNkHxmIaDOYQf4=;
        b=B0XyOxcWXXVCthCY0qeZqyjKf32XqLG0MgTu46WvajqCYwMmshWeJbYAwwCBBqXz1z
         CbBjnaZQQoFo58wU3kA3XGCACYGfkUiTF0Ndh1mub2mRX6D8ujg3FB6HcQNCDegZya1p
         I/gpPgG+O9kOo3QOu0Y36CAOXaYBLcjhJRDRhtX9NzP8iMiaosFXb+J0sJUKfuSH7lS7
         7zTxOemUawCoUj5DxbANQyn87hygDj+OCjweYJuuVG1APzI/4j8Rreve74CyFfI1hb0B
         3dSPxAt2kAbTp1wcfuH4PtN1HQLRbsk+vFjzKUW6lOHXDzXW+NxeC7qvQkZg/UYlTZhw
         e5fg==
X-Gm-Message-State: AO0yUKX8xRoN9/lVPeeSJc4V9xB3Ygbi169Cl3UWb/+4k+xeGeEQqP42
        oKJ/4vhsIbrr5dm6xYbuJcQ=
X-Google-Smtp-Source: AK7set+fE9X45glHrxmqzs0a9utURfqo2TKrILqXwvMhSA4OriGwRzvmJAulLj6/G0utGQUQdFQucw==
X-Received: by 2002:a17:906:a855:b0:930:963b:63a6 with SMTP id dx21-20020a170906a85500b00930963b63a6mr87662ejb.66.1679339131404;
        Mon, 20 Mar 2023 12:05:31 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id hy22-20020a1709068a7600b008e53874f8d8sm4717848ejc.180.2023.03.20.12.05.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 12:05:31 -0700 (PDT)
From:   arinc9.unal@gmail.com
X-Google-Original-From: arinc.unal@arinc9.com
To:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
Cc:     =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH net 2/3] net: dsa: mt7530: move lowering TRGMII driving to mt7530_setup()
Date:   Mon, 20 Mar 2023 22:05:19 +0300
Message-Id: <20230320190520.124513-2-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230320190520.124513-1-arinc.unal@arinc9.com>
References: <20230320190520.124513-1-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arınç ÜNAL <arinc.unal@arinc9.com>

Move lowering the TRGMII Tx clock driving to mt7530_setup(), after setting
the core clock, as seen on the U-Boot MediaTek ethernet driver.

Move the code which looks like it lowers the TRGMII Rx clock driving to
after the TRGMII Tx clock driving is lowered. This is run after lowering
the Tx clock driving on the U-Boot MediaTek ethernet driver as well.

This way, the switch should consume less power regardless of port 6 being
used.

Update the comment explaining mt7530_pad_clk_setup().

Tested rgmii and trgmii modes of port 6 and rgmii mode of port 5 on MCM
MT7530 on MT7621AT Unielec U7621-06 and standalone MT7530 on MT7623NI
Bananapi BPI-R2.

Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")
Link: https://source.denx.de/u-boot/u-boot/-/blob/29a48bf9ccba45a5e560bb564bbe76e42629325f/drivers/net/mtk_eth.c#L682
Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---

I asked this before, MT7530 DSA driver maintainers, please explain the code
I mentioned on the second paragraph.

I intend to send a patch to remove the maintainers, Sean Wang, Landen Chao
DENG Qingfang, listed on the MAINTAINERS file and change the status to
orphan if none of them respond to this question or review the patches.

I think a full week is a reasonable amount of time to receive a response
from a maintainer.

Arınç

---
 drivers/net/dsa/mt7530.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index d4a559007973..8831bd409a40 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -419,12 +419,12 @@ static void mt7530_pll_setup(struct mt7530_priv *priv)
 	core_set(priv, CORE_TRGMII_GSW_CLK_CG, REG_GSWCK_EN);
 }
 
-/* Setup TX circuit including relevant PAD and driving */
+/* Setup port 6 interface mode and TRGMII TX circuit */
 static int
 mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
 {
 	struct mt7530_priv *priv = ds->priv;
-	u32 ncpo1, ssc_delta, trgint, i, xtal;
+	u32 ncpo1, ssc_delta, trgint, xtal;
 
 	xtal = mt7530_read(priv, MT7530_MHWTRAP) & HWTRAP_XTAL_MASK;
 
@@ -469,11 +469,6 @@ mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
 		   P6_INTF_MODE(trgint));
 
 	if (trgint) {
-		/* Lower Tx Driving for TRGMII path */
-		for (i = 0 ; i < NUM_TRGMII_CTRL ; i++)
-			mt7530_write(priv, MT7530_TRGMII_TD_ODT(i),
-				     TD_DM_DRVP(8) | TD_DM_DRVN(8));
-
 		/* Disable the MT7530 TRGMII clocks */
 		core_clear(priv, CORE_TRGMII_GSW_CLK_CG, REG_TRGMIICK_EN);
 
@@ -494,10 +489,6 @@ mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
 
 		/* Enable the MT7530 TRGMII clocks */
 		core_set(priv, CORE_TRGMII_GSW_CLK_CG, REG_TRGMIICK_EN);
-	} else {
-		for (i = 0 ; i < NUM_TRGMII_CTRL; i++)
-			mt7530_rmw(priv, MT7530_TRGMII_RD(i),
-				   RD_TAP_MASK, RD_TAP(16));
 	}
 
 	return 0;
@@ -2207,6 +2198,15 @@ mt7530_setup(struct dsa_switch *ds)
 
 	mt7530_pll_setup(priv);
 
+	/* Lower Tx driving for TRGMII path */
+	for (i = 0; i < NUM_TRGMII_CTRL; i++)
+		mt7530_write(priv, MT7530_TRGMII_TD_ODT(i),
+			     TD_DM_DRVP(8) | TD_DM_DRVN(8));
+
+	for (i = 0; i < NUM_TRGMII_CTRL; i++)
+		mt7530_rmw(priv, MT7530_TRGMII_RD(i),
+			   RD_TAP_MASK, RD_TAP(16));
+
 	/* Enable port 6 */
 	val = mt7530_read(priv, MT7530_MHWTRAP);
 	val &= ~MHWTRAP_P6_DIS & ~MHWTRAP_PHY_ACCESS;
-- 
2.37.2

