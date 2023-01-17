Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B35ED673502
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 11:02:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbjASKCp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 05:02:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbjASKCb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 05:02:31 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2477D6CCC7;
        Thu, 19 Jan 2023 02:02:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1674122541; x=1705658541;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BTaC+eTDiqpxNaBodV9SnvUdwz1kIcjygsdvDJtO7y0=;
  b=ZgAS2VtMnrx4PBwaITSkU79qF32+HWwysjWO/UIJLN8QwYLb8WkTI3G0
   smBKQ8NXvyoaBTW9rfSLOeOQGYohpeiVgZrKjLAornZ2pXsUxuwL/9k9L
   VC54VXWYO0RJ4VmymSKqL71Uihx/nfOp3OFh+kkqstROp5eRP9NfTNkMh
   6fvj/6R/WD7MQMNY/aY9rHq6MebrANTUCopTL7yAq4fZoj9Cb5PlDWnXn
   V3DA0fS+A78jyjhOedmXZazSTT052yecXIpBmfnmSBSgeW8XhXc+oz/ka
   6uv8Vdlu+EMoKkNeHoC7PxP4UtrJsr+4mnroIBhre+HVB4XXKAEVq4pIj
   w==;
X-IronPort-AV: E=Sophos;i="5.97,228,1669100400"; 
   d="scan'208";a="197274452"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Jan 2023 03:02:20 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 19 Jan 2023 03:02:20 -0700
Received: from che-dk-unglab44lx.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Thu, 19 Jan 2023 03:02:17 -0700
From:   Pavithra Sathyanarayanan <Pavithra.Sathyanarayanan@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <bryan.whitehead@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
Subject: [PATCH net-next 1/3] net: lan743x: remove unwanted interface select settings
Date:   Tue, 17 Jan 2023 19:46:12 +0530
Message-ID: <20230117141614.4411-2-Pavithra.Sathyanarayanan@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230117141614.4411-1-Pavithra.Sathyanarayanan@microchip.com>
References: <20230117141614.4411-1-Pavithra.Sathyanarayanan@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DATE_IN_PAST_24_48,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the MII/RGMII Selection settings in driver as it is preset
by the EEPROM and has the required configurations before the driver
loads for LAN743x.

Signed-off-by: Pavithra Sathyanarayanan <Pavithra.Sathyanarayanan@microchip.com>
---
 drivers/net/ethernet/microchip/lan743x_main.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index e205edf477de..c4d16f4654b5 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -1418,14 +1418,6 @@ static void lan743x_phy_link_status_change(struct net_device *netdev)
 
 		data = lan743x_csr_read(adapter, MAC_CR);
 
-		/* set interface mode */
-		if (phy_interface_is_rgmii(phydev))
-			/* RGMII */
-			data &= ~MAC_CR_MII_EN_;
-		else
-			/* GMII */
-			data |= MAC_CR_MII_EN_;
-
 		/* set duplex mode */
 		if (phydev->duplex)
 			data |= MAC_CR_DPX_;
-- 
2.25.1

