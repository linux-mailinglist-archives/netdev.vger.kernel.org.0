Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C62523A8363
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 16:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231623AbhFOO51 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 10:57:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42767 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231486AbhFOO5Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 10:57:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623768911;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rY2VfBWw6NJ0/51nfkfzpQbN8Kg/IiRrFOK+qEg2pA4=;
        b=fJGgf0fmYBJ/yu0/oXh4QqvwosS682jmUbvzFLAYILs+04z/ZSo+vIWOx3rQRiOnxmQiHj
        CVePXs21ZwsBkDr+QwU1sRz+RlvDxV8gv0kGFi65fwRtybe/n/qr34v4Mwz7yX8WadHDHb
        GtryHSWYT6U9TJ8tzaEaDSsBnZqB6lQ=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-526-49Q8_mNDMYCUBCAY2mZF5A-1; Tue, 15 Jun 2021 10:55:09 -0400
X-MC-Unique: 49Q8_mNDMYCUBCAY2mZF5A-1
Received: by mail-ed1-f69.google.com with SMTP id s25-20020aa7c5590000b0290392e051b029so17410110edr.11
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 07:55:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rY2VfBWw6NJ0/51nfkfzpQbN8Kg/IiRrFOK+qEg2pA4=;
        b=nw+cegES9CuYA4wIjVZpreTY0+6IavH6unmtR10qHJfOpHwdNsrtZLHIgBBmYR6+gF
         rzoFLAJ3cyAE1ntACGYIf720SqBAnFqvjIgA0hQ8fMHm+zO15RNPthFIe6EDRW8YPLzr
         EZCQE8/7Is5kMNe31KjxKx3nRexWMISR2Wi4XDoNs1AVA2QWi5g1vruMlaN1iqXUzYgB
         4LuTSjVkEVRUJlugSUpX07y1FtCRhTUwNyWG04ZmCqzfxN3KL6+c2Ee7Cqn5Mm7uj5+v
         l8ot0fPh1NLN/1CD+tqHBKXVPChz8hDlu/GfCkO/s54BGWpN0od7hBt3dAxnQI1nGAUY
         FKaQ==
X-Gm-Message-State: AOAM530FhDK5On1m8WAOwz3Jusng9fUlnsySHO0HqQt9YfKDidQFMmtc
        rjq+8UhhIF4V12Q0x4nTIL1NDi2y0A1+R55895HQi/J4cc8pqHUpwE0itJCyHLRb9gJd7PNCY04
        GxsW37cSV0MDCOSwD
X-Received: by 2002:a17:906:dfd1:: with SMTP id jt17mr21253047ejc.486.1623768908510;
        Tue, 15 Jun 2021 07:55:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxUc77COnG0WIdO1tAjDrhLpnKaKhnq5sFxyuzHGltCcw1hnUBlYA0poEo+mX++Ywz8VM61xg==
X-Received: by 2002:a17:906:dfd1:: with SMTP id jt17mr21253020ejc.486.1623768908212;
        Tue, 15 Jun 2021 07:55:08 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id cf26sm10281358ejb.38.2021.06.15.07.55.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 07:55:06 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id E6CA1180732; Tue, 15 Jun 2021 16:54:58 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH bpf-next v2 09/16] marvell: remove rcu_read_lock() around XDP program invocation
Date:   Tue, 15 Jun 2021 16:54:48 +0200
Message-Id: <20210615145455.564037-10-toke@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210615145455.564037-1-toke@redhat.com>
References: <20210615145455.564037-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mvneta and mvpp2 drivers have rcu_read_lock()/rcu_read_unlock() pairs
around XDP program invocations. However, the actual lifetime of the objects
referred by the XDP program invocation is longer, all the way through to
the call to xdp_do_flush(), making the scope of the rcu_read_lock() too
small. This turns out to be harmless because it all happens in a single
NAPI poll cycle (and thus under local_bh_disable()), but it makes the
rcu_read_lock() misleading.

Rather than extend the scope of the rcu_read_lock(), just get rid of it
entirely. With the addition of RCU annotations to the XDP_REDIRECT map
types that take bh execution into account, lockdep even understands this to
be safe, so there's really no reason to keep it around.

Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Cc: Marcin Wojtas <mw@semihalf.com>
Cc: Russell King <linux@armlinux.org.uk>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 drivers/net/ethernet/marvell/mvneta.c           | 6 ++++--
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 8 ++++----
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 7d5cd9bc6c99..c2e9cbebc8d1 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2370,7 +2370,6 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 	/* Get number of received packets */
 	rx_todo = mvneta_rxq_busy_desc_num_get(pp, rxq);
 
-	rcu_read_lock();
 	xdp_prog = READ_ONCE(pp->xdp_prog);
 
 	/* Fairness NAPI loop */
@@ -2421,6 +2420,10 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 			goto next;
 		}
 
+		/* This code is invoked within a single NAPI poll cycle and thus
+		 * under local_bh_disable(), which provides the needed RCU
+		 * protection.
+		 */
 		if (xdp_prog &&
 		    mvneta_run_xdp(pp, rxq, xdp_prog, &xdp_buf, frame_sz, &ps))
 			goto next;
@@ -2448,7 +2451,6 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 		xdp_buf.data_hard_start = NULL;
 		sinfo.nr_frags = 0;
 	}
-	rcu_read_unlock();
 
 	if (xdp_buf.data_hard_start)
 		mvneta_xdp_put_buff(pp, rxq, &xdp_buf, &sinfo, -1);
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index b2259bf1d299..658db1720826 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -3852,8 +3852,6 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 	int rx_done = 0;
 	u32 xdp_ret = 0;
 
-	rcu_read_lock();
-
 	xdp_prog = READ_ONCE(port->xdp_prog);
 
 	/* Get number of received packets and clamp the to-do */
@@ -3925,6 +3923,10 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 					 MVPP2_MH_SIZE + MVPP2_SKB_HEADROOM,
 					 rx_bytes, false);
 
+			/* This code is invoked within a single NAPI poll cycle
+			 * and thus under local_bh_disable(), which provides the
+			 * needed RCU protection.
+			 */
 			ret = mvpp2_run_xdp(port, xdp_prog, &xdp, pp, &ps);
 
 			if (ret) {
@@ -3988,8 +3990,6 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 		mvpp2_bm_pool_put(port, pool, dma_addr, phys_addr);
 	}
 
-	rcu_read_unlock();
-
 	if (xdp_ret & MVPP2_XDP_REDIR)
 		xdp_do_flush_map();
 
-- 
2.31.1

