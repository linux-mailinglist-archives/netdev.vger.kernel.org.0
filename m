Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 386884565B2
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 23:27:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232389AbhKRW3l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 17:29:41 -0500
Received: from mail.netfilter.org ([217.70.188.207]:58318 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232013AbhKRW3g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 17:29:36 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 8EFE464A76;
        Thu, 18 Nov 2021 23:24:27 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 09/11] netfilter: xt_IDLETIMER: replace snprintf in show functions with sysfs_emit
Date:   Thu, 18 Nov 2021 23:26:16 +0100
Message-Id: <20211118222618.433273-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211118222618.433273-1-pablo@netfilter.org>
References: <20211118222618.433273-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jing Yao <yao.jing2@zte.com.cn>

coccicheck complains about the use of snprintf() in sysfs show
functions:
WARNING use scnprintf or sprintf

Use sysfs_emit instead of scnprintf, snprintf or sprintf makes more
sense.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Jing Yao <yao.jing2@zte.com.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_IDLETIMER.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/xt_IDLETIMER.c b/net/netfilter/xt_IDLETIMER.c
index 2f7cf5ecebf4..0f8bb0bf558f 100644
--- a/net/netfilter/xt_IDLETIMER.c
+++ b/net/netfilter/xt_IDLETIMER.c
@@ -85,9 +85,9 @@ static ssize_t idletimer_tg_show(struct device *dev,
 	mutex_unlock(&list_mutex);
 
 	if (time_after(expires, jiffies) || ktimespec.tv_sec > 0)
-		return snprintf(buf, PAGE_SIZE, "%ld\n", time_diff);
+		return sysfs_emit(buf, "%ld\n", time_diff);
 
-	return snprintf(buf, PAGE_SIZE, "0\n");
+	return sysfs_emit(buf, "0\n");
 }
 
 static void idletimer_tg_work(struct work_struct *work)
-- 
2.30.2

