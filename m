Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8E91AFFD2
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 04:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbgDTCTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 22:19:13 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2803 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726361AbgDTCSu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Apr 2020 22:18:50 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 54469A1480C227E3EB12;
        Mon, 20 Apr 2020 10:18:45 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Mon, 20 Apr 2020 10:18:35 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Guojia Liao <liaoguojia@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 06/10] net: hns3: modify some unsuitable type declaration
Date:   Mon, 20 Apr 2020 10:17:31 +0800
Message-ID: <1587349055-4403-7-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1587349055-4403-1-git-send-email-tanhuazhong@huawei.com>
References: <1587349055-4403-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guojia Liao <liaoguojia@huawei.com>

In hclge_set_fd_key_config(), parameter 'stage' should be
as enum HCLGE_FD_STAGE, and in hclge_config_key(), 'tuple_size'
should be type u8, also simplify unsigned int with u32 for 'i'.

Signed-off-by: Guojia Liao <liaoguojia@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index e238a9d..9edee7d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -4822,7 +4822,8 @@ static int hclge_get_fd_allocation(struct hclge_dev *hdev,
 	return ret;
 }
 
-static int hclge_set_fd_key_config(struct hclge_dev *hdev, int stage_num)
+static int hclge_set_fd_key_config(struct hclge_dev *hdev,
+				   enum HCLGE_FD_STAGE stage_num)
 {
 	struct hclge_set_fd_key_config_cmd *req;
 	struct hclge_fd_key_cfg *stage;
@@ -5158,9 +5159,10 @@ static int hclge_config_key(struct hclge_dev *hdev, u8 stage,
 	struct hclge_fd_key_cfg *key_cfg = &hdev->fd_cfg.key_cfg[stage];
 	u8 key_x[MAX_KEY_BYTES], key_y[MAX_KEY_BYTES];
 	u8 *cur_key_x, *cur_key_y;
-	unsigned int i;
-	int ret, tuple_size;
 	u8 meta_data_region;
+	u8 tuple_size;
+	int ret;
+	u32 i;
 
 	memset(key_x, 0, sizeof(key_x));
 	memset(key_y, 0, sizeof(key_y));
-- 
2.7.4

