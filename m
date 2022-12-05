Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45AF2642201
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 04:53:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231417AbiLEDxI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 22:53:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231415AbiLEDxE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 22:53:04 -0500
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [63.216.63.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA7149580;
        Sun,  4 Dec 2022 19:53:03 -0800 (PST)
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mxhk.zte.com.cn (FangMail) with ESMTPS id 4NQV4s2BVyz8R03d;
        Mon,  5 Dec 2022 11:53:01 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.40.50])
        by mse-fl2.zte.com.cn with SMTP id 2B53qtAN034087;
        Mon, 5 Dec 2022 11:52:55 +0800 (+08)
        (envelope-from ye.xingchen@zte.com.cn)
Received: from mapi (xaxapp01[null])
        by mapi (Zmail) with MAPI id mid31;
        Mon, 5 Dec 2022 11:52:56 +0800 (CST)
Date:   Mon, 5 Dec 2022 11:52:56 +0800 (CST)
X-Zmail-TransId: 2af9638d6b186bfdc340
X-Mailer: Zmail v1.0
Message-ID: <202212051152565871940@zte.com.cn>
Mime-Version: 1.0
From:   <ye.xingchen@zte.com.cn>
To:     <wintera@linux.ibm.com>
Cc:     <wenjia@linux.ibm.com>, <hca@linux.ibm.com>, <gor@linux.ibm.com>,
        <agordeev@linux.ibm.com>, <borntraeger@linux.ibm.com>,
        <svens@linux.ibm.com>, <linux-s390@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIIG5ldC1uZXh0XSBzMzkwL3FldGg6IHVzZSBzeXNmc19lbWl0KCkgdG8gaW5zdGVhZCBvZiBzY25wcmludGYoKQ==?=
Content-Type: text/plain;
        charset="UTF-8"
X-MAIL: mse-fl2.zte.com.cn 2B53qtAN034087
X-Fangmail-Gw-Spam-Type: 0
X-FangMail-Miltered: at cgslv5.04-192.168.250.137.novalocal with ID 638D6B1D.000 by FangMail milter!
X-FangMail-Envelope: 1670212381/4NQV4s2BVyz8R03d/638D6B1D.000/10.5.228.133/[10.5.228.133]/mse-fl2.zte.com.cn/<ye.xingchen@zte.com.cn>
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 638D6B1D.000/4NQV4s2BVyz8R03d
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: ye xingchen <ye.xingchen@zte.com.cn>

Follow the advice of the Documentation/filesystems/sysfs.rst and show()
should only use sysfs_emit() or sysfs_emit_at() when formatting the
value to be returned to user space.

Signed-off-by: ye xingchen <ye.xingchen@zte.com.cn>
---
 drivers/s390/net/qeth_l3_sys.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/net/qeth_l3_sys.c b/drivers/s390/net/qeth_l3_sys.c
index 1082380b21f8..65eea667e469 100644
--- a/drivers/s390/net/qeth_l3_sys.c
+++ b/drivers/s390/net/qeth_l3_sys.c
@@ -395,7 +395,7 @@ static ssize_t qeth_l3_dev_ipato_add_show(char *buf, struct qeth_card *card,
 	}
 	mutex_unlock(&card->ip_lock);

-	return str_len ? str_len : scnprintf(buf, PAGE_SIZE, "\n");
+	return str_len ? str_len : sysfs_emit(buf, "\n");
 }

 static ssize_t qeth_l3_dev_ipato_add4_show(struct device *dev,
@@ -614,7 +614,7 @@ static ssize_t qeth_l3_dev_ip_add_show(struct device *dev, char *buf,
 	}
 	mutex_unlock(&card->ip_lock);

-	return str_len ? str_len : scnprintf(buf, PAGE_SIZE, "\n");
+	return str_len ? str_len : sysfs_emit(buf, "\n");
 }

 static ssize_t qeth_l3_dev_vipa_add4_show(struct device *dev,
-- 
2.25.1
