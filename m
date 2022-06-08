Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 310565429D8
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 10:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232301AbiFHItG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 04:49:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231268AbiFHIss (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 04:48:48 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3653317529;
        Wed,  8 Jun 2022 01:06:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1654675579; x=1686211579;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=nPz0elsgpG0Rgm6MSWEv4NaWObr+3SGeXQnA+z0CNRk=;
  b=tYD7emkPrwgCGN15HeuVaIrPT2H27ojDfBFruqhpv8CgXZs7UHCT2Mic
   GzH4E3CiWgQkpIUiU8GB0yS+x1XCIiDVvrtCBA9Qh6gGLYZhl8JJ5b/QG
   1nuxuzZq/kXk0qFBbCKe9NsWZCiA95gqwf4ru4RK0ZDHxGy8poJhOf5oV
   bjYZdUdz7cg6e0MP3iZylBkDSrjQpI2yUN+ifvcr/meVqJyM3ioKxvkhw
   gix6eifC+QX/258Nt9F4/XOgr9aZojDIX3xZpVnu/biD2imxRE0UNgS2F
   9HMuciQeBpxtw8QcH5SfkXXVOLzsbI9A5f6llcNyQcHjMicge+Lx9gtuv
   w==;
X-IronPort-AV: E=Sophos;i="5.91,285,1647327600"; 
   d="scan'208";a="167231899"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Jun 2022 01:05:57 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 8 Jun 2022 01:05:56 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Wed, 8 Jun 2022 01:05:53 -0700
From:   Claudiu Beznea <claudiu.beznea@microchip.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [RESEND][PATCH net-next] net: macb: change return type for gem_ptp_set_one_step_sync()
Date:   Wed, 8 Jun 2022 11:08:18 +0300
Message-ID: <20220608080818.1495044-1-claudiu.beznea@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

