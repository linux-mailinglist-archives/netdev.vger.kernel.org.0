Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02B51582941
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 17:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233438AbiG0PEx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 11:04:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232807AbiG0PEv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 11:04:51 -0400
Received: from mail.nfschina.com (unknown [IPv6:2400:dd01:100f:2:72e2:84ff:fe10:5f45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0219345F53;
        Wed, 27 Jul 2022 08:04:49 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id CE0871E80D89;
        Wed, 27 Jul 2022 23:04:56 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (mail.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Ijy2gFPFcoVt; Wed, 27 Jul 2022 23:04:54 +0800 (CST)
Received: from localhost.localdomain (unknown [180.167.10.98])
        (Authenticated sender: liqiong@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id 6E2401E80D54;
        Wed, 27 Jul 2022 23:04:53 +0800 (CST)
From:   Li Qiong <liqiong@nfschina.com>
To:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
        yuzhe@nfschina.com, renyu@nfschina.com, jiaming@nfschina.com,
        Li Qiong <liqiong@nfschina.com>
Subject: [PATCH] net/rds: Use PTR_ERR instead of IS_ERR for rdsdebug()
Date:   Wed, 27 Jul 2022 23:03:41 +0800
Message-Id: <20220727150341.23746-1-liqiong@nfschina.com>
X-Mailer: git-send-email 2.11.0
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If 'local_odp_mr->r_trans_private' is a error code,
it is better to print the error code than to print
the value of IS_ERR().

Signed-off-by: Li Qiong <liqiong@nfschina.com>
---
 net/rds/rdma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rds/rdma.c b/net/rds/rdma.c
index 6f1a50d50d06..fba82d36593a 100644
--- a/net/rds/rdma.c
+++ b/net/rds/rdma.c
@@ -742,7 +742,7 @@ int rds_cmsg_rdma_args(struct rds_sock *rs, struct rds_message *rm,
 					NULL, 0, rs, &local_odp_mr->r_key, NULL,
 					iov->addr, iov->bytes, ODP_VIRTUAL);
 			if (IS_ERR(local_odp_mr->r_trans_private)) {
-				ret = IS_ERR(local_odp_mr->r_trans_private);
+				ret = PTR_ERR(local_odp_mr->r_trans_private);
 				rdsdebug("get_mr ret %d %p\"", ret,
 					 local_odp_mr->r_trans_private);
 				kfree(local_odp_mr);
-- 
2.11.0

