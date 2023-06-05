Return-Path: <netdev+bounces-7932-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F0A74722270
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 11:45:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9CBF82811FD
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 09:45:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6F3715496;
	Mon,  5 Jun 2023 09:45:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99C2B4432
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 09:45:48 +0000 (UTC)
Received: from fw2.prolan.hu (fw2.prolan.hu [193.68.50.107])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AA8ED2
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 02:45:46 -0700 (PDT)
Received: from proxmox-mailgw.intranet.prolan.hu (localhost.localdomain [127.0.0.1])
	by proxmox-mailgw.intranet.prolan.hu (Proxmox) with ESMTP id 157C7A0545;
	Mon,  5 Jun 2023 11:45:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prolan.hu; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:from:from:message-id:mime-version:reply-to:subject:subject:to
	:to; s=mail; bh=niCoXEjdbXelAJnVy6YtcGMyxsOEvNVEOZItHmSi/Uw=; b=
	OLd2IwY82hW/FcFRTK8kTfOi3PknOzhG6dSW0Y2H7AaDPSE+ibG3WDVzeU+2+oSm
	mOG9J2P6mjxH896rTFqdDMdoM0pGRtz7X0n0YyYYYFN3C4bZ03aIR10TMKpzjFNy
	AEKXeyYpXRpCL1G9D9qpLngajJZRIhNGKHQCIOFoNXt0ng4Joc5tA5kpQf0S4KgA
	arr7J2Ukfq0xnE6edsuwInmi0xOCpuyE00vikt50JZK0DxvtaXXL2yzYoFrtGJND
	FFEFykhT/ndl1GJjhsXWCipOt3idQX9hO1pjxq30MReXCQjc0aKJzhZjiAcsinAu
	gefvYtoQio92afjiqE0wFj4I1NIJkEb1aJqdkZ2t5sKKQjy+dbu9wyG1f5UnT4Zj
	62KBB9qTKrthNZajkMqxQBBa/GdFLpqi6uCBmqbg9MYAiKM2RnWvO4W72iiZqk9D
	gjJKn6uXE9CrKQyBAKEmLfSo5X/dgzwV7WFdR/xjlWUAPD4RqTeyRFqJYdqQdRuX
	cKTB2Ghfu/8utg3YEJjdFoP995G1/OVJ/OyumI7qr3q9K/WNRA5AFaLvvsBPehZA
	YePIWEtcuLPLprHnUSfw9/m+GcU25rLKJUHIyhQeWks/rW+ziPmSVMaTlWTBKQI3
	1KwDj0dYtFwSuUvaJMf4YgzaYimCcVrqSCgsd9wlJ8k=
From: =?UTF-8?q?Cs=C3=B3k=C3=A1s=20Bence?= <csokas.bence@prolan.hu>
To: <netdev@vger.kernel.org>
CC: Richard Cochran <richardcochran@gmail.com>, "David S. Miller"
	<davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
	<qiangqing.zhang@nxp.com>, Andrew Lunn <andrew@lunn.ch>,
	<kernel@pengutronix.de>, =?UTF-8?q?Cs=C3=B3k=C3=A1s=20Bence?=
	<csokas.bence@prolan.hu>
Subject: [PATCH resubmit] net: fec: Refactor: rename `adapter` to `fep`
Date: Mon, 5 Jun 2023 11:44:03 +0200
Message-ID: <20230605094402.85071-1-csokas.bence@prolan.hu>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Received-SPF: Fail (atlas.intranet.prolan.hu: domain of csokas.bence@prolan.hu
 does not designate 10.254.7.28 as permitted sender)
 receiver=atlas.intranet.prolan.hu; client-ip=10.254.7.28;
 helo=P-01011.intranet.prolan.hu;
X-ESET-AS: R=OK;S=0;OP=CALC;TIME=1685958349;VERSION=7954;MC=1783889486;ID=161457;TRN=0;CRV=0;IPC=;SP=0;SIPS=0;PI=3;F=0
X-ESET-Antispam: OK
X-EsetResult: clean, is OK
X-EsetId: 37303A29B0A0C254627165
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

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



