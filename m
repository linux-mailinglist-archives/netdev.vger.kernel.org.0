Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 112AA532A4A
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 14:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237282AbiEXMSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 08:18:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234334AbiEXMSv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 08:18:51 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81AA09347F;
        Tue, 24 May 2022 05:18:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1653394730; x=1684930730;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=nPz0elsgpG0Rgm6MSWEv4NaWObr+3SGeXQnA+z0CNRk=;
  b=PPdftN4IsdVF+rKvI1OjlYp9Py686gtgd98YkqaPhyKUGvMBzmu7G6QN
   r7zqmEsZemKNxPO8NnDPxJttfL8HPcjV4MsbhnFV4BweEwEX9uoROYsbT
   yvgal1ec4j20+nI9DGk5ioDM7yNAXbdGxZTjmg5VewCVGWHqgHc/M11rZ
   oU9kcS2MCOFXyvWsCw7jRatzmEqmQBPCbAtw0BKRubWjV9CicWfNq37q+
   XtYZdLVJ1hh4s4fkIhjmbDMA/SAjPmmGTkr3nuFTR/AJcX/j5JuC6tXeM
   5w+P43xmCk0pRKPij7yKQuPjP5FqjhapEFc7U3cFDp0p5RXT/Uda7gQn+
   Q==;
X-IronPort-AV: E=Sophos;i="5.91,248,1647327600"; 
   d="scan'208";a="165083481"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 May 2022 05:18:49 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 24 May 2022 05:18:48 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Tue, 24 May 2022 05:18:45 -0700
From:   Claudiu Beznea <claudiu.beznea@microchip.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH net-next] net: macb: change return type for gem_ptp_set_one_step_sync()
Date:   Tue, 24 May 2022 15:19:51 +0300
Message-ID: <20220524121951.1036697-1-claudiu.beznea@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

gem_ptp_set_one_step_sync() always returns zero thus change its return
type to void.

Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
---
 drivers/net/ethernet/cadence/macb_ptp.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_ptp.c b/drivers/net/ethernet/cadence/macb_ptp.c
index 9559c16078f9..e6cb20aaa76a 100644
--- a/drivers/net/ethernet/cadence/macb_ptp.c
+++ b/drivers/net/ethernet/cadence/macb_ptp.c
@@ -434,7 +434,7 @@ int gem_get_hwtst(struct net_device *dev, struct ifreq *rq)
 		return 0;
 }
 
-static int gem_ptp_set_one_step_sync(struct macb *bp, u8 enable)
+static void gem_ptp_set_one_step_sync(struct macb *bp, u8 enable)
 {
 	u32 reg_val;
 
@@ -444,8 +444,6 @@ static int gem_ptp_set_one_step_sync(struct macb *bp, u8 enable)
 		macb_writel(bp, NCR, reg_val | MACB_BIT(OSSMODE));
 	else
 		macb_writel(bp, NCR, reg_val & ~MACB_BIT(OSSMODE));
-
-	return 0;
 }
 
 int gem_set_hwtst(struct net_device *dev, struct ifreq *ifr, int cmd)
@@ -468,8 +466,7 @@ int gem_set_hwtst(struct net_device *dev, struct ifreq *ifr, int cmd)
 	case HWTSTAMP_TX_OFF:
 		break;
 	case HWTSTAMP_TX_ONESTEP_SYNC:
-		if (gem_ptp_set_one_step_sync(bp, 1) != 0)
-			return -ERANGE;
+		gem_ptp_set_one_step_sync(bp, 1);
 		tx_bd_control = TSTAMP_ALL_FRAMES;
 		break;
 	case HWTSTAMP_TX_ON:
-- 
2.34.1

