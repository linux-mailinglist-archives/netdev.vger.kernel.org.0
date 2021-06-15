Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 908263A8390
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 17:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231481AbhFOPGe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 11:06:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30677 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231346AbhFOPGc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 11:06:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623769467;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0tvsP/yH9Ey7XMq3RE8CaFyAMq7vmXoKEd6exr5zYNI=;
        b=f7MvNnNIujrF1kahuakI76DkIW7aEp1j+BB0oh9OxtmJmf5n9MZsoZ9dPwibLTYj2uGnJP
        8OAy1/JPXv7IubSj9iFA2WJ368wCAz90Q8LNDHQvkGxlJp77A9o+K/e4dN4IyjxqfW/GpT
        Cu/4wS0S/uD81bTyPKdeuwY4/hfPpz4=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-443-VvmmlHbAOrC5NrWFSqj1qg-1; Tue, 15 Jun 2021 11:04:25 -0400
X-MC-Unique: VvmmlHbAOrC5NrWFSqj1qg-1
Received: by mail-ej1-f71.google.com with SMTP id b8-20020a170906d108b02903fa10388224so4694435ejz.18
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 08:04:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0tvsP/yH9Ey7XMq3RE8CaFyAMq7vmXoKEd6exr5zYNI=;
        b=AZFNMlfqAKk/65tpxaI5LNQ+GrtjxZGj8X6ZbKE4Wfer7cAT6RSi5p5PKm1qWHy601
         qQjC3mUvAlmmBOffh0hJYadQ1HHEmMzapVEQMQwUAeXJh8wm7lCX9GYiH/0GQnTZLesp
         UhupIuCVffR6kU68x9u5n0+Wr7wrucegyBrgswf2fai4wGx8KH9CxP4QjgUT/O+SCoJO
         6jrt/061xKA6JfcAAHGgAjoC9X6P+TikjpjZSLdyZaH2OHCyRPA2FBRCDfZElS4wtWsg
         bSssSrmEakUBoLLoHPmzEAFxLC0d8uEnKCCMjxTRUAM0ZMqleenCNxIU7FmlyUvXf5kf
         ehFQ==
X-Gm-Message-State: AOAM530sSQrrFLdGz0LjA/Ro30axl4j2T8K6v2p+8Z5Touwin54AMWv8
        TJf75TshySdDsZ48hdnwz3SA3GMlVcBSR29N+Gp6F79haBdAkNBw/WIyofUr2Wru2bIhyk2qRxx
        VLjRD/Y/WMTtuosEA
X-Received: by 2002:a05:6402:1592:: with SMTP id c18mr23778761edv.2.1623769464263;
        Tue, 15 Jun 2021 08:04:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxlhK4Hyjzlmys+ZL4H0SJamx7Lw/4wa7JVAWKdG+DZ3iR+0/DA89DGjdClsHUXjjgeYnQqlQ==
X-Received: by 2002:a05:6402:1592:: with SMTP id c18mr23778723edv.2.1623769464026;
        Tue, 15 Jun 2021 08:04:24 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id e22sm12535481edv.57.2021.06.15.08.04.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 08:04:22 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id F0FBD180734; Tue, 15 Jun 2021 16:54:58 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Simon Horman <simon.horman@netronome.com>,
        oss-drivers@netronome.com
Subject: [PATCH bpf-next v2 11/16] nfp: remove rcu_read_lock() around XDP program invocation
Date:   Tue, 15 Jun 2021 16:54:50 +0200
Message-Id: <20210615145455.564037-12-toke@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210615145455.564037-1-toke@redhat.com>
References: <20210615145455.564037-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The nfp driver has rcu_read_lock()/rcu_read_unlock() pairs around XDP
program invocations. However, the actual lifetime of the objects referred
by the XDP program invocation is longer, all the way through to the call to
xdp_do_flush(), making the scope of the rcu_read_lock() too small.

While this is not actually an issue for the nfp driver because it doesn't
support XDP_REDIRECT (and thus doesn't call xdp_do_flush()), the
rcu_read_lock() is still unneeded. And With the addition of RCU annotations
to the XDP_REDIRECT map types that take bh execution into account, lockdep
even understands this to be safe, so there's really no reason to keep it
around.

Cc: Simon Horman <simon.horman@netronome.com>
Cc: oss-drivers@netronome.com
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index eeb30680b4dc..a3d59abed6ae 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -1819,7 +1819,6 @@ static int nfp_net_rx(struct nfp_net_rx_ring *rx_ring, int budget)
 	struct xdp_buff xdp;
 	int idx;
 
-	rcu_read_lock();
 	xdp_prog = READ_ONCE(dp->xdp_prog);
 	true_bufsz = xdp_prog ? PAGE_SIZE : dp->fl_bufsz;
 	xdp_init_buff(&xdp, PAGE_SIZE - NFP_NET_RX_BUF_HEADROOM,
@@ -1919,6 +1918,10 @@ static int nfp_net_rx(struct nfp_net_rx_ring *rx_ring, int budget)
 					 pkt_off - NFP_NET_RX_BUF_HEADROOM,
 					 pkt_len, true);
 
+			/* This code is invoked within a single NAPI poll cycle
+			 * and thus under local_bh_disable(), which provides the
+			 * needed RCU protection.
+			 */
 			act = bpf_prog_run_xdp(xdp_prog, &xdp);
 
 			pkt_len = xdp.data_end - xdp.data;
@@ -2036,7 +2039,6 @@ static int nfp_net_rx(struct nfp_net_rx_ring *rx_ring, int budget)
 			if (!nfp_net_xdp_complete(tx_ring))
 				pkts_polled = budget;
 	}
-	rcu_read_unlock();
 
 	return pkts_polled;
 }
-- 
2.31.1

