Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DFFE107D62
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 08:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbfKWHNE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 02:13:04 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33857 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbfKWHNE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 02:13:04 -0500
Received: by mail-pf1-f194.google.com with SMTP id n13so4765594pff.1;
        Fri, 22 Nov 2019 23:13:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fgn1btQspzPNoWszEZ1zutZQvRAKTqHp+QsoVcZA6eA=;
        b=uCl6UEQULW+4MCxcdpEcl4zkJEjFsVmdstXpDiwotjY2Modrggfwj3JB/16ADbpnEr
         ms//dUdI5aFWbwp0zwUAYAsngiRzGruDcVmxKZNrhWWFqee2jEbMgvCdu44oabZ/MTUE
         XrSGFRuaIpI/P72cIJmq8GQKqoPDAfWHQX+zCgMoUbPyB4p0tif5sTztLsPVWXYqNB3K
         NzJGvBxABwr3ASY5umII/gu3bOinApnenGqivAEycILxHmQPqmdctajbnpJP2YAHrFSP
         0aQfebTcm5V7ufLe3Or0i5Q0nmYBcjtWNk6I9gOUnafNMDGXS1VYWTgJ7wm+P7+VUrfo
         8lzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fgn1btQspzPNoWszEZ1zutZQvRAKTqHp+QsoVcZA6eA=;
        b=JCEZKomfm5xPL6Nyft5Jd74wdXriU4YK5+qzPlrKXbji8IK1pzh3B8P88So0dsDmkX
         MavVGxJ3ml6HyAKT9yTPttPb2xNyfqGrGMBW4NUBg3aNtRzveifQqoLjdR4zV8LO8Onn
         KGMf5FCMiLrfEQCpRKlI+zhZwoSY24yN0HLRW+KDjfPhf3PekaTH/qTYf1q/au4coJAi
         MXnpI5h2kQYP+1+TmndgRUw1dsh1deF3jOkuYhOCBXQyjUBgYY8z20VLVRfI1ofxJuwt
         W7zMCQxRDC8dIcOqNk4AnwXHS8c/XUu96WF0NtWLozUfy7Q3iVNeXx3Xvf9DGuApGDBH
         O8zQ==
X-Gm-Message-State: APjAAAXpY1JlyLB+ixEFgqreDdAdNREKUlBHI77AErPUol+Na1Ar4kMP
        pgDWF594hL/boXUMQXnRXXfxftd0cILZxA==
X-Google-Smtp-Source: APXvYqyYv2AmthCsKTjg0MJFBs6MHE5glVNxp7zqUbOZgve8O6b+JTTRhp7DJmZ30+RAI1BEWPM69A==
X-Received: by 2002:a63:7c10:: with SMTP id x16mr20089121pgc.176.1574493183232;
        Fri, 22 Nov 2019 23:13:03 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.54.40])
        by smtp.gmail.com with ESMTPSA id 67sm798960pjz.27.2019.11.22.23.12.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2019 23:13:02 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        ecree@solarflare.com, thoiland@redhat.com,
        andrii.nakryiko@gmail.com, tariqt@mellanox.com,
        saeedm@mellanox.com, maximmi@mellanox.com
Subject: [PATCH bpf-next v2 3/6] i40e: start using xdp_call.h
Date:   Sat, 23 Nov 2019 08:12:22 +0100
Message-Id: <20191123071226.6501-4-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191123071226.6501-1-bjorn.topel@gmail.com>
References: <20191123071226.6501-1-bjorn.topel@gmail.com>
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
index 1ccabeafa44c..9fb2ea43d481 100644
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
index d07e1a890428..5c3421f9cc69 100644
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

