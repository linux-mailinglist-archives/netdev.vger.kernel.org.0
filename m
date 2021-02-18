Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3A4531E6F7
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 08:39:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231204AbhBRHaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 02:30:05 -0500
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:50927 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231175AbhBRHVD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 02:21:03 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UOstHVZ_1613632815;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UOstHVZ_1613632815)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 18 Feb 2021 15:20:17 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     stf_xl@wp.pl
Cc:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] iwlegacy: 4965-mac: Simplify the calculation of variables
Date:   Thu, 18 Feb 2021 15:20:14 +0800
Message-Id: <1613632814-37897-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warnings:

./drivers/net/wireless/intel/iwlegacy/4965-mac.c:2596:54-56: WARNING !A
|| A && B is equivalent to !A || B.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/net/wireless/intel/iwlegacy/4965-mac.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlegacy/4965-mac.c b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
index 28675a4..52db532 100644
--- a/drivers/net/wireless/intel/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
@@ -2593,8 +2593,7 @@ struct il_mod_params il4965_mod_params = {
 	 */
 	if (ret != IL_INVALID_STATION &&
 	    (!(il->stations[ret].used & IL_STA_UCODE_ACTIVE) ||
-	     ((il->stations[ret].used & IL_STA_UCODE_ACTIVE) &&
-	      (il->stations[ret].used & IL_STA_UCODE_INPROGRESS)))) {
+	      (il->stations[ret].used & IL_STA_UCODE_INPROGRESS))) {
 		IL_ERR("Requested station info for sta %d before ready.\n",
 		       ret);
 		ret = IL_INVALID_STATION;
-- 
1.8.3.1

