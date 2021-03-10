Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18AFD333C2D
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 13:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232947AbhCJMFa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 07:05:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232674AbhCJMEv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 07:04:51 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5B02C061760
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 04:04:50 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id mm21so38115642ejb.12
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 04:04:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+ZQfcmHqQXHrh3vzokputHIWJTJ0QWN5/Qo2JLyjqfo=;
        b=re2Tzr+GXNh4Gr7k+qD6kQS5X9Sl6WfY94ShQqLA09db+XZzIiD5cGWPYyejr+WHmn
         QpoIzgYzSLlf+cixfqW/nWtrN3TOVdHSfQ9swmFg2or2WFZpCzaww6Coky1XmGSsA8HG
         cd0iYVTGzIe6Etlui6VxmH3BS1trAvBWqBHMRm7+cDAaSeAIePJP8SdC5bmbUMGy9di7
         wTPubTnhPa5n/aZ30EV/v9Ojzi3s8lGFTofCsifGIu4y6L2gP/Zq9a3StLGRZspPrMWB
         Xlkp2sWUFxlW4HmXU9nSaVaINXYEWc1g6j6PJNKO5JcykgHA7leSrfrqgY3bkzn1DLeV
         axng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+ZQfcmHqQXHrh3vzokputHIWJTJ0QWN5/Qo2JLyjqfo=;
        b=pCyM76WA2ydC8AxNwLZYK2/1IZqoTLeMcYbVI+iZusi1WRnoeUl5uTm/+YIhqOwtUc
         q6TPFZs3yslomkru4r3Pc3aXEaWt/QNCGd/CnkTgq0pPoIZHwxWHuQudgPqz/QdDliEk
         oWdqoS6MY9snBUEGs8LY2iQd5BY5AWUFJNSwEHghRCbjPZsYNhKuwGMRZOe7vU+YnzS6
         6KV/8M/PPtBBEp5Fh8PU09IAWNwbWqixnOY9zonNJhcuFdqJ/g3HAv2oQSK8lh4SAtvJ
         gauwOWwglQiqONWiaip/MnCA87vNEi+RSlQ8LXb172MbuSnb2XbtdDcCo/dRk6s1cCRS
         LNIw==
X-Gm-Message-State: AOAM532aI9uQKHtEOOqVbFfnELsd4BXE5Do7wozGD98YkSSCsKDkrWQm
        ftGeVKshZMXqSutadrndU1wN8Rr3TQA=
X-Google-Smtp-Source: ABdhPJwzvyMusXhRctlojb8CLSdNY2U2y62pS9fcVNOoAZVFDK223yHx+kBR1Pl1cCs9wACsGTKpTg==
X-Received: by 2002:a17:906:2ed1:: with SMTP id s17mr3270588eji.153.1615377889745;
        Wed, 10 Mar 2021 04:04:49 -0800 (PST)
Received: from localhost.localdomain ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id q20sm9913239ejs.41.2021.03.10.04.04.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 04:04:49 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
X-Google-Original-From: Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Alex Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH net-next 10/12] net: enetc: remove forward-declarations of enetc_clean_{rx,tx}_ring
Date:   Wed, 10 Mar 2021 14:03:49 +0200
Message-Id: <20210310120351.542292-11-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210310120351.542292-1-vladimir.oltean@nxp.com>
References: <20210310120351.542292-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch moves the NAPI enetc_poll after enetc_clean_rx_ring such that
we can delete the forward declarations.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 92 ++++++++++----------
 1 file changed, 44 insertions(+), 48 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 3b04d7596d80..ddda16f60df9 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -241,10 +241,6 @@ static irqreturn_t enetc_msix(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-static bool enetc_clean_tx_ring(struct enetc_bdr *tx_ring, int napi_budget);
-static int enetc_clean_rx_ring(struct enetc_bdr *rx_ring,
-			       struct napi_struct *napi, int work_limit);
-
 static void enetc_rx_dim_work(struct work_struct *w)
 {
 	struct dim *dim = container_of(w, struct dim, work);
@@ -273,50 +269,6 @@ static void enetc_rx_net_dim(struct enetc_int_vector *v)
 	net_dim(&v->rx_dim, dim_sample);
 }
 
-static int enetc_poll(struct napi_struct *napi, int budget)
-{
-	struct enetc_int_vector
-		*v = container_of(napi, struct enetc_int_vector, napi);
-	bool complete = true;
-	int work_done;
-	int i;
-
-	enetc_lock_mdio();
-
-	for (i = 0; i < v->count_tx_rings; i++)
-		if (!enetc_clean_tx_ring(&v->tx_ring[i], budget))
-			complete = false;
-
-	work_done = enetc_clean_rx_ring(&v->rx_ring, napi, budget);
-	if (work_done == budget)
-		complete = false;
-	if (work_done)
-		v->rx_napi_work = true;
-
-	if (!complete) {
-		enetc_unlock_mdio();
-		return budget;
-	}
-
-	napi_complete_done(napi, work_done);
-
-	if (likely(v->rx_dim_en))
-		enetc_rx_net_dim(v);
-
-	v->rx_napi_work = false;
-
-	/* enable interrupts */
-	enetc_wr_reg_hot(v->rbier, ENETC_RBIER_RXTIE);
-
-	for_each_set_bit(i, &v->tx_rings_map, ENETC_MAX_NUM_TXQS)
-		enetc_wr_reg_hot(v->tbier_base + ENETC_BDR_OFF(i),
-				 ENETC_TBIER_TXTIE);
-
-	enetc_unlock_mdio();
-
-	return work_done;
-}
-
 static int enetc_bd_ready_count(struct enetc_bdr *tx_ring, int ci)
 {
 	int pi = enetc_rd_reg_hot(tx_ring->tcir) & ENETC_TBCIR_IDX_MASK;
@@ -751,6 +703,50 @@ static int enetc_clean_rx_ring(struct enetc_bdr *rx_ring,
 	return rx_frm_cnt;
 }
 
+static int enetc_poll(struct napi_struct *napi, int budget)
+{
+	struct enetc_int_vector
+		*v = container_of(napi, struct enetc_int_vector, napi);
+	bool complete = true;
+	int work_done;
+	int i;
+
+	enetc_lock_mdio();
+
+	for (i = 0; i < v->count_tx_rings; i++)
+		if (!enetc_clean_tx_ring(&v->tx_ring[i], budget))
+			complete = false;
+
+	work_done = enetc_clean_rx_ring(&v->rx_ring, napi, budget);
+	if (work_done == budget)
+		complete = false;
+	if (work_done)
+		v->rx_napi_work = true;
+
+	if (!complete) {
+		enetc_unlock_mdio();
+		return budget;
+	}
+
+	napi_complete_done(napi, work_done);
+
+	if (likely(v->rx_dim_en))
+		enetc_rx_net_dim(v);
+
+	v->rx_napi_work = false;
+
+	/* enable interrupts */
+	enetc_wr_reg_hot(v->rbier, ENETC_RBIER_RXTIE);
+
+	for_each_set_bit(i, &v->tx_rings_map, ENETC_MAX_NUM_TXQS)
+		enetc_wr_reg_hot(v->tbier_base + ENETC_BDR_OFF(i),
+				 ENETC_TBIER_TXTIE);
+
+	enetc_unlock_mdio();
+
+	return work_done;
+}
+
 /* Probing and Init */
 #define ENETC_MAX_RFS_SIZE 64
 void enetc_get_si_caps(struct enetc_si *si)
-- 
2.25.1

