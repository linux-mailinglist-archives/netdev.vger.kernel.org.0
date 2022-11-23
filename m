Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA33634E88
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 05:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235659AbiKWEAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 23:00:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234375AbiKWEAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 23:00:08 -0500
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD4C1E0CAD;
        Tue, 22 Nov 2022 20:00:03 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046051;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0VVV17LO_1669175993;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0VVV17LO_1669175993)
          by smtp.aliyun-inc.com;
          Wed, 23 Nov 2022 12:00:01 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     tgraf@suug.ch
Cc:     herbert@gondor.apana.org.au, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH] lib/test_rhashtable: Remove set but unused variable 'insert_retries'
Date:   Wed, 23 Nov 2022 11:59:51 +0800
Message-Id: <20221123035951.10720-1-jiapeng.chong@linux.alibaba.com>
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
 lib/test_rhashtable.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/lib/test_rhashtable.c b/lib/test_rhashtable.c
index 6a8e445c8b55..a7bf3b40b67b 100644
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
+		if (err)
 			return err;
 	}
 
-- 
2.20.1.7.g153144c

