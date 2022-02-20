Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09DCA4BCEC8
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 14:56:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243208AbiBTNsq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 08:48:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238277AbiBTNso (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 08:48:44 -0500
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62CA62D1DD;
        Sun, 20 Feb 2022 05:48:23 -0800 (PST)
Received: by mail-pj1-x1041.google.com with SMTP id q8-20020a17090a178800b001bc299b8de1so1167396pja.1;
        Sun, 20 Feb 2022 05:48:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tScrAsZNPZ4z7UHmft7Hv1gjRNBu/0AWO2o1jJpasDE=;
        b=SDbmL2q4GpAxfF5DdIY7SiWIrev11XaxkZ2hhzmM44JQrnAspiKVZI1rqtfWyJLk3B
         kny6ghEkJPYQo7c2iiVvlNj9HdHsFwsOTmeCZ0+i7WlryJCn4M4nUq6tb5UxziMmY/3y
         4OlRMyGVV9li9DS2lIjiM26Okf3FrBgbFTVjkdNC+x/5sLxCHvVZwCJLHsvS8pVeqyO4
         UY47TOYrUGm8rACpEirj4pFW8Zl+2mcD/hEeIquJGfZo1a6Nl1jizGEI3Ot+glF6C2v0
         l1SXSlnjiPllANtinj6Gsf0EX2PqY6GP13GzAPOocroK+sPjgvAMZX2LBN+JUzqu4wCd
         eFqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tScrAsZNPZ4z7UHmft7Hv1gjRNBu/0AWO2o1jJpasDE=;
        b=h7mmwttjPv64ltlpH9WVphtSY4PurK/lgMy0hPzQ70hMvvBV8+Y6GMJDYvPtB0OCpG
         FnxhdCoDUO3xLm7/pS/6jPoNiCEJJfphwSRBkq2gS0WQ7bkeO724L+XlqDdBYaB3e1W2
         zpagA5niz6kPBh8oWjPRjHpWp8jMdXc/kyl3w6jrUNYgZ8867hOzlk3gZXbm3B987su9
         +V8l4R2Bd4Z+ra5PzREhcyaY0IdQmjWMF6bnD1o/CfghFxz7fHdnlqu1Sv83st82YQxk
         6uILUPvK2CYJZvtU5DLtOkcekiorlAXYCGUSYyPKsn2JxyZGPJTyARdDV4VZ2gThqQ+H
         7gIQ==
X-Gm-Message-State: AOAM5316t/M+Gc3vlKXPDBRw72sbrhD3zQMbY2T6e7MpUGXd45zMVKfK
        vTY4/3NcUpEeNmWn8mwfjYH2os8Ja0o=
X-Google-Smtp-Source: ABdhPJyWrN+KgyPgY+jZViH70EO8u5MlWSZ2EFYQ6PgYwobuq+3rVGdHHO9BHuoSzZHIC+2qKr/sjQ==
X-Received: by 2002:a17:902:db04:b0:14c:f43b:e9df with SMTP id m4-20020a170902db0400b0014cf43be9dfmr15305668plx.76.1645364902676;
        Sun, 20 Feb 2022 05:48:22 -0800 (PST)
Received: from localhost ([2405:201:6014:d0c0:6243:316e:a9e1:adda])
        by smtp.gmail.com with ESMTPSA id m19sm5989212pfk.15.2022.02.20.05.48.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Feb 2022 05:48:22 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH bpf-next v1 02/15] bpf: Make btf_find_field more generic
Date:   Sun, 20 Feb 2022 19:18:00 +0530
Message-Id: <20220220134813.3411982-3-memxor@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220220134813.3411982-1-memxor@gmail.com>
References: <20220220134813.3411982-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6216; h=from:subject; bh=0qXHd1TkFCU1UpyfBjDxPH7u7vulr4FC18+1Eom8vyo=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBiEkZXmmZlmlAH5SDX0rZCSizYI+2cvUqtVhJkOtm5 RJe0VeOJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYhJGVwAKCRBM4MiGSL8RyvF9D/ 0cU6szyBxLtBnTLArn5FKK5r1zQGJ2pWsJpfFiCtz52oSl+3mn1TWRs5wjqrFfuhUOCClT4OZ9nNr4 RzMkaC69RiTgU4X7noxj11dWpmzmmrl56hb2IlTwX49nBFpyVQje4Ms0F8XRsSVGwRjOdalk9jWYbu S1un+SOCf0xPj3MlOcOoMncP52waHh7OC2gdWv7mK7vNYjj827VvS0Cr8npPoSVvizTA02IcBNbFBY so6VtrxEGo+Mw6JNCpH1h+w/PPZgDEkzEMcoiQ5R4IZYkxO7FsDhXgh8G7tFRy21SUHaqLfIduL2aK aw/OF7pdWrpl8EHrVi97E5bHefdZP3XUHYWlJD5RnQtkAz06uB2cpLJpu9l0RzcWcUGxOTHd73bBjl F9+6xQTNPsiqEKdLu9lOPbr6IjruggtI8+9HwS6Fl/rkV6ZJ1Prm4rNyrbbuGqUnG8irARx2vNcATX yiyOv+GBvt7G6kHfRtvu/0d4HM89VkACWaZq9QbYf7T1ZmMKkuas+fFLHqsD0Dggr8nlRcnKTMT55E v1TrEpwbXOFgMeYrjkJJDub975c1A2RL0QFNK+1Hk0RkY2vvmIyVWbj86cDtLNo44CtWMgdNnPmdjL sk3qq7A3aZq30R9Ww16TXxHuH8Byqv6OLA8CDC0LztdRMP9St6HrRGAAvJBg==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Next commit's field type will not be struct, but pointer, and it will
not be limited to one offset, but multiple ones. Make existing
btf_find_struct_field and btf_find_datasec_var functions amenable to use
for finding BTF ID pointers in map value, by taking a moving spin_lock
and timer specific checks into their own function.

The alignment, and name are checked before the function is called, so it
is the last point where we can skip field or return an error before the
next loop iteration happens. This is important, because we'll be
potentially reallocating memory inside this function in next commit, so
being able to do that when everything else is in order is going to be
more convenient.

The name parameter is now optional, and only checked if it is not NULL.

The size must be checked in the function, because in case of PTR it will
instead point to the underlying BTF ID it is pointing to (or modifiers),
so the check becomes wrong to do outside of function, and the base type
has to be obtained by removing modifiers.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 kernel/bpf/btf.c | 119 +++++++++++++++++++++++++++++++++--------------
 1 file changed, 85 insertions(+), 34 deletions(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 3645d8c14a18..55f6ccac3388 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3119,71 +3119,108 @@ static void btf_struct_log(struct btf_verifier_env *env,
 	btf_verifier_log(env, "size=%u vlen=%u", t->size, btf_type_vlen(t));
 }
 
+enum {
+	BTF_FIELD_SPIN_LOCK,
+	BTF_FIELD_TIMER,
+};
+
+static int btf_find_field_struct(const struct btf *btf, const struct btf_type *t,
+				 u32 off, int sz, void *data)
+{
+	u32 *offp = data;
+
+	if (!__btf_type_is_struct(t))
+		return 0;
+	if (t->size != sz)
+		return 0;
+	if (*offp != -ENOENT)
+		/* only one such field is allowed */
+		return -E2BIG;
+	*offp = off;
+	return 0;
+}
+
 static int btf_find_struct_field(const struct btf *btf, const struct btf_type *t,
-				 const char *name, int sz, int align)
+				 const char *name, int sz, int align, int field_type,
+				 void *data)
 {
 	const struct btf_member *member;
-	u32 i, off = -ENOENT;
+	u32 i, off;
+	int ret;
 
 	for_each_member(i, t, member) {
 		const struct btf_type *member_type = btf_type_by_id(btf,
 								    member->type);
-		if (!__btf_type_is_struct(member_type))
-			continue;
-		if (member_type->size != sz)
-			continue;
-		if (strcmp(__btf_name_by_offset(btf, member_type->name_off), name))
-			continue;
-		if (off != -ENOENT)
-			/* only one such field is allowed */
-			return -E2BIG;
+
 		off = __btf_member_bit_offset(t, member);
+
+		if (name && strcmp(__btf_name_by_offset(btf, member_type->name_off), name))
+			continue;
 		if (off % 8)
 			/* valid C code cannot generate such BTF */
 			return -EINVAL;
 		off /= 8;
 		if (off % align)
 			return -EINVAL;
+
+		switch (field_type) {
+		case BTF_FIELD_SPIN_LOCK:
+		case BTF_FIELD_TIMER:
+			ret = btf_find_field_struct(btf, member_type, off, sz, data);
+			if (ret < 0)
+				return ret;
+			break;
+		default:
+			pr_err("verifier bug: unknown field type requested\n");
+			return -EFAULT;
+		}
 	}
-	return off;
+	return 0;
 }
 
 static int btf_find_datasec_var(const struct btf *btf, const struct btf_type *t,
-				const char *name, int sz, int align)
+				const char *name, int sz, int align, int field_type,
+				void *data)
 {
 	const struct btf_var_secinfo *vsi;
-	u32 i, off = -ENOENT;
+	u32 i, off;
+	int ret;
 
 	for_each_vsi(i, t, vsi) {
 		const struct btf_type *var = btf_type_by_id(btf, vsi->type);
 		const struct btf_type *var_type = btf_type_by_id(btf, var->type);
 
-		if (!__btf_type_is_struct(var_type))
-			continue;
-		if (var_type->size != sz)
+		off = vsi->offset;
+
+		if (name && strcmp(__btf_name_by_offset(btf, var_type->name_off), name))
 			continue;
 		if (vsi->size != sz)
 			continue;
-		if (strcmp(__btf_name_by_offset(btf, var_type->name_off), name))
-			continue;
-		if (off != -ENOENT)
-			/* only one such field is allowed */
-			return -E2BIG;
-		off = vsi->offset;
 		if (off % align)
 			return -EINVAL;
+
+		switch (field_type) {
+		case BTF_FIELD_SPIN_LOCK:
+		case BTF_FIELD_TIMER:
+			ret = btf_find_field_struct(btf, var_type, off, sz, data);
+			if (ret < 0)
+				return ret;
+			break;
+		default:
+			return -EFAULT;
+		}
 	}
-	return off;
+	return 0;
 }
 
 static int btf_find_field(const struct btf *btf, const struct btf_type *t,
-			  const char *name, int sz, int align)
+			  const char *name, int sz, int align, int field_type,
+			  void *data)
 {
-
 	if (__btf_type_is_struct(t))
-		return btf_find_struct_field(btf, t, name, sz, align);
+		return btf_find_struct_field(btf, t, name, sz, align, field_type, data);
 	else if (btf_type_is_datasec(t))
-		return btf_find_datasec_var(btf, t, name, sz, align);
+		return btf_find_datasec_var(btf, t, name, sz, align, field_type, data);
 	return -EINVAL;
 }
 
@@ -3193,16 +3230,30 @@ static int btf_find_field(const struct btf *btf, const struct btf_type *t,
  */
 int btf_find_spin_lock(const struct btf *btf, const struct btf_type *t)
 {
-	return btf_find_field(btf, t, "bpf_spin_lock",
-			      sizeof(struct bpf_spin_lock),
-			      __alignof__(struct bpf_spin_lock));
+	u32 off = -ENOENT;
+	int ret;
+
+	ret = btf_find_field(btf, t, "bpf_spin_lock",
+			     sizeof(struct bpf_spin_lock),
+			     __alignof__(struct bpf_spin_lock),
+			     BTF_FIELD_SPIN_LOCK, &off);
+	if (ret < 0)
+		return ret;
+	return off;
 }
 
 int btf_find_timer(const struct btf *btf, const struct btf_type *t)
 {
-	return btf_find_field(btf, t, "bpf_timer",
-			      sizeof(struct bpf_timer),
-			      __alignof__(struct bpf_timer));
+	u32 off = -ENOENT;
+	int ret;
+
+	ret = btf_find_field(btf, t, "bpf_timer",
+			     sizeof(struct bpf_timer),
+			     __alignof__(struct bpf_timer),
+			     BTF_FIELD_TIMER, &off);
+	if (ret < 0)
+		return ret;
+	return off;
 }
 
 static void __btf_struct_show(const struct btf *btf, const struct btf_type *t,
-- 
2.35.1

