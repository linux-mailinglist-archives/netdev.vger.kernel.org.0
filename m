Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 089C7298580
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 03:10:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1421354AbgJZCKs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Oct 2020 22:10:48 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2564 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1421350AbgJZCKr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Oct 2020 22:10:47 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CKJGL6hvYzhbtq;
        Mon, 26 Oct 2020 10:10:50 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.487.0; Mon, 26 Oct 2020
 10:10:41 +0800
From:   Zhang Qilong <zhangqilong3@huawei.com>
To:     <joe@perches.com>, <vvs@virtuozzo.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <lirongqing@baidu.com>, <roopa@cumulusnetworks.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v2 -next] neigh: Adjustment calculation method of neighbour path symbols
Date:   Mon, 26 Oct 2020 10:21:26 +0800
Message-ID: <20201026022126.117741-1-zhangqilong3@huawei.com>
X-Mailer: git-send-email 2.26.0.106.g9fadedd
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using size of "net//neigh/" is not clear, the use
of stitching("net/" + /neigh") should be clearer.

Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
---
 net/core/neighbour.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 8e39e28b0a8d..0474e73c4f9f 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -3623,7 +3623,14 @@ int neigh_sysctl_register(struct net_device *dev, struct neigh_parms *p,
 	int i;
 	struct neigh_sysctl_table *t;
 	const char *dev_name_source;
-	char neigh_path[ sizeof("net//neigh/") + IFNAMSIZ + IFNAMSIZ ];
+
+	/*
+	 * The path pattern is as follows
+	 * "net/%s/neigh/%s", minusing one
+	 * is for unnecessary terminators.
+	 */
+	char neigh_path[sizeof("net/") - 1 + IFNAMSIZ +
+			sizeof("/neigh/") + IFNAMSIZ];
 	char *p_name;
 
 	t = kmemdup(&neigh_sysctl_template, sizeof(*t), GFP_KERNEL);
-- 
2.17.1

