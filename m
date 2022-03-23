Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 333644E4AA5
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 02:53:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240821AbiCWBzI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 21:55:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240797AbiCWBzG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 21:55:06 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E05F256202
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 18:53:36 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id m22so343050pja.0
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 18:53:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=48zLxq6Ao+u9okFonUAASL2xEfX5JzmLT/yDLCNUOZQ=;
        b=ehHxHp/lmXAA2DRp+8wTr+i7+BC6yVG8TJkrMsRfMyNG9kVZ+0MQC+IWcEsHx3FsG3
         KkTcHRF4ZQpdjNPTtV/nkGmMfYpn1ze5FVxlrIlXZb6bxMNpnTeEnOw/xc9hVqqQoSNv
         urLQ2cWN456QkJ4j0sZfOKAAIghZUEvv++f9fXi0KOWmflvtdHe6d0YC5dQu42ZwaeI+
         rkNKp74JRb/U8e+eVzp4CXj9HkjYFWMaKdwH7/UlQcY3QIQasQRQ3VMO+odDlsR8J+kK
         ojbSoDv+8L+GPEzEwK4tBnYqpSWIuxF5TnGQqfnHC6NvkqKbYmMdAi8pR9+5eMKM2onz
         pTFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=48zLxq6Ao+u9okFonUAASL2xEfX5JzmLT/yDLCNUOZQ=;
        b=o1NdfH+QcjhCAJKOu8r5IkwTqrRCP2O1bXQ4Q75V5VhIUXaX8PA6ZHLmj31e7ygsuI
         Fya7h3gq3p50CnvkZskzZ4RtYWRuTjm2RqAVqmA9BjiBl/GVwNPer9tcqWLqZW/RneqM
         UJLdsNX7/bwseFVbqoa8i1DVu0U3zKJc9gCG5jpp78qL1nwliEdpcK+f+ULrnRCBRrAu
         kePgR0eV0W238w7UQSeq4L88RyQ32EG74wOmsM8R0hwv3nMNAY9yp2aFBikOU7Zd/69B
         QqkW5NJV7HjVZH+2BnsE2g85szcPxPK0OeR8H0DjtonBsfNxRrGnApGlQCELI7hPcejn
         wnEQ==
X-Gm-Message-State: AOAM532YhjE9i0h6FNwf5+WftOWsNhGheR/L5hZ5Ds4Brh2nLX4pY/K2
        5ycNREeH8hAcvMKDindEZHghY66DVDx6pQ==
X-Google-Smtp-Source: ABdhPJx/ZAkayrfwEU139T55WTjHcICIjTszsq2ZKd3Fk7NzDETfBKELRuBJpehBzDUDS9KW3wtXVA==
X-Received: by 2002:a17:902:aa0a:b0:154:9ce:366 with SMTP id be10-20020a170902aa0a00b0015409ce0366mr21614224plb.8.1648000415954;
        Tue, 22 Mar 2022 18:53:35 -0700 (PDT)
Received: from localhost.xiaojukeji.com ([111.201.151.228])
        by smtp.gmail.com with ESMTPSA id z23-20020a056a001d9700b004fa8f24702csm10184924pfw.85.2022.03.22.18.53.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Mar 2022 18:53:34 -0700 (PDT)
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
Subject: [net-next v2] net: core: use shared sysctl macro
Date:   Wed, 23 Mar 2022 09:53:26 +0800
Message-Id: <20220323015326.26478-1-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
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

This patch introdues the SYSCTL_THREE, and replace the
two, three and long_one to SYSCTL_XXX accordingly.

 KUnit:
 [23:03:58] ================ sysctl_test (10 subtests) =================
 [23:03:58] [PASSED] sysctl_test_api_dointvec_null_tbl_data
 [23:03:58] [PASSED] sysctl_test_api_dointvec_table_maxlen_unset
 [23:03:58] [PASSED] sysctl_test_api_dointvec_table_len_is_zero
 [23:03:58] [PASSED] sysctl_test_api_dointvec_table_read_but_position_set
 [23:03:58] [PASSED] sysctl_test_dointvec_read_happy_single_positive
 [23:03:58] [PASSED] sysctl_test_dointvec_read_happy_single_negative
 [23:03:58] [PASSED] sysctl_test_dointvec_write_happy_single_positive
 [23:03:58] [PASSED] sysctl_test_dointvec_write_happy_single_negative
 [23:03:58] [PASSED] sysctl_test_api_dointvec_write_single_less_int_min
 [23:03:58] [PASSED] sysctl_test_api_dointvec_write_single_greater_int_max
 [23:03:58] =================== [PASSED] sysctl_test ===================

 ./run_kselftest.sh -c sysctl
 ...
 # Running test: sysctl_test_0006 - run #49
 # Checking bitmap handler... ok
 # Wed Mar 16 14:58:41 UTC 2022
 # Running test: sysctl_test_0007 - run #0
 # Boot param test only possible sysctl_test is built-in, not module:
 # CONFIG_TEST_SYSCTL=m
 ok 1 selftests: sysctl: sysctl.sh

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
v2: add KUnit and selftests in commit msg
---
 fs/proc/proc_sysctl.c          |  2 +-
 include/linux/sysctl.h         | 13 +++++++------
 net/core/sysctl_net_core.c     | 14 +++++---------
 net/ipv4/sysctl_net_ipv4.c     | 16 ++++++----------
 net/ipv6/sysctl_net_ipv6.c     |  6 ++----
 net/netfilter/ipvs/ip_vs_ctl.c |  4 +---
 6 files changed, 22 insertions(+), 33 deletions(-)

diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 7d9cfc730bd4..0bdd9249666b 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -26,7 +26,7 @@ static const struct file_operations proc_sys_dir_file_operations;
 static const struct inode_operations proc_sys_dir_operations;
 
 /* shared constants to be used in various sysctls */
-const int sysctl_vals[] = { -1, 0, 1, 2, 4, 100, 200, 1000, 3000, INT_MAX, 65535 };
+const int sysctl_vals[] = { -1, 0, 1, 2, 3, 4, 100, 200, 1000, 3000, INT_MAX, 65535 };
 EXPORT_SYMBOL(sysctl_vals);
 
 const unsigned long sysctl_long_vals[] = { 0, 1, LONG_MAX };
diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index 6353d6db69b2..b2ac6542455f 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -42,12 +42,13 @@ struct ctl_dir;
 #define SYSCTL_ZERO			((void *)&sysctl_vals[1])
 #define SYSCTL_ONE			((void *)&sysctl_vals[2])
 #define SYSCTL_TWO			((void *)&sysctl_vals[3])
-#define SYSCTL_FOUR			((void *)&sysctl_vals[4])
-#define SYSCTL_ONE_HUNDRED		((void *)&sysctl_vals[5])
-#define SYSCTL_TWO_HUNDRED		((void *)&sysctl_vals[6])
-#define SYSCTL_ONE_THOUSAND		((void *)&sysctl_vals[7])
-#define SYSCTL_THREE_THOUSAND		((void *)&sysctl_vals[8])
-#define SYSCTL_INT_MAX			((void *)&sysctl_vals[9])
+#define SYSCTL_THREE			((void *)&sysctl_vals[4])
+#define SYSCTL_FOUR			((void *)&sysctl_vals[5])
+#define SYSCTL_ONE_HUNDRED		((void *)&sysctl_vals[6])
+#define SYSCTL_TWO_HUNDRED		((void *)&sysctl_vals[7])
+#define SYSCTL_ONE_THOUSAND		((void *)&sysctl_vals[8])
+#define SYSCTL_THREE_THOUSAND		((void *)&sysctl_vals[9])
+#define SYSCTL_INT_MAX			((void *)&sysctl_vals[10])
 
 /* this is needed for the proc_dointvec_minmax for [fs_]overflow UID and GID */
 #define SYSCTL_MAXOLDUID		((void *)&sysctl_vals[10])
diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index 7123fe7feeac..6ea51c155860 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -23,14 +23,10 @@
 #include <net/busy_poll.h>
 #include <net/pkt_sched.h>
 
-static int two = 2;
-static int three = 3;
 static int int_3600 = 3600;
 static int min_sndbuf = SOCK_MIN_SNDBUF;
 static int min_rcvbuf = SOCK_MIN_RCVBUF;
 static int max_skb_frags = MAX_SKB_FRAGS;
-static long long_one __maybe_unused = 1;
-static long long_max __maybe_unused = LONG_MAX;
 
 static int net_msg_warn;	/* Unused, but still a sysctl */
 
@@ -388,7 +384,7 @@ static struct ctl_table net_core_table[] = {
 		.extra2		= SYSCTL_ONE,
 # else
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= &two,
+		.extra2		= SYSCTL_TWO,
 # endif
 	},
 # ifdef CONFIG_HAVE_EBPF_JIT
@@ -399,7 +395,7 @@ static struct ctl_table net_core_table[] = {
 		.mode		= 0600,
 		.proc_handler	= proc_dointvec_minmax_bpf_restricted,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= &two,
+		.extra2		= SYSCTL_TWO,
 	},
 	{
 		.procname	= "bpf_jit_kallsyms",
@@ -417,7 +413,7 @@ static struct ctl_table net_core_table[] = {
 		.maxlen		= sizeof(long),
 		.mode		= 0600,
 		.proc_handler	= proc_dolongvec_minmax_bpf_restricted,
-		.extra1		= &long_one,
+		.extra1		= SYSCTL_LONG_ONE,
 		.extra2		= &bpf_jit_limit_max,
 	},
 #endif
@@ -544,7 +540,7 @@ static struct ctl_table net_core_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= &two,
+		.extra2		= SYSCTL_TWO,
 	},
 	{
 		.procname	= "devconf_inherit_init_net",
@@ -553,7 +549,7 @@ static struct ctl_table net_core_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= &three,
+		.extra2		= SYSCTL_THREE,
 	},
 	{
 		.procname	= "high_order_alloc_disable",
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index ad80d180b60b..cd448cdd3b38 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -20,10 +20,6 @@
 #include <net/protocol.h>
 #include <net/netevent.h>
 
-static int two = 2;
-static int three __maybe_unused = 3;
-static int four = 4;
-static int thousand = 1000;
 static int tcp_retr1_max = 255;
 static int ip_local_port_range_min[] = { 1, 1 };
 static int ip_local_port_range_max[] = { 65535, 65535 };
@@ -1006,7 +1002,7 @@ static struct ctl_table ipv4_net_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dou8vec_minmax,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= &two,
+		.extra2		= SYSCTL_TWO,
 	},
 	{
 		.procname	= "tcp_max_syn_backlog",
@@ -1059,7 +1055,7 @@ static struct ctl_table ipv4_net_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_fib_multipath_hash_policy,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= &three,
+		.extra2		= SYSCTL_THREE,
 	},
 	{
 		.procname	= "fib_multipath_hash_fields",
@@ -1117,7 +1113,7 @@ static struct ctl_table ipv4_net_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dou8vec_minmax,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= &four,
+		.extra2		= SYSCTL_FOUR,
 	},
 	{
 		.procname	= "tcp_recovery",
@@ -1310,7 +1306,7 @@ static struct ctl_table ipv4_net_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= &thousand,
+		.extra2		= SYSCTL_ONE_THOUSAND,
 	},
 	{
 		.procname	= "tcp_pacing_ca_ratio",
@@ -1319,7 +1315,7 @@ static struct ctl_table ipv4_net_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= &thousand,
+		.extra2		= SYSCTL_ONE_THOUSAND,
 	},
 	{
 		.procname	= "tcp_wmem",
@@ -1391,7 +1387,7 @@ static struct ctl_table ipv4_net_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dou8vec_minmax,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= &two,
+		.extra2		= SYSCTL_TWO,
 	},
 	{ }
 };
diff --git a/net/ipv6/sysctl_net_ipv6.c b/net/ipv6/sysctl_net_ipv6.c
index d53dd142bf87..94a0a294c6a1 100644
--- a/net/ipv6/sysctl_net_ipv6.c
+++ b/net/ipv6/sysctl_net_ipv6.c
@@ -23,8 +23,6 @@
 #endif
 #include <linux/ioam6.h>
 
-static int two = 2;
-static int three = 3;
 static int flowlabel_reflect_max = 0x7;
 static int auto_flowlabels_max = IP6_AUTO_FLOW_LABEL_MAX;
 static u32 rt6_multipath_hash_fields_all_mask =
@@ -172,7 +170,7 @@ static struct ctl_table ipv6_table_template[] = {
 		.mode		= 0644,
 		.proc_handler   = proc_rt6_multipath_hash_policy,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= &three,
+		.extra2		= SYSCTL_THREE,
 	},
 	{
 		.procname	= "fib_multipath_hash_fields",
@@ -197,7 +195,7 @@ static struct ctl_table ipv6_table_template[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dou8vec_minmax,
 		.extra1         = SYSCTL_ZERO,
-		.extra2         = &two,
+		.extra2         = SYSCTL_TWO,
 	},
 	{
 		.procname	= "ioam6_id",
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 7f645328b47f..efab2b06d373 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -1767,8 +1767,6 @@ static int ip_vs_zero_all(struct netns_ipvs *ipvs)
 
 #ifdef CONFIG_SYSCTL
 
-static int three = 3;
-
 static int
 proc_do_defense_mode(struct ctl_table *table, int write,
 		     void *buffer, size_t *lenp, loff_t *ppos)
@@ -1977,7 +1975,7 @@ static struct ctl_table vs_vars[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= &three,
+		.extra2		= SYSCTL_THREE,
 	},
 	{
 		.procname	= "nat_icmp_send",
-- 
2.27.0

