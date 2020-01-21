Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8938C143894
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 09:43:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728760AbgAUInJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 03:43:09 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:10113 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725890AbgAUImc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jan 2020 03:42:32 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id C67297E1EA6816AB0CE7;
        Tue, 21 Jan 2020 16:42:29 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Tue, 21 Jan 2020 16:42:22 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <huangdaode@huawei.com>, <linuxarm@huawei.com>, <kuba@kernel.org>,
        Guojia Liao <liaoguojia@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 5/9] net: hns3: refine the input parameter 'size' for snprintf()
Date:   Tue, 21 Jan 2020 16:42:09 +0800
Message-ID: <1579596133-54842-6-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1579596133-54842-1-git-send-email-tanhuazhong@huawei.com>
References: <1579596133-54842-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guojia Liao <liaoguojia@huawei.com>

The function snprintf() writes at most size bytes (including the
terminating null byte ('\0') to str. Now, We can guarantee that the
parameter of size is lager than the length of str to be formatting
including its terminating null byte. So it's unnecessary to minus 1
for the input parameter 'size'.

Signed-off-by: Guojia Liao <liaoguojia@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 06c58ed..6271b69 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -4716,7 +4716,7 @@ static int __init hns3_init_module(void)
 	pr_info("%s: %s\n", hns3_driver_name, hns3_copyright);
 
 	client.type = HNAE3_CLIENT_KNIC;
-	snprintf(client.name, HNAE3_CLIENT_NAME_LENGTH - 1, "%s",
+	snprintf(client.name, HNAE3_CLIENT_NAME_LENGTH, "%s",
 		 hns3_driver_name);
 
 	client.ops = &client_ops;
-- 
2.7.4

