Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1630640ADEC
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 14:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232716AbhINMjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 08:39:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232909AbhINMjY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 08:39:24 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0475AC061574;
        Tue, 14 Sep 2021 05:38:07 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id f3-20020a17090a638300b00199097ddf1aso2058626pjj.0;
        Tue, 14 Sep 2021 05:38:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=o2uir4PaWOGPcMyQFzYq+u0pT9SxwzyBbttgTlyAw3k=;
        b=GRhH4wC3fTltWPJzNjdpktt0sG4vnb1Jv6mK4JsXL+Yt9kf9pvBBXssimCBiFEV37K
         SYisBm/rAkOfljKq15tVtcCAbGxoI3ZHo41rEEJki9DYBy2fguiFbgorPLx6D8cXy66j
         7DJCcceIEPBifVHNbvL8A00AeRaL8kET0mwuI+A2d8YS78kXG+zYuK1saEi8Tm3iQv10
         rCKf6pGeOAKzCBsn5ecuiaMT1OC2VeqTbGR7LIgPdk7zyWJnfOmgGD7JcWyAGRx3swCV
         VptiQIgV72d87KIRdIZ4sOSImMMlI5hNnh5jTmVbvslWVmgS8OGIrFFEstQ+FZ+naiHW
         n3eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o2uir4PaWOGPcMyQFzYq+u0pT9SxwzyBbttgTlyAw3k=;
        b=v3ym2TwlSpbnTBeFkacCWTtdvBne75s3qSEg6dbffmdwSCldREIjayJWmhKOj8JqGH
         i6TAAwbit0RK0WrrIw+cI0VKMBM3L1niemgsJN9Ayj2f6FLBl9l+TSNfmq+TLDgRwnpb
         XfJIntP/zN3Ud2iWMkpTGgw9y2sxj6YuIRSLQc8wwazTod9VBX1y8FfU68zc5EulDUWc
         S4VLAQaXo18CeDdyAkzotk14FXxkbUjcfKhhfUObEak3/YEOXREX1I1WRJj3ix+fRqJA
         m62OJ27YlZmGwGE4ASG0VO9LF4mrBPxWsimHgr7PcNnHv2RJUzF1Y7fNiilYAspLeZTG
         o4hg==
X-Gm-Message-State: AOAM532T2sUEoZZNHAV7HULXzSKfur+bD5ViiIJa9JtIrcUqG2iGFALB
        4i0ksVpf5lxNaMfGgyhfc66QM7+r5wesNg==
X-Google-Smtp-Source: ABdhPJxYxBXDFKCZPaTAHe9SzfUfhHbx3LheQrnFY4AIiwCHvt/TL3+LDMOU4P1nZHhs4p9A9dCJeg==
X-Received: by 2002:a17:90b:4a44:: with SMTP id lb4mr1890054pjb.140.1631623086344;
        Tue, 14 Sep 2021 05:38:06 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id x26sm10413697pfm.77.2021.09.14.05.38.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 05:38:06 -0700 (PDT)
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
Subject: [PATCH bpf-next v2 03/10] bpf: btf: Introduce helpers for dynamic BTF set registration
Date:   Tue, 14 Sep 2021 18:07:42 +0530
Message-Id: <20210914123750.460750-4-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210914123750.460750-1-memxor@gmail.com>
References: <20210914123750.460750-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5061; h=from:subject; bh=xIk+3p0yR6nDontP2RM+Qd15PO5zXVr+rOfltuzXi+A=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhQJdWQTDX6mqAQpBBQhjssU+jDKZWQWpRO+akKeCp w/G8cAqJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYUCXVgAKCRBM4MiGSL8RyjOuD/ 9CVzLyyx/fzakF923YE3zGD0O+H01tFG7xg4lwPHGc3s1sMzODtomuDHBHcR3bKR2MA3NBLSqR0q8/ 1NgJGokExfM4INmng1po58QHPDMrsKDX7PWtdn/FINJxzp/Bv4QBcbaKVPUq9DtkyEMKfXu8Vs4TYp gLZqGE8/swk2O1Q3EZxbDbrBiYJiJAZI+zYCPDn2WnjrkIDcGEdZm36+mMvi3/mXCKGuOPQXBBRldl VgcoOspzl7BFLzyHZDTidZnkP67KLzvvVdL8c/8ZMo8rL4/jq2I2NwFB4H3zeEwcR1w6/HRjlKkR1D TJkgfXXcn+2a8Z9Usm2Mp9pe7jx7hB89sKLeOpFYElVqol3RKL0DbRo0xZ595CBqgKVA6oALtP7bQB GUEKi+RLs2Ze0GHYGxKnO75X48VtJIpitqeUb7v7Xe+Fm6lm9hznEbJ5m1dWuyBtUnezSrncM74ELY NkLweevfFRi/g0FEOO5lHhvtND+oJ9YBXUv9ymw34JQtw634Dx6x2RcUl3u4ntWelff/we/AShwsPg n+pRIKECoeIO2HyoAVkQ3BJi0vzKkLb4sG8SuNPua62lL1uUUxY1mMZTruM4pJBREdMT12LnnVo3Wd g/EoI465vgDLufoe6sepNB0vJNCnhDXlSlL4+rm0F6UlUpq2gtEIw0qIgsDA==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds helpers for registering btf_id_set from modules and the
check_kfunc_call callback that can be used to look them up.

With in kernel sets, the way this is supposed to work is, in kernel
callback looks up within the in-kernel kfunc whitelist, and then defers
to the dynamic BTF set lookup if it doesn't find the BTF id. If there is
no in-kernel BTF id set, this callback can be used directly.

Also fix includes for btf.h and bpfptr.h so that they can included in
isolation. This is in preparation for their usage in tcp_bbr, tcp_cubic
and tcp_dctcp modules in the next patch.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/linux/bpfptr.h |  1 +
 include/linux/btf.h    | 32 ++++++++++++++++++++++++++
 kernel/bpf/btf.c       | 51 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 84 insertions(+)

diff --git a/include/linux/bpfptr.h b/include/linux/bpfptr.h
index 546e27fc6d46..46e1757d06a3 100644
--- a/include/linux/bpfptr.h
+++ b/include/linux/bpfptr.h
@@ -3,6 +3,7 @@
 #ifndef _LINUX_BPFPTR_H
 #define _LINUX_BPFPTR_H
 
+#include <linux/mm.h>
 #include <linux/sockptr.h>
 
 typedef sockptr_t bpfptr_t;
diff --git a/include/linux/btf.h b/include/linux/btf.h
index 214fde93214b..e29a486d09d4 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -5,8 +5,10 @@
 #define _LINUX_BTF_H 1
 
 #include <linux/types.h>
+#include <linux/bpfptr.h>
 #include <uapi/linux/btf.h>
 #include <uapi/linux/bpf.h>
+#include <linux/mutex.h>
 
 #define BTF_TYPE_EMIT(type) ((void)(type *)0)
 #define BTF_TYPE_EMIT_ENUM(enum_val) ((void)enum_val)
@@ -238,4 +240,34 @@ static inline const char *btf_name_by_offset(const struct btf *btf,
 }
 #endif
 
+struct kfunc_btf_id_set {
+	struct list_head list;
+	struct btf_id_set *set;
+	struct module *owner;
+};
+
+struct kfunc_btf_id_list;
+
+#ifdef CONFIG_DEBUG_INFO_BTF_MODULES
+void register_kfunc_btf_id_set(struct kfunc_btf_id_list *l,
+			       struct kfunc_btf_id_set *s);
+void unregister_kfunc_btf_id_set(struct kfunc_btf_id_list *l,
+				 struct kfunc_btf_id_set *s);
+#else
+static inline void register_kfunc_btf_id_set(struct kfunc_btf_id_list *l,
+					     struct kfunc_btf_id_set *s)
+{
+}
+static inline void unregister_kfunc_btf_id_set(struct kfunc_btf_id_list *l,
+					       struct kfunc_btf_id_set *s)
+{
+}
+#endif
+
+#define DECLARE_CHECK_KFUNC_CALLBACK(type)                                     \
+	bool __bpf_check_##type##_kfunc_call(u32 kfunc_id, struct module *owner)
+#define DEFINE_KFUNC_BTF_ID_SET(set, name)                                     \
+	struct kfunc_btf_id_set name = { LIST_HEAD_INIT(name.list), (set),     \
+					 THIS_MODULE }
+
 #endif
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index dfe61df4f974..eecafed56300 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6215,3 +6215,54 @@ const struct bpf_func_proto bpf_btf_find_by_name_kind_proto = {
 };
 
 BTF_ID_LIST_GLOBAL_SINGLE(btf_task_struct_ids, struct, task_struct)
+
+struct kfunc_btf_id_list {
+	struct list_head list;
+	struct mutex mutex;
+};
+
+#ifdef CONFIG_DEBUG_INFO_BTF_MODULES
+
+void register_kfunc_btf_id_set(struct kfunc_btf_id_list *l,
+			       struct kfunc_btf_id_set *s)
+{
+	mutex_lock(&l->mutex);
+	list_add(&s->list, &l->list);
+	mutex_unlock(&l->mutex);
+}
+EXPORT_SYMBOL_GPL(register_kfunc_btf_id_set);
+
+void unregister_kfunc_btf_id_set(struct kfunc_btf_id_list *l,
+				 struct kfunc_btf_id_set *s)
+{
+	mutex_lock(&l->mutex);
+	list_del_init(&s->list);
+	mutex_unlock(&l->mutex);
+}
+EXPORT_SYMBOL_GPL(unregister_kfunc_btf_id_set);
+
+#endif
+
+#define DEFINE_KFUNC_BTF_ID_LIST(name)                                         \
+	struct kfunc_btf_id_list name = { LIST_HEAD_INIT(name.list),           \
+					  __MUTEX_INITIALIZER(name.mutex) }; \
+	EXPORT_SYMBOL_GPL(name)
+
+#define DEFINE_CHECK_KFUNC_CALLBACK(type, list_name)                           \
+	bool __bpf_check_##type##_kfunc_call(u32 kfunc_id,                     \
+					     struct module *owner)             \
+	{                                                                      \
+		struct kfunc_btf_id_set *s;                                    \
+		if (!owner || !IS_ENABLED(CONFIG_DEBUG_INFO_BTF_MODULES))      \
+			return false;                                          \
+		mutex_lock(&list_name.mutex);                                  \
+		list_for_each_entry(s, &list_name.list, list) {                \
+			if (s->owner == owner &&                               \
+			    btf_id_set_contains(s->set, kfunc_id)) {           \
+				mutex_unlock(&list_name.mutex);                \
+				return true;                                   \
+			}                                                      \
+		}                                                              \
+		mutex_unlock(&list_name.mutex);                                \
+		return false;                                                  \
+	}
-- 
2.33.0

