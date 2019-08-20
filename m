Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D73B0955E1
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 06:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729138AbfHTERy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 00:17:54 -0400
Received: from inva021.nxp.com ([92.121.34.21]:54228 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727006AbfHTERy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 00:17:54 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id AC1E520007D;
        Tue, 20 Aug 2019 06:17:52 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 39BFC200148;
        Tue, 20 Aug 2019 06:17:49 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 93232402B7;
        Tue, 20 Aug 2019 12:17:44 +0800 (SGT)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        "Allan W . Nielsen" <allan.nielsen@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Yangbo Lu <yangbo.lu@nxp.com>
Subject: [v3] ocelot_ace: fix action of trap
Date:   Tue, 20 Aug 2019 12:20:05 +0800
Message-Id: <20190820042005.12776-1-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The trap action should be copying the frame to CPU and
dropping it for forwarding, but current setting was just
copying frame to CPU.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_ace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_ace.c b/drivers/net/ethernet/mscc/ocelot_ace.c
index 39aca1a..86fc6e6 100644
--- a/drivers/net/ethernet/mscc/ocelot_ace.c
+++ b/drivers/net/ethernet/mscc/ocelot_ace.c
@@ -317,7 +317,7 @@ static void is2_action_set(struct vcap_data *data,
 		break;
 	case OCELOT_ACL_ACTION_TRAP:
 		VCAP_ACT_SET(PORT_MASK, 0x0);
-		VCAP_ACT_SET(MASK_MODE, 0x0);
+		VCAP_ACT_SET(MASK_MODE, 0x1);
 		VCAP_ACT_SET(POLICE_ENA, 0x0);
 		VCAP_ACT_SET(POLICE_IDX, 0x0);
 		VCAP_ACT_SET(CPU_QU_NUM, 0x0);
-- 
2.7.4

