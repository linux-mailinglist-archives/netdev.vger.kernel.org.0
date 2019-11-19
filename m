Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA3DD1028E9
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 17:08:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728420AbfKSQI3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 11:08:29 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42353 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727509AbfKSQI2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 11:08:28 -0500
Received: by mail-pg1-f195.google.com with SMTP id q17so11555719pgt.9;
        Tue, 19 Nov 2019 08:08:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+hHPk4MDXZMe1Dt2BSBD6rDj4LAJJcjXpcIlnBfgPIE=;
        b=Wgt1YPeae8eLuvi1LEIiW2eqtV6TQRRM2ChIYhhhvcVVCBR62YLbBT5aTeE5ngpuSf
         fNVa3JAQz4LPQcvYKgbskTBQnpNBJshktwzRSAIr/45Eb+sJqMQ6NBiOihi2HYzRwg8s
         dyMPS3d657BP4b6bRpKLBLS2r7SRYsGILxQ+JxUCeJGh6Drf74sZo+Rnm/cLXcpnKQe3
         MqDCB4OqV3G9wHZzCYTZX5kb0YCzNvVRielP3JMvL2ykB+WaqtccYEXPgAQnxmqI+KUq
         qJUdsCHaYnkLiNPwReHQTnqZgWTclrzmB7+B5k75D+r4OzbobuEIFDi/96Egx1hTJn8C
         c8Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+hHPk4MDXZMe1Dt2BSBD6rDj4LAJJcjXpcIlnBfgPIE=;
        b=XAQy4TcEll4Ip6bJJ2jX0lHazo2o6SaWenWrYffOvyrDxxC/msUJ8VNYwfu1uGB8AI
         exLYybG6IqzTmE0dusRCjsjYjqhdXsrgj7bPrMfmocOaf0joNhMysC6h+NZye2moijfE
         18aS0gMO9LVNzmgvIG7wiaVBZSCh3gYgSj/EMlF+hB9gTSDGUZp085LxLpPmRDTNLi0+
         e04vW/eYzUeuFopLX5rZ4sPJgdnYqEg4py58VO6VrbqEgZoSr7SuoAR/G88zQXU6i49y
         G6hbCiAHpT0c0drWTV0+NlQOpxgbcSvYZSeqQ/34xTwVsp8xDZt/l2bZF9++4/hfqRWk
         G47w==
X-Gm-Message-State: APjAAAX0/9gZ91Vsue2oaYGN4PDqV6Ly8QMlZArQA1uT8aOq/REJnsA2
        Ij04RjNyxfMq5qdlzj1MKDzFJkR4S7yTkA==
X-Google-Smtp-Source: APXvYqygOWptp54R9WSYNG8WufP/qVSs84JKhK0pkzVLnNb2j5AfQ4/5iSY4L+ejdn9jFYLvH2IE9Q==
X-Received: by 2002:aa7:9348:: with SMTP id 8mr6632106pfn.135.1574179707595;
        Tue, 19 Nov 2019 08:08:27 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (fmdmzpr04-ext.fm.intel.com. [192.55.55.39])
        by smtp.gmail.com with ESMTPSA id v10sm25196949pfg.11.2019.11.19.08.08.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 08:08:27 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        ecree@solarflare.com, thoiland@redhat.com,
        andrii.nakryiko@gmail.com
Subject: [PATCH bpf-next 3/3] i40e: start using xdp_call.h
Date:   Tue, 19 Nov 2019 17:07:57 +0100
Message-Id: <20191119160757.27714-4-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191119160757.27714-1-bjorn.topel@gmail.com>
References: <20191119160757.27714-1-bjorn.topel@gmail.com>
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

