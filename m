Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D72B53FD96B
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 14:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244059AbhIAMSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 08:18:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244051AbhIAMSg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 08:18:36 -0400
Received: from laurent.telenet-ops.be (laurent.telenet-ops.be [IPv6:2a02:1800:110:4::f00:19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1858C061760
        for <netdev@vger.kernel.org>; Wed,  1 Sep 2021 05:17:39 -0700 (PDT)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed20:2193:279a:893d:20ae])
        by laurent.telenet-ops.be with bizsmtp
        id ocHd250011ZidPp01cHd0y; Wed, 01 Sep 2021 14:17:37 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1mLPBQ-0017AR-Ls; Wed, 01 Sep 2021 14:17:36 +0200
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1mLPBQ-00AOXs-6t; Wed, 01 Sep 2021 14:17:36 +0200
From:   Geert Uytterhoeven <geert@linux-m68k.org>
To:     Arnd Bergmann <arnd@arndb.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Sam Creasey <sammy@sammy.net>, netdev@vger.kernel.org,
        linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] net/sun3_82586: Fix return value of sun3_82586_probe()
Date:   Wed,  1 Sep 2021 14:17:35 +0200
Message-Id: <20210901121735.2477588-1-geert@linux-m68k.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

drivers/net/ethernet/i825xx/sun3_82586.c: In function ‘sun3_82586_probe’:
drivers/net/ethernet/i825xx/sun3_82586.c:317:9: warning: returning ‘struct net_device *’ from a function with return type ‘int’ makes integer from pointer without a cast [-Wint-conversion]
  317 |  return dev;
      |         ^~~

The return type of sun3_82586_probe() was changed, but one return value
was forgotten to be updated.

Fixes: e179d78ee11a70e2 ("m68k: remove legacy probing")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/net/ethernet/i825xx/sun3_82586.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/i825xx/sun3_82586.c b/drivers/net/ethernet/i825xx/sun3_82586.c
index 8c57e6e36647e9d3..ec4c5cfe2d68e8ed 100644
--- a/drivers/net/ethernet/i825xx/sun3_82586.c
+++ b/drivers/net/ethernet/i825xx/sun3_82586.c
@@ -314,7 +314,7 @@ static int __init sun3_82586_probe(void)
 	err = register_netdev(dev);
 	if (err)
 		goto out2;
-	return dev;
+	return 0;
 
 out2:
 	release_region(ioaddr, SUN3_82586_TOTAL_SIZE);
-- 
2.25.1

