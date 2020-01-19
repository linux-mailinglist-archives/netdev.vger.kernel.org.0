Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4977C141DD2
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 13:46:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbgASMqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 07:46:45 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9200 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726778AbgASMqp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Jan 2020 07:46:45 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id D069340F0C76A81514F7;
        Sun, 19 Jan 2020 20:46:42 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.439.0; Sun, 19 Jan 2020 20:46:31 +0800
From:   Chen Zhou <chenzhou10@huawei.com>
To:     <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <chenzhou10@huawei.com>
Subject: [PATCH -next] net: hns3: replace snprintf with scnprintf in hns3_dbg_cmd_read
Date:   Sun, 19 Jan 2020 20:41:47 +0800
Message-ID: <20200119124147.30394-1-chenzhou10@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The return value of snprintf may be greater than the size of
HNS3_DBG_READ_LEN, use scnprintf instead in hns3_dbg_cmd_read.

Signed-off-by: Chen Zhou <chenzhou10@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index 6b328a2..8fad699 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -297,7 +297,7 @@ static ssize_t hns3_dbg_cmd_read(struct file *filp, char __user *buffer,
 	if (!buf)
 		return -ENOMEM;
 
-	len = snprintf(buf, HNS3_DBG_READ_LEN, "%s\n",
+	len = scnprintf(buf, HNS3_DBG_READ_LEN, "%s\n",
 		       "Please echo help to cmd to get help information");
 	uncopy_bytes = copy_to_user(buffer, buf, len);
 
-- 
2.7.4

