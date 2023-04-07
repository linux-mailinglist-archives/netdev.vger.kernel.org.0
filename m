Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1290F6DAE4C
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 15:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231425AbjDGNuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 09:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232147AbjDGNtj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 09:49:39 -0400
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2CC2BDD5;
        Fri,  7 Apr 2023 06:47:30 -0700 (PDT)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-54c0c86a436so96819527b3.6;
        Fri, 07 Apr 2023 06:47:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680875245;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a9BgVJEEYWS/nr7ufBquG0YTtl1dQzZWs/MVrntK8ZE=;
        b=Khq4lakPSKINAMHrDaCTMh8EeQ+V+eHwOuug8yWNtkFKqjdjWDbc2pmsVEAOLl7pOc
         Te7lJVbwGJgFDVT6Lu64E6hyKdmFqkkoYcwYpvrEbJcHtAKQucEM25hZHoue6SLvCcqw
         cmrYd7oFzoUgqC0H88H/Yo3V02LzLMyGZdWRDMa0x5JYnWsVo0WHmvDKlDRpgWcoGHLY
         Ka5pXwpf07gcpmTxO9aLrA7i9B+DeXGhTeAfPR8FbvK1Fsu++qdDBZv5HZOnWSI35f/f
         knmtij05XRWMbmq79iZtqawWhNKqPd+/NuWJFslMmCOsAjFccLgXjjK8CgKxjOEzclML
         QCyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680875245;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a9BgVJEEYWS/nr7ufBquG0YTtl1dQzZWs/MVrntK8ZE=;
        b=ENQBbr7ZYsGPXtQk/WuxoePfgKmZXP5RpLBJ9MnfYeU0zXB/J++xMPU9lnz6kkBz8w
         f9TPTAUXLTgBEHuFW+U1T2LlWy2chx/mkmq4kFaw6EVyCUMN/0n+MzbNjEgiOaxiHkDw
         99lFdulOw6KKtL+9w+J32Yx8y1qnIPAQfMpihyONgjAgJKTcwyB0Ce66HM5PkIdu5HZU
         J2WLZ2kgWpdV3aMm7WuXWHOoLGM6lyWtdH/ruwHt9BojVU/LmS64eLJVenLH+5MQzlCk
         ewlgtMpInIFaL/lYWk/HEz2C4+LP91biGGdAKH3xQAY7j3PV7yHeDWtAQLqqspIbizQI
         XE3g==
X-Gm-Message-State: AAQBX9cMts5WR3mHvuYQyEXFTM5ZE69Nt0jqLJesn9pgrURA0Cjmj3TQ
        NOiN66pnbywBp9rJtb3Wtk4=
X-Google-Smtp-Source: AKy350ZGVEQhtTR6cQW7sfrh8ngPWG6L2Xbz7SIX9tT6TZ3YLGIyhfygmDD3zdBILQB8L9E9zHbl+Q==
X-Received: by 2002:a81:6d4e:0:b0:54b:fc07:c7c8 with SMTP id i75-20020a816d4e000000b0054bfc07c7c8mr2094391ywc.0.1680875245241;
        Fri, 07 Apr 2023 06:47:25 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id 139-20020a810e91000000b00545a0818473sm1034317ywo.3.2023.04.07.06.47.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Apr 2023 06:47:25 -0700 (PDT)
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
Subject: [RFC PATCH v2 net-next 11/14] net: dsa: mt7530: set TRGMII RD TAP if trgmii is being used
Date:   Fri,  7 Apr 2023 16:46:23 +0300
Message-Id: <20230407134626.47928-12-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230407134626.47928-1-arinc.unal@arinc9.com>
References: <20230407134626.47928-1-arinc.unal@arinc9.com>
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

