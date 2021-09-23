Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B169B4162C9
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 18:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242338AbhIWQNF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 12:13:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231743AbhIWQNE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 12:13:04 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2DE9C061574
        for <netdev@vger.kernel.org>; Thu, 23 Sep 2021 09:11:32 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id q81so20144516qke.5
        for <netdev@vger.kernel.org>; Thu, 23 Sep 2021 09:11:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=n5ixhpxm0waokBgCVSXGCN32QeN3+SHbupO5QWNGzHA=;
        b=lM0q9po18QebMSEfFNPztY7TEHX0pQIkK+zuvQVJeYb6Oq+pyUzhCjZiAMLVTM75Z9
         LsWvlK0vGjvUvNPg2B0vI/oWqB35osruMBbsaTRI/+Fb5hGP20O4CHrjD63XdsKrNjt1
         eC0z6nzVTEROzweBFolWvNeX0e6pOkC9b6VQ+wBNwYS+0zbDf4pRO7L9XOgEan3ivCBB
         E64abcBOUaZuzNBxwsetKxMoyfIwToGW5xB8G3S9dtqhyX8yx0oQ4NMA2XZqJpM/uvZr
         LEldMhsgzJDwk/Ng/xIytiso6JLwOliPlCdwlSzFftOyRKbInJ8aMd7ol7Ck1hewrhPI
         5ffw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=n5ixhpxm0waokBgCVSXGCN32QeN3+SHbupO5QWNGzHA=;
        b=pRlf6TUwQFTY/MyKBcDwJI1ZEnLnQyxO038JqfXEaDofhJ7xYik3WZeudnm2Mr8FZn
         voVJmuvs30TIdf+pP49bUnLvJpEcKT5jaWrWLUUseLO1c4wF9Z9TtZbnlIWcKshWkvZr
         scPUmC1j/Ys2MLvkX6+GvAPpb0O2YzoemraBupH5wjaY5fbZ9LchNigMgM9VTou3wXvk
         94kR3DrMYidnsscz6I527cn5th/e4hmiIc5XtpI46Ek5plBw/8NA2hrnW7/G8mPT5LNB
         qlaGTuz4QC6PUohSXqKZyKm7hWowhMepsireAm8rKMOKz3t3tvyi1rDaUw/TLaYUpW+T
         femA==
X-Gm-Message-State: AOAM53025HUj1xUkkFDMxtW9RJnQ/yigpNpulYjfVC4zobZNAmNC6lO9
        z0yoHK/QU1bcXrH7aQN3dgU+8Sw3gAg=
X-Google-Smtp-Source: ABdhPJw4Tb3wdvq/WvtFkRQl+vkTdxgttEW5IaIiNIDcILd9YzylkHgBLb5Q3vI3SJsgWld3l1509A==
X-Received: by 2002:a37:be83:: with SMTP id o125mr3992159qkf.161.1632413491556;
        Thu, 23 Sep 2021 09:11:31 -0700 (PDT)
Received: from vpp.lan (h112.166.20.98.dynamic.ip.windstream.net. [98.20.166.112])
        by smtp.gmail.com with ESMTPSA id s8sm3385922qta.48.2021.09.23.09.11.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 09:11:29 -0700 (PDT)
From:   Joshua Roys <roysjosh@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Joshua Roys <roysjosh@gmail.com>
Subject: [PATCH net-next] net: mlx4: Add support for XDP_REDIRECT
Date:   Thu, 23 Sep 2021 12:10:34 -0400
Message-Id: <20210923161034.18975-1-roysjosh@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Joshua Roys <roysjosh@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx4/en_rx.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

This is a pattern-match commit, based off of the mlx4 XDP_TX and other
drivers' XDP_REDIRECT enablement patches. The goal was to get AF_XDP
working in VPP and this was successful. Tested with a CX3.

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
index 7f6d3b82c29b..557d7daac2d3 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
@@ -669,6 +669,7 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
 	struct bpf_prog *xdp_prog;
 	int cq_ring = cq->ring;
 	bool doorbell_pending;
+	bool xdp_redir_flush;
 	struct mlx4_cqe *cqe;
 	struct xdp_buff xdp;
 	int polled = 0;
@@ -682,6 +683,7 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
 	xdp_prog = rcu_dereference_bh(ring->xdp_prog);
 	xdp_init_buff(&xdp, priv->frag_info[0].frag_stride, &ring->xdp_rxq);
 	doorbell_pending = false;
+	xdp_redir_flush = false;
 
 	/* We assume a 1:1 mapping between CQEs and Rx descriptors, so Rx
 	 * descriptor offset can be deduced from the CQE index instead of
@@ -790,6 +792,14 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
 			switch (act) {
 			case XDP_PASS:
 				break;
+			case XDP_REDIRECT:
+				if (xdp_do_redirect(dev, &xdp, xdp_prog) >= 0) {
+					xdp_redir_flush = true;
+					frags[0].page = NULL;
+					goto next;
+				}
+				trace_xdp_exception(dev, xdp_prog, act);
+				goto xdp_drop_no_cnt;
 			case XDP_TX:
 				if (likely(!mlx4_en_xmit_frame(ring, frags, priv,
 							length, cq_ring,
@@ -897,6 +907,9 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
 			break;
 	}
 
+	if (xdp_redir_flush)
+		xdp_do_flush();
+
 	if (likely(polled)) {
 		if (doorbell_pending) {
 			priv->tx_cq[TX_XDP][cq_ring]->xdp_busy = true;
-- 
2.31.1

