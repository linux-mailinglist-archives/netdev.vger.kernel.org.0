Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66C42D50F7
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 18:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729236AbfJLQ2E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 12:28:04 -0400
Received: from mail-wm1-f46.google.com ([209.85.128.46]:35015 "EHLO
        mail-wm1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727262AbfJLQ2D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Oct 2019 12:28:03 -0400
Received: by mail-wm1-f46.google.com with SMTP id y21so12857133wmi.0
        for <netdev@vger.kernel.org>; Sat, 12 Oct 2019 09:28:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=a4YJs8zYUHJzbNo/VmeEjkPYuk+XUUHRBoED3IplySc=;
        b=11QhGVCVR3RemVU2XAgkZraXmAFzNJi3hL+TzHIkaVYtezuz5nCDJ9tlJllFuU5+c7
         KQ+Qv9TwHXZMqVYRQkWkiAuu8p6qTk1WQAnVvAYEwsvh+2jNIQyqxyCh15iGvtyCcG9/
         2IhmYzpVdeI23ODHHzTIpRX1cBW+v2TvNSOZ78FfjPWjHrKEdBhliocqasxco6sao7eu
         XBym6QnHKhufinT/1ax9Ly8OsLh7gRmf0ffKH7jYUNyetaPN4vuwpLWBJU/eea4rDF8X
         fR8BWshsFXOUaQb/uh0fL/cp/uxmwT9Waol2225QwXkXbveM9fMdQv/7eLdfAu3eUO17
         yAOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a4YJs8zYUHJzbNo/VmeEjkPYuk+XUUHRBoED3IplySc=;
        b=h5gPAF7PEZfSWAYrn2m3b5mO7ZWDCu+AC2JuNi4iwT4qVu1t8dh4HtM0onRX0wBXwW
         qFVP+WpUxKViy33ABrzac6Q2jTejQg1a+HGXAs7EWP3jIn5RNzmcN17bl5xN2ei15XdT
         YgLQAwjhGO58xCgegNuw0pOyIap3IeSGiwTnuW2eF9qwefNA66CyHRmGMyFjhyPtljKk
         8IqEilAJ4AWeGlF0nn3INxu5arq+EHiCfbTRjlzv8ve/A0WAQyDaCzLveFkKbFy0fPYn
         Jo8XVGIIuNzO0F0Jm2+hEcmefcOok3ITMIi3zWd69X8md2+wFVMUerQ5E43yMOkJpVuE
         3mWA==
X-Gm-Message-State: APjAAAVUyTTpCc/KAr+tHPf0yRMJnJ/JZ9iKyLuY6Lba/BvbH6+dpC7b
        UD1YJKsTdg0ybAA21AYpNsM3K97IRWY=
X-Google-Smtp-Source: APXvYqxODuN68LUDrHv0me+JwqC939e1GHm7042zxhrLFxIpWp5+ymo5Se/I0HouMvtTzI2fnDJJ7w==
X-Received: by 2002:a1c:988b:: with SMTP id a133mr7534765wme.22.1570897680765;
        Sat, 12 Oct 2019 09:28:00 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id p7sm8956633wma.34.2019.10.12.09.28.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Oct 2019 09:28:00 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, mlxsw@mellanox.com
Subject: [patch net-next v2 1/2] ethtool: Add support for 400Gbps (50Gbps per lane) link modes
Date:   Sat, 12 Oct 2019 18:27:57 +0200
Message-Id: <20191012162758.32473-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191012162758.32473-1-jiri@resnulli.us>
References: <20191012162758.32473-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Add support for 400Gbps speed, link modes of 50Gbps per lane

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
v1->v2:
- added patch description
---
 drivers/net/phy/phy-core.c   | 10 +++++++++-
 include/uapi/linux/ethtool.h |  6 ++++++
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
index 9412669b579c..4d96f7a8e8f2 100644
--- a/drivers/net/phy/phy-core.c
+++ b/drivers/net/phy/phy-core.c
@@ -8,7 +8,7 @@
 
 const char *phy_speed_to_str(int speed)
 {
-	BUILD_BUG_ON_MSG(__ETHTOOL_LINK_MODE_MASK_NBITS != 69,
+	BUILD_BUG_ON_MSG(__ETHTOOL_LINK_MODE_MASK_NBITS != 74,
 		"Enum ethtool_link_mode_bit_indices and phylib are out of sync. "
 		"If a speed or mode has been added please update phy_speed_to_str "
 		"and the PHY settings array.\n");
@@ -42,6 +42,8 @@ const char *phy_speed_to_str(int speed)
 		return "100Gbps";
 	case SPEED_200000:
 		return "200Gbps";
+	case SPEED_400000:
+		return "400Gbps";
 	case SPEED_UNKNOWN:
 		return "Unknown";
 	default:
@@ -70,6 +72,12 @@ EXPORT_SYMBOL_GPL(phy_duplex_to_str);
 			       .bit = ETHTOOL_LINK_MODE_ ## b ## _BIT}
 
 static const struct phy_setting settings[] = {
+	/* 400G */
+	PHY_SETTING( 400000, FULL, 400000baseCR8_Full		),
+	PHY_SETTING( 400000, FULL, 400000baseKR8_Full		),
+	PHY_SETTING( 400000, FULL, 400000baseLR8_ER8_FR8_Full	),
+	PHY_SETTING( 400000, FULL, 400000baseDR8_Full		),
+	PHY_SETTING( 400000, FULL, 400000baseSR8_Full		),
 	/* 200G */
 	PHY_SETTING( 200000, FULL, 200000baseCR4_Full		),
 	PHY_SETTING( 200000, FULL, 200000baseKR4_Full		),
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index 8938b76c4ee3..d4591792f0b4 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -1507,6 +1507,11 @@ enum ethtool_link_mode_bit_indices {
 	ETHTOOL_LINK_MODE_200000baseCR4_Full_BIT	 = 66,
 	ETHTOOL_LINK_MODE_100baseT1_Full_BIT		 = 67,
 	ETHTOOL_LINK_MODE_1000baseT1_Full_BIT		 = 68,
+	ETHTOOL_LINK_MODE_400000baseKR8_Full_BIT	 = 69,
+	ETHTOOL_LINK_MODE_400000baseSR8_Full_BIT	 = 70,
+	ETHTOOL_LINK_MODE_400000baseLR8_ER8_FR8_Full_BIT = 71,
+	ETHTOOL_LINK_MODE_400000baseDR8_Full_BIT	 = 72,
+	ETHTOOL_LINK_MODE_400000baseCR8_Full_BIT	 = 73,
 
 	/* must be last entry */
 	__ETHTOOL_LINK_MODE_MASK_NBITS
@@ -1618,6 +1623,7 @@ enum ethtool_link_mode_bit_indices {
 #define SPEED_56000		56000
 #define SPEED_100000		100000
 #define SPEED_200000		200000
+#define SPEED_400000		400000
 
 #define SPEED_UNKNOWN		-1
 
-- 
2.21.0

