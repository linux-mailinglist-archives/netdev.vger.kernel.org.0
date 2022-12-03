Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF07464150A
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 09:47:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231621AbiLCIrY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 03:47:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231650AbiLCIrV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 03:47:21 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F28F17DA7C;
        Sat,  3 Dec 2022 00:47:19 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id a16so9272725edb.9;
        Sat, 03 Dec 2022 00:47:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HMRfNVkYWHz+LMi/NylOUJ5RkXspRMRC+wF0iaIwxy0=;
        b=BoXRd8bXKz4MsHQ0YmRqHT14+SxASbikcBvAZwcKX6ts/0MbKmEn8uJKBXFrppZuI8
         bSo/RbPGb1a6adllaYkwIPDaaMt2Wvl9n/K/agcibFauV2aEFvMUnTGN15zKzctfucuy
         +wMKCJxM2/Sk6TRqjV8uzYdgDctGLiZJr+EBaHzdqrP1z9FuugfiGPdH/BSriZy21N/H
         iCEgHccvThaEwFNh4ELt/2v/bAyFe4ZsUNCxB4awUEsrMY8YO2ey6j7DitS5K+mPdtra
         tyYFecVM5YyRY0vC+qryYKW98dFw0tOpXTpsoSeFyvvGs2heIuw6cT2c35zM+KOzxTi7
         KehQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HMRfNVkYWHz+LMi/NylOUJ5RkXspRMRC+wF0iaIwxy0=;
        b=cowlaakWlzED0H6S6x+ODialTxk2ksPZF30Vy7D2f+HzJyxNSu3LpQMVv6fz5zykc2
         E2JXX+4tSyZHkW4ROj17WLs7h/BSKE53832gj6GPvPqlUxHuEcfAGDLuKgg4za1px6FE
         SwOJ5SbQ6Vy3gLGnewEdfptEm4t/ngPwZmlzPpxzAwJ13DbAp5ZpQZes0wWRODYyjUK8
         sX8ICVM9TdBezoEbKjOyxSkQnmagD7LZvZlJP9WpoPcxjoqQwfjVEQIZZReND923pkhX
         SO8rAHvFDAp/vJqyC7LPz5fUv+4FovPWdpLWnw5etmuhQy9vr9mQAYuwXmgOCuAsCCI1
         PhTw==
X-Gm-Message-State: ANoB5plN7VTw052hi6ffkwQEijPdZGq+GVSVx/BDNBVqMVWi8O5wF2Pg
        J7nE883BUtNw1jW1ITAaTko=
X-Google-Smtp-Source: AA0mqf7uj8O5MWCHeeyH2TL64pK+XSbUBn7embXmq1krWDUSaEkbn8dwI0BQTGMiWp4GSXZwrIfhHA==
X-Received: by 2002:a05:6402:541a:b0:463:be84:5283 with SMTP id ev26-20020a056402541a00b00463be845283mr25149011edb.7.1670057238253;
        Sat, 03 Dec 2022 00:47:18 -0800 (PST)
Received: from jimi.localdomain ([213.57.189.88])
        by smtp.gmail.com with ESMTPSA id q26-20020a170906389a00b007bdc2de90e6sm3964200ejd.42.2022.12.03.00.47.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Dec 2022 00:47:17 -0800 (PST)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, andrii@kernel.org,
        daniel@iogearbox.net, nicolas.dichtel@6wind.com,
        razor@blackwall.org, mykolal@fb.com, ast@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, shuah@kernel.org,
        liuhangbin@gmail.com, lixiaoyan@google.com, jtoppins@redhat.com,
        kuniyu@amazon.co.jp
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH bpf-next,v6 2/4] xfrm: interface: Add unstable helpers for setting/getting XFRM metadata from TC-BPF
Date:   Sat,  3 Dec 2022 10:46:57 +0200
Message-Id: <20221203084659.1837829-3-eyal.birger@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221203084659.1837829-1-eyal.birger@gmail.com>
References: <20221203084659.1837829-1-eyal.birger@gmail.com>
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

When setting the xfrm metadata, percpu metadata dsts are used in order
to avoid allocating a metadata dst per packet.

In order to guarantee safe module unload, the percpu dsts are allocated
on first use and never freed. The percpu pointer is stored in
net/core/filter.c so that it can be reused on module reload.

The metadata percpu dsts take ownership of the original skb dsts so
that they may be used as part of the xfrm transmission logic - e.g.
for MTU calculations.

Signed-off-by: Eyal Birger <eyal.birger@gmail.com>

---

v6:
  fix sparse warning:
  "symbol 'xfrm_bpf_md_dst' was not declared. Should it be static?"
  by moving the xfrm_bpf_md_dst declaration to xfrm.h

v5:
  - remove cleanup of percpu dsts as suggested by Martin KaFai Lau
  - remove redundant extern in header file

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
 include/net/xfrm.h             |  17 +++++
 net/core/dst.c                 |   8 ++-
 net/core/filter.c              |   9 +++
 net/xfrm/Makefile              |   6 ++
 net/xfrm/xfrm_interface_bpf.c  | 115 +++++++++++++++++++++++++++++++++
 net/xfrm/xfrm_interface_core.c |  14 ++++
 7 files changed, 168 insertions(+), 2 deletions(-)
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
index e0cc6791c001..3707e6b34e67 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -2086,4 +2086,21 @@ static inline bool xfrm6_local_dontfrag(const struct sock *sk)
 	return false;
 }
 #endif
+
+#if (IS_BUILTIN(CONFIG_XFRM_INTERFACE) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF)) || \
+    (IS_MODULE(CONFIG_XFRM_INTERFACE) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF_MODULES))
+
+extern struct metadata_dst __percpu *xfrm_bpf_md_dst;
+
+int register_xfrm_interface_bpf(void);
+
+#else
+
+static inline int register_xfrm_interface_bpf(void)
+{
+	return 0;
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
diff --git a/net/core/filter.c b/net/core/filter.c
index 37baaa6b8fc3..328d382fcea0 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5630,6 +5630,15 @@ static const struct bpf_func_proto bpf_bind_proto = {
 };
 
 #ifdef CONFIG_XFRM
+
+#if (IS_BUILTIN(CONFIG_XFRM_INTERFACE) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF)) || \
+    (IS_MODULE(CONFIG_XFRM_INTERFACE) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF_MODULES))
+
+struct metadata_dst __percpu *xfrm_bpf_md_dst;
+EXPORT_SYMBOL_GPL(xfrm_bpf_md_dst);
+
+#endif
+
 BPF_CALL_5(bpf_skb_get_xfrm_state, struct sk_buff *, skb, u32, index,
 	   struct bpf_xfrm_state *, to, u32, size, u64, flags)
 {
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
index 000000000000..1ef2162cebcf
--- /dev/null
+++ b/net/xfrm/xfrm_interface_bpf.c
@@ -0,0 +1,115 @@
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
+	if (!xfrm_bpf_md_dst) {
+		struct metadata_dst __percpu *tmp;
+
+		tmp = metadata_dst_alloc_percpu(0, METADATA_XFRM, GFP_ATOMIC);
+		if (!tmp)
+			return -ENOMEM;
+		if (cmpxchg(&xfrm_bpf_md_dst, NULL, tmp))
+			metadata_dst_free_percpu(tmp);
+	}
+	md_dst = this_cpu_ptr(xfrm_bpf_md_dst);
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
+	return register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_CLS,
+					 &xfrm_interface_kfunc_set);
+}
diff --git a/net/xfrm/xfrm_interface_core.c b/net/xfrm/xfrm_interface_core.c
index 5a67b120c4db..1f99dc469027 100644
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
-- 
2.34.1

