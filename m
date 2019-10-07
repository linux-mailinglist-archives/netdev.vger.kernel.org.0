Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB7ACDFE7
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 13:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727502AbfJGLJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 07:09:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44881 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727317AbfJGLJl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 07:09:41 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1iHQtU-0005Nj-0p; Mon, 07 Oct 2019 11:09:36 +0000
From:   Colin King <colin.king@canonical.com>
To:     Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Peng Li <lipeng321@huawei.com>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: hns3: make array tick_array static, makes object smaller
Date:   Mon,  7 Oct 2019 12:09:35 +0100
Message-Id: <20191007110935.32607-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Don't populate the array tick_array on the stack but instead make it
static. Makes the object code smaller by 29 bytes.

Before:
   text	   data	    bss	    dec	    hex	filename
  19191	    432	      0	  19623	   4ca7	hisilicon/hns3/hns3pf/hclge_tm.o

After:
   text	   data	    bss	    dec	    hex	filename
  19098	    496	      0	  19594	   4c8a	hisilicon/hns3/hns3pf/hclge_tm.o

(gcc version 9.2.1, amd64)

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index 9f0e35f27789..5cce9b7f1d3d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -46,7 +46,7 @@ static int hclge_shaper_para_calc(u32 ir, u8 shaper_level,
 #define DIVISOR_CLK		(1000 * 8)
 #define DIVISOR_IR_B_126	(126 * DIVISOR_CLK)
 
-	const u16 tick_array[HCLGE_SHAPER_LVL_CNT] = {
+	static const u16 tick_array[HCLGE_SHAPER_LVL_CNT] = {
 		6 * 256,        /* Prioriy level */
 		6 * 32,         /* Prioriy group level */
 		6 * 8,          /* Port level */
-- 
2.20.1

