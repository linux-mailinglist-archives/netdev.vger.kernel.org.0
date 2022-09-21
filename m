Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4155BFDF0
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 14:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbiIUMcu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 08:32:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbiIUMcd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 08:32:33 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62FFA696D5;
        Wed, 21 Sep 2022 05:32:32 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MXd472h8ZzlWx2;
        Wed, 21 Sep 2022 20:28:23 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 21 Sep
 2022 20:32:30 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <shuah@kernel.org>, <victor@mojatatu.com>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH -next, v3 09/10] net: hinic: replace magic numbers with macro
Date:   Wed, 21 Sep 2022 20:33:57 +0800
Message-ID: <20220921123358.63442-10-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220921123358.63442-1-shaozhengchao@huawei.com>
References: <20220921123358.63442-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace magic numbers with macro.

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 drivers/net/ethernet/huawei/hinic/hinic_sriov.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_sriov.c b/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
index d54ccef467e7..a5f08b969e3f 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
@@ -24,6 +24,7 @@ MODULE_PARM_DESC(set_vf_link_state, "Set vf link state, 0 represents link auto,
 #define HINIC_VLAN_PRIORITY_SHIFT 13
 #define HINIC_ADD_VLAN_IN_MAC 0x8000
 #define HINIC_TX_RATE_TABLE_FULL 12
+#define HINIC_MAX_QOS 7
 
 static int hinic_set_mac(struct hinic_hwdev *hwdev, const u8 *mac_addr,
 			 u16 vlan_id, u16 func_id)
@@ -774,7 +775,7 @@ int hinic_ndo_set_vf_vlan(struct net_device *netdev, int vf, u16 vlan, u8 qos,
 	u16 vlanprio, cur_vlanprio;
 
 	sriov_info = &nic_dev->sriov_info;
-	if (vf >= sriov_info->num_vfs || vlan > 4095 || qos > 7)
+	if (vf >= sriov_info->num_vfs || vlan >= VLAN_N_VID || qos > HINIC_MAX_QOS)
 		return -EINVAL;
 	if (vlan_proto != htons(ETH_P_8021Q))
 		return -EPROTONOSUPPORT;
-- 
2.17.1

