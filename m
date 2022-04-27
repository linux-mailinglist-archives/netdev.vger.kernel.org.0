Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30758511726
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 14:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233184AbiD0LzM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 07:55:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233168AbiD0LzL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 07:55:11 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0470247381
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 04:52:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1651060321; x=1682596321;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version;
  bh=q0uJsp3g00PvEz4LywAMXgw9qQ3+DueD9D2hsOip/cQ=;
  b=lBV9so8jUaiPx88dqyVOB7r8okZA7ADewtUIVLKqE4CmC1fPhJWI+NOT
   J3unE2VpwyRrcazd2IIf0q3AwuivSKYPpzRCN8VjZ6mcLhCmKbgE54Q/k
   gGtFZW8QeM+1J5EmjH6QgvGAK7TYwhtXzjWb9mrpXKzbHnvPM1CzmIWHW
   LweRBd6PnNYWeIMVvGBFh17+V2K/e3GGmfljz4nd2QBLPUycQHNOokW0V
   pnZZxctrldfyxiQpjl/1cSbvR5yaDcLqHbVaA2Pq346j+1rMacFsKf2Pf
   DLeInN7GW1pC1bBY7gDr/NCuZj3iXgVhNjXxTN0AM4WUE4XvAphnogUv8
   g==;
X-IronPort-AV: E=Sophos;i="5.90,292,1643698800"; 
   d="scan'208";a="161496754"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Apr 2022 04:51:58 -0700
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
Subject: [REVIEW REQUEST3 PATCH net-next 1/2] net: phy: microchip: update LAN88xx phy ID and phy ID mask.
Date:   Wed, 27 Apr 2022 04:51:41 -0700
Message-ID: <20220427115142.12642-2-yuiko.oshino@microchip.com>
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

update LAN88xx phy ID and phy ID mask because the existing code conflicts with the LAN8742 phy.

The current phy IDs on the available hardware.
        LAN8742 0x0007C130, 0x0007C131
        LAN88xx 0x0007C132

Signed-off-by: Yuiko Oshino <yuiko.oshino@microchip.com>
---
 drivers/net/phy/microchip.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/microchip.c b/drivers/net/phy/microchip.c
index 9f1f2b6c97d4..131caf659ed2 100644
--- a/drivers/net/phy/microchip.c
+++ b/drivers/net/phy/microchip.c
@@ -344,8 +344,8 @@ static int lan88xx_config_aneg(struct phy_device *phydev)
 
 static struct phy_driver microchip_phy_driver[] = {
 {
-	.phy_id		= 0x0007c130,
-	.phy_id_mask	= 0xfffffff0,
+	.phy_id		= 0x0007c132,
+	.phy_id_mask	= 0xfffffff2,
 	.name		= "Microchip LAN88xx",
 
 	/* PHY_GBIT_FEATURES */
@@ -369,7 +369,7 @@ static struct phy_driver microchip_phy_driver[] = {
 module_phy_driver(microchip_phy_driver);
 
 static struct mdio_device_id __maybe_unused microchip_tbl[] = {
-	{ 0x0007c130, 0xfffffff0 },
+	{ 0x0007c132, 0xfffffff2 },
 	{ }
 };
 
-- 
2.25.1

