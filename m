Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 061726EAD14
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 16:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232842AbjDUOhZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 10:37:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232781AbjDUOhS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 10:37:18 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1E4313F83;
        Fri, 21 Apr 2023 07:37:09 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-94ed7e49541so236551866b.1;
        Fri, 21 Apr 2023 07:37:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682087828; x=1684679828;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BEQa4/xHb6zNxlzp+nQz3Th+D0wsYwHJEzOMjCihAA0=;
        b=ZLiz7VI1LgCRTrl6vuhh0Ya1V50x4rqu6D/kmhJ4UHrdgB/mMJHYQkQYrsg+Y+kID2
         ZrAzSyHbSBnBngaySNZZz6RJyf3nkcWbaV1Hc6qyoevLGH6nN8tEBZDCBewM0ovE+yTE
         6vX5eR74L4i7Cvi3wCnjqggrtwXEPVds4Jzz64X2oJY35U+Qm9cf55rGYkPcqu8VXyhY
         7ruEraMsbDx/1qDhyyzdJgfm4QQghUoPq2PSYtLkEIrzlkHlMk0baKzlgn6bTBh6NvX2
         YXTq76Vpysm8U32kc8euQkRQS+9SWhtUrkTrjOBxEc9fkGsnKi8StkloxnLZwFM3WWPL
         ginw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682087828; x=1684679828;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BEQa4/xHb6zNxlzp+nQz3Th+D0wsYwHJEzOMjCihAA0=;
        b=jBhCEdX2+T98v7oMkjOLecUEssRBEAwxQtbEA83h1G9keHHGaiOItefkf/rViNmh0s
         6VU4Oq6UJ/EUB8KVIQ0iYzkBLIe3E6fh9W0yTCIsatXwXcdtcQEt2sRfbB30Cx0WqBSC
         OFQkC511v/O+ysGpCHlpF8a+Eg2FV6UUKOyFjP4171Us5zuPd/eojWR1O8Truniakd4n
         aZuVuspN8E4AU2HCg/XFysbqJEA9NYo22U/8VaNmqiWSiOgFPyyKykJ53ILYG3K2suFa
         k/ws36BHqRmgzGfoovk7Carp3u0bW8nK+/nO9PFTFrAMw/AKxOBUrlfWnlmWYNUbqDQR
         euEw==
X-Gm-Message-State: AAQBX9fICvK4hQkWwF5cX4U+Ugu7BQw9ZQpuExsJ2rX86M1sfexjHoGG
        uFvwAiDDizZoB2pDn2aq2aI=
X-Google-Smtp-Source: AKy350aYC8vZhVhjqQTuEMfzGSYTGJE29X38itrkcvfN2wPBmLh7N3Xsl7f7jIM8oO1qa+oppffqeA==
X-Received: by 2002:a17:907:a40e:b0:94f:a292:20cc with SMTP id sg14-20020a170907a40e00b0094fa29220ccmr2834815ejc.41.1682087828142;
        Fri, 21 Apr 2023 07:37:08 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id q27-20020a170906361b00b0094e1026bc66sm2168244ejb.140.2023.04.21.07.37.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Apr 2023 07:37:07 -0700 (PDT)
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
Subject: [RFC PATCH net-next 06/22] net: dsa: mt7530: improve code path for setting up port 5
Date:   Fri, 21 Apr 2023 17:36:32 +0300
Message-Id: <20230421143648.87889-7-arinc.unal@arinc9.com>
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
index 30553044d4b7..591df09c8bb5 100644
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

