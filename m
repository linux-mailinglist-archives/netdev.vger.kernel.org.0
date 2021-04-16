Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 858F1362A37
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 23:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344372AbhDPVYF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 17:24:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344362AbhDPVYE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 17:24:04 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 086ABC061574
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 14:23:39 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id d10so20024846pgf.12
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 14:23:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OvULFiWeHUEKUeh9RQ3kpfHIvoTEp9Y6vWcG+2NW++U=;
        b=UfAuHMBbYbJR8ZLVAUeH3kbHblYmqQ4Dds/6s4+TF7/vCvq7MM4MpMSPHBPCJljAAL
         jXVMYIERqTKlhKpJc4aPcNCffFVXqjSoFtMN5uc1ZgRj6l/l56f8cF/RC1irYEcxSFVo
         LlIuaP0UCfg4uOL7KsOyA0zzTVikmZp3EHDRa7PVnokdE2gkTOn7KAleiUIuezjNe986
         AHi+nANdypeV/9vJdVqMqwt+/z1St64n6Njvw7rxXmcapE4RBvUIVDngtb4AA3HS8aer
         44kDWBl86+kYDi1Uv8OCniwuKA4TpqLyCBGnSA65jGPXXCEFluxB02RyNK5wh7GSSPdT
         6mKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OvULFiWeHUEKUeh9RQ3kpfHIvoTEp9Y6vWcG+2NW++U=;
        b=keGIzoq7bcqFaG71JfMbGFWGpwq3RUXP9ssty0vvfG91CBTKvdKU+Jy83Vtg6liUJ6
         iSL2ZpE9k85TLINIMWpyTMr9J6W7DWTbM6TB4J2H8tIT3ZrNkvt4wuxhn1CFrWRLPair
         6K35wVw/wpKwjrnAXzJ5TCDxXIKUvbEFMrtZ1Or1Djxdn7RjX2j+kmIA0WtW1CNsYgg4
         yKn3YgSJ/KCHVOxArvjm4SIAjH/9pBOua0JZgyrjFeKTgnBK5yggpZljevPwt4J/8v4e
         8vAoucqZ5qQGCX6sTV8Jc0A7vokAVlhJTNGwD4FKYjnl06ZZ7l9vxr8YAh7cZb5FakwF
         ZiHg==
X-Gm-Message-State: AOAM533a8LRW12Jd/0HMa/80udUHOspdqPP55lemjewIRXqMZjO5TwEZ
        Jm8xYCG711tlan2fO/nW8fo=
X-Google-Smtp-Source: ABdhPJzsSZHauzWyaLX5zwoWT6K9/fIp+1AAvkuGqJvhpORSHxxw52eE+a7xR4+oAe4mBQ0Xa3rBIA==
X-Received: by 2002:a62:3201:0:b029:211:3dcc:c9ca with SMTP id y1-20020a6232010000b02902113dccc9camr9553567pfy.46.1618608218581;
        Fri, 16 Apr 2021 14:23:38 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id t23sm6069132pju.15.2021.04.16.14.23.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 14:23:38 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Po Liu <po.liu@nxp.com>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 07/10] net: enetc: use dedicated TX rings for XDP
Date:   Sat, 17 Apr 2021 00:22:22 +0300
Message-Id: <20210416212225.3576792-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210416212225.3576792-1-olteanv@gmail.com>
References: <20210416212225.3576792-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

It is possible for one CPU to perform TX hashing (see netdev_pick_tx)
between the 8 ENETC TX rings, and the TX hashing to select TX queue 1.

At the same time, it is possible for the other CPU to already use TX
ring 1 for XDP (either XDP_TX or XDP_REDIRECT). Since there is no mutual
exclusion between XDP and the network stack, we run into an issue
because the ENETC TX procedure is not reentrant.

The obvious approach would be to just make XDP take the lock of the
network stack's TX queue corresponding to the ring it's about to enqueue
in.

For XDP_REDIRECT, this is quite straightforward, a lock at the beginning
and end of enetc_xdp_xmit() should do the trick.

But for XDP_TX, it's a bit more complicated. For one, we do TX batching
all by ourselves for frames with the XDP_TX verdict. This is something
we would like to keep the way it is, for performance reasons. But
batching means that the network stack's lock should be kept from the
first enqueued XDP_TX frame and until we ring the doorbell. That is
mostly fine, except for cases when in the same NAPI loop we have mixed
XDP_TX and XDP_REDIRECT frames. So if enetc_xdp_xmit() gets called while
we are holding the lock from the RX NAPI, then bam, deadlock. The naive
answer could be 'just flush the XDP_TX frames first, then release the
network stack's TX queue lock, then call xdp_do_flush_map()'. But even
xdp_do_redirect() is capable of flushing the batched XDP_REDIRECT
frames, so unless we unlock/relock the TX queue around xdp_do_redirect(),
there simply isn't any clean way to protect XDP_TX from concurrent
network stack .ndo_start_xmit() on another CPU.

So we need to take a different approach, and that is to reserve two
rings for the sole use of XDP. We leave TX rings
0..ndev->real_num_tx_queues-1 to be handled by the network stack, and we
pick them from the end of the priv->tx_ring array.

We make an effort to keep the mapping done by enetc_alloc_msix() which
decides which CPU handles the TX completions of which TX ring in its
NAPI poll. So the XDP TX ring of CPU 0 is handled by TX ring 6, and the
XDP TX ring of CPU 1 is handled by TX ring 7.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 46 +++++++++++++++++---
 drivers/net/ethernet/freescale/enetc/enetc.h |  1 +
 2 files changed, 40 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index c7b940979314..56190d861bb9 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -9,6 +9,26 @@
 #include <linux/ptp_classify.h>
 #include <net/pkt_sched.h>
 
+static int enetc_num_stack_tx_queues(struct enetc_ndev_priv *priv)
+{
+	int num_tx_rings = priv->num_tx_rings;
+	int i;
+
+	for (i = 0; i < priv->num_rx_rings; i++)
+		if (priv->rx_ring[i]->xdp.prog)
+			return num_tx_rings - num_possible_cpus();
+
+	return num_tx_rings;
+}
+
+static struct enetc_bdr *enetc_rx_ring_from_xdp_tx_ring(struct enetc_ndev_priv *priv,
+							struct enetc_bdr *tx_ring)
+{
+	int index = &priv->tx_ring[tx_ring->index] - priv->xdp_tx_ring;
+
+	return priv->rx_ring[index];
+}
+
 static struct sk_buff *enetc_tx_swbd_get_skb(struct enetc_tx_swbd *tx_swbd)
 {
 	if (tx_swbd->is_xdp_tx || tx_swbd->is_xdp_redirect)
@@ -468,7 +488,6 @@ static void enetc_recycle_xdp_tx_buff(struct enetc_bdr *tx_ring,
 				      struct enetc_tx_swbd *tx_swbd)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(tx_ring->ndev);
-	struct enetc_bdr *rx_ring = priv->rx_ring[tx_ring->index];
 	struct enetc_rx_swbd rx_swbd = {
 		.dma = tx_swbd->dma,
 		.page = tx_swbd->page,
@@ -476,6 +495,9 @@ static void enetc_recycle_xdp_tx_buff(struct enetc_bdr *tx_ring,
 		.dir = tx_swbd->dir,
 		.len = tx_swbd->len,
 	};
+	struct enetc_bdr *rx_ring;
+
+	rx_ring = enetc_rx_ring_from_xdp_tx_ring(priv, tx_ring);
 
 	if (likely(enetc_swbd_unused(rx_ring))) {
 		enetc_reuse_page(rx_ring, &rx_swbd);
@@ -1059,7 +1081,7 @@ int enetc_xdp_xmit(struct net_device *ndev, int num_frames,
 	int xdp_tx_bd_cnt, i, k;
 	int xdp_tx_frm_cnt = 0;
 
-	tx_ring = priv->tx_ring[smp_processor_id()];
+	tx_ring = priv->xdp_tx_ring[smp_processor_id()];
 
 	prefetchw(ENETC_TXBD(*tx_ring, tx_ring->next_to_use));
 
@@ -1221,8 +1243,8 @@ static int enetc_clean_rx_ring_xdp(struct enetc_bdr *rx_ring,
 	int xdp_tx_bd_cnt, xdp_tx_frm_cnt = 0, xdp_redirect_frm_cnt = 0;
 	struct enetc_tx_swbd xdp_tx_arr[ENETC_MAX_SKB_FRAGS] = {0};
 	struct enetc_ndev_priv *priv = netdev_priv(rx_ring->ndev);
-	struct enetc_bdr *tx_ring = priv->tx_ring[rx_ring->index];
 	int rx_frm_cnt = 0, rx_byte_cnt = 0;
+	struct enetc_bdr *tx_ring;
 	int cleaned_cnt, i;
 	u32 xdp_act;
 
@@ -1280,6 +1302,7 @@ static int enetc_clean_rx_ring_xdp(struct enetc_bdr *rx_ring,
 			napi_gro_receive(napi, skb);
 			break;
 		case XDP_TX:
+			tx_ring = priv->xdp_tx_ring[rx_ring->index];
 			xdp_tx_bd_cnt = enetc_rx_swbd_to_xdp_tx_swbd(xdp_tx_arr,
 								     rx_ring,
 								     orig_i, i);
@@ -2022,6 +2045,7 @@ void enetc_start(struct net_device *ndev)
 int enetc_open(struct net_device *ndev)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+	int num_stack_tx_queues;
 	int err;
 
 	err = enetc_setup_irqs(priv);
@@ -2040,7 +2064,9 @@ int enetc_open(struct net_device *ndev)
 	if (err)
 		goto err_alloc_rx;
 
-	err = netif_set_real_num_tx_queues(ndev, priv->num_tx_rings);
+	num_stack_tx_queues = enetc_num_stack_tx_queues(priv);
+
+	err = netif_set_real_num_tx_queues(ndev, num_stack_tx_queues);
 	if (err)
 		goto err_set_queues;
 
@@ -2113,15 +2139,17 @@ static int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
 	struct tc_mqprio_qopt *mqprio = type_data;
 	struct enetc_bdr *tx_ring;
+	int num_stack_tx_queues;
 	u8 num_tc;
 	int i;
 
+	num_stack_tx_queues = enetc_num_stack_tx_queues(priv);
 	mqprio->hw = TC_MQPRIO_HW_OFFLOAD_TCS;
 	num_tc = mqprio->num_tc;
 
 	if (!num_tc) {
 		netdev_reset_tc(ndev);
-		netif_set_real_num_tx_queues(ndev, priv->num_tx_rings);
+		netif_set_real_num_tx_queues(ndev, num_stack_tx_queues);
 
 		/* Reset all ring priorities to 0 */
 		for (i = 0; i < priv->num_tx_rings; i++) {
@@ -2133,7 +2161,7 @@ static int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
 	}
 
 	/* Check if we have enough BD rings available to accommodate all TCs */
-	if (num_tc > priv->num_tx_rings) {
+	if (num_tc > num_stack_tx_queues) {
 		netdev_err(ndev, "Max %d traffic classes supported\n",
 			   priv->num_tx_rings);
 		return -EINVAL;
@@ -2421,8 +2449,9 @@ int enetc_ioctl(struct net_device *ndev, struct ifreq *rq, int cmd)
 int enetc_alloc_msix(struct enetc_ndev_priv *priv)
 {
 	struct pci_dev *pdev = priv->si->pdev;
-	int v_tx_rings;
+	int first_xdp_tx_ring;
 	int i, n, err, nvec;
+	int v_tx_rings;
 
 	nvec = ENETC_BDR_INT_BASE_IDX + priv->bdr_int_num;
 	/* allocate MSIX for both messaging and Rx/Tx interrupts */
@@ -2497,6 +2526,9 @@ int enetc_alloc_msix(struct enetc_ndev_priv *priv)
 		}
 	}
 
+	first_xdp_tx_ring = priv->num_tx_rings - num_possible_cpus();
+	priv->xdp_tx_ring = &priv->tx_ring[first_xdp_tx_ring];
+
 	return 0;
 
 fail:
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index 6f818e33e03b..3de71669e317 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -317,6 +317,7 @@ struct enetc_ndev_priv {
 
 	u32 speed; /* store speed for compare update pspeed */
 
+	struct enetc_bdr **xdp_tx_ring;
 	struct enetc_bdr *tx_ring[16];
 	struct enetc_bdr *rx_ring[16];
 
-- 
2.25.1

