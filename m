Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4BF463AD44
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 17:05:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232579AbiK1QFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 11:05:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232594AbiK1QF3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 11:05:29 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59D64233AB;
        Mon, 28 Nov 2022 08:05:28 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id z92so5609682ede.1;
        Mon, 28 Nov 2022 08:05:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AcU1qnshwNd2/hpsG70WFJN94NbG4k4K2P/M9Yhux6U=;
        b=oW5Hi6anHk5BR058fjoOq04loZhrc6QV4lPA8ssWAJzlwZrjmnmCy3W8CTUwbWCwlu
         IoqiNuGqfdREloryEi/DT3DsQ7AJGeIqpQ1tuW6hMij8imbAurH8vrPLtCJe9WNFbejw
         IU1V7i/E+V/Yy/qxLj59ZFr5yeT07wsY3T7Iw2f8caoZMRtokcecn45ZfnHf7LW0KZNp
         +QWKAbhDIHRdVRmiebqb5CmIupiVmXpsluGT5xgj7d0sVgbDFEI0vtc413y3DXj8EaVJ
         jekbJAcCuUL1sAGFWFAI4P2OwA7ll2eyv3iV8/rRylQ+NGFxCCFdCMplqF5+F+35w6PK
         lYwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AcU1qnshwNd2/hpsG70WFJN94NbG4k4K2P/M9Yhux6U=;
        b=RmteoIE7S4Eu2LvTlrPd+FmM2XOOeeuD8pyig042yfXihldKYxtjpF1ECCGhtfsLCV
         DsK4MIlMnfoSIrMUp2NBpDiY8dWDiMBeSZ8qzitww3Rh+wDfn5FzBfpMC3AV9bdA3/XL
         RsuVHzr7Q6Ofqi2IE2YXj2Ih1s97ABsLysgIKCTSUyzXyuhg/4XVWdDS0sBuFloAA4D0
         k/qFCBGb1UktTSFe6RsJPuOkKLuHfks3Q27YuX+JakmVlQUQNdBQxy3CrYGUdG89m3Ry
         a5Nplx7bmWaBeIvJVMZ7p/HNVf+2Z9KNaUqfT5ZzqslTvBoD5Bj/Jh6Yk/+1YmZknMrG
         HGEg==
X-Gm-Message-State: ANoB5plBhln9MUM00pdu3vg1oUEkPWz97nbJHaTDru5zlJqIOZh8Ckar
        SptuYp5B2W28vR3TLOkC3QA=
X-Google-Smtp-Source: AA0mqf4aACBMt6l4NZUuMW+1QeaXW9gLnR7achUnkWR6VL8YcYyILm8ZIJSXbrkohaa7NQW2G+LQkQ==
X-Received: by 2002:a05:6402:388e:b0:468:fb0d:2d8b with SMTP id fd14-20020a056402388e00b00468fb0d2d8bmr16379025edb.124.1669651526727;
        Mon, 28 Nov 2022 08:05:26 -0800 (PST)
Received: from jimi.localdomain ([213.57.189.88])
        by smtp.gmail.com with ESMTPSA id w21-20020a170906385500b0077a201f6d1esm5127264ejc.87.2022.11.28.08.05.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 08:05:26 -0800 (PST)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, andrii@kernel.org,
        daniel@iogearbox.net, nicolas.dichtel@6wind.com,
        razor@blackwall.org, mykolal@fb.com, ast@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, shuah@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH ipsec-next 2/3] xfrm: interface: Add unstable helpers for setting/getting XFRM metadata from TC-BPF
Date:   Mon, 28 Nov 2022 18:05:00 +0200
Message-Id: <20221128160501.769892-3-eyal.birger@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221128160501.769892-1-eyal.birger@gmail.com>
References: <20221128160501.769892-1-eyal.birger@gmail.com>
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

This object is built based on the availabilty of BTF debug info.

The metadata percpu dsts used on TX take ownership of the original skb
dsts so that they may be used as part of the xfrm transmittion logic -
e.g.  for MTU calculations.

Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
---
 include/net/dst_metadata.h     |  1 +
 include/net/xfrm.h             | 20 ++++++++
 net/core/dst.c                 |  4 ++
 net/xfrm/Makefile              |  6 +++
 net/xfrm/xfrm_interface_bpf.c  | 92 ++++++++++++++++++++++++++++++++++
 net/xfrm/xfrm_interface_core.c | 15 ++++++
 6 files changed, 138 insertions(+)
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
index bc9c9be4e080..4c2eb7e56dab 100644
--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -315,6 +315,8 @@ void metadata_dst_free(struct metadata_dst *md_dst)
 #ifdef CONFIG_DST_CACHE
 	if (md_dst->type == METADATA_IP_TUNNEL)
 		dst_cache_destroy(&md_dst->u.tun_info.dst_cache);
+	else if (md_dst->type == METADATA_XFRM)
+		dst_release(md_dst->u.xfrm_info.dst_orig);
 #endif
 	kfree(md_dst);
 }
@@ -348,6 +350,8 @@ void metadata_dst_free_percpu(struct metadata_dst __percpu *md_dst)
 
 		if (one_md_dst->type == METADATA_IP_TUNNEL)
 			dst_cache_destroy(&one_md_dst->u.tun_info.dst_cache);
+		else if (one_md_dst->type == METADATA_XFRM)
+			dst_release(one_md_dst->u.xfrm_info.dst_orig);
 	}
 #endif
 	free_percpu(md_dst);
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
index 000000000000..d3997ab7cc28
--- /dev/null
+++ b/net/xfrm/xfrm_interface_bpf.c
@@ -0,0 +1,92 @@
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
+__used noinline
+int bpf_skb_get_xfrm_info(struct __sk_buff *skb_ctx, struct bpf_xfrm_info *to)
+{
+	struct sk_buff *skb = (struct sk_buff *)skb_ctx;
+	struct xfrm_md_info *info;
+
+	memset(to, 0, sizeof(*to));
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
+	memset(info, 0, sizeof(*info));
+
+	info->if_id = from->if_id;
+	info->link = from->link;
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
+	xfrm_md_dst = metadata_dst_alloc_percpu(0, METADATA_XFRM,
+						GFP_KERNEL);
+	if (!xfrm_md_dst)
+		return -ENOMEM;
+	return register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_CLS,
+					 &xfrm_interface_kfunc_set);
+}
+
+void __exit cleanup_xfrm_interface_bpf(void)
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

