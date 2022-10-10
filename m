Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 678DB5F0B6E
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 14:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbiI3MME (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 08:12:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231464AbiI3MMA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 08:12:00 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A522B6036;
        Fri, 30 Sep 2022 05:11:59 -0700 (PDT)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Mf8B21T96zlWpY;
        Fri, 30 Sep 2022 20:07:38 +0800 (CST)
Received: from dggpemm500013.china.huawei.com (7.185.36.172) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 30 Sep 2022 20:11:57 +0800
Received: from huawei.com (10.67.174.245) by dggpemm500013.china.huawei.com
 (7.185.36.172) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 30 Sep
 2022 20:11:57 +0800
From:   Chen Zhongjin <chenzhongjin@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <chenzhongjin@huawei.com>
Subject: [PATCH -next] net: mvneta: Remove unused variables 'i'
Date:   Mon, 10 Oct 2022 11:25:06 +0800
Message-ID: <20221010032506.2886099-1-chenzhongjin@huawei.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.245]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
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

'commit cad5d847a093 ("net: mvneta: Fix the CPU choice in mvneta_percpu_elect")'
This commit had changed the logic to elect CPU in mvneta_percpu_elect().
Now the variable 'i' is not used in this function, so remove it.

Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
---
 drivers/net/ethernet/marvell/mvneta.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 0caa2df87c04..11bec920177b 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -4266,7 +4266,7 @@ static void mvneta_mdio_remove(struct mvneta_port *pp)
  */
 static void mvneta_percpu_elect(struct mvneta_port *pp)
 {
-	int elected_cpu = 0, max_cpu, cpu, i = 0;
+	int elected_cpu = 0, max_cpu, cpu;
 
 	/* Use the cpu associated to the rxq when it is online, in all
 	 * the other cases, use the cpu 0 which can't be offline.
@@ -4306,8 +4306,6 @@ static void mvneta_percpu_elect(struct mvneta_port *pp)
 		 */
 		smp_call_function_single(cpu, mvneta_percpu_unmask_interrupt,
 					 pp, true);
-		i++;
-
 	}
 };
 
-- 
2.33.0

