Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92721516F66
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 14:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384959AbiEBMT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 08:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384943AbiEBMTZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 08:19:25 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C3EB1209A
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 05:15:55 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id p10so24897571lfa.12
        for <netdev@vger.kernel.org>; Mon, 02 May 2022 05:15:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=zF2cE9+P0Hg5X3nSpzQOTg1K/5ZJ3rPndlEIKRoSDaE=;
        b=8UEmygGrLhp+zPnr4D7bOp+vs7LlPYg2S3/xyDed0anZr1IHNhAVGPvTPtlJ5Wdbvi
         TheDYWElLLlOPoDL+7H+GvXvpMcijUFW7qUV0Yy+5aMthqi8pIFazE9oCTPg/oMSTsCL
         lWDaTSJvvkhowIn/T/vwRgME6AMoK+sMNXK2/OQdHuadCFH3O5vEGCsvpf/RY8d9x2xZ
         3PjDmNeVwkFWS7cekO5vYkoyPerJaJq/CEDaWGy3ugmjhrWChzYLn8dzSNES5wosXznv
         i+w1jVJK58S7J2xJhZTEXYnH4xVzDT7jRW8n+gEsPQ+5ZPZtHlI+SQQF4q26TRHMQXqF
         Y43w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:references:content-language:in-reply-to
         :content-transfer-encoding;
        bh=zF2cE9+P0Hg5X3nSpzQOTg1K/5ZJ3rPndlEIKRoSDaE=;
        b=KiThNCKyHSuPiwowrV0Ob7WlvwT/nbjwkjZv9wPoXxRog9LtOlvZBty91VZoIvpFU0
         hRcAuflHyHCkW8asvSZU8X6xKtjpz8bwZMyTojn04DmVELuUySmIkwzBBMmPmrjgYR5U
         tOGWoYY0vnH5cIFOQtYL1LomaLlIx25XvsfD6M10ehOnvXGj0R8JCSZYd4Gszrff4Qq9
         NCx9UZx5Stq9b9f6SJFQBuL1qEEQWI8OiZNYgnFy8DjvcvtriNJyppxD+HihplgLIDr4
         e4F7E+6KNPe5VdyApm5+Ho8KG6FlV1l/87r719lEWF78tWBu23A6Ezj08h5W3mtjqgLq
         RjyQ==
X-Gm-Message-State: AOAM532te1yr1MsSwCd1mJCHbCwXtqSAeGXYx8XQTQQuUit7iXjvxTy+
        8y/JKwn6zZKkF36x0n7JyZbEGA==
X-Google-Smtp-Source: ABdhPJwkDTEskzw4tw9Vq22RaRk6KjYv0enSGIlQ810JvdVySd9J8zis8/RvtsOJPDji2cp8jppRUA==
X-Received: by 2002:a05:6512:b18:b0:44a:9a1f:dcf6 with SMTP id w24-20020a0565120b1800b0044a9a1fdcf6mr8517690lfu.4.1651493753494;
        Mon, 02 May 2022 05:15:53 -0700 (PDT)
Received: from [192.168.1.65] ([46.188.121.177])
        by smtp.gmail.com with ESMTPSA id 7-20020a05651c128700b0024f3d1daebcsm1003262ljc.68.2022.05.02.05.15.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 May 2022 05:15:53 -0700 (PDT)
Message-ID: <354a0a5f-9ec3-a25c-3215-304eab2157bc@openvz.org>
Date:   Mon, 2 May 2022 15:15:51 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
From:   Vasily Averin <vvs@openvz.org>
Subject: [PATCH memcg v2] memcg: accounting for objects allocated for new
 netdevice
To:     Shakeel Butt <shakeelb@google.com>
Cc:     kernel@openvz.org, Florian Westphal <fw@strlen.de>,
        linux-kernel@vger.kernel.org,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Vlastimil Babka <vbabka@suse.cz>,
        Michal Hocko <mhocko@suse.com>, cgroups@vger.kernel.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        linux-fsdevel@vger.kernel.org
References: <53613f02-75f2-0546-d84c-a5ed989327b6@openvz.org>
Content-Language: en-US
In-Reply-To: <53613f02-75f2-0546-d84c-a5ed989327b6@openvz.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Creating a new netdevice allocates at least ~50Kb of memory for various
kernel objects, but only ~5Kb of them are accounted to memcg. As a result,
creating an unlimited number of netdevice inside a memcg-limited container
does not fall within memcg restrictions, consumes a significant part
of the host's memory, can cause global OOM and lead to random kills of
host processes.

The main consumers of non-accounted memory are:
 ~10Kb   80+ kernfs nodes
 ~6Kb    ipv6_add_dev() allocations
  6Kb    __register_sysctl_table() allocations
  4Kb    neigh_sysctl_register() allocations
  4Kb    __devinet_sysctl_register() allocations
  4Kb    __addrconf_sysctl_register() allocations

Accounting of these objects allows to increase the share of memcg-related
memory up to 60-70% (~38Kb accounted vs ~54Kb total for dummy netdevice
on typical VM with default Fedora 35 kernel) and this should be enough
to somehow protect the host from misuse inside container.

Other related objects are quite small and may not be taken into account
to minimize the expected performance degradation.

It should be separately mentonied ~300 bytes of percpu allocation
of struct ipstats_mib in snmp6_alloc_dev(), on huge multi-cpu nodes
it can become the main consumer of memory.

This patch does not enables kernfs accounting as it affects
other parts of the kernel and should be discussed separately.
However, even without kernfs, this patch significantly improves the
current situation and allows to take into account more than half
of all netdevice allocations.

Signed-off-by: Vasily Averin <vvs@openvz.org>
---
v2: 1) kernfs accounting moved into separate patch, suggested by
    Shakeel and mkoutny@.
    2) in ipv6_add_dev() changed original "sizeof(struct inet6_dev)"
    to "sizeof(*ndev)", according to checkpath.pl recommendation:
      CHECK: Prefer kzalloc(sizeof(*ndev)...) over kzalloc(sizeof
        (struct inet6_dev)...)
---
 fs/proc/proc_sysctl.c | 2 +-
 net/core/neighbour.c  | 2 +-
 net/ipv4/devinet.c    | 2 +-
 net/ipv6/addrconf.c   | 8 ++++----
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 7d9cfc730bd4..df4604fea4f8 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -1333,7 +1333,7 @@ struct ctl_table_header *__register_sysctl_table(
 		nr_entries++;
 
 	header = kzalloc(sizeof(struct ctl_table_header) +
-			 sizeof(struct ctl_node)*nr_entries, GFP_KERNEL);
+			 sizeof(struct ctl_node)*nr_entries, GFP_KERNEL_ACCOUNT);
 	if (!header)
 		return NULL;
 
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index ec0bf737b076..3dcda2a54f86 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -3728,7 +3728,7 @@ int neigh_sysctl_register(struct net_device *dev, struct neigh_parms *p,
 	char neigh_path[ sizeof("net//neigh/") + IFNAMSIZ + IFNAMSIZ ];
 	char *p_name;
 
-	t = kmemdup(&neigh_sysctl_template, sizeof(*t), GFP_KERNEL);
+	t = kmemdup(&neigh_sysctl_template, sizeof(*t), GFP_KERNEL_ACCOUNT);
 	if (!t)
 		goto err;
 
diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index fba2bffd65f7..47523fe5b891 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -2566,7 +2566,7 @@ static int __devinet_sysctl_register(struct net *net, char *dev_name,
 	struct devinet_sysctl_table *t;
 	char path[sizeof("net/ipv4/conf/") + IFNAMSIZ];
 
-	t = kmemdup(&devinet_sysctl, sizeof(*t), GFP_KERNEL);
+	t = kmemdup(&devinet_sysctl, sizeof(*t), GFP_KERNEL_ACCOUNT);
 	if (!t)
 		goto out;
 
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index f908e2fd30b2..290e5e671774 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -342,7 +342,7 @@ static int snmp6_alloc_dev(struct inet6_dev *idev)
 {
 	int i;
 
-	idev->stats.ipv6 = alloc_percpu(struct ipstats_mib);
+	idev->stats.ipv6 = alloc_percpu_gfp(struct ipstats_mib, GFP_KERNEL_ACCOUNT);
 	if (!idev->stats.ipv6)
 		goto err_ip;
 
@@ -358,7 +358,7 @@ static int snmp6_alloc_dev(struct inet6_dev *idev)
 	if (!idev->stats.icmpv6dev)
 		goto err_icmp;
 	idev->stats.icmpv6msgdev = kzalloc(sizeof(struct icmpv6msg_mib_device),
-					   GFP_KERNEL);
+					   GFP_KERNEL_ACCOUNT);
 	if (!idev->stats.icmpv6msgdev)
 		goto err_icmpmsg;
 
@@ -382,7 +382,7 @@ static struct inet6_dev *ipv6_add_dev(struct net_device *dev)
 	if (dev->mtu < IPV6_MIN_MTU)
 		return ERR_PTR(-EINVAL);
 
-	ndev = kzalloc(sizeof(struct inet6_dev), GFP_KERNEL);
+	ndev = kzalloc(sizeof(*ndev), GFP_KERNEL_ACCOUNT);
 	if (!ndev)
 		return ERR_PTR(err);
 
@@ -7029,7 +7029,7 @@ static int __addrconf_sysctl_register(struct net *net, char *dev_name,
 	struct ctl_table *table;
 	char path[sizeof("net/ipv6/conf/") + IFNAMSIZ];
 
-	table = kmemdup(addrconf_sysctl, sizeof(addrconf_sysctl), GFP_KERNEL);
+	table = kmemdup(addrconf_sysctl, sizeof(addrconf_sysctl), GFP_KERNEL_ACCOUNT);
 	if (!table)
 		goto out;
 
-- 
2.31.1

