Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C63C05117F6
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 14:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233187AbiD0LzN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 07:55:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233170AbiD0LzL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 07:55:11 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16776473BB
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 04:52:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1651060321; x=1682596321;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version;
  bh=Pqh0d2pZhNiZ1vFFWPMz2pFQ/flBiCpUwQeyGSsTmbM=;
  b=ig9yi8rIMMRkKPPI3ekeEKNRuVx8ZYwSz5AK5nQ+VP0jQFXnIXJErHnG
   iAPX/jTtp2RE3NHtwhtAbjM7BQO1qvZzzUys9WHm5tLaW6z7z/TdjBqyX
   sEwo8Iq6VIj8V6Pe9Ue8Kv3EOys6Zjy/Zzly6yb0KYmJlfizt5Y80tZ/Q
   mBWEnDNikC++ST1YVWub32d4AjGHw8QjV3k3a0cnoqwFyuMYIyZ4LJmIy
   D7FBSU56yfZFPfb6ds0fyIjy21d7zv+/boC6erh99pr1fpID4aKUqsMQf
   zX2PjYdsWwAkb2M24L05uwGRekhHSN3/wkDAe9ALvd8W7biMgCCUGd6CN
   g==;
X-IronPort-AV: E=Sophos;i="5.90,292,1643698800"; 
   d="scan'208";a="161496755"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Apr 2022 04:51:59 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 27 Apr 2022 04:51:58 -0700
Received: from chn-vm-ungapp01.mchp-main.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Wed, 27 Apr 2022 04:51:58 -0700
From:   Yuiko Oshino <yuiko.oshino@microchip.com>
To:     <woojung.huh@microchip.com>, <yuiko.oshino@microchip.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <andrew@lunn.ch>,
        <ravi.hegde@microchip.com>, <UNGLinuxDriver@microchip.com>
Subject: [PATCH net-next 2/2] net: phy: smsc: add LAN8742 phy support.
Date:   Wed, 27 Apr 2022 04:51:42 -0700
Message-ID: <20220427115142.12642-3-yuiko.oshino@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220427115142.12642-1-yuiko.oshino@microchip.com>
References: <20220427115142.12642-1-yuiko.oshino@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current phy IDs on the available hardware.
        LAN8742 0x0007C130, 0x0007C131

Signed-off-by: Yuiko Oshino <yuiko.oshino@microchip.com>
---
 drivers/net/phy/smsc.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index d8cac02a79b9..2b3b5d0ad6f3 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -483,6 +483,32 @@ static struct phy_driver smsc_phy_driver[] = {
 
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
+}, {
+	.phy_id	= 0x0007c130,	/* 0x0007c130 and 0x0007c131 */
+	.phy_id_mask	= 0xfffffff2,
+	.name		= "Microchip LAN8742",
+
+	/* PHY_BASIC_FEATURES */
+	.flags		= PHY_RST_AFTER_CLK_EN,
+
+	.probe		= smsc_phy_probe,
+
+	/* basic functions */
+	.read_status	= lan87xx_read_status,
+	.config_init	= smsc_phy_config_init,
+	.soft_reset	= smsc_phy_reset,
+
+	/* IRQ related */
+	.config_intr	= smsc_phy_config_intr,
+	.handle_interrupt = smsc_phy_handle_interrupt,
+
+	/* Statistics */
+	.get_sset_count = smsc_get_sset_count,
+	.get_strings	= smsc_get_strings,
+	.get_stats	= smsc_get_stats,
+
+	.suspend	= genphy_suspend,
+	.resume	= genphy_resume,
 } };
 
 module_phy_driver(smsc_phy_driver);
@@ -498,6 +524,7 @@ static struct mdio_device_id __maybe_unused smsc_tbl[] = {
 	{ 0x0007c0d0, 0xfffffff0 },
 	{ 0x0007c0f0, 0xfffffff0 },
 	{ 0x0007c110, 0xfffffff0 },
+	{ 0x0007c130, 0xfffffff2 },
 	{ }
 };
 
-- 
2.25.1

