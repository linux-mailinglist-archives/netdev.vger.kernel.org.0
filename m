Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B04740ADF1
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 14:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233015AbhINMje (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 08:39:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232983AbhINMjb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 08:39:31 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28A50C0613D8;
        Tue, 14 Sep 2021 05:38:13 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id f65so12058062pfb.10;
        Tue, 14 Sep 2021 05:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mqoITvHXLse1CtgZzTC8zsmR2oDKQ32w61pGdrlO134=;
        b=lJ/sga4HKlMyCBXCYuA5kbsp4SYbtcR+SY2VkTI7Sz55h0xfax3oHFMEG7m3e30Os7
         CwqUzabjIvNUi+r12XD6fGp4LkKlQncPAN8eXQcngpOlt+bfzP9sG1VcSP/gU0MZN7H/
         +dHKCFTXhgef19sEjM+7QzPstsLqYMj0NRRHuwESqXnQ0jZgb8xfiGQrKLStwTG3tdan
         vISeloNS4+evglIIjqgooMCtUHBEJlmuqTef2PkyTK9C0mkBw9ajIVveVrjTX5eB1Yz1
         Jh4XZnmpOf9LVOppKBbXpOFkFgZyKT4KYrhI5vFXb3PEj/drO9GsrWgWZs+2cUFuVRD0
         XC6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mqoITvHXLse1CtgZzTC8zsmR2oDKQ32w61pGdrlO134=;
        b=foMfLR0ahL4Ax7cFKIg7RFHjgDOX5jqkcDZIfvZO/pFybJhxyNtAzcUrPGp3cePwgE
         J3Gg6KVvsBqtcHUMBgqGcRU9p0eemqbgyXNo21MUayIKRLdcdV39mBUcuOwRyDKSxrHT
         F29h3Ny7Pb9WL5IHBCt20mqy2Y6BsYBdtCH4J2CT8yWtiiWUWHlvfkvesgpAA3/1ZhbP
         UNjpQdI9JmmYvrJhVm141W9ga/i0GOOom06+0fmXKV3RtbShU1dQ3Y+2Sm/8dDAqv+aH
         RknIsVr7/OVQHPCI3hwMn2sbYkEWE6ABpUZBM3ybC5zcTKl7q5T4lJ7j5C9/81RcJRb3
         nGSg==
X-Gm-Message-State: AOAM533BUGHDyrDJfpL/OV8fFjBZ/+YD0keCFdsbNTaZNItcBwDBnAIU
        6DBSZeWxxCy+7Y1ZLV5W2Ab3P5sjFKzplw==
X-Google-Smtp-Source: ABdhPJxV7JnLNfkztxhRoKJYAbyGK3ELCIib71XYQ+IkgDUdOV88aWxza3m9xZJEQzrBgAyq1Vhlew==
X-Received: by 2002:a63:4c1f:: with SMTP id z31mr15479907pga.50.1631623092349;
        Tue, 14 Sep 2021 05:38:12 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id j128sm10708893pfd.38.2021.09.14.05.38.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 05:38:12 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v2 05/10] bpf: Enable TCP congestion control kfunc from modules
Date:   Tue, 14 Sep 2021 18:07:44 +0530
Message-Id: <20210914123750.460750-6-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210914123750.460750-1-memxor@gmail.com>
References: <20210914123750.460750-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=9235; h=from:subject; bh=m9TZ+KdIbneN6+JbSrnpTeto3oY8+468yP/Y99kWUeA=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhQJdW+lyJs/2rzqQm9zAFAR9Ff5iaBUkPwjsAUNGP CiQrob+JAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYUCXVgAKCRBM4MiGSL8RykwZD/ 4rjozNckLlXgbTbcn1m/+Ujnk4/P7pdGulpMr4tMVpKxOjv4ZLImlqsJpAMRUlwLOCyNilqe04dPvl aZ6L4tJqTDmGkO5PRwX5WZw2LFWtivTwOpDU/wPSM5A1M9wnscvyTPj5kwiRiy9C6mUyndB8zRX9ck 2OC+H1iJ8U8fBZHoXfzR+7trw+oFc0aG4qQ2f1kuWdXxbA+ZuhL7ImKr05zpwWz3kS7a+4Q7nMuok+ 7GZT7URRhUZfnZv+yjX6VYrXC9ik+vrUiXtaIp2+XWpokmyWNDvxT5dZvepXTNinTd0Ka5aqmgug7u Od50CPzmwtivFRW5HPYyhRuusykrnTENK2Cz0+WjUgJ9yk0jF/irJ41Jt/vANvLDnvEr6gDeznibcx bFSw5EuouVx/u0HMIjeOpUq3iAcdU3PBbN1s1bQ00HYalP3Zz+IDRHT+4h1zmBKLjdiVHXJHXPKOPr aq0g/fsWLifjEPdHyUiKzn8F1n3/dNLRXeevyDokio+cwuO4FMOEW43sIsMfgTIsXLo7AjwABPC7rI 1ZDfXgT1RY/fAaMkvf8w8E1IH4Ao8tmiY6tY49CPWRkKL6IjDWHiUjxC9eQL7RU3Lo22ZRseD6iakt w4t3IVBPn8dPRTiHl1poDeAhB8yVxlCxXyq6AIIoVR7XSpvumHgMM8u7Ti1g==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit moves BTF ID lookup into the newly added registration
helper, in a way that the bbr, cubic, and dctcp implementation set up
their sets in the bpf_tcp_ca kfunc_btf_set list, while the ones not
dependent on modules are looked up from the wrapper function.

This lifts the restriction for them to be compiled as built in objects,
and can be loaded as modules if required. Also modify Makefile.modfinal
to resolve_btfids in TCP congestion control modules if the config option
is set, using the base BTF support added in the previous commit.

See following commits for background on use of:

 CONFIG_X86 ifdef:
 569c484f9995 (bpf: Limit static tcp-cc functions in the .BTF_ids list to x86)

 CONFIG_DYNAMIC_FTRACE ifdef:
 7aae231ac93b (bpf: tcp: Limit calling some tcp cc functions to CONFIG_DYNAMIC_FTRACE)

[ resolve_btfids uses --no-fail because some crypto kernel modules
  under arch/x86/crypto generated from ASM do not have the .BTF sections ]

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/linux/btf.h       |  4 ++++
 kernel/bpf/btf.c          |  3 +++
 net/ipv4/bpf_tcp_ca.c     | 34 +++-------------------------------
 net/ipv4/tcp_bbr.c        | 28 +++++++++++++++++++++++++++-
 net/ipv4/tcp_cubic.c      | 26 +++++++++++++++++++++++++-
 net/ipv4/tcp_dctcp.c      | 26 +++++++++++++++++++++++++-
 scripts/Makefile.modfinal |  1 +
 7 files changed, 88 insertions(+), 34 deletions(-)

diff --git a/include/linux/btf.h b/include/linux/btf.h
index e29a486d09d4..c7b6382123e1 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -270,4 +270,8 @@ static inline void unregister_kfunc_btf_id_set(struct kfunc_btf_id_list *l,
 	struct kfunc_btf_id_set name = { LIST_HEAD_INIT(name.list), (set),     \
 					 THIS_MODULE }
 
+extern struct kfunc_btf_id_list bpf_tcp_ca_kfunc_list;
+
+DECLARE_CHECK_KFUNC_CALLBACK(bpf_tcp_ca);
+
 #endif
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index eecafed56300..8240478b7398 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6266,3 +6266,6 @@ EXPORT_SYMBOL_GPL(unregister_kfunc_btf_id_set);
 		mutex_unlock(&list_name.mutex);                                \
 		return false;                                                  \
 	}
+
+DEFINE_KFUNC_BTF_ID_LIST(bpf_tcp_ca_kfunc_list);
+DEFINE_CHECK_KFUNC_CALLBACK(bpf_tcp_ca, bpf_tcp_ca_kfunc_list);
diff --git a/net/ipv4/bpf_tcp_ca.c b/net/ipv4/bpf_tcp_ca.c
index b3afd3361f34..c9f1d2dcf67b 100644
--- a/net/ipv4/bpf_tcp_ca.c
+++ b/net/ipv4/bpf_tcp_ca.c
@@ -223,41 +223,13 @@ BTF_ID(func, tcp_reno_cong_avoid)
 BTF_ID(func, tcp_reno_undo_cwnd)
 BTF_ID(func, tcp_slow_start)
 BTF_ID(func, tcp_cong_avoid_ai)
-#ifdef CONFIG_X86
-#ifdef CONFIG_DYNAMIC_FTRACE
-#if IS_BUILTIN(CONFIG_TCP_CONG_CUBIC)
-BTF_ID(func, cubictcp_init)
-BTF_ID(func, cubictcp_recalc_ssthresh)
-BTF_ID(func, cubictcp_cong_avoid)
-BTF_ID(func, cubictcp_state)
-BTF_ID(func, cubictcp_cwnd_event)
-BTF_ID(func, cubictcp_acked)
-#endif
-#if IS_BUILTIN(CONFIG_TCP_CONG_DCTCP)
-BTF_ID(func, dctcp_init)
-BTF_ID(func, dctcp_update_alpha)
-BTF_ID(func, dctcp_cwnd_event)
-BTF_ID(func, dctcp_ssthresh)
-BTF_ID(func, dctcp_cwnd_undo)
-BTF_ID(func, dctcp_state)
-#endif
-#if IS_BUILTIN(CONFIG_TCP_CONG_BBR)
-BTF_ID(func, bbr_init)
-BTF_ID(func, bbr_main)
-BTF_ID(func, bbr_sndbuf_expand)
-BTF_ID(func, bbr_undo_cwnd)
-BTF_ID(func, bbr_cwnd_event)
-BTF_ID(func, bbr_ssthresh)
-BTF_ID(func, bbr_min_tso_segs)
-BTF_ID(func, bbr_set_state)
-#endif
-#endif  /* CONFIG_DYNAMIC_FTRACE */
-#endif	/* CONFIG_X86 */
 BTF_SET_END(bpf_tcp_ca_kfunc_ids)
 
 static bool bpf_tcp_ca_check_kfunc_call(u32 kfunc_btf_id, struct module *owner)
 {
-	return btf_id_set_contains(&bpf_tcp_ca_kfunc_ids, kfunc_btf_id);
+	if (btf_id_set_contains(&bpf_tcp_ca_kfunc_ids, kfunc_btf_id))
+		return true;
+	return __bpf_check_bpf_tcp_ca_kfunc_call(kfunc_btf_id, owner);
 }
 
 static const struct bpf_verifier_ops bpf_tcp_ca_verifier_ops = {
diff --git a/net/ipv4/tcp_bbr.c b/net/ipv4/tcp_bbr.c
index 6274462b86b4..ec5550089b4d 100644
--- a/net/ipv4/tcp_bbr.c
+++ b/net/ipv4/tcp_bbr.c
@@ -56,6 +56,8 @@
  * otherwise TCP stack falls back to an internal pacing using one high
  * resolution timer per TCP socket and may use more resources.
  */
+#include <linux/btf.h>
+#include <linux/btf_ids.h>
 #include <linux/module.h>
 #include <net/tcp.h>
 #include <linux/inet_diag.h>
@@ -1152,14 +1154,38 @@ static struct tcp_congestion_ops tcp_bbr_cong_ops __read_mostly = {
 	.set_state	= bbr_set_state,
 };
 
+BTF_SET_START(tcp_bbr_kfunc_ids)
+#ifdef CONFIG_X86
+#ifdef CONFIG_DYNAMIC_FTRACE
+BTF_ID(func, bbr_init)
+BTF_ID(func, bbr_main)
+BTF_ID(func, bbr_sndbuf_expand)
+BTF_ID(func, bbr_undo_cwnd)
+BTF_ID(func, bbr_cwnd_event)
+BTF_ID(func, bbr_ssthresh)
+BTF_ID(func, bbr_min_tso_segs)
+BTF_ID(func, bbr_set_state)
+#endif
+#endif
+BTF_SET_END(tcp_bbr_kfunc_ids)
+
+static DEFINE_KFUNC_BTF_ID_SET(&tcp_bbr_kfunc_ids, tcp_bbr_kfunc_btf_set);
+
 static int __init bbr_register(void)
 {
+	int ret;
+
 	BUILD_BUG_ON(sizeof(struct bbr) > ICSK_CA_PRIV_SIZE);
-	return tcp_register_congestion_control(&tcp_bbr_cong_ops);
+	ret = tcp_register_congestion_control(&tcp_bbr_cong_ops);
+	if (ret)
+		return ret;
+	register_kfunc_btf_id_set(&bpf_tcp_ca_kfunc_list, &tcp_bbr_kfunc_btf_set);
+	return 0;
 }
 
 static void __exit bbr_unregister(void)
 {
+	unregister_kfunc_btf_id_set(&bpf_tcp_ca_kfunc_list, &tcp_bbr_kfunc_btf_set);
 	tcp_unregister_congestion_control(&tcp_bbr_cong_ops);
 }
 
diff --git a/net/ipv4/tcp_cubic.c b/net/ipv4/tcp_cubic.c
index 4a30deaa9a37..5e9d9c51164c 100644
--- a/net/ipv4/tcp_cubic.c
+++ b/net/ipv4/tcp_cubic.c
@@ -25,6 +25,8 @@
  */
 
 #include <linux/mm.h>
+#include <linux/btf.h>
+#include <linux/btf_ids.h>
 #include <linux/module.h>
 #include <linux/math64.h>
 #include <net/tcp.h>
@@ -482,8 +484,25 @@ static struct tcp_congestion_ops cubictcp __read_mostly = {
 	.name		= "cubic",
 };
 
+BTF_SET_START(tcp_cubic_kfunc_ids)
+#ifdef CONFIG_X86
+#ifdef CONFIG_DYNAMIC_FTRACE
+BTF_ID(func, cubictcp_init)
+BTF_ID(func, cubictcp_recalc_ssthresh)
+BTF_ID(func, cubictcp_cong_avoid)
+BTF_ID(func, cubictcp_state)
+BTF_ID(func, cubictcp_cwnd_event)
+BTF_ID(func, cubictcp_acked)
+#endif
+#endif
+BTF_SET_END(tcp_cubic_kfunc_ids)
+
+static DEFINE_KFUNC_BTF_ID_SET(&tcp_cubic_kfunc_ids, tcp_cubic_kfunc_btf_set);
+
 static int __init cubictcp_register(void)
 {
+	int ret;
+
 	BUILD_BUG_ON(sizeof(struct bictcp) > ICSK_CA_PRIV_SIZE);
 
 	/* Precompute a bunch of the scaling factors that are used per-packet
@@ -514,11 +533,16 @@ static int __init cubictcp_register(void)
 	/* divide by bic_scale and by constant Srtt (100ms) */
 	do_div(cube_factor, bic_scale * 10);
 
-	return tcp_register_congestion_control(&cubictcp);
+	ret = tcp_register_congestion_control(&cubictcp);
+	if (ret)
+		return ret;
+	register_kfunc_btf_id_set(&bpf_tcp_ca_kfunc_list, &tcp_cubic_kfunc_btf_set);
+	return 0;
 }
 
 static void __exit cubictcp_unregister(void)
 {
+	unregister_kfunc_btf_id_set(&bpf_tcp_ca_kfunc_list, &tcp_cubic_kfunc_btf_set);
 	tcp_unregister_congestion_control(&cubictcp);
 }
 
diff --git a/net/ipv4/tcp_dctcp.c b/net/ipv4/tcp_dctcp.c
index 79f705450c16..0d7ab3cc7b61 100644
--- a/net/ipv4/tcp_dctcp.c
+++ b/net/ipv4/tcp_dctcp.c
@@ -36,6 +36,8 @@
  *	Glenn Judd <glenn.judd@morganstanley.com>
  */
 
+#include <linux/btf.h>
+#include <linux/btf_ids.h>
 #include <linux/module.h>
 #include <linux/mm.h>
 #include <net/tcp.h>
@@ -236,14 +238,36 @@ static struct tcp_congestion_ops dctcp_reno __read_mostly = {
 	.name		= "dctcp-reno",
 };
 
+BTF_SET_START(tcp_dctcp_kfunc_ids)
+#ifdef CONFIG_X86
+#ifdef CONFIG_DYNAMIC_FTRACE
+BTF_ID(func, dctcp_init)
+BTF_ID(func, dctcp_update_alpha)
+BTF_ID(func, dctcp_cwnd_event)
+BTF_ID(func, dctcp_ssthresh)
+BTF_ID(func, dctcp_cwnd_undo)
+BTF_ID(func, dctcp_state)
+#endif
+#endif
+BTF_SET_END(tcp_dctcp_kfunc_ids)
+
+static DEFINE_KFUNC_BTF_ID_SET(&tcp_dctcp_kfunc_ids, tcp_dctcp_kfunc_btf_set);
+
 static int __init dctcp_register(void)
 {
+	int ret;
+
 	BUILD_BUG_ON(sizeof(struct dctcp) > ICSK_CA_PRIV_SIZE);
-	return tcp_register_congestion_control(&dctcp);
+	ret = tcp_register_congestion_control(&dctcp);
+	if (ret)
+		return ret;
+	register_kfunc_btf_id_set(&bpf_tcp_ca_kfunc_list, &tcp_dctcp_kfunc_btf_set);
+	return 0;
 }
 
 static void __exit dctcp_unregister(void)
 {
+	unregister_kfunc_btf_id_set(&bpf_tcp_ca_kfunc_list, &tcp_dctcp_kfunc_btf_set);
 	tcp_unregister_congestion_control(&dctcp);
 }
 
diff --git a/scripts/Makefile.modfinal b/scripts/Makefile.modfinal
index ff805777431c..b4f83533eda6 100644
--- a/scripts/Makefile.modfinal
+++ b/scripts/Makefile.modfinal
@@ -41,6 +41,7 @@ quiet_cmd_btf_ko = BTF [M] $@
       cmd_btf_ko = 							\
 	if [ -f vmlinux ]; then						\
 		LLVM_OBJCOPY="$(OBJCOPY)" $(PAHOLE) -J --btf_base vmlinux $@; \
+		$(RESOLVE_BTFIDS) --no-fail -s vmlinux $@; 		\
 	else								\
 		printf "Skipping BTF generation for %s due to unavailability of vmlinux\n" $@ 1>&2; \
 	fi;
-- 
2.33.0

