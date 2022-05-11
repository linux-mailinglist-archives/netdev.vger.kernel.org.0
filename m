Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A953B5230C9
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 12:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231751AbiEKKjC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 06:39:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239593AbiEKKi6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 06:38:58 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFFBE9BAC7;
        Wed, 11 May 2022 03:38:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1652265507; x=1683801507;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4d2r++ODIwPQnQR41o2Hor18zKmdz4y8vNW8f6xrvKA=;
  b=H1g6D/aVRyYCsnV5TEIcs/9I4+U0cNos7H3G9IcVmwMy2553Dv3kSpWH
   fMHvQVpJH2HM7RiT0fLsensGi74o4+DTXFAfpuiGutjPPPlWcwn3Mw0mD
   xrLLSswc4VA018NReWmPOsgq7l6Tl1eeJ9nQNIAuL/gb+qI0dse0yIaF3
   9ym+sl36uR5RQnVbsOl/J6GzZJ1m9+bi4CEg55IEp3+PBuyVWQW/LOSGG
   zVd6eHeh+xF4GBLiwHRGEmWZDmqbQW3PYVVxKfLmVQ2n+vu75L4POn6CA
   89uUBuJJId2WxSDxuQJXeD/Ppu4p7B1yE4jINz3ypChqwtaWhYRB5lWmC
   g==;
X-IronPort-AV: E=Sophos;i="5.91,216,1647327600"; 
   d="scan'208";a="158596612"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 May 2022 03:38:27 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 11 May 2022 03:38:26 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Wed, 11 May 2022 03:38:21 -0700
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
        Eric Dumazet <edumazet@google.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Marek Vasut <marex@denx.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: [RFC Patch net-next 1/9] net: dsa: microchip: ksz8795: update the port_cnt value in ksz_chip_data
Date:   Wed, 11 May 2022 16:07:47 +0530
Message-ID: <20220511103755.12553-2-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220511103755.12553-1-arun.ramadoss@microchip.com>
References: <20220511103755.12553-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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

