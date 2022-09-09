Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 552D45B355C
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 12:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbiIIKjS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 06:39:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbiIIKjR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 06:39:17 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4661134C1A;
        Fri,  9 Sep 2022 03:39:15 -0700 (PDT)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MPC7G28dpzlVqs;
        Fri,  9 Sep 2022 18:35:22 +0800 (CST)
Received: from ubuntu1804.huawei.com (10.67.174.58) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 9 Sep 2022 18:39:13 +0800
From:   Xiu Jianfeng <xiujianfeng@huawei.com>
To:     <ericvh@gmail.com>, <lucho@ionkov.net>, <asmadeus@codewreck.org>,
        <linux_oss@crudebyte.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <v9fs-developer@lists.sourceforge.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] net/9p: add __init/__exit annotations to module init/exit funcs
Date:   Fri, 9 Sep 2022 18:35:46 +0800
Message-ID: <20220909103546.73015-1-xiujianfeng@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.174.58]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500023.china.huawei.com (7.185.36.114)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing __init/__exit annotations to module init/exit funcs.

Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
---
 net/9p/trans_xen.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/9p/trans_xen.c b/net/9p/trans_xen.c
index 41c57d40efb6..b15c64128c3e 100644
--- a/net/9p/trans_xen.c
+++ b/net/9p/trans_xen.c
@@ -511,7 +511,7 @@ static struct xenbus_driver xen_9pfs_front_driver = {
 	.otherend_changed = xen_9pfs_front_changed,
 };
 
-static int p9_trans_xen_init(void)
+static int __init p9_trans_xen_init(void)
 {
 	int rc;
 
@@ -530,7 +530,7 @@ static int p9_trans_xen_init(void)
 module_init(p9_trans_xen_init);
 MODULE_ALIAS_9P("xen");
 
-static void p9_trans_xen_exit(void)
+static void __exit p9_trans_xen_exit(void)
 {
 	v9fs_unregister_trans(&p9_xen_trans);
 	return xenbus_unregister_driver(&xen_9pfs_front_driver);
-- 
2.17.1

