Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C58F3A1151
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 12:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238981AbhFIKkn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 06:40:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36371 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238460AbhFIKkl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 06:40:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623235127;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=13osPXmV51CM+evqtQb1PXhLMNKO0hGWYKSryosHfNU=;
        b=Ivz5q1qNoNMHmQjOUavQKy32OCgaj3/806mm+5DwrXIcBhik9sHsYOCqRWZ6e1CUfEf99j
        Qniozg6dlb58G5mserf//c2/CnGlBdXhaxdB2rf9UBZXqVpyOEqdj+p9bySfinc0fSnKds
        4/QC3YIW/aomQMmRYUJqrIkT7K7oLT4=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-36-VDcqdq_GMNi6Zc-AAWCHwQ-1; Wed, 09 Jun 2021 06:38:45 -0400
X-MC-Unique: VDcqdq_GMNi6Zc-AAWCHwQ-1
Received: by mail-ed1-f70.google.com with SMTP id x8-20020aa7d3880000b029038fe468f5f4so12135628edq.10
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 03:38:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=13osPXmV51CM+evqtQb1PXhLMNKO0hGWYKSryosHfNU=;
        b=s/bjfO4LNpnWsrvoachV2ZcgoI+4vaQMJRPsmw2yVGArhKvngC2x1ZyOOajqAhvp/t
         Uf1HpHODpPzBaF6Gfpz72kI2jP/i91Gj4xK3EPE8P6NB/b22OiRHJTqkDpzsviIxDhTu
         6VIkXMas+AN7uP4ax8py/WGhtQAAU5fczFbKJ2tNi8RW+krvhBQmoNF28Az63a+/bCKu
         142N17b0lm7eYamFSKbNYNOWfuExTM5yjy4Bnsv8Bbp1ul6Lxq8C8mgwBIQxZ0Tv2IXh
         qugLAkXDjfdYTjfabzY24GiVRjdywFj5maRpuzMIccDPFihLnkSALme7DBgdo+2hMlLz
         4vpQ==
X-Gm-Message-State: AOAM5302zBbuungOJwENkuiT4ede2Vg/vlU+GyffIzUgaOlsJgkJ2bgM
        aB9Ic9RdDr7veJ0nmmuyOWdrdflbssIoeNl6xBQXuI49J60/9crtFpZEBSOrd8TDRf3jNCNjI2U
        DtvasKqZ36IXJ68Z8
X-Received: by 2002:a17:907:270c:: with SMTP id w12mr28462792ejk.175.1623235124381;
        Wed, 09 Jun 2021 03:38:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx9e5nyoFDDTAOzGAf14fh0+8uA9uZPhafO8NuCa6RdoAIPeTeu87RD7Wd8bQzzXvdc4Qhuag==
X-Received: by 2002:a17:907:270c:: with SMTP id w12mr28462775ejk.175.1623235124029;
        Wed, 09 Jun 2021 03:38:44 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id dh18sm966980edb.92.2021.06.09.03.38.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 03:38:43 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id BFE8A18072F; Wed,  9 Jun 2021 12:33:30 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH bpf-next 11/17] mlx4: remove rcu_read_lock() around XDP program invocation
Date:   Wed,  9 Jun 2021 12:33:20 +0200
Message-Id: <20210609103326.278782-12-toke@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210609103326.278782-1-toke@redhat.com>
References: <20210609103326.278782-1-toke@redhat.com>
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

