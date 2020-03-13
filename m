Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1636E1851CD
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 23:49:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727552AbgCMWtg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 18:49:36 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:53582 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbgCMWtg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 18:49:36 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 02DMnV0x030033;
        Fri, 13 Mar 2020 17:49:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1584139771;
        bh=NC3leWhnM/4NIc8QyBQa2tN7YReyUOftwpbx33+WJHM=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=TuL6aplDWwv+Y83xVkOpZwJl0IccEQhCGpIzS2thT+a95IHN9AhlexjyHExfIAvx2
         J42cWNtfxsDPt2biJx/4g6Vk6YS+EyrnOkQrjr8b2q137FZajxed7wC8Dlk2VlpWBj
         lYzVC4L++KXqFvc6wbVrcUmHhgB/hYrtZ9LaiJTA=
Received: from DLEE109.ent.ti.com (dlee109.ent.ti.com [157.170.170.41])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 02DMnVL7127550
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 13 Mar 2020 17:49:31 -0500
Received: from DLEE107.ent.ti.com (157.170.170.37) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Fri, 13
 Mar 2020 17:49:30 -0500
Received: from localhost.localdomain (10.64.41.19) by DLEE107.ent.ti.com
 (157.170.170.37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Fri, 13 Mar 2020 17:49:30 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by localhost.localdomain (8.15.2/8.15.2) with ESMTP id 02DMnTPG061620;
        Fri, 13 Mar 2020 17:49:30 -0500
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
Subject: [PATCH net-next 01/11] net: ethernet: ti: cpts: use dev_yy() api for logs
Date:   Sat, 14 Mar 2020 00:49:04 +0200
Message-ID: <20200313224914.5997-2-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200313224914.5997-1-grygorii.strashko@ti.com>
References: <20200313224914.5997-1-grygorii.strashko@ti.com>
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

