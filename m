Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BCDF6DAE44
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 15:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233135AbjDGNtM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 09:49:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232428AbjDGNsY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 09:48:24 -0400
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3618BBB9B;
        Fri,  7 Apr 2023 06:46:52 -0700 (PDT)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-545cb3c9898so721662067b3.7;
        Fri, 07 Apr 2023 06:46:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680875209;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TL1ifXOj3OEH5mV418CX1uP5QyBqfV3oBYYgm4r26w8=;
        b=brzH4Zr9wcAE9Er/wEsGJxmQUi4okUwFqcrv69/yi+p5271tRXAgDqXIOYN3hBegy7
         om4LYIN9tDQtVsMg7NQJwMWzM4Q0mq0wI8SAKMquObkBkrAD2vN0q9gRRq5ep+maZMVo
         elyVb58YyuFogMN36xNWcYYmozvuQPb/rP17rC2/LEP36rV5o2qMpIVmZFIpAjQ401W1
         4nNCCRoq1GFizygBm6eWTb9OP3ohPhLrOTeH0OfFvama9xTFc3wo4MzelUwgPaR+Or3z
         cGPqxvWHPOR9D2snqAoTDTxkb+YoNtk7KC5uFVvRNKZiKKb6FnJzWAbuiQo6dyDfvayR
         TFZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680875209;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TL1ifXOj3OEH5mV418CX1uP5QyBqfV3oBYYgm4r26w8=;
        b=l+yng7Qyjqhi5drY9tYeshQvLOID77JKI03ewId8o5R2vVO2Y40kBAjK0UbpafGSjV
         A83LOEh7kk/0oJ+O2kUbYRFcEZh3DG3Vry3u4/D1rmxD1n0+agTw3fwTIY9czpe0BkoB
         +IkcB0OQl79crvnTnXzHYcvtsGvKf72BniAffbrRBD1/rgiwsL41Tjp59b7vOlyreysC
         u/Q8aRJSTsPwuQBIp+0xYTBhXcr+yeFdI/M2wdQTVUN6FQyb63x+A6QakffkvmuSLReI
         64QAvCQug+ho4lwiwxnW1KyinETnm3SbBRPHle0/O+gExd11w9NYLN4tvJbHfMr9m02Y
         Pfpw==
X-Gm-Message-State: AAQBX9fKLBuwvfqih8kiSJ1QNgoDY/j64i11BJ8DMzOlb3KdNR7QZ+ao
        QBVdT+F4Dj16rZDeUyf+iyY=
X-Google-Smtp-Source: AKy350Z/AUqNXhcPJmR8umz9jFQUHbV+jS24GKZcYfRxzzfAUr+lQ2e2xeJcqDG5YNrWF7wFVuuMOg==
X-Received: by 2002:a81:6804:0:b0:543:8177:5c6b with SMTP id d4-20020a816804000000b0054381775c6bmr1867560ywc.29.1680875209028;
        Fri, 07 Apr 2023 06:46:49 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id 139-20020a810e91000000b00545a0818473sm1034317ywo.3.2023.04.07.06.46.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Apr 2023 06:46:48 -0700 (PDT)
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
Subject: [RFC PATCH v2 net-next 03/14] net: dsa: mt7530: do not run mt7530_setup_port5() if port 5 is disabled
Date:   Fri,  7 Apr 2023 16:46:15 +0300
Message-Id: <20230407134626.47928-4-arinc.unal@arinc9.com>
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

There's no need to run all the code on mt7530_setup_port5() if port 5 is
disabled. The only case for calling mt7530_setup_port5() from
mt7530_setup() is when PHY muxing is enabled. That is because port 5 is not
defined as a port on the devicetree, therefore, it cannot be controlled by
phylink.

Because of this, run mt7530_setup_port5() if priv->p5_intf_sel is
P5_INTF_SEL_PHY_P0 or P5_INTF_SEL_PHY_P4. Remove the P5_DISABLED case from
mt7530_setup_port5().

Stop initialising the interface variable as the remaining cases will always
call mt7530_setup_port5() with it initialised.

Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/mt7530.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index a00aabe4987e..9ab2e128b564 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -943,9 +943,6 @@ static void mt7530_setup_port5(struct dsa_switch *ds, phy_interface_t interface)
 		/* MT7530_P5_MODE_GMAC: P5 -> External phy or 2nd GMAC */
 		val &= ~MHWTRAP_P5_DIS;
 		break;
-	case P5_DISABLED:
-		interface = PHY_INTERFACE_MODE_NA;
-		break;
 	default:
 		dev_err(ds->dev, "Unsupported p5_intf_sel %d\n",
 			priv->p5_intf_sel);
@@ -2299,7 +2296,6 @@ mt7530_setup(struct dsa_switch *ds)
 		 * if PHY muxing is detected.
 		 */
 		priv->p5_intf_sel = P5_DISABLED;
-		interface = PHY_INTERFACE_MODE_NA;
 
 		for_each_child_of_node(dn, mac_np) {
 			if (!of_device_is_compatible(mac_np,
@@ -2332,7 +2328,9 @@ mt7530_setup(struct dsa_switch *ds)
 			break;
 		}
 
-		mt7530_setup_port5(ds, interface);
+		if (priv->p5_intf_sel == P5_INTF_SEL_PHY_P0 ||
+		    priv->p5_intf_sel == P5_INTF_SEL_PHY_P4)
+			mt7530_setup_port5(ds, interface);
 	}
 
 #ifdef CONFIG_GPIOLIB
-- 
2.37.2

