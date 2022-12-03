Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 013B86414B9
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 08:31:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbiLCHbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 02:31:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231537AbiLCHbF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 02:31:05 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A08618AAC6;
        Fri,  2 Dec 2022 23:31:03 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id fy37so16317163ejc.11;
        Fri, 02 Dec 2022 23:31:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R2lUNtTp19ZYEWAcJcvU7WydSWxqLqezoBsuVdWgWh0=;
        b=JdfOJGr9k9I9gv8Rh1pPsLnsoNdoMfVxbeYZWCWz/YH/u9jK4fI/QpKAGBNx7i3C8g
         z0GQ2g4aWSiXUxJGtCp+HXK4bNjyLqiMWYh2YfmJKWqGYinLkH+DXM9eY6+hlFc6r49m
         YXXmQk6GL0nOfqg0ftM7/Uj2UOiQ7fHUmfMWDZTp0FsPGFecfa6Z42tYepzxJ1/sa5Pb
         YzXOQoIMvDBME61RAY13ST8K92Gbuk8KLQDTgUSY9V2F8JN03Q5b8NAu3es+LC2yqKpk
         rwlBittk3aQFr0fBg2czQ3t+qcZ+z07I/Vub2unmmQ3UnXpMivXGTmPT60XJe78iBC1R
         SOWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R2lUNtTp19ZYEWAcJcvU7WydSWxqLqezoBsuVdWgWh0=;
        b=nB1d/ug7Vh22J6dftI3q2yahe++KlrEhCX6h6QPYBycVfsa/Jiz6meGHrWjHaX05bm
         YscP0IOSKTDu9oCu9riQT0qVtHXUEC7PbJFA1sknPpIFsF/afTtB8wIbnQrvG2k01X2O
         NHvZlif1JiGwb8pfp+5tdJZrGwVHza/pJcEMK8bGSyeOCivIoGUp/W72PfmTLbMHBYqe
         TX9LQ2eJztez053BhU9feJsFi7ys+czbGmdPQSQm4QlGGV/vK+vuaG8JEwaicOTOfa8X
         j81reaTGoJkhYEP2QPLBnNoyA7ZVmsXoS1IJVUZ2TCh3nLApbRW+O6IeeNfVd//ptEWo
         kAQA==
X-Gm-Message-State: ANoB5pmoa4vT9ZyMWOd/wkTfQKQoU7WmUJ4r9pgsidLEF2691zTlGhho
        D1N9pm9wP4/u2PcXMbIfLyE=
X-Google-Smtp-Source: AA0mqf7NPdT8uC0IP3/TmJEp97uLfUGrhn16s+ztt2dx/YSiHHqJD/xDQNXsIyvaAMYzWt8CmJWj1w==
X-Received: by 2002:a17:906:9c8a:b0:7bf:6698:d444 with SMTP id fj10-20020a1709069c8a00b007bf6698d444mr24125091ejc.548.1670052661871;
        Fri, 02 Dec 2022 23:31:01 -0800 (PST)
Received: from jimi.localdomain ([213.57.189.88])
        by smtp.gmail.com with ESMTPSA id p4-20020a056402074400b0046267f8150csm3772709edy.19.2022.12.02.23.30.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 23:31:01 -0800 (PST)
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
Subject: [PATCH bpf-next,v5 2/4] xfrm: interface: Add unstable helpers for setting/getting XFRM metadata from TC-BPF
Date:   Sat,  3 Dec 2022 09:30:33 +0200
Message-Id: <20221203073035.1798108-3-eyal.birger@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221203073035.1798108-1-eyal.birger@gmail.com>
References: <20221203073035.1798108-1-eyal.birger@gmail.com>
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
 include/net/xfrm.h             |  15 +++++
 net/core/dst.c                 |   8 ++-
 net/core/filter.c              |   4 ++
 net/xfrm/Makefile              |   6 ++
 net/xfrm/xfrm_interface_bpf.c  | 117 +++++++++++++++++++++++++++++++++
 net/xfrm/xfrm_interface_core.c |  14 ++++
 7 files changed, 163 insertions(+), 2 deletions(-)
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
index e0cc6791c001..4a0efc5d8e10 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -2086,4 +2086,19 @@ static inline bool xfrm6_local_dontfrag(const struct sock *sk)
 	return false;
 }
 #endif
+
+#if (IS_BUILTIN(CONFIG_XFRM_INTERFACE) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF)) || \
+    (IS_MODULE(CONFIG_XFRM_INTERFACE) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF_MODULES))
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
index 37baaa6b8fc3..80c685f21aa4 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5630,6 +5630,10 @@ static const struct bpf_func_proto bpf_bind_proto = {
 };
 
 #ifdef CONFIG_XFRM
+
+struct metadata_dst __percpu *xfrm_bpf_md_dst;
+EXPORT_SYMBOL_GPL(xfrm_bpf_md_dst);
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
index 000000000000..08b3fea6d769
--- /dev/null
+++ b/net/xfrm/xfrm_interface_bpf.c
@@ -0,0 +1,117 @@
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
+extern struct metadata_dst __percpu *xfrm_bpf_md_dst;
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

