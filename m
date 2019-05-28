Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 331F82CE50
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 20:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727896AbfE1SQQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 14:16:16 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:59919 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727473AbfE1SQQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 14:16:16 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 45D28r5NhYz1rYXY;
        Tue, 28 May 2019 20:16:12 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 45D28r4chQz1qqkK;
        Tue, 28 May 2019 20:16:12 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id MIGZjLMzH4Vl; Tue, 28 May 2019 20:16:11 +0200 (CEST)
X-Auth-Info: nt9nDC7iCui/4G2q3jKtIpOA88xJ8ExQvUWMBppV31Y=
Received: from kurokawa.lan (ip-86-49-110-70.net.upcbroadband.cz [86.49.110.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Tue, 28 May 2019 20:16:11 +0200 (CEST)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jean Delvare <jdelvare@suse.com>, linux-hwmon@vger.kernel.org
Subject: [PATCH] net: phy: tja11xx: Switch to HWMON_CHANNEL_INFO()
Date:   Tue, 28 May 2019 20:15:41 +0200
Message-Id: <20190528181541.1946-1-marex@denx.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The HWMON_CHANNEL_INFO macro simplifies the code, reduces the likelihood
of errors, and makes the code easier to read.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Jean Delvare <jdelvare@suse.com>
Cc: linux-hwmon@vger.kernel.org
---
 drivers/net/phy/nxp-tja11xx.c | 24 ++----------------------
 1 file changed, 2 insertions(+), 22 deletions(-)

diff --git a/drivers/net/phy/nxp-tja11xx.c b/drivers/net/phy/nxp-tja11xx.c
index 11b8701e78fd..b705d0bd798b 100644
--- a/drivers/net/phy/nxp-tja11xx.c
+++ b/drivers/net/phy/nxp-tja11xx.c
@@ -311,29 +311,9 @@ static umode_t tja11xx_hwmon_is_visible(const void *data,
 	return 0;
 }
 
-static u32 tja11xx_hwmon_in_config[] = {
-	HWMON_I_LCRIT_ALARM,
-	0
-};
-
-static const struct hwmon_channel_info tja11xx_hwmon_in = {
-	.type		= hwmon_in,
-	.config		= tja11xx_hwmon_in_config,
-};
-
-static u32 tja11xx_hwmon_temp_config[] = {
-	HWMON_T_CRIT_ALARM,
-	0
-};
-
-static const struct hwmon_channel_info tja11xx_hwmon_temp = {
-	.type		= hwmon_temp,
-	.config		= tja11xx_hwmon_temp_config,
-};
-
 static const struct hwmon_channel_info *tja11xx_hwmon_info[] = {
-	&tja11xx_hwmon_in,
-	&tja11xx_hwmon_temp,
+	HWMON_CHANNEL_INFO(in, HWMON_I_LCRIT_ALARM),
+	HWMON_CHANNEL_INFO(temp, HWMON_T_CRIT_ALARM),
 	NULL
 };
 
-- 
2.20.1

