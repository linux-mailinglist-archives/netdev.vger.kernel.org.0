Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8C6ECDD1
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 09:59:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727864AbfKBI7c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Nov 2019 04:59:32 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:41778 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726999AbfKBI7c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 2 Nov 2019 04:59:32 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 4E1B717A9324712E8E4C;
        Sat,  2 Nov 2019 16:59:27 +0800 (CST)
Received: from linux-ibm.site (10.175.102.37) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.439.0; Sat, 2 Nov 2019 16:59:18 +0800
From:   zhong jiang <zhongjiang@huawei.com>
To:     <kvalo@codeaurora.org>, <stas.yakovlev@gmail.com>,
        <simon.horman@netronome.com>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <zhongjiang@huawei.com>
Subject: [PATCH v3 1/2] ipw2x00: Remove redundant variable "rc"
Date:   Sat, 2 Nov 2019 16:55:21 +0800
Message-ID: <1572684922-61805-2-git-send-email-zhongjiang@huawei.com>
X-Mailer: git-send-email 1.7.12.4
In-Reply-To: <1572684922-61805-1-git-send-email-zhongjiang@huawei.com>
References: <1572684922-61805-1-git-send-email-zhongjiang@huawei.com>
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

