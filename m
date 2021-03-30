Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB94B34E4C7
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 11:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231426AbhC3Jvx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 05:51:53 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:50148 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231220AbhC3Jvw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 05:51:52 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UTqqc7w_1617097892;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UTqqc7w_1617097892)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 30 Mar 2021 17:51:50 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     paulus@samba.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-ppp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] ppp: deflate: Remove useless call "zlib_inflateEnd"
Date:   Tue, 30 Mar 2021 17:51:30 +0800
Message-Id: <1617097890-27020-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following whitescan warning:

Calling "zlib_inflateEnd(&state->strm)" is only useful for its return
value, which is ignored.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/net/ppp/ppp_deflate.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ppp/ppp_deflate.c b/drivers/net/ppp/ppp_deflate.c
index c457f84..e6d48e5 100644
--- a/drivers/net/ppp/ppp_deflate.c
+++ b/drivers/net/ppp/ppp_deflate.c
@@ -279,7 +279,6 @@ static void z_decomp_free(void *arg)
 	struct ppp_deflate_state *state = (struct ppp_deflate_state *) arg;
 
 	if (state) {
-		zlib_inflateEnd(&state->strm);
 		vfree(state->strm.workspace);
 		kfree(state);
 	}
-- 
1.8.3.1

