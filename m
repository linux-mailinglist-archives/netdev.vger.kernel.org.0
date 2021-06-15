Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6E63A838B
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 17:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231379AbhFOPGc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 11:06:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58971 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230314AbhFOPGb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 11:06:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623769466;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZxWYziQTh5PhGh5gNlqbhBcg5NmHZI8IP9BRx6C+a+c=;
        b=XB4l3/O/suW1/oQS+SyKUA7b1NJkbodqYf/W19VZ5neF0zlbV3EI72c4x45yqpFslg9zvb
        Dl38up0+kDte/PoD5BgJOvkE+toL8anQxg8yAXyIWXuOHRLKjqWef4p/DjqlU6VqOE95N7
        HPYxPCN6HxlmoRHDk0sKpkoGJxJTiR8=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-543-Llo5XRnTOgymzS7kHHBLbA-1; Tue, 15 Jun 2021 11:04:25 -0400
X-MC-Unique: Llo5XRnTOgymzS7kHHBLbA-1
Received: by mail-ej1-f72.google.com with SMTP id n8-20020a1709067b48b02904171dc68f87so4627286ejo.21
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 08:04:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZxWYziQTh5PhGh5gNlqbhBcg5NmHZI8IP9BRx6C+a+c=;
        b=UFqwgyn9yGk+j39Y2poF0YE7oRcKyvJe/I71HbWl6SMlOZ5A4xqKsJHcClxxHK1JMp
         ZdVA3FsPKKa4xrg9u/sk/tXoLVqKMvGVqwaGNezfNbk8h4E7UYj0MvH5mG0kchB5iqIP
         grHJGGTGkjoqNHh0aPOpcw4BCHhaisprIpYLIosvciTdcu49PBzgRDKUlZY1kmtgxWuH
         rziNuhCvRLuNZFohDTwcy3LrxZdprPS2RLuELhcbZyJ7Z3bOnflUkZ2X82Uwn81vOQK1
         qbmtIlckssO0PiSAXpuwIfDKUvFS4DAFy4Mvv4+NNlAfFjMuyfbbJyqKK2vWPi1bUyhM
         GzVw==
X-Gm-Message-State: AOAM532a5qo8vcd6NqsCoXno5NfjePc3Dc/9yjEGBOtWphYjgqi7zNWA
        l/bXTYmZTKW/ZBKBoH2M/136YpAcqN3svBunwlD6ewuQjxEpX9ZVYJNwzU1pVmVDxM2AqzUhC5e
        0HgnUSZ7c4Hs56uv2
X-Received: by 2002:a17:907:948f:: with SMTP id dm15mr21421653ejc.476.1623769463973;
        Tue, 15 Jun 2021 08:04:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzx2MELp8drUahchRUWbn1SY+20azHa5F2l+fLZOj+MrTocl/HB0ciEMAf412RgNG99qLgGdQ==
X-Received: by 2002:a17:907:948f:: with SMTP id dm15mr21421618ejc.476.1623769463698;
        Tue, 15 Jun 2021 08:04:23 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id u15sm12545189edy.29.2021.06.15.08.04.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 08:04:22 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id EBE61180733; Tue, 15 Jun 2021 16:54:58 +0200 (CEST)
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
Subject: [PATCH bpf-next v2 10/16] mlx4: remove rcu_read_lock() around XDP program invocation
Date:   Tue, 15 Jun 2021 16:54:49 +0200
Message-Id: <20210615145455.564037-11-toke@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210615145455.564037-1-toke@redhat.com>
References: <20210615145455.564037-1-toke@redhat.com>
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
2.31.1

