Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6CE96EDE2C
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 10:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233832AbjDYIc5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 04:32:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233593AbjDYIbp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 04:31:45 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 301815FF0;
        Tue, 25 Apr 2023 01:30:46 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id a640c23a62f3a-94a34a0b9e2so785275866b.1;
        Tue, 25 Apr 2023 01:30:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682411435; x=1685003435;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JLm5jhMS6rFgBzI8z+1W06D+EQwsGdSNOt8/QtnXpBI=;
        b=Ap33L6THf74ai+r6w//IbTznSDtVocBHM7PTMhbUVfihCpZZoQIMHkxxJxGeEJcFC/
         m7DTVjUb7UVORIdFwiVaP2fX40jbGS+gPtiHiGOl/PJYrToSEyBp8AYAo8enkovg4GFT
         4UNqxOpTWde9ytaO7rCQgHe2y9ifeACQWjT3Bwk2AXYZkf0BHGACL98CiV57oeUR7jr0
         uJQO69lTIf9GkCBwWdtWCNNfVIZQkCQw8pFL2zFYnURSiNEGHW21iFFJlv2xR46grMhS
         YRwwT2rwFyD2euHDZhxdEyl3AQfWZIo0WFToBHaa1RGWxwnjIfqla7zrbTT0UglGusru
         GM8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682411435; x=1685003435;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JLm5jhMS6rFgBzI8z+1W06D+EQwsGdSNOt8/QtnXpBI=;
        b=jmm5LV/nD6x5ZwHeM1QNWB3doP7cJx+48I2AYGvas8LEE81Izle+eH+hNj9lbgqU9L
         B+uM/T5TTKZ9gSEgShTkx4J+OFloED/iCtTeRFXgjLP1dFa5aXm8ZuVP2RAxwrGPuM5v
         yw7JBTIlNjqlgqOFuEuEkTC8iyicyPQqGzMceDtuESK/IDdMQ24LOyIslxKo0UaPHsl8
         8aNnjrgy4KImGIc8hmav1/ueetWsh65oFoJCcctUWq/2i6qEZfll7n8McsxT9UfE51Ie
         SgSwvNgz+GtoYdqxNFNiba8PZq3hfIR4XP4LDIZ4OnOerT5/DK257jD2PNL0VVRjkM6o
         SfaA==
X-Gm-Message-State: AAQBX9dw8OH9Ug6r9gslRyJwO6ALEUhK1uWGp/+6XKVc59duvbY2Utkb
        IdRuMJzJnUIqMlbhlVVX7oQ=
X-Google-Smtp-Source: AKy350ZHnHWTezegV98s6VGWqeQ9P96T/8gc+hf2umUdZqmtltCd4D7zYoSKx0DLOxIbyURM78gaRQ==
X-Received: by 2002:a17:906:170e:b0:947:c221:eb38 with SMTP id c14-20020a170906170e00b00947c221eb38mr12120196eje.13.1682411434710;
        Tue, 25 Apr 2023 01:30:34 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id mc2-20020a170906eb4200b0094ca077c985sm6439028ejb.213.2023.04.25.01.30.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 01:30:34 -0700 (PDT)
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
        Bartel Eerdekens <bartel.eerdekens@constell8.be>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH net-next 17/24] net: dsa: mt7530: move lowering port 5 RGMII driving to mt7530_setup()
Date:   Tue, 25 Apr 2023 11:29:26 +0300
Message-Id: <20230425082933.84654-18-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230425082933.84654-1-arinc.unal@arinc9.com>
References: <20230425082933.84654-1-arinc.unal@arinc9.com>
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

Move lowering Tx driving of rgmii on port 5 to right before lowering of Tx
driving of trgmii on port 6 on mt7530_setup().

This way, the switch should consume less power regardless of port 5 being
used.

Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/mt7530.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 0108af681d50..468c50b3f43b 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -938,10 +938,6 @@ static void mt7530_setup_port5(struct dsa_switch *ds, phy_interface_t interface)
 		/* P5 RGMII TX Clock Control: delay x */
 		mt7530_write(priv, MT7530_P5RGMIITXCR,
 			     CSR_RGMII_TXC_CFG(0x10 + tx_delay));
-
-		/* reduce P5 RGMII Tx driving, 8mA */
-		mt7530_write(priv, MT7530_IO_DRV_CR,
-			     P5_IO_CLK_DRV(1) | P5_IO_DATA_DRV(1));
 	}
 
 	mt7530_write(priv, MT7530_MHWTRAP, val);
@@ -2214,6 +2210,10 @@ mt7530_setup(struct dsa_switch *ds)
 
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

