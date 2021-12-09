Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 234BD46F103
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 18:09:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242489AbhLIRNN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 12:13:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242479AbhLIRNM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 12:13:12 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DFF3C0617A1;
        Thu,  9 Dec 2021 09:09:39 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id i12so5990065pfd.6;
        Thu, 09 Dec 2021 09:09:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=P8O5QErZ2jdQYXzcJnu5Zo3N8QUOjV62BUXXzC5OX2s=;
        b=DltCdRCnNYpSSzEOXWBFdZXarMQct8RvpIexlwGEtYZTJ9n6WDrQLkI2UAfIdB9/XN
         RV82YE56lzSuiWCcJRIxRzcwlEH+po05NmzXR89cY4QijF3/re95+3UxSz2czWY1IChn
         E824IYKecUxC6e+uI6MzpQmbdkQbGvZNOfHG5yglRjdt3X01nK6Sii1JQETLScARDl5O
         BtfZ90DOf++2ccAdlXfB7b4Rz/HllMo26muWND4RKnA5mpSbBAg6VQINeu3I3QdqaIuy
         H7p/w9CZULcI4TP8xVgCjrq1Njm1qj9E27TlKrEJQuT++dWeyUkHVeQE2LkFJKKVj/s9
         EIgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=P8O5QErZ2jdQYXzcJnu5Zo3N8QUOjV62BUXXzC5OX2s=;
        b=DRio/PCPwiqP69gsGBuqAAOyH6x5z1Yo9vsotSxMre7PmR4xVFTeNzkwt8nvftbY7G
         Kkc3yJ+MRvrV5xdClbQYL5PnUiJygIYoTERUzEoItzyKURZBnA7SfT1zhyZnOds1PmAp
         oSowsnejiQgBIMYLzqADQ9cYrcDkjwUYHISbd43OqIUVbCf6INcUg/JEqlb8xb6vMmEc
         qFlJ4QBh9RVCJxgCW2cBmS30RvTX35Rsth2ZpY66vrlvtzF2Zw8daQKR36nIRN2f3Cfy
         R6hw+WXDZ3NGl5uwaN2GO8VbJxTYmDUowqBlZZG0aQitObg6IshQyxS47pirlkLNf/i7
         t5Aw==
X-Gm-Message-State: AOAM533laBmhH+7M1usx6iX9TCcByp1t1z1w4rSCPXTIFkPAvdygePsv
        vnNsyNAajxhNEDTXoAeiDmdsEHMTYkY=
X-Google-Smtp-Source: ABdhPJxlEJBgpTSs/h2NJdSLXB5LdMR7Xr0TTNSoJJ0zhcB/UylEaK03pGhoyF46ufR6+4BsjvYXhg==
X-Received: by 2002:a62:cdc1:0:b0:4aa:6a80:8bbf with SMTP id o184-20020a62cdc1000000b004aa6a808bbfmr12944564pfg.4.1639069778555;
        Thu, 09 Dec 2021 09:09:38 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id k6sm10230627pjt.14.2021.12.09.09.09.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 09:09:38 -0800 (PST)
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
Subject: [PATCH bpf-next v2 2/9] bpf: Remove DEFINE_KFUNC_BTF_ID_SET
Date:   Thu,  9 Dec 2021 22:39:22 +0530
Message-Id: <20211209170929.3485242-3-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211209170929.3485242-1-memxor@gmail.com>
References: <20211209170929.3485242-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3978; h=from:subject; bh=QekA5mm1iJ6B929iH/8jysavS44UJ8b5BFAs9jlkHRU=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhsjgH0mDA66G7iUv4uw/T/2uHYHgurmbWR+mgD2ps jW1zF06JAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYbI4BwAKCRBM4MiGSL8Rym5pD/ 9Pfkb4Bj5ptFXsUoZ9Bm925SYR9DEO4hgVA90oCXntLDoxC1MWuqwhyOdYQVUIR0LmAsVbUHd0kVFn k9BaF9JwlMLGLETHPVZ43JsHPVSW/UHYLm0CAnHbZyRgP5mnU9NIV+x7BiflJX1DtPDEV6oSPx3YD+ 3JVmTZ37GKDkHJfHAayyyrr38uPq9wsPu4mlsBWa8rBr6NNf2UKlLhgs63GWfCXjwwQoRI0YHeYXy3 AgT+IW+UKKw40DlV+GTi2TVkz/WnSVDAiHAFyY0vY3xWticeTykp46Q40j/uWDlo+o2+e4SfJFFvbP R4/tgzWCjAaMY/9huAdQpdrZMHG/jr+yhwcywzu/yvpeM5zamIi1BDjBOttolqIz+vX8DvAiAy/YFP GVV58b9UsmxwIvsJmVJEBh+L/BsxBOIH69CyuX0TXft4kKhh2/qwN73xpAL9waD+tEbvU6TNaLW1iI t8ph7GuPLf17uaU9TjFuV+1sj2ykOL6U+aJTLLzEzmnJws/FMV9iyi0qBUapE9iesBPp2lycWNLKk7 8xfMWruhtc+Dx3KarZvZCQ70IbTFK6KyUDTJC5wjh163UJX2zzZmOpwl05Cg30b1JbIIM1D8045yPK WGgO8r7mg0zkIeSixDzZkJ60uYNR0950T5KJ/S3S2tpg/znAX9v+gLdllXcQ==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The only reason to keep it was to initialize list head, but future
commits will introduce more members that need to be set, which is more
convenient to do using designated initializer.

Hence, remove the macro, convert users, and initialize list head inside
register_kfunc_btf_id_set.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/linux/btf.h                                   | 4 ----
 kernel/bpf/btf.c                                      | 1 +
 net/ipv4/tcp_bbr.c                                    | 5 ++++-
 net/ipv4/tcp_cubic.c                                  | 5 ++++-
 net/ipv4/tcp_dctcp.c                                  | 5 ++++-
 tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c | 5 ++++-
 6 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/include/linux/btf.h b/include/linux/btf.h
index d3014493f6fb..ec9e69c14480 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -361,10 +361,6 @@ bool bpf_check_mod_kfunc_call(struct kfunc_btf_id_list *klist, u32 kfunc_id,
 }
 #endif
 
-#define DEFINE_KFUNC_BTF_ID_SET(set, name)                                     \
-	struct kfunc_btf_id_set name = { LIST_HEAD_INIT(name.list), (set),     \
-					 THIS_MODULE }
-
 extern struct kfunc_btf_id_list bpf_tcp_ca_kfunc_list;
 extern struct kfunc_btf_id_list prog_test_kfunc_list;
 
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index c9413d13ca91..450f9e37ceca 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6375,6 +6375,7 @@ struct kfunc_btf_id_list {
 void register_kfunc_btf_id_set(struct kfunc_btf_id_list *l,
 			       struct kfunc_btf_id_set *s)
 {
+	INIT_LIST_HEAD(&s->list);
 	mutex_lock(&l->mutex);
 	list_add(&s->list, &l->list);
 	mutex_unlock(&l->mutex);
diff --git a/net/ipv4/tcp_bbr.c b/net/ipv4/tcp_bbr.c
index ec5550089b4d..280dada5d1ae 100644
--- a/net/ipv4/tcp_bbr.c
+++ b/net/ipv4/tcp_bbr.c
@@ -1169,7 +1169,10 @@ BTF_ID(func, bbr_set_state)
 #endif
 BTF_SET_END(tcp_bbr_kfunc_ids)
 
-static DEFINE_KFUNC_BTF_ID_SET(&tcp_bbr_kfunc_ids, tcp_bbr_kfunc_btf_set);
+static struct kfunc_btf_id_set tcp_bbr_kfunc_btf_set = {
+	.owner = THIS_MODULE,
+	.set   = &tcp_bbr_kfunc_ids,
+};
 
 static int __init bbr_register(void)
 {
diff --git a/net/ipv4/tcp_cubic.c b/net/ipv4/tcp_cubic.c
index 5e9d9c51164c..70384a8040c5 100644
--- a/net/ipv4/tcp_cubic.c
+++ b/net/ipv4/tcp_cubic.c
@@ -497,7 +497,10 @@ BTF_ID(func, cubictcp_acked)
 #endif
 BTF_SET_END(tcp_cubic_kfunc_ids)
 
-static DEFINE_KFUNC_BTF_ID_SET(&tcp_cubic_kfunc_ids, tcp_cubic_kfunc_btf_set);
+static struct kfunc_btf_id_set tcp_cubic_kfunc_btf_set = {
+	.owner = THIS_MODULE,
+	.set   = &tcp_cubic_kfunc_ids,
+};
 
 static int __init cubictcp_register(void)
 {
diff --git a/net/ipv4/tcp_dctcp.c b/net/ipv4/tcp_dctcp.c
index 0d7ab3cc7b61..ac2a47eb89d8 100644
--- a/net/ipv4/tcp_dctcp.c
+++ b/net/ipv4/tcp_dctcp.c
@@ -251,7 +251,10 @@ BTF_ID(func, dctcp_state)
 #endif
 BTF_SET_END(tcp_dctcp_kfunc_ids)
 
-static DEFINE_KFUNC_BTF_ID_SET(&tcp_dctcp_kfunc_ids, tcp_dctcp_kfunc_btf_set);
+static struct kfunc_btf_id_set tcp_dctcp_kfunc_btf_set = {
+	.owner = THIS_MODULE,
+	.set   = &tcp_dctcp_kfunc_ids,
+};
 
 static int __init dctcp_register(void)
 {
diff --git a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
index 5d52ea2768df..a437086e1860 100644
--- a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
+++ b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
@@ -93,7 +93,10 @@ BTF_SET_START(bpf_testmod_kfunc_ids)
 BTF_ID(func, bpf_testmod_test_mod_kfunc)
 BTF_SET_END(bpf_testmod_kfunc_ids)
 
-static DEFINE_KFUNC_BTF_ID_SET(&bpf_testmod_kfunc_ids, bpf_testmod_kfunc_btf_set);
+static struct kfunc_btf_id_set bpf_testmod_kfunc_btf_set = {
+	.owner = THIS_MODULE,
+	.set   = &bpf_testmod_kfunc_ids,
+};
 
 static int bpf_testmod_init(void)
 {
-- 
2.34.1

