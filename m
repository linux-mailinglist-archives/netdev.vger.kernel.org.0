Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2DC12D3EF0
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 10:39:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729184AbgLIJhz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 04:37:55 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:9141 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728311AbgLIJhz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 04:37:55 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CrX4T0DKYz15Zp1;
        Wed,  9 Dec 2020 17:36:41 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.487.0; Wed, 9 Dec 2020 17:37:06 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <kvalo@codeaurora.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH v2 wireless] iwlwifi: fw: simplify the iwl_fw_dbg_collect_trig()
Date:   Wed, 9 Dec 2020 17:37:34 +0800
Message-ID: <20201209093734.20836-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify the return expression.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index ab4a8b942c81..9393fcb62076 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -2558,7 +2558,7 @@ int iwl_fw_dbg_collect_trig(struct iwl_fw_runtime *fwrt,
 			    struct iwl_fw_dbg_trigger_tlv *trigger,
 			    const char *fmt, ...)
 {
-	int ret, len = 0;
+	int len = 0;
 	char buf[64];
 
 	if (iwl_trans_dbg_ini_valid(fwrt->trans))
@@ -2580,13 +2580,8 @@ int iwl_fw_dbg_collect_trig(struct iwl_fw_runtime *fwrt,
 		len = strlen(buf) + 1;
 	}
 
-	ret = iwl_fw_dbg_collect(fwrt, le32_to_cpu(trigger->id), buf, len,
+	return iwl_fw_dbg_collect(fwrt, le32_to_cpu(trigger->id), buf, len,
 				  trigger);
-
-	if (ret)
-		return ret;
-
-	return 0;
 }
 IWL_EXPORT_SYMBOL(iwl_fw_dbg_collect_trig);
 
-- 
2.22.0

