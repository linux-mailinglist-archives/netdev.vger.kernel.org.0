Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F345423E59
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 15:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238657AbhJFNCv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 09:02:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238644AbhJFNCt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 09:02:49 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 928A4C061749
        for <netdev@vger.kernel.org>; Wed,  6 Oct 2021 06:00:57 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id v18so9505098edc.11
        for <netdev@vger.kernel.org>; Wed, 06 Oct 2021 06:00:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xsveLT33mXd68DjALvlgf8dqdcAb75JbYw2goBIVh7E=;
        b=hgyylsAw/4BsrGUQEQE7jsSJQAs8ug9hebmXn3iZEqckmjOOBnYN2KClSFcPMwbCB5
         u3BSJ4i40AfVzmmFj9KohvSrsB0ArGYA+W1P+l2QETh5GwA0A8Yjuo1bb3tSQhXfWn7j
         DRahYmlZa6R6LEHAVgUXmbI0mxJqJqNu8OaaQZfl06CHAEXLWWzy3RQP0YGgsB06S5SH
         B9gZxf+IV8GNpkzMuR3AOvbWsIcfSzXBI1/fzRAq2BtKgk1bQppK83c8NApGH5J4jVGT
         U3MmOqw701AP06XEcTbZ4Z+jUsBjHfVj4sJ2MtvH9Ja5mzE2Ul+ezmN1fPbraU24IfKP
         adiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xsveLT33mXd68DjALvlgf8dqdcAb75JbYw2goBIVh7E=;
        b=jAfu9BeyYV3xGjU9bk/TXx7EsbFgDDPYsSC40BR5fndsM7ByjPLFL/Y30aaYmscdmF
         JWyaEUSvRmfeCy5erFoKdPb4MjVI7NdLp8+UDQH1tNzICahEnCMn7azQ5Kt+dJswce5L
         yvemmvJcKRRTRzfo/bQz7BAiIghEFaqinYxa2kyfWND94UxJDc95WlbtuKhRXZJ2UhIu
         SN2njldi+DbKNHAB8/0jreksRX1Kojz8AT8l0Pld99fnojjl38sDzjxEXGteSA3LmKx0
         y8RNQ6PwwHseuCRXNd3rakQyytp5qGIBgH2BVsmBtTRAR037X9dWKdMC6FFZ4TRtIj0j
         B0dg==
X-Gm-Message-State: AOAM533/bGKeBVxLdJTi2OVNXeELKjPNvho2F+43ct+4QbJcZXmfSrx+
        izF2qx/2F5a2Ib7ye4kpcpsmxd0b6I8=
X-Google-Smtp-Source: ABdhPJzyXqYekC57WIWn1gvZBwkH494WsJQaOiGnZ73S0rJ1hbtbt4QaRvWn3ecscyXyQvAoadI+tA==
X-Received: by 2002:a17:906:4e4a:: with SMTP id g10mr12554036ejw.524.1633525250086;
        Wed, 06 Oct 2021 06:00:50 -0700 (PDT)
Received: from localhost.localdomain (84-104-224-163.cable.dynamic.v4.ziggo.nl. [84.104.224.163])
        by smtp.gmail.com with ESMTPSA id y16sm194122eds.70.2021.10.06.06.00.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 06:00:49 -0700 (PDT)
From:   Ruud Bos <kernel.hbk@gmail.com>
To:     netdev@vger.kernel.org
Cc:     richardcochran@gmail.com, davem@davemloft.net, kuba@kernel.org,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        Ruud Bos <kernel.hbk@gmail.com>
Subject: [PATCH net-next 4/4] support EXTTS on 82580/i354/i350
Date:   Wed,  6 Oct 2021 14:58:25 +0200
Message-Id: <20211006125825.1383-5-kernel.hbk@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211006125825.1383-1-kernel.hbk@gmail.com>
References: <20211006125825.1383-1-kernel.hbk@gmail.com>
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

