Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35005524790
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 10:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351304AbiELIEG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 04:04:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237517AbiELIEG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 04:04:06 -0400
Received: from out199-3.us.a.mail.aliyun.com (out199-3.us.a.mail.aliyun.com [47.90.199.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5672E20F9FC;
        Thu, 12 May 2022 01:04:04 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R351e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0VCzyqtO_1652342638;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0VCzyqtO_1652342638)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 12 May 2022 16:03:59 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     wellslutw@gmail.com
Cc:     edumazet@google.com, pabeni@redhat.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next] net: ethernet: fix platform_no_drv_owner.cocci warning
Date:   Thu, 12 May 2022 16:03:57 +0800
Message-Id: <20220512080357.44357-1-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove .owner field if calls are used which set it automatically.
./drivers/net/ethernet/sunplus/spl2sw_driver.c:569:3-8: No need to set
.owner here. The core will do it.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/net/ethernet/sunplus/spl2sw_driver.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/sunplus/spl2sw_driver.c b/drivers/net/ethernet/sunplus/spl2sw_driver.c
index 8320fa833d3e..bf32f425b19d 100644
--- a/drivers/net/ethernet/sunplus/spl2sw_driver.c
+++ b/drivers/net/ethernet/sunplus/spl2sw_driver.c
@@ -566,7 +566,6 @@ static struct platform_driver spl2sw_driver = {
 	.remove = spl2sw_remove,
 	.driver = {
 		.name = "sp7021_emac",
-		.owner = THIS_MODULE,
 		.of_match_table = spl2sw_of_match,
 	},
 };
-- 
2.20.1.7.g153144c

