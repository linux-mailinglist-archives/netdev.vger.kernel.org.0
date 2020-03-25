Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55783192540
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 11:17:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727340AbgCYKRr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 06:17:47 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:44155 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbgCYKRr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 06:17:47 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 48nPFM5WRSz1rt3P;
        Wed, 25 Mar 2020 11:17:43 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 48nPFM4Yvcz1r0cV;
        Wed, 25 Mar 2020 11:17:43 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id rlaKaFYIn5R9; Wed, 25 Mar 2020 11:17:42 +0100 (CET)
X-Auth-Info: eu/Mchblh8PO6nAfxOlMO9XGcZaP5S0h9I4cGVMfquY=
Received: from desktop.lan (ip-86-49-35-8.net.upcbroadband.cz [86.49.35.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Wed, 25 Mar 2020 11:17:42 +0100 (CET)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     o.rempel@pengutronix.de, Marek Vasut <marex@denx.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jean Delvare <jdelvare@suse.com>
Subject: [RFC][PATCH 1/2] ethtool: Add BroadRReach Master/Slave PHY tunable
Date:   Wed, 25 Mar 2020 11:17:35 +0100
Message-Id: <20200325101736.2100-1-marex@denx.de>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a PHY tunable to select BroadRReach PHY Master/Slave mode.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Jean Delvare <jdelvare@suse.com>
Cc: netdev@vger.kernel.org
---
 include/uapi/linux/ethtool.h | 1 +
 net/core/ethtool.c           | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index dc69391d2bba..ebe658804ef1 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -259,6 +259,7 @@ struct ethtool_tunable {
 enum phy_tunable_id {
 	ETHTOOL_PHY_ID_UNSPEC,
 	ETHTOOL_PHY_DOWNSHIFT,
+	ETHTOOL_PHY_BRR_MODE,
 	/*
 	 * Add your fresh new phy tunable attribute above and remember to update
 	 * phy_tunable_strings[] in net/core/ethtool.c
diff --git a/net/core/ethtool.c b/net/core/ethtool.c
index 09d828a6a173..553f3d0e2624 100644
--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -133,6 +133,7 @@ static const char
 phy_tunable_strings[__ETHTOOL_PHY_TUNABLE_COUNT][ETH_GSTRING_LEN] = {
 	[ETHTOOL_ID_UNSPEC]     = "Unspec",
 	[ETHTOOL_PHY_DOWNSHIFT]	= "phy-downshift",
+	[ETHTOOL_PHY_BRR_MODE]	= "phy-broadrreach-mode",
 };
 
 static int ethtool_get_features(struct net_device *dev, void __user *useraddr)
@@ -2524,6 +2525,7 @@ static int ethtool_phy_tunable_valid(const struct ethtool_tunable *tuna)
 {
 	switch (tuna->id) {
 	case ETHTOOL_PHY_DOWNSHIFT:
+	case ETHTOOL_PHY_BRR_MODE:
 		if (tuna->len != sizeof(u8) ||
 		    tuna->type_id != ETHTOOL_TUNABLE_U8)
 			return -EINVAL;
-- 
2.25.1

