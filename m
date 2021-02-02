Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B7DC30BE69
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 13:42:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231714AbhBBMlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 07:41:40 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:12104 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231739AbhBBMlP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 07:41:15 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DVPWk2rFxz162Vy;
        Tue,  2 Feb 2021 20:39:14 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.498.0; Tue, 2 Feb 2021 20:40:24 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <kuba@kernel.org>,
        <huangdaode@huawei.com>, <linuxarm@openeuler.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 7/7] net: hns3: remove unnecessary check in hns3_dbg_read()
Date:   Tue, 2 Feb 2021 20:39:53 +0800
Message-ID: <1612269593-18691-8-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1612269593-18691-1-git-send-email-tanhuazhong@huawei.com>
References: <1612269593-18691-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clang warns:

drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c:499:28: warning:
address of array 'filp->f_path.dentry->d_iname' will always evaluate
to 'true' [-Wpointer-bool-conversion]
        if (!filp->f_path.dentry->d_iname)

This check is unnecessary, so remove it.

Reported-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index 448e7cd..894b454 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -496,9 +496,6 @@ static ssize_t hns3_dbg_read(struct file *filp, char __user *buffer,
 	ssize_t size = 0;
 	int ret = 0;
 
-	if (!filp->f_path.dentry->d_iname)
-		return -EINVAL;
-
 	read_buf = kzalloc(HNS3_DBG_READ_LEN, GFP_KERNEL);
 	if (!read_buf)
 		return -ENOMEM;
-- 
2.7.4

