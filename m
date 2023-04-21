Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 408CE6EAD34
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 16:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232956AbjDUOie (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 10:38:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232781AbjDUOhd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 10:37:33 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BDE814452;
        Fri, 21 Apr 2023 07:37:23 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id 4fb4d7f45d1cf-5050491cb04so2574391a12.0;
        Fri, 21 Apr 2023 07:37:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682087841; x=1684679841;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p+dofZHOOW69JOLHI22sQ8OPoJMkGCG8x3AI17TiDqs=;
        b=fXw97UmiJ/MMCmvWZV6wGK4K+sByF72DQK538kfvhJ4Fdvmy6QXu1cPLN5YefNNSpG
         88YqFD0qkMpghVdRxjdcZBdim6DnGfZcA11nK+dOOgT6WEGv5nIVggWUPf8zEcpgN/Ev
         8AsRipc0PafM+bi/fm+Z/u42rj9tVNlVP5BxtJm6s4YBoRRfAyJPkfr9VVaEI4Yq1+ys
         nggpgDmcN3TgCFV1cajMPxaZ48lT5XE9aF8SBpfwotQhWJzWMF6yQv9qgaIi8FtuX92X
         DiBtjDD6jxEL8Ckn7/M2VdwAGahE8ujMxvb6+KUbb4zuuskoHRdanMBD4bCt6wsXIV75
         wVnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682087841; x=1684679841;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p+dofZHOOW69JOLHI22sQ8OPoJMkGCG8x3AI17TiDqs=;
        b=bz+xzV9hkqz6b/ZvKzH3xPplCZpiBGDA5KbAJ95RPzl0ufvDuCf/cyW/9oqt/lruUb
         h2ER4Pv6plr4k3y705P+SayhDl/z9qwNVK6wwKUs71Z9drC2kIFZDqHOkO4yXJ3awxaQ
         w/AJUNa+j3L4qQwzFUvI5/mQoSzyOUkvwYeyaC9qngVga8H4dftyD+FJgtU+D2NYUhaP
         MqqGiNvgljX9348rn8vm4Kcj7ofGduXTYNTfwhM8t4hPwIJkMYpBrOZAhaMsiKzEc6Mo
         QzR1FFWWu1UMxCfBu4HviYym2bkPtCdKVS8lbR4xXUQ9IidFp0eCfj5F6X4OdSOWSdzL
         j7eg==
X-Gm-Message-State: AAQBX9ew0lcaPv4joZKDQk0Ef4IhVCApqCIk9YM0aAfM+T8jACJ6LZVU
        ZajGwaCsMgs7H4OaYoIu75M=
X-Google-Smtp-Source: AKy350aULjZUKC1bGLSUxBB90hqtc9kUEcTXJTE84prab1d7nVL3w+d/kkEZm0sKgE9SE4JKFv0E5w==
X-Received: by 2002:a17:906:2c58:b0:953:5eb4:fe45 with SMTP id f24-20020a1709062c5800b009535eb4fe45mr2339306ejh.23.1682087841265;
        Fri, 21 Apr 2023 07:37:21 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id q27-20020a170906361b00b0094e1026bc66sm2168244ejb.140.2023.04.21.07.37.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Apr 2023 07:37:21 -0700 (PDT)
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
Subject: [RFC PATCH net-next 12/22] net: dsa: mt7530: move XTAL check to mt7530_setup()
Date:   Fri, 21 Apr 2023 17:36:38 +0300
Message-Id: <20230421143648.87889-13-arinc.unal@arinc9.com>
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
index a1627e20675d..eaa36d41e8b9 100644
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
@@ -2136,7 +2129,7 @@ mt7530_setup(struct dsa_switch *ds)
 	struct mt7530_dummy_poll p;
 	phy_interface_t interface;
 	struct dsa_port *cpu_dp;
-	u32 id, val;
+	u32 id, val, xtal;
 	int ret, i;
 
 	/* The parent node of master netdev which holds the common system
@@ -2206,6 +2199,15 @@ mt7530_setup(struct dsa_switch *ds)
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
2.37.2

