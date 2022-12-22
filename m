Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B43B0653DCB
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 10:58:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235217AbiLVJ63 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 04:58:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234914AbiLVJ61 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 04:58:27 -0500
X-Greylist: delayed 434 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 22 Dec 2022 01:58:24 PST
Received: from fw2.prolan.hu (fw2.prolan.hu [193.68.50.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2242222B0A
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 01:58:23 -0800 (PST)
Received: from imsva.intranet.prolan.hu (imsva.intranet.prolan.hu [10.254.254.252])
        by fw2.prolan.hu (Postfix) with ESMTPS id 8339A7F4A1;
        Thu, 22 Dec 2022 10:51:05 +0100 (CET)
Received: from imsva.intranet.prolan.hu (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6F80B34064;
        Thu, 22 Dec 2022 10:51:05 +0100 (CET)
Received: from imsva.intranet.prolan.hu (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 551143405A;
        Thu, 22 Dec 2022 10:51:05 +0100 (CET)
Received: from fw2.prolan.hu (unknown [10.254.254.253])
        by imsva.intranet.prolan.hu (Postfix) with ESMTPS;
        Thu, 22 Dec 2022 10:51:05 +0100 (CET)
Received: from sinope.intranet.prolan.hu (sinope.intranet.prolan.hu [10.254.0.237])
        by fw2.prolan.hu (Postfix) with ESMTPS id 241E57F4A1;
        Thu, 22 Dec 2022 10:51:05 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=prolan.hu; s=mail;
        t=1671702665; bh=wp6Cfz7F5CMe/uJIUq7yt2fnPBXH7aLtIL9xzk/8v9o=;
        h=From:To:CC:Subject:Date:From;
        b=X5tTH/KSL6dcx4XTws26i9kjwswU7ida0uU/8NRC0DKYt3ZsYT/IW+MD/eh6R1P8I
         fT9jE21VkeGhKrqNrOeK2v7YYwFugZIkHvSB9aQVu9x/q+/LfEvAc09d6DCud+X70m
         9AhwhXmm9TVsq+B2ZOUiMm/0I4a8jncnnm6SSCQhB6/gVjuZeWy999yrSf/+0Uql6g
         Wb/imtEPApqXzLqE1nA+Ee7S2TcQxenBUu9K3yBgmNhOJDQm7FCehAIiBCkNEGgO5u
         UNGqpbRflU/dlG6TfxHJBrcf6M30MJviwKLWVMQ8CDOVeN4sDhcBRRtc3VYSq0KBfT
         uGZrJI+BwQJYA==
Received: from atlas.intranet.prolan.hu (10.254.0.229) by
 sinope.intranet.prolan.hu (10.254.0.237) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P521) id
 15.1.2507.16; Thu, 22 Dec 2022 10:51:04 +0100
Received: from P-01011.intranet.prolan.hu (10.254.7.28) by
 atlas.intranet.prolan.hu (10.254.0.229) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Thu, 22 Dec 2022 10:51:04 +0100
From:   =?UTF-8?q?Cs=C3=B3k=C3=A1s=20Bence?= <csokas.bence@prolan.hu>
To:     <netdev@vger.kernel.org>
CC:     Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <qiangqing.zhang@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>, <kernel@pengutronix.de>,
        =?UTF-8?q?Cs=C3=B3k=C3=A1s=20Bence?= <csokas.bence@prolan.hu>
Subject: [PATCH] net: fec: Refactor: rename `adapter` to `fep`
Date:   Thu, 22 Dec 2022 10:49:52 +0100
Message-ID: <20221222094951.11234-1-csokas.bence@prolan.hu>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ESET-AS: R=OK;S=0;OP=CALC;TIME=1671702664;VERSION=7942;MC=3670990863;TRN=0;CRV=0;IPC=;SP=0;SIPS=0;PI=3;F=0
X-ESET-Antispam: OK
X-EsetResult: clean, is OK
X-EsetId: 37303A29A91EF4576C776A
X-TM-AS-GCONF: 00
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 01b825f reverted a style fix, which renamed
`struct fec_enet_private *adapter` to `fep` to match
the rest of the driver. This commit factors out
that style fix.

Signed-off-by: Csókás Bence <csokas.bence@prolan.hu>
---
 drivers/net/ethernet/freescale/fec_ptp.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
index ab86bb8562ef..afc658d2c271 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -443,21 +443,21 @@ static int fec_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
  */
 static int fec_ptp_gettime(struct ptp_clock_info *ptp, struct timespec64 *ts)
 {
-	struct fec_enet_private *adapter =
+	struct fec_enet_private *fep =
 	    container_of(ptp, struct fec_enet_private, ptp_caps);
 	u64 ns;
 	unsigned long flags;
 
-	mutex_lock(&adapter->ptp_clk_mutex);
+	mutex_lock(&fep->ptp_clk_mutex);
 	/* Check the ptp clock */
-	if (!adapter->ptp_clk_on) {
-		mutex_unlock(&adapter->ptp_clk_mutex);
+	if (!fep->ptp_clk_on) {
+		mutex_unlock(&fep->ptp_clk_mutex);
 		return -EINVAL;
 	}
-	spin_lock_irqsave(&adapter->tmreg_lock, flags);
-	ns = timecounter_read(&adapter->tc);
-	spin_unlock_irqrestore(&adapter->tmreg_lock, flags);
-	mutex_unlock(&adapter->ptp_clk_mutex);
+	spin_lock_irqsave(&fep->tmreg_lock, flags);
+	ns = timecounter_read(&fep->tc);
+	spin_unlock_irqrestore(&fep->tmreg_lock, flags);
+	mutex_unlock(&fep->ptp_clk_mutex);
 
 	*ts = ns_to_timespec64(ns);
 
-- 
2.25.1

