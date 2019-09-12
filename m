Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B4F3B12EE
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 18:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730086AbfILQos (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 12:44:48 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:53340 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725972AbfILQor (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Sep 2019 12:44:47 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 542F2CD0AB34221E6235;
        Fri, 13 Sep 2019 00:44:45 +0800 (CST)
Received: from linux-ibm.site (10.175.102.37) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.439.0; Fri, 13 Sep 2019 00:44:35 +0800
From:   zhong jiang <zhongjiang@huawei.com>
To:     <kvalo@codeaurora.org>
CC:     <davem@davemloft.net>, <zhongjiang@huawei.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] libertas: Remove unneeded variable and make function to be void
Date:   Fri, 13 Sep 2019 00:41:32 +0800
Message-ID: <1568306492-42998-4-git-send-email-zhongjiang@huawei.com>
X-Mailer: git-send-email 1.7.12.4
In-Reply-To: <1568306492-42998-1-git-send-email-zhongjiang@huawei.com>
References: <1568306492-42998-1-git-send-email-zhongjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.102.37]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

lbs_process_event  do not need return value to cope with different
cases. And change functon return type to void.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 drivers/net/wireless/marvell/libertas/cmd.h     | 2 +-
 drivers/net/wireless/marvell/libertas/cmdresp.c | 5 +----
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/marvell/libertas/cmd.h b/drivers/net/wireless/marvell/libertas/cmd.h
index 8087856..3c19307 100644
--- a/drivers/net/wireless/marvell/libertas/cmd.h
+++ b/drivers/net/wireless/marvell/libertas/cmd.h
@@ -76,7 +76,7 @@ void lbs_mac_event_disconnected(struct lbs_private *priv,
 
 /* Events */
 
-int lbs_process_event(struct lbs_private *priv, u32 event);
+void lbs_process_event(struct lbs_private *priv, u32 event);
 
 
 /* Actual commands */
diff --git a/drivers/net/wireless/marvell/libertas/cmdresp.c b/drivers/net/wireless/marvell/libertas/cmdresp.c
index b73d083..cb515c5 100644
--- a/drivers/net/wireless/marvell/libertas/cmdresp.c
+++ b/drivers/net/wireless/marvell/libertas/cmdresp.c
@@ -220,9 +220,8 @@ int lbs_process_command_response(struct lbs_private *priv, u8 *data, u32 len)
 	return ret;
 }
 
-int lbs_process_event(struct lbs_private *priv, u32 event)
+void lbs_process_event(struct lbs_private *priv, u32 event)
 {
-	int ret = 0;
 	struct cmd_header cmd;
 
 	switch (event) {
@@ -351,6 +350,4 @@ int lbs_process_event(struct lbs_private *priv, u32 event)
 		netdev_alert(priv->dev, "EVENT: unknown event id %d\n", event);
 		break;
 	}
-
-	return ret;
 }
-- 
1.7.12.4

