Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65D9561E9F5
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 04:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231321AbiKGD57 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 22:57:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231320AbiKGD5i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 22:57:38 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3AA6E095;
        Sun,  6 Nov 2022 19:57:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667793456; x=1699329456;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0wXSUs/stCX4n/UAX5pCiYlq8CvlIWxfpXl+9+NLOIw=;
  b=kICgCO03n87tPUCarKAXL3gCPAnZAsAhrFojHbsbtc5saIY+zXFXpQDj
   s/BLCG1Ias6GvbnAAMizb6o+l+E6tnqW0EZH445tCHyjUwjKe6Sz0Drcn
   3NrJECaCiM4y9VM1dl4AfC6OrDdEQvHWtXD/CxrnEhC/pJg7/GCE+M0UE
   RlXQeJz6Ib6r5XlYAba+J8zGXAcYtfGwura9Aq7tX1jJzz1mxmakrqeC6
   KEKqz5UE1GePFNCiy8yFHECzRC5PYnU8EYzYL8x68qmPA+t8z4+K6Phvb
   uNZG3kycv0vL1b+uhvXBZJOt866bRWQDzpvT5COfRaCpvAphKpfq4Ihgc
   g==;
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="187916840"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Nov 2022 20:57:36 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Sun, 6 Nov 2022 20:57:36 -0700
Received: from che-lt-i67786lx.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Sun, 6 Nov 2022 20:57:32 -0700
From:   Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
Subject: [PATCH net-next v2 4/5] net: dsa: microchip: ksz8563: Add number of port irq
Date:   Mon, 7 Nov 2022 14:59:21 +0530
Message-ID: <20221107092922.5926-5-rakesh.sankaranarayanan@microchip.com>
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

KSZ8563 have three port interrupts: PTP, PHY and ACL. Add
port_nirq as 3 for KSZ8563 inside ksz_chip_data.

Signed-off-by: Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
---
 drivers/net/dsa/microchip/ksz_common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index f7e414e747ed..8c8db315317d 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -1039,6 +1039,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.num_statics = 16,
 		.cpu_ports = 0x07,	/* can be configured as cpu port */
 		.port_cnt = 3,		/* total port count */
+		.port_nirqs = 3,
 		.ops = &ksz9477_dev_ops,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
-- 
2.34.1

