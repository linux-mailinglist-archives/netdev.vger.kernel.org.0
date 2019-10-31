Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB95EEAECC
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 12:23:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbfJaLXc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 07:23:32 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5667 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726739AbfJaLXC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Oct 2019 07:23:02 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 1E0B0F54A19E3056AEC0;
        Thu, 31 Oct 2019 19:22:57 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.439.0; Thu, 31 Oct 2019 19:22:50 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 7/9] net: hns3: add or modify some comments
Date:   Thu, 31 Oct 2019 19:23:22 +0800
Message-ID: <1572521004-36126-8-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1572521004-36126-1-git-send-email-tanhuazhong@huawei.com>
References: <1572521004-36126-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guangbin Huang <huangguangbin2@huawei.com>

This patch makes the comment for macro HCLGE_MBX_GET_VF_FLR_STATUS
more correct, and adds comments in some place to make the code more
readable.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h         | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hnae3.c             | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 3 +++
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
index 0059d44..cb45c7d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
@@ -47,7 +47,7 @@ enum HCLGE_MBX_OPCODE {
 	HCLGE_MBX_GET_MEDIA_TYPE,       /* (VF -> PF) get media type */
 	HCLGE_MBX_PUSH_PROMISC_INFO,	/* (PF -> VF) push vf promisc info */
 
-	HCLGE_MBX_GET_VF_FLR_STATUS = 200, /* (M7 -> PF) get vf reset status */
+	HCLGE_MBX_GET_VF_FLR_STATUS = 200, /* (M7 -> PF) get vf flr status */
 	HCLGE_MBX_PUSH_LINK_STATUS,	/* (M7 -> PF) get port link status */
 	HCLGE_MBX_NCSI_ERROR,		/* (M7 -> PF) receive a NCSI error */
 };
diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.c b/drivers/net/ethernet/hisilicon/hns3/hnae3.c
index 03ca7d9..eef1b27 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.c
@@ -146,7 +146,7 @@ void hnae3_unregister_client(struct hnae3_client *client)
 		return;
 
 	mutex_lock(&hnae3_common_lock);
-
+	/* one system should only have one client for every type */
 	list_for_each_entry(client_tmp, &hnae3_client_list, node) {
 		if (client_tmp->type == client->type) {
 			existed = true;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 3002527..e578029 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -8552,6 +8552,7 @@ int hclge_set_vport_mtu(struct hclge_vport *vport, int new_mtu)
 	struct hclge_dev *hdev = vport->back;
 	int i, max_frm_size, ret;
 
+	/* HW supprt 2 layer vlan */
 	max_frm_size = new_mtu + ETH_HLEN + ETH_FCS_LEN + 2 * VLAN_HLEN;
 	if (max_frm_size < HCLGE_MAC_MIN_FRAME ||
 	    max_frm_size > HCLGE_MAC_MAX_FRAME)
@@ -9314,6 +9315,8 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 	hdev->reset_type = HNAE3_NONE_RESET;
 	hdev->reset_level = HNAE3_FUNC_RESET;
 	ae_dev->priv = hdev;
+
+	/* HW supprt 2 layer vlan */
 	hdev->mps = ETH_FRAME_LEN + ETH_FCS_LEN + 2 * VLAN_HLEN;
 
 	mutex_init(&hdev->vport_lock);
-- 
2.7.4

