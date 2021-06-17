Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C37B3ABE39
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 23:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231189AbhFQVje (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 17:39:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57291 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229683AbhFQVje (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 17:39:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623965845;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c8O4Yimc+TSjNewaWd3nzsqZvk1ap2sDHxPur5LQuO8=;
        b=E83l7R/Gy7JYnTYle3W79jnwRTZbT8gZhKv8vdc3nyBA3R5nyP797qTZPRUCvuNlBjSuJb
        3sNF/r2LBDAC/ZNN0OPIO86fFDDC8ZuxCWcFNTHHxIat8Zqg4HQkolFSv3YYM4CDzJg7zc
        vsOdD0275yJELZFG4thQv0Zv3dfLG1k=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-187-pyiRdLR3OiGp8WzFXKPy2g-1; Thu, 17 Jun 2021 17:37:24 -0400
X-MC-Unique: pyiRdLR3OiGp8WzFXKPy2g-1
Received: by mail-ed1-f69.google.com with SMTP id g13-20020a056402090db02903935a4cb74fso2419558edz.1
        for <netdev@vger.kernel.org>; Thu, 17 Jun 2021 14:37:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c8O4Yimc+TSjNewaWd3nzsqZvk1ap2sDHxPur5LQuO8=;
        b=sIMQiGq6vq0baHwZTOY57rSkfGG4hLilFZoyXXL9oMnLWBa8LYcFhuKOLH4n6M5Tdx
         2po0JfPzt2GLPil+PSPyk7zGSJlty76IkgN+23znD4lyrwbD7Lu0XPEt4A1cOrS+zyov
         e+IVbjXiQ7wKVPuN9mKw+uOMb9XQa9NXGgsxJFhU7iCpo0clEjw/hRrpe/rTvJP7xjcG
         nBg79mY6+4rnQUWzBO98brVRRKy5Q3crIOjbUNgoR+rX+RR6LGeLDW148QVsWrg+z+9V
         T1MDNcOR+mnBFUa2PT6M51wN6xkXlNCyqNEgKplWV26ubQvy0cIfnceCJeTfLgJMIk54
         b51g==
X-Gm-Message-State: AOAM530Po+D5qLrEcWWsmkWgzC8rwhLMxia5zB+ZlZ7+4+rR7l9ED6xa
        iVaqzfaG56FiSgrsjMScgYJv20Y4Uh7kSo/PifvZoL5hWMRzNtlDarjb5GmnXn2XFhTiaP/ijot
        2HAPEZTAcb2cWG3QU
X-Received: by 2002:a17:906:b857:: with SMTP id ga23mr7467085ejb.296.1623965843566;
        Thu, 17 Jun 2021 14:37:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyncqixvPI2i/r8fEKf9J5GXPyMqsF90pHqtqhIlR+8XIzCseASzejpmol2cBYRKDrxwm28Mg==
X-Received: by 2002:a17:906:b857:: with SMTP id ga23mr7467067ejb.296.1623965843412;
        Thu, 17 Jun 2021 14:37:23 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id cf26sm121229ejb.38.2021.06.17.14.37.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 14:37:22 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B62E9180733; Thu, 17 Jun 2021 23:27:54 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH bpf-next v3 10/16] mlx4: remove rcu_read_lock() around XDP program invocation
Date:   Thu, 17 Jun 2021 23:27:42 +0200
Message-Id: <20210617212748.32456-11-toke@redhat.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210617212748.32456-1-toke@redhat.com>
References: <20210617212748.32456-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mlx4 driver has rcu_read_lock()/rcu_read_unlock() pairs around XDP
program invocations. However, the actual lifetime of the objects referred
by the XDP program invocation is longer, all the way through to the call to
xdp_do_flush(), making the scope of the rcu_read_lock() too small. This
turns out to be harmless because it all happens in a single NAPI poll
cycle (and thus under local_bh_disable()), but it makes the rcu_read_lock()
misleading.

Rather than extend the scope of the rcu_read_lock(), just get rid of it
entirely. With the addition of RCU annotations to the XDP_REDIRECT map
types that take bh execution into account, lockdep even understands this to
be safe, so there's really no reason to keep it around. Also switch the RCU
dereferences in the driver loop itself to the _bh variants.

Cc: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 drivers/net/ethernet/mellanox/mlx4/en_rx.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
index e35e4d7ef4d1..3f08c14d0441 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
@@ -679,9 +679,7 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
 
 	ring = priv->rx_ring[cq_ring];
 
-	/* Protect accesses to: ring->xdp_prog, priv->mac_hash list */
-	rcu_read_lock();
-	xdp_prog = rcu_dereference(ring->xdp_prog);
+	xdp_prog = rcu_dereference_bh(ring->xdp_prog);
 	xdp_init_buff(&xdp, priv->frag_info[0].frag_stride, &ring->xdp_rxq);
 	doorbell_pending = false;
 
@@ -744,7 +742,7 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
 				/* Drop the packet, since HW loopback-ed it */
 				mac_hash = ethh->h_source[MLX4_EN_MAC_HASH_IDX];
 				bucket = &priv->mac_hash[mac_hash];
-				hlist_for_each_entry_rcu(entry, bucket, hlist) {
+				hlist_for_each_entry_rcu_bh(entry, bucket, hlist) {
 					if (ether_addr_equal_64bits(entry->mac,
 								    ethh->h_source))
 						goto next;
@@ -899,8 +897,6 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
 			break;
 	}
 
-	rcu_read_unlock();
-
 	if (likely(polled)) {
 		if (doorbell_pending) {
 			priv->tx_cq[TX_XDP][cq_ring]->xdp_busy = true;
-- 
2.32.0

