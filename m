Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD1DD6D88BF
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 22:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233157AbjDEUjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 16:39:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232640AbjDEUjP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 16:39:15 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAF37768E;
        Wed,  5 Apr 2023 13:39:12 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id n9-20020a05600c4f8900b003f05f617f3cso3566206wmq.2;
        Wed, 05 Apr 2023 13:39:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680727151;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TL1ifXOj3OEH5mV418CX1uP5QyBqfV3oBYYgm4r26w8=;
        b=otBFkFBIeXE2wHUW2NbAADjRIHF+Q3/1CyWyDB0KCBi/bP20rCssC6krJAdujcBH0p
         vOr+fv+PvHyG2Lh3nHOO205ZyWI4KHjzqT7qsF3NzKvNhRR/N13+PZi6I92fRLV+HIkk
         NOQtYCDb/jQLRvUEn0+kwXuvwtc5KrH8csK6rRMtSiLHNVb4oFDd/W4dfwZz6ySfih6L
         69xhweJmDTMYUUbhYyNiVONmz1b65R5rqaglAir2dBEdPXGc8HaACVDW8lbeidNEyFVt
         wpNX6ng2AIENabtgAzErMui85//Jr2AgfW1+iBZKRLjyqrByjXAijgkmXD+v1/qnf3z0
         V/ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680727151;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TL1ifXOj3OEH5mV418CX1uP5QyBqfV3oBYYgm4r26w8=;
        b=qZwif7RQl8EeXpasrThLq/2Ky5pVf5v9u8gxKNPMQH7JXfkt950Wr1QxbSqQRKh7e7
         LDkT6I/TtiPg2DenP0XwITS5JZBIad6S1podt8namHajoeFL1JpMU7/Y8Wsbax7qXVDL
         hr5ZLaGV0osf+dveOnok9l4Rrb/2dZlrRdWdr9K7WMu8rXnK3rV1vUmhTJXiobqzDW3d
         52s8/tyXwwMYkVuyU58gluODIynBcCPInICnnFel1G9POzn++xsePa37ateOLUQ7ffVa
         fx90zjsk4oRyMpv56SgTN/XYCSrt/7SnvIXhp1qX/i5FLbfVSYBc+aCj1oiQY8i13Jat
         QUIw==
X-Gm-Message-State: AAQBX9eh0NVJzhme7TuAJXWmCo5zNkjLiQMMJukGJjJBcqp5tZZjV1gV
        8OdVXK3Gvv2g9FHK7GzglQI=
X-Google-Smtp-Source: AKy350apw98pqyG0m2kriMDO9nl7uy8+ve6V4vFItG3nJ/BQRJUCnIASNlPnFi/uFduCYKWZ/rXdtA==
X-Received: by 2002:a05:600c:198e:b0:3ed:ad05:5841 with SMTP id t14-20020a05600c198e00b003edad055841mr2488273wmq.17.1680727150993;
        Wed, 05 Apr 2023 13:39:10 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id p19-20020a05600c469300b003eda46d6792sm3259867wmo.32.2023.04.05.13.39.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 13:39:10 -0700 (PDT)
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
Subject: [RFC PATCH net-next 03/12] net: dsa: mt7530: do not run mt7530_setup_port5() if port 5 is disabled
Date:   Wed,  5 Apr 2023 23:38:50 +0300
Message-Id: <20230405203859.391267-4-arinc.unal@arinc9.com>
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

