Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39179438810
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 11:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231665AbhJXJsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 05:48:08 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:26188 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231177AbhJXJr6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Oct 2021 05:47:58 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4HcY825cvKz8trM;
        Sun, 24 Oct 2021 17:44:18 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Sun, 24 Oct 2021 17:45:37 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Sun, 24 Oct 2021 17:45:36 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 8/8] net: hns3: add error recovery module and type for himac
Date:   Sun, 24 Oct 2021 17:41:15 +0800
Message-ID: <20211024094115.42158-9-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211024094115.42158-1-huangguangbin2@huawei.com>
References: <20211024094115.42158-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiaran Zhang <zhangjiaran@huawei.com>

This patch adds himac error recovery module, link_error type and
ptp_error type for himac.

Signed-off-by: Jiaran Zhang <zhangjiaran@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c | 9 +++++++++
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h | 3 +++
 2 files changed, 12 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
index 59df3c477c36..20e628c2bd44 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
@@ -1242,6 +1242,9 @@ static const struct hclge_hw_module_id hclge_hw_module_id_st[] = {
 	}, {
 		.module_id = MODULE_MASTER,
 		.msg = "MODULE_MASTER"
+	}, {
+		.module_id = MODULE_HIMAC,
+		.msg = "MODULE_HIMAC"
 	}, {
 		.module_id = MODULE_ROCEE_TOP,
 		.msg = "MODULE_ROCEE_TOP"
@@ -1315,6 +1318,12 @@ static const struct hclge_hw_type_id hclge_hw_type_id_st[] = {
 	}, {
 		.type_id = GLB_ERROR,
 		.msg = "glb_error"
+	}, {
+		.type_id = LINK_ERROR,
+		.msg = "link_error"
+	}, {
+		.type_id = PTP_ERROR,
+		.msg = "ptp_error"
 	}, {
 		.type_id = ROCEE_NORMAL_ERR,
 		.msg = "rocee_normal_error"
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h
index 2f4f4c71a5ec..86be6fb32990 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h
@@ -138,6 +138,7 @@ enum hclge_mod_name_list {
 	MODULE_RCB_TX		= 12,
 	MODULE_TXDMA		= 13,
 	MODULE_MASTER		= 14,
+	MODULE_HIMAC		= 15,
 	/* add new MODULE NAME for NIC here in order */
 	MODULE_ROCEE_TOP	= 40,
 	MODULE_ROCEE_TIMER	= 41,
@@ -166,6 +167,8 @@ enum hclge_err_type_list {
 	ETS_ERROR		= 10,
 	NCSI_ERROR		= 11,
 	GLB_ERROR		= 12,
+	LINK_ERROR		= 13,
+	PTP_ERROR		= 14,
 	/* add new ERROR TYPE for NIC here in order */
 	ROCEE_NORMAL_ERR	= 40,
 	ROCEE_OVF_ERR		= 41,
-- 
2.33.0

