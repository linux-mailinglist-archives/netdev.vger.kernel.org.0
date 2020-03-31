Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46FB6198B10
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 06:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729918AbgCaEPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 00:15:19 -0400
Received: from inva021.nxp.com ([92.121.34.21]:46970 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729624AbgCaEPS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Mar 2020 00:15:18 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 4C5DB2007AF;
        Tue, 31 Mar 2020 06:15:17 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 16AE62007D5;
        Tue, 31 Mar 2020 06:15:11 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 27B5F402C8;
        Tue, 31 Mar 2020 12:14:57 +0800 (SGT)
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
Subject: [v2, 7/7] net: dsa: felix: enable PTP programmable pin
Date:   Tue, 31 Mar 2020 12:11:13 +0800
Message-Id: <20200331041113.15873-8-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200331041113.15873-1-yangbo.lu@nxp.com>
References: <20200331041113.15873-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable PTP programmable pin.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
Changes for v2:
	- Added this patch.
---
 drivers/net/dsa/ocelot/felix.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index e1573bc..bfa4c12 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -504,13 +504,15 @@ static struct ptp_clock_info ocelot_ptp_clock_info = {
 	.max_adj	= 0x7fffffff,
 	.n_alarm	= 0,
 	.n_ext_ts	= 0,
-	.n_per_out	= 0,
-	.n_pins		= 0,
+	.n_per_out	= OCELOT_PTP_PINS_NUM,
+	.n_pins		= OCELOT_PTP_PINS_NUM,
 	.pps		= 0,
 	.gettime64	= ocelot_ptp_gettime64,
 	.settime64	= ocelot_ptp_settime64,
 	.adjtime	= ocelot_ptp_adjtime,
 	.adjfine	= ocelot_ptp_adjfine,
+	.verify		= ocelot_ptp_verify,
+	.enable		= ocelot_ptp_enable,
 };
 
 /* Hardware initialization done here so that we can allocate structures with
-- 
2.7.4

