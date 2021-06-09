Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA4803A114F
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 12:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238073AbhFIKkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 06:40:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42362 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238384AbhFIKkl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 06:40:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623235126;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jk02ESooGWTSdBozEufWm00wwV1iSla6r5tCLEhagY4=;
        b=XzH+xWCCJYVDHpbJ/uAwC4CxfvVpGLxC4SiDmGk5xjEAcCY7L9htvmbBj7H6BFW+Fx6TXC
        j0HXw9UqG4t82cXW7qaCqXgP/OMWV+/WSqdkGkafTcrTKczBbUJPdqIAWFDjJ1c8TSf/fN
        3VEyk6ki6Z5m71BRDCBvRkA0Qkh4fjc=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-34-V5VlifOGMRCwt-AEJOz8VA-1; Wed, 09 Jun 2021 06:38:45 -0400
X-MC-Unique: V5VlifOGMRCwt-AEJOz8VA-1
Received: by mail-ej1-f70.google.com with SMTP id p18-20020a1709067852b02903dab2a3e1easo7860079ejm.17
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 03:38:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jk02ESooGWTSdBozEufWm00wwV1iSla6r5tCLEhagY4=;
        b=MkPN38t5iwnFYFkQPZzy6Ial1rz4ADqQQ+N4qIv9w92+w3+9xkBmwgppY999SSxL/3
         ViUFv+E5avYQsbMA9/bOxgRJoMCf1Kkoo2ePPivl668SmrL78NAiJzYyCIAVC0g2wJyN
         EWqNcEiaLyqm6o1A3usewHMiureOiroEn1V/cr96OZlS65Gsu3nyZH52np4wmbcAnSZb
         dLCIEsUQqIgNI8MDkHm5ihPXrrwGiRB2C15kn72jrqAUbzGW2x7WHrT2os3ymQQ0EThn
         qL393EmTSU1oXtE0n75Nb8VJlb+/Wankr+PmejCLtDfMeaRvnVjpdaVZ0xXn3Q8ZFRcV
         9i8w==
X-Gm-Message-State: AOAM531Qe5w+CRG7riKhIaTMBsFrw/EH23HQWsqTfic+D78y3RJYdiAy
        Vsf3u1s73U4cz0nCypI43UE8wV9zZBZj2d5zNm2hd67b5H0WMiV8LHTBJiiQNe4c1wONz03VmWs
        NHt5furM2SbT+aqgK
X-Received: by 2002:a17:906:8a55:: with SMTP id gx21mr28306413ejc.179.1623235124153;
        Wed, 09 Jun 2021 03:38:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz8vD1ubOmif6w/i6ZswfYgm1TfNtkHvLNWlj29pRDEzzgimzt9ncLfA52oAlvj9EOHKV8cXw==
X-Received: by 2002:a17:906:8a55:: with SMTP id gx21mr28306386ejc.179.1623235123797;
        Wed, 09 Jun 2021 03:38:43 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id br21sm925884ejb.124.2021.06.09.03.38.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 03:38:43 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id DE3D7180732; Wed,  9 Jun 2021 12:33:30 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>
Subject: [PATCH bpf-next 14/17] sfc: remove rcu_read_lock() around XDP program invocation
Date:   Wed,  9 Jun 2021 12:33:23 +0200
Message-Id: <20210609103326.278782-15-toke@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210609103326.278782-1-toke@redhat.com>
References: <20210609103326.278782-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The sfc driver has rcu_read_lock()/rcu_read_unlock() pairs around XDP
program invocations. However, the actual lifetime of the objects referred
by the XDP program invocation is longer, all the way through to the call to
xdp_do_flush(), making the scope of the rcu_read_lock() too small. This
turns out to be harmless because it all happens in a single NAPI poll
cycle (and thus under local_bh_disable()), but it makes the rcu_read_lock()
misleading.

Rather than extend the scope of the rcu_read_lock(), just get rid of it
entirely. With the addition of RCU annotations to the XDP_REDIRECT map
types that take bh execution into account, lockdep even understands this to
be safe, so there's really no reason to keep it around.

Cc: Edward Cree <ecree.xilinx@gmail.com>
Cc: Martin Habets <habetsm.xilinx@gmail.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 drivers/net/ethernet/sfc/rx.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/sfc/rx.c b/drivers/net/ethernet/sfc/rx.c
index 17b8119c48e5..606750938b89 100644
--- a/drivers/net/ethernet/sfc/rx.c
+++ b/drivers/net/ethernet/sfc/rx.c
@@ -260,18 +260,14 @@ static bool efx_do_xdp(struct efx_nic *efx, struct efx_channel *channel,
 	s16 offset;
 	int err;
 
-	rcu_read_lock();
-	xdp_prog = rcu_dereference(efx->xdp_prog);
-	if (!xdp_prog) {
-		rcu_read_unlock();
+	xdp_prog = rcu_dereference_bh(efx->xdp_prog);
+	if (!xdp_prog)
 		return true;
-	}
 
 	rx_queue = efx_channel_get_rx_queue(channel);
 
 	if (unlikely(channel->rx_pkt_n_frags > 1)) {
 		/* We can't do XDP on fragmented packets - drop. */
-		rcu_read_unlock();
 		efx_free_rx_buffers(rx_queue, rx_buf,
 				    channel->rx_pkt_n_frags);
 		if (net_ratelimit())
@@ -296,7 +292,6 @@ static bool efx_do_xdp(struct efx_nic *efx, struct efx_channel *channel,
 			 rx_buf->len, false);
 
 	xdp_act = bpf_prog_run_xdp(xdp_prog, &xdp);
-	rcu_read_unlock();
 
 	offset = (u8 *)xdp.data - *ehp;
 
-- 
2.31.1

