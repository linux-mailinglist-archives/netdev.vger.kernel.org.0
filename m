Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33E4B41F90E
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 03:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232296AbhJBBT7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 21:19:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232267AbhJBBTz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 21:19:55 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 624C1C061775;
        Fri,  1 Oct 2021 18:18:10 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id rj12-20020a17090b3e8c00b0019f88e44d85so1519382pjb.4;
        Fri, 01 Oct 2021 18:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0xBCeAslqr5mHk+OCT97Cvrfs9qVpOb3flunBMRSpe0=;
        b=W6q9dbHdzV+DcAtgy3E/ERN1FspnQh6ULyIuY1f8mfyvamVtdSHY8WH180+CdGCHO8
         VJsEtes2qcOePw/N6HpQMzkvOmZiOA6ijXsnDFJLp9eD0AXQgWbxSCKYYJPxdS8H/sLD
         Vtk8EBPdqwn15nzaBaQxibWbXKQvqh8Fs3mnCC4hJgQbk8giHzgFfjJYRUzoueKMMTAP
         RsP/MfbZITXMBnB1k4cqevHj3hA8bvB2UJiMn0XuaFZ4Gmk8WwgfGbUg6D1L8wSYFzXg
         cgTKlwTHjdS30yR0W8n/kBg7XMooO6bUgWTO3t0IRWEiUDjAmToAMsp9sK2zY/5zJU93
         5xOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0xBCeAslqr5mHk+OCT97Cvrfs9qVpOb3flunBMRSpe0=;
        b=sURE0AUvOYjgQgktd1SZS8txrMX9SKcBMQLO6tsLaRpdFDj6LInKd4WOFeu4LgLCkn
         Y2XrWxbxUXeePEFDDfVx3XyubQ6sorIiq3mgK3hpoIHMconsHDTMW4dzJKcX1+0Y1Xyt
         OOQti7gwQ1c+Y1/V0onMLUvJfADW86Y3o+54txCzeWGbD9lPnH5xgzi2eY862nCclSOA
         RYN+z+hyAArsgxpWnCZVrWLPysyw8MPhYTyB3rHD3Ps0jKkmXP9Ua9oJEdQpp6ZO23cg
         TJvXhtC8KPmsjn/BeXsGe78YBAijnhklmpYNkDIOGiE1COjyW9kP+RTnQFCRtI4tpK6P
         Zwhw==
X-Gm-Message-State: AOAM53000Ygym3VIGSfie4p/JNu6L6lkInLYd38At9lCxotmBFHJqKVm
        YLo0SHhJZr4ndTC7m8kPxtrxFWqJbj4=
X-Google-Smtp-Source: ABdhPJykZdFaiLAW5RnAKiEMI4MbkZou9Xwp5pTIjwagGGVbqILlP98czdVsNJEhgntIdd+goPBRdQ==
X-Received: by 2002:a17:90a:a386:: with SMTP id x6mr16594366pjp.56.1633137489685;
        Fri, 01 Oct 2021 18:18:09 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id t8sm8676362pjt.39.2021.10.01.18.18.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 18:18:09 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v7 3/9] bpf: btf: Introduce helpers for dynamic BTF set registration
Date:   Sat,  2 Oct 2021 06:47:51 +0530
Message-Id: <20211002011757.311265-4-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211002011757.311265-1-memxor@gmail.com>
References: <20211002011757.311265-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4416; h=from:subject; bh=GrUdnxmNjM0L0zN5iUj+qn/9wrTOW8D1KvsoDOm9Zn4=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhV7MRoY3YdYBELHNd0IK1oVVRptlT4W/t927kA6GN 6XoPAeaJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYVezEQAKCRBM4MiGSL8RyiNLEA CFLfbXZkHESEGjU4OqSkd/FH9gC96z5THK16Djtougz1XTPne0khhPJYLroO7DakLbAOu+MNvgei9e b+WLa4NQIi+lfaAL5eqw1cBSLJEnypwYFOtnnCLWBgDP5ZncDZw9b1BF00iulsV8X71tjcobN3qvjw yJRa2SqyIul/w9lhAcqx83AWLxvGqrJc0cHaTIiGMhbxC3SsOrqRlkY6inH03EAy4sOVepoeViy/Pw thP6gvXjOIMlhj+L+Tc1vvKe5rQn6GF300NQheodFIv9DWUqfHy/qamJiRmEG7OPCihwBIFjs734nd evblH7iKBIL/xy8qQb44xaY+/eQJDlaqVTOKZ7QEuQZXvc5uxTbu5a4ShSmvcMYqkG9SPea0n8uJeD K+g/gKp1k/1uoa4cMKwCoKZPFB6gzKmo2junxTOEB1XjUAoeWtknCYGy5uizdt3Dr0e+R9sz8mHljS LjX8oXFQX/O72es2VeFWl6ssRknp/wz90hd4NrYV86hNOzvqYohj6VuBSQEfgfEd/uqWek9+vzERBX qXI5Sc9NF5OwUgeK0DWEj/7OQXaOsDlbFFanmkO0CiX2t6IZAdn8Qzr7w/Xc+fbAeRorqwjIjnBJXr ZnAKl1Rzx714Ghki6syap2WlS4Fw06sUlEXL+PAA9pF05Zljg9PO+EByBlaw==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds helpers for registering btf_id_set from modules and the
bpf_check_mod_kfunc_call callback that can be used to look them up.

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
 include/linux/btf.h    | 36 +++++++++++++++++++++++++++++
 kernel/bpf/btf.c       | 52 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 89 insertions(+)

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
index 214fde93214b..6c4c61d821d7 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -5,6 +5,7 @@
 #define _LINUX_BTF_H 1
 
 #include <linux/types.h>
+#include <linux/bpfptr.h>
 #include <uapi/linux/btf.h>
 #include <uapi/linux/bpf.h>
 
@@ -238,4 +239,39 @@ static inline const char *btf_name_by_offset(const struct btf *btf,
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
+bool bpf_check_mod_kfunc_call(struct kfunc_btf_id_list *klist, u32 kfunc_id,
+			      struct module *owner);
+#else
+static inline void register_kfunc_btf_id_set(struct kfunc_btf_id_list *l,
+					     struct kfunc_btf_id_set *s)
+{
+}
+static inline void unregister_kfunc_btf_id_set(struct kfunc_btf_id_list *l,
+					       struct kfunc_btf_id_set *s)
+{
+}
+static inline bool bpf_check_mod_kfunc_call(struct kfunc_btf_id_list *klist,
+					    u32 kfunc_id, struct module *owner)
+{
+	return false;
+}
+#endif
+
+#define DEFINE_KFUNC_BTF_ID_SET(set, name)                                     \
+	struct kfunc_btf_id_set name = { LIST_HEAD_INIT(name.list), (set),     \
+					 THIS_MODULE }
+
 #endif
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index c3d605b22473..62cbeb4951eb 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6343,3 +6343,55 @@ const struct bpf_func_proto bpf_btf_find_by_name_kind_proto = {
 };
 
 BTF_ID_LIST_GLOBAL_SINGLE(btf_task_struct_ids, struct, task_struct)
+
+/* BTF ID set registration API for modules */
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
+bool bpf_check_mod_kfunc_call(struct kfunc_btf_id_list *klist, u32 kfunc_id,
+			      struct module *owner)
+{
+	struct kfunc_btf_id_set *s;
+
+	if (!owner)
+		return false;
+	mutex_lock(&klist->mutex);
+	list_for_each_entry(s, &klist->list, list) {
+		if (s->owner == owner && btf_id_set_contains(s->set, kfunc_id)) {
+			mutex_unlock(&klist->mutex);
+			return true;
+		}
+	}
+	mutex_unlock(&klist->mutex);
+	return false;
+}
+
+#endif
+
+#define DEFINE_KFUNC_BTF_ID_LIST(name)                                         \
+	struct kfunc_btf_id_list name = { LIST_HEAD_INIT(name.list),           \
+					  __MUTEX_INITIALIZER(name.mutex) };   \
+	EXPORT_SYMBOL_GPL(name)
-- 
2.33.0

