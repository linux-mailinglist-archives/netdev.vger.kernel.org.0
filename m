Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAD0343C961
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 14:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241858AbhJ0MSq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 08:18:46 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:26125 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241814AbhJ0MSj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 08:18:39 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4HfSKh1CdHz1DHrL;
        Wed, 27 Oct 2021 20:14:16 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Wed, 27 Oct 2021 20:16:11 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Wed, 27 Oct 2021 20:16:11 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net 6/7] net: hns3: expand buffer len for some debugfs command
Date:   Wed, 27 Oct 2021 20:11:48 +0800
Message-ID: <20211027121149.45897-7-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211027121149.45897-1-huangguangbin2@huawei.com>
References: <20211027121149.45897-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The specified buffer length for three debugfs files fd_tcam, uc and tqp
is not enough for their maximum needs, so this patch fixes them.

Fixes: b5a0b70d77b9 ("net: hns3: refactor dump fd tcam of debugfs")
Fixes: 1556ea9120ff ("net: hns3: refactor dump mac list of debugfs")
Fixes: d96b0e59468d ("net: hns3: refactor dump reg of debugfs")
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index 3aaad96d0176..f2ade0446208 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -137,7 +137,7 @@ static struct hns3_dbg_cmd_info hns3_dbg_cmd[] = {
 		.name = "uc",
 		.cmd = HNAE3_DBG_CMD_MAC_UC,
 		.dentry = HNS3_DBG_DENTRY_MAC,
-		.buf_len = HNS3_DBG_READ_LEN,
+		.buf_len = HNS3_DBG_READ_LEN_128KB,
 		.init = hns3_dbg_common_file_init,
 	},
 	{
@@ -256,7 +256,7 @@ static struct hns3_dbg_cmd_info hns3_dbg_cmd[] = {
 		.name = "tqp",
 		.cmd = HNAE3_DBG_CMD_REG_TQP,
 		.dentry = HNS3_DBG_DENTRY_REG,
-		.buf_len = HNS3_DBG_READ_LEN,
+		.buf_len = HNS3_DBG_READ_LEN_128KB,
 		.init = hns3_dbg_common_file_init,
 	},
 	{
@@ -298,7 +298,7 @@ static struct hns3_dbg_cmd_info hns3_dbg_cmd[] = {
 		.name = "fd_tcam",
 		.cmd = HNAE3_DBG_CMD_FD_TCAM,
 		.dentry = HNS3_DBG_DENTRY_FD,
-		.buf_len = HNS3_DBG_READ_LEN,
+		.buf_len = HNS3_DBG_READ_LEN_1MB,
 		.init = hns3_dbg_common_file_init,
 	},
 	{
-- 
2.33.0

