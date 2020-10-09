Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25C32289154
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 20:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733005AbgJISm6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 14:42:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22433 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732816AbgJISm5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 14:42:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602268976;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=BuHz/agx/D/xUxMUmb9YQz8Olko0BMRD2G5Xk+NMsYA=;
        b=Nc5+jWFS+cYuG+O1Vo5YVdDjPCz9Xgo2s/LkM+nIolppFA7JMiUmJnqYadoLGlyv7TcA4G
        Q3/QTbHWYzLVVWNFXIUqHKNj3B/taEsND+vQR4RgVyQ58MsvZLb5YpTQ7qnc16INV/+rOl
        V+BxwZQ5O+6OHQF9/oEzOOvfiz25acY=
Received: from mail-vs1-f72.google.com (mail-vs1-f72.google.com
 [209.85.217.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-505-KJBbNiTJM4O0ZtmNw7T3ow-1; Fri, 09 Oct 2020 14:42:54 -0400
X-MC-Unique: KJBbNiTJM4O0ZtmNw7T3ow-1
Received: by mail-vs1-f72.google.com with SMTP id l11so1484301vsq.19
        for <netdev@vger.kernel.org>; Fri, 09 Oct 2020 11:42:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BuHz/agx/D/xUxMUmb9YQz8Olko0BMRD2G5Xk+NMsYA=;
        b=lklH523Hky50AtrKuFwtZrcohakZhtNiDLFzYTP6XNoqs44Dni6Z6cMHE7Je8R5bIb
         TvfRBwG3qgh+4WDkn8uaUY9SfWgXLUVkE/ocko4fLi8B+mqlC/SVWGgRifNaBXk0NTWu
         wEME9ON1r1J8MrUrF54K5kb1RZnNnP7kKwDdHi4yhB9S2TLfOalQpKh5nS4VzT49Bv/U
         iw+yAuhe25kKYtJ7WeWyPHIAwAaH49kl1aX9r2p4Jxqs1k55rd7SYce40Qs2ei72hpJG
         mHubfSNRRkgB2G1aROWZgc54DEHvI1UV6nKAzZS22cTKRZG7zu6rfUgyp67KG+s0qTV+
         RomQ==
X-Gm-Message-State: AOAM530rC9xvzi06JihKM22yWEO1cIMS0cZoYUM5Qu6v0J6sgyA2kF2V
        r/asXGdhtY9S8Szy3WVS3Mm4i3DOVniPPfn3CuFyeg08rvkB6kk2dzbwG+98QO3r/6d5x2MZeIz
        Zq9dgW24vfgE4US7G
X-Received: by 2002:a67:ec89:: with SMTP id h9mr8758456vsp.55.1602268974248;
        Fri, 09 Oct 2020 11:42:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxqui8W8z3EFvE8/xCYAoe4hqPY7vwTnzl3eqMhQ+bGhMjEANnr+OIPvldIDLL0JBJyyrRfMw==
X-Received: by 2002:a67:ec89:: with SMTP id h9mr8758444vsp.55.1602268973995;
        Fri, 09 Oct 2020 11:42:53 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id s18sm1249332vkd.51.2020.10.09.11.42.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 11:42:53 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 499201837DC; Fri,  9 Oct 2020 20:42:51 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     daniel@iogearbox.net, ast@fb.com
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH bpf-next v3] bpf_fib_lookup: always return target ifindex
Date:   Fri,  9 Oct 2020 20:42:34 +0200
Message-Id: <20201009184234.134214-1-toke@redhat.com>
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
to perform the neighbour lookup, at the cost of a bit of duplicated work.

For that we still need the target ifindex, and since bpf_fib_lookup()
already has that at the time it performs the neighbour lookup, there is
really no reason why it can't just return it in any case. So let's just
always return the ifindex if the FIB lookup itself succeeds.

Cc: David Ahern <dsahern@gmail.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
v3:
- Get rid of the flag again, to be revisited later (David)

v2:
- Add flag (Daniel)
- Remove misleading code example from commit message (David)

net/core/filter.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 5da44b11e1ec..a0c30f3ea7ca 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5196,7 +5196,6 @@ static int bpf_fib_set_fwd_params(struct bpf_fib_lookup *params,
 	memcpy(params->smac, dev->dev_addr, ETH_ALEN);
 	params->h_vlan_TCI = 0;
 	params->h_vlan_proto = 0;
-	params->ifindex = dev->ifindex;
 
 	return 0;
 }
@@ -5293,6 +5292,7 @@ static int bpf_ipv4_fib_lookup(struct net *net, struct bpf_fib_lookup *params,
 	dev = nhc->nhc_dev;
 
 	params->rt_metric = res.fi->fib_priority;
+	params->ifindex = dev->ifindex;
 
 	/* xdp and cls_bpf programs are run in RCU-bh so
 	 * rcu_read_lock_bh is not needed here
@@ -5418,6 +5418,7 @@ static int bpf_ipv6_fib_lookup(struct net *net, struct bpf_fib_lookup *params,
 
 	dev = res.nh->fib_nh_dev;
 	params->rt_metric = res.f6i->fib6_metric;
+	params->ifindex = dev->ifindex;
 
 	/* xdp and cls_bpf programs are run in RCU-bh so rcu_read_lock_bh is
 	 * not needed here.
-- 
2.28.0

