Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE88B3E1F04
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 00:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241620AbhHEWwn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 18:52:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230437AbhHEWwm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 18:52:42 -0400
X-Greylist: delayed 1722 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 05 Aug 2021 15:52:27 PDT
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B7A7C0613D5;
        Thu,  5 Aug 2021 15:52:27 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.94.2)
        (envelope-from <daniel@makrotopia.org>)
        id 1mBlm7-00031R-VP; Fri, 06 Aug 2021 00:23:39 +0200
Date:   Thu, 5 Aug 2021 23:23:30 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>, Michael Walle <michael@walle.cc>
Subject: [PATCH] ARM: kirkwood: add missing <linux/if_ether.h> for ETH_ALEN
Message-ID: <YQxk4jrbm31NM1US@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After commit 83216e3988cd1 ("of: net: pass the dst buffer to
of_get_mac_address()") build fails for kirkwood as ETH_ALEN is not
defined.

arch/arm/mach-mvebu/kirkwood.c: In function 'kirkwood_dt_eth_fixup':
arch/arm/mach-mvebu/kirkwood.c:87:13: error: 'ETH_ALEN' undeclared (first use in this function); did you mean 'ESTALE'?
   u8 tmpmac[ETH_ALEN];
             ^~~~~~~~
             ESTALE
arch/arm/mach-mvebu/kirkwood.c:87:13: note: each undeclared identifier is reported only once for each function it appears in
arch/arm/mach-mvebu/kirkwood.c:87:6: warning: unused variable 'tmpmac' [-Wunused-variable]
   u8 tmpmac[ETH_ALEN];
      ^~~~~~
make[5]: *** [scripts/Makefile.build:262: arch/arm/mach-mvebu/kirkwood.o] Error 1
make[5]: *** Waiting for unfinished jobs....

Add missing #include <linux/if_ether.h> to fix this.

Cc: David S. Miller <davem@davemloft.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Michael Walle <michael@walle.cc>
Reported-by: https://buildbot.openwrt.org/master/images/#/builders/56/builds/220/steps/44/logs/stdio
Fixes: 83216e3988cd1 ("of: net: pass the dst buffer to of_get_mac_address()")
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 arch/arm/mach-mvebu/kirkwood.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-mvebu/kirkwood.c b/arch/arm/mach-mvebu/kirkwood.c
index 06b1706595f4c..a493a896e6ee3 100644
--- a/arch/arm/mach-mvebu/kirkwood.c
+++ b/arch/arm/mach-mvebu/kirkwood.c
@@ -14,6 +14,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/mbus.h>
+#include <linux/if_ether.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/of_net.h>
-- 
2.32.0

