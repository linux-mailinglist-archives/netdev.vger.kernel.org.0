Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78FD46C94FD
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 16:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232214AbjCZOJa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 10:09:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232224AbjCZOJM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 10:09:12 -0400
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 937164C37;
        Sun, 26 Mar 2023 07:08:51 -0700 (PDT)
Received: by mail-qv1-xf35.google.com with SMTP id 31so5166336qvc.1;
        Sun, 26 Mar 2023 07:08:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679839730;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FE6q6p+dFTrGAKyKj7RnvQhsdIZfEftFuQ5+sKNAZxc=;
        b=D76MU+xeNJzZVMvqN9aEJ1ImGKcrDzJVZlZFme9Q3QdJoQ9B/u7bQc2xY9xU4pKoT1
         tb7z1KGlHTGabEi5HyvKL8Br8kcZSf+lUmoyZg6wST2TKSwEC4kmk+/L5CtVekjC1imm
         IUtcob0hiVfbBhjPkFtS9NHg0mlLRyfeyJ6tWab6Qw9U0nDQZSsLQMtu3ABd3+Rc1iZ0
         x0p9R9twv0stKHFHlOuGHkolzkdxQFW+G8azSKEMkD9srJqFvgj6Xzna9Z1zVzPNyoZX
         W5gb5hvef0MtcoE9/8m8O3/ZWF1CixamuO1WSS3fFlmnTzC9N9kzCatkBY66YwFUy+Hu
         O3Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679839730;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FE6q6p+dFTrGAKyKj7RnvQhsdIZfEftFuQ5+sKNAZxc=;
        b=kGXrbBND1YR9GUVdFf8oWwd7J9WYxWCVzVAGyLR5G39OK3Mh6ZZHFYYH1/eDx4NX9r
         qAytsuzsjyduW3GwB+9CG0Lkj3Tydt5ftxzewNeMeP4gb2p2i+ZYxsA0JmwdIj/Agy26
         qau6kjjHm/ZyMk82n+++e06xWGuYC4oOjIWzXTxGuknLrWUluqw7uO2Ozodi0J4H9SJj
         yTpXsptuhVXey0cTXgFbuA2rLRuaz8Gb32y2PzddddYQE8i6FJdNaIt+wJs/0psqCIhl
         /qxP8KLtpjLRfvPtMklVYhxL1MFrEjodNkviq5QzlF2NoAEtwD5JBRRWjzTPf4ZpZlwf
         pekw==
X-Gm-Message-State: AAQBX9fcp9IoE+ILj7e47LngWvbg+4gkwg2iXYLMSCppC9LqalmhHHOb
        CgMQ9wHkO6p5N1buJAAhq4o=
X-Google-Smtp-Source: AKy350ZXYJBESOoxkQUOuwbRFbnXJKrJen8y5qornJklJSyCE/pS7djMghLwkglOYXW7p2HrKG/5HQ==
X-Received: by 2002:a05:6214:29e4:b0:5a9:ed32:1765 with SMTP id jv4-20020a05621429e400b005a9ed321765mr14734612qvb.23.1679839730704;
        Sun, 26 Mar 2023 07:08:50 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id j5-20020a0ce6a5000000b005dd8b93458esm2212220qvn.38.2023.03.26.07.08.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Mar 2023 07:08:50 -0700 (PDT)
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
        <angelogioacchino.delregno@collabora.com>,
        Russell King <linux@armlinux.org.uk>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
Cc:     =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Landen Chao <landen.chao@mediatek.com>,
        Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        Richard van Schagen <richard@routerhints.com>,
        Richard van Schagen <vschagen@cs.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH net 5/7] net: dsa: mt7530: set up port 5 before CPU ports are enabled
Date:   Sun, 26 Mar 2023 17:08:16 +0300
Message-Id: <20230326140818.246575-6-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230326140818.246575-1-arinc.unal@arinc9.com>
References: <20230326140818.246575-1-arinc.unal@arinc9.com>
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

Set priv->p5_intf_sel before the CPU ports are enabled.

This makes sure the 'if (priv->p5_intf_sel != P5_DISABLED)' check on
mt753x_phylink_mac_config() runs with priv->p5_intf_sel initialised.

Set up port 5 for phy muxing right after priv->p5_interface is set to
PHY_INTERFACE_MODE_NA.

Fixes: 38f790a80560 ("net: dsa: mt7530: Add support for port 5")
Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/mt7530.c | 76 ++++++++++++++++++++--------------------
 1 file changed, 38 insertions(+), 38 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 3deebdcfeedf..2397d63cec29 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2209,44 +2209,6 @@ mt7530_setup(struct dsa_switch *ds)
 	priv->p5_interface = PHY_INTERFACE_MODE_NA;
 	priv->p6_interface = PHY_INTERFACE_MODE_NA;
 
-	/* Enable port 6 */
-	val = mt7530_read(priv, MT7530_MHWTRAP);
-	val &= ~MHWTRAP_P6_DIS & ~MHWTRAP_PHY_ACCESS;
-	val |= MHWTRAP_MANUAL;
-	mt7530_write(priv, MT7530_MHWTRAP, val);
-
-	/* Enable and reset MIB counters */
-	mt7530_mib_reset(ds);
-
-	for (i = 0; i < MT7530_NUM_PORTS; i++) {
-		/* Disable forwarding by default on all ports */
-		mt7530_rmw(priv, MT7530_PCR_P(i), PCR_MATRIX_MASK,
-			   PCR_MATRIX_CLR);
-
-		/* Disable learning by default on all ports */
-		mt7530_set(priv, MT7530_PSC_P(i), SA_DIS);
-
-		if (dsa_is_cpu_port(ds, i)) {
-			ret = mt753x_cpu_port_enable(ds, i);
-			if (ret)
-				return ret;
-		} else {
-			mt7530_port_disable(ds, i);
-
-			/* Set default PVID to 0 on all user ports */
-			mt7530_rmw(priv, MT7530_PPBV1_P(i), G0_PORT_VID_MASK,
-				   G0_PORT_VID_DEF);
-		}
-		/* Enable consistent egress tag */
-		mt7530_rmw(priv, MT7530_PVC_P(i), PVC_EG_TAG_MASK,
-			   PVC_EG_TAG(MT7530_VLAN_EG_CONSISTENT));
-	}
-
-	/* Setup VLAN ID 0 for VLAN-unaware bridges */
-	ret = mt7530_setup_vlan0(priv);
-	if (ret)
-		return ret;
-
 	/* Setup port 5 */
 	if (!dsa_is_unused_port(ds, 5)) {
 		/* Set the interface selection of port 5 to GMAC5 when it's used
@@ -2294,6 +2256,44 @@ mt7530_setup(struct dsa_switch *ds)
 			mt7530_setup_port5(ds, interface);
 	}
 
+	/* Enable port 6 */
+	val = mt7530_read(priv, MT7530_MHWTRAP);
+	val &= ~MHWTRAP_P6_DIS & ~MHWTRAP_PHY_ACCESS;
+	val |= MHWTRAP_MANUAL;
+	mt7530_write(priv, MT7530_MHWTRAP, val);
+
+	/* Enable and reset MIB counters */
+	mt7530_mib_reset(ds);
+
+	for (i = 0; i < MT7530_NUM_PORTS; i++) {
+		/* Disable forwarding by default on all ports */
+		mt7530_rmw(priv, MT7530_PCR_P(i), PCR_MATRIX_MASK,
+			   PCR_MATRIX_CLR);
+
+		/* Disable learning by default on all ports */
+		mt7530_set(priv, MT7530_PSC_P(i), SA_DIS);
+
+		if (dsa_is_cpu_port(ds, i)) {
+			ret = mt753x_cpu_port_enable(ds, i);
+			if (ret)
+				return ret;
+		} else {
+			mt7530_port_disable(ds, i);
+
+			/* Set default PVID to 0 on all user ports */
+			mt7530_rmw(priv, MT7530_PPBV1_P(i), G0_PORT_VID_MASK,
+				   G0_PORT_VID_DEF);
+		}
+		/* Enable consistent egress tag */
+		mt7530_rmw(priv, MT7530_PVC_P(i), PVC_EG_TAG_MASK,
+			   PVC_EG_TAG(MT7530_VLAN_EG_CONSISTENT));
+	}
+
+	/* Setup VLAN ID 0 for VLAN-unaware bridges */
+	ret = mt7530_setup_vlan0(priv);
+	if (ret)
+		return ret;
+
 #ifdef CONFIG_GPIOLIB
 	if (of_property_read_bool(priv->dev->of_node, "gpio-controller")) {
 		ret = mt7530_setup_gpio(priv);
-- 
2.37.2

