Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 400213FBB10
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 19:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238300AbhH3Rfz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 13:35:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238147AbhH3Rfj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 13:35:39 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2A57C061764;
        Mon, 30 Aug 2021 10:34:45 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id 7so12748294pfl.10;
        Mon, 30 Aug 2021 10:34:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yU4+xx6iAwgsGxgz5Ht4AFD9WjITvbQsNdCqZ6ULtK4=;
        b=jvLCEjluWiKv4zpLIy1fBtQofZjH2laDX82OKUaTGAdLmCDRPoKNaieeyjWQaFJXiU
         +2Rki+ft3m+hw9hlATBeHeirRi6MK//1hvbMUdUb1KKAzdIyltxdO2DbTN4yhW9DC2ke
         AQ91Cj9oFAS03W+4xuJoSntdHWdCS+pbOioSj5NGbc5kIAD2iJEf+tkplvWljyPouhcU
         tmn+xaASv4pBqRIiAlBHvdPwByjg2B3dCXbXtRediqWO1+D9U7NOLQV16ZlNp29qL/gc
         uOzhecsg+x9qAvxD0o7/2Sy7xNTvAIb1ybQxRcHOdESPG0G77R4UM0Cs7fhUaRLAEJJK
         H/aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yU4+xx6iAwgsGxgz5Ht4AFD9WjITvbQsNdCqZ6ULtK4=;
        b=c39cJH/LtYdntDTjyQ7S2v/DzVd120TdFd4rLMfifAE7djOyB9t8+q9ugMKD5T8wc0
         qSL+DfiLfprjDq3CWZIK0YZKddPILEB14NzxQVPv976VIGQAqUQFn8r1e6N00tIbZJs8
         8lgkkMrjrr3jFs+UDjTrxb3IgPuqww6MJCPqG15vongwtW5gbzMMaQrb3tGY3FpQCXld
         xYL161EoCIahpXrEKj1EiVMp8+2jgoNIYiMRTmD64XOEabyzFj2e2k/lZIG8QoRJSqI1
         QCL17XD+nHRMXNpnOykFP2z5tfWEg4rkBBRKIVwHlN9hvf3qcnVrzNWfL0khKvnTIuxR
         c1cA==
X-Gm-Message-State: AOAM531Jgxs9rYoeL+TU6557ioCag/FOPhAHmwJZPBqnilKmgz7HC+0o
        G68eWF8w5br9Tjd8NehW8DVbfX1VjXdx8Q==
X-Google-Smtp-Source: ABdhPJynjRPrD2xFf/w7J1BHLShTqTaKUB6DMCuljgvWg+RkaCIn1n5+I+WOxi1UKEXjpWJFWhltzg==
X-Received: by 2002:a62:1816:0:b0:3fc:c349:af7c with SMTP id 22-20020a621816000000b003fcc349af7cmr10036437pfy.31.1630344885395;
        Mon, 30 Aug 2021 10:34:45 -0700 (PDT)
Received: from localhost ([2405:201:6014:d820:9cc6:d37f:c2fd:dc6])
        by smtp.gmail.com with ESMTPSA id m64sm18223072pga.55.2021.08.30.10.34.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 10:34:45 -0700 (PDT)
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
Subject: [PATCH bpf-next RFC v1 5/8] tools: Allow specifying base BTF file in resolve_btfids
Date:   Mon, 30 Aug 2021 23:04:21 +0530
Message-Id: <20210830173424.1385796-6-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210830173424.1385796-1-memxor@gmail.com>
References: <20210830173424.1385796-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2098; h=from:subject; bh=kZhRM1Uo6vUje4gN/WsUjSsDNLJ5u0WuItuVyu5D9Zk=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhLRX9DhwehFEbRic2pkL2wCQ10r1eCg0KKIKoWVSG lKYtwOmJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYS0V/QAKCRBM4MiGSL8RygKPD/ 9tQw7XRzgDl94ByIZTRqMn5kChomef301BN3pM457RFSBeomwD+oe6V9DNDACdf0GqL/bwyMiu3f5Y gy6/GkAuhpTVtMVcpyx3Tjqx8KiOs1/96yjSr170AFVBCwtzS9csDgpi532ip5h/b3IUHTJWKSBb5b QTsy8RCeSkWBibloygFNUpXaG+bqYiZ8V54JcHtVET/2tsBayqUekFN+a4DPbw9ImA+l/D/I+VZXpA N/6UEB0+/5IBFeMjvRdA6xAjm3sXEhe3aeO6Umxn1pnH2+kdwelkI20meCwc03jhqnus3VEntp9wMh vlu9ZVhdhMqla7DFBJyhENvK7nrMPLqNgQIDr9HDOVOx+QEO6bhh9qUUED5YGaoEWzxNDWLGalcdwJ nT9Ou6NXpdBOXrqT9USmuM0cq1CS2XZLAuj2viYGKwjExU6cZt5dhpY+xwn+5Fx5ZqpGbn9eE/86GY 6CGcLXmEG9F0YvM547eOxyY3dM08t2hEGJrzIQH6N6PH6btmst+mfvlI3qWjF1VY6WQg4h7ZwV7HtN lo5RLGSbdzxuVDm3KOHU8Mso17uhLfBhXJM3voliluh0z+vM2Mwflza3E8EQ2g5wAcuTEOsG33LQmQ kK+jvElZXp2yVp+3cnTN2l/lSVkdoIZ4dHUR1mL8/hTsEySSqxPR0VwJ5Y1g==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commits allows specifying the base BTF for resolving btf id
lists/sets during link time in the resolve_btfids tool. The base BTF is
set to NULL if no path is passed. This allows resolving BTF ids for
module kernel objects.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/bpf/resolve_btfids/main.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/tools/bpf/resolve_btfids/main.c b/tools/bpf/resolve_btfids/main.c
index de6365b53c9c..206e1120082f 100644
--- a/tools/bpf/resolve_btfids/main.c
+++ b/tools/bpf/resolve_btfids/main.c
@@ -89,6 +89,7 @@ struct btf_id {
 struct object {
 	const char *path;
 	const char *btf;
+	const char *base_btf_path;
 
 	struct {
 		int		 fd;
@@ -477,16 +478,27 @@ static int symbols_resolve(struct object *obj)
 	int nr_structs  = obj->nr_structs;
 	int nr_unions   = obj->nr_unions;
 	int nr_funcs    = obj->nr_funcs;
+	struct btf *base_btf = NULL;
 	int err, type_id;
 	struct btf *btf;
 	__u32 nr_types;
 
-	btf = btf__parse(obj->btf ?: obj->path, NULL);
+	if (obj->base_btf_path) {
+		base_btf = btf__parse(obj->base_btf_path, NULL);
+		err = libbpf_get_error(base_btf);
+		if (err) {
+			pr_err("FAILED: load base BTF from %s: %s\n",
+			       obj->base_btf_path, strerror(-err));
+			return -1;
+		}
+	}
+
+	btf = btf__parse_split(obj->btf ?: obj->path, base_btf);
 	err = libbpf_get_error(btf);
 	if (err) {
 		pr_err("FAILED: load BTF from %s: %s\n",
 			obj->btf ?: obj->path, strerror(-err));
-		return -1;
+		goto out;
 	}
 
 	err = -1;
@@ -545,6 +557,7 @@ static int symbols_resolve(struct object *obj)
 
 	err = 0;
 out:
+	btf__free(base_btf);
 	btf__free(btf);
 	return err;
 }
@@ -697,6 +710,8 @@ int main(int argc, const char **argv)
 			   "BTF data"),
 		OPT_BOOLEAN(0, "no-fail", &no_fail,
 			   "do not fail if " BTF_IDS_SECTION " section is not found"),
+		OPT_STRING('s', "base-btf", &obj.base_btf_path, "file",
+			   "path of file providing base BTF data"),
 		OPT_END()
 	};
 	int err = -1;
-- 
2.33.0

