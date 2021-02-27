Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81ECA326C19
	for <lists+netdev@lfdr.de>; Sat, 27 Feb 2021 08:26:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbhB0HZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Feb 2021 02:25:03 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:12652 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbhB0HY7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Feb 2021 02:24:59 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DndJN1SZlzlQ9B;
        Sat, 27 Feb 2021 15:22:12 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Sat, 27 Feb 2021 15:24:10 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [RESEND net 1/3] net: hns3: fix error mask definition of flow director
Date:   Sat, 27 Feb 2021 15:24:51 +0800
Message-ID: <1614410693-8107-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1614410693-8107-1-git-send-email-tanhuazhong@huawei.com>
References: <1614410693-8107-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

Currently, some bit filed definitions of flow director TCAM
configuration command are incorrect. Since the wrong MSB is
always 0, and these fields are assgined in order, so it still works.

Fix it by redefine them.

Fixes: 117328680288 ("net: hns3: Add input key and action config support for flow director")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index ff52a65..057dda7 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -1053,16 +1053,16 @@ struct hclge_fd_tcam_config_3_cmd {
 #define HCLGE_FD_AD_DROP_B		0
 #define HCLGE_FD_AD_DIRECT_QID_B	1
 #define HCLGE_FD_AD_QID_S		2
-#define HCLGE_FD_AD_QID_M		GENMASK(12, 2)
+#define HCLGE_FD_AD_QID_M		GENMASK(11, 2)
 #define HCLGE_FD_AD_USE_COUNTER_B	12
 #define HCLGE_FD_AD_COUNTER_NUM_S	13
 #define HCLGE_FD_AD_COUNTER_NUM_M	GENMASK(20, 13)
 #define HCLGE_FD_AD_NXT_STEP_B		20
 #define HCLGE_FD_AD_NXT_KEY_S		21
-#define HCLGE_FD_AD_NXT_KEY_M		GENMASK(26, 21)
+#define HCLGE_FD_AD_NXT_KEY_M		GENMASK(25, 21)
 #define HCLGE_FD_AD_WR_RULE_ID_B	0
 #define HCLGE_FD_AD_RULE_ID_S		1
-#define HCLGE_FD_AD_RULE_ID_M		GENMASK(13, 1)
+#define HCLGE_FD_AD_RULE_ID_M		GENMASK(12, 1)
 #define HCLGE_FD_AD_TC_OVRD_B		16
 #define HCLGE_FD_AD_TC_SIZE_S		17
 #define HCLGE_FD_AD_TC_SIZE_M		GENMASK(20, 17)
-- 
2.7.4

