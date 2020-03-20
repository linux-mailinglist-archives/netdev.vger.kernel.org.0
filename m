Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99CF218CBDB
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 11:41:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727383AbgCTKlJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 06:41:09 -0400
Received: from inva021.nxp.com ([92.121.34.21]:54920 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727347AbgCTKlH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Mar 2020 06:41:07 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id E51032004AD;
        Fri, 20 Mar 2020 11:41:05 +0100 (CET)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id BFDA12004AC;
        Fri, 20 Mar 2020 11:40:59 +0100 (CET)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 654DE4030B;
        Fri, 20 Mar 2020 18:40:51 +0800 (SGT)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Yangbo Lu <yangbo.lu@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Subject: [PATCH 5/6] net: mscc: ocelot: add wave programming registers definitions
Date:   Fri, 20 Mar 2020 18:37:25 +0800
Message-Id: <20200320103726.32559-6-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200320103726.32559-1-yangbo.lu@nxp.com>
References: <20200320103726.32559-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add wave programming registers definitions for Ocelot platforms.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c  | 2 ++
 drivers/net/ethernet/mscc/ocelot_regs.c | 2 ++
 include/soc/mscc/ocelot.h               | 2 ++
 include/soc/mscc/ocelot_ptp.h           | 2 ++
 4 files changed, 8 insertions(+)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index b4078f3..4fe707e 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -313,6 +313,8 @@ static const u32 vsc9959_ptp_regmap[] = {
 	REG(PTP_PIN_TOD_SEC_MSB,           0x000004),
 	REG(PTP_PIN_TOD_SEC_LSB,           0x000008),
 	REG(PTP_PIN_TOD_NSEC,              0x00000c),
+	REG(PTP_PIN_WF_HIGH_PERIOD,        0x000014),
+	REG(PTP_PIN_WF_LOW_PERIOD,         0x000018),
 	REG(PTP_CFG_MISC,                  0x0000a0),
 	REG(PTP_CLK_CFG_ADJ_CFG,           0x0000a4),
 	REG(PTP_CLK_CFG_ADJ_FREQ,          0x0000a8),
diff --git a/drivers/net/ethernet/mscc/ocelot_regs.c b/drivers/net/ethernet/mscc/ocelot_regs.c
index b88b589..ed4dd01 100644
--- a/drivers/net/ethernet/mscc/ocelot_regs.c
+++ b/drivers/net/ethernet/mscc/ocelot_regs.c
@@ -239,6 +239,8 @@ static const u32 ocelot_ptp_regmap[] = {
 	REG(PTP_PIN_TOD_SEC_MSB,           0x000004),
 	REG(PTP_PIN_TOD_SEC_LSB,           0x000008),
 	REG(PTP_PIN_TOD_NSEC,              0x00000c),
+	REG(PTP_PIN_WF_HIGH_PERIOD,        0x000014),
+	REG(PTP_PIN_WF_LOW_PERIOD,         0x000018),
 	REG(PTP_CFG_MISC,                  0x0000a0),
 	REG(PTP_CLK_CFG_ADJ_CFG,           0x0000a4),
 	REG(PTP_CLK_CFG_ADJ_FREQ,          0x0000a8),
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 0ad61e3..bcce278 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -385,6 +385,8 @@ enum ocelot_reg {
 	PTP_PIN_TOD_SEC_MSB,
 	PTP_PIN_TOD_SEC_LSB,
 	PTP_PIN_TOD_NSEC,
+	PTP_PIN_WF_HIGH_PERIOD,
+	PTP_PIN_WF_LOW_PERIOD,
 	PTP_CFG_MISC,
 	PTP_CLK_CFG_ADJ_CFG,
 	PTP_CLK_CFG_ADJ_FREQ,
diff --git a/include/soc/mscc/ocelot_ptp.h b/include/soc/mscc/ocelot_ptp.h
index 2dd27f0..3dd63d2 100644
--- a/include/soc/mscc/ocelot_ptp.h
+++ b/include/soc/mscc/ocelot_ptp.h
@@ -14,6 +14,8 @@
 #define PTP_PIN_TOD_SEC_MSB_RSZ		PTP_PIN_CFG_RSZ
 #define PTP_PIN_TOD_SEC_LSB_RSZ		PTP_PIN_CFG_RSZ
 #define PTP_PIN_TOD_NSEC_RSZ		PTP_PIN_CFG_RSZ
+#define PTP_PIN_WF_HIGH_PERIOD_RSZ	PTP_PIN_CFG_RSZ
+#define PTP_PIN_WF_LOW_PERIOD_RSZ	PTP_PIN_CFG_RSZ
 
 #define PTP_PIN_CFG_DOM			BIT(0)
 #define PTP_PIN_CFG_SYNC		BIT(2)
-- 
2.7.4

