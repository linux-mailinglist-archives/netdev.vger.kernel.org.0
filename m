Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35F574B5FCE
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 02:09:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232107AbiBOBJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 20:09:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230031AbiBOBJ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 20:09:29 -0500
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A32DF3F89C;
        Mon, 14 Feb 2022 17:09:18 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V4VOvy5_1644887355;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0V4VOvy5_1644887355)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 15 Feb 2022 09:09:16 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     kuba@kernel.org
Cc:     davem@davemloft.net, ioana.ciornei@nxp.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next] dpaa2-eth: Simplify bool conversion
Date:   Tue, 15 Feb 2022 09:09:13 +0800
Message-Id: <20220215010913.114395-1-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warnings:
./drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c:1199:42-47: WARNING:
conversion to bool not needed here
./drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c:1218:54-59: WARNING:
conversion to bool not needed here

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index c4a48e6f1758..3e709c8fb961 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -1196,7 +1196,7 @@ static int dpaa2_eth_build_gso_fd(struct dpaa2_eth_priv *priv,
 		/* Setup the SG entry for the header */
 		dpaa2_sg_set_addr(sgt, tso_hdr_dma);
 		dpaa2_sg_set_len(sgt, hdr_len);
-		dpaa2_sg_set_final(sgt, data_left > 0 ? false : true);
+		dpaa2_sg_set_final(sgt, data_left <= 0);
 
 		/* Compose the SG entries for each fragment of data */
 		num_sge = 1;
@@ -1215,7 +1215,7 @@ static int dpaa2_eth_build_gso_fd(struct dpaa2_eth_priv *priv,
 			}
 			dpaa2_sg_set_addr(sgt, addr);
 			dpaa2_sg_set_len(sgt, size);
-			dpaa2_sg_set_final(sgt, size == data_left ? true : false);
+			dpaa2_sg_set_final(sgt, size == data_left);
 
 			num_sge++;
 
-- 
2.20.1.7.g153144c

