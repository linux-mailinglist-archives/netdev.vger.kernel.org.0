Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B958E5EB742
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 03:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbiI0B4o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 21:56:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbiI0B4k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 21:56:40 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A37B497EF3
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 18:56:37 -0700 (PDT)
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Mc2gT54tMz1P6tS;
        Tue, 27 Sep 2022 09:52:21 +0800 (CST)
Received: from kwepemm600008.china.huawei.com (7.193.23.88) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 27 Sep 2022 09:56:35 +0800
Received: from huawei.com (10.175.100.227) by kwepemm600008.china.huawei.com
 (7.193.23.88) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 27 Sep
 2022 09:56:34 +0800
From:   Shang XiaoJing <shangxiaojing@huawei.com>
To:     <l.stelmach@samsung.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>
CC:     <shangxiaojing@huawei.com>
Subject: [PATCH -next] net: ax88796c: Use skb_put_data() instead of skb_put/memcpy pair
Date:   Tue, 27 Sep 2022 10:30:43 +0800
Message-ID: <20220927023043.17769-1-shangxiaojing@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.100.227]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600008.china.huawei.com (7.193.23.88)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use skb_put_data() instead of skb_put() and memcpy(), which is clear.

Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
---
 drivers/net/ethernet/asix/ax88796c_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/asix/ax88796c_main.c b/drivers/net/ethernet/asix/ax88796c_main.c
index f1d610efd69e..8b7cdf015a16 100644
--- a/drivers/net/ethernet/asix/ax88796c_main.c
+++ b/drivers/net/ethernet/asix/ax88796c_main.c
@@ -293,7 +293,7 @@ ax88796c_tx_fixup(struct net_device *ndev, struct sk_buff_head *q)
 	skb_put(skb, padlen);
 
 	/* EOP header */
-	memcpy(skb_put(skb, TX_EOP_SIZE), &info.eop, TX_EOP_SIZE);
+	skb_put_data(skb, &info.eop, TX_EOP_SIZE);
 
 	skb_unlink(skb, q);
 
-- 
2.17.1

