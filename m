Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 174161035F1
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 09:23:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727940AbfKTIXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 03:23:46 -0500
Received: from inva021.nxp.com ([92.121.34.21]:52290 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727910AbfKTIXo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 03:23:44 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id D957420087B;
        Wed, 20 Nov 2019 09:23:42 +0100 (CET)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id DCDB8200862;
        Wed, 20 Nov 2019 09:23:37 +0100 (CET)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 80396402B5;
        Wed, 20 Nov 2019 16:23:31 +0800 (SGT)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     Yangbo Lu <yangbo.lu@nxp.com>
Subject: [PATCH 4/5] net: dsa: ocelot: define PTP registers for felix_vsc9959
Date:   Wed, 20 Nov 2019 16:23:17 +0800
Message-Id: <20191120082318.3909-5-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191120082318.3909-1-yangbo.lu@nxp.com>
References: <20191120082318.3909-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to define PTP registers for felix_vsc9959.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index d67bd14..b9758b0 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -282,6 +282,16 @@ static const u32 vsc9959_sys_regmap[] = {
 	REG_RESERVED(SYS_CM_DATA),
 };
 
+static const u32 vsc9959_ptp_regmap[] = {
+	REG(PTP_PIN_CFG,                   0x000000),
+	REG(PTP_PIN_TOD_SEC_MSB,           0x000004),
+	REG(PTP_PIN_TOD_SEC_LSB,           0x000008),
+	REG(PTP_PIN_TOD_NSEC,              0x00000c),
+	REG(PTP_CFG_MISC,                  0x0000a0),
+	REG(PTP_CLK_CFG_ADJ_CFG,           0x0000a4),
+	REG(PTP_CLK_CFG_ADJ_FREQ,          0x0000a8),
+};
+
 static const u32 vsc9959_gcb_regmap[] = {
 	REG(GCB_SOFT_RST,			0x000004),
 };
@@ -293,6 +303,7 @@ static const u32 *vsc9959_regmap[] = {
 	[REW]	= vsc9959_rew_regmap,
 	[SYS]	= vsc9959_sys_regmap,
 	[S2]	= vsc9959_s2_regmap,
+	[PTP]	= vsc9959_ptp_regmap,
 	[GCB]	= vsc9959_gcb_regmap,
 };
 
@@ -330,6 +341,11 @@ static struct resource vsc9959_target_io_res[] = {
 		.end	= 0x00603ff,
 		.name	= "s2",
 	},
+	[PTP] = {
+		.start	= 0x0090000,
+		.end	= 0x00900cb,
+		.name	= "ptp",
+	},
 	[GCB] = {
 		.start	= 0x0070000,
 		.end	= 0x00701ff,
-- 
2.7.4

