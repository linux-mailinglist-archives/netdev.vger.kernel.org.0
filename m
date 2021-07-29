Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA6743DA8D3
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 18:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231974AbhG2QU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 12:20:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231634AbhG2QUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 12:20:45 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA240C061765
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 09:20:41 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id h14so7602050wrx.10
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 09:20:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WpzKuMYPOOo+opYvgS0cCtV4tL2VnVBIMo4lNV54X2A=;
        b=TTEXmlfC+Q8I3qXy7YVvc9OFAJCu2F3mWWpgxrQvRNH+ck8brFpuYMMoi0+VktDVyL
         8OEbSzLRtbY3oSMOPTo5omt2sbwqMr1by/oc/HWCzEzMg2Fg5W4IBGhVXifNPz3KxcHS
         Zvv/mihY70YeIwt33voOzV6ZeQNzcziYfwlZ6Bb88ADrEWPzcFbLJEY6AR5S1XwMAqD5
         Dn+zzn+0G16pcK1cdqFMIVmLPJvOkCVjzMvtoJG9TbrrhEtC3xKw0xFpEOv5diy192jp
         Ykr/2utdbakW5mtmJTHgXT7LN6ba4ezwlPFEY3+eI0l52rWuciMYMLx7xH4GTf4v3liC
         s7Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WpzKuMYPOOo+opYvgS0cCtV4tL2VnVBIMo4lNV54X2A=;
        b=LJa/02twPQSICFUYwFRHfE/UBLUvX7cp91P6ILGUPg9zd5VlGKiLklj9fh1Qor1aGh
         zb2KzvSl6j/GmWskhtzH6sVxi+rDmPcUUq2M+BeE/0/Ly0GSGSlthEVTanLWAsDzoYv4
         pUgm/eZBw/kirh40zIX5YBvJNnodBS+NlS9+zgKUygu/l1hMbdvbTfZYQrW10CqmG+mG
         wF/iw32XqfqOiEBdbog6t45bEUzEOcg5Q4SMLa/+lh5rcnviFdiQvXQjOCBPKNmOiqAt
         XDgkdu6wUEh9njQYPIJbN+frgbqWkuZXvAU8+0gr9MQ3NqUxPosEYKPmJIzq17MNAMwu
         4GDA==
X-Gm-Message-State: AOAM533FkZRwQJrozZfxwqTFq2ErahXGI8DscFjlRpwrg+TwCHETM/Wn
        r3zyte/JA+Pxh8t7eJBMqq92b1I+mJ6ikHCdaP0=
X-Google-Smtp-Source: ABdhPJxAZJFxVjOsG4dFTmMC24NdvSZAPVL+ch7lG5vJAjZ6aNax9Hn7256v7Z7aSle8dY13l8s/Rw==
X-Received: by 2002:adf:9cc7:: with SMTP id h7mr3206863wre.406.1627575640270;
        Thu, 29 Jul 2021 09:20:40 -0700 (PDT)
Received: from localhost.localdomain ([149.86.66.250])
        by smtp.gmail.com with ESMTPSA id c10sm3854853wmb.40.2021.07.29.09.20.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 09:20:39 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH bpf-next v3 3/8] libbpf: rename btf__get_from_id() as btf__load_from_kernel_by_id()
Date:   Thu, 29 Jul 2021 17:20:23 +0100
Message-Id: <20210729162028.29512-4-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210729162028.29512-1-quentin@isovalent.com>
References: <20210729162028.29512-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rename function btf__get_from_id() as btf__load_from_kernel_by_id() to
better indicate what the function does. Change the new function so that,
instead of requiring a pointer to the pointer to update and returning
with an error code, it takes a single argument (the id of the BTF
object) and returns the corresponding pointer. This is more in line with
the existing constructors.

The other tools calling the (soon-to-be) deprecated btf__get_from_id()
function will be updated in a future commit.

References:

- https://github.com/libbpf/libbpf/issues/278
- https://github.com/libbpf/libbpf/wiki/Libbpf:-the-road-to-v1.0#btfh-apis

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
---
 tools/lib/bpf/btf.c      | 25 +++++++++++++++++--------
 tools/lib/bpf/btf.h      |  3 ++-
 tools/lib/bpf/libbpf.c   |  5 +++--
 tools/lib/bpf/libbpf.map |  1 +
 4 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 7e0de560490e..948c29fee447 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -1383,21 +1383,30 @@ struct btf *btf_get_from_fd(int btf_fd, struct btf *base_btf)
 	return btf;
 }
 
+struct btf *btf__load_from_kernel_by_id(__u32 id)
+{
+	struct btf *btf;
+	int btf_fd;
+
+	btf_fd = bpf_btf_get_fd_by_id(id);
+	if (btf_fd < 0)
+		return libbpf_err_ptr(-errno);
+
+	btf = btf_get_from_fd(btf_fd, NULL);
+	close(btf_fd);
+
+	return libbpf_ptr(btf);
+}
+
 int btf__get_from_id(__u32 id, struct btf **btf)
 {
 	struct btf *res;
-	int err, btf_fd;
+	int err;
 
 	*btf = NULL;
-	btf_fd = bpf_btf_get_fd_by_id(id);
-	if (btf_fd < 0)
-		return libbpf_err(-errno);
-
-	res = btf_get_from_fd(btf_fd, NULL);
+	res = btf__load_from_kernel_by_id(id);
 	err = libbpf_get_error(res);
 
-	close(btf_fd);
-
 	if (err)
 		return libbpf_err(err);
 
diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
index fd8a21d936ef..698afde03c2e 100644
--- a/tools/lib/bpf/btf.h
+++ b/tools/lib/bpf/btf.h
@@ -43,6 +43,8 @@ LIBBPF_API struct btf *btf__parse_elf(const char *path, struct btf_ext **btf_ext
 LIBBPF_API struct btf *btf__parse_elf_split(const char *path, struct btf *base_btf);
 LIBBPF_API struct btf *btf__parse_raw(const char *path);
 LIBBPF_API struct btf *btf__parse_raw_split(const char *path, struct btf *base_btf);
+LIBBPF_API struct btf *btf__load_from_kernel_by_id(__u32 id);
+LIBBPF_API int btf__get_from_id(__u32 id, struct btf **btf);
 
 LIBBPF_API int btf__finalize_data(struct bpf_object *obj, struct btf *btf);
 LIBBPF_API int btf__load(struct btf *btf);
@@ -67,7 +69,6 @@ LIBBPF_API void btf__set_fd(struct btf *btf, int fd);
 LIBBPF_API const void *btf__get_raw_data(const struct btf *btf, __u32 *size);
 LIBBPF_API const char *btf__name_by_offset(const struct btf *btf, __u32 offset);
 LIBBPF_API const char *btf__str_by_offset(const struct btf *btf, __u32 offset);
-LIBBPF_API int btf__get_from_id(__u32 id, struct btf **btf);
 LIBBPF_API int btf__get_map_kv_tids(const struct btf *btf, const char *map_name,
 				    __u32 expected_key_size,
 				    __u32 expected_value_size,
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 9a657d6d7da3..313883179919 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -8316,7 +8316,7 @@ static int libbpf_find_prog_btf_id(const char *name, __u32 attach_prog_fd)
 {
 	struct bpf_prog_info_linear *info_linear;
 	struct bpf_prog_info *info;
-	struct btf *btf = NULL;
+	struct btf *btf;
 	int err;
 
 	info_linear = bpf_program__get_prog_info_linear(attach_prog_fd, 0);
@@ -8333,7 +8333,8 @@ static int libbpf_find_prog_btf_id(const char *name, __u32 attach_prog_fd)
 		pr_warn("The target program doesn't have BTF\n");
 		goto out;
 	}
-	if (btf__get_from_id(info->btf_id, &btf)) {
+	btf = btf__load_from_kernel_by_id(info->btf_id);
+	if (libbpf_get_error(btf)) {
 		pr_warn("Failed to get BTF of the program\n");
 		goto out;
 	}
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 4d80eb8c56b0..3a9c6939301e 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -375,6 +375,7 @@ LIBBPF_0.5.0 {
 		bpf_map_lookup_and_delete_elem_flags;
 		bpf_program__attach_kprobe_opts;
 		bpf_object__gen_loader;
+		btf__load_from_kernel_by_id;
 		btf__load_into_kernel;
 		btf_dump__dump_type_data;
 		libbpf_set_strict_mode;
-- 
2.30.2

