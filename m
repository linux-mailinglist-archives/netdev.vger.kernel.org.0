Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C69D578AB2
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 13:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387746AbfG2Lj4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 07:39:56 -0400
Received: from gateway31.websitewelcome.com ([192.185.144.97]:38963 "EHLO
        gateway31.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387467AbfG2Lj4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 07:39:56 -0400
X-Greylist: delayed 1443 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Jul 2019 07:39:55 EDT
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway31.websitewelcome.com (Postfix) with ESMTP id 36735633A
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 06:15:52 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id s3dAhWo8I2PzOs3dAhcnPC; Mon, 29 Jul 2019 06:15:52 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=xgyoH9+SUqADYOwrGqi4K+OwBKJnOmwJJ7VGEN9DehY=; b=jebu8mzHO7JvZb82LFr6dukjbw
        ibyshgEOABlBZ2AGgqdvKSJxw/EASjtL7o5wO4w5q9WiXm8NWKiFJApPfDH2ie4Fl86ZI3azfJqL0
        18BpwJzPVMg0q2MTpJinfi1LSjlYEliOn0TFS9WelqisIrRD+ydr8elHDVmXOr00oWfO7gaW0uFPL
        qi2sgo3RTlSBDZDHrtKSMb/ZyfoIT6JRNb9ZaHcZx9AFe2i4+Km9w5O6l8q6NFcrKrLOBTkTmwQ/5
        ICD++a2zmHYK71GxldPX76TYzJOgmy4g6PTAu5m1XhdBLx68f6tSeYdTOYc+KXZi8BLQR7gWeTis2
        Skn0R9OA==;
Received: from [187.192.11.120] (port=46286 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1hs3d9-000DXb-1X; Mon, 29 Jul 2019 06:15:51 -0500
Date:   Mon, 29 Jul 2019 06:15:50 -0500
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Michael Grzeschik <m.grzeschik@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH] arcnet: arc-rimi: Mark expected switch fall-throughs
Message-ID: <20190729111550.GA3327@embeddedor>
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
X-Exim-ID: 1hs3d9-000DXb-1X
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [187.192.11.120]:46286
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 21
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mark switch cases where we are expecting to fall through.

This patch fixes the following warnings (Building: powerpc allyesconfig):

drivers/net/arcnet/arc-rimi.c: In function 'arcrimi_setup':
include/linux/printk.h:304:2: warning: this statement may fall through [-Wimplicit-fallthrough=]
  printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/arcnet/arc-rimi.c:365:3: note: in expansion of macro 'pr_err'
   pr_err("Too many arguments\n");
   ^~~~~~
drivers/net/arcnet/arc-rimi.c:366:2: note: here
  case 3:  /* Node ID */
  ^~~~
drivers/net/arcnet/arc-rimi.c:367:8: warning: this statement may fall through [-Wimplicit-fallthrough=]
   node = ints[3];
   ~~~~~^~~~~~~~~
drivers/net/arcnet/arc-rimi.c:368:2: note: here
  case 2:  /* IRQ */
  ^~~~
drivers/net/arcnet/arc-rimi.c:369:7: warning: this statement may fall through [-Wimplicit-fallthrough=]
   irq = ints[2];
   ~~~~^~~~~~~~~
drivers/net/arcnet/arc-rimi.c:370:2: note: here
  case 1:  /* IO address */
  ^~~~

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/arcnet/arc-rimi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/arcnet/arc-rimi.c b/drivers/net/arcnet/arc-rimi.c
index 11c5bad95226..14a5fb378145 100644
--- a/drivers/net/arcnet/arc-rimi.c
+++ b/drivers/net/arcnet/arc-rimi.c
@@ -363,10 +363,13 @@ static int __init arcrimi_setup(char *s)
 	switch (ints[0]) {
 	default:		/* ERROR */
 		pr_err("Too many arguments\n");
+		/* Fall through */
 	case 3:		/* Node ID */
 		node = ints[3];
+		/* Fall through */
 	case 2:		/* IRQ */
 		irq = ints[2];
+		/* Fall through */
 	case 1:		/* IO address */
 		io = ints[1];
 	}
-- 
2.22.0

