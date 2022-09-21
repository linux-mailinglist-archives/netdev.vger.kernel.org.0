Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E669E5BFDB5
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 14:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbiIUMV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 08:21:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiIUMV1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 08:21:27 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D072E8A1FF;
        Wed, 21 Sep 2022 05:21:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1663762886; x=1695298886;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PL+1MuO5jCEO2qzF4mOgRnqzQQH8tiFfop0GK+FZI+E=;
  b=Ce+4op0IifPIvZglmP4mYyO/CRpj+dHWnXDlnOcOcC8Yh5fV0YyvzQA2
   1hgySU47bn0J+XnpcDyrAYC8ZfxmoTOTn1s1/6MLQwj7Av31f03ra8jG7
   jniwNfPVvmRvtjZiKjvBpu4C13+cOatyp5+996s8y3984HFjmmDjUrtyc
   veaYomySXPmZs+9F+ds69jkao65qg1K8nYMtKri6PRaPVBj5yDUHUkzWx
   WP2EJ1Kz01Nu77SkndrwOA6wwVxfGA/8KKpdrfVc+G4nYfRio6qURLcWS
   LyQDVMD5DhpyxgXTZCf/KdYfS4JCOvwti5WxkHa31K118ktl5XFhP1fvd
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,333,1654585200"; 
   d="scan'208";a="174903295"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Sep 2022 05:21:23 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 21 Sep 2022 05:21:21 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Wed, 21 Sep 2022 05:21:19 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2 1/4] net: lan966x: Add define for number of priority queues NUM_PRIO_QUEUES
Date:   Wed, 21 Sep 2022 14:25:35 +0200
Message-ID: <20220921122538.2079744-2-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220921122538.2079744-1-horatiu.vultur@microchip.com>
References: <20220921122538.2079744-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a define for the number of priority queues on lan966x. Because there
will be more checks for this, so instead of using hardcoded value all
over the place add a define for this.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_main.c | 3 ++-
 drivers/net/ethernet/microchip/lan966x/lan966x_main.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 371fa995e9e01..ee9b8ebba6d0a 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -738,7 +738,8 @@ static int lan966x_probe_port(struct lan966x *lan966x, u32 p,
 		return -EINVAL;
 
 	dev = devm_alloc_etherdev_mqs(lan966x->dev,
-				      sizeof(struct lan966x_port), 8, 1);
+				      sizeof(struct lan966x_port),
+				      NUM_PRIO_QUEUES, 1);
 	if (!dev)
 		return -ENOMEM;
 
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index 6135d311c4077..a5d5987852d46 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -36,6 +36,7 @@
 
 #define NUM_PHYS_PORTS			8
 #define CPU_PORT			8
+#define NUM_PRIO_QUEUES			8
 
 /* Reserved PGIDs */
 #define PGID_CPU			(PGID_AGGR - 6)
-- 
2.33.0

