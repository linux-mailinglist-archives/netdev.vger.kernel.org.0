Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28CE25EB74B
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 03:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbiI0B6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 21:58:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiI0B6s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 21:58:48 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D38EDD11F
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 18:58:47 -0700 (PDT)
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Mc2kB2JmNzWh0v;
        Tue, 27 Sep 2022 09:54:42 +0800 (CST)
Received: from kwepemm600008.china.huawei.com (7.193.23.88) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 27 Sep 2022 09:58:46 +0800
Received: from huawei.com (10.175.100.227) by kwepemm600008.china.huawei.com
 (7.193.23.88) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 27 Sep
 2022 09:58:45 +0800
From:   Shang XiaoJing <shangxiaojing@huawei.com>
To:     <m.chetan.kumar@intel.com>, <linuxwwan@intel.com>,
        <loic.poulain@linaro.org>, <ryazanov.s.a@gmail.com>,
        <johannes@sipsolutions.net>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>
CC:     <shangxiaojing@huawei.com>
Subject: [PATCH -next] net: wwan: iosm: Use skb_put_data() instead of skb_put/memcpy pair
Date:   Tue, 27 Sep 2022 10:32:54 +0800
Message-ID: <20220927023254.30342-1-shangxiaojing@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.100.227]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
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
 drivers/net/wwan/iosm/iosm_ipc_imem_ops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_imem_ops.c b/drivers/net/wwan/iosm/iosm_ipc_imem_ops.c
index 57304a5adf68..b7f9237dedf7 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_imem_ops.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_imem_ops.c
@@ -590,7 +590,7 @@ int ipc_imem_sys_devlink_write(struct iosm_devlink *ipc_devlink,
 		goto out;
 	}
 
-	memcpy(skb_put(skb, count), buf, count);
+	skb_put_data(skb, buf, count);
 
 	IPC_CB(skb)->op_type = UL_USR_OP_BLOCKED;
 
-- 
2.17.1

