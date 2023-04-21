Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EECD6EAD22
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 16:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232733AbjDUOha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 10:37:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232784AbjDUOhT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 10:37:19 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DC25C17C;
        Fri, 21 Apr 2023 07:37:12 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id 4fb4d7f45d1cf-506bdf29712so12860929a12.0;
        Fri, 21 Apr 2023 07:37:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682087830; x=1684679830;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VA0Xuk7MTgGa91dYwTC92d17A98m4rbax3BNrbxXgxg=;
        b=M4UWnciomcUE4HK+mDFOEhaQpLMON/yMq1egd2eGD0WjqLi+0EO8LKCpuYv/hx30WT
         nhwfgfnd8DOh+GrNePxRaULnUkLzivdzGvaE8i3r/QtreW8oXp68KJttbMRL/gv+4SqY
         q9hBwdaSa5lbn1G4FlJ0xKusB6GQET/Lw1o1BTFaSvho5tKvyql2BDBAnn0bj6QcMCDD
         HQTaxEG0hAMhP7kxEAhW8QOxumCzrHRruAk/Y2nXsU6dVu4zTFPF5e2/pk9wjnTCbdJW
         qBC0hiFpBRl3zD3KC9ZZVOA+LqLwQF3C1/0qrp2ADUL2DuRyPGWgi3d6hMS8AItrDZ7f
         thqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682087830; x=1684679830;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VA0Xuk7MTgGa91dYwTC92d17A98m4rbax3BNrbxXgxg=;
        b=HsU8wTFEE0AhWD8M/u9/7coTKEV8Fnq+Cim7cC5eQerf79rOzdjqe1cz5sUTqbEP+j
         35HFJwFpdbslai6jsuprMf2QLDuLjRe+pS1mfD3J1LF9lEuV9SVjA00rFuHY4Te8BCRV
         WewTpW7kNRL9SP4rhve+Q1HnfQb3oXG9UYdF40JmyiB9D9+mqz5BNwbsA3vnmSCc8aOn
         2xslbh5IJlzu52hEapSP/CNT5cxItO0AKiHCPWACiElwOFgIublQfXMKf0Two2yjLF5l
         a1EA3NDp6NMFKGEO2DSE+ZfYo6fT3iWrBI14IjT1qwbkwfqz5y3qIZ+aCwDGa2NbPQb/
         jy/g==
X-Gm-Message-State: AAQBX9fTJwwhFz8Y7qnEUXsXTpMI5NcnLEHowla0GwSEJN7fzBiXdAgw
        JhnF8A4FwlIOJTiayspsWA8=
X-Google-Smtp-Source: AKy350b1lI/7oYXC7o4YA2rNQhIhx/wnN+4LOaI5v5kCAlbObHDch3hFRAM8039Bj2AeoQ/vDBwLKw==
X-Received: by 2002:a17:906:4ec5:b0:94e:80b2:51e3 with SMTP id i5-20020a1709064ec500b0094e80b251e3mr2310031ejv.27.1682087830425;
        Fri, 21 Apr 2023 07:37:10 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id q27-20020a170906361b00b0094e1026bc66sm2168244ejb.140.2023.04.21.07.37.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Apr 2023 07:37:10 -0700 (PDT)
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
Subject: [RFC PATCH net-next 07/22] net: dsa: mt7530: do not run mt7530_setup_port5() if port 5 is disabled
Date:   Fri, 21 Apr 2023 17:36:33 +0300
Message-Id: <20230421143648.87889-8-arinc.unal@arinc9.com>
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
 drivers/net/dsa/mt7530.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 591df09c8bb5..bac2388319a3 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -932,9 +932,6 @@ static void mt7530_setup_port5(struct dsa_switch *ds, phy_interface_t interface)
 		/* MT7530_P5_MODE_GMAC: P5 -> External phy or 2nd GMAC */
 		val &= ~MHWTRAP_P5_DIS;
 		break;
-	case P5_DISABLED:
-		interface = PHY_INTERFACE_MODE_NA;
-		break;
 	default:
 		dev_err(ds->dev, "Unsupported p5_intf_sel %d\n",
 			priv->p5_intf_sel);
@@ -2282,8 +2279,6 @@ mt7530_setup(struct dsa_switch *ds)
 		 * Set priv->p5_intf_sel to the appropriate value if PHY muxing
 		 * is detected.
 		 */
-		interface = PHY_INTERFACE_MODE_NA;
-
 		for_each_child_of_node(dn, mac_np) {
 			if (!of_device_is_compatible(mac_np,
 						     "mediatek,eth-mac"))
@@ -2315,7 +2310,9 @@ mt7530_setup(struct dsa_switch *ds)
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

