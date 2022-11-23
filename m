Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5BAA635738
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 10:41:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237945AbiKWJj5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 04:39:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237934AbiKWJjj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 04:39:39 -0500
Received: from out199-3.us.a.mail.aliyun.com (out199-3.us.a.mail.aliyun.com [47.90.199.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D45810613D;
        Wed, 23 Nov 2022 01:37:20 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R511e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0VVWMaJV_1669196233;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0VVWMaJV_1669196233)
          by smtp.aliyun-inc.com;
          Wed, 23 Nov 2022 17:37:17 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     tgraf@suug.ch
Cc:     herbert@gondor.apana.org.au, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH v2] lib/test_rhashtable: Remove set but unused variable 'insert_retries'
Date:   Wed, 23 Nov 2022 17:37:02 +0800
Message-Id: <20221123093702.32219-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Variable 'insert_retries' is not effectively used in the function, so
delete it.

lib/test_rhashtable.c:437:18: warning: variable 'insert_retries' set but not used.

Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=3242
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
Changes in v2:
  -The condition for modifying err is less than 0.

 lib/test_rhashtable.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/lib/test_rhashtable.c b/lib/test_rhashtable.c
index 6a8e445c8b55..c20f6cb4bf55 100644
--- a/lib/test_rhashtable.c
+++ b/lib/test_rhashtable.c
@@ -434,7 +434,7 @@ static int __init test_rhltable(unsigned int entries)
 static int __init test_rhashtable_max(struct test_obj *array,
 				      unsigned int entries)
 {
-	unsigned int i, insert_retries = 0;
+	unsigned int i;
 	int err;
 
 	test_rht_params.max_size = roundup_pow_of_two(entries / 8);
@@ -447,9 +447,7 @@ static int __init test_rhashtable_max(struct test_obj *array,
 
 		obj->value.id = i * 2;
 		err = insert_retry(&ht, obj, test_rht_params);
-		if (err > 0)
-			insert_retries += err;
-		else if (err)
+		if (err < 0)
 			return err;
 	}
 
-- 
2.20.1.7.g153144c

