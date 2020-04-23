Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 250B21B5D80
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 16:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728625AbgDWOVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 10:21:10 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:59924 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726910AbgDWOVJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 10:21:09 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 03NEL3vi077806;
        Thu, 23 Apr 2020 09:21:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1587651663;
        bh=L2BiDtgp0YI3iDwwCJIkGSJCT04BlhuuDzMQKbN7fAA=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=hbEETpGw+5WC3Z+W5JcK9cJz5+gnqB7IoD7sf+jsEV5EHy8BVJKtLIA2P2gH4PCsN
         G5KJi8ZZqPgZIjmKymfbN+vnCDEqCbaAqdF7jSJx1HgVAeXe5yzNcyWVLnNREhQQSr
         RiyHxWlWd8ZJpx31r964P88lzCsHpgZwQ2t48W9Q=
Received: from DFLE109.ent.ti.com (dfle109.ent.ti.com [10.64.6.30])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 03NEL3VS122554
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 23 Apr 2020 09:21:03 -0500
Received: from DFLE100.ent.ti.com (10.64.6.21) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 23
 Apr 2020 09:21:03 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE100.ent.ti.com
 (10.64.6.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 23 Apr 2020 09:21:03 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 03NEL2k7116790;
        Thu, 23 Apr 2020 09:21:02 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     Richard Cochran <richardcochran@gmail.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        <linux-kernel@vger.kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        <linux-omap@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next v5 01/10] net: ethernet: ti: cpts: use dev_yy() api for logs
Date:   Thu, 23 Apr 2020 17:20:13 +0300
Message-ID: <20200423142022.10538-2-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200423142022.10538-1-grygorii.strashko@ti.com>
References: <20200423142022.10538-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use dev_yy() API instead of pr_yy() for log outputs.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
---
 drivers/net/ethernet/ti/cpts.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpts.c b/drivers/net/ethernet/ti/cpts.c
index 729ce09dded9..445f445185df 100644
--- a/drivers/net/ethernet/ti/cpts.c
+++ b/drivers/net/ethernet/ti/cpts.c
@@ -71,7 +71,7 @@ static int cpts_purge_events(struct cpts *cpts)
 	}
 
 	if (removed)
-		pr_debug("cpts: event pool cleaned up %d\n", removed);
+		dev_dbg(cpts->dev, "cpts: event pool cleaned up %d\n", removed);
 	return removed ? 0 : -1;
 }
 
@@ -150,7 +150,7 @@ static int cpts_fifo_read(struct cpts *cpts, int match)
 			break;
 
 		if (list_empty(&cpts->pool) && cpts_purge_events(cpts)) {
-			pr_err("cpts: event pool empty\n");
+			dev_warn(cpts->dev, "cpts: event pool empty\n");
 			return -1;
 		}
 
@@ -178,7 +178,7 @@ static int cpts_fifo_read(struct cpts *cpts, int match)
 		case CPTS_EV_HW:
 			break;
 		default:
-			pr_err("cpts: unknown event type\n");
+			dev_err(cpts->dev, "cpts: unknown event type\n");
 			break;
 		}
 		if (type == match)
@@ -196,7 +196,7 @@ static u64 cpts_systim_read(const struct cyclecounter *cc)
 
 	cpts_write32(cpts, TS_PUSH, ts_push);
 	if (cpts_fifo_read(cpts, CPTS_EV_PUSH))
-		pr_err("cpts: unable to obtain a time stamp\n");
+		dev_err(cpts->dev, "cpts: unable to obtain a time stamp\n");
 
 	list_for_each_safe(this, next, &cpts->events) {
 		event = list_entry(this, struct cpts_event, list);
@@ -307,8 +307,8 @@ static long cpts_overflow_check(struct ptp_clock_info *ptp)
 	}
 	spin_unlock_irqrestore(&cpts->lock, flags);
 
-	pr_debug("cpts overflow check at %lld.%09ld\n",
-		 (long long)ts.tv_sec, ts.tv_nsec);
+	dev_dbg(cpts->dev, "cpts overflow check at %lld.%09ld\n",
+		(long long)ts.tv_sec, ts.tv_nsec);
 	return (long)delay;
 }
 
-- 
2.17.1

