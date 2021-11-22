Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D496459119
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 16:15:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239678AbhKVPSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 10:18:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233449AbhKVPS3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 10:18:29 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6862C061574
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 07:15:22 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id g14so78529489edb.8
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 07:15:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oaQjB7lbCNvQ6j5Qj1cZs1R1magKCcFGqEhPiwQHJDo=;
        b=RC1H6Emw3LrcCjWT+2H4BhZ4TptQRZljzPFGZwJKYP8sl2ymEbqZybw+u16tBvvRWs
         sGE+iay9bi0szFCuD2CpJrPi0TvrIXVs0SEzHTIglfnnKZ3Pd6nEzw3N3YzvZmIySuYi
         F6lntabrAztHGklGlswBjumnpKLsHRULA2r99VenuPvq8cknbtVL2QKUaTJ4DxM8ohD9
         mOP6ZZUbp7l3tpex7srmYne06WDZ8kB3v+MhlpdUjDsFA/ROmH4EaT89wl92m32v5ZvN
         xl36xT8b3YSO/oE5lsvgYnH2NsludeNj3dkTNApQiwOcvxu0cXgJJvjB6Z88elKwjUxo
         5J3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oaQjB7lbCNvQ6j5Qj1cZs1R1magKCcFGqEhPiwQHJDo=;
        b=ni8qRRvylVUxIm0vxCDk4TnniBI70hfl5OC8DOfHUufHuV0ZbZvm79oAmiS/nTPA+3
         PRNLHV/Xx3SJg8lhBvldmygA2ClWBMuvqERAb7nfmOpCR1HoFkn9BoGdcGI3BO0f8zo/
         K4LoA6jC8l83qlBGiHn/ULZxACBA3YkpYv0QuwHKW5mruRQTrfc8OPvMzKOXrM7buoUL
         OmNWDF9L+AMJ9yZZVykrUd2o3iJDce763AaClsrZmk3cXQwQUfOQTEy1sp7S9VO42Rqw
         kJXuLTjrCQdQOr+nryQNHKLJR4xVY0cLVPRaW0gVn1GY3M5ftlgXkBchYxVrBhpvfZry
         Xn9g==
X-Gm-Message-State: AOAM533ryrKJy5NazyyAi7pTLzj9w+ApqICuEupAJsmPe2TdWakTVnT8
        gh70zzd6EjU74F/4WZM2m+N9bMjmWuQbFe80
X-Google-Smtp-Source: ABdhPJzARBZokcWqNi0vW8TA77fO5p/k3+FUhHAkR6nrLGCs+B0Gs6FV5aqVgOBCAfz0DT0Be+WXCA==
X-Received: by 2002:a17:907:948c:: with SMTP id dm12mr13870217ejc.551.1637594120573;
        Mon, 22 Nov 2021 07:15:20 -0800 (PST)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id qb21sm3906904ejc.78.2021.11.22.07.15.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 07:15:20 -0800 (PST)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     idosch@idosch.org, davem@davemloft.net, kuba@kernel.org,
        dsahern@gmail.com, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net v2 1/3] net: ipv6: add fib6_nh_release_dsts stub
Date:   Mon, 22 Nov 2021 17:15:12 +0200
Message-Id: <20211122151514.2813935-2-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211122151514.2813935-1-razor@blackwall.org>
References: <20211122151514.2813935-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

We need a way to release a fib6_nh's per-cpu dsts when replacing
nexthops otherwise we can end up with stale per-cpu dsts which hold net
device references, so add a new IPv6 stub called fib6_nh_release_dsts.
It must be used after an RCU grace period, so no new dsts can be created
through a group's nexthop entry.
Similar to fib6_nh_release it shouldn't be used if fib6_nh_init has failed
so it doesn't need a dummy stub when IPv6 is not enabled.

Fixes: 7bf4796dd099 ("nexthops: add support for replace")
Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
v2: no changes

 include/net/ip6_fib.h    |  1 +
 include/net/ipv6_stubs.h |  1 +
 net/ipv6/af_inet6.c      |  1 +
 net/ipv6/route.c         | 19 +++++++++++++++++++
 4 files changed, 22 insertions(+)

diff --git a/include/net/ip6_fib.h b/include/net/ip6_fib.h
index c412dde4d67d..83b8070d1cc9 100644
--- a/include/net/ip6_fib.h
+++ b/include/net/ip6_fib.h
@@ -485,6 +485,7 @@ int fib6_nh_init(struct net *net, struct fib6_nh *fib6_nh,
 		 struct fib6_config *cfg, gfp_t gfp_flags,
 		 struct netlink_ext_ack *extack);
 void fib6_nh_release(struct fib6_nh *fib6_nh);
+void fib6_nh_release_dsts(struct fib6_nh *fib6_nh);
 
 int call_fib6_entry_notifiers(struct net *net,
 			      enum fib_event_type event_type,
diff --git a/include/net/ipv6_stubs.h b/include/net/ipv6_stubs.h
index afbce90c4480..45e0339be6fa 100644
--- a/include/net/ipv6_stubs.h
+++ b/include/net/ipv6_stubs.h
@@ -47,6 +47,7 @@ struct ipv6_stub {
 			    struct fib6_config *cfg, gfp_t gfp_flags,
 			    struct netlink_ext_ack *extack);
 	void (*fib6_nh_release)(struct fib6_nh *fib6_nh);
+	void (*fib6_nh_release_dsts)(struct fib6_nh *fib6_nh);
 	void (*fib6_update_sernum)(struct net *net, struct fib6_info *rt);
 	int (*ip6_del_rt)(struct net *net, struct fib6_info *rt, bool skip_notify);
 	void (*fib6_rt_update)(struct net *net, struct fib6_info *rt,
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 0c4da163535a..dab4a047590b 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -1026,6 +1026,7 @@ static const struct ipv6_stub ipv6_stub_impl = {
 	.ip6_mtu_from_fib6 = ip6_mtu_from_fib6,
 	.fib6_nh_init	   = fib6_nh_init,
 	.fib6_nh_release   = fib6_nh_release,
+	.fib6_nh_release_dsts = fib6_nh_release_dsts,
 	.fib6_update_sernum = fib6_update_sernum_stub,
 	.fib6_rt_update	   = fib6_rt_update,
 	.ip6_del_rt	   = ip6_del_rt,
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 3ae25b8ffbd6..42d60c76d30a 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3680,6 +3680,25 @@ void fib6_nh_release(struct fib6_nh *fib6_nh)
 	fib_nh_common_release(&fib6_nh->nh_common);
 }
 
+void fib6_nh_release_dsts(struct fib6_nh *fib6_nh)
+{
+	int cpu;
+
+	if (!fib6_nh->rt6i_pcpu)
+		return;
+
+	for_each_possible_cpu(cpu) {
+		struct rt6_info *pcpu_rt, **ppcpu_rt;
+
+		ppcpu_rt = per_cpu_ptr(fib6_nh->rt6i_pcpu, cpu);
+		pcpu_rt = xchg(ppcpu_rt, NULL);
+		if (pcpu_rt) {
+			dst_dev_put(&pcpu_rt->dst);
+			dst_release(&pcpu_rt->dst);
+		}
+	}
+}
+
 static struct fib6_info *ip6_route_info_create(struct fib6_config *cfg,
 					      gfp_t gfp_flags,
 					      struct netlink_ext_ack *extack)
-- 
2.31.1

