Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57F9746F12D
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 18:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242538AbhLIRNg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 12:13:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242575AbhLIRN2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 12:13:28 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A220C0617A2;
        Thu,  9 Dec 2021 09:09:55 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id j11so5649573pgs.2;
        Thu, 09 Dec 2021 09:09:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GvJznNDAgo3CuiHz7/K7B75kA+ahi1yXh3hHCEA8oGk=;
        b=HVHQD3Tb6SqPAHRTF9X2RQVura0Cgw/GUqxl0gcnbXawt2drQqX0W2Arq3H3gxZyMd
         MDOM7MrtDoxEYHUVTC6JPJtd3Ta5E6Dy5K51Vsj5OsZjJ3tE7a5FRw0h7QdGA2af6E/l
         XCLtiof5SAJNcUsjj4YLFGfLE6hAexGU6spMyqlh8TDo1pxu0uKt8oHbYssIVIJJOWxD
         TMtsoCRkHse7Ds29RifDIVFMHf8J+PDDRRLj3r9ji36HaL4X9fi24TuY/3rRLmT1tWDq
         SG01kCbO1/P/2pzk0AWF4TW4hLqt92xgAQNvP7+TuGs8XLzXwH3dxvW/bLmONckfNIiv
         J9nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GvJznNDAgo3CuiHz7/K7B75kA+ahi1yXh3hHCEA8oGk=;
        b=EDx8f8bLJN6nf1VASRBVpB+HQbeJ4hK3AlybyPpTfyPnA1O6qcK94iNKNz/8YzaXlW
         Et7kARhdAbueyfiogvXrbAR1e+7D69KzKGAMBvn/AWAT5vE5nA64y7s9JDQNpbdChmuc
         HvO1FT29UXI9GPhBQ2UzcszQoqPe3wy3RhUJ3R/WT4qt1snwt6kVUC5s0cV6CwtKGeUG
         2MSnvt6Y6UjFrI/qV/yJnUDr6m7nmdg5OATm9U7mlh0JvBjf4kXmvQERd9ZLwc4VD+ys
         PJ5E8Vi+H3UQpKWh521a3faS0aiYNiNkv/MD2tRVhXAkNzzLaOaoHx/bsG+Uruwj9EHE
         8M9Q==
X-Gm-Message-State: AOAM531ELLUTANViCblsmXX8h+vxnt0qhi/i72xTk4uA0urPO0RQpJ/S
        uYN0v+cPlHUSfdS5nzkMycPsDfhhNm0=
X-Google-Smtp-Source: ABdhPJxzf3UfyCtpmuDB8Ug9gOQq6eWDWBe1UCS/OaKTuEeCA0+QPLaw2f2fx2S0w9TgBo2ZRstt9w==
X-Received: by 2002:a63:ff26:: with SMTP id k38mr34591633pgi.157.1639069794104;
        Thu, 09 Dec 2021 09:09:54 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id i10sm262721pjd.3.2021.12.09.09.09.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 09:09:53 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH bpf-next v2 7/9] net/netfilter: Add unstable CT lookup helpers for XDP and TC-BPF
Date:   Thu,  9 Dec 2021 22:39:27 +0530
Message-Id: <20211209170929.3485242-8-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211209170929.3485242-1-memxor@gmail.com>
References: <20211209170929.3485242-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=22298; h=from:subject; bh=o76RpCV9bRz8OhF6ZrHxAn5RDoQ+6bdBYT9JV9rTZYY=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhsjgHSmvJ7q06/jQyxBdH2uMfWPmiNnYSkrZQ8tzi h9uf4W6JAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYbI4BwAKCRBM4MiGSL8RykjZD/ 9/lgsAPrFjVqP3dVxUBSdnq2OXPcSm+Gz2zv/G4auvGe7B8XtLbTJ6LqvADo717W/x0jYJC2vHOG/V AlYnx4I1nb/S08/xS3nZiWtOMqRNNcERm6o6S8zdx4JfbGnUfYqUJmqUlUGSA6RvyGjyJSRwdpdtmd aE+gR/4Q5yuqcbb1gBu6besud98jZFTT3GFXEcaU5um4Y4FKFXOCg4xuwvvNN8vXRmMsd6VK/9o1h3 zurdLC/tQY1dvUDMQjirgSGpYkSRVwsss7+q6xxpMKT9gHWMmg1mxJaUKixwBPm1dQrwdJPYWsmttW apc6ZMKQHCWt0mgNWfmv8w2dn4fmwx4a0SboX62f5quCCDsw0g4UtTlQYZdABEVHfZ6LbZGSrmxElI OgS8G3lV9cT5mfBvKYvs2k7lBBCsYm4MyMFkvFF3ZCxJY5YLmi2ypwPky49Jp43PZpqt8978HHLfqo zEcfvVBhQ7vIexN8WmOgvMgL+C9G8fB4jFiJonAjy5LL9RUt7obr3J02KbElKO/+1KrzOWx8UBd6gJ fBa6IgBpCxkzfGDUMOY0BtUfTcTdc8DBAkILGjdPWxH1huUXE2GOCgSVSWLQt7Kv8GWYWkh/nEn3a8 FmmKh5wKprX6mL4K8vA38YbLfDjomNIVKF/VjKfwD2OPmEo2EWJwU7pwFl3w==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change adds conntrack lookup helpers using the unstable kfunc call
interface for the XDP and TC-BPF hooks. The primary usecase is
implementing a synproxy in XDP, see Maxim's patchset at [0].

Also add acquire/release functions (randomly returning NULL), and also
exercise the PTR_TO_BTF_ID_OR_NULL path so that BPF program caller has
to check for NULL before dereferencing the pointer, for the TC hook.
Introduce kfunc that take various argument types (for PTR_TO_MEM) that
will pass and fail the verifier checks. These will be used in selftests.

Export get_net_ns_by_id as nf_conntrack needs to call it.

Note that we search for acquire, release, and null returning kfuncs in
the intersection of those sets and main set.

This implies that the kfunc_btf_id_list acq_set, rel_set, null_set may
contain BTF ID not in main set, this is explicitly allowed and
recommended (to save on definining more and more sets), since
check_kfunc_call verifier operation would filter out the invalid BTF ID
fairly early, so later checks for acquire, release, and ret_type_null
kfunc will only consider allowed BTF IDs for that program that are
allowed in main set. This is why the nf_conntrack_acq_ids set has BTF
IDs for both xdp and tc hook kfuncs.

  [0]: https://lore.kernel.org/bpf/20211019144655.3483197-1-maximmi@nvidia.com

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/linux/bpf.h               |  21 +++
 include/linux/btf.h               |  30 +++-
 kernel/bpf/btf.c                  |  19 +++
 net/bpf/test_run.c                | 147 +++++++++++++++++
 net/core/filter.c                 |  27 ++++
 net/core/net_namespace.c          |   1 +
 net/netfilter/nf_conntrack_core.c | 252 ++++++++++++++++++++++++++++++
 7 files changed, 496 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 6a14072c72a0..7b370ed06b1d 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1675,6 +1675,9 @@ int bpf_prog_test_run_sk_lookup(struct bpf_prog *prog,
 				const union bpf_attr *kattr,
 				union bpf_attr __user *uattr);
 bool bpf_prog_test_check_kfunc_call(u32 kfunc_id, struct module *owner);
+bool bpf_prog_test_is_acquire_kfunc(u32 kfunc_id, struct module *owner);
+bool bpf_prog_test_is_release_kfunc(u32 kfunc_id, struct module *owner);
+bool bpf_prog_test_is_kfunc_ret_type_null(u32 kfunc_id, struct module *owner);
 bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 		    const struct bpf_prog *prog,
 		    struct bpf_insn_access_aux *info);
@@ -1933,6 +1936,24 @@ static inline bool bpf_prog_test_check_kfunc_call(u32 kfunc_id,
 	return false;
 }
 
+static inline bool bpf_prog_test_is_acquire_kfunc(u32 kfunc_id,
+						  struct module *owner)
+{
+	return false;
+}
+
+static inline bool bpf_prog_test_is_release_kfunc(u32 kfunc_id,
+						  struct module *owner)
+{
+	return false;
+}
+
+static inline bool bpf_prog_test_is_kfunc_ret_type_null(u32 kfunc_id,
+							struct module *owner)
+{
+	return false;
+}
+
 static inline void bpf_map_put(struct bpf_map *map)
 {
 }
diff --git a/include/linux/btf.h b/include/linux/btf.h
index ec9e69c14480..8362a39fe522 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -321,7 +321,10 @@ static inline const char *btf_name_by_offset(const struct btf *btf,
 #endif
 
 enum kfunc_btf_id_set_types {
-	BTF_SET_CHECK,
+	BTF_SET_CHECK,    /* Allowed kfunc set */
+	BTF_SET_ACQUIRE,  /* Acquire kfunc set */
+	BTF_SET_RELEASE,  /* Release kfunc set */
+	BTF_SET_RET_NULL, /* kfunc with 'return type PTR_TO_BTF_ID_OR_NULL' set */
 	__BTF_SET_MAX,
 };
 
@@ -331,6 +334,9 @@ struct kfunc_btf_id_set {
 		struct btf_id_set *sets[__BTF_SET_MAX];
 		struct {
 			struct btf_id_set *set;
+			struct btf_id_set *acq_set;
+			struct btf_id_set *rel_set;
+			struct btf_id_set *null_set;
 		};
 	};
 	struct module *owner;
@@ -345,6 +351,12 @@ void unregister_kfunc_btf_id_set(struct kfunc_btf_id_list *l,
 				 struct kfunc_btf_id_set *s);
 bool bpf_check_mod_kfunc_call(struct kfunc_btf_id_list *klist, u32 kfunc_id,
 			      struct module *owner);
+bool bpf_is_mod_acquire_kfunc(struct kfunc_btf_id_list *klist, u32 kfunc_id,
+			      struct module *owner);
+bool bpf_is_mod_release_kfunc(struct kfunc_btf_id_list *klist, u32 kfunc_id,
+			      struct module *owner);
+bool bpf_is_mod_kfunc_ret_type_null(struct kfunc_btf_id_list *klist,
+				    u32 kfunc_id, struct module *owner);
 #else
 static inline void register_kfunc_btf_id_set(struct kfunc_btf_id_list *l,
 					     struct kfunc_btf_id_set *s)
@@ -359,9 +371,25 @@ bool bpf_check_mod_kfunc_call(struct kfunc_btf_id_list *klist, u32 kfunc_id,
 {
 	return false;
 }
+bool bpf_is_mod_acquire_kfunc(struct kfunc_btf_id_list *klist, u32 kfunc_id,
+			      struct module *owner)
+{
+	return false;
+}
+bool bpf_is_mod_release_kfunc(struct kfunc_btf_id_list *klist, u32 kfunc_id,
+			      struct module *owner)
+{
+	return false;
+}
+bool bpf_is_mod_kfunc_ret_type_null(struct kfunc_btf_id_list *klist,
+				    u32 kfunc_id, struct module *owner)
+{
+	return false;
+}
 #endif
 
 extern struct kfunc_btf_id_list bpf_tcp_ca_kfunc_list;
 extern struct kfunc_btf_id_list prog_test_kfunc_list;
+extern struct kfunc_btf_id_list xdp_kfunc_list;
 
 #endif
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index a790ba6d93d8..4b955f47b800 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6539,6 +6539,24 @@ bool bpf_check_mod_kfunc_call(struct kfunc_btf_id_list *klist, u32 kfunc_id,
 	return kfunc_btf_id_set_contains(klist, kfunc_id, owner, BTF_SET_CHECK);
 }
 
+bool bpf_is_mod_acquire_kfunc(struct kfunc_btf_id_list *klist, u32 kfunc_id,
+			      struct module *owner)
+{
+	return kfunc_btf_id_set_contains(klist, kfunc_id, owner, BTF_SET_ACQUIRE);
+}
+
+bool bpf_is_mod_release_kfunc(struct kfunc_btf_id_list *klist, u32 kfunc_id,
+			      struct module *owner)
+{
+	return kfunc_btf_id_set_contains(klist, kfunc_id, owner, BTF_SET_RELEASE);
+}
+
+bool bpf_is_mod_kfunc_ret_type_null(struct kfunc_btf_id_list *klist,
+				    u32 kfunc_id, struct module *owner)
+{
+	return kfunc_btf_id_set_contains(klist, kfunc_id, owner, BTF_SET_RET_NULL);
+}
+
 #endif
 
 #define DEFINE_KFUNC_BTF_ID_LIST(name)                                         \
@@ -6548,6 +6566,7 @@ bool bpf_check_mod_kfunc_call(struct kfunc_btf_id_list *klist, u32 kfunc_id,
 
 DEFINE_KFUNC_BTF_ID_LIST(bpf_tcp_ca_kfunc_list);
 DEFINE_KFUNC_BTF_ID_LIST(prog_test_kfunc_list);
+DEFINE_KFUNC_BTF_ID_LIST(xdp_kfunc_list);
 
 int bpf_core_types_are_compat(const struct btf *local_btf, __u32 local_id,
 			      const struct btf *targ_btf, __u32 targ_id)
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 46dd95755967..779377f4af25 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -232,6 +232,117 @@ struct sock * noinline bpf_kfunc_call_test3(struct sock *sk)
 	return sk;
 }
 
+struct prog_test_ref_kfunc {
+	int a;
+	int b;
+	struct prog_test_ref_kfunc *next;
+};
+
+static struct prog_test_ref_kfunc prog_test_struct = {
+	.a = 42,
+	.b = 108,
+	.next = &prog_test_struct,
+};
+
+noinline struct prog_test_ref_kfunc *
+bpf_kfunc_call_test_acquire(unsigned long *scalar_ptr)
+{
+	/* randomly return NULL */
+	if (get_jiffies_64() % 2)
+		return NULL;
+	return &prog_test_struct;
+}
+
+noinline void bpf_kfunc_call_test_release(struct prog_test_ref_kfunc *p)
+{
+}
+
+struct prog_test_pass1 {
+	int x0;
+	struct {
+		int x1;
+		struct {
+			int x2;
+			struct {
+				int x3;
+				struct {
+					int x4;
+					struct {
+						int x5;
+						struct {
+							int x6;
+							struct {
+								int x7;
+							};
+						};
+					};
+				};
+			};
+		};
+	};
+};
+
+struct prog_test_pass2 {
+	int len;
+	short arr1[4];
+	struct {
+		char arr2[4];
+		unsigned long arr3[8];
+	} x;
+};
+
+struct prog_test_fail1 {
+	void *p;
+	int x;
+};
+
+struct prog_test_fail2 {
+	int x8;
+	struct prog_test_pass1 x;
+};
+
+struct prog_test_fail3 {
+	int len;
+	char arr1[2];
+	char arr2[0];
+};
+
+noinline void bpf_kfunc_call_test_pass_ctx(struct __sk_buff *skb)
+{
+}
+
+noinline void bpf_kfunc_call_test_pass1(struct prog_test_pass1 *p)
+{
+}
+
+noinline void bpf_kfunc_call_test_pass2(struct prog_test_pass2 *p)
+{
+}
+
+noinline void bpf_kfunc_call_test_fail1(struct prog_test_fail1 *p)
+{
+}
+
+noinline void bpf_kfunc_call_test_fail2(struct prog_test_fail2 *p)
+{
+}
+
+noinline void bpf_kfunc_call_test_fail3(struct prog_test_fail3 *p)
+{
+}
+
+noinline void bpf_kfunc_call_test_mem_len_pass1(void *mem, int len__mem)
+{
+}
+
+noinline void bpf_kfunc_call_test_mem_len_fail1(void *mem, int len)
+{
+}
+
+noinline void bpf_kfunc_call_test_mem_len_fail2(u64 *mem, int len)
+{
+}
+
 __diag_pop();
 
 ALLOW_ERROR_INJECTION(bpf_modify_return_test, ERRNO);
@@ -240,8 +351,23 @@ BTF_SET_START(test_sk_kfunc_ids)
 BTF_ID(func, bpf_kfunc_call_test1)
 BTF_ID(func, bpf_kfunc_call_test2)
 BTF_ID(func, bpf_kfunc_call_test3)
+BTF_ID(func, bpf_kfunc_call_test_acquire)
+BTF_ID(func, bpf_kfunc_call_test_release)
+BTF_ID(func, bpf_kfunc_call_test_pass_ctx)
+BTF_ID(func, bpf_kfunc_call_test_pass1)
+BTF_ID(func, bpf_kfunc_call_test_pass2)
+BTF_ID(func, bpf_kfunc_call_test_fail1)
+BTF_ID(func, bpf_kfunc_call_test_fail2)
+BTF_ID(func, bpf_kfunc_call_test_fail3)
+BTF_ID(func, bpf_kfunc_call_test_mem_len_pass1)
+BTF_ID(func, bpf_kfunc_call_test_mem_len_fail1)
+BTF_ID(func, bpf_kfunc_call_test_mem_len_fail2)
 BTF_SET_END(test_sk_kfunc_ids)
 
+BTF_ID_LIST(test_sk_acq_rel)
+BTF_ID(func, bpf_kfunc_call_test_acquire)
+BTF_ID(func, bpf_kfunc_call_test_release)
+
 bool bpf_prog_test_check_kfunc_call(u32 kfunc_id, struct module *owner)
 {
 	if (btf_id_set_contains(&test_sk_kfunc_ids, kfunc_id))
@@ -249,6 +375,27 @@ bool bpf_prog_test_check_kfunc_call(u32 kfunc_id, struct module *owner)
 	return bpf_check_mod_kfunc_call(&prog_test_kfunc_list, kfunc_id, owner);
 }
 
+bool bpf_prog_test_is_acquire_kfunc(u32 kfunc_id, struct module *owner)
+{
+	if (kfunc_id == test_sk_acq_rel[0])
+		return true;
+	return bpf_is_mod_acquire_kfunc(&prog_test_kfunc_list, kfunc_id, owner);
+}
+
+bool bpf_prog_test_is_release_kfunc(u32 kfunc_id, struct module *owner)
+{
+	if (kfunc_id == test_sk_acq_rel[1])
+		return true;
+	return bpf_is_mod_release_kfunc(&prog_test_kfunc_list, kfunc_id, owner);
+}
+
+bool bpf_prog_test_is_kfunc_ret_type_null(u32 kfunc_id, struct module *owner)
+{
+	if (kfunc_id == test_sk_acq_rel[0])
+		return true;
+	return bpf_is_mod_kfunc_ret_type_null(&prog_test_kfunc_list, kfunc_id, owner);
+}
+
 static void *bpf_test_init(const union bpf_attr *kattr, u32 size,
 			   u32 headroom, u32 tailroom)
 {
diff --git a/net/core/filter.c b/net/core/filter.c
index fe27c91e3758..ad84ec6e0daa 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -10000,17 +10000,44 @@ const struct bpf_verifier_ops tc_cls_act_verifier_ops = {
 	.gen_prologue		= tc_cls_act_prologue,
 	.gen_ld_abs		= bpf_gen_ld_abs,
 	.check_kfunc_call	= bpf_prog_test_check_kfunc_call,
+	.is_acquire_kfunc	= bpf_prog_test_is_acquire_kfunc,
+	.is_release_kfunc	= bpf_prog_test_is_release_kfunc,
+	.is_kfunc_ret_type_null = bpf_prog_test_is_kfunc_ret_type_null,
 };
 
 const struct bpf_prog_ops tc_cls_act_prog_ops = {
 	.test_run		= bpf_prog_test_run_skb,
 };
 
+static bool xdp_check_kfunc_call(u32 kfunc_id, struct module *owner)
+{
+	return bpf_check_mod_kfunc_call(&xdp_kfunc_list, kfunc_id, owner);
+}
+
+static bool xdp_is_acquire_kfunc(u32 kfunc_id, struct module *owner)
+{
+	return bpf_is_mod_acquire_kfunc(&xdp_kfunc_list, kfunc_id, owner);
+}
+
+static bool xdp_is_release_kfunc(u32 kfunc_id, struct module *owner)
+{
+	return bpf_is_mod_release_kfunc(&xdp_kfunc_list, kfunc_id, owner);
+}
+
+static bool xdp_is_kfunc_ret_type_null(u32 kfunc_id, struct module *owner)
+{
+	return bpf_is_mod_kfunc_ret_type_null(&xdp_kfunc_list, kfunc_id, owner);
+}
+
 const struct bpf_verifier_ops xdp_verifier_ops = {
 	.get_func_proto		= xdp_func_proto,
 	.is_valid_access	= xdp_is_valid_access,
 	.convert_ctx_access	= xdp_convert_ctx_access,
 	.gen_prologue		= bpf_noop_prologue,
+	.check_kfunc_call	= xdp_check_kfunc_call,
+	.is_acquire_kfunc	= xdp_is_acquire_kfunc,
+	.is_release_kfunc	= xdp_is_release_kfunc,
+	.is_kfunc_ret_type_null = xdp_is_kfunc_ret_type_null,
 };
 
 const struct bpf_prog_ops xdp_prog_ops = {
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 202fa5eacd0f..7b4bfe793002 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -299,6 +299,7 @@ struct net *get_net_ns_by_id(const struct net *net, int id)
 
 	return peer;
 }
+EXPORT_SYMBOL_GPL(get_net_ns_by_id);
 
 /*
  * setup_net runs the initializers for the network namespace object.
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 770a63103c7a..85042cb6f82e 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -11,6 +11,9 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/bpf.h>
+#include <linux/btf.h>
+#include <linux/btf_ids.h>
 #include <linux/types.h>
 #include <linux/netfilter.h>
 #include <linux/module.h>
@@ -2451,6 +2454,249 @@ static int kill_all(struct nf_conn *i, void *data)
 	return net_eq(nf_ct_net(i), data);
 }
 
+/* Unstable Kernel Helpers for XDP and TC-BPF hook
+ *
+ * These are called from the XDP and SCHED_CLS BPF programs. Note that it is
+ * allowed to break compatibility for these functions since the interface they
+ * are exposed through to BPF programs is explicitly unstable.
+ */
+static struct nf_conn *__bpf_nf_ct_lookup(struct net *net,
+					  struct bpf_sock_tuple *bpf_tuple,
+					  u32 tuple_len, u8 protonum,
+					  s32 netns_id)
+{
+	struct nf_conntrack_tuple_hash *hash;
+	struct nf_conntrack_tuple tuple;
+
+	if (unlikely(protonum != IPPROTO_TCP && protonum != IPPROTO_UDP))
+		return ERR_PTR(-EPROTO);
+	if (unlikely(netns_id < BPF_F_CURRENT_NETNS))
+		return ERR_PTR(-EINVAL);
+
+	memset(&tuple, 0, sizeof(tuple));
+	switch (tuple_len) {
+	case sizeof(bpf_tuple->ipv4):
+		tuple.src.l3num = AF_INET;
+		tuple.src.u3.ip = bpf_tuple->ipv4.saddr;
+		tuple.src.u.tcp.port = bpf_tuple->ipv4.sport;
+		tuple.dst.u3.ip = bpf_tuple->ipv4.daddr;
+		tuple.dst.u.tcp.port = bpf_tuple->ipv4.dport;
+		break;
+	case sizeof(bpf_tuple->ipv6):
+		tuple.src.l3num = AF_INET6;
+		memcpy(tuple.src.u3.ip6, bpf_tuple->ipv6.saddr, sizeof(bpf_tuple->ipv6.saddr));
+		tuple.src.u.tcp.port = bpf_tuple->ipv6.sport;
+		memcpy(tuple.dst.u3.ip6, bpf_tuple->ipv6.daddr, sizeof(bpf_tuple->ipv6.daddr));
+		tuple.dst.u.tcp.port = bpf_tuple->ipv6.dport;
+		break;
+	default:
+		return ERR_PTR(-EAFNOSUPPORT);
+	}
+
+	tuple.dst.protonum = protonum;
+
+	if (netns_id >= 0) {
+		net = get_net_ns_by_id(net, netns_id);
+		if (unlikely(!net))
+			return ERR_PTR(-ENONET);
+	}
+
+	hash = nf_conntrack_find_get(net, &nf_ct_zone_dflt, &tuple);
+	if (netns_id >= 0)
+		put_net(net);
+	if (!hash)
+		return ERR_PTR(-ENOENT);
+	return nf_ct_tuplehash_to_ctrack(hash);
+}
+
+/* bpf_ct_opts - Options for CT lookup helpers
+ *
+ * Members:
+ * @error      - Out parameter, set for any errors encountered
+ *		 Values:
+ *		   -EINVAL - Passed NULL for bpf_tuple pointer
+ *		   -EINVAL - opts->reserved is not 0
+ *		   -EINVAL - netns_id is less than -1
+ *		   -EINVAL - len__opts isn't NF_BPF_CT_OPTS_SZ (12)
+ *		   -EPROTO - l4proto isn't one of IPPROTO_TCP or IPPROTO_UDP
+ *		   -ENONET - No network namespace found for netns_id
+ *		   -ENOENT - Conntrack lookup could not find entry for tuple
+ *		   -EAFNOSUPPORT - len__tuple isn't one of sizeof(tuple->ipv4)
+ *				   or sizeof(tuple->ipv6)
+ * @l4proto    - Layer 4 protocol
+ *		 Values:
+ *		   IPPROTO_TCP, IPPROTO_UDP
+ * @reserved   - Reserved member, will be reused for more options in future
+ *		 Values:
+ *		   0
+ * @netns_id   - Specify the network namespace for lookup
+ *		 Values:
+ *		   BPF_F_CURRENT_NETNS (-1)
+ *		     Use namespace associated with ctx (xdp_md, __sk_buff)
+ *		   [0, S32_MAX]
+ *		     Network Namespace ID
+ */
+struct bpf_ct_opts {
+	s32 netns_id;
+	s32 error;
+	u8 l4proto;
+	u8 reserved[3];
+};
+
+enum {
+	NF_BPF_CT_OPTS_SZ = 12,
+};
+
+/* bpf_xdp_ct_lookup - Lookup CT entry for the given tuple, and acquire a
+ *		       reference to it
+ *
+ * Parameters:
+ * @xdp_ctx	- Pointer to ctx (xdp_md) in XDP program
+ *		    Cannot be NULL
+ * @bpf_tuple	- Pointer to memory representing the tuple to look up
+ *		    Cannot be NULL
+ * @len__tuple	- Length of the tuple structure
+ *		    Must be one of sizeof(bpf_tuple->ipv4) or
+ *		    sizeof(bpf_tuple->ipv6)
+ * @opts	- Additional options for lookup (documented above)
+ *		    Cannot be NULL
+ * @len__opts	- Length of the bpf_ct_opts structure
+ *		    Must be NF_BPF_CT_OPTS_SZ (12)
+ */
+struct nf_conn *bpf_xdp_ct_lookup(struct xdp_md *xdp_ctx,
+				  struct bpf_sock_tuple *bpf_tuple,
+				  u32 len__tuple, struct bpf_ct_opts *opts,
+				  u32 len__opts)
+{
+	struct xdp_buff *ctx = (struct xdp_buff *)xdp_ctx;
+	struct net *caller_net;
+	struct nf_conn *nfct;
+
+	BUILD_BUG_ON(sizeof(struct bpf_ct_opts) != NF_BPF_CT_OPTS_SZ);
+
+	if (!opts)
+		return NULL;
+	if (!bpf_tuple || opts->reserved[0] || opts->reserved[1] ||
+	    opts->reserved[2] || len__opts != NF_BPF_CT_OPTS_SZ) {
+		opts->error = -EINVAL;
+		return NULL;
+	}
+	caller_net = dev_net(ctx->rxq->dev);
+	nfct = __bpf_nf_ct_lookup(caller_net, bpf_tuple, len__tuple, opts->l4proto,
+				  opts->netns_id);
+	if (IS_ERR(nfct)) {
+		opts->error = PTR_ERR(nfct);
+		return NULL;
+	}
+	return nfct;
+}
+
+/* bpf_skb_ct_lookup - Lookup CT entry for the given tuple, and acquire a
+ *		       reference to it
+ *
+ * Parameters:
+ * @skb_ctx	- Pointer to ctx (__sk_buff) in TC program
+ *		    Cannot be NULL
+ * @bpf_tuple	- Pointer to memory representing the tuple to look up
+ *		    Cannot be NULL
+ * @len__tuple	- Length of the tuple structure
+ *		    Must be one of sizeof(bpf_tuple->ipv4) or
+ *		    sizeof(bpf_tuple->ipv6)
+ * @opts	- Additional options for lookup (documented above)
+ *		    Cannot be NULL
+ * @len__opts	- Length of the bpf_ct_opts structure
+ *		    Must be NF_BPF_CT_OPTS_SZ (12)
+ */
+struct nf_conn *bpf_skb_ct_lookup(struct __sk_buff *skb_ctx,
+				  struct bpf_sock_tuple *bpf_tuple,
+				  u32 len__tuple, struct bpf_ct_opts *opts,
+				  u32 len__opts)
+{
+	struct sk_buff *skb = (struct sk_buff *)skb_ctx;
+	struct net *caller_net;
+	struct nf_conn *nfct;
+
+	BUILD_BUG_ON(sizeof(struct bpf_ct_opts) != NF_BPF_CT_OPTS_SZ);
+
+	if (!opts)
+		return NULL;
+	if (!bpf_tuple || opts->reserved[0] || opts->reserved[1] ||
+	    opts->reserved[2] || len__opts != NF_BPF_CT_OPTS_SZ) {
+		opts->error = -EINVAL;
+		return NULL;
+	}
+	caller_net = skb->dev ? dev_net(skb->dev) : sock_net(skb->sk);
+	nfct = __bpf_nf_ct_lookup(caller_net, bpf_tuple, len__tuple, opts->l4proto,
+				  opts->netns_id);
+	if (IS_ERR(nfct)) {
+		opts->error = PTR_ERR(nfct);
+		return NULL;
+	}
+	return nfct;
+}
+
+/* bpf_ct_release - Release acquired nf_conn object
+ *
+ * This must be invoked for referenced PTR_TO_BTF_ID, and the verifier rejects
+ * the program if any references remain in the program in all of the explored
+ * states.
+ *
+ * Parameters:
+ * @nf_conn	 - Pointer to referenced nf_conn object, obtained using
+ *		   bpf_xdp_ct_lookup or bpf_skb_ct_lookup.
+ */
+void bpf_ct_release(struct nf_conn *nfct)
+{
+	if (!nfct)
+		return;
+	nf_ct_put(nfct);
+}
+
+/* kfuncs that may return NULL PTR_TO_BTF_ID */
+BTF_SET_START(nf_conntrack_null_ids)
+BTF_ID(func, bpf_xdp_ct_lookup)
+BTF_ID(func, bpf_skb_ct_lookup)
+BTF_SET_END(nf_conntrack_null_ids)
+
+/* XDP hook allowed kfuncs */
+BTF_SET_START(nf_conntrack_xdp_ids)
+BTF_ID(func, bpf_xdp_ct_lookup)
+BTF_ID(func, bpf_ct_release)
+BTF_SET_END(nf_conntrack_xdp_ids)
+
+/* TC-BPF hook allowed kfuncs */
+BTF_SET_START(nf_conntrack_skb_ids)
+BTF_ID(func, bpf_skb_ct_lookup)
+BTF_ID(func, bpf_ct_release)
+BTF_SET_END(nf_conntrack_skb_ids)
+
+/* XDP and TC-BPF hook acquire kfuncs */
+BTF_SET_START(nf_conntrack_acq_ids)
+BTF_ID(func, bpf_xdp_ct_lookup)
+BTF_ID(func, bpf_skb_ct_lookup)
+BTF_SET_END(nf_conntrack_acq_ids)
+
+/* XDP and TC-BPF hook release kfuncs */
+BTF_SET_START(nf_conntrack_rel_ids)
+BTF_ID(func, bpf_ct_release)
+BTF_SET_END(nf_conntrack_rel_ids)
+
+static struct kfunc_btf_id_set nf_ct_xdp_kfunc_set = {
+	.owner                 = THIS_MODULE,
+	.set                   = &nf_conntrack_xdp_ids,
+	.acq_set	       = &nf_conntrack_acq_ids,
+	.rel_set	       = &nf_conntrack_rel_ids,
+	.null_set	       = &nf_conntrack_null_ids,
+};
+
+static struct kfunc_btf_id_set nf_ct_skb_kfunc_set = {
+	.owner                 = THIS_MODULE,
+	.set                   = &nf_conntrack_skb_ids,
+	.acq_set	       = &nf_conntrack_acq_ids,
+	.rel_set	       = &nf_conntrack_rel_ids,
+	.null_set	       = &nf_conntrack_null_ids,
+};
+
 void nf_conntrack_cleanup_start(void)
 {
 	conntrack_gc_work.exiting = true;
@@ -2459,6 +2705,9 @@ void nf_conntrack_cleanup_start(void)
 
 void nf_conntrack_cleanup_end(void)
 {
+	unregister_kfunc_btf_id_set(&xdp_kfunc_list, &nf_ct_xdp_kfunc_set);
+	unregister_kfunc_btf_id_set(&prog_test_kfunc_list, &nf_ct_skb_kfunc_set);
+
 	RCU_INIT_POINTER(nf_ct_hook, NULL);
 	cancel_delayed_work_sync(&conntrack_gc_work.dwork);
 	kvfree(nf_conntrack_hash);
@@ -2745,6 +2994,9 @@ int nf_conntrack_init_start(void)
 	conntrack_gc_work_init(&conntrack_gc_work);
 	queue_delayed_work(system_power_efficient_wq, &conntrack_gc_work.dwork, HZ);
 
+	register_kfunc_btf_id_set(&prog_test_kfunc_list, &nf_ct_skb_kfunc_set);
+	register_kfunc_btf_id_set(&xdp_kfunc_list, &nf_ct_xdp_kfunc_set);
+
 	return 0;
 
 err_proto:
-- 
2.34.1

