Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EED2112B8B
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 12:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727328AbfECKgs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 06:36:48 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:52053 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbfECKgs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 06:36:48 -0400
Received-SPF: Pass (esa3.microchip.iphmx.com: domain of
  Nicolas.Ferre@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="Nicolas.Ferre@microchip.com";
  x-sender="Nicolas.Ferre@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa3.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="Nicolas.Ferre@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa3.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Nicolas.Ferre@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
X-IronPort-AV: E=Sophos;i="5.60,425,1549954800"; 
   d="scan'208";a="31911162"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 03 May 2019 03:36:47 -0700
Received: from tenerife.corp.atmel.com (10.10.76.4) by
 chn-sv-exch06.mchp-main.com (10.10.76.107) with Microsoft SMTP Server id
 14.3.352.0; Fri, 3 May 2019 03:36:47 -0700
From:   Nicolas Ferre <nicolas.ferre@microchip.com>
To:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        <linux-arm-kernel@lists.infradead.org>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        <michal.simek@xilinx.com>, <harini.katakam@xilinx.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Subject: [PATCH] net: macb: remove redundant struct phy_device declaration
Date:   Fri, 3 May 2019 12:36:28 +0200
Message-ID: <20190503103628.17160-1-nicolas.ferre@microchip.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While moving the chunk of code during 739de9a1563a
("net: macb: Reorganize macb_mii bringup"), the declaration of
struct phy_device declaration was kept. It's not useful in this
function as we alrady have a phydev pointer.

Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 009ed4c1baf3..59531adcbb42 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -530,8 +530,6 @@ static int macb_mii_probe(struct net_device *dev)
 			 */
 			if (!bp->phy_node && !phy_find_first(bp->mii_bus)) {
 				for (i = 0; i < PHY_MAX_ADDR; i++) {
-					struct phy_device *phydev;
-
 					phydev = mdiobus_scan(bp->mii_bus, i);
 					if (IS_ERR(phydev) &&
 					    PTR_ERR(phydev) != -ENODEV) {
-- 
2.17.1

