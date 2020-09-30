Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE5C27DD96
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 03:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729404AbgI3BHy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 21:07:54 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14783 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729126AbgI3BHx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 21:07:53 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 26718D6824CFD39A4F4A;
        Wed, 30 Sep 2020 09:07:51 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.487.0; Wed, 30 Sep 2020
 09:07:41 +0800
From:   Ye Bin <yebin10@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Ye Bin <yebin10@huawei.com>, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH 1/2] pktgen: Fix inconsistent of format with argument type in pktgen.c
Date:   Wed, 30 Sep 2020 09:08:37 +0800
Message-ID: <20200930010838.1266872-2-yebin10@huawei.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200930010838.1266872-1-yebin10@huawei.com>
References: <20200930010838.1266872-1-yebin10@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix follow warnings:
[net/core/pktgen.c:925]: (warning) %u in format string (no. 1)
	requires 'unsigned int' but the argument type is 'signed int'.
[net/core/pktgen.c:942]: (warning) %u in format string (no. 1)
	requires 'unsigned int' but the argument type is 'signed int'.
[net/core/pktgen.c:962]: (warning) %u in format string (no. 1)
	requires 'unsigned int' but the argument type is 'signed int'.
[net/core/pktgen.c:984]: (warning) %u in format string (no. 1)
	requires 'unsigned int' but the argument type is 'signed int'.
[net/core/pktgen.c:1149]: (warning) %d in format string (no. 1)
	requires 'int' but the argument type is 'unsigned int'.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 net/core/pktgen.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index 44fdbb9c6e53..105978604ffd 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -922,7 +922,7 @@ static ssize_t pktgen_if_write(struct file *file,
 			pkt_dev->min_pkt_size = value;
 			pkt_dev->cur_pkt_size = value;
 		}
-		sprintf(pg_result, "OK: min_pkt_size=%u",
+		sprintf(pg_result, "OK: min_pkt_size=%d",
 			pkt_dev->min_pkt_size);
 		return count;
 	}
@@ -939,7 +939,7 @@ static ssize_t pktgen_if_write(struct file *file,
 			pkt_dev->max_pkt_size = value;
 			pkt_dev->cur_pkt_size = value;
 		}
-		sprintf(pg_result, "OK: max_pkt_size=%u",
+		sprintf(pg_result, "OK: max_pkt_size=%d",
 			pkt_dev->max_pkt_size);
 		return count;
 	}
@@ -959,7 +959,7 @@ static ssize_t pktgen_if_write(struct file *file,
 			pkt_dev->max_pkt_size = value;
 			pkt_dev->cur_pkt_size = value;
 		}
-		sprintf(pg_result, "OK: pkt_size=%u", pkt_dev->min_pkt_size);
+		sprintf(pg_result, "OK: pkt_size=%d", pkt_dev->min_pkt_size);
 		return count;
 	}
 
@@ -981,7 +981,7 @@ static ssize_t pktgen_if_write(struct file *file,
 
 		i += len;
 		pkt_dev->nfrags = value;
-		sprintf(pg_result, "OK: frags=%u", pkt_dev->nfrags);
+		sprintf(pg_result, "OK: frags=%d", pkt_dev->nfrags);
 		return count;
 	}
 	if (!strcmp(name, "delay")) {
@@ -1146,7 +1146,7 @@ static ssize_t pktgen_if_write(struct file *file,
 		     (!(pkt_dev->odev->priv_flags & IFF_TX_SKB_SHARING)))))
 			return -ENOTSUPP;
 		pkt_dev->burst = value < 1 ? 1 : value;
-		sprintf(pg_result, "OK: burst=%d", pkt_dev->burst);
+		sprintf(pg_result, "OK: burst=%u", pkt_dev->burst);
 		return count;
 	}
 	if (!strcmp(name, "node")) {
-- 
2.25.4

