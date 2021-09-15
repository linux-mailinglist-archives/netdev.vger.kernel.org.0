Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEFE840BF2C
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 07:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236297AbhIOFLc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 01:11:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236292AbhIOFLW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 01:11:22 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4210EC0613D8;
        Tue, 14 Sep 2021 22:10:04 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id g184so1541040pgc.6;
        Tue, 14 Sep 2021 22:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yGr9iACuV6BoX7TnMjNVhLVmAfdKWT67ERnimSMzQJU=;
        b=Ozv2Y5fzYZgdIGcpfERY6WJdVgMmuXZ7g+xnpHKn1YLd/yUrD+mGYsKEIUSsCzTe67
         srukjThS64/e7j6pVKz3BqKDRzcJEonFSB+Xo1nKn1Aa56TA+CRErXs6GwAFPYf2pivB
         HLEz099ID4X0+77Z0F4exxKUT1ypm9NL55UGxF227CmTxXsDvLBg12/5drvdq3kNwlsx
         v4FUeCoIQgeKPos2IGEIlhuXn5TMpfQL4dOdIeL6rTso9UjwVohFnIOM/eVhnxVAd/GU
         RaMXIX6wn0dzEAtZsok9CwK/j7SnYBuRzAWLjx8sk+vqjF0O77KXZfcctWE4KmGUeN4/
         9kXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yGr9iACuV6BoX7TnMjNVhLVmAfdKWT67ERnimSMzQJU=;
        b=U/4uCPiw3iMB5RwaXS2SzNjb7XrfRMEkE9MUIf1rc4IGz09+osPUhUvxnojf3lqBRD
         DC/sshpzhhgFFXSzN2jIwMPg25GcAuVY0szVxVagJwo8MFtAFEDIjv06AUZUvrlQEUxb
         f74A9a9f8/FPSqXKcQpTmHr5lVtj3PAQvZwcJty0WhNS8+50MafRcAqR/cA0//cFJ/H9
         fABa5bUutt8w6a43lR4RHFkaEGqDJMymlwGre98seFKZxtTVT2IVOv+jwhzTkiYmagpO
         VNtHQKIb+5tijOBHW2vqOjThXbL5wqlaiNI3B6MjhHJsLIWaFIBHvsdiSeujNQXNvJzX
         6dxw==
X-Gm-Message-State: AOAM531XVADEI1rrafdVL4WnyC4K4c8eLbYLNeFrV0GC3oV4GeUmW0lp
        Xh1RMlQYjBa0rsRlkyYSEBEIeGRckm6HZg==
X-Google-Smtp-Source: ABdhPJxAnUGtrD3wPIooUxYyMXP6vXIdPNFc2+ssd2gvZfgMBsrMPfQ6+8NpGl3Z24mVVfZDQ8rVGg==
X-Received: by 2002:a05:6a00:a23:b0:43d:e856:a3d4 with SMTP id p35-20020a056a000a2300b0043de856a3d4mr8530023pfh.17.1631682603571;
        Tue, 14 Sep 2021 22:10:03 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id z17sm3627633pfh.110.2021.09.14.22.10.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 22:10:03 -0700 (PDT)
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
Subject: [PATCH bpf-next v3 05/10] bpf: Enable TCP congestion control kfunc from modules
Date:   Wed, 15 Sep 2021 10:39:38 +0530
Message-Id: <20210915050943.679062-6-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210915050943.679062-1-memxor@gmail.com>
References: <20210915050943.679062-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=9235; h=from:subject; bh=DKtrsf0TcthrgG/VRKnYyF97AuWzH3768PxQ2CQccBU=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhQX4bYQ953eMkGd8AAWtVAvZlgF+ZL5LsDP3U9Sn7 9pFqXuOJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYUF+GwAKCRBM4MiGSL8RyjE/D/ 90GmI0Ze83yFMpQ9D65HQYlsHtfjbC6UrzGeqqYmsSsrs0f71jxUFi9v3EmUlXmdOYMwK+g6c/7Jsk IxNsp1uT9OqVqdhrnoorivSHUMk0S2uKDaz3jDlZGoGh/TjFmxLLM80MF+3mhwB03F3g+rKjWVIuIR t+k5GMVvMwx0s0Mq2tv8GtQTRkdDDyggVS7N1P/CjRr32CT92z9NqV/JEubmpvtLzrUwOHG9wWISWp u8yweEWITwERxRrLuEfx+g0NWW5d0ueWcFoHDFJKBxe9vjxqgVoBRL4l7FljMlaZMDzTA9AJJACglr IpCg6RRShgbfvODT4Tqtk+ZMVHrruze5GCOO0AEX8qTS6///j7upMaRF3uqLD7tNctp92kQX1Gfbro vDpj0WsWyMD9iPcU770hD+gKb0D7bN9cDd5LA9zQf1BAs8UDViKI9M8TvUBGDc63GyKQPC7PguMW4y FL+mpi/Yrbr7j0bYjaH0TCnpibbo2lD9KVeWeDYAliq8jJBB76+OWx4UBTuO9Mn44MKm/fJw863MrS /fecENvmECwKA7XT0/LuS/U1xLiqC5bf/GtL00WcOJnx8teKAz0aLmK4Nj8STQ3SzHLbcGHuXxserr xDD+MTWKi2VBPOJaNk/qaNskWjmAJT4I7Zk7B7ZWjhfTjiZ4AabIpfvAwOug==
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
index d17f45b163f5..671b4f713a51 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6394,3 +6394,6 @@ EXPORT_SYMBOL_GPL(unregister_kfunc_btf_id_set);
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

