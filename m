Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0687561912A
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 07:37:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231128AbiKDGhk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 02:37:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbiKDGhj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 02:37:39 -0400
Received: from out30-56.freemail.mail.aliyun.com (out30-56.freemail.mail.aliyun.com [115.124.30.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15CE821E18;
        Thu,  3 Nov 2022 23:37:37 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0VTvrMNq_1667543853;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0VTvrMNq_1667543853)
          by smtp.aliyun-inc.com;
          Fri, 04 Nov 2022 14:37:34 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     richardcochran@gmail.com, bagasdotme@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next v3] net: ethernet: Simplify bool conversion
Date:   Fri,  4 Nov 2022 14:37:31 +0800
Message-Id: <20221104063731.84008-1-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The result of 'scaled_ppm < 0' is Boolean, and the question mark
expression is redundant, remove it to clear the below warning:

./drivers/net/ethernet/renesas/rcar_gen4_ptp.c:32:40-45: WARNING: conversion to bool not needed here

Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=2729
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---

change in v3:
--According to Richard's suggestion, to preserve reverse Christmas tree order.

 drivers/net/ethernet/renesas/rcar_gen4_ptp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/renesas/rcar_gen4_ptp.c b/drivers/net/ethernet/renesas/rcar_gen4_ptp.c
index c007e33c47e1..0dc80f6bbf94 100644
--- a/drivers/net/ethernet/renesas/rcar_gen4_ptp.c
+++ b/drivers/net/ethernet/renesas/rcar_gen4_ptp.c
@@ -29,8 +29,8 @@ static const struct rcar_gen4_ptp_reg_offset s4_offs = {
 static int rcar_gen4_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 {
 	struct rcar_gen4_ptp_private *ptp_priv = ptp_to_priv(ptp);
-	bool neg_adj = scaled_ppm < 0 ? true : false;
 	s64 addend = ptp_priv->default_addend;
+	bool neg_adj = scaled_ppm < 0;
 	s64 diff;
 
 	if (neg_adj)
-- 
2.20.1.7.g153144c

