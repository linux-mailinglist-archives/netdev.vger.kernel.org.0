Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9614F61E9F1
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 04:57:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbiKGD5i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 22:57:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231283AbiKGD51 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 22:57:27 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6096CC762;
        Sun,  6 Nov 2022 19:57:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667793446; x=1699329446;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XREYEvSdINiMHV6IL4y/XM301yNPd7W2TtRBmVU9SiM=;
  b=ZyceMPIzQhjIMPCwRh7K8FUlCu/G/oT5uoJLQIQ0niQ/uzem3cgeNYjM
   5r3P5PkpVZOpy4LT4avXmeH8Fnq2UllweAq1tLBofXW92vY6ZMZxrNqkE
   OUpN3gDYKpKIBQ3GhUKnWUDlJ8KESuWxB3lVOn8bWtYa3eq7Q5BXJxY+0
   ZzUmGfxd15LVb5+MtcoARejiTMj/DwKLsbrTrASfPU0O2voF0Jekr49QW
   /MHYZotOEl9b3abKe0KzrU+0Tk3Yx4bwI11bhQJzxIyhPyYYKVO6a0gKF
   d78JnhQ91kiiHfO9pewTIRNAO2iKVULCzvBjA9Yr2P/K19zn8cpMLO0OC
   g==;
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="187916795"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Nov 2022 20:57:25 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Sun, 6 Nov 2022 20:57:25 -0700
Received: from che-lt-i67786lx.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Sun, 6 Nov 2022 20:57:21 -0700
From:   Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
Subject: [PATCH net-next v2 2/5] net: dsa: microchip: add irq in i2c probe
Date:   Mon, 7 Nov 2022 14:59:19 +0530
Message-ID: <20221107092922.5926-3-rakesh.sankaranarayanan@microchip.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221107092922.5926-1-rakesh.sankaranarayanan@microchip.com>
References: <20221107092922.5926-1-rakesh.sankaranarayanan@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

add device irq in i2c probe function.

Signed-off-by: Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
---
 drivers/net/dsa/microchip/ksz9477_i2c.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz9477_i2c.c b/drivers/net/dsa/microchip/ksz9477_i2c.c
index 55146584e9b5..caa9acf1495c 100644
--- a/drivers/net/dsa/microchip/ksz9477_i2c.c
+++ b/drivers/net/dsa/microchip/ksz9477_i2c.c
@@ -41,6 +41,8 @@ static int ksz9477_i2c_probe(struct i2c_client *i2c,
 	if (i2c->dev.platform_data)
 		dev->pdata = i2c->dev.platform_data;
 
+	dev->irq = i2c->irq;
+
 	ret = ksz_switch_register(dev);
 
 	/* Main DSA driver may not be started yet. */
-- 
2.34.1

