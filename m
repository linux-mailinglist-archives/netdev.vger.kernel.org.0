Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 068086D88D5
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 22:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234141AbjDEUkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 16:40:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233939AbjDEUkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 16:40:18 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 199FA83CC;
        Wed,  5 Apr 2023 13:39:36 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id l15-20020a05600c4f0f00b003ef6d684102so19157009wmq.3;
        Wed, 05 Apr 2023 13:39:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680727172;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L71GAIfC9eueAFpPEM3jN5dqLC94Zw3zCdbNg29s88s=;
        b=MiTmmxWpXe2fE/0oNn2g7hsWoWsYD9g6VdQBcZ51eEukbBygXXyawyTPJyOfz3Z6p0
         cP26KmucIcfZDP9eWNZ9t4k0cF8AUAK7UAY9OotSb13c1HaJt06z/q3qZQG3H7y8HLaZ
         bblYlI9ka+HOwqFjA9pVrrsTSZ+mydgTe2Sx0GM9vIc7WubqO42qrjM/EisAxYuNoQxO
         ulZq8U4qvEP4vJ9RYD6CeXD/5+JVKy/ZSTvRATHaZYCwxUHyv29Jp3xr9D3szlzLZN0U
         2c+L1zloAfqFXxjfTexsA/ojqOrhJj1rcTmrVEm8yWy7/UCp4/amn+U06U3fmp2bjGYn
         fMGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680727172;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L71GAIfC9eueAFpPEM3jN5dqLC94Zw3zCdbNg29s88s=;
        b=S0ttEVWXZMLZAAjk4xPPhxxJ1EEeDkzKF/GXnZHU9n5+X1X3ayF0xwWqVAmQji7LGu
         EtE/Jmnj3rdvOoJd0rH7hfbyAiFIslR6EPPimX6E54nCKifnkIjh7p5gm7Pt6qIj6ULO
         HvOfdANXyiFv8H2To09klLxuAYRu8VoLGSxtyHYuVhR07U9Dh5nRusRcwmJj9WA1nU4n
         TCvYHxZLI5fRYlWzqr31grkz3i8gXwsUM6g+RXBxq/IGsQKPaeF4c43U5yDlYd3pr9+u
         hFWEbF0Wxw88LYkefJHSG1/zjXyL7vGKjjOK0a1R4O6q9nCgpkxXDCgMTWlxNxxV8ZOB
         Q3CA==
X-Gm-Message-State: AAQBX9c0QQtNJ8CGK2ckzSBDvCUlu2fMUOcmYekrjoN17fnsyhXZ5Uyu
        0aX83v4OGxJZIIeF3WBTKCI=
X-Google-Smtp-Source: AKy350ZfAZeQEKVf1n9tV8rwVhEY06YRX4VGzkFY8HUbcQ7WPJqd971FrD9WXiRCZ7cd2jeZ0sQzUg==
X-Received: by 2002:a05:600c:218d:b0:3eb:9822:f0 with SMTP id e13-20020a05600c218d00b003eb982200f0mr5728897wme.30.1680727172707;
        Wed, 05 Apr 2023 13:39:32 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id p19-20020a05600c469300b003eda46d6792sm3259867wmo.32.2023.04.05.13.39.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 13:39:32 -0700 (PDT)
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
Subject: [RFC PATCH net-next 12/12] net: dsa: mt7530: move lowering port 5 RGMII driving to mt7530_setup()
Date:   Wed,  5 Apr 2023 23:38:59 +0300
Message-Id: <20230405203859.391267-13-arinc.unal@arinc9.com>
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

Move lowering Tx driving of rgmii on port 5 to right before lowering of Tx
driving of trgmii on port 6 on mt7530_setup().

This way, the switch should consume less power regardless of port 5 being
used.

Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---

Emphasise on the "should".

Arınç

---
 drivers/net/dsa/mt7530.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 384e601b2ecd..6fbbdcb5987f 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -956,10 +956,6 @@ static void mt7530_setup_port5(struct dsa_switch *ds, phy_interface_t interface)
 		/* P5 RGMII TX Clock Control: delay x */
 		mt7530_write(priv, MT7530_P5RGMIITXCR,
 			     CSR_RGMII_TXC_CFG(0x10 + tx_delay));
-
-		/* reduce P5 RGMII Tx driving, 8mA */
-		mt7530_write(priv, MT7530_IO_DRV_CR,
-			     P5_IO_CLK_DRV(1) | P5_IO_DATA_DRV(1));
 	}
 
 	mt7530_write(priv, MT7530_MHWTRAP, val);
@@ -2227,6 +2223,10 @@ mt7530_setup(struct dsa_switch *ds)
 
 	mt7530_pll_setup(priv);
 
+	/* Lower P5 RGMII Tx driving, 8mA */
+	mt7530_write(priv, MT7530_IO_DRV_CR,
+			P5_IO_CLK_DRV(1) | P5_IO_DATA_DRV(1));
+
 	/* Lower Tx driving for TRGMII path */
 	for (i = 0; i < NUM_TRGMII_CTRL; i++)
 		mt7530_write(priv, MT7530_TRGMII_TD_ODT(i),
-- 
2.37.2

