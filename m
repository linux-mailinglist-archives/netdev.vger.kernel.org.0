Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17C63EC2C4
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 13:37:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730244AbfKAMhn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 08:37:43 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5688 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727487AbfKAMhn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Nov 2019 08:37:43 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 0AB54AB08411281977FE;
        Fri,  1 Nov 2019 20:37:41 +0800 (CST)
Received: from linux-ibm.site (10.175.102.37) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Fri, 1 Nov 2019 20:37:34 +0800
From:   zhong jiang <zhongjiang@huawei.com>
To:     <kvalo@codeaurora.org>, <stas.yakovlev@gmail.com>,
        <simon.horman@netronome.com>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <zhongjiang@huawei.com>
Subject: [PATCH v2 1/3] ipw2x00: Remove redundant variable "rc"
Date:   Fri, 1 Nov 2019 20:33:39 +0800
Message-ID: <1572611621-13280-2-git-send-email-zhongjiang@huawei.com>
X-Mailer: git-send-email 1.7.12.4
In-Reply-To: <1572611621-13280-1-git-send-email-zhongjiang@huawei.com>
References: <1572611621-13280-1-git-send-email-zhongjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.102.37]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

local variable "rc" is not used. It is safe to remove and
There is only one caller of libipw_qos_convert_ac_to_parameters().
hence make it void

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 drivers/net/wireless/intel/ipw2x00/libipw_rx.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/libipw_rx.c b/drivers/net/wireless/intel/ipw2x00/libipw_rx.c
index 34cfd81..0cb36d1 100644
--- a/drivers/net/wireless/intel/ipw2x00/libipw_rx.c
+++ b/drivers/net/wireless/intel/ipw2x00/libipw_rx.c
@@ -999,13 +999,12 @@ static int libipw_read_qos_info_element(struct
 /*
  * Write QoS parameters from the ac parameters.
  */
-static int libipw_qos_convert_ac_to_parameters(struct
+static void libipw_qos_convert_ac_to_parameters(struct
 						  libipw_qos_parameter_info
 						  *param_elm, struct
 						  libipw_qos_parameters
 						  *qos_param)
 {
-	int rc = 0;
 	int i;
 	struct libipw_qos_ac_parameter *ac_params;
 	u32 txop;
@@ -1030,7 +1029,6 @@ static int libipw_qos_convert_ac_to_parameters(struct
 		txop = le16_to_cpu(ac_params->tx_op_limit) * 32;
 		qos_param->tx_op_limit[i] = cpu_to_le16(txop);
 	}
-	return rc;
 }
 
 /*
-- 
1.7.12.4

