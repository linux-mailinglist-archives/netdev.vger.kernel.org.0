Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D002749281B
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 15:15:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244008AbiARONl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 09:13:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:55309 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233774AbiARONk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 09:13:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642515220;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=IkxHaq0kCy4SsLO6SBaKmPU/IZqSsuPvVM6M3HwEwcE=;
        b=AvHYOkRQOY8bruQbVIW+RAzqqFhwhN1ns5hQZ9GPM0iPsxQxSL1LznVvOceCw8Q9+rDvdu
        RAxfAvt40rxExPArWvoYiHJBD+tcmVads+N2ox6XUEBFgpdZpO0AbidArmSKPCH1axnXho
        qABkDrabvQkV9SC6rwSsPT6yUqqBXKk=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-163-SQL3bRvTP42DM-59d-Um_Q-1; Tue, 18 Jan 2022 09:13:39 -0500
X-MC-Unique: SQL3bRvTP42DM-59d-Um_Q-1
Received: by mail-ed1-f69.google.com with SMTP id c8-20020a05640227c800b003fdc1684cdeso17164621ede.12
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 06:13:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IkxHaq0kCy4SsLO6SBaKmPU/IZqSsuPvVM6M3HwEwcE=;
        b=OtTIiAxabWBqaoi37CT96xetUTxIBjE8YA+QQ8XsCxJlo1L5miWw3VrttSJJHDXQzZ
         5eaU8+ltEiz4R7r/yE2arDOi5sH924L7RZveItYSlU53x3FeOC3WQC7WyloMK2qpcj9W
         4xfFBKoNrQ/FWyFunvgj2aWa0+wxGZ7apLHGM0OP/ifE+i85W9Y4rFTtAZhPbfTj5+QM
         eUiJCcZS/pGESbAB4KBlB3lQ1gBnFooUUEc+e+nvnKzaHcTHqYRYNIRhXmXOrIqGe5tu
         ivVUaMc9TaEsIrSe0T8PylDHA7p+11vwxpTfEsxn1J+8yGy3/UpacClrdTLpj6xCyRDq
         MGtA==
X-Gm-Message-State: AOAM532AORGRjYO9N8v6jwE5iIEZEW8RXdV7NfaVBhCwMNST1KZNqfdf
        7XzPGjm/P4J8Ge1OLeubuCXtd/Gjx6APzVt7dk+HUAduhipBxAiGpmbAkU83sK74xQaBFHF/A3/
        RdaA2VvBrTiyTHVOV
X-Received: by 2002:a17:906:fcb0:: with SMTP id qw16mr283225ejb.560.1642515215735;
        Tue, 18 Jan 2022 06:13:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwlqY3jnCFT+m23Tm5xwL91Ub2ICs+TnZJRMHixpWwJ4IGe1D2vK10fxdKhcnqZBgX9g3ivJA==
X-Received: by 2002:a17:906:fcb0:: with SMTP id qw16mr283058ejb.560.1642515213178;
        Tue, 18 Jan 2022 06:13:33 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id 20sm5369584ejy.105.2022.01.18.06.13.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 06:13:32 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id AFA491804EC; Tue, 18 Jan 2022 15:13:30 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf] libbpf: define BTF_KIND_* constants in btf.h to avoid compilation errors
Date:   Tue, 18 Jan 2022 15:13:27 +0100
Message-Id: <20220118141327.34231-1-toke@redhat.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The btf.h header included with libbpf contains inline helper functions to
check for various BTF kinds. These helpers directly reference the
BTF_KIND_* constants defined in the kernel header, and because the header
file is included in user applications, this happens in the user application
compile units.

This presents a problem if a user application is compiled on a system with
older kernel headers because the constants are not available. To avoid
this, add #defines of the constants directly in btf.h before using them.

Since the kernel header moved to an enum for BTF_KIND_*, the #defines can
shadow the enum values without any errors, so we only need #ifndef guards
for the constants that predates the conversion to enum. We group these so
there's only one guard for groups of values that were added together.

  [0] Closes: https://github.com/libbpf/libbpf/issues/436

Fixes: 223f903e9c83 ("bpf: Rename BTF_KIND_TAG to BTF_KIND_DECL_TAG")
Fixes: 5b84bd10363e ("libbpf: Add support for BTF_KIND_TAG")
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/lib/bpf/btf.h | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
index 061839f04525..51862fdee850 100644
--- a/tools/lib/bpf/btf.h
+++ b/tools/lib/bpf/btf.h
@@ -375,8 +375,28 @@ btf_dump__dump_type_data(struct btf_dump *d, __u32 id,
 			 const struct btf_dump_type_data_opts *opts);
 
 /*
- * A set of helpers for easier BTF types handling
+ * A set of helpers for easier BTF types handling.
+ *
+ * The inline functions below rely on constants from the kernel headers which
+ * may not be available for applications including this header file. To avoid
+ * compilation errors, we define all the constants here that were added after
+ * the initial introduction of the BTF_KIND* constants.
  */
+#ifndef BTF_KIND_FUNC
+#define BTF_KIND_FUNC		12	/* Function	*/
+#define BTF_KIND_FUNC_PROTO	13	/* Function Proto	*/
+#endif
+#ifndef BTF_KIND_VAR
+#define BTF_KIND_VAR		14	/* Variable	*/
+#define BTF_KIND_DATASEC	15	/* Section	*/
+#endif
+#ifndef BTF_KIND_FLOAT
+#define BTF_KIND_FLOAT		16	/* Floating point	*/
+#endif
+/* The kernel header switched to enums, so these two were never #defined */
+#define BTF_KIND_DECL_TAG	17	/* Decl Tag */
+#define BTF_KIND_TYPE_TAG	18	/* Type Tag */
+
 static inline __u16 btf_kind(const struct btf_type *t)
 {
 	return BTF_INFO_KIND(t->info);
-- 
2.34.1

