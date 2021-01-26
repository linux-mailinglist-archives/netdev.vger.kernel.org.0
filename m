Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99EBA304759
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 20:01:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387745AbhAZRGR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 12:06:17 -0500
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:41394 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389726AbhAZIOB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 03:14:01 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=abaci-bugfix@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0UMxk8Ir_1611648784;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:abaci-bugfix@linux.alibaba.com fp:SMTPD_---0UMxk8Ir_1611648784)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 26 Jan 2021 16:13:08 +0800
From:   Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
To:     jiri@resnulli.us
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
Subject: [PATCH] rocker: Simplify the calculation of variables
Date:   Tue, 26 Jan 2021 16:13:03 +0800
Message-Id: <1611648783-3916-1-git-send-email-abaci-bugfix@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warnings:

./drivers/net/ethernet/rocker/rocker_ofdpa.c:926:34-36: WARNING !A || A
&& B is equivalent to !A || B.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
---
 drivers/net/ethernet/rocker/rocker_ofdpa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/rocker/rocker_ofdpa.c b/drivers/net/ethernet/rocker/rocker_ofdpa.c
index 7072b24..e2d5962 100644
--- a/drivers/net/ethernet/rocker/rocker_ofdpa.c
+++ b/drivers/net/ethernet/rocker/rocker_ofdpa.c
@@ -923,7 +923,7 @@ static int ofdpa_flow_tbl_bridge(struct ofdpa_port *ofdpa_port,
 	struct ofdpa_flow_tbl_entry *entry;
 	u32 priority;
 	bool vlan_bridging = !!vlan_id;
-	bool dflt = !eth_dst || (eth_dst && eth_dst_mask);
+	bool dflt = !eth_dst || eth_dst_mask;
 	bool wild = false;
 
 	entry = kzalloc(sizeof(*entry), GFP_ATOMIC);
-- 
1.8.3.1

