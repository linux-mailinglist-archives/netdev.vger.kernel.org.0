Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CBDB5B33CC
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 11:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbiIIJYZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 05:24:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231367AbiIIJYI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 05:24:08 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C42EF131EF6;
        Fri,  9 Sep 2022 02:23:09 -0700 (PDT)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MP9Sj6w4XzHnfc;
        Fri,  9 Sep 2022 17:20:21 +0800 (CST)
Received: from ubuntu1804.huawei.com (10.67.174.58) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 9 Sep 2022 17:22:18 +0800
From:   Xiu Jianfeng <xiujianfeng@huawei.com>
To:     <santosh.shilimkar@oracle.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <rds-devel@oss.oracle.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] net: rds: add missing __init/__exit annotations to module init/exit funcs
Date:   Fri, 9 Sep 2022 17:18:40 +0800
Message-ID: <20220909091840.247946-1-xiujianfeng@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.174.58]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
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
 net/rds/af_rds.c         | 2 +-
 net/rds/rdma_transport.c | 4 ++--
 net/rds/tcp.c            | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/rds/af_rds.c b/net/rds/af_rds.c
index b239120dd9ca..3ff6995244e5 100644
--- a/net/rds/af_rds.c
+++ b/net/rds/af_rds.c
@@ -894,7 +894,7 @@ module_exit(rds_exit);
 
 u32 rds_gen_num;
 
-static int rds_init(void)
+static int __init rds_init(void)
 {
 	int ret;
 
diff --git a/net/rds/rdma_transport.c b/net/rds/rdma_transport.c
index a9e4ff948a7d..d36f3f6b4351 100644
--- a/net/rds/rdma_transport.c
+++ b/net/rds/rdma_transport.c
@@ -291,7 +291,7 @@ static void rds_rdma_listen_stop(void)
 #endif
 }
 
-static int rds_rdma_init(void)
+static int __init rds_rdma_init(void)
 {
 	int ret;
 
@@ -307,7 +307,7 @@ static int rds_rdma_init(void)
 }
 module_init(rds_rdma_init);
 
-static void rds_rdma_exit(void)
+static void __exit rds_rdma_exit(void)
 {
 	/* stop listening first to ensure no new connections are attempted */
 	rds_rdma_listen_stop();
diff --git a/net/rds/tcp.c b/net/rds/tcp.c
index 73ee2771093d..d8754366506a 100644
--- a/net/rds/tcp.c
+++ b/net/rds/tcp.c
@@ -712,7 +712,7 @@ static void rds_tcp_exit(void)
 }
 module_exit(rds_tcp_exit);
 
-static int rds_tcp_init(void)
+static int __init rds_tcp_init(void)
 {
 	int ret;
 
-- 
2.17.1

