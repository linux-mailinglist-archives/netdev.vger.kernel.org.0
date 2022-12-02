Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71F74640264
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 09:42:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232100AbiLBImd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 03:42:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231730AbiLBImc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 03:42:32 -0500
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91550100;
        Fri,  2 Dec 2022 00:42:29 -0800 (PST)
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mxct.zte.com.cn (FangMail) with ESMTPS id 4NNmfD01Zpz501Qh;
        Fri,  2 Dec 2022 16:42:28 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.40.50])
        by mse-fl2.zte.com.cn with SMTP id 2B28gCQX002973;
        Fri, 2 Dec 2022 16:42:12 +0800 (+08)
        (envelope-from ye.xingchen@zte.com.cn)
Received: from mapi (xaxapp01[null])
        by mapi (Zmail) with MAPI id mid31;
        Fri, 2 Dec 2022 16:42:14 +0800 (CST)
Date:   Fri, 2 Dec 2022 16:42:14 +0800 (CST)
X-Zmail-TransId: 2af96389ba667b8f7013
X-Mailer: Zmail v1.0
Message-ID: <202212021642142044742@zte.com.cn>
Mime-Version: 1.0
From:   <ye.xingchen@zte.com.cn>
To:     <davem@davemloft.net>
Cc:     <elder@kernel.org>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIXSBuZXQ6IGlwYTogdXNlIHN5c2ZzX2VtaXQoKSB0byBpbnN0ZWFkIG9mIHNjbnByaW50Zigp?=
Content-Type: text/plain;
        charset="UTF-8"
X-MAIL: mse-fl2.zte.com.cn 2B28gCQX002973
X-Fangmail-Gw-Spam-Type: 0
X-FangMail-Miltered: at cgslv5.04-192.168.251.13.novalocal with ID 6389BA73.002 by FangMail milter!
X-FangMail-Envelope: 1669970548/4NNmfD01Zpz501Qh/6389BA73.002/10.5.228.133/[10.5.228.133]/mse-fl2.zte.com.cn/<ye.xingchen@zte.com.cn>
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6389BA73.002/4NNmfD01Zpz501Qh
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
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
 drivers/net/ipa/ipa_sysfs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ipa/ipa_sysfs.c b/drivers/net/ipa/ipa_sysfs.c
index 5cbc15a971f9..14bd2f903045 100644
--- a/drivers/net/ipa/ipa_sysfs.c
+++ b/drivers/net/ipa/ipa_sysfs.c
@@ -46,7 +46,7 @@ version_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct ipa *ipa = dev_get_drvdata(dev);

-	return scnprintf(buf, PAGE_SIZE, "%s\n", ipa_version_string(ipa));
+	return sysfs_emit(buf, "%s\n", ipa_version_string(ipa));
 }

 static DEVICE_ATTR_RO(version);
@@ -70,7 +70,7 @@ static ssize_t rx_offload_show(struct device *dev,
 {
 	struct ipa *ipa = dev_get_drvdata(dev);

-	return scnprintf(buf, PAGE_SIZE, "%s\n", ipa_offload_string(ipa));
+	return sysfs_emit(buf, "%s\n", ipa_offload_string(ipa));
 }

 static DEVICE_ATTR_RO(rx_offload);
@@ -80,7 +80,7 @@ static ssize_t tx_offload_show(struct device *dev,
 {
 	struct ipa *ipa = dev_get_drvdata(dev);

-	return scnprintf(buf, PAGE_SIZE, "%s\n", ipa_offload_string(ipa));
+	return sysfs_emit(buf, "%s\n", ipa_offload_string(ipa));
 }

 static DEVICE_ATTR_RO(tx_offload);
-- 
2.25.1
