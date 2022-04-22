Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A82250B0FE
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 09:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444627AbiDVHE5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 03:04:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444629AbiDVHEz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 03:04:55 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E18945130D;
        Fri, 22 Apr 2022 00:01:59 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id n18so8902500plg.5;
        Fri, 22 Apr 2022 00:01:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MopaOY7i6WBi8YVwl5BOvWJCH8y5VXovqDBUoTUNOUQ=;
        b=CAIG/mMVKrKt5OZGWXryYFW3dEEYvrDi47HBkS3yl3EL81bzNUMybiUWux9G8k7uLl
         74yhzhrQDe5Y5BOvjBaCP75R0CD+cg9s2G4fa+raBO7Km2gRK0Gq4W6GoDvLtXrzT0aW
         3LDFRFCF2C3rnBSiB4k8vv6T2yoWSNluiSprb4vF4oa2Q0cgLt9qEZsSf1jhQFbF7rj/
         K+g9IOPkQSP7IMWK9f83U0Ol5oreu8VVD+6QcNr5hmHiPKUyn9Uy2lHW2U5nH2c6zf3n
         4B+lyHOSTCxVYTply+wKDR3j/2lBhRM/nI8gQKiPBhSEK9Twj+qnXIBgBzBhfFJVWg4z
         Vepw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MopaOY7i6WBi8YVwl5BOvWJCH8y5VXovqDBUoTUNOUQ=;
        b=TJenvolwQlGWT2NZWUVxgUMvebCKd76+KruSDh25acG4LWwimwmKjiEwr/l2vg6oV2
         +W710/uJv/5M4t3zUt1Q5yA1MUq/s7NJmhmAAXBqG+fqaWq9YfJ6+AGOGV0hls/5YHGq
         4dD58aqzBGr4+0ECq9j2n97Qm04QtLQ/sxpuR+dBdV3noN1MGEOw6vjVN4wq16t0sdef
         R+ygxH6yU60rZFWvxo9/9o7k3Li5/o2ah3nqtFzHzalu/vmoVETlEgWaHhfhlpNx+1yT
         dpbYkQbDmwIUigd70p8g3ocz+Wh9KAU+P3kP92Pybk2vzV06s/q2DHbBQ2PYSI5ngHJ7
         wXfA==
X-Gm-Message-State: AOAM531E3KqARcQ5Ti0k2fwTqXy/UJ+kWvxcLZzBd5M37wi96GqOt2c6
        47DDUPdmgKn1hEHvE8Ck9VSNq1n/aZdIgQ==
X-Google-Smtp-Source: ABdhPJwF/GHqpbugqr3ld8NTA0tlHfBAr3TkH81dP2rfb/nqZUwZ5C02IvL9Q/OzxCbSb9K/PS0XOQ==
X-Received: by 2002:a17:90a:ec09:b0:1d5:dd77:d050 with SMTP id l9-20020a17090aec0900b001d5dd77d050mr3673333pjy.53.1650610919136;
        Fri, 22 Apr 2022 00:01:59 -0700 (PDT)
Received: from localhost.localdomain ([111.204.182.100])
        by smtp.gmail.com with ESMTPSA id 10-20020a17090a1a0a00b001cd630f301fsm4873467pjk.36.2022.04.22.00.01.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Apr 2022 00:01:58 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Simon Horman <horms@verge.net.au>,
        Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, Shuah Khan <shuah@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Akhmat Karakotov <hmukos@yandex-team.ru>
Subject: [net-next v4 1/3] net: sysctl: use shared sysctl macro
Date:   Fri, 22 Apr 2022 15:01:39 +0800
Message-Id: <20220422070141.39397-2-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20220422070141.39397-1-xiangxia.m.yue@gmail.com>
References: <20220422070141.39397-1-xiangxia.m.yue@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: David Ahern <dsahern@kernel.org>
Cc: Simon Horman <horms@verge.net.au>
Cc: Julian Anastasov <ja@ssi.bg>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>
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

