Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 144AC5F9A6
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 16:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727714AbfGDOG7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 10:06:59 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:8702 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726794AbfGDOGb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 10:06:31 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 071282E3EF254570DEE0;
        Thu,  4 Jul 2019 22:06:27 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.439.0; Thu, 4 Jul 2019 22:06:17 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 7/9] net: hns3: add default value for tc_size and tc_offset
Date:   Thu, 4 Jul 2019 22:04:26 +0800
Message-ID: <1562249068-40176-8-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562249068-40176-1-git-send-email-tanhuazhong@huawei.com>
References: <1562249068-40176-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

This patch adds default value for tc_size and tc_offset, or it may
get random value and used later.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 94c94e1..2abd5f5 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -4092,11 +4092,11 @@ int hclge_rss_init_hw(struct hclge_dev *hdev)
 	struct hclge_vport *vport = hdev->vport;
 	u8 *rss_indir = vport[0].rss_indirection_tbl;
 	u16 rss_size = vport[0].alloc_rss_size;
+	u16 tc_offset[HCLGE_MAX_TC_NUM] = {0};
+	u16 tc_size[HCLGE_MAX_TC_NUM] = {0};
 	u8 *key = vport[0].rss_hash_key;
 	u8 hfunc = vport[0].rss_algo;
-	u16 tc_offset[HCLGE_MAX_TC_NUM];
 	u16 tc_valid[HCLGE_MAX_TC_NUM];
-	u16 tc_size[HCLGE_MAX_TC_NUM];
 	u16 roundup_size;
 	unsigned int i;
 	int ret;
@@ -9036,12 +9036,12 @@ static int hclge_set_channels(struct hnae3_handle *handle, u32 new_tqps_num,
 {
 	struct hclge_vport *vport = hclge_get_vport(handle);
 	struct hnae3_knic_private_info *kinfo = &vport->nic.kinfo;
+	u16 tc_offset[HCLGE_MAX_TC_NUM] = {0};
 	struct hclge_dev *hdev = vport->back;
+	u16 tc_size[HCLGE_MAX_TC_NUM] = {0};
 	int cur_rss_size = kinfo->rss_size;
 	int cur_tqps = kinfo->num_tqps;
-	u16 tc_offset[HCLGE_MAX_TC_NUM];
 	u16 tc_valid[HCLGE_MAX_TC_NUM];
-	u16 tc_size[HCLGE_MAX_TC_NUM];
 	u16 roundup_size;
 	u32 *rss_indir;
 	unsigned int i;
-- 
2.7.4

