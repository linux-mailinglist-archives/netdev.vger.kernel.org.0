Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB2C33507DC
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 22:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236480AbhCaUJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 16:09:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236446AbhCaUJW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 16:09:22 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24E81C061574;
        Wed, 31 Mar 2021 13:09:21 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id jy13so31954173ejc.2;
        Wed, 31 Mar 2021 13:09:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UlZF2RiwQrVHV4FQBT2dG//zwt4SH4LuMoq2pLPHFeE=;
        b=GCvW6t18xTyZObixFkBwYVSJBKH2cpt9FYHwsGlhVxIoYRcfdoHbDt2KP9EYOyX9AR
         j9Hh8o3LU0RPeKho1RipyKYM7XKO9s89avFqb8Tbw9HnLo9k8t3PCWUn36WtVqAP609f
         Y95AFm/2R8eF+utnT8frDArcKjS8O+GRZ6SMIao9r5AZss11SLX/UBPZsFeBGPwBbGFo
         m5AP/eIJiwb0IJg+nANRAiW5TDJwWUzbZhoFbrChTg2d22kSCW2kIeZyKJ9JXJUq1Iai
         sTz72NHpBfsCoIC8vCIkiRUL8j4WkPr5jfHzjCMH3H4rtJZoAQcDJY8jjwyyPbuDq07b
         CSpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UlZF2RiwQrVHV4FQBT2dG//zwt4SH4LuMoq2pLPHFeE=;
        b=gf0pwoCVlNVxvjx9FqipHjvG2zO1gXxFBDYZubj9Jcjx/fOViNQL0abV+FVw+0G7cP
         tj2uHJH1fodptwkLjmOtNnMTsSgddcJeVcJYgNv9BQ02du1QZdZCQiWAvn2OBfz2MnwE
         ke1iELL2tXL4fcMUGgqwhHIBaWdAHutrIivWDrFkqDeGxy1WLVGGGxQMIpRXS3t2FJZv
         FDDMGDMIiTOWLMpHttfGKKCI8gCj0DNpf2pyuIbBdSEYpychG4zieUE4vnWtgx07SLjH
         hZBz3QKiQQfjSfWSlKmVZi2rLKZ9iDyNmpjBaWkzvA531dicmihDgJ8j5aFy/i5eReIF
         /vHA==
X-Gm-Message-State: AOAM530F1Li3tyd7Sh7FnKou3nvKciCiQbg1xAwgRHm82Ne8PinERFSH
        /vkwKFIPOIIrpijHJBaKHHM=
X-Google-Smtp-Source: ABdhPJwQJsO0hfNLAXqNcqoJvlti0VPdPLQ2uuIRspHfgz7+qkuhAswvx0a4bF0z9lUxx5mcrp4bZg==
X-Received: by 2002:a17:906:16ca:: with SMTP id t10mr5603486ejd.85.1617221359881;
        Wed, 31 Mar 2021 13:09:19 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id r19sm1691305ejr.55.2021.03.31.13.09.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 13:09:19 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 5/9] net: enetc: move up enetc_reuse_page and enetc_page_reusable
Date:   Wed, 31 Mar 2021 23:08:53 +0300
Message-Id: <20210331200857.3274425-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210331200857.3274425-1-olteanv@gmail.com>
References: <20210331200857.3274425-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

For XDP_TX, we need to call enetc_reuse_page from enetc_clean_tx_ring,
so we need to avoid a forward declaration.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 38 ++++++++++----------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index ade05518b496..38301d0d7f0c 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -275,6 +275,25 @@ static int enetc_bd_ready_count(struct enetc_bdr *tx_ring, int ci)
 	return pi >= ci ? pi - ci : tx_ring->bd_count - ci + pi;
 }
 
+static bool enetc_page_reusable(struct page *page)
+{
+	return (!page_is_pfmemalloc(page) && page_ref_count(page) == 1);
+}
+
+static void enetc_reuse_page(struct enetc_bdr *rx_ring,
+			     struct enetc_rx_swbd *old)
+{
+	struct enetc_rx_swbd *new;
+
+	new = &rx_ring->rx_swbd[rx_ring->next_to_alloc];
+
+	/* next buf that may reuse a page */
+	enetc_bdr_idx_inc(rx_ring, &rx_ring->next_to_alloc);
+
+	/* copy page reference */
+	*new = *old;
+}
+
 static void enetc_get_tx_tstamp(struct enetc_hw *hw, union enetc_tx_bd *txbd,
 				u64 *tstamp)
 {
@@ -516,25 +535,6 @@ static void enetc_get_offloads(struct enetc_bdr *rx_ring,
 #endif
 }
 
-static bool enetc_page_reusable(struct page *page)
-{
-	return (!page_is_pfmemalloc(page) && page_ref_count(page) == 1);
-}
-
-static void enetc_reuse_page(struct enetc_bdr *rx_ring,
-			     struct enetc_rx_swbd *old)
-{
-	struct enetc_rx_swbd *new;
-
-	new = &rx_ring->rx_swbd[rx_ring->next_to_alloc];
-
-	/* next buf that may reuse a page */
-	enetc_bdr_idx_inc(rx_ring, &rx_ring->next_to_alloc);
-
-	/* copy page reference */
-	*new = *old;
-}
-
 static struct enetc_rx_swbd *enetc_get_rx_buff(struct enetc_bdr *rx_ring,
 					       int i, u16 size)
 {
-- 
2.25.1

