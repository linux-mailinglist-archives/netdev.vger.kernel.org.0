Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9156EDE30
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 10:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233828AbjDYIcz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 04:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233765AbjDYIbp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 04:31:45 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 257CF13C24;
        Tue, 25 Apr 2023 01:30:45 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id 4fb4d7f45d1cf-50506111a6eso10011019a12.1;
        Tue, 25 Apr 2023 01:30:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682411432; x=1685003432;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BDhIHtzgrt1JK0OHDfth9yreKDguDZ1mwE1kdBlBcjc=;
        b=Vs7/n3A14u40HN1zzZMUGkdqqU9uVQOs1pjNjF0fMuwj/qtPPRYsXL8b4BPsX4RZAC
         srr/fOeNSSA3GQpurqa6UjH0SXhSXTUUDfXwDYOF/UeakUP8z1XSZWUrwNml3PlzJ4zY
         gveSaBym8bK7QvSbG9pEwPvdz1obEtHS/Nh9TK73tGzL2ScCyyXbn49Ulel2kKoTUs+M
         tPLK6wCoGlIJR0Q19k4rvJZJ3Cb0UEgOjWzkqOLqKOtVCbY34t0v6/PNeoFJ1m2wY08+
         qxOPb43iBf3jUBBmUynwG5OwA1xsMqWZd+raPGX5d1g2nBsSpzBez9f90x1cycfwA5mo
         xiuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682411432; x=1685003432;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BDhIHtzgrt1JK0OHDfth9yreKDguDZ1mwE1kdBlBcjc=;
        b=A6DIFy4vs+jUk+71JNNiJe83/drpYQhiDykNqNAHUGZKy7/42DujIUebwOrEb0jrO2
         FZxn4CzCgLM2TfTHWcawvIXDNc81zspDwE+sspP9m+L1eDIlbYsGNoqFyXXSUf9lHLEu
         IxjDVTxsV5X5zs6Vkll/KC89+1RrsTXGyCqZKwYQ2PPeWSvWviFgXcb/2HqoODmvvY9u
         GYe8ykrcg5yYzrWzzAwXRM2f9YtQ+Ufe5GYjMkThOz160ul5zxFF8SUl7XgK/N+/KdfQ
         /FmA9h41Az/ECKXPsgqbdpqms6GUHkSddfpTHjrPKAToBuG3h8A5DHGu1G4E6vGQoS8C
         eU4A==
X-Gm-Message-State: AAQBX9cu0XBKcCcHpxMxGyavwZcRZeHxyLV1ll40oLyd+qARouccKuFz
        B3ivPQeR0xzCLNJjbC+VUKE=
X-Google-Smtp-Source: AKy350aRWIhqNZBAvc3x7nhtFqt59Dfm4+hxInSRx/S8/Kxa5racJG5jce4um2W1h3R8yESoFZbBFQ==
X-Received: by 2002:a17:906:3086:b0:94a:8291:a1e3 with SMTP id 6-20020a170906308600b0094a8291a1e3mr11236909ejv.74.1682411432342;
        Tue, 25 Apr 2023 01:30:32 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id mc2-20020a170906eb4200b0094ca077c985sm6439028ejb.213.2023.04.25.01.30.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 01:30:31 -0700 (PDT)
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
Subject: [PATCH net-next 16/24] net: dsa: mt7530: set TRGMII RD TAP if trgmii is being used
Date:   Tue, 25 Apr 2023 11:29:25 +0300
Message-Id: <20230425082933.84654-17-arinc.unal@arinc9.com>
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

This code sets the Read Data (RD) TAP value to 16 for all TRGMII control
registers.

The for loop iterates over all the TRGMII control registers, and
mt7530_rmw() function is used to perform a read-modify-write operation on
each register's RD_TAP field to set its value to 16.

This operation is used to tune the timing of the read data signal in
TRGMII to match the TX signal of the link partner.

Run this if trgmii is being used. Since this code doesn't lower the
driving, there's no apparent benefit to run this if trgmii is not being
used.

Add a comment to explain the code.

Thanks to 趙皎宏 (Landen Chao) for pointing out what the code does.

Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/mt7530.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index ea023e32313c..0108af681d50 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -404,7 +404,7 @@ static void
 mt7530_setup_port6(struct dsa_switch *ds, phy_interface_t interface)
 {
 	struct mt7530_priv *priv = ds->priv;
-	u32 ncpo1, ssc_delta, xtal, val;
+	u32 ncpo1, ssc_delta, i, xtal, val;
 
 	val = mt7530_read(priv, MT7530_MHWTRAP);
 	val &= ~MHWTRAP_P6_DIS;
@@ -457,6 +457,11 @@ mt7530_setup_port6(struct dsa_switch *ds, phy_interface_t interface)
 
 		/* Enable the MT7530 TRGMII clocks */
 		core_set(priv, CORE_TRGMII_GSW_CLK_CG, REG_TRGMIICK_EN);
+
+		/* Set the Read Data TAP value of the MT7530 TRGMII */
+		for (i = 0; i < NUM_TRGMII_CTRL; i++)
+			mt7530_rmw(priv, MT7530_TRGMII_RD(i),
+				   RD_TAP_MASK, RD_TAP(16));
 	}
 }
 
@@ -2214,10 +2219,6 @@ mt7530_setup(struct dsa_switch *ds)
 		mt7530_write(priv, MT7530_TRGMII_TD_ODT(i),
 			     TD_DM_DRVP(8) | TD_DM_DRVN(8));
 
-	for (i = 0; i < NUM_TRGMII_CTRL; i++)
-		mt7530_rmw(priv, MT7530_TRGMII_RD(i),
-			   RD_TAP_MASK, RD_TAP(16));
-
 	/* Enable PHY access and operate in manual mode */
 	val = mt7530_read(priv, MT7530_MHWTRAP);
 	val &= ~MHWTRAP_PHY_ACCESS;
-- 
2.37.2

