Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B56F4670B6
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 04:28:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344703AbhLCDbt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 22:31:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236794AbhLCDbs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 22:31:48 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED5BCC06174A;
        Thu,  2 Dec 2021 19:28:24 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id 200so1747945pga.1;
        Thu, 02 Dec 2021 19:28:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wt6uQUiFVgAMC9AAC69fh7t+C0IyG8YZllN6+JxtLp0=;
        b=IFYLl6Koijlj6UmmeibSS06r3/eLDICnhNI4NM8vE75f2Dslj5hi7R5tQOVUg3oerp
         VLaUgIIVsP/tOlY4ko5cE8DwkIKsEMVJb2EbH0ftObm/EbTXAO0+e2DPavRMFuPAPXre
         vVWpjpZ0BAUGIae7uf4rybx7r16Uos8wU3tbgmtnEoCdQIMqMrjGOUiF/DJ7kZuVtajI
         YoZi65J658agqsW2qRumAicrKvOtQujJCj0QPp6pPv6cVyl3K5qF29FnsCCgCLRQANwI
         wnE4Chu6p7hGLkOk2mvuYThJNDTLP+R9gU8eXcgAtl8eQBByZmCm6+yF4x6iMcLionWM
         s7Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wt6uQUiFVgAMC9AAC69fh7t+C0IyG8YZllN6+JxtLp0=;
        b=qg9A0JFlp/JO01bBSFlsFhT6uGghnCVJ0iv3SqrSZIizpqwoym6EXiAEd1VeLNxECI
         0QjYvSeMeNldKUEIbGTSrji3Yg6KH2TSKuYBGvcA4E5O3NC71f1WeyVYVUtKj91wnbjG
         dpoMOXevBqe2CUfOFIMbPzFA5giyfQT4huPV+qZNYgaGuhcSyM8CWfWh1Qe/Z4oa7fMT
         U290ypyZEO/B9e9poCqV1dmrltCDMI341O6sF53+PmPapKEihqjuVDIeFsck8N5XU/K3
         ifDQZLnnICpBiT6tMvnAzwUjqQqTbYRMop2vvXgk3l7KxxEsQhz8KhsYIInd47cg3c/u
         GhnA==
X-Gm-Message-State: AOAM533R1bSwmpjtM2h4Y3VwSKBwntz5uFfIz+Fj+sXaNz9JIxjrDg0f
        OJz9ihzFRitZG9Ol9hCJZEY=
X-Google-Smtp-Source: ABdhPJxrsZnk26DhTSLBCv5TxpcS9IX7CajA1jlIxEEnSvnCGtOgxOlzwgZRPr599dI2QhbN+RuN4w==
X-Received: by 2002:a62:1c0e:0:b0:4a0:3492:37b5 with SMTP id c14-20020a621c0e000000b004a0349237b5mr16441531pfc.33.1638502104341;
        Thu, 02 Dec 2021 19:28:24 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id p6sm778935pjb.48.2021.12.02.19.28.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 19:28:23 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: xu.xin16@zte.com.cn
To:     davem@davemloft.net
Cc:     kuba@kernel.org, alex.aring@gmail.com, stefan@datenfreihafen.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, horms@verge.net.au,
        ja@ssi.bg, pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        daniel@iogearbox.net, roopa@nvidia.com, yajun.deng@linux.dev,
        chinagar@codeaurora.org, xu.xin16@zte.com.cn,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wpan@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: [PATCH net-next] net: Enable some sysctls for the userns root with privilege
Date:   Fri,  3 Dec 2021 03:28:15 +0000
Message-Id: <20211203032815.339186-1-xu.xin16@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: xu xin <xu.xin16@zte.com.cn>

Enabled sysctls include the followings: 
1. net/ipv4/neigh/<if>/* 
2. net/ipv6/neigh/<if>/* 
3. net/ieee802154/6lowpan/* 
4. net/ipv6/route/* 
5. net/ipv4/vs/* 
6. net/unix/* 
7. net/core/xfrm_*

In practical work, some userns with root privilege have needs to adjust
these sysctls in their own netns, but limited just because they are not
init user_ns, even if they are given root privilege by docker -privilege.

Reported-by: xu xin <xu.xin16@zte.com.cn>
Tested-by: xu xin <xu.xin16@zte.com.cn>
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
---
 net/core/neighbour.c                | 4 ----
 net/ieee802154/6lowpan/reassembly.c | 4 ----
 net/ipv6/route.c                    | 4 ----
 net/netfilter/ipvs/ip_vs_ctl.c      | 4 ----
 net/netfilter/ipvs/ip_vs_lblc.c     | 4 ----
 net/netfilter/ipvs/ip_vs_lblcr.c    | 3 ---
 net/unix/sysctl_net_unix.c          | 4 ----
 net/xfrm/xfrm_sysctl.c              | 4 ----
 8 files changed, 31 deletions(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 0cdd4d9ad942..44d90cc341ea 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -3771,10 +3771,6 @@ int neigh_sysctl_register(struct net_device *dev, struct neigh_parms *p,
 			neigh_proc_base_reachable_time;
 	}
 
-	/* Don't export sysctls to unprivileged users */
-	if (neigh_parms_net(p)->user_ns != &init_user_ns)
-		t->neigh_vars[0].procname = NULL;
-
 	switch (neigh_parms_family(p)) {
 	case AF_INET:
 	      p_name = "ipv4";
diff --git a/net/ieee802154/6lowpan/reassembly.c b/net/ieee802154/6lowpan/reassembly.c
index be6f06adefe0..89cbad6d8368 100644
--- a/net/ieee802154/6lowpan/reassembly.c
+++ b/net/ieee802154/6lowpan/reassembly.c
@@ -366,10 +366,6 @@ static int __net_init lowpan_frags_ns_sysctl_register(struct net *net)
 				GFP_KERNEL);
 		if (table == NULL)
 			goto err_alloc;
-
-		/* Don't export sysctls to unprivileged users */
-		if (net->user_ns != &init_user_ns)
-			table[0].procname = NULL;
 	}
 
 	table[0].data	= &ieee802154_lowpan->fqdir->high_thresh;
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index f0d29fcb2094..6a0b15d6500e 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -6409,10 +6409,6 @@ struct ctl_table * __net_init ipv6_route_sysctl_init(struct net *net)
 		table[8].data = &net->ipv6.sysctl.ip6_rt_min_advmss;
 		table[9].data = &net->ipv6.sysctl.ip6_rt_gc_min_interval;
 		table[10].data = &net->ipv6.sysctl.skip_notify_on_dev_down;
-
-		/* Don't export sysctls to unprivileged users */
-		if (net->user_ns != &init_user_ns)
-			table[1].procname = NULL;
 	}
 
 	return table;
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 7f645328b47f..a77c8abf2fc7 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -4040,10 +4040,6 @@ static int __net_init ip_vs_control_net_init_sysctl(struct netns_ipvs *ipvs)
 		tbl = kmemdup(vs_vars, sizeof(vs_vars), GFP_KERNEL);
 		if (tbl == NULL)
 			return -ENOMEM;
-
-		/* Don't export sysctls to unprivileged users */
-		if (net->user_ns != &init_user_ns)
-			tbl[0].procname = NULL;
 	} else
 		tbl = vs_vars;
 	/* Initialize sysctl defaults */
diff --git a/net/netfilter/ipvs/ip_vs_lblc.c b/net/netfilter/ipvs/ip_vs_lblc.c
index 7ac7473e3804..567ba33fa5b4 100644
--- a/net/netfilter/ipvs/ip_vs_lblc.c
+++ b/net/netfilter/ipvs/ip_vs_lblc.c
@@ -561,10 +561,6 @@ static int __net_init __ip_vs_lblc_init(struct net *net)
 		if (ipvs->lblc_ctl_table == NULL)
 			return -ENOMEM;
 
-		/* Don't export sysctls to unprivileged users */
-		if (net->user_ns != &init_user_ns)
-			ipvs->lblc_ctl_table[0].procname = NULL;
-
 	} else
 		ipvs->lblc_ctl_table = vs_vars_table;
 	ipvs->sysctl_lblc_expiration = DEFAULT_EXPIRATION;
diff --git a/net/netfilter/ipvs/ip_vs_lblcr.c b/net/netfilter/ipvs/ip_vs_lblcr.c
index 77c323c36a88..a58440a7bf9e 100644
--- a/net/netfilter/ipvs/ip_vs_lblcr.c
+++ b/net/netfilter/ipvs/ip_vs_lblcr.c
@@ -747,9 +747,6 @@ static int __net_init __ip_vs_lblcr_init(struct net *net)
 		if (ipvs->lblcr_ctl_table == NULL)
 			return -ENOMEM;
 
-		/* Don't export sysctls to unprivileged users */
-		if (net->user_ns != &init_user_ns)
-			ipvs->lblcr_ctl_table[0].procname = NULL;
 	} else
 		ipvs->lblcr_ctl_table = vs_vars_table;
 	ipvs->sysctl_lblcr_expiration = DEFAULT_EXPIRATION;
diff --git a/net/unix/sysctl_net_unix.c b/net/unix/sysctl_net_unix.c
index c09bea89151b..01d44e2598e2 100644
--- a/net/unix/sysctl_net_unix.c
+++ b/net/unix/sysctl_net_unix.c
@@ -30,10 +30,6 @@ int __net_init unix_sysctl_register(struct net *net)
 	if (table == NULL)
 		goto err_alloc;
 
-	/* Don't export sysctls to unprivileged users */
-	if (net->user_ns != &init_user_ns)
-		table[0].procname = NULL;
-
 	table[0].data = &net->unx.sysctl_max_dgram_qlen;
 	net->unx.ctl = register_net_sysctl(net, "net/unix", table);
 	if (net->unx.ctl == NULL)
diff --git a/net/xfrm/xfrm_sysctl.c b/net/xfrm/xfrm_sysctl.c
index 0c6c5ef65f9d..a9b7723eb88f 100644
--- a/net/xfrm/xfrm_sysctl.c
+++ b/net/xfrm/xfrm_sysctl.c
@@ -55,10 +55,6 @@ int __net_init xfrm_sysctl_init(struct net *net)
 	table[2].data = &net->xfrm.sysctl_larval_drop;
 	table[3].data = &net->xfrm.sysctl_acq_expires;
 
-	/* Don't export sysctls to unprivileged users */
-	if (net->user_ns != &init_user_ns)
-		table[0].procname = NULL;
-
 	net->xfrm.sysctl_hdr = register_net_sysctl(net, "net/core", table);
 	if (!net->xfrm.sysctl_hdr)
 		goto out_register;
-- 
2.25.1

