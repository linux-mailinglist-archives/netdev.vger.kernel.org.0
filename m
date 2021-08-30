Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF823FBB11
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 19:35:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238304AbhH3Rf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 13:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238241AbhH3Rfm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 13:35:42 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDC3BC061575;
        Mon, 30 Aug 2021 10:34:48 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id n12so8939346plk.10;
        Mon, 30 Aug 2021 10:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Bllv4igQDhqfPNPj8PECvsAivrNhA9cZwlyPHLyQwGk=;
        b=ZJPGiuLABZi47A1dnOh0J/Cs1KVnYjva6xVeMOXMkwc4HNRgsCjI3ZJxEsBYA3jsvJ
         9pHI54FlwZEKhwq8yYKCiTj7uarSczXi8RfGWhOWRkp9uKwxvN2EUIeJnkxf/JjAptaw
         5wQjFNCaAtVaFQANxR+SbEuaFMMph8ffZEdqM8UVm9BCGWABTmWs1Orwi2Wu45HEji7r
         R47LT6x4qx1wzgix49C6leTh5mWKjSnAEEDDkMNJuWlVcxrYUNX5trdJ9uc83p2s88Kk
         lMzfKusu631PBqDXiM2dk+FWAGBOKwyA0gEqoM/17a/xrIectvmSGwMD1m4EXI1yIfxp
         Jalw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Bllv4igQDhqfPNPj8PECvsAivrNhA9cZwlyPHLyQwGk=;
        b=dYXy+rjLCNek1UFldSEpDj0nDlg+A8D8p8Cpul1thShITxIUkarDZyKUbYb9vlc/um
         vOKfEwiHHjJoq2gyRea3ZC8hxx3qbGAHFDkwLAcS0wsmN5i+lGaWun9ZRfC5UNpKZQyp
         x/TlZgntfE/yru113nYA8TgNUV+gmTjZR+NlPBkkzKFvJSQAdgQfWzXqz2kn6vLSDpY+
         OJ97a2p+XFdf6Eln80lAodCDy3/usPUJofLDpB+TltFYhmwkzu/haQUCEEug0sZYixLD
         mKDg+qbdyVxC6PvqaXJ9ZU7vHrqrxJ8rizHFX1cDlSBEy+18pSDqB+QWTB47Dnq3XfAe
         G/6Q==
X-Gm-Message-State: AOAM5333HLb+5sk2j1+AsxXuNFXtiFES5j0gDDgwsFZ9Wb2RFaC97zc6
        RsGas3NzJRklRfFvE8/YKtM7lqfDuf/OqQ==
X-Google-Smtp-Source: ABdhPJwq4HKoKG+9P0UUNcnIF9arwwXQJTlK4la/jkZtR4SZDuoU06nXnjp54Ax6C0AsYshrrPBDsg==
X-Received: by 2002:a17:90b:1293:: with SMTP id fw19mr235382pjb.26.1630344888288;
        Mon, 30 Aug 2021 10:34:48 -0700 (PDT)
Received: from localhost ([2405:201:6014:d820:9cc6:d37f:c2fd:dc6])
        by smtp.gmail.com with ESMTPSA id b5sm11057273pfr.26.2021.08.30.10.34.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 10:34:48 -0700 (PDT)
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
Subject: [PATCH bpf-next RFC v1 6/8] bpf: btf: Introduce helpers for dynamic BTF set registration
Date:   Mon, 30 Aug 2021 23:04:22 +0530
Message-Id: <20210830173424.1385796-7-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210830173424.1385796-1-memxor@gmail.com>
References: <20210830173424.1385796-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4964; h=from:subject; bh=nXaHbRpL2WVIVSeC9fgjWSV4M/WCqUXTEg9q2jrxx7c=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhLRX9Of4lr28/jnSo4KXOXyXkseR3R6KLvIGuiN/d TQM2jOCJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYS0V/QAKCRBM4MiGSL8Ryl9BD/ 4lGwf+9I1Fn9wUxKEt1K41u1F2XFOLEyxXVruRcTP3G89b/yZxQ2d17sljpthLgwXXuFMDxEP8tv0A hhfUErJbjghiznIHNPICirHuiSZvKwpU5xRskHHDv/kh7sy9WWbB7TXSgzCqNXAdTFCUmecMogiaIe b9PB0jBkIWqErRfdXThGMP/atXheP7N0Y9Tq44gWbp+qjyAvXomi9wruXHZ0QmJ+Rx+TOBIiTH9Xkt E1OzMrxrXPp55I2b/78gUQGZ5y57WswqEaRO1WfYYFNwveQK2PF4jBiX6r0YUTFfg1hTqIGkWsLUGN Pp4GUAJd9oMXFTNUOjAldnCHBXe0JUq5LwjX3z5zM47Ki/32+T9PR9o5TRmcpKVxA9hOzzZ/ETj/GB 5bYhRA86kxSIKamkPwh4bbI2L4admrwyaKxYTOP6eUMfAecw+fm40Jy625y4wFukC2Ckog5fCRXHrV GZ9iXLunEH8FxYJQmM+oaz0bhcKWA+AWKUg7h4VvjwiT+v8TM0ifBL4APvur7PV23e12s69dHNHGNh yz+7fMHirJH71z9t0pqCzDx2wZh21+Hv2djcgIu3yt33fCgLXEfEdF+RznUjTFg/NBsyUjfV+LZa1W LWS/wR6pMPq9N/uDpZoDNmdOoxx7xitJKW89jLtkpQyNik+ykTyOGg5h/2sA==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds macros that generate BTF set registration APIs and
check_kfunc_call callback. These require a type, which namespaces each
BTF set. This is in preparation to allow for nf_conntrack registering
unstable helpers it wants to expose to XDP and SCHED_CLS programs in
subsequent patches.

With in kernel sets, the way this is supposed to work is, in kernel
callback looks up within the in-kernel kfunc whitelist, and then defers
to the dynamic BTF set lookup if it doesn't find the BTF id. If there is
no in-kernel BTF id set, this callback can be directly used.

Also fix includes for btf.h and bpfptr.h so that they can included in
isolation. This is in preparation for their usage in tcp_bbr, tcp_cubic
and tcp_dctcp modules in the next patch.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/linux/bpfptr.h |  1 +
 include/linux/btf.h    | 15 +++++++++++++++
 kernel/bpf/btf.c       | 34 ++++++++++++++++++++++++++++++++++
 3 files changed, 50 insertions(+)

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
index 214fde93214b..d024b0eb43f9 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -5,6 +5,7 @@
 #define _LINUX_BTF_H 1
 
 #include <linux/types.h>
+#include <linux/bpfptr.h>
 #include <uapi/linux/btf.h>
 #include <uapi/linux/bpf.h>
 
@@ -238,4 +239,18 @@ static inline const char *btf_name_by_offset(const struct btf *btf,
 }
 #endif
 
+struct kfunc_btf_set {
+	struct list_head list;
+	struct btf_id_set *set;
+};
+
+/* Register set of BTF ids */
+#define DECLARE_KFUNC_BTF_SET_REG(type)                                        \
+	void register_##type##_kfunc_btf_set(struct kfunc_btf_set *s);         \
+	bool __bpf_check_##type##_kfunc_call(u32 kfunc_id);                    \
+	void unregister_##type##_kfunc_btf_set(struct kfunc_btf_set *s)
+
+#define DEFINE_KFUNC_BTF_SET(set, name)                                        \
+	struct kfunc_btf_set name = { LIST_HEAD_INIT(name.list), (set) }
+
 #endif
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index dfe61df4f974..35873495761d 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6215,3 +6215,37 @@ const struct bpf_func_proto bpf_btf_find_by_name_kind_proto = {
 };
 
 BTF_ID_LIST_GLOBAL_SINGLE(btf_task_struct_ids, struct, task_struct)
+
+/* Typesafe helpers to register BTF ID sets for modules */
+#define DEFINE_KFUNC_BTF_SET_REG(type)                                         \
+	static DEFINE_MUTEX(type##_kfunc_btf_set_mutex);                       \
+	static LIST_HEAD(type##_kfunc_btf_set_list);                           \
+	void register_##type##_kfunc_btf_set(struct kfunc_btf_set *s)          \
+	{                                                                      \
+		mutex_lock(&type##_kfunc_btf_set_mutex);                       \
+		list_add(&s->list, &type##_kfunc_btf_set_list);                \
+		mutex_unlock(&type##_kfunc_btf_set_mutex);                     \
+	}                                                                      \
+	EXPORT_SYMBOL_GPL(register_##type##_kfunc_btf_set);                    \
+	bool __bpf_check_##type##_kfunc_call(u32 kfunc_id)                     \
+	{                                                                      \
+		struct kfunc_btf_set *s;                                       \
+		mutex_lock(&type##_kfunc_btf_set_mutex);                       \
+		list_for_each_entry(s, &type##_kfunc_btf_set_list, list) {     \
+			if (btf_id_set_contains(s->set, kfunc_id)) {           \
+				mutex_unlock(&type##_kfunc_btf_set_mutex);     \
+				return true;                                   \
+			}                                                      \
+		}                                                              \
+		mutex_unlock(&type##_kfunc_btf_set_mutex);                     \
+		return false;                                                  \
+	}                                                                      \
+	void unregister_##type##_kfunc_btf_set(struct kfunc_btf_set *s)        \
+	{                                                                      \
+		if (!s)                                                        \
+			return;                                                \
+		mutex_lock(&type##_kfunc_btf_set_mutex);                       \
+		list_del_init(&s->list);                                       \
+		mutex_unlock(&type##_kfunc_btf_set_mutex);                     \
+	}                                                                      \
+	EXPORT_SYMBOL_GPL(unregister_##type##_kfunc_btf_set)
-- 
2.33.0

