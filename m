Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEC0E47E31F
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 13:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243429AbhLWMUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 07:20:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243392AbhLWMUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 07:20:20 -0500
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E47A2C061401;
        Thu, 23 Dec 2021 04:20:19 -0800 (PST)
Received: by mail-qv1-xf33.google.com with SMTP id kj16so5035250qvb.2;
        Thu, 23 Dec 2021 04:20:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=D25qNoe4b7BBiu4Ck6a2DRt+tC1EyAJXN/9/wN6Ogas=;
        b=oLMVM6+CfmHKb66YeDM2kN9LZIPmQ5UeTEcplp9zYVane9j3B9fpFusve+/zueLD40
         0rjuEILZnffXLC+q9xe972AsrAw6F5SoyCLBXJchV9to5lkfVehUAwhSfQmQPYxxYn1l
         yP1KOgbznFTYg2Lk4CS17CMvqj4S7BlKuBIsUEKR5UqO5VQVV56LtxXcP6x4Jm9MccLO
         AO5otGilgGG7OyWt+GMxrYMY8SqpMPHc0yS6VVIycCtXeYpIrqDjX0mr2ZrVGMsikBk6
         Sf+NuD3i7h4QYjSlMDkllLJkxQKezImHFQdpxCx6iTTtfpzPxLbkc7dOkEwxud1GPQ/k
         FteQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=D25qNoe4b7BBiu4Ck6a2DRt+tC1EyAJXN/9/wN6Ogas=;
        b=WjeFnXNzIbDI24YzDWOJcCNEgGcpfIDBRGIYFOs7A1orPsLpPOXzv69NWGqxJ0AC7r
         Yz9qa9IXlo1nGSivpdyLlFb9NBBBVQywBtWxWryPg2rYOYm5T/VgqyDqJjMJRuB5rtmp
         LENN86X6pOHncPTnO7+wDuREEMPgkPI6i65BQMNgBqI+daOL+D2re6x3JaALXMDKDLHw
         8XB1SNfbV8HZcRevXIgdRNBdWsivKku157+0m6mK5Vy3necfFqBxoNbyi88t3dw/YEY7
         eo9jp0plgcLcITjTPvnyzuKg+kBeyhlzhgeNQqueob3FJ7Pqj+Ppob8L+5fD6QxKvCMU
         /nFg==
X-Gm-Message-State: AOAM532YOimPo/KmsWlBReLxOWbSh3f62y2H/wEAB83yOGRsHaMXZJWX
        Nea8F/7/Ee+2w7Sx3lCzAFc=
X-Google-Smtp-Source: ABdhPJxk5k7wRYR4P38HkdeoaGEawThlY3IMj5+NGdyxH1F8lmgcafhl/rKYY9qrObru/vRyfhqBng==
X-Received: by 2002:a05:6214:29e7:: with SMTP id jv7mr1354077qvb.16.1640262019074;
        Thu, 23 Dec 2021 04:20:19 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id o9sm4001967qtk.81.2021.12.23.04.20.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Dec 2021 04:20:18 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: xu.xin16@zte.com.cn
To:     davem@davemloft.net
Cc:     yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        prestwoj@gmail.com, xu.xin16@zte.com.cn, zxu@linkedin.com,
        praveen5582@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH net-next] ipv4: delete sysctls about routing cache
Date:   Thu, 23 Dec 2021 12:20:10 +0000
Message-Id: <20211223122010.569553-1-xu.xin16@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: xu xin <xu.xin16@zte.com.cn>

Since routing cache in ipv4 has been deleted in 2012, the sysctls about
it are useless.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
---
 include/uapi/linux/sysctl.h | 10 ++++----
 net/ipv4/route.c            | 48 -------------------------------------
 2 files changed, 5 insertions(+), 53 deletions(-)

diff --git a/include/uapi/linux/sysctl.h b/include/uapi/linux/sysctl.h
index 6a3b194c50fe..72ecdf38c4ed 100644
--- a/include/uapi/linux/sysctl.h
+++ b/include/uapi/linux/sysctl.h
@@ -432,9 +432,9 @@ enum {
 	NET_IPV4_ROUTE_FLUSH=1,
 	NET_IPV4_ROUTE_MIN_DELAY=2, /* obsolete since 2.6.25 */
 	NET_IPV4_ROUTE_MAX_DELAY=3, /* obsolete since 2.6.25 */
-	NET_IPV4_ROUTE_GC_THRESH=4,
-	NET_IPV4_ROUTE_MAX_SIZE=5,
-	NET_IPV4_ROUTE_GC_MIN_INTERVAL=6,
+	NET_IPV4_ROUTE_GC_THRESH=4, /* obsolete */
+	NET_IPV4_ROUTE_MAX_SIZE=5,  /* obsolete */
+	NET_IPV4_ROUTE_GC_MIN_INTERVAL=6, /* obsolete */
 	NET_IPV4_ROUTE_GC_TIMEOUT=7,
 	NET_IPV4_ROUTE_GC_INTERVAL=8, /* obsolete since 2.6.38 */
 	NET_IPV4_ROUTE_REDIRECT_LOAD=9,
@@ -442,12 +442,12 @@ enum {
 	NET_IPV4_ROUTE_REDIRECT_SILENCE=11,
 	NET_IPV4_ROUTE_ERROR_COST=12,
 	NET_IPV4_ROUTE_ERROR_BURST=13,
-	NET_IPV4_ROUTE_GC_ELASTICITY=14,
+	NET_IPV4_ROUTE_GC_ELASTICITY=14, /* obsolete */
 	NET_IPV4_ROUTE_MTU_EXPIRES=15,
 	NET_IPV4_ROUTE_MIN_PMTU=16,
 	NET_IPV4_ROUTE_MIN_ADVMSS=17,
 	NET_IPV4_ROUTE_SECRET_INTERVAL=18,
-	NET_IPV4_ROUTE_GC_MIN_INTERVAL_MS=19,
+	NET_IPV4_ROUTE_GC_MIN_INTERVAL_MS=19, /* obsolete */
 };
 
 enum
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 843a7a3699fe..4b0d7d654859 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -110,7 +110,6 @@
 
 #define RT_GC_TIMEOUT (300*HZ)
 
-static int ip_rt_max_size;
 static int ip_rt_redirect_number __read_mostly	= 9;
 static int ip_rt_redirect_load __read_mostly	= HZ / 50;
 static int ip_rt_redirect_silence __read_mostly	= ((HZ / 50) << (9 + 1));
@@ -3428,8 +3427,6 @@ void ip_rt_multicast_event(struct in_device *in_dev)
 }
 
 #ifdef CONFIG_SYSCTL
-static int ip_rt_gc_interval __read_mostly  = 60 * HZ;
-static int ip_rt_gc_min_interval __read_mostly	= HZ / 2;
 static int ip_rt_gc_elasticity __read_mostly	= 8;
 static int ip_min_valid_pmtu __read_mostly	= IPV4_MIN_MTU;
 
@@ -3448,36 +3445,6 @@ static int ipv4_sysctl_rtcache_flush(struct ctl_table *__ctl, int write,
 }
 
 static struct ctl_table ipv4_route_table[] = {
-	{
-		.procname	= "gc_thresh",
-		.data		= &ipv4_dst_ops.gc_thresh,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
-	{
-		.procname	= "max_size",
-		.data		= &ip_rt_max_size,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
-	{
-		/*  Deprecated. Use gc_min_interval_ms */
-
-		.procname	= "gc_min_interval",
-		.data		= &ip_rt_gc_min_interval,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_jiffies,
-	},
-	{
-		.procname	= "gc_min_interval_ms",
-		.data		= &ip_rt_gc_min_interval,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_ms_jiffies,
-	},
 	{
 		.procname	= "gc_timeout",
 		.data		= &ip_rt_gc_timeout,
@@ -3485,13 +3452,6 @@ static struct ctl_table ipv4_route_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_jiffies,
 	},
-	{
-		.procname	= "gc_interval",
-		.data		= &ip_rt_gc_interval,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_jiffies,
-	},
 	{
 		.procname	= "redirect_load",
 		.data		= &ip_rt_redirect_load,
@@ -3527,13 +3487,6 @@ static struct ctl_table ipv4_route_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
-	{
-		.procname	= "gc_elasticity",
-		.data		= &ip_rt_gc_elasticity,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
 	{
 		.procname	= "mtu_expires",
 		.data		= &ip_rt_mtu_expires,
@@ -3705,7 +3658,6 @@ int __init ip_rt_init(void)
 		panic("IP: failed to allocate ipv4_dst_blackhole_ops counter\n");
 
 	ipv4_dst_ops.gc_thresh = ~0;
-	ip_rt_max_size = INT_MAX;
 
 	devinet_init();
 	ip_fib_init();
-- 
2.25.1

