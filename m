Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDC051B0001
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 04:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbgDTCvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 22:51:40 -0400
Received: from inva020.nxp.com ([92.121.34.13]:55908 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725988AbgDTCvX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Apr 2020 22:51:23 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id AE2031A0616;
        Mon, 20 Apr 2020 04:51:21 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id BECEE1A0642;
        Mon, 20 Apr 2020 04:51:16 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id CF7C7402ED;
        Mon, 20 Apr 2020 10:51:08 +0800 (SGT)
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
Subject: [v3, 7/7] net: dsa: felix: enable PTP programmable pin
Date:   Mon, 20 Apr 2020 10:46:51 +0800
Message-Id: <20200420024651.47353-8-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200420024651.47353-1-yangbo.lu@nxp.com>
References: <20200420024651.47353-1-yangbo.lu@nxp.com>
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
Changes for v3:
	- None.
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

