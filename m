Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2B58687E31
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 14:00:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232476AbjBBNAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 08:00:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232527AbjBBNAK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 08:00:10 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 656668E4AC;
        Thu,  2 Feb 2023 04:59:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1675342774; x=1706878774;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=l+6j3bIkI3D5xNchH0czU8eucYVEM7sYgP+6GkMs3tk=;
  b=OxSsIfqyLrh9uu+vES8XplLrbxqwa2M+Acz4JZ4joo9SQrBdzQsQ1D6i
   5Gx9IA8kpPmU9sf2KGdvfNBTEwfiZSCSXqCzYv5dQdeiK2io9V3EWh4wB
   OkOFCLg4B0r7cXVdtkVVlz1qXDxe56Z9CHP5XUUTiREzsGLrUi+Ha0u2h
   NAXEp5b+YzsnG71yLXBFUDaW6+MJNjNf/FTFTlZ0rVDFEPZY7Tdn0v2jz
   nwNB/KjivT8Ylftq/W4N5u3ivqZMeYk2Kqkjxw+sX0lPqyL6uR7SOw6V6
   DlZiGrXoEqVXB8JnVilHXcjUZFdFgZN5fYMKPu8L3Qu6eeqNtphZuPjN+
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,267,1669100400"; 
   d="scan'208";a="135252111"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Feb 2023 05:59:27 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 2 Feb 2023 05:59:26 -0700
Received: from che-lt-i67786lx.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Thu, 2 Feb 2023 05:59:22 -0700
From:   Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <olteanv@gmail.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <woojung.huh@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <linux@armlinux.org.uk>
Subject: [RFC PATCH net-next 11/11] net: dsa: microchip: lan937x: update multicast table
Date:   Thu, 2 Feb 2023 18:29:30 +0530
Message-ID: <20230202125930.271740-12-rakesh.sankaranarayanan@microchip.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230202125930.271740-1-rakesh.sankaranarayanan@microchip.com>
References: <20230202125930.271740-1-rakesh.sankaranarayanan@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Program multicast table for cascaded port in second switch with
default port forward value since it is the host port for second switch.
Current driver program the same for cpu port in first switch.

Signed-off-by: Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
---
 drivers/net/dsa/microchip/ksz9477.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 4c12131098b1..521d8c2e1540 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -1116,18 +1116,22 @@ void ksz9477_config_cpu_port(struct dsa_switch *ds)
 
 int ksz9477_enable_stp_addr(struct ksz_device *dev)
 {
+	u32 fwd_port = BIT(dev->cpu_port);
 	const u32 *masks;
 	u32 data;
 	int ret;
 
 	masks = dev->info->masks;
 
+	if (dev->ds->index == 1)
+		fwd_port = BIT(dev->dsa_port);
+
 	/* Enable Reserved multicast table */
 	ksz_cfg(dev, REG_SW_LUE_CTRL_0, SW_RESV_MCAST_ENABLE, true);
 
 	/* Set the Override bit for forwarding BPDU packet to CPU */
 	ret = ksz_write32(dev, REG_SW_ALU_VAL_B,
-			  ALU_V_OVERRIDE | BIT(dev->cpu_port));
+			  ALU_V_OVERRIDE | fwd_port);
 	if (ret < 0)
 		return ret;
 
-- 
2.34.1

