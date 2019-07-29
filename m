Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1DB678AA9
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 13:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387682AbfG2LhR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 07:37:17 -0400
Received: from gateway24.websitewelcome.com ([192.185.50.93]:46806 "EHLO
        gateway24.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387467AbfG2LhR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 07:37:17 -0400
X-Greylist: delayed 1434 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Jul 2019 07:37:16 EDT
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway24.websitewelcome.com (Postfix) with ESMTP id 16180F4AE
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 06:13:22 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id s3akhWljY2PzOs3akhcl25; Mon, 29 Jul 2019 06:13:22 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=mIw7cotMP7bnPhy9cmCT7/53nY6tn5T4nfr2XPRnVmo=; b=Gpruoqx8ukF3WMApnznu/Lv5my
        Cx2kRuJAdvtJhke+Txv+zEwe+S5ArlBMCKefIlaQytdb8FpW65E+9A+TBSMLtZFSftQmbxiO3im/m
        S7yQb48Px3pA9AVZaVFt+Vp4024DNSpUZmZoMfmhMXV6posoA1dh7wMjPVkbci+mhZgPwek0mHE4Z
        ZPyd2598dlLruKCMb9Ln2aqXbMUKm3PfvrhfUCQeEnVzOrk99w05F12DptgFAZe7wyMNLXNjEnevc
        tUWpKpTlmteVjLCiNropI+j5pS7l4nI9/lMVlfdkRG+BcSSH0MrbxbLX67bf3xm/BhktSWG/CtPCv
        MOuNs4Qg==;
Received: from [187.192.11.120] (port=46276 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1hs3ai-000CDD-VZ; Mon, 29 Jul 2019 06:13:21 -0500
Date:   Mon, 29 Jul 2019 06:13:20 -0500
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Michael Grzeschik <m.grzeschik@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH] arcnet: com90io: Mark expected switch fall-throughs
Message-ID: <20190729111320.GA3193@embeddedor>
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
X-Exim-ID: 1hs3ai-000CDD-VZ
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [187.192.11.120]:46276
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 15
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mark switch cases where we are expecting to fall through.

This patch fixes the following warnings (Building: powerpc allyesconfig):

drivers/net/arcnet/com90io.c: In function 'com90io_setup':
include/linux/printk.h:304:2: warning: this statement may fall through [-Wimplicit-fallthrough=]
  printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/arcnet/com90io.c:365:3: note: in expansion of macro 'pr_err'
   pr_err("Too many arguments\n");
   ^~~~~~
drivers/net/arcnet/com90io.c:366:2: note: here
  case 2:  /* IRQ */
  ^~~~
drivers/net/arcnet/com90io.c:367:7: warning: this statement may fall through [-Wimplicit-fallthrough=]
   irq = ints[2];
   ~~~~^~~~~~~~~
drivers/net/arcnet/com90io.c:368:2: note: here
  case 1:  /* IO address */
  ^~~~

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/arcnet/com90io.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/arcnet/com90io.c b/drivers/net/arcnet/com90io.c
index 2c546013a980..186bbf87bc84 100644
--- a/drivers/net/arcnet/com90io.c
+++ b/drivers/net/arcnet/com90io.c
@@ -363,8 +363,10 @@ static int __init com90io_setup(char *s)
 	switch (ints[0]) {
 	default:		/* ERROR */
 		pr_err("Too many arguments\n");
+		/* Fall through */
 	case 2:		/* IRQ */
 		irq = ints[2];
+		/* Fall through */
 	case 1:		/* IO address */
 		io = ints[1];
 	}
-- 
2.22.0

