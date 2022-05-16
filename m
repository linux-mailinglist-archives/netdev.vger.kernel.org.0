Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5ABE527C6A
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 05:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239706AbiEPDdK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 May 2022 23:33:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239716AbiEPDdF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 May 2022 23:33:05 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D537D1FCC7;
        Sun, 15 May 2022 20:33:03 -0700 (PDT)
Received: from kwepemi500015.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4L1l7s0xgHzCsjb;
        Mon, 16 May 2022 11:28:09 +0800 (CST)
Received: from huawei.com (10.175.101.6) by kwepemi500015.china.huawei.com
 (7.221.188.92) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Mon, 16 May
 2022 11:33:00 +0800
From:   Lu Wei <luwei32@huawei.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <asmaa@nvidia.com>, <davthompson@nvidia.com>,
        <limings@nvidia.com>, <cai.huoqing@linux.dev>, <arnd@arndb.de>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] net/mlxbf_gige: use eth_zero_addr() to clear mac address
Date:   Mon, 16 May 2022 11:33:43 +0800
Message-ID: <20220516033343.329178-1-luwei32@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemi500015.china.huawei.com (7.221.188.92)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use eth_zero_addr() to clear mac address instead of memset().

Signed-off-by: Lu Wei <luwei32@huawei.com>
---
 drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
index 66ef0090755e..84621b4cb15b 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
@@ -69,7 +69,7 @@ static void mlxbf_gige_initial_mac(struct mlxbf_gige *priv)
 	u8 mac[ETH_ALEN];
 	u64 local_mac;
 
-	memset(mac, 0, ETH_ALEN);
+	eth_zero_addr(mac);
 	mlxbf_gige_get_mac_rx_filter(priv, MLXBF_GIGE_LOCAL_MAC_FILTER_IDX,
 				     &local_mac);
 	u64_to_ether_addr(local_mac, mac);
-- 
2.17.1

