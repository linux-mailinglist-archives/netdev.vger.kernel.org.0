Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7309516152
	for <lists+netdev@lfdr.de>; Sun,  1 May 2022 05:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239471AbiEAD7x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Apr 2022 23:59:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbiEAD7q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Apr 2022 23:59:46 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F9DC3DA4C;
        Sat, 30 Apr 2022 20:56:20 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id x23so4684440pff.9;
        Sat, 30 Apr 2022 20:56:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YexJgFvpQcfqfZTZS8UGyxjxKNfSDCViBAnAI2GLdq4=;
        b=ZcGI1Fgtu2kxLFYwNw6YdEhSw5RqVMSFBkvrsGx75b7ivx8u6TucXGja/o86zXtYVL
         PP0FMqzDL6PQl7J+vVyBjaNjd7KE82rNV23+3/Vwn0bWFol2NfZaLg4BNQlQdo4fbC3p
         qItbalYMfCwKpD0lByfXaEER1i5/cowzOp9Tt0vjFkm3PFjRow2zUCU6VQdpLn3ToL4d
         zr/0qC6Z80GSBk5fj85mqgqgk1A0VRqDEbgy47MvQqA/ee4XV/z7v6NXWHM9sO/KZfl+
         ZN9nJXX4Gkm4cIURo1CB3qswC4Fg1frBXe1tqEyYYhovRlgtlfmj9YQ6/JJlo2F2FwSW
         O9aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YexJgFvpQcfqfZTZS8UGyxjxKNfSDCViBAnAI2GLdq4=;
        b=PwLhLGPjCbhmCGU8jFX+H7zPV4Lb3PXIKARiwZ3c4MO9ZvkQfvB09HFOshuufgQo04
         FEvyQJmPs1Uye/urgTaPk3FhqdBAWkd24DUz/fK0bypOY1IUaHoEvo1f0NNKp0+Arw9F
         QVUqs2oTml4AbH3Tq8edtFnGYLJGDn7uApt8zCuvS45gk0BSmfGK0I2/MGv9rEUWEsZa
         cFwDCdvThjPKhSowOqUbNG6u7sTB1sNs+Xvf6zC7wiRYh42LsbT678PZxCfyWjQlYgSa
         qQt/HliFRfr8A7uhukFcJ/hN7dtqB7+Fne8lGvLZYya9fn+Q3M6x93FaXy7ToeEAlLSW
         TF+A==
X-Gm-Message-State: AOAM532p/rvOlMcQ3t2wyI31y+NwxtH4LdH17Qc6onffG+nYkJaDVAOZ
        22FwyuYKuGUGurRb/wtUNIfAAGyM9QfLhA==
X-Google-Smtp-Source: ABdhPJym9Ixf46gEWBdp+sJXAh1SqJZ420G7wDrEb8coCxMvE2SrhWELDmWLmufgYeequrJ0WsWrjw==
X-Received: by 2002:a63:8549:0:b0:3ab:3197:3efc with SMTP id u70-20020a638549000000b003ab31973efcmr4946732pgd.137.1651377379371;
        Sat, 30 Apr 2022 20:56:19 -0700 (PDT)
Received: from bogon.xiaojukeji.com ([111.201.149.168])
        by smtp.gmail.com with ESMTPSA id q9-20020a654949000000b003c1d946af6csm1767863pgs.32.2022.04.30.20.56.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 30 Apr 2022 20:56:18 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org
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
Subject: [PATCH v5 2/3] net: sysctl: introduce sysctl SYSCTL_THREE
Date:   Sun,  1 May 2022 11:55:23 +0800
Message-Id: <20220501035524.91205-3-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20220501035524.91205-1-xiangxia.m.yue@gmail.com>
References: <20220501035524.91205-1-xiangxia.m.yue@gmail.com>
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

