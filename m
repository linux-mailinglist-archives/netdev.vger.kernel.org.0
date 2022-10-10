Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B09305F0B23
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 13:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbiI3L4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 07:56:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230266AbiI3Lz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 07:55:59 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BF5F125DB7;
        Fri, 30 Sep 2022 04:55:57 -0700 (PDT)
Received: from dggpemm500020.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Mf7sr46RSzHqJq;
        Fri, 30 Sep 2022 19:53:36 +0800 (CST)
Received: from dggpemm500013.china.huawei.com (7.185.36.172) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 30 Sep 2022 19:55:55 +0800
Received: from huawei.com (10.67.174.245) by dggpemm500013.china.huawei.com
 (7.185.36.172) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 30 Sep
 2022 19:55:55 +0800
From:   Chen Zhongjin <chenzhongjin@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <rds-devel@oss.oracle.com>
CC:     <santosh.shilimkar@oracle.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <chenzhongjin@huawei.com>
Subject: [PATCH -next 1/2] net/rds: Remove unused variable 'total_copied'
Date:   Mon, 10 Oct 2022 11:09:03 +0800
Message-ID: <20221010030904.2883557-2-chenzhongjin@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20221010030904.2883557-1-chenzhongjin@huawei.com>
References: <20221010030904.2883557-1-chenzhongjin@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.245]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500013.china.huawei.com (7.185.36.172)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_DATE_IN_FUTURE_96_Q autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reported by Clang [-Wunused-but-set-variable]

'commit 0cebaccef3ac ("rds: zerocopy Tx support.")'
This commit introduced the variable 'dest_frames'. However this variable
is never used by other code except iterates itself, so remove it.

Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
---
 net/rds/message.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/rds/message.c b/net/rds/message.c
index d74be4e3f3fa..eee2e674d5c0 100644
--- a/net/rds/message.c
+++ b/net/rds/message.c
@@ -366,7 +366,6 @@ static int rds_message_zcopy_from_user(struct rds_message *rm, struct iov_iter *
 	struct scatterlist *sg;
 	int ret = 0;
 	int length = iov_iter_count(from);
-	int total_copied = 0;
 	struct rds_msg_zcopy_info *info;
 
 	rm->m_inc.i_hdr.h_len = cpu_to_be32(iov_iter_count(from));
@@ -404,7 +403,6 @@ static int rds_message_zcopy_from_user(struct rds_message *rm, struct iov_iter *
 			ret = -EFAULT;
 			goto err;
 		}
-		total_copied += copied;
 		length -= copied;
 		sg_set_page(sg, pages, copied, start);
 		rm->data.op_nents++;
-- 
2.33.0

