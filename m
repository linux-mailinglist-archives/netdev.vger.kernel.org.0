Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25356502DD3
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 18:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355879AbiDOQmq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 12:42:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355896AbiDOQmf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 12:42:35 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16C147487B
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 09:40:06 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id 125so7667353pgc.11
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 09:40:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=u54GN7wbelZ8d4yAA5EOMYLlgpa2LlLO5H9alYn9tAE=;
        b=J5P+uzzqowag4Ym8b+2ONX2smRb5bdZh6dbxhaJAiF5fJNlFyfOdCkiDyTWqcPz7DR
         K68UZqfq2X7YbjXK4fLeWfnJvA19vIZoM3w5sZrX0x/bPXwL7xg9MVa832HcrUFEfR58
         +VcGuvD3W5saPnNCuG3VPFS2Hag2U5FkHh77OMmc6hwC7W68pCmN3Jx2MnJnspKDA1rg
         BRnRz9omz+tTs5MI3clXM6Ld371t4S8Fv/FaxIjt5zWNShGP4gnkJiA984XwgmxHRmPe
         kVlNxGzZYTbOxqKJWf3obuv7x3iARZtjKjx9/CwG+YSuEloiZPBg0JBu4JrHqsxkNDWx
         WakA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u54GN7wbelZ8d4yAA5EOMYLlgpa2LlLO5H9alYn9tAE=;
        b=otZ/nYZpy3hFgUo/wjFqPNFDWF0OgtCIqD+El52FDN7bEFmT03SGpAtiCzw1KUHyyC
         /KI6a41nGK+b/iWyMQSd/QxVCe0QzMV/RPcWKH6KgJqsDwLajM2L+JL3PPclTKDoCeRH
         eeax70FRSa7saLRbmNTQFSsQuncnkrGJqQfq2y1RpgbGwsxT57u6P13i2xOg8hXoYaI6
         OTGiMOOj09VDGfFIhvQahI5IikSRI/54+h4hSMtJnfdcWH/sZcrh4sYqCdgMBSsCzfxD
         8SUddi0edHN33GDeb+CM0rSOcoudyHVppFeSsJSjI/rgOXFEhe4h1R2GMb+iLxaEzc36
         TnkQ==
X-Gm-Message-State: AOAM533zn2L5kPw7rneWWs96BIX9UOU8wEyxcW0A6riazXvRW37q4r6r
        J1L7AWggMLWCZJVghU8Z5FQNYYW4SrurrvX+
X-Google-Smtp-Source: ABdhPJxASKet4i+AHyCb4h4J3cvuwhtu5IlenmNa6sSJOZShd7c8RwaItwYIaWp+vTNMPeFmbRtYeQ==
X-Received: by 2002:a05:6a00:724:b0:4fa:a35f:8e0f with SMTP id 4-20020a056a00072400b004faa35f8e0fmr20494827pfm.25.1650040805287;
        Fri, 15 Apr 2022 09:40:05 -0700 (PDT)
Received: from localhost.localdomain ([111.201.148.136])
        by smtp.gmail.com with ESMTPSA id y13-20020a17090a154d00b001cb5f0b55cfsm5598077pja.1.2022.04.15.09.40.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Apr 2022 09:40:04 -0700 (PDT)
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
Subject: [PATCH v3 2/2] net: sysctl: introduce sysctl SYSCTL_THREE
Date:   Sat, 16 Apr 2022 00:39:12 +0800
Message-Id: <20220415163912.26530-3-xiangxia.m.yue@gmail.com>
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

This patch introdues the SYSCTL_THREE.

KUnit:
[00:10:14] ================ sysctl_test (10 subtests) =================
[00:10:14] [PASSED] sysctl_test_api_dointvec_null_tbl_data
[00:10:14] [PASSED] sysctl_test_api_dointvec_table_maxlen_unset
[00:10:14] [PASSED] sysctl_test_api_dointvec_table_len_is_zero
[00:10:14] [PASSED] sysctl_test_api_dointvec_table_read_but_position_set
[00:10:14] [PASSED] sysctl_test_dointvec_read_happy_single_positive
[00:10:14] [PASSED] sysctl_test_dointvec_read_happy_single_negative
[00:10:14] [PASSED] sysctl_test_dointvec_write_happy_single_positive
[00:10:14] [PASSED] sysctl_test_dointvec_write_happy_single_negative
[00:10:14] [PASSED] sysctl_test_api_dointvec_write_single_less_int_min
[00:10:14] [PASSED] sysctl_test_api_dointvec_write_single_greater_int_max
[00:10:14] =================== [PASSED] sysctl_test ===================

./run_kselftest.sh -c sysctl
...
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
 fs/proc/proc_sysctl.c          | 2 +-
 include/linux/sysctl.h         | 9 +++++----
 net/core/sysctl_net_core.c     | 3 +--
 net/ipv4/sysctl_net_ipv4.c     | 3 +--
 net/ipv6/sysctl_net_ipv6.c     | 3 +--
 net/netfilter/ipvs/ip_vs_ctl.c | 4 +---
 6 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 7d9cfc730bd4..5851c2a92c0d 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -26,7 +26,7 @@ static const struct file_operations proc_sys_dir_file_operations;
 static const struct inode_operations proc_sys_dir_operations;
 
 /* shared constants to be used in various sysctls */
-const int sysctl_vals[] = { -1, 0, 1, 2, 4, 100, 200, 1000, 3000, INT_MAX, 65535 };
+const int sysctl_vals[] = { 0, 1, 2, 3, 4, 100, 200, 1000, 3000, INT_MAX, 65535, -1 };
 EXPORT_SYMBOL(sysctl_vals);
 
 const unsigned long sysctl_long_vals[] = { 0, 1, LONG_MAX };
diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index 6353d6db69b2..80263f7cdb77 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -38,10 +38,10 @@ struct ctl_table_header;
 struct ctl_dir;
 
 /* Keep the same order as in fs/proc/proc_sysctl.c */
-#define SYSCTL_NEG_ONE			((void *)&sysctl_vals[0])
-#define SYSCTL_ZERO			((void *)&sysctl_vals[1])
-#define SYSCTL_ONE			((void *)&sysctl_vals[2])
-#define SYSCTL_TWO			((void *)&sysctl_vals[3])
+#define SYSCTL_ZERO			((void *)&sysctl_vals[0])
+#define SYSCTL_ONE			((void *)&sysctl_vals[1])
+#define SYSCTL_TWO			((void *)&sysctl_vals[2])
+#define SYSCTL_THREE			((void *)&sysctl_vals[3])
 #define SYSCTL_FOUR			((void *)&sysctl_vals[4])
 #define SYSCTL_ONE_HUNDRED		((void *)&sysctl_vals[5])
 #define SYSCTL_TWO_HUNDRED		((void *)&sysctl_vals[6])
@@ -51,6 +51,7 @@ struct ctl_dir;
 
 /* this is needed for the proc_dointvec_minmax for [fs_]overflow UID and GID */
 #define SYSCTL_MAXOLDUID		((void *)&sysctl_vals[10])
+#define SYSCTL_NEG_ONE			((void *)&sysctl_vals[11])
 
 extern const int sysctl_vals[];
 
diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index 3a0ce309ffcd..195ca5c28771 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -25,7 +25,6 @@
 
 #include "dev.h"
 
-static int three = 3;
 static int int_3600 = 3600;
 static int min_sndbuf = SOCK_MIN_SNDBUF;
 static int min_rcvbuf = SOCK_MIN_RCVBUF;
@@ -553,7 +552,7 @@ static struct ctl_table net_core_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= &three,
+		.extra2		= SYSCTL_THREE,
 	},
 	{
 		.procname	= "high_order_alloc_disable",
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 9ff60a389cd0..cd448cdd3b38 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -20,7 +20,6 @@
 #include <net/protocol.h>
 #include <net/netevent.h>
 
-static int three __maybe_unused = 3;
 static int tcp_retr1_max = 255;
 static int ip_local_port_range_min[] = { 1, 1 };
 static int ip_local_port_range_max[] = { 65535, 65535 };
@@ -1056,7 +1055,7 @@ static struct ctl_table ipv4_net_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_fib_multipath_hash_policy,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= &three,
+		.extra2		= SYSCTL_THREE,
 	},
 	{
 		.procname	= "fib_multipath_hash_fields",
diff --git a/net/ipv6/sysctl_net_ipv6.c b/net/ipv6/sysctl_net_ipv6.c
index 560c48d0ddb7..94a0a294c6a1 100644
--- a/net/ipv6/sysctl_net_ipv6.c
+++ b/net/ipv6/sysctl_net_ipv6.c
@@ -23,7 +23,6 @@
 #endif
 #include <linux/ioam6.h>
 
-static int three = 3;
 static int flowlabel_reflect_max = 0x7;
 static int auto_flowlabels_max = IP6_AUTO_FLOW_LABEL_MAX;
 static u32 rt6_multipath_hash_fields_all_mask =
@@ -171,7 +170,7 @@ static struct ctl_table ipv6_table_template[] = {
 		.mode		= 0644,
 		.proc_handler   = proc_rt6_multipath_hash_policy,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= &three,
+		.extra2		= SYSCTL_THREE,
 	},
 	{
 		.procname	= "fib_multipath_hash_fields",
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

