Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD45368B72C
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 09:17:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbjBFIRB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 03:17:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjBFIRA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 03:17:00 -0500
Received: from unicom145.biz-email.net (unicom145.biz-email.net [210.51.26.145])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80AB1E3B8;
        Mon,  6 Feb 2023 00:16:56 -0800 (PST)
Received: from ([60.208.111.195])
        by unicom145.biz-email.net ((D)) with ASMTP (SSL) id CCX00149;
        Mon, 06 Feb 2023 16:16:49 +0800
Received: from localhost.localdomain (10.200.104.97) by
 jtjnmail201611.home.langchao.com (10.100.2.11) with Microsoft SMTP Server id
 15.1.2507.16; Mon, 6 Feb 2023 16:16:49 +0800
From:   Bo Liu <liubo03@inspur.com>
To:     <johannes@sipsolutions.net>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <simon.horman@corigine.com>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Bo Liu <liubo03@inspur.com>
Subject: [PATCH net-next v2] rfkill: Use sysfs_emit() to instead of sprintf()
Date:   Mon, 6 Feb 2023 03:16:41 -0500
Message-ID: <20230206081641.3193-1-liubo03@inspur.com>
X-Mailer: git-send-email 2.18.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.200.104.97]
tUid:   20232061616495256ba71b3295b314174ac298669a739
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Follow the advice of the Documentation/filesystems/sysfs.rst and show()
should only use sysfs_emit() or sysfs_emit_at() when formatting the
value to be returned to user space.

Signed-off-by: Bo Liu <liubo03@inspur.com>
---
 net/rfkill/core.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/rfkill/core.c b/net/rfkill/core.c
index b390ff245d5e..a103b2da4ed2 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -685,7 +685,7 @@ static ssize_t name_show(struct device *dev, struct device_attribute *attr,
 {
 	struct rfkill *rfkill = to_rfkill(dev);
 
-	return sprintf(buf, "%s\n", rfkill->name);
+	return sysfs_emit(buf, "%s\n", rfkill->name);
 }
 static DEVICE_ATTR_RO(name);
 
@@ -694,7 +694,7 @@ static ssize_t type_show(struct device *dev, struct device_attribute *attr,
 {
 	struct rfkill *rfkill = to_rfkill(dev);
 
-	return sprintf(buf, "%s\n", rfkill_types[rfkill->type]);
+	return sysfs_emit(buf, "%s\n", rfkill_types[rfkill->type]);
 }
 static DEVICE_ATTR_RO(type);
 
@@ -703,7 +703,7 @@ static ssize_t index_show(struct device *dev, struct device_attribute *attr,
 {
 	struct rfkill *rfkill = to_rfkill(dev);
 
-	return sprintf(buf, "%d\n", rfkill->idx);
+	return sysfs_emit(buf, "%d\n", rfkill->idx);
 }
 static DEVICE_ATTR_RO(index);
 
@@ -712,7 +712,7 @@ static ssize_t persistent_show(struct device *dev,
 {
 	struct rfkill *rfkill = to_rfkill(dev);
 
-	return sprintf(buf, "%d\n", rfkill->persistent);
+	return sysfs_emit(buf, "%d\n", rfkill->persistent);
 }
 static DEVICE_ATTR_RO(persistent);
 
@@ -721,7 +721,7 @@ static ssize_t hard_show(struct device *dev, struct device_attribute *attr,
 {
 	struct rfkill *rfkill = to_rfkill(dev);
 
-	return sprintf(buf, "%d\n", (rfkill->state & RFKILL_BLOCK_HW) ? 1 : 0 );
+	return sysfs_emit(buf, "%d\n", (rfkill->state & RFKILL_BLOCK_HW) ? 1 : 0);
 }
 static DEVICE_ATTR_RO(hard);
 
@@ -730,7 +730,7 @@ static ssize_t soft_show(struct device *dev, struct device_attribute *attr,
 {
 	struct rfkill *rfkill = to_rfkill(dev);
 
-	return sprintf(buf, "%d\n", (rfkill->state & RFKILL_BLOCK_SW) ? 1 : 0 );
+	return sysfs_emit(buf, "%d\n", (rfkill->state & RFKILL_BLOCK_SW) ? 1 : 0);
 }
 
 static ssize_t soft_store(struct device *dev, struct device_attribute *attr,
@@ -764,7 +764,7 @@ static ssize_t hard_block_reasons_show(struct device *dev,
 {
 	struct rfkill *rfkill = to_rfkill(dev);
 
-	return sprintf(buf, "0x%lx\n", rfkill->hard_block_reasons);
+	return sysfs_emit(buf, "0x%lx\n", rfkill->hard_block_reasons);
 }
 static DEVICE_ATTR_RO(hard_block_reasons);
 
@@ -783,7 +783,7 @@ static ssize_t state_show(struct device *dev, struct device_attribute *attr,
 {
 	struct rfkill *rfkill = to_rfkill(dev);
 
-	return sprintf(buf, "%d\n", user_state_from_blocked(rfkill->state));
+	return sysfs_emit(buf, "%d\n", user_state_from_blocked(rfkill->state));
 }
 
 static ssize_t state_store(struct device *dev, struct device_attribute *attr,
-- 
2.27.0

