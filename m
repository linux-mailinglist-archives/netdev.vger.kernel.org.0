Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9E90470128
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 14:02:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238208AbhLJNGP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 08:06:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238117AbhLJNGO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 08:06:14 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08D14C061746;
        Fri, 10 Dec 2021 05:02:40 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id n26so8435993pff.3;
        Fri, 10 Dec 2021 05:02:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1ItAi1NiUfY3PlMRN2nXxe0y6XKd9BsYRCF5Tp9C72Q=;
        b=Rn5vBrGtjonc9PxzsBxNMhcB2Dqy1ua6s3CtYLE9r0RC4Fvuxu6pJPH8xdhOuOmCH0
         dEa0xU+EWuMKbQCFGW/MqXU2xONEhn0lWPWiEsFtAKAdfOwOeqD/K7TqXUhxYWF3tWMJ
         KFCkuTSqaT2CZG6v4bSRUFM4IGEql4N1S94DgFadbl6RRFmj2ORNQwQIK3m/jC4Vtcae
         IQz/qpofUTSs23LpjuSjzoycoT1CiuIEvmD37ChsQYR9H9HiZjj3tsx1LwaapUoEUpsC
         nj36/MAD1W9jRPGnHy9irWSTbZOGB3nRItthUYeQY4dQmSeL2wtenFG2wHRxb7FG9RTx
         ApFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1ItAi1NiUfY3PlMRN2nXxe0y6XKd9BsYRCF5Tp9C72Q=;
        b=NBV2f3trxPFxSuFykRLOIhpP5SsBT7jh22Mdli9+611wLtPPVihkV36bfdIxkjZ/Pt
         D6AZRIfB5oCLHTGBc4ySQaULgtdyfaDxY/ksB6bqSwnx1HOBMwqz4d0+s0u0jYOaby8p
         fkPNjli5f9oxR0c1h//vo17ti1dRz6x/3X45gYIMLdpx/XHiL7hRqgl9rdwceoWm4Pzo
         PTeTICO0y4BR+iR7nxcibj/RcgSt8ahzd0+VIr4Kj7A3RTt/TGLXdDdLOARkY/OaFMZ3
         m4Hf/a0EQhfO3KpIZ3phJKu8dR6wvF6hg57JoSprbBEVQbSBgpuaS5uFvxxthQ7STgwW
         26Eg==
X-Gm-Message-State: AOAM530gXzpopqgB/dsAiLIVs7+DPJ40t4MVBMvWP5BPpx5dczWjBTbj
        5b3LkdCmtDxxcF7pxxkwIqn8U8auAmw=
X-Google-Smtp-Source: ABdhPJz0QPVPVRYZhRSi5f7N1wbUm5MTP66S1Bu9bUe6Sg0QSYXOVwevs6qvFeQTu+U59tMiJ7qdmw==
X-Received: by 2002:a05:6a00:1a53:b0:4b1:7ab:9b5 with SMTP id h19-20020a056a001a5300b004b107ab09b5mr6173917pfv.29.1639141359409;
        Fri, 10 Dec 2021 05:02:39 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id u5sm2739355pgm.60.2021.12.10.05.02.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 05:02:39 -0800 (PST)
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
Subject: [PATCH bpf-next v3 2/9] bpf: Remove DEFINE_KFUNC_BTF_ID_SET
Date:   Fri, 10 Dec 2021 18:32:23 +0530
Message-Id: <20211210130230.4128676-3-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211210130230.4128676-1-memxor@gmail.com>
References: <20211210130230.4128676-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3978; h=from:subject; bh=2YlfhC4jEuAkaiezCz5Ao8Srs74MwfRKp2FGbJdSX/k=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhs0/TUeC5ydFzENnUCQNbbqTsyshDDEfq5h9v8MDB KPomLNqJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYbNP0wAKCRBM4MiGSL8RypfMD/ 9YUImylQikHoyynV9SgnCzjuzREDGbeGpVf+d8Vg4ON2UvRApxgj3/U2am4SUJ/08WeZc+NG/Rqw9t nxcpdKEHM+l+BAUIE/+9K/qRUGnjLmJ34NLJzECvZ3Cl/PKteEPxbk9YS14pWxSG/5wagWAQx3RlY+ imgOqJdd+l+DoWFCT0qDSmC2fWFJ9APTpjS62NvnyvPVxtQAQwUfNkO1TzU8pPDvBJeQes56VJjO4A hoLmVDPWoEqmmek6bcqFFZTuEPy9/i91RgIhx83wRZAeEAZXjoNp+PtLmZw8NXDO/E1aaJFgrxvEE4 3q4b4+KWlLMl+atl1qPm5n6Yqmrp8PoZvmKV1BBuWsJpwLaFkMPhXnAKa4uw89doU92Qk2S2bIpzZy SKpStiHKUOtAVrwqPtKd4aYXvP/wijztDa0MNk5vaRwNlMmjTBxnYeBuqMQocr8VOLiYHF9tlbSWYS Y62xH4jW3ENI8yZD69KCutwX/zE4k9xjAjSX9VHwwJhN5gljiTiMJ09dW+YNwHD5/A/LDxQ2tDHXxT EIEtilbn50NQJYhQAfUluMs8QesZKpa+yR1reUOXmHWlk+lfTrb9lS+DJo1KWzUt2xuVvJSJ0p0xg2 lo17Wpu8kCQ1lMXtmlgqcc/cu/QdD5pjyXhjt8pGZw2ApvxLQJmNN15HEcNQ==
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
index d96e2859382e..3730e845d266 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -361,10 +361,6 @@ static inline bool bpf_check_mod_kfunc_call(struct kfunc_btf_id_list *klist,
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

