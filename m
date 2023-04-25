Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 915DC6EDE13
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 10:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233710AbjDYIbS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 04:31:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233714AbjDYIaw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 04:30:52 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06561D30D;
        Tue, 25 Apr 2023 01:30:11 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id a640c23a62f3a-94f6c285d22so1007838566b.2;
        Tue, 25 Apr 2023 01:30:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682411409; x=1685003409;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Me/5070ACKIQU4J+v2mhTC588oNjGg5pGKAJrtCPvhY=;
        b=cS6Oz6YVZPKIdLSoVVLMCRnoc3D9cg0nE5K2dSxoqeBYwOLJI8Myz0/aCi5MQ09y/8
         Bb9RBY+A67uEvB0HET36vE6K/F5516P1DFSUfZAfa7vIB7700QZkjazhffGKQSuPQxM6
         78r5Hy0OziBGPmgLs8Xg2mQjI9t/iNu/TIRTctJu4pWqAzHOxJvzzW/x8BuiBPejmr8b
         cI1PKZWSDNNzk7Pq4A5X5lkWiP4UGeXABIzLOh/lP4Cobxr9VO+ntWO7ghvoOBYV8WkL
         U5DaUD2qaf2wDZs53Sg3IEB7NXya1tX5hyKc5TUzzc/e0/MijhrXxOw3c47Z3VFRUo41
         Eu9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682411409; x=1685003409;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Me/5070ACKIQU4J+v2mhTC588oNjGg5pGKAJrtCPvhY=;
        b=Z3X9iQcSL7rLBpUGNjXLiKec/tkScRTl+MWWBe9KVnQ4FHF6rWhFVYlGlqhox0apt0
         cxyU3QrkbgkZn8uNCcQ0bO8efuCCOjJbR4xh3aZwYnzvPyMsyjNas4U1lsYQPQ5hRpWk
         Oqljn4CdEZ5XTxmWVpeLMjSWdNmHxBlJmj/kmfyKDEFsPPXzl/noYg8j/9//v6FQu+Cj
         7iFhEt3JN5CbHEVpe2fsOYhO7R/eOfFjrEWx1xABklRO4Hf1hwnUvYsTxUvExVcytpWY
         70o7uHqifpecE77S5XhZp+1RxVoTecTFmwnKzkEv6smORkX3e/GFQwskYF+eh9AGnTF5
         F7VA==
X-Gm-Message-State: AAQBX9fwpLJAo5ronQu9RnUOxEXxzSeDNvhWiL7//mmFMSyuCTb47lI6
        TfKf6FnUkjMmn/dCKnnUvq0=
X-Google-Smtp-Source: AKy350ZxsjzJSESr4bMyY+44vc6B2jumt24xvk4np9MIyL9T8ndSUBp+t6EzrMaq/uws1qhkGbLA1Q==
X-Received: by 2002:a17:906:ecac:b0:94f:6218:191d with SMTP id qh12-20020a170906ecac00b0094f6218191dmr12652278ejb.32.1682411408919;
        Tue, 25 Apr 2023 01:30:08 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id mc2-20020a170906eb4200b0094ca077c985sm6439028ejb.213.2023.04.25.01.30.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 01:30:08 -0700 (PDT)
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
Subject: [PATCH net-next 07/24] net: dsa: mt7530: improve code path for setting up port 5
Date:   Tue, 25 Apr 2023 11:29:16 +0300
Message-Id: <20230425082933.84654-8-arinc.unal@arinc9.com>
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

There're two code paths for setting up port 5:

mt7530_setup()
-> mt7530_setup_port5()

mt753x_phylink_mac_config()
-> mt753x_mac_config()
   -> mt7530_mac_config()
      -> mt7530_setup_port5()

Currently mt7530_setup_port5() from mt7530_setup() always runs. If port 5
is used as a CPU, DSA, or user port, mt7530_setup_port5() from
mt753x_phylink_mac_config() won't run. That is because priv->p5_interface
set on mt7530_setup_port5() will match state->interface on
mt753x_phylink_mac_config() which will stop running mt7530_setup_port5()
again.

mt7530_setup_port5() from mt753x_phylink_mac_config() won't run when port 5
is disabled or used for PHY muxing as port 5 won't be defined on the
devicetree.

Therefore, mt7530_setup_port5() will never run from
mt753x_phylink_mac_config().

Address this by not running mt7530_setup_port5() from mt7530_setup() if
port 5 is used as a CPU, DSA, or user port. For the cases of PHY muxing or
the port being disabled, call mt7530_setup_port5() from mt7530_setup().

Do not set priv->p5_interface on mt7530_setup_port5(). There won't be a
case where mt753x_phylink_mac_config() runs after mt7530_setup_port5()
anymore.

Do not set priv->p5_intf_sel to P5_DISABLED. It is already set to that when
"priv" is allocated.

Move setting the interface to a more specific location. It's supposed to be
overwritten if PHY muxing is detected.

Improve the comment which explain the process.

Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/mt7530.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 98ef5ba0b19b..f3d238a46543 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -968,8 +968,6 @@ static void mt7530_setup_port5(struct dsa_switch *ds, phy_interface_t interface)
 	dev_dbg(ds->dev, "Setup P5, HWTRAP=0x%x, intf_sel=%s, phy-mode=%s\n",
 		val, p5_intf_modes(priv->p5_intf_sel), phy_modes(interface));
 
-	priv->p5_interface = interface;
-
 unlock_exit:
 	mutex_unlock(&priv->reg_mutex);
 }
@@ -2277,16 +2275,15 @@ mt7530_setup(struct dsa_switch *ds)
 		return ret;
 
 	/* Setup port 5 */
-	priv->p5_intf_sel = P5_DISABLED;
-	interface = PHY_INTERFACE_MODE_NA;
-
 	if (!dsa_is_unused_port(ds, 5)) {
 		priv->p5_intf_sel = P5_INTF_SEL_GMAC5;
-		ret = of_get_phy_mode(dsa_to_port(ds, 5)->dn, &interface);
-		if (ret && ret != -ENODEV)
-			return ret;
 	} else {
-		/* Scan the ethernet nodes. look for GMAC1, lookup used phy */
+		/* Scan the ethernet nodes. Look for GMAC1, lookup the used PHY.
+		 * Set priv->p5_intf_sel to the appropriate value if PHY muxing
+		 * is detected.
+		 */
+		interface = PHY_INTERFACE_MODE_NA;
+
 		for_each_child_of_node(dn, mac_np) {
 			if (!of_device_is_compatible(mac_np,
 						     "mediatek,eth-mac"))
@@ -2317,6 +2314,8 @@ mt7530_setup(struct dsa_switch *ds)
 			of_node_put(phy_node);
 			break;
 		}
+
+		mt7530_setup_port5(ds, interface);
 	}
 
 #ifdef CONFIG_GPIOLIB
@@ -2327,8 +2326,6 @@ mt7530_setup(struct dsa_switch *ds)
 	}
 #endif /* CONFIG_GPIOLIB */
 
-	mt7530_setup_port5(ds, interface);
-
 	/* Flush the FDB table */
 	ret = mt7530_fdb_cmd(priv, MT7530_FDB_FLUSH, NULL);
 	if (ret < 0)
-- 
2.37.2

