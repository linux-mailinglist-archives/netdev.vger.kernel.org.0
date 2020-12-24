Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94F942E2747
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 14:26:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729037AbgLXNZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Dec 2020 08:25:24 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:9487 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728367AbgLXNZX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Dec 2020 08:25:23 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4D1rPs3Dx1zhvVj;
        Thu, 24 Dec 2020 21:24:01 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.498.0; Thu, 24 Dec 2020 21:24:27 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <kvalo@codeaurora.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <luciano.coelho@intel.com>,
        Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH v2 -next] intel: iwlwifi: use DEFINE_MUTEX() for mutex lock
Date:   Thu, 24 Dec 2020 21:25:03 +0800
Message-ID: <20201224132503.31397-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mutex lock can be initialized automatically with DEFINE_MUTEX()
rather than explicitly calling mutex_init().

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

