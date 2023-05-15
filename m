Return-Path: <netdev+bounces-2623-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 495D3702BDF
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 13:54:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4A5301C20B45
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 11:54:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35C1EC2F6;
	Mon, 15 May 2023 11:54:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 288EAC139
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 11:54:34 +0000 (UTC)
X-Greylist: delayed 344 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 15 May 2023 04:54:32 PDT
Received: from fw2.prolan.hu (fw2.prolan.hu [193.68.50.107])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35DEB2106
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 04:54:31 -0700 (PDT)
Received: from proxmox-mailgw.intranet.prolan.hu (localhost.localdomain [127.0.0.1])
	by proxmox-mailgw.intranet.prolan.hu (Proxmox) with ESMTP id C41AFA05FA;
	Mon, 15 May 2023 13:48:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prolan.hu; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:from:from:message-id:mime-version:reply-to:subject:subject:to
	:to; s=mail; bh=P/QU8pbY5irfJma64n9feTgQ/RM6KnBuO332VH5WK0o=; b=
	DR9mc32SM+ijRwGUrpBKAiJDf5DisilYzp4Nkvk6sBGKj5pogBhTOr1pMH/ZkZss
	Zao7UmyQ+abVyu3UbQ90j23q9rdrwnWEAz0o2eAOPmWj6kePXSRSKu1mzRVIEuNb
	cVxo4c1Yrj1uHIGg3n6xWkVL4ucD4rSop1/8pblCtEtdGhQldDUnkHtbjwz+GePx
	A1aBlhu9CpWv+mf4AC1kwF/GfRGKeXTBvi8T0DFtHHEwIJV4ofLbORZ2elhbgcdU
	setyRy96qKK2YY1fXqtON3r1R9ihBUjYFhO/GIR4/yx7a1UwFCZT8aywF1sxO/kR
	lMHHWg+KYr3AlxXa3hIvB7MTbApXWVP33V8AgDXsNWNTNrVRMSF/6t8/ssdxIUvF
	tIKAhG/rKYCIJzw2N5ufAvfaDjHVFGlncRv/tZ5fProFCvG08p1OoDixWrUn7Qi2
	FCdf3Ywa4Bum6gJoEd+gp7eiK2ba5h1RqnQjiCGT2nKq/DtmivmBy5/5R6uiiNA4
	bkCJ+3cmoPBA2CnqZDBq3sJViqJbq2ZAm9I9teJEC8fiAG3QYIS8qf9b4MZMDLBC
	qL82dmUuvfEfw6LWfoFmNgzW4kd2qce/sAXZXaahctUPEVK4WBjE8FZWWL7AVUfL
	8yVCQvbv8gb0wL1pKmH5wThsS0+pjVzpp3SD+Deh17E=
Received: from sinope.intranet.prolan.hu (sinope.intranet.prolan.hu [10.254.0.237])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by proxmox-mailgw.intranet.prolan.hu (Proxmox) with ESMTPS id 36470A0487;
	Mon, 15 May 2023 13:48:50 +0200 (CEST)
Received: from atlas.intranet.prolan.hu (10.254.0.229) by
 sinope.intranet.prolan.hu (10.254.0.237) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P521) id
 15.1.2507.23; Mon, 15 May 2023 13:48:50 +0200
Received: from P-01011.intranet.prolan.hu (10.254.7.28) by
 atlas.intranet.prolan.hu (10.254.0.229) with Microsoft SMTP Server id
 15.1.2507.23 via Frontend Transport; Mon, 15 May 2023 13:48:50 +0200
From: =?UTF-8?q?Cs=C3=B3k=C3=A1s=20Bence?= <csokas.bence@prolan.hu>
To: <netdev@vger.kernel.org>
CC: Richard Cochran <richardcochran@gmail.com>, "David S. Miller"
	<davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
	<qiangqing.zhang@nxp.com>, Andrew Lunn <andrew@lunn.ch>,
	<kernel@pengutronix.de>, =?UTF-8?q?Cs=C3=B3k=C3=A1s=20Bence?=
	<csokas.bence@prolan.hu>
Subject: [PATCH] net: fec: Refactor: rename `adapter` to `fep`
Date: Mon, 15 May 2023 13:47:21 +0200
Message-ID: <20230515114721.6420-1-csokas.bence@prolan.hu>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ESET-AS: R=OK;S=0;OP=CALC;TIME=1684151330;VERSION=7953;MC=619065744;ID=315976;TRN=0;CRV=0;IPC=;SP=0;SIPS=0;PI=3;F=0
X-ESET-Antispam: OK
X-EsetResult: clean, is OK
X-EsetId: 37303A2939B8C254607464
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

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



