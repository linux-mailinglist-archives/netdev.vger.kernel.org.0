Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0107A2E1D12
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 15:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728953AbgLWOMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 09:12:23 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:9638 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728742AbgLWOMW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 09:12:22 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4D1FV91hfrz15hRG;
        Wed, 23 Dec 2020 22:10:41 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Wed, 23 Dec 2020 22:11:16 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <kvalo@codeaurora.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH -next] intel/iwlwifi: use DEFINE_MUTEX (and mutex_init() had been too late)
Date:   Wed, 23 Dec 2020 22:11:52 +0800
Message-ID: <20201223141152.32564-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index 9dcd2e990c9c..71119044382f 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -133,7 +133,7 @@ enum {
 };
 
 /* Protects the table contents, i.e. the ops pointer & drv list */
-static struct mutex iwlwifi_opmode_table_mtx;
+static DEFINE_MUTEX(iwlwifi_opmode_table_mtx);
 static struct iwlwifi_opmode_table {
 	const char *name;			/* name: iwldvm, iwlmvm, etc */
 	const struct iwl_op_mode_ops *ops;	/* pointer to op_mode ops */
@@ -1786,8 +1786,6 @@ static int __init iwl_drv_init(void)
 {
 	int i, err;
 
-	mutex_init(&iwlwifi_opmode_table_mtx);
-
 	for (i = 0; i < ARRAY_SIZE(iwlwifi_opmode_table); i++)
 		INIT_LIST_HEAD(&iwlwifi_opmode_table[i].drv);
 
-- 
2.22.0

