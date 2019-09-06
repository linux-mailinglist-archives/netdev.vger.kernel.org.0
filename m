Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D4D5AB721
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 13:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388293AbfIFL2L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 07:28:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37846 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725308AbfIFL2K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 07:28:10 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1i6CPM-0005wt-H2; Fri, 06 Sep 2019 11:28:04 +0000
From:   Colin King <colin.king@canonical.com>
To:     Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Peng Li <lipeng321@huawei.com>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: hns3: make array spec_opcode static const, makes object smaller
Date:   Fri,  6 Sep 2019 12:28:04 +0100
Message-Id: <20190906112804.7812-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Don't populate the array spec_opcode on the stack but instead make it
static const. Makes the object code smaller by 48 bytes.

Before:
   text	   data	    bss	    dec	    hex	filename
   6914	   1040	    128	   8082	   1f92	hns3/hns3vf/hclgevf_cmd.o

After:
   text	   data	    bss	    dec	    hex	filename
   6866	   1040	    128	   8034	   1f62	hns3/hns3vf/hclgevf_cmd.o

(gcc version 9.2.1, amd64)

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
index 4c2c9458648f..d5d1cc5d1b6e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
@@ -74,7 +74,7 @@ static bool hclgevf_cmd_csq_done(struct hclgevf_hw *hw)
 
 static bool hclgevf_is_special_opcode(u16 opcode)
 {
-	u16 spec_opcode[] = {0x30, 0x31, 0x32};
+	static const u16 spec_opcode[] = {0x30, 0x31, 0x32};
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(spec_opcode); i++) {
-- 
2.20.1

