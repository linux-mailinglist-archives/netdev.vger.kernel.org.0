Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6118F2F7024
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 02:47:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731649AbhAOBqH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 20:46:07 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:11389 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731572AbhAOBqG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 20:46:06 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DH3rP0RMsz7VWk;
        Fri, 15 Jan 2021 09:44:21 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.498.0; Fri, 15 Jan 2021 09:45:13 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>,
        <wcn36xx@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kvalo@codeaurora.org>, Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH wireless v2] scsi: megaraid: Remove unnecessary memset
Date:   Fri, 15 Jan 2021 09:45:59 +0800
Message-ID: <20210115014559.7803-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

memcpy operation is next to memset code, and the size to copy
is equals to the size to memset, so the memset operation is
unnecessary, remove it.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/net/wireless/ath/wcn36xx/smd.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index 273fed22711f..5447a6696c35 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -478,7 +478,6 @@ static void init_hal_msg(struct wcn36xx_hal_msg_header *hdr,
 
 #define PREPARE_HAL_BUF(send_buf, msg_body) \
 	do {							\
-		memset(send_buf, 0, msg_body.header.len);	\
 		memcpy(send_buf, &msg_body, sizeof(msg_body));	\
 	} while (0)						\
 
-- 
2.22.0

