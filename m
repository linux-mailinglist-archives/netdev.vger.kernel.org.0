Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA6CF4CEEAB
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 00:43:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234455AbiCFXoQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 18:44:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234465AbiCFXoL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 18:44:11 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EA243FBF6;
        Sun,  6 Mar 2022 15:43:18 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id n15so2303905plh.2;
        Sun, 06 Mar 2022 15:43:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VwHdyYnuRcRXYNFmqabJL9282iWYdbjzM/YzBvIZOfw=;
        b=FtabHTT7QlroIUf2e3cAIpypNvHpmjUDgNGcIr34R+uTczAO0l6rFhlp1CJP5R2SET
         oFgP3nvv2edWIdVI4mSH0+HL4QED/oVyUHzkkPGO3NLVqjGx2zbgb2fw+48iiQN5tWy0
         CheDnblejxQUhs0kri34MLyhX0FKliODSFBF22R+TRIDaKcpta9RR2cJfAon7IoiUpm8
         +PhsJhNGhpwT3xz4q4w5vRk5V81UhF9UfYW+p/54Hd8V0sVh2ElOQgJzeI+dC3jq3y0r
         U1BLyFuZ4B9lpxmAgB6jQu0SYrtlvxQwvwEiGXlqVoTFDwHGA7JbLRqbCsn5My9U0Zej
         nQjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VwHdyYnuRcRXYNFmqabJL9282iWYdbjzM/YzBvIZOfw=;
        b=PFxrmO6Z+o6g7/q4iV5E+SM3ueGZahIcYMeFPbB+GJLT2lORBz95pXKtjxXtgFilck
         E0Enkq0+EblVbf5Ae/MNHOi/I4iq6bGgPV/oqsSDJPQwT6f0oq37/WuXeUj6szKofExc
         2cwDaFlKW2ViX6s71Yq8hkLVqsdmfw6ACFMz5ak6Il8PcH36gFvfCeqsv7KOB3SXBhoF
         gpWk+WxnN4R771q07kbJ3k2PRU9BNPV/JSx8OZwW7Eqb6NfltCFrS1xRwQwNUZDIP2eU
         U7VbaFVjx2lhouirn+SDq2MbOTgSaPQZeF4txDbSRk0+z2GaOjmzsq0w++P3fRGrzp+t
         p1Pw==
X-Gm-Message-State: AOAM5316DUOnQf+en5Lr6IALEyLSP+o2ZAC8xHs/2kRq+hnBAwJ49r9x
        RYSDnXdWLkOi6HgCNshoNvf/xpR/PRc=
X-Google-Smtp-Source: ABdhPJzPCnm135JRRlwfFwUmQVnOXL1DEKfhj/f9eRGrrELkTyhO91A9aQZEFEIXAndIgxAtlw/Ayw==
X-Received: by 2002:a17:90b:3b45:b0:1bf:275d:e3a6 with SMTP id ot5-20020a17090b3b4500b001bf275de3a6mr14685131pjb.157.1646610197821;
        Sun, 06 Mar 2022 15:43:17 -0800 (PST)
Received: from localhost ([2405:201:6014:d0c0:6243:316e:a9e1:adda])
        by smtp.gmail.com with ESMTPSA id c5-20020a056a00248500b004f6b5ddcc65sm10220143pfv.199.2022.03.06.15.43.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Mar 2022 15:43:17 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Lorenz Bauer <linux@lmb.io>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v1 1/5] bpf: Add ARG_SCALAR and ARG_CONSTANT
Date:   Mon,  7 Mar 2022 05:13:07 +0530
Message-Id: <20220306234311.452206-2-memxor@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220306234311.452206-1-memxor@gmail.com>
References: <20220306234311.452206-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2592; h=from:subject; bh=+UTutSV7e6MxZzmPcWPn5d4JDQXC+kDPpa78cbCfs90=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBiJUWooddDSYApqqx1ZGBQrmGShyR+BarlGZJnYKCC //Ag5mGJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYiVFqAAKCRBM4MiGSL8RykqYD/ wPBgtBobik/QPvn9vUOCRnvGj+dc2qegy9RqXUXytJfvas6L3x2cp3z3FJuOxOEQggZ+QGixxahs2d FxUu62ECQGNw8hRUyAo93+T8sROPKpatnD1YjWyuAsvaaqio80KyvMoQKyaK4+5hjvQ1nhGHPE9h81 TIN/orECOFXw5OZTUKo5UUm1mcXfxxvpbNEbETJu7cHb3HHGrrFPBaOwgKEvNM3iA+fJo81mbuOdyu ga61FT7ttIJxB/dxsLcASQx/Hl7GMP/veqh9FkSYCJWtozIQg2nWg6nFwoMYHaLN/1Cg6u2Uts8zJf vBH5e16DrPaY1WT2km5N8dVgkqUa6+bmqVYls8NoJfjkNI7h3QngoOkQTLjiHzWoU60RpzPTJjOO+C e6RnpozaLOq0boHnzFcFCaEh8U45OTlREMBsJq9lRbKQFykdWVE1Ba0UVZrabyMPVoKmkkLGGnWwi/ 9VPfqo9JoL68D1c5mLEDtrk5iFRgyQnRVtMD88whW8tw+rCHsJun0lWDsEoIlQDgTZ8KX5M/W+fTK/ S/K5RqCw/trezMuptmk2ZZDea6Jgc1bnnVp+j2rKkilppB1WnbmgZSR+ozlzrJR3GEGCVokKrjel3c lHUKjq1ckBaC+zo6Rp2CF/mFpLggcrZBZUXDZxRJSuQiyiqchkq8qnxoANYg==
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

In the next patch, we will introduce a new helper 'bpf_packet_pointer'
that takes offset and len and returns a packet pointer. There we want to
statically enforce offset is in range [0, 0xffff], and that len is a
constant value, in range [1, 0xffff]. This also helps us avoid a
pointless runtime check. To make these checks possible, we need to
ensure we only get a scalar type. Although a lot of other argument types
take scalars, their intent is different. Hence add general ARG_SCALAR
and ARG_CONSTANT types, where the latter is also checked to be constant
in addition to being scalar.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/linux/bpf.h   |  2 ++
 kernel/bpf/verifier.c | 13 +++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 88449fbbe063..7841d90b83df 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -391,6 +391,8 @@ enum bpf_arg_type {
 	ARG_PTR_TO_STACK,	/* pointer to stack */
 	ARG_PTR_TO_CONST_STR,	/* pointer to a null terminated read-only string */
 	ARG_PTR_TO_TIMER,	/* pointer to bpf_timer */
+	ARG_SCALAR,		/* a scalar with any value(s) */
+	ARG_CONSTANT,		/* a scalar with constant value */
 	__BPF_ARG_TYPE_MAX,
 
 	/* Extended arg_types. */
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index ec3a7b6c9515..0373d5bd240f 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5163,6 +5163,12 @@ static bool arg_type_is_int_ptr(enum bpf_arg_type type)
 	       type == ARG_PTR_TO_LONG;
 }
 
+static bool arg_type_is_scalar(enum bpf_arg_type type)
+{
+	return type == ARG_SCALAR ||
+	       type == ARG_CONSTANT;
+}
+
 static int int_ptr_type_to_size(enum bpf_arg_type type)
 {
 	if (type == ARG_PTR_TO_INT)
@@ -5302,6 +5308,8 @@ static const struct bpf_reg_types *compatible_reg_types[__BPF_ARG_TYPE_MAX] = {
 	[ARG_PTR_TO_STACK]		= &stack_ptr_types,
 	[ARG_PTR_TO_CONST_STR]		= &const_str_ptr_types,
 	[ARG_PTR_TO_TIMER]		= &timer_types,
+	[ARG_SCALAR]			= &scalar_types,
+	[ARG_CONSTANT]			= &scalar_types,
 };
 
 static int check_reg_type(struct bpf_verifier_env *env, u32 regno,
@@ -5635,6 +5643,11 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 			verbose(env, "string is not zero-terminated\n");
 			return -EINVAL;
 		}
+	} else if (arg_type_is_scalar(arg_type)) {
+		if (arg_type == ARG_CONSTANT && !tnum_is_const(reg->var_off)) {
+			verbose(env, "R%d is not a known constant\n", regno);
+			return -EACCES;
+		}
 	}
 
 	return err;
-- 
2.35.1

