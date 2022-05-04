Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F090D519DBF
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 13:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348628AbiEDLUF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 07:20:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236569AbiEDLUE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 07:20:04 -0400
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2A06205FB;
        Wed,  4 May 2022 04:16:25 -0700 (PDT)
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
        by localhost (Postfix) with ESMTP id 4KtZ5h2f9Xz9sT2;
        Wed,  4 May 2022 13:16:24 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
        by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 3OgEBuh8_rtE; Wed,  4 May 2022 13:16:24 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase2.c-s.fr (Postfix) with ESMTP id 4KtZ5h1rF1z9sSD;
        Wed,  4 May 2022 13:16:24 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 2E4EC8B77C;
        Wed,  4 May 2022 13:16:24 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id RxcPznheMaGs; Wed,  4 May 2022 13:16:24 +0200 (CEST)
Received: from PO20335.IDSI0.si.c-s.fr (unknown [172.25.230.108])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 172FE8B763;
        Wed,  4 May 2022 13:16:24 +0200 (CEST)
Received: from PO20335.IDSI0.si.c-s.fr (localhost [127.0.0.1])
        by PO20335.IDSI0.si.c-s.fr (8.17.1/8.16.1) with ESMTPS id 244BGEBg927179
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Wed, 4 May 2022 13:16:14 +0200
Received: (from chleroy@localhost)
        by PO20335.IDSI0.si.c-s.fr (8.17.1/8.17.1/Submit) id 244BGE35927178;
        Wed, 4 May 2022 13:16:14 +0200
X-Authentication-Warning: PO20335.IDSI0.si.c-s.fr: chleroy set sender to christophe.leroy@csgroup.eu using -f
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next v3] sungem: Prepare cleanup of powerpc's asm/prom.h
Date:   Wed,  4 May 2022 13:16:09 +0200
Message-Id: <f7a7fab3ec5edf803d934fca04df22631c2b449d.1651662885.git.christophe.leroy@csgroup.eu>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1651662968; l=2008; s=20211009; h=from:subject:message-id; bh=Luxz3CI0X86f0cpDKOj97aRMoq955XBygd8j9a/N7/U=; b=bOB5uLP2V5q2FWHwutM2/z/oRH3RS+IPj0knXAsREp9/X8XPmnfMzI9wYeMbtryOIedU0tSQ+Ko8 AEU3kjtUDFLPvmXUEKpX4OoidOFqAYHXg33/hg0zdbcBj1cU9CUf
X-Developer-Key: i=christophe.leroy@csgroup.eu; a=ed25519; pk=HIzTzUj91asvincQGOFx6+ZF5AoUuP9GdOtQChs7Mm0=
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

powerpc's <asm/prom.h> includes some headers that it doesn't
need itself.

In order to clean powerpc's <asm/prom.h> up in a further step,
first clean all files that include <asm/prom.h>

sungem_phy.c doesn't use any object provided by <asm/prom.h>.

But removing inclusion of <asm/prom.h> leads to the following
errors:

  CC      drivers/net/sungem_phy.o
drivers/net/sungem_phy.c: In function 'bcm5421_init':
drivers/net/sungem_phy.c:448:42: error: implicit declaration of function 'of_get_parent'; did you mean 'dget_parent'? [-Werror=implicit-function-declaration]
  448 |                 struct device_node *np = of_get_parent(phy->platform_data);
      |                                          ^~~~~~~~~~~~~
      |                                          dget_parent
drivers/net/sungem_phy.c:448:42: warning: initialization of 'struct device_node *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
drivers/net/sungem_phy.c:450:35: error: implicit declaration of function 'of_get_property' [-Werror=implicit-function-declaration]
  450 |                 if (np == NULL || of_get_property(np, "no-autolowpower", NULL))
      |                                   ^~~~~~~~~~~~~~~

Remove <asm/prom.h> from included headers but add <linux/of.h> to
handle the above.

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
---
v3: Make a more specific commit message

v2: More detailed commit description
---
 drivers/net/sungem_phy.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/sungem_phy.c b/drivers/net/sungem_phy.c
index 4daac5fda073..ff22b6b1c686 100644
--- a/drivers/net/sungem_phy.c
+++ b/drivers/net/sungem_phy.c
@@ -29,11 +29,7 @@
 #include <linux/mii.h>
 #include <linux/ethtool.h>
 #include <linux/delay.h>
-
-#ifdef CONFIG_PPC_PMAC
-#include <asm/prom.h>
-#endif
-
+#include <linux/of.h>
 #include <linux/sungem_phy.h>
 
 /* Link modes of the BCM5400 PHY */
-- 
2.35.1

