Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15F41FBA34
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 21:48:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbfKMUsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 15:48:13 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36577 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726613AbfKMUsM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 15:48:12 -0500
Received: by mail-pg1-f193.google.com with SMTP id k13so2111777pgh.3;
        Wed, 13 Nov 2019 12:48:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+hHPk4MDXZMe1Dt2BSBD6rDj4LAJJcjXpcIlnBfgPIE=;
        b=jbAxRhKPD+dzE/RXQAwYDAmeb56ZOCrSALBy/nONC1+lxemUmySj48nLZ4PcZeYC7A
         N4mUHIwCjRM5Im39WFsCwEVQkNelUvnbtPig8iU5UxkLS+16LN6O/7cPsEtokTJBYtVw
         dywEvFTD+K9WIMZfbtsztNqtLu0l6WtFw6OhpGq8Q1YkM6eMekdau/x3r92DVMNZcsnu
         tTrrVi7H5GYwWKs9njFjjEWt/0acZKSmbXRn+iUW5pvcKvCMtp7QkDuyHop/GAYqCnaC
         gw0pItTXRPx3mw1eosmBH4ps/+BdDMUDGeEWt7PbnI7VIHwe/PrdYQuH6PN72+xYdvo0
         DMUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+hHPk4MDXZMe1Dt2BSBD6rDj4LAJJcjXpcIlnBfgPIE=;
        b=BfpOy2F/RvpLbonl46P5ZSDgUrRXVUVIfLAS5HF6RgnBZDaM/izJnIKB6Lt4DijByA
         ecUPT8jtvaSAuK3DW/tICC5cG1E+CC/KxxqQ8iHDuSF+xhHnSmL9uZJaarMEH58uuJIs
         ZWmRsh2v4Tpl6rwTpsZTFVtSJulTNtCodwP0aw2GQOgWurz++YW5nvLLlhWANF/GU9V3
         RLOFyGMvMWf/fuDKYmk+dTIGuNw9fV7SjImVPrAvElTwlblTTDjB/YQoGCb8001z8HGx
         uelrmk9SY8nDVJENdmsBYqwQbzYOSHTjDFMMHHQpkmIipuUJPWZoAGSa4LdRAC6XDP0s
         eupA==
X-Gm-Message-State: APjAAAXuNb7QqIJfuX4PFRZu+awDVfZbSt5NVnZOD/IX7lFBaX2H/yCF
        juuDErIwEIHIAI84baPpyIX+JirbwzY=
X-Google-Smtp-Source: APXvYqw5ujzcd0PI2MvIwrUQlQSkj2RwmPOvvDtbyHAmP6YBtoyU8rAIngIdtlqLpRPMVz/YxnqzEQ==
X-Received: by 2002:a63:8f5e:: with SMTP id r30mr6060014pgn.146.1573678091285;
        Wed, 13 Nov 2019 12:48:11 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.54.40])
        by smtp.gmail.com with ESMTPSA id g20sm3235861pgk.46.2019.11.13.12.48.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2019 12:48:10 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com
Subject: [RFC PATCH bpf-next 4/4] i40e: start using xdp_call.h
Date:   Wed, 13 Nov 2019 21:47:37 +0100
Message-Id: <20191113204737.31623-5-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113204737.31623-1-bjorn.topel@gmail.com>
References: <20191113204737.31623-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

This commit starts using xdp_call.h and the BPF dispatcher to avoid
the retpoline overhead.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 5 +++++
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 5 ++++-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c  | 5 ++++-
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index b3d7edbb1389..59b530e4198f 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -5,6 +5,7 @@
 #include <linux/of_net.h>
 #include <linux/pci.h>
 #include <linux/bpf.h>
+#include <linux/xdp_call.h>
 
 /* Local includes */
 #include "i40e.h"
@@ -12517,6 +12518,8 @@ static netdev_features_t i40e_features_check(struct sk_buff *skb,
 	return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
 }
 
+DEFINE_XDP_CALL(i40e_xdp_call);
+
 /**
  * i40e_xdp_setup - add/remove an XDP program
  * @vsi: VSI to changed
@@ -12552,6 +12555,8 @@ static int i40e_xdp_setup(struct i40e_vsi *vsi,
 	for (i = 0; i < vsi->num_queue_pairs; i++)
 		WRITE_ONCE(vsi->rx_rings[i]->xdp_prog, vsi->xdp_prog);
 
+	xdp_call_update(i40e_xdp_call, old_prog, prog);
+
 	if (old_prog)
 		bpf_prog_put(old_prog);
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index b8496037ef7f..34d7b15897a1 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -3,6 +3,7 @@
 
 #include <linux/prefetch.h>
 #include <linux/bpf_trace.h>
+#include <linux/xdp_call.h>
 #include <net/xdp.h>
 #include "i40e.h"
 #include "i40e_trace.h"
@@ -2188,6 +2189,8 @@ int i40e_xmit_xdp_tx_ring(struct xdp_buff *xdp, struct i40e_ring *xdp_ring)
 	return i40e_xmit_xdp_ring(xdpf, xdp_ring);
 }
 
+DECLARE_XDP_CALL(i40e_xdp_call);
+
 /**
  * i40e_run_xdp - run an XDP program
  * @rx_ring: Rx ring being processed
@@ -2209,7 +2212,7 @@ static struct sk_buff *i40e_run_xdp(struct i40e_ring *rx_ring,
 
 	prefetchw(xdp->data_hard_start); /* xdp_frame write */
 
-	act = bpf_prog_run_xdp(xdp_prog, xdp);
+	act = xdp_call_run(i40e_xdp_call, xdp_prog, xdp);
 	switch (act) {
 	case XDP_PASS:
 		break;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index a05dfecdd9b4..c623eeaeb625 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -2,6 +2,7 @@
 /* Copyright(c) 2018 Intel Corporation. */
 
 #include <linux/bpf_trace.h>
+#include <linux/xdp_call.h>
 #include <net/xdp_sock.h>
 #include <net/xdp.h>
 
@@ -179,6 +180,8 @@ int i40e_xsk_umem_setup(struct i40e_vsi *vsi, struct xdp_umem *umem,
 		i40e_xsk_umem_disable(vsi, qid);
 }
 
+DECLARE_XDP_CALL(i40e_xdp_call);
+
 /**
  * i40e_run_xdp_zc - Executes an XDP program on an xdp_buff
  * @rx_ring: Rx ring
@@ -202,7 +205,7 @@ static int i40e_run_xdp_zc(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
 	 * this path is enabled by setting an XDP program.
 	 */
 	xdp_prog = READ_ONCE(rx_ring->xdp_prog);
-	act = bpf_prog_run_xdp(xdp_prog, xdp);
+	act = xdp_call_run(i40e_xdp_call, xdp_prog, xdp);
 	offset = xdp->data - xdp->data_hard_start;
 
 	xdp->handle = xsk_umem_adjust_offset(umem, xdp->handle, offset);
-- 
2.20.1

