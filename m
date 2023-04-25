Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49ED16EDE22
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 10:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233721AbjDYIc3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 04:32:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233300AbjDYIbU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 04:31:20 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D2EA13C1B;
        Tue, 25 Apr 2023 01:30:37 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-953343581a4so804615566b.3;
        Tue, 25 Apr 2023 01:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682411423; x=1685003423;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7kwxv5YjSB3QzEOGZ2oRt9roe6rXfZ17PcarFfIQGeU=;
        b=JJcsEUpwNrmrwPV1ogH+dwji5UMjyghuQyIBJSBSKEqpqR4i7KqFBnSFFdzTW4eZ8c
         2fDyt73ztwhma4blJQ9jnGdUFSxbsiHlgwYh4yOaJ3UqKqISxanFpgs4kv3J71eyedRk
         R3yOnsnU/xgFAswncrZI4IIWICrXoYhrJEqJ9wmmwmexzzPebdfdmDz4ZMqALrL4GnlC
         5DFHcrt5ZCMJZsrFfEJXpHhomuOdKW/4TWKjo+Vk49HKNjn7BVecvr62wBxMzKbQLvS1
         RUYPtMsepfQXjvqZhOssU2piw8AO51XNd3ESlMfdDAG8VOlTnIEpfryA+LXjZrj8UeNp
         fFBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682411423; x=1685003423;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7kwxv5YjSB3QzEOGZ2oRt9roe6rXfZ17PcarFfIQGeU=;
        b=QYJDHJIxjRsg4K2Mg6GASTE2iVpVqUQY7YZ6uboMW8z23wqMM9o4qUlkgS14RuRKPx
         0z4fPdEGutOya3eCYwpoxl089aYMhlDxVb5AiFAEGi9GUgMhuHywe7vfWneALor1tO4l
         XBO1D1gmN1WVOTCAmb6C/p8Ixfpx2y+X1hoYlg/c4SgUUJ4k0EF8rV1+6EOIEV6odLEo
         rQL8IE2a9iD+jeoWUCpQ8Ujcf42beaAdoEguG7kC13B4zytQpF0OqY5epCUC2XGO0DWc
         nFsUEhKVOe7SPXYFPWdpR08YfwfyrQJLk7PaEtzMuoXgomslMAfcBiWjCa3VfU2rV5EF
         TuEA==
X-Gm-Message-State: AAQBX9ehbDKdlkSL4Pg5Aq2jgvdm9ersYXhLoS0tCJnZLERDWBrB3z6c
        619S614/UkRMvu3F78dfZls=
X-Google-Smtp-Source: AKy350aguKiMQful+GW7E2lZvbMUkudRtfHsFOYT4NSuwVd/7oKVLErpt+s63adqZWg/Wg+mPTfHPA==
X-Received: by 2002:a17:906:b088:b0:94e:98da:ef97 with SMTP id x8-20020a170906b08800b0094e98daef97mr11814688ejy.27.1682411423414;
        Tue, 25 Apr 2023 01:30:23 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id mc2-20020a170906eb4200b0094ca077c985sm6439028ejb.213.2023.04.25.01.30.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 01:30:22 -0700 (PDT)
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
Subject: [PATCH net-next 13/24] net: dsa: mt7530: move XTAL check to mt7530_setup()
Date:   Tue, 25 Apr 2023 11:29:22 +0300
Message-Id: <20230425082933.84654-14-arinc.unal@arinc9.com>
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
index 2addd5e7fbe6..04a48829465c 100644
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

