Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDDF5458475
	for <lists+netdev@lfdr.de>; Sun, 21 Nov 2021 16:25:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238288AbhKUP2P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 10:28:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237983AbhKUP2E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Nov 2021 10:28:04 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23DFCC061574
        for <netdev@vger.kernel.org>; Sun, 21 Nov 2021 07:24:59 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id b12so27812911wrh.4
        for <netdev@vger.kernel.org>; Sun, 21 Nov 2021 07:24:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4kxx5MbEDh8mveoZxdtZsIc7F4S+mS5sJ95UvEoJUU8=;
        b=SaqbbtIk2CzmUaTY3U8CydaYJ/dqB93gr+8p0ygmoySqKG2Qkm207b2WRAw1X1pFEq
         hEFAzvctI725uF0xMmWJVGthDXwBwzti7UM4PB29EkQiPe61NlFErLMH3g5Djtyg6ypW
         kxe9panFCpCEp/e5rS5wq+Xjv2lhu4/jjCUuKOZZiBobsbMH9KovEkUF5jfAWSsxvoOt
         kWLxOoBaRAPqd94qie7+fMoavACeoKQ7BZ5cr4XVFTDaOUf4cY1nPNWTlNQ3gO3LIl0M
         h3grQEKUcWu/EVqUczspKS1E9pWwCVf7o3YOY0eOV+FPZJn9N0bErt5NIZh79SweIRBb
         M+tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4kxx5MbEDh8mveoZxdtZsIc7F4S+mS5sJ95UvEoJUU8=;
        b=rz1M4StlHyv3TeO0uEeh8MtUU+vN4MOzxmXGqkz5WiFCDwNca/Jrz8UynIeA9SZlx/
         CtFlmb2vJKuDdYV2vGEXXk6Sg9IHRfNKlorMrXB3cYDs37AnxWDUUDzw5TnyQPRNACaQ
         Zbr0GzSKQhUseCMM9BRmTXZw4pxaPCF5E+tpl4QIepdmonsCmmJjPD7AMRptR+ZXR2EG
         WKRFBCmJopwqJsoaoN3goOS9+7w9wA5VCWmJG8E2O7p78wONOsEhEWQA4v/ctYWUJmLL
         tQGQnBo7mA7NFK3x6lU/ArV8JKlKg/nJbOdUyE46LMBict6tKLZRJCNtDUzvSflAvoKg
         LH6w==
X-Gm-Message-State: AOAM533PzO+zg7MD4PxjpNltA4qX/HUQCqAROg6fiJ7WPVqx4d4yAZ7x
        Hw+Ost8ETPN79i6z1c2YvWuVyB7afld965ZI
X-Google-Smtp-Source: ABdhPJwKMDSUHMu8TE1NWsKJoOzP1RoLseJXd+hk9iiHdcxQ4j+fyM6SBdrw80qnFWU36k2f/+npkA==
X-Received: by 2002:adf:f042:: with SMTP id t2mr29711353wro.180.1637508297404;
        Sun, 21 Nov 2021 07:24:57 -0800 (PST)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id m36sm7165559wms.25.2021.11.21.07.24.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Nov 2021 07:24:57 -0800 (PST)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     idosch@idosch.org, davem@davemloft.net, kuba@kernel.org,
        dsahern@gmail.com, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net 1/3] net: ipv6: add fib6_nh_release_dsts stub
Date:   Sun, 21 Nov 2021 17:24:51 +0200
Message-Id: <20211121152453.2580051-2-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211121152453.2580051-1-razor@blackwall.org>
References: <20211121152453.2580051-1-razor@blackwall.org>
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

