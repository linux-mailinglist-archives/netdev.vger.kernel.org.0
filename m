Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C83D842B8E2
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 09:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238447AbhJMHXG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 03:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238302AbhJMHUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 03:20:11 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58DEBC06174E
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 00:18:06 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id p13so6297940edw.0
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 00:18:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xsveLT33mXd68DjALvlgf8dqdcAb75JbYw2goBIVh7E=;
        b=qmtgf9hiszDDupqmSqM6c6hxJawYddjmhjI+igUWx3ROZvmrX7HwF3T3rLrcZr1z5F
         zm4eJ86jKGesfRTF4qPdhvNBwCXWF4mvQVhZIrqYJhaCS1cmxH/fvcdSGET6l6iccSyp
         IDtLe+uGK+aTXoOMegZeaxXiYIP0fdUh22+PjpDKaBgcQbLd1ZsWX0NaSs6jAwyO/PAK
         fsPgdlmrqK4rZs2EoSYgiAL8ASi412Wx96AWLmmmUzmgUsXNRi3M8fHJRKAIO4D+MFOm
         3jL6NK5zuax60Dsiq9szXV/nOBBQPfmm+WvnZlJatc2oeTSuk85Uh9x3qIjtEK4wAIpz
         L+rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xsveLT33mXd68DjALvlgf8dqdcAb75JbYw2goBIVh7E=;
        b=uIpY64+QIWg+PHkp4oY7nZ3uW/XyO7zfwuP/29tbZ6/gHMYfC2l4Zq9zumRmIjPnD/
         b6fwl+VPjJq6ijANTuKezOmsyEd0e5/2aAoAUuhCRJS/ZGYP89scHlsL+J1al21bku+0
         pg6SCfXXE5f6kmU2e8Pj9zKbVsPaZNtN+jRl0I6O6sqd3N9HSjfg4IeIFU877b+OGfE/
         qpXf9w9YgD48lOUNYne+kjySdG7IBk6nALWUk058qavT7cFStxCVQ0R1iCnQ3x1rpyUT
         p2ifoBIoAg+NN5hdnxSWwkV9PmVZQ8JgEcG8Cgye4M9CooPnNqqJvhda39m0o+UHyU8Y
         eaew==
X-Gm-Message-State: AOAM533pBorbzP/DbhMoUd6aS+w7KBd5Capw7Wn1V05JELbk+4GqR0ZA
        envoN6oCFG4uqvp/p9jWcy4=
X-Google-Smtp-Source: ABdhPJxGv1N+B2QpzyfVQ9AjD9NZ9S+CTYZW6JlgzhPom7waizuMGu/bPltHbE08yBHKPNw8jLiULQ==
X-Received: by 2002:a50:cf0d:: with SMTP id c13mr6988372edk.269.1634109484987;
        Wed, 13 Oct 2021 00:18:04 -0700 (PDT)
Received: from localhost.localdomain (84-104-224-163.cable.dynamic.v4.ziggo.nl. [84.104.224.163])
        by smtp.gmail.com with ESMTPSA id f7sm2935886edl.33.2021.10.13.00.18.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 00:18:04 -0700 (PDT)
From:   Ruud Bos <kernel.hbk@gmail.com>
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, richardcochran@gmail.com,
        davem@davemloft.net, kuba@kernel.org,
        Ruud Bos <kernel.hbk@gmail.com>
Subject: [PATCH net-next RESEND 4/4] igb: support EXTTS on 82580/i354/i350
Date:   Wed, 13 Oct 2021 09:15:31 +0200
Message-Id: <20211013071531.1145-5-kernel.hbk@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211013071531.1145-1-kernel.hbk@gmail.com>
References: <20211013071531.1145-1-kernel.hbk@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support for the EXTTS PTP pin function on 82580/i354/i350 based adapters.
Because the time registers of these adapters do not have the nice split in
second rollovers as the i210 has, the implementation is slightly more
complex compared to the i210 implementation.

Signed-off-by: Ruud Bos <kernel.hbk@gmail.com>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 20 ++++++++++---
 drivers/net/ethernet/intel/igb/igb_ptp.c  | 36 ++++++++++++++++++++++-
 2 files changed, 51 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 5f59c5de7033..30f16cacd972 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -6807,17 +6807,29 @@ static void igb_perout(struct igb_adapter *adapter, int sdp)
 static void igb_extts(struct igb_adapter *adapter, int sdp)
 {
 	struct e1000_hw *hw = &adapter->hw;
-	u32 sec, nsec;
+	int auxstmpl = (sdp == 1) ? E1000_AUXSTMPL1 : E1000_AUXSTMPL0;
+	int auxstmph = (sdp == 1) ? E1000_AUXSTMPH1 : E1000_AUXSTMPH0;
+	struct timespec64 ts;
 	struct ptp_clock_event event;
 
 	if (sdp < 0 || sdp >= IGB_N_EXTTS)
 		return;
 
-	nsec = rd32((sdp == 1) ? E1000_AUXSTMPL1 : E1000_AUXSTMPL0);
-	sec  = rd32((sdp == 1) ? E1000_AUXSTMPH1 : E1000_AUXSTMPH0);
+	if ((hw->mac.type == e1000_82580) ||
+	    (hw->mac.type == e1000_i354) ||
+	    (hw->mac.type == e1000_i350)) {
+		s64 ns = rd32(auxstmpl);
+
+		ns += ((s64)(rd32(auxstmph) & 0xFF)) << 32;
+		ts = ns_to_timespec64(ns);
+	} else {
+		ts.tv_nsec = rd32(auxstmpl);
+		ts.tv_sec  = rd32(auxstmph);
+	}
+
 	event.type = PTP_CLOCK_EXTTS;
 	event.index = sdp;
-	event.timestamp = sec * 1000000000ULL + nsec;
+	event.timestamp = ts.tv_sec * 1000000000ULL + ts.tv_nsec;
 	ptp_clock_event(adapter->ptp_clock, &event);
 }
 
diff --git a/drivers/net/ethernet/intel/igb/igb_ptp.c b/drivers/net/ethernet/intel/igb/igb_ptp.c
index 64a949bb5d8a..bc24295b6b52 100644
--- a/drivers/net/ethernet/intel/igb/igb_ptp.c
+++ b/drivers/net/ethernet/intel/igb/igb_ptp.c
@@ -524,7 +524,41 @@ static int igb_ptp_feature_enable_82580(struct ptp_clock_info *ptp,
 
 	switch (rq->type) {
 	case PTP_CLK_REQ_EXTTS:
-		return -EOPNOTSUPP;
+		/* Reject requests with unsupported flags */
+		if (rq->extts.flags & ~(PTP_ENABLE_FEATURE |
+					PTP_RISING_EDGE |
+					PTP_FALLING_EDGE |
+					PTP_STRICT_FLAGS))
+			return -EOPNOTSUPP;
+
+		if (on) {
+			pin = ptp_find_pin(igb->ptp_clock, PTP_PF_EXTTS,
+					   rq->extts.index);
+			if (pin < 0)
+				return -EBUSY;
+		}
+		if (rq->extts.index == 1) {
+			tsauxc_mask = TSAUXC_EN_TS1;
+			tsim_mask = TSINTR_AUTT1;
+		} else {
+			tsauxc_mask = TSAUXC_EN_TS0;
+			tsim_mask = TSINTR_AUTT0;
+		}
+		spin_lock_irqsave(&igb->tmreg_lock, flags);
+		tsauxc = rd32(E1000_TSAUXC);
+		tsim = rd32(E1000_TSIM);
+		if (on) {
+			igb_pin_extts(igb, rq->extts.index, pin);
+			tsauxc |= tsauxc_mask;
+			tsim |= tsim_mask;
+		} else {
+			tsauxc &= ~tsauxc_mask;
+			tsim &= ~tsim_mask;
+		}
+		wr32(E1000_TSAUXC, tsauxc);
+		wr32(E1000_TSIM, tsim);
+		spin_unlock_irqrestore(&igb->tmreg_lock, flags);
+		return 0;
 
 	case PTP_CLK_REQ_PEROUT:
 		/* Reject requests with unsupported flags */
-- 
2.30.2

