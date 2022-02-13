Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10BA94B3CF6
	for <lists+netdev@lfdr.de>; Sun, 13 Feb 2022 19:52:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237749AbiBMSwM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 13:52:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234745AbiBMSwL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 13:52:11 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F51E580D9
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 10:52:05 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id i14so23512436wrc.10
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 10:52:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version:organization
         :content-transfer-encoding;
        bh=5b6T59mtoBLg2aHTqbBo/r+mo6q1zaT8htW2r31opOo=;
        b=jkcJuibzzNnKOpzhPiGpqn62fKaL16PjFsJa9ECq+C+9uKDFnGlijB7gW+8kO7w+HY
         JTcmBFp3EXWo8QZxjaYvYNZmWqtKY53glpL8tsHmTXry7U0lPDGb0TWpinKA5mPeGL14
         kDUW1Ri44IFGs5CQt4gY1kJHP3LLzsCHOzrL4MFDt2iS0ahGKDxBtEqHdiKsXO6wREoz
         zgKTBZX068Vk/n8xLuTiT/ydSusfeWg8P2AgGIYZU0B2/wTqzDMOkjsHC4EWiT+Fnw3Y
         BU9gqnjg5KAlnM2NRS4uDHlhXeU27TTzmSObP9PDmVxnVVIQYWMX27BEh5GwhM+snTIy
         GYOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :organization:content-transfer-encoding;
        bh=5b6T59mtoBLg2aHTqbBo/r+mo6q1zaT8htW2r31opOo=;
        b=q0Zkjr0p3GipJ4k0XB9Hr3XF4if2P2thQhshes6r0DEKjPJk+uiqSBOpws1jGjZTJl
         rK0lGRHFMZO4qVlGEG2xkiaBxSk6hn1BtgnNzElmUQ5bQtaW1eu3OTKPAlNFeagO3qcW
         ZQWo5ueCS/Oc7BwDnFD4jCPVjAciytUDsnHYNTf+ALysBUpIF15MTUooTlVu6VVIYC/a
         Bv6nPl6ayEmnNJabLN6P8mE3qTFvssGH+u1RIrItZDtTsqmzOKBnOzMAqlHq4mYc8gOO
         WJ1Y8z9p20O23rsNDhxSPAZCvMTC3XXRF96lbLRLOChuPZWG5I3BN481RVxBcVhxCvkh
         qxcg==
X-Gm-Message-State: AOAM531xYoVz03410Pn446IYsIDtgpKplG7nazHMlKkgymlMslhC9KMG
        rUW7x8Mp91Sq/LQOxR7wwg0EaeZf/4EifQ==
X-Google-Smtp-Source: ABdhPJwjXJQ+chY2+2rwARmjalWZYGCDghqclK/Ut0wkfk6IbBp15ag9Ju/I1wD+LzfC15WFaL6/2A==
X-Received: by 2002:a05:6000:81:: with SMTP id m1mr8479062wrx.94.1644778324070;
        Sun, 13 Feb 2022 10:52:04 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id j5sm25659049wrq.31.2022.02.13.10.52.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Feb 2022 10:52:03 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next] net: dsa: mv88e6xxx: Fix validation of built-in PHYs on 6095/6097
Date:   Sun, 13 Feb 2022 19:51:54 +0100
Message-Id: <20220213185154.3262207-1-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These chips have 8 built-in FE PHYs and 3 SERDES interfaces that can
run at 1G. With the blamed commit, the built-in PHYs could no longer
be connected to, using an MII PHY interface mode.

Create a separate .phylink_get_caps callback for these chips, which
takes the FE/GE split into consideration.

Fixes: 2ee84cfefb1e ("net: dsa: mv88e6xxx: convert to phylink_generic_validate()")
Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 85527fe4fcc8..34036c555977 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -580,6 +580,25 @@ static const u8 mv88e6185_phy_interface_modes[] = {
 	[MV88E6185_PORT_STS_CMODE_PHY]		 = PHY_INTERFACE_MODE_SGMII,
 };
 
+static void mv88e6095_phylink_get_caps(struct mv88e6xxx_chip *chip, int port,
+				       struct phylink_config *config)
+{
+	u8 cmode = chip->ports[port].cmode;
+
+	config->mac_capabilities = MAC_SYM_PAUSE | MAC_10 | MAC_100;
+
+	if (mv88e6xxx_phy_is_internal(chip->ds, port)) {
+		__set_bit(PHY_INTERFACE_MODE_MII, config->supported_interfaces);
+	} else {
+		if (cmode < ARRAY_SIZE(mv88e6185_phy_interface_modes) &&
+		    mv88e6185_phy_interface_modes[cmode])
+			__set_bit(mv88e6185_phy_interface_modes[cmode],
+				  config->supported_interfaces);
+
+		config->mac_capabilities |= MAC_1000FD;
+	}
+}
+
 static void mv88e6185_phylink_get_caps(struct mv88e6xxx_chip *chip, int port,
 				       struct phylink_config *config)
 {
@@ -3803,7 +3822,7 @@ static const struct mv88e6xxx_ops mv88e6095_ops = {
 	.reset = mv88e6185_g1_reset,
 	.vtu_getnext = mv88e6185_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6185_g1_vtu_loadpurge,
-	.phylink_get_caps = mv88e6185_phylink_get_caps,
+	.phylink_get_caps = mv88e6095_phylink_get_caps,
 	.set_max_frame_size = mv88e6185_g1_set_max_frame_size,
 };
 
@@ -3850,7 +3869,7 @@ static const struct mv88e6xxx_ops mv88e6097_ops = {
 	.rmu_disable = mv88e6085_g1_rmu_disable,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
-	.phylink_get_caps = mv88e6185_phylink_get_caps,
+	.phylink_get_caps = mv88e6095_phylink_get_caps,
 	.set_max_frame_size = mv88e6185_g1_set_max_frame_size,
 };
 
-- 
2.25.1

