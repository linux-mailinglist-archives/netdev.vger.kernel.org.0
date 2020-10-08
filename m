Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F31C8287674
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 16:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730733AbgJHOzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 10:55:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25166 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730538AbgJHOzD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 10:55:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602168902;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=8vBAvmA9VVkjQaQOIV4tKX06blikqMqTAqSZ4A68NBY=;
        b=E3vLNX12OWtH3698zUuXgcu5/7G1w3qmFzZQHYRXvsdX4SygD0wsdAGC00955iDzfQ1MLg
        2BnVP1QWdd/9IHZh+R2ZVDdaYHWLCtVPZdkCrzXleNxq3zsSaN0exBURxMea/OpE0tPKMX
        2pN1KRC7CTmAJLmLPmgaqkgQKNDu6Ak=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-289-yalImkCbPxSe2HL9onM-cA-1; Thu, 08 Oct 2020 10:55:00 -0400
X-MC-Unique: yalImkCbPxSe2HL9onM-cA-1
Received: by mail-wr1-f72.google.com with SMTP id u15so3997568wrn.4
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 07:55:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8vBAvmA9VVkjQaQOIV4tKX06blikqMqTAqSZ4A68NBY=;
        b=r4W+XqiThzAcF8ZdJwDCWyCd/FstIQXAZPk6XkYG+ui1wT0Xqz5XhFCKmhUOX3IHiN
         g62M+4IEssF1tDQUZla6BTJDt93O6EPDLPeMClrwkcHdh7cb5+X4zlFRYIronLMfMU8v
         K1ldxm3mdFiZZ/RN22HdDj1/57SyT/v+GDPZKyZ6ONhdwqnMQn8xxi8nF06j8mzXfj6w
         8fA9KhzWDbdL3FHJd45/Gci0cVGiQ/WDw1RhAV8noQAx1iskoKxuqBcg2EbJNz0OJvnN
         +YRcICG5fEf/VPuBQ2NXWVJs+tPDGF0CwMep+6T5Ir2xuB4uLczCbFbMDccXv6+u8oUY
         vqGQ==
X-Gm-Message-State: AOAM530BxIiW+RH2zPkWAUFRtZROfaFsRnjkiY6gP5/p0QnPN2UeAYGX
        kz0zEN2Ru6eVqMYXEOqDgOttnD0SbQ6Cns4N37pHShkVfDb/GOjjGiVLYXfYNhfNk/nqY/VlWC2
        agZIqdtu5hNT9yXf6
X-Received: by 2002:adf:93e5:: with SMTP id 92mr9474004wrp.31.1602168899150;
        Thu, 08 Oct 2020 07:54:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxPlSxYXyvusTZl4I7WqRB2oLECEai0MOCdZ97k1p83lq+jHpkyBXtT7k7kAHJjmMxLoV7FRA==
X-Received: by 2002:adf:93e5:: with SMTP id 92mr9473981wrp.31.1602168898893;
        Thu, 08 Oct 2020 07:54:58 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id h4sm7669509wrv.11.2020.10.08.07.54.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 07:54:58 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B72561837DC; Thu,  8 Oct 2020 16:54:56 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     daniel@iogearbox.net, ast@fb.com
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH bpf-next] bpf_fib_lookup: return target ifindex even if neighbour lookup fails
Date:   Thu,  8 Oct 2020 16:53:14 +0200
Message-Id: <20201008145314.116800-1-toke@redhat.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bpf_fib_lookup() helper performs a neighbour lookup for the destination
IP and returns BPF_FIB_LKUP_NO_NEIGH if this fails, with the expectation
that the BPF program will pass the packet up the stack in this case.
However, with the addition of bpf_redirect_neigh() that can be used instead
to perform the neighbour lookup.

However, for that we still need the target ifindex, and since
bpf_fib_lookup() already has that at the time it performs the neighbour
lookup, there is really no reason why it can't just return it in any case.
With this fix, a BPF program can do the following to perform a redirect
based on the routing table that will succeed even if there is no neighbour
entry:

	ret = bpf_fib_lookup(skb, &fib_params, sizeof(fib_params), 0);
	if (ret == BPF_FIB_LKUP_RET_SUCCESS) {
		__builtin_memcpy(eth->h_dest, fib_params.dmac, ETH_ALEN);
		__builtin_memcpy(eth->h_source, fib_params.smac, ETH_ALEN);

		return bpf_redirect(fib_params.ifindex, 0);
	} else if (ret == BPF_FIB_LKUP_RET_NO_NEIGH) {
		return bpf_redirect_neigh(fib_params.ifindex, 0);
	}

Cc: David Ahern <dsahern@gmail.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 net/core/filter.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 05df73780dd3..00fce34a2204 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5192,7 +5192,6 @@ static int bpf_fib_set_fwd_params(struct bpf_fib_lookup *params,
 	memcpy(params->smac, dev->dev_addr, ETH_ALEN);
 	params->h_vlan_TCI = 0;
 	params->h_vlan_proto = 0;
-	params->ifindex = dev->ifindex;
 
 	return 0;
 }
@@ -5289,6 +5288,7 @@ static int bpf_ipv4_fib_lookup(struct net *net, struct bpf_fib_lookup *params,
 	dev = nhc->nhc_dev;
 
 	params->rt_metric = res.fi->fib_priority;
+	params->ifindex = dev->ifindex;
 
 	/* xdp and cls_bpf programs are run in RCU-bh so
 	 * rcu_read_lock_bh is not needed here
@@ -5414,6 +5414,7 @@ static int bpf_ipv6_fib_lookup(struct net *net, struct bpf_fib_lookup *params,
 
 	dev = res.nh->fib_nh_dev;
 	params->rt_metric = res.f6i->fib6_metric;
+	params->ifindex = dev->ifindex;
 
 	/* xdp and cls_bpf programs are run in RCU-bh so rcu_read_lock_bh is
 	 * not needed here.
-- 
2.28.0

