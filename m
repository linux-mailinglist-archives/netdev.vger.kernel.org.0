Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B693615B59
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 05:15:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbiKBEPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 00:15:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbiKBEPT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 00:15:19 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D577DF38;
        Tue,  1 Nov 2022 21:14:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667362488; x=1698898488;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZjHjwtYeimh+uqynqbTRCzpKyff/1Kid7o8ddH+6vhw=;
  b=oTrBdqhm18fUf7r9LtpA3Xw+JvpWMlSQVnvL7LUx+aVYhoMOr2bxWi50
   1xo8pBaYooN+NSK6DFHuNVXid8M7+BU/bWnXO8i1vIW5zD4k9SpaJXnET
   785slLPsPlktL2y4rgIqqyO6ChyhL4B/0UaJMa7RHWgjwNUj78Cj79qxr
   LiFU7IXJN4SwTRVfK8AQaq3W+WT+Y/vNujIAwJk9tODoX4lj+rVzTWhQN
   q3A+FM+mekrENDjWP8HEiiLEhjReTCFuhyBddXQocnYiinA0icIXkYoFf
   dGoK7JI24plGPyLlTZK3NPDGt1Wu2z6a3+dl7UsWsaJXrY4Mj6TAKx6V3
   Q==;
X-IronPort-AV: E=Sophos;i="5.95,232,1661842800"; 
   d="scan'208";a="187301801"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Nov 2022 21:14:47 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 1 Nov 2022 21:14:47 -0700
Received: from che-lt-i67786lx.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 1 Nov 2022 21:14:43 -0700
From:   Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
Subject: [PATCH net-next 5/6] net: dsa: microchip: ksz8563: Add number of port irq
Date:   Wed, 2 Nov 2022 09:40:57 +0530
Message-ID: <20221102041058.128779-6-rakesh.sankaranarayanan@microchip.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221102041058.128779-1-rakesh.sankaranarayanan@microchip.com>
References: <20221102041058.128779-1-rakesh.sankaranarayanan@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
index 7620855ba995..b2a0c0c32d0a 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -2789,6 +2789,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.num_statics = 16,
 		.cpu_ports = 0x07,	/* can be configured as cpu port */
 		.port_cnt = 3,		/* total port count */
+		.port_nirqs = 3,
 		.ops = &ksz9477_dev_ops,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
-- 
2.34.1

