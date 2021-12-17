Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F98947826C
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 02:50:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232006AbhLQBui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 20:50:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbhLQBui (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 20:50:38 -0500
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0D74C061574;
        Thu, 16 Dec 2021 17:50:37 -0800 (PST)
Received: by mail-pj1-x1042.google.com with SMTP id co15so825976pjb.2;
        Thu, 16 Dec 2021 17:50:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qr2kcrgwOSbevMYO+WHv635g5JWPM5Czpfl1U7E6+Bc=;
        b=bf26hw4WBW/Ojt79pBHr85SQ92nfGG/lcIlGojQwFN0DQucVL7fEiZIcr1lDOjfEhb
         I+r0jbDeqpsrjCG/ofyrDIQ+IK10I5KdRxFqMVZ3/OHXosFGc/HsX1H1RvDrPHjPKW0q
         LS2KabakVdHMNQyI/0hqUIUuBzgkNRx7FvaRX5pNF+u42QpfAIQjZ22mT/M8YbSsa9cq
         iulXsEOpm6OiuaZFdSvXOWnYJAIFAkSt4P/z9EEGugVXK7T4xQOjXfU3mx/qFcv7mNpQ
         hlbcy4g9A6LmhcRr0IUdoyDliFcgoTM5KikAwKyRJsFfFn1TnglE3U8vu/k1X9vrrFUk
         BsNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qr2kcrgwOSbevMYO+WHv635g5JWPM5Czpfl1U7E6+Bc=;
        b=bYdo0ujLid4qye85fl5aPtoTys5MXvsGCaRYmGW7L/l7o5fFbCpnC8f5xGSQGm5glv
         6C6snzdXYqTwyiUDTn9TLxmECW6N75UMEgb4AGDs74nXRF0cE8bSYUdAfArYeF/xgwC2
         JBofp+mOG0mTy4c2nwrMwAxCrbWyl7WSP/WsGOEooANlBxzCBJg7t7QoBMy1u4vJvdon
         BuNMsY/gMI2JDnIfI0uaSG951htCm9/5I684aptB+uMqHKR3GXWro+1Qn6OzJfCsXL8/
         92eWYCb4DZXSuL1kcQxpH/ONhvDJO1d0Nbgs2ShGC0A3U8V1QC6y7EyTzgvla/dPo21m
         7jgw==
X-Gm-Message-State: AOAM5322e692iiHl2vD5MRsbI3wIGIvIm4nWgdINT0Ah3g+tIAVWfVGp
        IRy0VJeGK6/oG6jdVlO+mY0t1W2eyqI=
X-Google-Smtp-Source: ABdhPJwQJudODRGJYNZIx0XmvOSbBzmcaxC4H6olh0HSAU1BQqMlcoFWfOX4qMo+nY1BtCRYLeCUPw==
X-Received: by 2002:a17:90a:8807:: with SMTP id s7mr1018923pjn.229.1639705837188;
        Thu, 16 Dec 2021 17:50:37 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id h8sm7802784pfh.10.2021.12.16.17.50.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 17:50:36 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH bpf-next v4 01/10] bpf: Refactor bpf_check_mod_kfunc_call
Date:   Fri, 17 Dec 2021 07:20:22 +0530
Message-Id: <20211217015031.1278167-2-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211217015031.1278167-1-memxor@gmail.com>
References: <20211217015031.1278167-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3649; h=from:subject; bh=LL+2pO42FBqGl5mH6a78USOP58BAKnND4s9qqli/aEs=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhu+vE0knFvDwuGiDut9WrvUun/kU8sprZosRkLpqJ yerqHemJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYbvrxAAKCRBM4MiGSL8RyokBD/ 9khGyZUOHE/H8XHKN4rWrs4gEAjuQrrpf878qZ7wbZMPR3wKSpXL2qWsmSS3eTvBIplnc3q3XCSMSq IZYgL6NS7ByMytCJDCuhAKE6r6mTp5ejR53sIQq9OUme5UBcnGKRGyEaqupjhUg+jiPfHT8SEyOOy1 ISz+c5ye0i/qkRG3qu88ETRW91QPCWDH/EHFNUn05AcMxmEQezLiHMnivnxujvvkjKMq5R1xkOIFRx 9yWPncHxOnVrCmhqcvYA46D4t4xdmY99wCVXIkbaT4R19xF7u08A6aiyAaJCUFHEdlGDyt4kroztyD WUeNCJeUL0awn2dViWRniL1yJmZof2oHsyIKDPIffS+6RjsMQYpVoSh0zDY+qK1zaKm+9qiRh4CkvF WOn9frGcVNmlYwUesBMmdaVwzCwam5o7VsyBJrRA0mvMvOrwiapViVgu0TbwivLcCSQj0pEU1ARBGZ W6S6IJ8T5tG5qXukwZPMqnbRRPb+7i5OGw1+PuqPbeLx/2wPKdcJoDViufZN0UglAUaVHSkZ74LrOh sdT1Tf+DYXTZjxi94KUjT2yU41Ss1qsBZI859AS3IpmgHGY2Wx8zmmlgTfAV+tHuCyJGSSErpR+0bk p/dPNp2qbQM1wgp9vTBQLL8dsL99CJITiV9nlbOXg58astsraaZB9NYAJx9Q==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Future commits adding more callbacks will implement the same pattern of
matching module owner of kfunc_btf_id_set, and then operating on more
sets inside the struct. Instead of having to repeat the same code of
walking over the list, lift code searching individual sets corresponding
to a owner module out into a common helper, and index into sets array.

While the btf_id_set 'set' member for check_kfunc_call wouldn't have
been NULL so far, future commits introduce sets that are optional, hence
the common code also checks whether the pointer is valid (i.e. not NULL).

Note that we must continue search on owner match and btf_id_set_contains
returning false, since more entries may have same owner (since it can be
NULL for built-in modules). To clarify this case, a comment is added, so
that future commits don't regress the search, as it was fixed recently
in commit b12f03104324 ("bpf: Fix bpf_check_mod_kfunc_call for built-in
modules").

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/linux/btf.h | 15 +++++++++++++--
 kernel/bpf/btf.c    | 25 +++++++++++++++++++------
 2 files changed, 32 insertions(+), 8 deletions(-)

diff --git a/include/linux/btf.h b/include/linux/btf.h
index 0c74348cbc9d..916da2efbea8 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -320,9 +320,19 @@ static inline const char *btf_name_by_offset(const struct btf *btf,
 }
 #endif
 
+enum kfunc_btf_id_set_type {
+	BTF_SET_CHECK,
+	__BTF_SET_MAX,
+};
+
 struct kfunc_btf_id_set {
 	struct list_head list;
-	struct btf_id_set *set;
+	union {
+		struct btf_id_set *sets[__BTF_SET_MAX];
+		struct {
+			struct btf_id_set *set;
+		};
+	};
 	struct module *owner;
 };
 
@@ -361,7 +371,8 @@ static struct kfunc_btf_id_list prog_test_kfunc_list __maybe_unused;
 #endif
 
 #define DEFINE_KFUNC_BTF_ID_SET(set, name)                                     \
-	struct kfunc_btf_id_set name = { LIST_HEAD_INIT(name.list), (set),     \
+	struct kfunc_btf_id_set name = { LIST_HEAD_INIT(name.list),            \
+					 { { (set) } },                        \
 					 THIS_MODULE }
 
 #endif
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index a17de71abd2e..97f6729cf23c 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6384,20 +6384,33 @@ void unregister_kfunc_btf_id_set(struct kfunc_btf_id_list *l,
 }
 EXPORT_SYMBOL_GPL(unregister_kfunc_btf_id_set);
 
-bool bpf_check_mod_kfunc_call(struct kfunc_btf_id_list *klist, u32 kfunc_id,
-			      struct module *owner)
+/* Caller must hold reference to module 'owner' */
+static bool kfunc_btf_id_set_contains(struct kfunc_btf_id_list *klist,
+				      u32 kfunc_id, struct module *owner,
+				      enum kfunc_btf_id_set_type type)
 {
 	struct kfunc_btf_id_set *s;
+	bool ret = false;
 
+	if (type >= __BTF_SET_MAX)
+		return false;
 	mutex_lock(&klist->mutex);
 	list_for_each_entry(s, &klist->list, list) {
-		if (s->owner == owner && btf_id_set_contains(s->set, kfunc_id)) {
-			mutex_unlock(&klist->mutex);
-			return true;
+		if (s->owner == owner && s->sets[type] &&
+		    btf_id_set_contains(s->sets[type], kfunc_id)) {
+			ret = true;
+			break;
 		}
+		/* continue search, since multiple sets may have same owner */
 	}
 	mutex_unlock(&klist->mutex);
-	return false;
+	return ret;
+}
+
+bool bpf_check_mod_kfunc_call(struct kfunc_btf_id_list *klist, u32 kfunc_id,
+			      struct module *owner)
+{
+	return kfunc_btf_id_set_contains(klist, kfunc_id, owner, BTF_SET_CHECK);
 }
 
 #define DEFINE_KFUNC_BTF_ID_LIST(name)                                         \
-- 
2.34.1

