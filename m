Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF274F0069
	for <lists+netdev@lfdr.de>; Sat,  2 Apr 2022 12:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343868AbiDBKTY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Apr 2022 06:19:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245212AbiDBKTX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Apr 2022 06:19:23 -0400
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 443DA1A9CA1;
        Sat,  2 Apr 2022 03:17:32 -0700 (PDT)
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
        by localhost (Postfix) with ESMTP id 4KVtJV6xYFz9sSZ;
        Sat,  2 Apr 2022 12:17:30 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
        by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id pu8Do0A9rX-Y; Sat,  2 Apr 2022 12:17:30 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase2.c-s.fr (Postfix) with ESMTP id 4KVtJV6CYbz9sSY;
        Sat,  2 Apr 2022 12:17:30 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id BA6748B76D;
        Sat,  2 Apr 2022 12:17:30 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id 1Z9HyIuRztQM; Sat,  2 Apr 2022 12:17:30 +0200 (CEST)
Received: from PO20335.IDSI0.si.c-s.fr (unknown [192.168.202.136])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 84C8F8B768;
        Sat,  2 Apr 2022 12:17:30 +0200 (CEST)
Received: from PO20335.IDSI0.si.c-s.fr (localhost [127.0.0.1])
        by PO20335.IDSI0.si.c-s.fr (8.17.1/8.16.1) with ESMTPS id 232AHJLb685017
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Sat, 2 Apr 2022 12:17:19 +0200
Received: (from chleroy@localhost)
        by PO20335.IDSI0.si.c-s.fr (8.17.1/8.17.1/Submit) id 232AHIsU685016;
        Sat, 2 Apr 2022 12:17:18 +0200
X-Authentication-Warning: PO20335.IDSI0.si.c-s.fr: chleroy set sender to christophe.leroy@csgroup.eu using -f
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next] sungem: Prepare cleanup of powerpc's asm/prom.h
Date:   Sat,  2 Apr 2022 12:17:13 +0200
Message-Id: <fa778bf9c0a23df8a9e6fe2e2b20d936bd0a89af.1648833433.git.christophe.leroy@csgroup.eu>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1648894632; l=755; s=20211009; h=from:subject:message-id; bh=9P9V6Pv5hiX1Na4XsdsHt3zj0YkBYgBCqV+2yPXlZ2k=; b=qSjN7zD0KZ/O6iTYUpPx5xKWjmnCoIvCkoCQ/tBsKdpacal4jBZNFB3IfB5FunDN1netmdy6u37p r7dq9YvkAmHluM8vMXwW5WlT5g1G9qVhf4SDDYFjjJeN8HeNs3v0
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

powerpc's asm/prom.h brings some headers that it doesn't
need itself.

In order to clean it up, first add missing headers in
users of asm/prom.h

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
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

