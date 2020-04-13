Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A55141A63D6
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 09:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729486AbgDMHyM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 03:54:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:37348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727480AbgDMHyM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 03:54:12 -0400
Received: from huawei.com (szxga04-in.huawei.com [45.249.212.190])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5286C008651;
        Mon, 13 Apr 2020 00:54:11 -0700 (PDT)
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 2976A9A447D55784BA21;
        Mon, 13 Apr 2020 15:54:09 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Mon, 13 Apr 2020
 15:53:58 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <kvalo@codeaurora.org>, <davem@davemloft.net>,
        <yanaijie@huawei.com>, <libertas-dev@lists.infradead.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Hulk Robot <hulkci@huawei.com>
Subject: [PATCH] libertas: make lbs_process_event() void
Date:   Mon, 13 Apr 2020 16:20:22 +0800
Message-ID: <20200413082022.22380-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warning:

drivers/net/wireless/marvell/libertas/cmdresp.c:225:5-8: Unneeded
variable: "ret". Return "0" on line 355

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/net/wireless/marvell/libertas/cmd.h     | 2 +-
 drivers/net/wireless/marvell/libertas/cmdresp.c | 5 +----
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/marvell/libertas/cmd.h b/drivers/net/wireless/marvell/libertas/cmd.h
index 80878561cb90..3c193074662b 100644
--- a/drivers/net/wireless/marvell/libertas/cmd.h
+++ b/drivers/net/wireless/marvell/libertas/cmd.h
@@ -76,7 +76,7 @@ void lbs_mac_event_disconnected(struct lbs_private *priv,
 
 /* Events */
 
-int lbs_process_event(struct lbs_private *priv, u32 event);
+void lbs_process_event(struct lbs_private *priv, u32 event);
 
 
 /* Actual commands */
diff --git a/drivers/net/wireless/marvell/libertas/cmdresp.c b/drivers/net/wireless/marvell/libertas/cmdresp.c
index b73d08381398..cb515c5584c1 100644
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
2.21.1

