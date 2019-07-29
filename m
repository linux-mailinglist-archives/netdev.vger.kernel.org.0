Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87C8C782E5
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 02:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726271AbfG2AuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jul 2019 20:50:15 -0400
Received: from gateway32.websitewelcome.com ([192.185.145.113]:27104 "EHLO
        gateway32.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726238AbfG2AuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jul 2019 20:50:15 -0400
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway32.websitewelcome.com (Postfix) with ESMTP id 5558C1034E
        for <netdev@vger.kernel.org>; Sun, 28 Jul 2019 19:32:54 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id rtawhRILl2PzOrtawhXOpe; Sun, 28 Jul 2019 19:32:54 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=jsM2jggX28X4Rf3N6HWALVQI3TBcdvqhgj8CBeNFHos=; b=rB+czlHihcm6fnZHM7M1wvFA/j
        Fz96eEIAmbxFRb6sK+q8LAvnlvJ0ORK5bwwZt89pTIMkG/8DyF6NV48kquwxdS6T7EXMGlitLH50j
        8nq37GT5uLfD+xwcFFzD4m9Te1vffD/s9SwYDcgmTcYor+ZVGGxpKzyWj4pyqj/1FbfDYGCn904q0
        Y2uYU9ya/+hsCdd59bSYLLOdmm3ozNrrWJhW7xIFxJuzHjSrN07r2o5j0pkaE5wW2gtoue4t0EM35
        JGs9+Zj3cex28r44D11jcYsVOUEYSLrjP93YKnRAN3h0EdIcM+WCIv03KlkeeWc4LvHFnVR9PK4/g
        jYH96FWg==;
Received: from [187.192.11.120] (port=40114 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1hrtav-0040c6-7s; Sun, 28 Jul 2019 19:32:53 -0500
Date:   Sun, 28 Jul 2019 19:32:51 -0500
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Ishizaki Kou <kou.ishizaki@toshiba.co.jp>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH] net: spider_net: Mark expected switch fall-through
Message-ID: <20190729003251.GA25556@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.192.11.120
X-Source-L: No
X-Exim-ID: 1hrtav-0040c6-7s
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [187.192.11.120]:40114
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 57
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mark switch cases where we are expecting to fall through.

This patch fixes the following warning:

drivers/net/ethernet/toshiba/spider_net.c: In function 'spider_net_release_tx_chain':
drivers/net/ethernet/toshiba/spider_net.c:783:7: warning: this statement may fall through [-Wimplicit-fallthrough=]
    if (!brutal) {
       ^
drivers/net/ethernet/toshiba/spider_net.c:792:3: note: here
   case SPIDER_NET_DESCR_RESPONSE_ERROR:
   ^~~~

Notice that, in this particular case, the code comment is
modified in accordance with what GCC is expecting to find.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/ethernet/toshiba/spider_net.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/toshiba/spider_net.c b/drivers/net/ethernet/toshiba/spider_net.c
index 5b196ebfed49..0f346761a2b2 100644
--- a/drivers/net/ethernet/toshiba/spider_net.c
+++ b/drivers/net/ethernet/toshiba/spider_net.c
@@ -788,6 +788,7 @@ spider_net_release_tx_chain(struct spider_net_card *card, int brutal)
 			/* fallthrough, if we release the descriptors
 			 * brutally (then we don't care about
 			 * SPIDER_NET_DESCR_CARDOWNED) */
+			/* Fall through */
 
 		case SPIDER_NET_DESCR_RESPONSE_ERROR:
 		case SPIDER_NET_DESCR_PROTECTION_ERROR:
-- 
2.22.0

