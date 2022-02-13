Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B18A34B38C8
	for <lists+netdev@lfdr.de>; Sun, 13 Feb 2022 01:38:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232697AbiBMAi2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Feb 2022 19:38:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232675AbiBMAi2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Feb 2022 19:38:28 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6922B6004E
        for <netdev@vger.kernel.org>; Sat, 12 Feb 2022 16:38:23 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id w11so21156043wra.4
        for <netdev@vger.kernel.org>; Sat, 12 Feb 2022 16:38:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version:organization
         :content-transfer-encoding;
        bh=bT2Te+Kg9SQlga08Bc5dZ+XNGd8nQG47I/LjRlS+lTA=;
        b=izpzK2aptidswgj+IrD8bsq0MTZ2eEsoQQF6NZBWOjfHyo+7uJl0c17wn6Y3LgvVLJ
         P1upGmuHjQ5GC28vYiOQDDvNz1BLKZqI4nAQFMFijNr2jd6L1Zs7d2sBu8RqFy2EPPwE
         kTIPDtZjqDCypTGpf0xXxo1LRVxVhhGp6W3rFP8lOmOrXM+beXE2OYRTwFmtZJ/P+Esf
         xVRFB8C+lZ950y6MuLNSWKUSmz3HrBNIELZ9QP6e9KWCtPaV+AqsycFEZEkDqGbiJtjD
         3gQLDIr3BE8LtfOHc8ycvM2xoe7hOqHKrbam6NEsM6sCt3h1nF4peM78dlXHGCPRimmO
         Q82g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :organization:content-transfer-encoding;
        bh=bT2Te+Kg9SQlga08Bc5dZ+XNGd8nQG47I/LjRlS+lTA=;
        b=0sKCsqRJ/2jd+1jCEZ49hUQ41gcfDqpBSNUICFmKSKYwSir9QXhoqPpR6B58h6O85a
         brX5faX2jzBh0Zh9WNeFMqSNkuZTF4OsadoDKhNQ/0nCWg0meSPiLWDIuK9Jn7aOjW6b
         8yQ7j/bRJ5d2t1MRh4Tx1txw+CsCxoZUF9J5tm065vDs+iStTWLTt2K2g+DloV3Axqve
         JuGL7kcQYYFJVDoEiiJMV8pb9Z7NDujGV9NWSVNEvbFbOHmTZq8FreGJFEjW6kwpr8Lv
         PepQ/Dut2Ch3vOjs4gMKcEl5k4Dp5MKf1p3yHFVFEh3jc6BljTt/2SEtOyjSVjSqiF7J
         WQBw==
X-Gm-Message-State: AOAM531YQ7yELjqh02HuzC8bfgf1JnURcibRvUFnb3qqUJJ99XneNiQf
        XzOGQefKPatjFiedlVa0gjuwMQ==
X-Google-Smtp-Source: ABdhPJwvun1U+g/rmYkWGOIuPnc/4//mZOAHrhni/PE25GNEMCqB4AeM286Hqez96qRO44bfGOIGpg==
X-Received: by 2002:adf:908f:: with SMTP id i15mr6531238wri.256.1644712701925;
        Sat, 12 Feb 2022 16:38:21 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id s7sm8676472wrw.71.2022.02.12.16.38.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Feb 2022 16:38:21 -0800 (PST)
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
Subject: [PATCH net-next] net: dsa: mv88e6xxx: Fix validation of built-in PHYs on 6095/6097
Date:   Sun, 13 Feb 2022 01:37:01 +0100
Message-Id: <20220213003702.2440875-1-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
 drivers/net/dsa/mv88e6xxx/chip.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 85527fe4fcc8..622b3b4ed513 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -580,6 +580,27 @@ static const u8 mv88e6185_phy_interface_modes[] = {
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
+		if (cmode == MV88E6185_PORT_STS_CMODE_PHY)
+			__set_bit(PHY_INTERFACE_MODE_MII,
+				  config->supported_interfaces);
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
@@ -3803,7 +3824,7 @@ static const struct mv88e6xxx_ops mv88e6095_ops = {
 	.reset = mv88e6185_g1_reset,
 	.vtu_getnext = mv88e6185_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6185_g1_vtu_loadpurge,
-	.phylink_get_caps = mv88e6185_phylink_get_caps,
+	.phylink_get_caps = mv88e6095_phylink_get_caps,
 	.set_max_frame_size = mv88e6185_g1_set_max_frame_size,
 };
 
@@ -3850,7 +3871,7 @@ static const struct mv88e6xxx_ops mv88e6097_ops = {
 	.rmu_disable = mv88e6085_g1_rmu_disable,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
-	.phylink_get_caps = mv88e6185_phylink_get_caps,
+	.phylink_get_caps = mv88e6095_phylink_get_caps,
 	.set_max_frame_size = mv88e6185_g1_set_max_frame_size,
 };
 
-- 
2.25.1

