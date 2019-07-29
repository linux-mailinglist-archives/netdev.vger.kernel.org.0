Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8793A782E9
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 02:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbfG2Avi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jul 2019 20:51:38 -0400
Received: from gateway30.websitewelcome.com ([192.185.148.2]:23731 "EHLO
        gateway30.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726216AbfG2Avh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jul 2019 20:51:37 -0400
X-Greylist: delayed 1286 seconds by postgrey-1.27 at vger.kernel.org; Sun, 28 Jul 2019 20:51:37 EDT
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
        by gateway30.websitewelcome.com (Postfix) with ESMTP id 1E0273360
        for <netdev@vger.kernel.org>; Sun, 28 Jul 2019 19:30:11 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id rtYJhkcwr2qH7rtYJhn9RX; Sun, 28 Jul 2019 19:30:11 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=aUbewr3BJ25RAJjku2qXb/TH5xCdAT0sVUaiISEs7mo=; b=pYgV+stVXPILhGH4w0k4qGwUnR
        4nlSLwBNHczmz2/c82+w2d1UN5+F4R+mvodG+ethfvGkbqy9cFvMtKThlCAL5is7Gcm1Q6Ao4mmb8
        T15EHgbA0JuMpRdzixbm/wqL6WHztR3TMZI76YRfOyvU1cWY9GwzbavRg7Z1sq34etrZkrUn2kAlO
        kIyrjUyGRGZs6qFkH2rekdT8Uarq5awmYZQ5Ph90Op27n8SzYJ+DgK25z3Hq7rMRnmEiywPY3i9tx
        ccnGS2s/iYXmqQBpIm/Qdz8IlA0atPUfSTwHYPT2T2ThQKPU+sUE7gE/0r9jnDxBCLwadepPp5ktH
        /o63tONQ==;
Received: from [187.192.11.120] (port=40096 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1hrtYH-003zbX-U2; Sun, 28 Jul 2019 19:30:10 -0500
Date:   Sun, 28 Jul 2019 19:30:09 -0500
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Douglas Miller <dougmill@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH] net: ehea: Mark expected switch fall-through
Message-ID: <20190729003009.GA25425@embeddedor>
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
X-Exim-ID: 1hrtYH-003zbX-U2
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [187.192.11.120]:40096
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 51
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mark switch cases where we are expecting to fall through.

This patch fixes the following warning:

drivers/net/ethernet/ibm/ehea/ehea_main.c: In function 'ehea_mem_notifier':
include/linux/printk.h:311:2: warning: this statement may fall through [-Wimplicit-fallthrough=]
  printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/ibm/ehea/ehea_main.c:3253:3: note: in expansion of macro 'pr_info'
   pr_info("memory offlining canceled");
   ^~~~~~~
drivers/net/ethernet/ibm/ehea/ehea_main.c:3256:2: note: here
  case MEM_ONLINE:
  ^~~~

Notice that, in this particular case, the code comment is
modified in accordance with what GCC is expecting to find.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/ethernet/ibm/ehea/ehea_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ehea/ehea_main.c b/drivers/net/ethernet/ibm/ehea/ehea_main.c
index 4138a8480347..cca71ba7a74a 100644
--- a/drivers/net/ethernet/ibm/ehea/ehea_main.c
+++ b/drivers/net/ethernet/ibm/ehea/ehea_main.c
@@ -3251,7 +3251,7 @@ static int ehea_mem_notifier(struct notifier_block *nb,
 	switch (action) {
 	case MEM_CANCEL_OFFLINE:
 		pr_info("memory offlining canceled");
-		/* Fall through: re-add canceled memory block */
+		/* Fall through - re-add canceled memory block */
 
 	case MEM_ONLINE:
 		pr_info("memory is going online");
-- 
2.22.0

