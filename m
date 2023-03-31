Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99AE76D17B6
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 08:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbjCaGpa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 02:45:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbjCaGp3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 02:45:29 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 395F1103;
        Thu, 30 Mar 2023 23:45:26 -0700 (PDT)
Received: from dggpeml500019.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4PnrL23FhpzSqGW;
        Fri, 31 Mar 2023 14:41:46 +0800 (CST)
Received: from dggphispra29317.huawei.com (10.244.145.77) by
 dggpeml500019.china.huawei.com (7.185.36.137) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 31 Mar 2023 14:45:24 +0800
From:   Chenyuan Mi <michenyuan@huawei.com>
To:     <isdn@linux-pingi.de>
CC:     <marcel@holtmann.org>, <johan.hedberg@gmail.com>,
        <luiz.dentz@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-bluetooth@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] cmtp: fix argument error
Date:   Fri, 31 Mar 2023 14:45:20 +0800
Message-ID: <20230331064520.1320749-1-michenyuan@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.244.145.77]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500019.china.huawei.com (7.185.36.137)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix this issue by using BTPROTO_CMTP as argument instead of BTPROTO_HIDP.

Signed-off-by: Chenyuan Mi <michenyuan@huawei.com>
---
 net/bluetooth/cmtp/sock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/cmtp/sock.c b/net/bluetooth/cmtp/sock.c
index 96d49d9fae96..cf4370055ce2 100644
--- a/net/bluetooth/cmtp/sock.c
+++ b/net/bluetooth/cmtp/sock.c
@@ -250,7 +250,7 @@ int cmtp_init_sockets(void)
 	err = bt_procfs_init(&init_net, "cmtp", &cmtp_sk_list, NULL);
 	if (err < 0) {
 		BT_ERR("Failed to create CMTP proc file");
-		bt_sock_unregister(BTPROTO_HIDP);
+		bt_sock_unregister(BTPROTO_CMTP);
 		goto error;
 	}
 
-- 
2.25.1

