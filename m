Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5E4278A99
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 13:31:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387726AbfG2Lbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 07:31:31 -0400
Received: from gateway20.websitewelcome.com ([192.185.4.169]:12202 "EHLO
        gateway20.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387483AbfG2Lbb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 07:31:31 -0400
X-Greylist: delayed 1293 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Jul 2019 07:31:30 EDT
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway20.websitewelcome.com (Postfix) with ESMTP id 01560400D0050
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 05:06:29 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id s3XQh47UZYTGMs3XQhsDHx; Mon, 29 Jul 2019 06:09:56 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=zBhKVOqNXWjPvhmyDU3NEueaWG9T6eHgUkI6CNjSGOY=; b=iTR36zL883BYvaTP3y/w06lPL6
        xSJ9/fYiJuvPV3dA0UWXZ9svWVBQYmNmB3Kw9G/BPGuP0eki4rzCIMBKb2HL44egwslphkPntAGEl
        zYC9pLwnOS4faKc4Fmph1/NphtiN6jFsIBXqmn3UOUA+yvhj51eb2HEeIUeBl5HL0Dc4l3YJZq8oJ
        pas/yOcUx7SOYrBJSsMlcsldmm2XZFpRkHL/SSu+iBrrQlYcKRjFL6Tk1pRgnebZqeLQiStYvdziJ
        WflbGrlqxG2KhkFj1zb2e4GOcMGSzkqF3V8DqtcqvMoXyuxi+EsBo/dgab6aYEHMgC7pm8xrq7Oqz
        2e4O4QOQ==;
Received: from [187.192.11.120] (port=46260 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1hs3XO-000AJJ-RD; Mon, 29 Jul 2019 06:09:55 -0500
Date:   Mon, 29 Jul 2019 06:09:53 -0500
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Michael Grzeschik <m.grzeschik@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH] arcnet: com90xx: Mark expected switch fall-throughs
Message-ID: <20190729110953.GA3048@embeddedor>
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
X-Exim-ID: 1hs3XO-000AJJ-RD
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [187.192.11.120]:46260
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 9
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mark switch cases where we are expecting to fall through.

This patch fixes the following warnings (Building: powerpc allyesconfig):

drivers/net/arcnet/com90xx.c: In function 'com90xx_setup':
include/linux/printk.h:304:2: warning: this statement may fall through [-Wimplicit-fallthrough=]
  printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/arcnet/com90xx.c:695:3: note: in expansion of macro 'pr_err'
   pr_err("Too many arguments\n");
   ^~~~~~
drivers/net/arcnet/com90xx.c:696:2: note: here
  case 3:  /* Mem address */
  ^~~~
drivers/net/arcnet/com90xx.c:697:9: warning: this statement may fall through [-Wimplicit-fallthrough=]
   shmem = ints[3];
   ~~~~~~^~~~~~~~~
drivers/net/arcnet/com90xx.c:698:2: note: here
  case 2:  /* IRQ */
  ^~~~
drivers/net/arcnet/com90xx.c:699:7: warning: this statement may fall through [-Wimplicit-fallthrough=]
   irq = ints[2];
   ~~~~^~~~~~~~~
drivers/net/arcnet/com90xx.c:700:2: note: here
  case 1:  /* IO address */
  ^~~~

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/arcnet/com90xx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/arcnet/com90xx.c b/drivers/net/arcnet/com90xx.c
index ca4a57c30bf8..bd75d06ad7df 100644
--- a/drivers/net/arcnet/com90xx.c
+++ b/drivers/net/arcnet/com90xx.c
@@ -693,10 +693,13 @@ static int __init com90xx_setup(char *s)
 	switch (ints[0]) {
 	default:		/* ERROR */
 		pr_err("Too many arguments\n");
+		/* Fall through */
 	case 3:		/* Mem address */
 		shmem = ints[3];
+		/* Fall through */
 	case 2:		/* IRQ */
 		irq = ints[2];
+		/* Fall through */
 	case 1:		/* IO address */
 		io = ints[1];
 	}
-- 
2.22.0

