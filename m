Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B82D40ADE9
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 14:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232888AbhINMjW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 08:39:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232898AbhINMjV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 08:39:21 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9127C061574;
        Tue, 14 Sep 2021 05:38:03 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id 5so8090646plo.5;
        Tue, 14 Sep 2021 05:38:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8H2t4nrL6OKI1S9DG0MWY1o7DOImDjh2AQh5r73KfwE=;
        b=HSSkXn9E/xjh7qvVIHKvBqT9uHQd/tWBsDzMUuyKyO3jtlr8qVf2MZzZXJ5JKHY7Vt
         Uy4tKOpvsr0ZRqnv0HpQh7KaH/dnlXQIeEsqNUmQHDMx20yaYXlUBiPV5QO6qMFWIYeV
         Re+7WggvdBKONFLMuk+MF7iEZ9CbpDEpG6TuahgqYRw/BWszvfuLrQ1LafqHhWU/Ee+k
         3o20Eln8VKH+/3jkHPQdbKb94tGhv69cI70tF70jzzn1taf04e0dV8qcV9BkqpBQ5C0u
         8MCVPMFGkFT/K3/uIFZycAF/EJjZ7vTwpjEcJvE7lkRDn1IgT4Y8uJ9Braj3F2RLpIMY
         Ni1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8H2t4nrL6OKI1S9DG0MWY1o7DOImDjh2AQh5r73KfwE=;
        b=eNkG3PVq0IyaJyCVNAcJzdehvhLY6GVm8N6uNNFCBY1Gbm0SS63Rt0deiMSXccaoR5
         10gXokIjuUOWsLkcMc9UjfeshfPOV1+YrosqgHZDZ0RYoZ08wujGc0Jkxv9uum3uk5aH
         VuMU65IUWVDRGX/oXIslt5UQgnxytiUYZkYeYReD1wqK7TWFRg+qOozagsySZTi5glnU
         e5VJ+TgVfhmqYicVLon7bARpzPvMR1JcKBOM1CzLHRtTWy9r5Bl5w03EwYlk8ET3ib+C
         ZtHw5xQr76Ib5Es/ZbRPy/JUS70CDM+0AfVKtiT0wMbII2C8aWuUpomY7oHhjw2IxToq
         JmqQ==
X-Gm-Message-State: AOAM5307Pn6gpUGk86MV9M2yFYdzMpnr28FAwf/dQq8LdeL6HoWCK0xB
        cDd7ghfm6sKSSFw2mjlHu8Lwnm7+MpY3HQ==
X-Google-Smtp-Source: ABdhPJw9XmePtM+qL5wus8UU1NXXk34eNWX701/q+n8eJowfw55o4wMlGJlmYS4hWcAA3bB1T9ZQpg==
X-Received: by 2002:a17:90b:46cd:: with SMTP id jx13mr1870661pjb.122.1631623083263;
        Tue, 14 Sep 2021 05:38:03 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id cm5sm1738453pjb.24.2021.09.14.05.38.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 05:38:03 -0700 (PDT)
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
Subject: [PATCH bpf-next v2 02/10] bpf: Be conservative while processing invalid kfunc calls
Date:   Tue, 14 Sep 2021 18:07:41 +0530
Message-Id: <20210914123750.460750-3-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210914123750.460750-1-memxor@gmail.com>
References: <20210914123750.460750-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2253; h=from:subject; bh=KwrtasYlogJBoIL6nFroYhICQdUm8Kr8EgPEOr5ZFWY=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhQJdWIlzQb2Ml0Ubt+UAOvxa6xmTwJ5H8mn5f8ZNS wCNP8PyJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYUCXVgAKCRBM4MiGSL8RyoDeD/ 9fkForr9OuFOwjsaguAQOmYPqm1GiSyGvBWc99FqQoCDLL4WNyFF/7TFkQZOK+8p8nnZSJhaWSu+Ga E2BwwQbCEytEck+XVoyrB48NlyGe+xm2O3NgcruIPcVO0ZKzMYPcW5LzMUy4spQ6tImVd2lme+ilW5 bzMU0J3Gmsg6Csutkmb70bB/Em9Do7ML0hUw4FKmHcgor71qwqVCKywkIp2PkR4FuDmJf8p4V8MN9P ZhDIFM9CWSfm5V6MW0mIDoqqW8J6wHvMMFZl5Uy0QnMPrjrK3lS0bUAVhb8ZeR+rl+bfUd8BuRSU4V L2O2mPX+AuccMUBwaJopAuaWN6jlmGczTgeBjRg5jdcXNf7HWSK8MFExTGYtznj83yLerdPIQvvqUk RH6IOsCZ/7zaJmm8Uu5Aj9JFmKnwYJaOwv0o0Hd5O+vuBSK4fQKR+7y2xrq0Y8KCl0pQo2WEY3ho6Z nOoPGYyhg9Ub9fAtezXZ5sOexOvopKsa/h9vof5VFtw30uC9fZ+z6wxZPvLhTrYyjdGRH6N7oXjJD5 CLGy5Ll5brlY4s/2N9jjzObcudrZHPD0CFFaHvfx3NSb9dH7nJUCvH9j4GOcZSoP/fv5EW9R/i/hgD 2NMfXQmL0tkJLg4QLHeyfPb4Tmr+2nEYGtzI1fGm2HpJ4oSuPKLunbIBhWzw==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch also modifies the BPF verifier to only return error for
invalid kfunc calls specially marked by userspace (with insn->imm == 0,
insn->off == 0) after the verifier has eliminated dead instructions.
This can be handled in the fixup stage, and skip processing during add
and check stages.

If such an invalid call is dropped, the fixup stage will not encounter
insn->imm as 0, otherwise it bails out and returns an error.

This will be exposed as weak ksym support in libbpf in subsequent patch.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 kernel/bpf/verifier.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 6bbbb98f4ee2..7dd2a632ea6f 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1815,6 +1815,15 @@ static int add_kfunc_call(struct bpf_verifier_env *env, u32 func_id, s16 offset)
 		prog_aux->kfunc_tab = tab;
 	}
 
+	/* btf idr allocates IDs from 1, so func_id == 0 is always invalid, but
+	 * instead of returning an error, be conservative and wait until the
+	 * code elimination pass before returning error, so that invalid calls
+	 * that get pruned out can be in BPF programs loaded from userspace.
+	 * It is also required that offset be untouched (0) for such calls.
+	 */
+	if (!func_id && !offset)
+		return 0;
+
 	if (!btf_tab && offset) {
 		btf_tab = kzalloc(sizeof(*btf_tab), GFP_KERNEL);
 		if (!btf_tab)
@@ -6624,6 +6633,10 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn)
 	struct btf *desc_btf;
 	int err;
 
+	/* skip for now, but return error when we find this in fixup_kfunc_call */
+	if (!insn->imm)
+		return 0;
+
 	desc_btf = find_kfunc_desc_btf(env, insn->imm, insn->off, &btf_mod);
 	if (IS_ERR(desc_btf))
 		return PTR_ERR(desc_btf);
@@ -12758,6 +12771,11 @@ static int fixup_kfunc_call(struct bpf_verifier_env *env,
 {
 	const struct bpf_kfunc_desc *desc;
 
+	if (!insn->imm) {
+		verbose(env, "invalid kernel function call not eliminated in verifier pass\n");
+		return -EINVAL;
+	}
+
 	/* insn->imm has the btf func_id. Replace it with
 	 * an address (relative to __bpf_base_call).
 	 */
-- 
2.33.0

