Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97C8F662499
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 12:49:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236750AbjAILs4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 06:48:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237075AbjAILst (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 06:48:49 -0500
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18801D120;
        Mon,  9 Jan 2023 03:48:48 -0800 (PST)
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mxct.zte.com.cn (FangMail) with ESMTPS id 4NrBzc6Kznz4y3Z8;
        Mon,  9 Jan 2023 19:48:44 +0800 (CST)
Received: from szxlzmapp02.zte.com.cn ([10.5.231.79])
        by mse-fl2.zte.com.cn with SMTP id 309Bmers067416;
        Mon, 9 Jan 2023 19:48:40 +0800 (+08)
        (envelope-from yang.yang29@zte.com.cn)
Received: from mapi (szxlzmapp01[null])
        by mapi (Zmail) with MAPI id mid14;
        Mon, 9 Jan 2023 19:48:43 +0800 (CST)
Date:   Mon, 9 Jan 2023 19:48:43 +0800 (CST)
X-Zmail-TransId: 2b0363bbff1bffffffffabae1a6f
X-Mailer: Zmail v1.0
Message-ID: <202301091948433010050@zte.com.cn>
Mime-Version: 1.0
From:   <yang.yang29@zte.com.cn>
To:     <santosh.shilimkar@oracle.com>
Cc:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <rds-devel@oss.oracle.com>,
        <linux-kernel@vger.kernel.org>, <xu.panda@zte.com.cn>,
        <yang.yang29@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIG5ldC1uZXh0XSBuZXQvcmRzOiB1c2Ugc3Ryc2NweSgpIHRvIGluc3RlYWQgb2Ygc3RybmNweSgp?=
Content-Type: text/plain;
        charset="UTF-8"
X-MAIL: mse-fl2.zte.com.cn 309Bmers067416
X-Fangmail-Gw-Spam-Type: 0
X-FangMail-Miltered: at cgslv5.04-192.168.251.13.novalocal with ID 63BBFF1C.000 by FangMail milter!
X-FangMail-Envelope: 1673264924/4NrBzc6Kznz4y3Z8/63BBFF1C.000/10.5.228.133/[10.5.228.133]/mse-fl2.zte.com.cn/<yang.yang29@zte.com.cn>
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 63BBFF1C.000/4NrBzc6Kznz4y3Z8
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xu Panda <xu.panda@zte.com.cn>

The implementation of strscpy() is more robust and safer.
That's now the recommended way to copy NUL-terminated strings.

Signed-off-by: Xu Panda <xu.panda@zte.com.cn>
Signed-off-by: Yang Yang <yang.yang29@zte.com.cn>
---
 net/rds/stats.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/rds/stats.c b/net/rds/stats.c
index 9e87da43c004..6a5a60d36d60 100644
--- a/net/rds/stats.c
+++ b/net/rds/stats.c
@@ -89,8 +89,7 @@ void rds_stats_info_copy(struct rds_info_iterator *iter,

 	for (i = 0; i < nr; i++) {
 		BUG_ON(strlen(names[i]) >= sizeof(ctr.name));
-		strncpy(ctr.name, names[i], sizeof(ctr.name) - 1);
-		ctr.name[sizeof(ctr.name) - 1] = '\0';
+		strscpy(ctr.name, names[i], sizeof(ctr.name));
 		ctr.value = values[i];

 		rds_info_copy(iter, &ctr, sizeof(ctr));
-- 
2.15.2
