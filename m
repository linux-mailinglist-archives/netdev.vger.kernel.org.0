Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 035744BCED7
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 14:56:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243880AbiBTNtA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 08:49:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243842AbiBTNs4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 08:48:56 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB4632DA86;
        Sun, 20 Feb 2022 05:48:35 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id v13-20020a17090ac90d00b001b87bc106bdso16509985pjt.4;
        Sun, 20 Feb 2022 05:48:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=R9d2PpgqfauFJJjkRlCvvbMhZKsS/YVJK4MsuC6I8N0=;
        b=ZCI/j3azJWDM65HsBnnX5qjBvmN0fLz4r3rWoOOvlhaZlxSiIa4d6LL18ZyZ9BUvWJ
         sNuDIyu/FQ2KFfNoqMD3COslhcDYLuseRUGe29OnmnQDHRb+Lv1MCupgsVlS1y7tyroX
         SdZw/Ic+NVb25iquYB9hWE5sWwq6TqRPmRNAE9ET1mYB2CobJ/k4wZlcmxhd0KwiHcc4
         bxMmKt+DCWjpGgJ0QiLEehiUY3MIGRptYFH13N19hh3exIt/IdyNTT/mk1a69E5KCFGp
         JQf0rHLbJeUa5xw8E8VGxMRRcSnkruhu5IsChufUteRQz4v58cYKhMbtGj+MQrUbSV8k
         o65A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R9d2PpgqfauFJJjkRlCvvbMhZKsS/YVJK4MsuC6I8N0=;
        b=iu/WO2H/VdhBjtzmvTx2PfxRO+N6ma7FrkZ2PZTxtPOCnOWAqP0kEYJcAXxQ11wNEC
         xo9yrXQCCLWdBO1FCYDP497PN9V30YTGND/OSMeKfFKEjVNN/1uSTiEbC5CZt6AV9DwD
         iaSK7yPaGX5MjNHKq0KU0ZwtgwWqrjBbUkrxJPlqfPX7uKyEDYmnJJyeuYNi7s5z3wwN
         7kgICabZTUixymgkThfIuvthiR9ztOyEuy0FfuuMVqSOxtp2SRabzBjHi4PcfvZaRFJo
         5ZGLTOWpMSlq/0rBHTjtXNu8B5HDn2hzG230Yv2tqsm4i/ndYtlA6OFUgJ6hd3Hf0n/6
         D8gA==
X-Gm-Message-State: AOAM531SJdOyDKcfVEMydHjx9Eamr5eJbNSyh2djY1fjFMYAWU91Ta0T
        zzjPeKSK7kKgq+Etxt6AzaDGCfQAg44=
X-Google-Smtp-Source: ABdhPJxOUHncv9ivzRcctx7PwuFM8hfyviiF0JS2hla6Xnku9b8LAM4SGV7HqV9S2tKeJ/vAHBYa5A==
X-Received: by 2002:a17:90b:1d91:b0:1b9:d5fd:3c8a with SMTP id pf17-20020a17090b1d9100b001b9d5fd3c8amr21440556pjb.213.1645364915014;
        Sun, 20 Feb 2022 05:48:35 -0800 (PST)
Received: from localhost ([2405:201:6014:d0c0:6243:316e:a9e1:adda])
        by smtp.gmail.com with ESMTPSA id a14sm9759980pfv.51.2022.02.20.05.48.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Feb 2022 05:48:34 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH bpf-next v1 06/15] bpf: Allow storing __user PTR_TO_BTF_ID in map
Date:   Sun, 20 Feb 2022 19:18:04 +0530
Message-Id: <20220220134813.3411982-7-memxor@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220220134813.3411982-1-memxor@gmail.com>
References: <20220220134813.3411982-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6532; h=from:subject; bh=d2wogHsh3SI7Hcu5QYrntWdvoEgeiQvZgIP9xtiBwrU=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBiEkZX4+2EeGW6HzIGTAy16zwZeMmxnmOUgj8rPFSB XCIy18+JAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYhJGVwAKCRBM4MiGSL8RynZZD/ 9DamE0brQ9+dzNmjcWrKPFl74LTgMQmypmdL5a5h0Glp5IlpIdZzWAYRMLzu32bV+uZINvn2y/fP90 ow2oOGbdH1spM9LBxoe4nFsI3BXEkbR0tPkktKgO0QI+OWWB0/ERfP0FI2B/xyQxZ8shaFHuU1JrKK thXBIPHatBhwgcnDm2OfrqFbsou/QtyfaOyJDEUwb53dLlf4INVAsXqpoGumZ2F/8GH2C/LAcN/YYq GW/RU8lj6R6LOk1yvctU/WRxysocKtWV3lAXlfr2vUDEiA0xZwkz2bvI/PjBXMah488Jzoz63zDY5g MwDLIFvmJZmP5hZ74+TL0+/0Un8sg0lud4Rge2N96lIauHxZZ9j6+f86sV92F51LSOVEjfe36svkFb L5omNfGG7oco5defkgtwLq/pxzoFW7OyQQc6xyQdMt2hdoQEkrnOp4GTWNI5li8mpulIAhHe/Pajrx VLEoB6LSRlCuIDa+WA9hqZeyldK8r07szvaz5EpAMKrwtI8cD46YmhZOkHxMBOB5Fp4egNA/Tc/waF NuqddaD9Zpel39uelWch8LaCcZ/p8ErbWUcL+euZPWhgmyvIv0U4bKgBF3vLpwfs49GJAyIhES8QBB dpmcAc2hwdlbeXIRcYQ2qNZ+cJBv8uVmUNa2nQcLUedl0F4XJIKSlL7Xrunw==
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

Recently, verifier gained __user annotation support [0] where it
prevents BPF program from normally derefering user memory pointer in the
kernel, and instead requires use of bpf_probe_read_user. We can allow
the user to also store these pointers in BPF maps, with the logic that
whenever user loads it from the BPF map, it gets marked as MEM_USER.

  [0]: https://lore.kernel.org/bpf/20220127154555.650886-1-yhs@fb.com

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/linux/bpf.h   |  1 +
 kernel/bpf/btf.c      | 20 +++++++++++++++-----
 kernel/bpf/verifier.c | 21 +++++++++++++++------
 3 files changed, 31 insertions(+), 11 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 843c8c01cf9d..37ca92f4c7b7 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -163,6 +163,7 @@ enum {
 enum {
 	BPF_MAP_VALUE_OFF_F_REF    = (1U << 0),
 	BPF_MAP_VALUE_OFF_F_PERCPU = (1U << 1),
+	BPF_MAP_VALUE_OFF_F_USER   = (1U << 2),
 };
 
 struct bpf_map_value_off_desc {
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index eb57584ee0a8..bafceae90c32 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3146,7 +3146,7 @@ static s32 btf_find_by_name_kind_all(const char *name, u32 kind, struct btf **bt
 static int btf_find_field_kptr(const struct btf *btf, const struct btf_type *t,
 			       u32 off, int sz, void *data)
 {
-	bool btf_id_tag = false, ref_tag = false, percpu_tag = false;
+	bool btf_id_tag = false, ref_tag = false, percpu_tag = false, user_tag = false;
 	struct bpf_map_value_off *tab;
 	struct bpf_map *map = data;
 	int nr_off, ret, flags = 0;
@@ -3181,6 +3181,13 @@ static int btf_find_field_kptr(const struct btf *btf, const struct btf_type *t,
 				goto end;
 			}
 			percpu_tag = true;
+		} else if (!strcmp("kernel.bpf.user", __btf_name_by_offset(btf, t->name_off))) {
+			/* repeated tag */
+			if (user_tag) {
+				ret = -EINVAL;
+				goto end;
+			}
+			user_tag = true;
 		} else if (!strncmp("kernel.", __btf_name_by_offset(btf, t->name_off),
 			   sizeof("kernel.") - 1)) {
 			/* TODO: Should we reject these when loading BTF? */
@@ -3192,15 +3199,16 @@ static int btf_find_field_kptr(const struct btf *btf, const struct btf_type *t,
 		t = btf_type_by_id(btf, t->type);
 	}
 	if (!btf_id_tag) {
-		/* 'ref' or 'percpu' tag must be specified together with 'btf_id' tag */
-		if (ref_tag || percpu_tag) {
+		/* 'ref', 'percpu', 'user' tag must be specified together with 'btf_id' tag */
+		if (ref_tag || percpu_tag || user_tag) {
 			ret = -EINVAL;
 			goto end;
 		}
 		return 0;
 	}
-	/* referenced percpu btf_id pointer is not yet supported */
-	if (ref_tag && percpu_tag) {
+	/* All three are mutually exclusive */
+	ret = ref_tag + percpu_tag + user_tag;
+	if (ret > 1) {
 		ret = -EINVAL;
 		goto end;
 	}
@@ -3257,6 +3265,8 @@ static int btf_find_field_kptr(const struct btf *btf, const struct btf_type *t,
 		flags |= BPF_MAP_VALUE_OFF_F_REF;
 	else if (percpu_tag)
 		flags |= BPF_MAP_VALUE_OFF_F_PERCPU;
+	else if (user_tag)
+		flags |= BPF_MAP_VALUE_OFF_F_USER;
 
 	tab->off[nr_off].offset = off;
 	tab->off[nr_off].btf_id = id;
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 00d6ab49033d..28da858bb921 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3482,7 +3482,11 @@ static int map_ptr_to_btf_id_match_type(struct bpf_verifier_env *env,
 	enum bpf_reg_type reg_type;
 	const char *reg_name = "";
 
-	if (off_desc->flags & BPF_MAP_VALUE_OFF_F_PERCPU) {
+	if (off_desc->flags & BPF_MAP_VALUE_OFF_F_USER) {
+		if (reg->type != (PTR_TO_BTF_ID | MEM_USER) &&
+		    reg->type != (PTR_TO_BTF_ID | PTR_MAYBE_NULL | MEM_USER))
+			goto end;
+	} else if (off_desc->flags & BPF_MAP_VALUE_OFF_F_PERCPU) {
 		if (reg->type != PTR_TO_PERCPU_BTF_ID &&
 		    reg->type != (PTR_TO_PERCPU_BTF_ID | PTR_MAYBE_NULL))
 			goto end;
@@ -3536,7 +3540,9 @@ static int map_ptr_to_btf_id_match_type(struct bpf_verifier_env *env,
 
 	return 0;
 end:
-	if (off_desc->flags & BPF_MAP_VALUE_OFF_F_PERCPU)
+	if (off_desc->flags & BPF_MAP_VALUE_OFF_F_USER)
+		reg_type = PTR_TO_BTF_ID | PTR_MAYBE_NULL | MEM_USER;
+	else if (off_desc->flags & BPF_MAP_VALUE_OFF_F_PERCPU)
 		reg_type = PTR_TO_PERCPU_BTF_ID | PTR_MAYBE_NULL;
 	else
 		reg_type = PTR_TO_BTF_ID | PTR_MAYBE_NULL;
@@ -3556,14 +3562,14 @@ static int check_map_ptr_to_btf_id(struct bpf_verifier_env *env, u32 regno, int
 				   struct bpf_reg_state *atomic_load_reg)
 {
 	struct bpf_reg_state *reg = reg_state(env, regno), *val_reg;
+	bool ref_ptr = false, percpu_ptr = false, user_ptr = false;
 	struct bpf_insn *insn = &env->prog->insnsi[insn_idx];
 	enum bpf_reg_type reg_type = PTR_TO_BTF_ID;
-	bool ref_ptr = false, percpu_ptr = false;
 	struct bpf_map_value_off_desc *off_desc;
 	int insn_class = BPF_CLASS(insn->code);
+	int ret, reg_flags = PTR_MAYBE_NULL;
 	struct bpf_map *map = reg->map_ptr;
 	u32 ref_obj_id = 0;
-	int ret;
 
 	/* Things we already checked for in check_map_access:
 	 *  - Reject cases where variable offset may touch BTF ID pointer
@@ -3590,8 +3596,11 @@ static int check_map_ptr_to_btf_id(struct bpf_verifier_env *env, u32 regno, int
 
 	ref_ptr = off_desc->flags & BPF_MAP_VALUE_OFF_F_REF;
 	percpu_ptr = off_desc->flags & BPF_MAP_VALUE_OFF_F_PERCPU;
+	user_ptr = off_desc->flags & BPF_MAP_VALUE_OFF_F_USER;
 	if (percpu_ptr)
 		reg_type = PTR_TO_PERCPU_BTF_ID;
+	else if (user_ptr)
+		reg_flags |= MEM_USER;
 
 	if (is_xchg_insn(insn)) {
 		/* We do checks and updates during register fill call for fetch case */
@@ -3623,7 +3632,7 @@ static int check_map_ptr_to_btf_id(struct bpf_verifier_env *env, u32 regno, int
 		}
 		/* val_reg might be NULL at this point */
 		mark_btf_ld_reg(env, cur_regs(env), value_regno, reg_type, off_desc->btf,
-				off_desc->btf_id, PTR_MAYBE_NULL);
+				off_desc->btf_id, reg_flags);
 		/* __mark_ptr_or_null_regs needs ref_obj_id == id to clear
 		 * reference state for ptr == NULL branch.
 		 */
@@ -3641,7 +3650,7 @@ static int check_map_ptr_to_btf_id(struct bpf_verifier_env *env, u32 regno, int
 		 * value from map as PTR_TO_BTF_ID, with the correct type.
 		 */
 		mark_btf_ld_reg(env, cur_regs(env), value_regno, reg_type, off_desc->btf,
-				off_desc->btf_id, PTR_MAYBE_NULL);
+				off_desc->btf_id, reg_flags);
 		val_reg->id = ++env->id_gen;
 	} else if (insn_class == BPF_STX) {
 		if (WARN_ON_ONCE(value_regno < 0))
-- 
2.35.1

