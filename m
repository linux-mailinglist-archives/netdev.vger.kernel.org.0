Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 539106D88D4
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 22:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234413AbjDEUkv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 16:40:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234377AbjDEUkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 16:40:15 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 183E765B2;
        Wed,  5 Apr 2023 13:39:32 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id l15-20020a05600c4f0f00b003ef6d684102so19156961wmq.3;
        Wed, 05 Apr 2023 13:39:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680727170;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a9BgVJEEYWS/nr7ufBquG0YTtl1dQzZWs/MVrntK8ZE=;
        b=PkCe8EUwo59MuxO0b6KKI0EmM0HxoC38GvoQCL9HKBu3Pi5g9oGx43peL0MKckQs05
         9GTz+/qxJf8/I4YzJWNBHoxaqLYtCgzAi+4f3uduLglyaLnYD8bvZYKoMHf5SSvgNBrV
         7ASNECmnIIspbW3qf7+L4jOm3cisQ42pq0C2zRANZt9PBwUTXmU4HV2ZE31zBqtBO7T0
         Rnw7v6ZpKZdutrO2fHfH9Hi2hZ5dEftWF2d+Z73dcyXWJ3QsHayuBm8tzTjHTGb+ph/E
         JzpsdA2CZPlKGb0u5yldIRaZ8s5eu93/BO+XocnBJwc3GTWOQJ/rJXA1295X0tm5hTSs
         XDtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680727170;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a9BgVJEEYWS/nr7ufBquG0YTtl1dQzZWs/MVrntK8ZE=;
        b=oINRtDsAlSuUp0EMLSBrfeSObCH5W+TDEx/tom3Qus78lCiS807/KudDhinohB1WG3
         KsUtLT0pBvs1WRK8NBv5J2WaV41FC6tgiIpD574OlhVBdxB+rN+VV3n4yKqf53Hfv7BU
         OoKVxiaoblr69i+ewVVSDufIBAvH/vNOPrmA/6klmqBe5XmYliYpUHxkhoegedYtQbp5
         Dc/3xmILoIXVkqmqfSmuo5LKzu0sFAnauMiGjtpIwFNw5z6ie4Q/1g9PvSj1n/+Dihs3
         /itZqZRYLmYALo5MMtNlzL04qZXQATISpnU0M/ymgpcXpVhD8FBSYJnsWqAxHttzxDfY
         U1BQ==
X-Gm-Message-State: AAQBX9eGJE6J6m+yA1baDDtTIRVlXAAbf9X2L+JHGyQFYNeTuXgIbc1L
        +BltphkL5Ypf+OW994W6kdI=
X-Google-Smtp-Source: AKy350ak9wGsiF9xXKquHuS6fiWGFlLoT/KizsEmKlqSw6wiiOnCOZh9KwtUQUXE/BoiyAZ5k1Hx1Q==
X-Received: by 2002:a1c:7211:0:b0:3ef:7584:9896 with SMTP id n17-20020a1c7211000000b003ef75849896mr5529893wmc.26.1680727170331;
        Wed, 05 Apr 2023 13:39:30 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id p19-20020a05600c469300b003eda46d6792sm3259867wmo.32.2023.04.05.13.39.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 13:39:29 -0700 (PDT)
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
Subject: [RFC PATCH net-next 11/12] net: dsa: mt7530: set TRGMII RD TAP if trgmii is being used
Date:   Wed,  5 Apr 2023 23:38:58 +0300
Message-Id: <20230405203859.391267-12-arinc.unal@arinc9.com>
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
index fe496d865478..384e601b2ecd 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -404,7 +404,7 @@ static int
 mt7530_setup_port6(struct dsa_switch *ds, phy_interface_t interface)
 {
 	struct mt7530_priv *priv = ds->priv;
-	u32 ncpo1, ssc_delta, xtal, val;
+	u32 ncpo1, ssc_delta, i, xtal, val;
 
 	val = mt7530_read(priv, MT7530_MHWTRAP);
 	val &= ~MHWTRAP_P6_DIS;
@@ -464,6 +464,11 @@ mt7530_setup_port6(struct dsa_switch *ds, phy_interface_t interface)
 
 		/* Enable the MT7530 TRGMII clocks */
 		core_set(priv, CORE_TRGMII_GSW_CLK_CG, REG_TRGMIICK_EN);
+
+		/* Set the Read Data TAP value of the MT7530 TRGMII */
+		for (i = 0; i < NUM_TRGMII_CTRL; i++)
+			mt7530_rmw(priv, MT7530_TRGMII_RD(i),
+				   RD_TAP_MASK, RD_TAP(16));
 	}
 
 	return 0;
@@ -2227,10 +2232,6 @@ mt7530_setup(struct dsa_switch *ds)
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

