Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94EC53C85DA
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 16:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232816AbhGNOSm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 10:18:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232543AbhGNOSj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 10:18:39 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10888C061764
        for <netdev@vger.kernel.org>; Wed, 14 Jul 2021 07:15:48 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id v5so3436721wrt.3
        for <netdev@vger.kernel.org>; Wed, 14 Jul 2021 07:15:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CSW+B8YeFefYH1Ir/Q2pn5cgLIgymPkcnV1aC48t328=;
        b=jcYB+fAnFlM89GbF6jSoChSI1X8hpt0qa1TkLBTjktSG14qYVAUiI1YlTBShihuN6/
         bX4tKst7U92Z6Ah9kM9zUEqr2oGNHOj2f9BgFGcEDB5KGsfNygCNyM3q0xN2qbEWfMUn
         Z3sRVixnhsFAGftjvIWBc2AhGPPXGQpbaXNSvMYJ9lmzaFuTB1RivAVVzNeD5ItqCdfs
         zuLmrxkT/G0BnFnMcKPyNVG/mH4JywJ6cqGi/hGUCetkGTaGRrTJ0+B4KsA4y4VMY+f8
         wtqjPgkziTww+vBq/GNVSM6JGh3JSaNX0iBZ0Ee6Fbv+Yx4lpwdJqtFX1+cI5nobwEHy
         TKbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CSW+B8YeFefYH1Ir/Q2pn5cgLIgymPkcnV1aC48t328=;
        b=XPzRs/jboLXTzin0HtSFDFqbxWLbvPv3SLJmfNilvjmCtoOpnCzjeU0WnvhqzSau/L
         t8mAgGe6O2m+nRcHM0MBFqTPv4yhJG2c9r9lX/gkRNsjtXgPFlqGQcFgngLeL8XMZvAj
         Mfu1M580KNoiNsqFj2OH5iMcgECep6uEhXH+RUjIewxYkdFONuZlwvK6NlEhvL1gk0Lu
         UWdZb/0wA6LlLBE8jIgaBmBb3Xv+Ov/wCIjX9YTaswMkjdzQk23H6SbUUMNNgKI3i2xA
         ofspAaIwa72idY3z8lKJUYUy0yaGJrXpz4rw5x8NDtu7yIbD3q1OPalVz7Zx5wunoR3R
         os8w==
X-Gm-Message-State: AOAM532Om0twrErCBFG8PAWDQSREum93vs8byIX3TeYDrzTep6AsmU1i
        m/MOt00ziv6ho16Fojm7yi6/UA==
X-Google-Smtp-Source: ABdhPJwQ0Mr/d+SVS2DU2E5nwYxhdWCe5g8XJjw6kBoIjdnbYFY4V49UQPqwl9xf8RcZ8nZjw1xKGg==
X-Received: by 2002:a05:6000:1c4:: with SMTP id t4mr13400198wrx.181.1626272146728;
        Wed, 14 Jul 2021 07:15:46 -0700 (PDT)
Received: from localhost.localdomain ([149.86.90.174])
        by smtp.gmail.com with ESMTPSA id a207sm6380037wme.27.2021.07.14.07.15.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 07:15:46 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next 2/6] libbpf: rename btf__get_from_id() as btf__load_from_kernel_by_id()
Date:   Wed, 14 Jul 2021 15:15:28 +0100
Message-Id: <20210714141532.28526-3-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210714141532.28526-1-quentin@isovalent.com>
References: <20210714141532.28526-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rename function btf__get_from_id() as btf__load_from_kernel_by_id() to
better indicate what the function does.

The other tools calling the deprecated btf__get_from_id() function will
be updated in a future commit.

References:

- https://github.com/libbpf/libbpf/issues/278
- https://github.com/libbpf/libbpf/wiki/Libbpf:-the-road-to-v1.0#btfh-apis

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 tools/lib/bpf/btf.c      | 4 +++-
 tools/lib/bpf/btf.h      | 1 +
 tools/lib/bpf/libbpf.c   | 2 +-
 tools/lib/bpf/libbpf.map | 1 +
 4 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 7e0de560490e..05b63b63083a 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -1383,7 +1383,7 @@ struct btf *btf_get_from_fd(int btf_fd, struct btf *base_btf)
 	return btf;
 }
 
-int btf__get_from_id(__u32 id, struct btf **btf)
+int btf__load_from_kernel_by_id(__u32 id, struct btf **btf)
 {
 	struct btf *res;
 	int err, btf_fd;
@@ -1404,6 +1404,8 @@ int btf__get_from_id(__u32 id, struct btf **btf)
 	*btf = res;
 	return 0;
 }
+int btf__get_from_id(__u32, struct btf **)
+	__attribute__((alias("btf__load_from_kernel_by_id")));
 
 int btf__get_map_kv_tids(const struct btf *btf, const char *map_name,
 			 __u32 expected_key_size, __u32 expected_value_size,
diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
index b36f1b2805dc..0bd9d3952d19 100644
--- a/tools/lib/bpf/btf.h
+++ b/tools/lib/bpf/btf.h
@@ -68,6 +68,7 @@ LIBBPF_API const void *btf__get_raw_data(const struct btf *btf, __u32 *size);
 LIBBPF_API const char *btf__name_by_offset(const struct btf *btf, __u32 offset);
 LIBBPF_API const char *btf__str_by_offset(const struct btf *btf, __u32 offset);
 LIBBPF_API int btf__get_from_id(__u32 id, struct btf **btf);
+LIBBPF_API int btf__load_from_kernel_by_id(__u32 id, struct btf **btf);
 LIBBPF_API int btf__get_map_kv_tids(const struct btf *btf, const char *map_name,
 				    __u32 expected_key_size,
 				    __u32 expected_value_size,
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index d8b7c7750402..e54fa1e57d48 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -9571,7 +9571,7 @@ static int libbpf_find_prog_btf_id(const char *name, __u32 attach_prog_fd)
 		pr_warn("The target program doesn't have BTF\n");
 		goto out;
 	}
-	if (btf__get_from_id(info->btf_id, &btf)) {
+	if (btf__load_from_kernel_by_id(info->btf_id, &btf)) {
 		pr_warn("Failed to get BTF of the program\n");
 		goto out;
 	}
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index d42f20b0e9e4..a687cc63cd80 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -378,5 +378,6 @@ LIBBPF_0.5.0 {
 
 LIBBPF_0.6.0 {
 	global:
+		btf__load_from_kernel_by_id;
 		btf__load_into_kernel;
 } LIBBPF_0.5.0;
-- 
2.30.2

