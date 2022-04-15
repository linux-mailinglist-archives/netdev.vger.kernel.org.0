Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB4E5502DCF
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 18:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355195AbiDOQmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 12:42:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355885AbiDOQma (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 12:42:30 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FD3A6A429
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 09:40:01 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id k14so7706799pga.0
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 09:40:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Pv9fzW0+rpXyo+HilHLIGLgvkMo+X6fBXONAG7ib4CA=;
        b=lN3n/pPgaEWKSW0wjwMGl3U8u4fRnGfYZSyyO6r3boq/OM5h04EX7geuwcd8yBQTLW
         Fxr37RWha0YnVL6fwpYHRWFhEXimY5z6oHs/3Wy0F3uWzzqnBdQBIYsikH1Ta3LNLcb5
         uCAk3KPsr5pdMhknGhogn6gIy/z558s9uB7vklHymz6htaNyCKZfvF4lGbXZ/PcAoCPE
         JtiElT+tDe62DZU8mfFydY3opa3oqiagQoKGWOJSyeE8+xWebkPUDlwvjpNIIRsphFbq
         gQwVZUVgLTnvj7LGtcZ9HmHGO7BoEeyIfrdJPRgH6D2XdtZunilOZ2ax+i4WgMg46fJX
         Qm3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Pv9fzW0+rpXyo+HilHLIGLgvkMo+X6fBXONAG7ib4CA=;
        b=z7qSrXZKgBnmS/iVe/kp0HxGIptdBtItTlh8aWWslhQbI3y18OsvkLtbOisOnyX2CA
         oPeiGLOiqji31cELR+HpIKRxxVz0UVTwoPrGkLE6Nb8ldnktWV0RXPjmlT2P4bjHG9mx
         bqgc3U/U7t5XUB/pD4D8a5jnMljrIl5FLjfTQojEUzYjeZGwznu/FgOHY6aGEW3CHTmv
         VFjNiPkPBGex/msy5nLpnvNf1RWgoGH5knOEJmdciWgiVZfOxzJoAuOmdKPYaMeqisnY
         +lj0vo10ogASiCdUlG+scH8zfUkXXcwUjRTw7uyybZCUKG9sj9hssmOvbRNVcLHB8/+Y
         hFQA==
X-Gm-Message-State: AOAM532kVO81OChWjcy0+6FQmuoHWb3Q8IB+8vcgwD8ym8IIYf2D3VBv
        npsBQE2ZwVjRPmSBezpRzODSaPIkB/oXuoli
X-Google-Smtp-Source: ABdhPJzdbOFCD3N8pmyeaFZWcQQWSCb/QeOReg98ewL87/pzcVweOpLcUeCTvI3jC4ZbYbrzgG258w==
X-Received: by 2002:a63:5f06:0:b0:3a2:8b3d:a844 with SMTP id t6-20020a635f06000000b003a28b3da844mr3665259pgb.554.1650040800459;
        Fri, 15 Apr 2022 09:40:00 -0700 (PDT)
Received: from localhost.localdomain ([111.201.148.136])
        by smtp.gmail.com with ESMTPSA id y13-20020a17090a154d00b001cb5f0b55cfsm5598077pja.1.2022.04.15.09.39.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Apr 2022 09:40:00 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     netdev@vger.kernel.org
Cc:     Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Simon Horman <horms@verge.net.au>,
        Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Dmitry Vyukov <dvyukov@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Akhmat Karakotov <hmukos@yandex-team.ru>
Subject: [PATCH v3 1/2] net: sysctl: use shared sysctl macro
Date:   Sat, 16 Apr 2022 00:39:11 +0800
Message-Id: <20220415163912.26530-2-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20220415163912.26530-1-xiangxia.m.yue@gmail.com>
References: <20220415163912.26530-1-xiangxia.m.yue@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

This patch replace two, four and long_one to SYSCTL_XXX.

Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: David Ahern <dsahern@kernel.org>
Cc: Simon Horman <horms@verge.net.au>
Cc: Julian Anastasov <ja@ssi.bg>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Cc: Akhmat Karakotov <hmukos@yandex-team.ru>
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 net/core/sysctl_net_core.c | 10 ++++------
 net/ipv4/sysctl_net_ipv4.c | 13 +++++--------
 net/ipv6/sysctl_net_ipv6.c |  3 +--
 3 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index 8295e5877eb3..3a0ce309ffcd 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -25,13 +25,11 @@
 
 #include "dev.h"
 
-static int two = 2;
 static int three = 3;
 static int int_3600 = 3600;
 static int min_sndbuf = SOCK_MIN_SNDBUF;
 static int min_rcvbuf = SOCK_MIN_RCVBUF;
 static int max_skb_frags = MAX_SKB_FRAGS;
-static long long_one __maybe_unused = 1;
 static long long_max __maybe_unused = LONG_MAX;
 
 static int net_msg_warn;	/* Unused, but still a sysctl */
@@ -390,7 +388,7 @@ static struct ctl_table net_core_table[] = {
 		.extra2		= SYSCTL_ONE,
 # else
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= &two,
+		.extra2		= SYSCTL_TWO,
 # endif
 	},
 # ifdef CONFIG_HAVE_EBPF_JIT
@@ -401,7 +399,7 @@ static struct ctl_table net_core_table[] = {
 		.mode		= 0600,
 		.proc_handler	= proc_dointvec_minmax_bpf_restricted,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= &two,
+		.extra2		= SYSCTL_TWO,
 	},
 	{
 		.procname	= "bpf_jit_kallsyms",
@@ -419,7 +417,7 @@ static struct ctl_table net_core_table[] = {
 		.maxlen		= sizeof(long),
 		.mode		= 0600,
 		.proc_handler	= proc_dolongvec_minmax_bpf_restricted,
-		.extra1		= &long_one,
+		.extra1		= SYSCTL_LONG_ONE,
 		.extra2		= &bpf_jit_limit_max,
 	},
 #endif
@@ -546,7 +544,7 @@ static struct ctl_table net_core_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= &two,
+		.extra2		= SYSCTL_TWO,
 	},
 	{
 		.procname	= "devconf_inherit_init_net",
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index ad80d180b60b..9ff60a389cd0 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -20,10 +20,7 @@
 #include <net/protocol.h>
 #include <net/netevent.h>
 
-static int two = 2;
 static int three __maybe_unused = 3;
-static int four = 4;
-static int thousand = 1000;
 static int tcp_retr1_max = 255;
 static int ip_local_port_range_min[] = { 1, 1 };
 static int ip_local_port_range_max[] = { 65535, 65535 };
@@ -1006,7 +1003,7 @@ static struct ctl_table ipv4_net_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dou8vec_minmax,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= &two,
+		.extra2		= SYSCTL_TWO,
 	},
 	{
 		.procname	= "tcp_max_syn_backlog",
@@ -1117,7 +1114,7 @@ static struct ctl_table ipv4_net_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dou8vec_minmax,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= &four,
+		.extra2		= SYSCTL_FOUR,
 	},
 	{
 		.procname	= "tcp_recovery",
@@ -1310,7 +1307,7 @@ static struct ctl_table ipv4_net_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= &thousand,
+		.extra2		= SYSCTL_ONE_THOUSAND,
 	},
 	{
 		.procname	= "tcp_pacing_ca_ratio",
@@ -1319,7 +1316,7 @@ static struct ctl_table ipv4_net_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= &thousand,
+		.extra2		= SYSCTL_ONE_THOUSAND,
 	},
 	{
 		.procname	= "tcp_wmem",
@@ -1391,7 +1388,7 @@ static struct ctl_table ipv4_net_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dou8vec_minmax,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= &two,
+		.extra2		= SYSCTL_TWO,
 	},
 	{ }
 };
diff --git a/net/ipv6/sysctl_net_ipv6.c b/net/ipv6/sysctl_net_ipv6.c
index d53dd142bf87..560c48d0ddb7 100644
--- a/net/ipv6/sysctl_net_ipv6.c
+++ b/net/ipv6/sysctl_net_ipv6.c
@@ -23,7 +23,6 @@
 #endif
 #include <linux/ioam6.h>
 
-static int two = 2;
 static int three = 3;
 static int flowlabel_reflect_max = 0x7;
 static int auto_flowlabels_max = IP6_AUTO_FLOW_LABEL_MAX;
@@ -197,7 +196,7 @@ static struct ctl_table ipv6_table_template[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dou8vec_minmax,
 		.extra1         = SYSCTL_ZERO,
-		.extra2         = &two,
+		.extra2         = SYSCTL_TWO,
 	},
 	{
 		.procname	= "ioam6_id",
-- 
2.27.0

