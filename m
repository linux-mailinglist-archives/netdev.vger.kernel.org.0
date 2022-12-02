Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6B126403EA
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 10:59:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233180AbiLBJ7m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 04:59:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232918AbiLBJ7l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 04:59:41 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFE41C868A;
        Fri,  2 Dec 2022 01:59:39 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id f18so7013967wrj.5;
        Fri, 02 Dec 2022 01:59:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9F1UFiR0qtpe3Of8uQAylQhK0bHGnBVcigqtNrHL9oM=;
        b=Qi5TgWf7WZjb2IFrI9MODu9zJgGRT1S+vJCcYNhWnhG1HTXXkSzy/J50okgtu454gS
         EAuxv562xKbZcCksjxcqCZqjePWJBIkHhJelgmoI1jnZl5z62kU3c0bcRW3cQr3E1Nrl
         iunnZV0NfvtrCEtSJ38dN+s2o7Ms9t1XCjT1P/scAc9GC/7FygYz6Sg59GYez3gnla8U
         B37gnWWgN0vsBXIQP7kfX7ucuQlca0McNXSvgMI5RGig+HG8TAtmaEXp++4Q4jff20us
         s+WyFNh+EpAuKUUJwWfz95tLjZHK7Q/lfcYyl39P25Y+pJCkhlTHffL+ymXMRdA3EMjB
         RJ4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9F1UFiR0qtpe3Of8uQAylQhK0bHGnBVcigqtNrHL9oM=;
        b=e0aJ6P/68DJ0WAy85VA4Q/9DwhLh0CXgr86DeQG95Sg5LxEhBNtTqu2t2coU/vjRva
         eKt7tXGweY4EmdDjqSlOp5Xa5sbVY2g74uJZTusWmj6QlvsP9tOXJBaHGT/a5bQ1JLS8
         W5oV4/6zF+8WLaPKXYxRzcNeCmni4cu8sCMnu7BLWedVm++NctrwJ86YU3OlGRRrX1Dl
         9SdzJl7+I3CDq+zoN/fxyVTxlQExH/qcP3q+LCyC8oqUpDqy8b5jPPqpum7VOA0EeCEW
         HYj9BTw6hsJWOO++w0wdJWIsNcwBzWS7E3X1EC/mtOLO38rQ1st8hKo3coi56HNTJIOS
         Rl0A==
X-Gm-Message-State: ANoB5pl7pTnYFudZ/lqM4ZuFeqYBIOH9RSG9+vWG5RaLxRSJ+6Az+8pb
        Et/yL5rlhfGjt1tVbXWt/7Q=
X-Google-Smtp-Source: AA0mqf5W2683jlQ5r7lPdRxKethqw2BcyKOjepPk+L/AN3jiRgdFO1RrEnvGM4yE3yousiiHBQu+Bw==
X-Received: by 2002:adf:fd05:0:b0:241:f0e0:cc24 with SMTP id e5-20020adffd05000000b00241f0e0cc24mr27942301wrr.198.1669975178965;
        Fri, 02 Dec 2022 01:59:38 -0800 (PST)
Received: from localhost.localdomain ([213.57.189.88])
        by smtp.gmail.com with ESMTPSA id s1-20020adfdb01000000b002420a2cdc96sm6517851wri.70.2022.12.02.01.59.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 01:59:38 -0800 (PST)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, andrii@kernel.org,
        daniel@iogearbox.net, nicolas.dichtel@6wind.com,
        razor@blackwall.org, mykolal@fb.com, ast@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, shuah@kernel.org,
        liuhangbin@gmail.com, lixiaoyan@google.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH bpf-next,v4 2/4] xfrm: interface: Add unstable helpers for setting/getting XFRM metadata from TC-BPF
Date:   Fri,  2 Dec 2022 11:59:18 +0200
Message-Id: <20221202095920.1659332-3-eyal.birger@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221202095920.1659332-1-eyal.birger@gmail.com>
References: <20221202095920.1659332-1-eyal.birger@gmail.com>
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

This change adds xfrm metadata helpers using the unstable kfunc call
interface for the TC-BPF hooks. This allows steering traffic towards
different IPsec connections based on logic implemented in bpf programs.

This object is built based on the availability of BTF debug info.

The metadata percpu dsts used on TX take ownership of the original skb
dsts so that they may be used as part of the xfrm transmission logic -
e.g.  for MTU calculations.

Signed-off-by: Eyal Birger <eyal.birger@gmail.com>

---

v4: changes requested by Martin KaFai Lau:
  - add kfunc documentation
  - remove redundant memset
  - minor coding

v3:
  - remove redunant memset() as suggested by Martin KaFai Lau
  - remove __exit annotation from cleanup() function as it's used from
    an __init function

v2: changed added following points raised by Martin KaFai Lau:
  - make sure dst is refcounted prior to caching
  - free dst_orig regardless of CONFIG_DST_CACHE
  - call xfrm interface bpf cleanup in case of kfunc registration errors
---
 include/net/dst_metadata.h     |   1 +
 include/net/xfrm.h             |  20 ++++++
 net/core/dst.c                 |   8 ++-
 net/xfrm/Makefile              |   6 ++
 net/xfrm/xfrm_interface_bpf.c  | 123 +++++++++++++++++++++++++++++++++
 net/xfrm/xfrm_interface_core.c |  15 ++++
 6 files changed, 171 insertions(+), 2 deletions(-)
 create mode 100644 net/xfrm/xfrm_interface_bpf.c

diff --git a/include/net/dst_metadata.h b/include/net/dst_metadata.h
index a454cf4327fe..1b7fae4c6b24 100644
--- a/include/net/dst_metadata.h
+++ b/include/net/dst_metadata.h
@@ -26,6 +26,7 @@ struct macsec_info {
 struct xfrm_md_info {
 	u32 if_id;
 	int link;
+	struct dst_entry *dst_orig;
 };
 
 struct metadata_dst {
diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index e0cc6791c001..5e5fea3087b6 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -2086,4 +2086,24 @@ static inline bool xfrm6_local_dontfrag(const struct sock *sk)
 	return false;
 }
 #endif
+
+#if (IS_BUILTIN(CONFIG_XFRM_INTERFACE) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF)) || \
+    (IS_MODULE(CONFIG_XFRM_INTERFACE) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF_MODULES))
+
+extern int register_xfrm_interface_bpf(void);
+extern void cleanup_xfrm_interface_bpf(void);
+
+#else
+
+static inline int register_xfrm_interface_bpf(void)
+{
+	return 0;
+}
+
+static inline void cleanup_xfrm_interface_bpf(void)
+{
+}
+
+#endif
+
 #endif	/* _NET_XFRM_H */
diff --git a/net/core/dst.c b/net/core/dst.c
index bc9c9be4e080..bb14a0392388 100644
--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -316,6 +316,8 @@ void metadata_dst_free(struct metadata_dst *md_dst)
 	if (md_dst->type == METADATA_IP_TUNNEL)
 		dst_cache_destroy(&md_dst->u.tun_info.dst_cache);
 #endif
+	if (md_dst->type == METADATA_XFRM)
+		dst_release(md_dst->u.xfrm_info.dst_orig);
 	kfree(md_dst);
 }
 EXPORT_SYMBOL_GPL(metadata_dst_free);
@@ -340,16 +342,18 @@ EXPORT_SYMBOL_GPL(metadata_dst_alloc_percpu);
 
 void metadata_dst_free_percpu(struct metadata_dst __percpu *md_dst)
 {
-#ifdef CONFIG_DST_CACHE
 	int cpu;
 
 	for_each_possible_cpu(cpu) {
 		struct metadata_dst *one_md_dst = per_cpu_ptr(md_dst, cpu);
 
+#ifdef CONFIG_DST_CACHE
 		if (one_md_dst->type == METADATA_IP_TUNNEL)
 			dst_cache_destroy(&one_md_dst->u.tun_info.dst_cache);
-	}
 #endif
+		if (one_md_dst->type == METADATA_XFRM)
+			dst_release(one_md_dst->u.xfrm_info.dst_orig);
+	}
 	free_percpu(md_dst);
 }
 EXPORT_SYMBOL_GPL(metadata_dst_free_percpu);
diff --git a/net/xfrm/Makefile b/net/xfrm/Makefile
index 08a2870fdd36..cd47f88921f5 100644
--- a/net/xfrm/Makefile
+++ b/net/xfrm/Makefile
@@ -5,6 +5,12 @@
 
 xfrm_interface-$(CONFIG_XFRM_INTERFACE) += xfrm_interface_core.o
 
+ifeq ($(CONFIG_XFRM_INTERFACE),m)
+xfrm_interface-$(CONFIG_DEBUG_INFO_BTF_MODULES) += xfrm_interface_bpf.o
+else ifeq ($(CONFIG_XFRM_INTERFACE),y)
+xfrm_interface-$(CONFIG_DEBUG_INFO_BTF) += xfrm_interface_bpf.o
+endif
+
 obj-$(CONFIG_XFRM) := xfrm_policy.o xfrm_state.o xfrm_hash.o \
 		      xfrm_input.o xfrm_output.o \
 		      xfrm_sysctl.o xfrm_replay.o xfrm_device.o
diff --git a/net/xfrm/xfrm_interface_bpf.c b/net/xfrm/xfrm_interface_bpf.c
new file mode 100644
index 000000000000..de281847c5f1
--- /dev/null
+++ b/net/xfrm/xfrm_interface_bpf.c
@@ -0,0 +1,123 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Unstable XFRM Helpers for TC-BPF hook
+ *
+ * These are called from SCHED_CLS BPF programs. Note that it is
+ * allowed to break compatibility for these functions since the interface they
+ * are exposed through to BPF programs is explicitly unstable.
+ */
+
+#include <linux/bpf.h>
+#include <linux/btf_ids.h>
+
+#include <net/dst_metadata.h>
+#include <net/xfrm.h>
+
+/* bpf_xfrm_info - XFRM metadata information
+ *
+ * Members:
+ * @if_id	- XFRM if_id:
+ *		    Transmit: if_id to be used in policy and state lookups
+ *		    Receive: if_id of the state matched for the incoming packet
+ * @link	- Underlying device ifindex:
+ *		    Transmit: used as the underlying device in VRF routing
+ *		    Receive: the device on which the packet had been received
+ */
+struct bpf_xfrm_info {
+	u32 if_id;
+	int link;
+};
+
+static struct metadata_dst __percpu *xfrm_md_dst;
+__diag_push();
+__diag_ignore_all("-Wmissing-prototypes",
+		  "Global functions as their definitions will be in xfrm_interface BTF");
+
+/* bpf_skb_get_xfrm_info - Get XFRM metadata
+ *
+ * Parameters:
+ * @skb_ctx	- Pointer to ctx (__sk_buff) in TC program
+ *		    Cannot be NULL
+ * @to		- Pointer to memory to which the metadata will be copied
+ *		    Cannot be NULL
+ */
+__used noinline
+int bpf_skb_get_xfrm_info(struct __sk_buff *skb_ctx, struct bpf_xfrm_info *to)
+{
+	struct sk_buff *skb = (struct sk_buff *)skb_ctx;
+	struct xfrm_md_info *info;
+
+	info = skb_xfrm_md_info(skb);
+	if (!info)
+		return -EINVAL;
+
+	to->if_id = info->if_id;
+	to->link = info->link;
+	return 0;
+}
+
+/* bpf_skb_get_xfrm_info - Set XFRM metadata
+ *
+ * Parameters:
+ * @skb_ctx	- Pointer to ctx (__sk_buff) in TC program
+ *		    Cannot be NULL
+ * @from	- Pointer to memory from which the metadata will be copied
+ *		    Cannot be NULL
+ */
+__used noinline
+int bpf_skb_set_xfrm_info(struct __sk_buff *skb_ctx,
+			  const struct bpf_xfrm_info *from)
+{
+	struct sk_buff *skb = (struct sk_buff *)skb_ctx;
+	struct metadata_dst *md_dst;
+	struct xfrm_md_info *info;
+
+	if (unlikely(skb_metadata_dst(skb)))
+		return -EINVAL;
+
+	md_dst = this_cpu_ptr(xfrm_md_dst);
+
+	info = &md_dst->u.xfrm_info;
+
+	info->if_id = from->if_id;
+	info->link = from->link;
+	skb_dst_force(skb);
+	info->dst_orig = skb_dst(skb);
+
+	dst_hold((struct dst_entry *)md_dst);
+	skb_dst_set(skb, (struct dst_entry *)md_dst);
+	return 0;
+}
+
+__diag_pop()
+
+BTF_SET8_START(xfrm_ifc_kfunc_set)
+BTF_ID_FLAGS(func, bpf_skb_get_xfrm_info)
+BTF_ID_FLAGS(func, bpf_skb_set_xfrm_info)
+BTF_SET8_END(xfrm_ifc_kfunc_set)
+
+static const struct btf_kfunc_id_set xfrm_interface_kfunc_set = {
+	.owner = THIS_MODULE,
+	.set   = &xfrm_ifc_kfunc_set,
+};
+
+int __init register_xfrm_interface_bpf(void)
+{
+	int err;
+
+	xfrm_md_dst = metadata_dst_alloc_percpu(0, METADATA_XFRM,
+						GFP_KERNEL);
+	if (!xfrm_md_dst)
+		return -ENOMEM;
+	err = register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_CLS,
+					&xfrm_interface_kfunc_set);
+	if (err < 0) {
+		metadata_dst_free_percpu(xfrm_md_dst);
+		return err;
+	}
+	return 0;
+}
+
+void cleanup_xfrm_interface_bpf(void)
+{
+	metadata_dst_free_percpu(xfrm_md_dst);
+}
diff --git a/net/xfrm/xfrm_interface_core.c b/net/xfrm/xfrm_interface_core.c
index 5a67b120c4db..1e1e8e965939 100644
--- a/net/xfrm/xfrm_interface_core.c
+++ b/net/xfrm/xfrm_interface_core.c
@@ -396,6 +396,14 @@ xfrmi_xmit2(struct sk_buff *skb, struct net_device *dev, struct flowi *fl)
 
 		if_id = md_info->if_id;
 		fl->flowi_oif = md_info->link;
+		if (md_info->dst_orig) {
+			struct dst_entry *tmp_dst = dst;
+
+			dst = md_info->dst_orig;
+			skb_dst_set(skb, dst);
+			md_info->dst_orig = NULL;
+			dst_release(tmp_dst);
+		}
 	} else {
 		if_id = xi->p.if_id;
 	}
@@ -1162,12 +1170,18 @@ static int __init xfrmi_init(void)
 	if (err < 0)
 		goto rtnl_link_failed;
 
+	err = register_xfrm_interface_bpf();
+	if (err < 0)
+		goto kfunc_failed;
+
 	lwtunnel_encap_add_ops(&xfrmi_encap_ops, LWTUNNEL_ENCAP_XFRM);
 
 	xfrm_if_register_cb(&xfrm_if_cb);
 
 	return err;
 
+kfunc_failed:
+	rtnl_link_unregister(&xfrmi_link_ops);
 rtnl_link_failed:
 	xfrmi6_fini();
 xfrmi6_failed:
@@ -1183,6 +1197,7 @@ static void __exit xfrmi_fini(void)
 {
 	xfrm_if_unregister_cb();
 	lwtunnel_encap_del_ops(&xfrmi_encap_ops, LWTUNNEL_ENCAP_XFRM);
+	cleanup_xfrm_interface_bpf();
 	rtnl_link_unregister(&xfrmi_link_ops);
 	xfrmi4_fini();
 	xfrmi6_fini();
-- 
2.34.1

