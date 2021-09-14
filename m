Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6163A40ADED
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 14:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232939AbhINMjd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 08:39:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232902AbhINMja (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 08:39:30 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05B74C0613C1;
        Tue, 14 Sep 2021 05:38:10 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id 17so12590296pgp.4;
        Tue, 14 Sep 2021 05:38:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yU4+xx6iAwgsGxgz5Ht4AFD9WjITvbQsNdCqZ6ULtK4=;
        b=C8+gBjG8gvVycJFtB7zCILzp77d7RShKQD2jaimyINWujoTBuZ2CTnoFdV6asYKcUZ
         e/4ZDEXnQ4oyewRWjBiX4sULtUhgVZ7VxQmoqlq2Qd6wauIbZeaGG+bjQBMoDMJyqwue
         Ysy9jyEUumjsisI2NaBRSdocijhsXP5AwgboHXWPzZQfEq2HGlPrLPY09nK/Jy8Eud6v
         Qh40jBxlRmz/SKLI1OUiEU+rIXfG8IkcMzS2XtpwC7+TFztxXyz5G7oJ74lv8JyXBPM7
         r9w2/UbaZLQEhhfvXIG9ACy3+vM0qU1I4E/xs1WYDWGxT9yXTD/TBHVHXV9PLlHl5TIo
         FwMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yU4+xx6iAwgsGxgz5Ht4AFD9WjITvbQsNdCqZ6ULtK4=;
        b=eIuDYAItGyhEKJTHMaHjJ8K2UwXWw9VYRL/xd+oehoLsDtgjs2/8B2v6XzaB82TFFx
         ymYfHpUrrkJtgVezUlNHvP3HPqa+j4uMrdeRlHN7TfdlmCa5d/Gv2wsVONdC1LKyYij3
         hj8sstF3+D1SmU3yW6X7O69AV5UIbStZMZ1OtFiYCGMferZhpjhlV0GQVduehX/6lbOt
         S+7f1DRlbgmXUTwKazAMshRWA5kLSeA3HORrLddfi7yI4X+G8bGjPLk8QHnIf9vidoai
         BhLx0jsvMA7XnlfT96pyLPjYJhFOzWcb8qlcSb7TnuEZwTG1OP4gzgpuQZ2bJCmkHjrO
         mnxA==
X-Gm-Message-State: AOAM533+GyNNBu37e2DNE68SIx821kj2sCACqD+QhU79jEkk/MRlGPur
        d/fhAee0w+APhTt38YeTuenpoO4OOgnnfA==
X-Google-Smtp-Source: ABdhPJwXEgJUgD8L7WqLCR+jmsAzNCoZX5BPHOTUKm6XgG5EVVS1sK8T9hfbtq96byx/YrhHRC9r+w==
X-Received: by 2002:a62:6d07:0:b0:40a:33cd:d3ea with SMTP id i7-20020a626d07000000b0040a33cdd3eamr4441713pfc.61.1631623089404;
        Tue, 14 Sep 2021 05:38:09 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id z8sm10040931pfa.113.2021.09.14.05.38.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 05:38:09 -0700 (PDT)
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
Subject: [PATCH bpf-next v2 04/10] tools: Allow specifying base BTF file in resolve_btfids
Date:   Tue, 14 Sep 2021 18:07:43 +0530
Message-Id: <20210914123750.460750-5-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210914123750.460750-1-memxor@gmail.com>
References: <20210914123750.460750-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2098; h=from:subject; bh=kZhRM1Uo6vUje4gN/WsUjSsDNLJ5u0WuItuVyu5D9Zk=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhQJdWDhwehFEbRic2pkL2wCQ10r1eCg0KKIKoWVSG lKYtwOmJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYUCXVgAKCRBM4MiGSL8RymBXD/ 49y4gvzxmoWUtayiH1hrKzBuVcNgBJogUNJYKJAoZIeUGsAvseQhwIB+UN2ojkb5ONSX4gPRd8IJ5A jc2tOe3f0+KmWcyiGHKfEecS35Ef4gHoTSZhBrjuH20lbZ7qt3qCg4laqNZ9t1XnHmApAD0Ovh48xf fvrQh1gvtUXn0jDuFdZoyeVWAoeDasoL+sdxcM013eK/58Va923mLwKBXCtZvmyBJG8JkR39XuLq2W 9Plm2k1nd3WsjTZBrGyqPkl6UgDHFTSuj4mvKiKHx/LHJUFNpe27H61owKQgBkrcxf6ISPbOQER8Vw sf7tkmsi8bxfq4O2iLtqK4AsSM7JuS5WOsilIOxSf4RNpJGvJtRLkB1kzG4RPJW9Qvo33MLgWhcGIi VitHZe7ds0E19aaLTLAfsMVhgRKwlCuVDIRFa3EFaKreNkeGdO1fbAiUXbHHI1Rjx9OecGbE1RkmU7 HgW7RbVfSdOb1/MozuG1TftIYKBovBR16ITuvi8wfNyvbEZWX4cNHt31BcnrQ7BF5TN4qwKGSMItcy 8kvJHI0WWVJk0miZ0BXr7/Y6TmdEG1EV1Ks4IfWxbu5D5QI6gVWaX1XBs/7PtygUv9JhqeLBZh0TeC WCbHj14V03iHHZf3HEMXo7S69dEiXf+2tc7RZvbq/gu3TnVuNtLd1S9m7kmw==
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

