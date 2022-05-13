Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61662525FC9
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 12:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379346AbiEMKW4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 06:22:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379395AbiEMKWo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 06:22:44 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E90915A740;
        Fri, 13 May 2022 03:22:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1652437363; x=1683973363;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4d2r++ODIwPQnQR41o2Hor18zKmdz4y8vNW8f6xrvKA=;
  b=bDpKbUhJdUG6q0dxMlNW7xYOKZ3JqLhcQmf6cEE4vIllpFZPbj8q3Qiu
   yI3y7+SyIeFKXvRXdI0/Dp03mJGz6CRpGDvZ2uL0WqkjW8VVdchgsC+1O
   +Vv5ablXWZVzuFQiigidEcul9zoRj/HaUqkYFgz9oxDC8/WAJcfas+Rzl
   uEVFzeWiWHMZmTujD87Q4BsbwtEZ+1OwvcMgS3+v6x0Mgq8w6nwAWNp5x
   oGo4MJI8CadQRJ5wMA+FwhAKdJSXe7uhQhUAgJ2wTK/7Babv0mLWXBicx
   blcPId/mUS6asxVAnAfe8i9byyOmhlGLO35Tr6eKOvt0oQ6gBbGA3lY+4
   g==;
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="173236818"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 May 2022 03:22:43 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 13 May 2022 03:22:43 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 13 May 2022 03:22:38 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Russell King <linux@armlinux.org.uk>,
        Woojung Huh <woojung.huh@microchip.com>,
        <UNGLinuxDriver@microchip.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Marek Vasut <marex@denx.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Eric Dumazet <edumazet@google.com>
Subject: [RFC Patch net-next v2 1/9] net: dsa: microchip: ksz8795: update the port_cnt value in ksz_chip_data
Date:   Fri, 13 May 2022 15:52:11 +0530
Message-ID: <20220513102219.30399-2-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220513102219.30399-1-arun.ramadoss@microchip.com>
References: <20220513102219.30399-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The port_cnt value in the structure is not used in the switch_init.
Instead it uses the fls(chip->cpu_port), this is due to one of port in
the ksz8794 unavailable. The cpu_port for the 8794 is 0x10, fls(0x10) =
5, hence updating it directly in the ksz_chip_data structure in order to
same with all the other switches in ksz8795.c and ksz9477.c files.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz8795.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index f91deea9368e..83bcabf2dc54 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1607,6 +1607,7 @@ static const struct ksz_chip_data ksz8_switch_chips[] = {
 		 * KSZ8794   0,1,2      4
 		 * KSZ8795   0,1,2,3    4
 		 * KSZ8765   0,1,2,3    4
+		 * port_cnt is configured as 5, even though it is 4
 		 */
 		.chip_id = 0x8794,
 		.dev_name = "KSZ8794",
@@ -1614,7 +1615,7 @@ static const struct ksz_chip_data ksz8_switch_chips[] = {
 		.num_alus = 0,
 		.num_statics = 8,
 		.cpu_ports = 0x10,	/* can be configured as cpu port */
-		.port_cnt = 4,		/* total cpu and user ports */
+		.port_cnt = 5,		/* total cpu and user ports */
 		.ksz87xx_eee_link_erratum = true,
 	},
 	{
@@ -1653,7 +1654,7 @@ static int ksz8_switch_init(struct ksz_device *dev)
 			dev->num_vlans = chip->num_vlans;
 			dev->num_alus = chip->num_alus;
 			dev->num_statics = chip->num_statics;
-			dev->port_cnt = fls(chip->cpu_ports);
+			dev->port_cnt = chip->port_cnt;
 			dev->cpu_port = fls(chip->cpu_ports) - 1;
 			dev->phy_port_cnt = dev->port_cnt - 1;
 			dev->cpu_ports = chip->cpu_ports;
-- 
2.33.0

