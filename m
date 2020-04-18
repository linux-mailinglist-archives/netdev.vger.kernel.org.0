Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC7F1AEA57
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 08:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbgDRGsr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 02:48:47 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:54290 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726055AbgDRGs0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Apr 2020 02:48:26 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 304A21235A4284CB4A5E;
        Sat, 18 Apr 2020 14:48:20 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.487.0; Sat, 18 Apr 2020 14:48:10 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Guojia Liao <liaoguojia@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 06/10] net: hns3: modify some unsuitable type declaration
Date:   Sat, 18 Apr 2020 14:47:05 +0800
Message-ID: <1587192429-11463-7-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1587192429-11463-1-git-send-email-tanhuazhong@huawei.com>
References: <1587192429-11463-1-git-send-email-tanhuazhong@huawei.com>
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
index 90d2c77..3a08287 100644
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

