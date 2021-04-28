Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E64736D567
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 12:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238803AbhD1KGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 06:06:25 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:48552 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230122AbhD1KGY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 06:06:24 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R571e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UX3bx8O_1619604332;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UX3bx8O_1619604332)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 28 Apr 2021 18:05:38 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     simon.horman@netronome.com
Cc:     kuba@kernel.org, davem@davemloft.net, oss-drivers@netronome.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] nfp: flower: Remove redundant assignment to mask
Date:   Wed, 28 Apr 2021 18:05:30 +0800
Message-Id: <1619604330-122462-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The value stored to mask in the calculations this patch removes is
not used, so the calculation and the assignment can be removed.

Cleans up the following clang-analyzer warning:

drivers/net/ethernet/netronome/nfp/flower/offload.c:1230:3: warning:
Value stored to 'mask' is never read
[clang-analyzer-deadcode.DeadStores].

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/net/ethernet/netronome/nfp/flower/offload.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index e95969c..86e734a 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -1227,7 +1227,6 @@ int nfp_flower_merge_offloaded_flows(struct nfp_app *app,
 				return -EOPNOTSUPP;
 			}
 		ext += size;
-		mask += size;
 	}
 
 	if ((priv->flower_ext_feats & NFP_FL_FEATS_VLAN_QINQ)) {
-- 
1.8.3.1

