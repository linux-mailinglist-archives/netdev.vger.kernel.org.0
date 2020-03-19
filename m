Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBD8518BD32
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 17:58:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728476AbgCSQ6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 12:58:14 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:59990 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728454AbgCSQ6N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 12:58:13 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 02JGw8RM033856;
        Thu, 19 Mar 2020 11:58:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1584637088;
        bh=NC3leWhnM/4NIc8QyBQa2tN7YReyUOftwpbx33+WJHM=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=pp4bH7qNUPjAQ2umBXokEMG1pbjO1Zopd0aY7O206uBofF0lOUzncDbCSzQdQg2I5
         sv56KoX05Mt0lTqhv6gxc5FRgoFOyXvy43BoXI91AKvnka2TVsAGEyz76SygIkml+6
         Kew6Lp3caZPH5RBOxBeWDwzD5HBa6E/YF4+JYqwQ=
Received: from DLEE115.ent.ti.com (dlee115.ent.ti.com [157.170.170.26])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 02JGw8Sd018372
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 19 Mar 2020 11:58:08 -0500
Received: from DLEE112.ent.ti.com (157.170.170.23) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Thu, 19
 Mar 2020 11:58:08 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Thu, 19 Mar 2020 11:58:07 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 02JGw7so111215;
        Thu, 19 Mar 2020 11:58:07 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Tony Lindgren <tony@atomide.com>
CC:     Sekhar Nori <nsekhar@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        netdev <netdev@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next v2 01/10] net: ethernet: ti: cpts: use dev_yy() api for logs
Date:   Thu, 19 Mar 2020 18:57:53 +0200
Message-ID: <20200319165802.30898-2-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200319165802.30898-1-grygorii.strashko@ti.com>
References: <20200319165802.30898-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use dev_yy() API instead of pr_yy() for log outputs.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/cpts.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpts.c b/drivers/net/ethernet/ti/cpts.c
index 729ce09dded9..f07b40504e5b 100644
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
+			dev_info(cpts->dev, "cpts: event pool empty\n");
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

