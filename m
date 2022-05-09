Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26AB751F72E
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 10:47:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231672AbiEIIuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 04:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237431AbiEIIW6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 04:22:58 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 942021F0188;
        Mon,  9 May 2022 01:18:59 -0700 (PDT)
Received: from kwepemi500013.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4KxYW11GxBz1JC03;
        Mon,  9 May 2022 16:00:13 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi500013.china.huawei.com (7.221.188.120) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 9 May 2022 16:01:20 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 9 May 2022 16:01:20 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH V2 net-next 6/6] net: hns3: fix incorrect type of argument in declaration of function hclge_comm_get_rss_indir_tbl
Date:   Mon, 9 May 2022 15:55:32 +0800
Message-ID: <20220509075532.32166-7-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220509075532.32166-1-huangguangbin2@huawei.com>
References: <20220509075532.32166-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The argument rss_ind_tbl_size is type u16 in function definition of
hclge_comm_get_rss_indir_tbl(), but it is set to type __le16 in function
declaration by mistake, so fix it.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.h    | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.h b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.h
index aa1d7a6ff4ca..946d166a452d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.h
@@ -106,7 +106,7 @@ int hclge_comm_parse_rss_hfunc(struct hclge_comm_rss_cfg *rss_cfg,
 void hclge_comm_get_rss_hash_info(struct hclge_comm_rss_cfg *rss_cfg, u8 *key,
 				  u8 *hfunc);
 void hclge_comm_get_rss_indir_tbl(struct hclge_comm_rss_cfg *rss_cfg,
-				  u32 *indir, __le16 rss_ind_tbl_size);
+				  u32 *indir, u16 rss_ind_tbl_size);
 int hclge_comm_set_rss_algo_key(struct hclge_comm_hw *hw, const u8 hfunc,
 				const u8 *key);
 int hclge_comm_init_rss_tuple_cmd(struct hclge_comm_rss_cfg *rss_cfg,
-- 
2.33.0

