Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1863D687E2F
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 14:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232596AbjBBNAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 08:00:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232591AbjBBM7t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 07:59:49 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37BC68C405;
        Thu,  2 Feb 2023 04:59:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1675342762; x=1706878762;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ouumZ6vbUvawBmcL9NxoUu7tYtFUqagkN0ir03uG0JE=;
  b=jblrvlrd04/sJWl2s+iqEKMS0szsyJcqY2/Jv55Ru1z9VoM/2k7kLdtd
   ENq7di3NJLKt3AuSZg8QSM2RzgtoMSbNLf5CrDdJIgtCIhxXyLW2ouXAm
   wEcU3yG1SikMA8MFXa6aT22GVF78fAcNmszb1TliXdRFzQwD/EjcrUUhI
   UJ+ChakIXLnUz0XIh5Vd925PvXIVAl94CQbKN+zZ6/CItynADBAwdIl0C
   jpYUD6uZttHPFLtSlK94NSDkNTY0DycABzxK8cSlVJDFjVZ4Lk6H5EusR
   k+7hruLPc2gpg11IlAQ9lATIh/Ne3SYihktinr9CgPRHjSOBwnm1k9Pif
   g==;
X-IronPort-AV: E=Sophos;i="5.97,267,1669100400"; 
   d="scan'208";a="135252070"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Feb 2023 05:59:21 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 2 Feb 2023 05:59:21 -0700
Received: from che-lt-i67786lx.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Thu, 2 Feb 2023 05:59:16 -0700
From:   Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <olteanv@gmail.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <woojung.huh@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <linux@armlinux.org.uk>
Subject: [RFC PATCH net-next 10/11] net: dsa: microchip: lan937x: update vlan untag membership
Date:   Thu, 2 Feb 2023 18:29:29 +0530
Message-ID: <20230202125930.271740-11-rakesh.sankaranarayanan@microchip.com>
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

Exclude cascaded port from vlan untag membership table since it will be
the host port for second switch. Here setting 1 means, port will be
capable of receiving tagged frames and 0 means, port can not receive
tagged frames.

Signed-off-by: Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
---
 drivers/net/dsa/microchip/ksz9477.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index bf13d47c26cf..4c12131098b1 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -399,7 +399,7 @@ int ksz9477_port_vlan_add(struct ksz_device *dev, int port,
 		vlan_table[1] |= BIT(port);
 	else
 		vlan_table[1] &= ~BIT(port);
-	vlan_table[1] &= ~(BIT(dev->cpu_port));
+	vlan_table[1] &= ~(BIT(dev->cpu_port) | BIT(dev->dsa_port));
 
 	vlan_table[2] |= BIT(port) | BIT(dev->cpu_port);
 
-- 
2.34.1

