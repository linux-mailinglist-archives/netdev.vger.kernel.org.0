Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35BA35F0B48
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 14:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230517AbiI3MGd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 08:06:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbiI3MGb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 08:06:31 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF8CF157FFB;
        Fri, 30 Sep 2022 05:06:28 -0700 (PDT)
Received: from dggpemm500021.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Mf85D5J1yzpTJK;
        Fri, 30 Sep 2022 20:03:28 +0800 (CST)
Received: from dggpemm500013.china.huawei.com (7.185.36.172) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 30 Sep 2022 20:06:27 +0800
Received: from huawei.com (10.67.174.245) by dggpemm500013.china.huawei.com
 (7.185.36.172) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 30 Sep
 2022 20:06:26 +0800
From:   Chen Zhongjin <chenzhongjin@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <shayagr@amazon.com>, <akiyano@amazon.com>, <darinzon@amazon.com>,
        <ndagan@amazon.com>, <saeedb@amazon.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <nkoler@amazon.com>, <42.hyeyoo@gmail.com>,
        <chenzhongjin@huawei.com>
Subject: [PATCH -next] net: ena: Remove unused variable 'tx_bytes'
Date:   Mon, 10 Oct 2022 11:19:36 +0800
Message-ID: <20221010031936.2885327-1-chenzhongjin@huawei.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.245]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
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

'commit 548c4940b9f1 ("net: ena: Implement XDP_TX action")'
This commit introduced the variable 'tx_bytes'. However this variable
is never used by other code except iterates itself, so remove it.

Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 6a356a6cee15..c8dfb9287856 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -1876,7 +1876,6 @@ static int ena_clean_xdp_irq(struct ena_ring *xdp_ring, u32 budget)
 {
 	u32 total_done = 0;
 	u16 next_to_clean;
-	u32 tx_bytes = 0;
 	int tx_pkts = 0;
 	u16 req_id;
 	int rc;
@@ -1914,7 +1913,6 @@ static int ena_clean_xdp_irq(struct ena_ring *xdp_ring, u32 budget)
 			  "tx_poll: q %d skb %p completed\n", xdp_ring->qid,
 			  xdpf);
 
-		tx_bytes += xdpf->len;
 		tx_pkts++;
 		total_done += tx_info->tx_descs;
 
-- 
2.33.0

