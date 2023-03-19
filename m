Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 216CD6BFF5D
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 06:10:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbjCSFJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 01:09:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbjCSFJo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 01:09:44 -0400
Received: from m12.mail.163.com (m12.mail.163.com [220.181.12.214])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CC38A12BD3;
        Sat, 18 Mar 2023 22:09:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=EV8Co
        y6UpeuOXMoDGXrNwPbs5KH0GOFsMnyQWDyA7a0=; b=CtY/mmYq1ri7zfUThaGP3
        p/JicKlzuTo1dDD3O7lrqyO+ld0b+OQ+fpYdzoRaQqGBCbTF+kJMxtq29q+mb/3c
        WKsKSeN6vbN2k9xcFn9wUbr+BFXdx1L4OiefvKiE4/9uljOqSaIlQwHKRmubbz7L
        SH3VRSLzoP0hYVzojUX4KI=
Received: from lizhe.. (unknown [120.245.132.192])
        by zwqz-smtp-mta-g1-1 (Coremail) with SMTP id _____wC3bLHZmBZkflf2AQ--.3614S4;
        Sun, 19 Mar 2023 13:09:00 +0800 (CST)
From:   Lizhe <sensor1010@163.com>
To:     wintera@linux.ibm.com, wenjia@linux.ibm.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lizhe <sensor1010@163.com>
Subject: [PATCH v1] net/iucv: Remove redundant driver match function
Date:   Sun, 19 Mar 2023 13:08:40 +0800
Message-Id: <20230319050840.377727-1-sensor1010@163.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _____wC3bLHZmBZkflf2AQ--.3614S4
X-Coremail-Antispam: 1Uf129KBjvdXoW7Jr1kAr4DGr47Kr1kXrW5ZFb_yoW3ZFXE93
        4xZFn7Wrn2k3Z7Jan7Z395ArnFka1kGF4rWw4Sqasayw18W348Xw4vqrsxta4YgrWrCFZ8
        C3srJr4UA347WjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRKSdyUUUUUU==
X-Originating-IP: [120.245.132.192]
X-CM-SenderInfo: 5vhq20jurqiii6rwjhhfrp/1tbiKBA3q17WMXDXKAAAsS
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If there is no driver match function, the driver core assumes that each
candidate pair (driver, device) matches, see driver_match_device().

Drop the bus's match function that always returned 1 and so
implements the same behaviour as when there is no match function

Signed-off-by: Lizhe <sensor1010@163.com>
---
 net/iucv/iucv.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/net/iucv/iucv.c b/net/iucv/iucv.c
index fc3fddeb6f36..7dd15dead88e 100644
--- a/net/iucv/iucv.c
+++ b/net/iucv/iucv.c
@@ -62,14 +62,8 @@
 #define IUCV_IPNORPY	0x10
 #define IUCV_IPALL	0x80
 
-static int iucv_bus_match(struct device *dev, struct device_driver *drv)
-{
-	return 0;
-}
-
 struct bus_type iucv_bus = {
 	.name = "iucv",
-	.match = iucv_bus_match,
 };
 EXPORT_SYMBOL(iucv_bus);
 
-- 
2.34.1

