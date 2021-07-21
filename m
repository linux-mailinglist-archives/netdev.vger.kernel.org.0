Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1890C3D12A3
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 17:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240039AbhGUO5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 10:57:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240021AbhGUO5m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 10:57:42 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A1D9C061575
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 08:38:15 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id u8-20020a7bcb080000b02901e44e9caa2aso1225211wmj.4
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 08:38:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YFc+p2CWUZ27INFIKo1iQGYRXr1S7VT4yShsvIVH75w=;
        b=Edpwi6NgjS5enTGjsxjMTUMSFkA2+pWw1ynvfNeiqi6Ho2iFhN/nQtdC7M9JFWSQ34
         AmKB8eUeFhWV5eC/HDGuWoUutH+oWZbFocXJY2GkIkr0TscoQUVTjnVPZhBXDKdj5fUu
         cNLVv0ikpqMdnYqzeozd3lJzT1XoitngTYOFIgIRzTEgA46Qocj8/kuDCnMiuiFHRYdq
         dU8H2mWbuK/1f3K9AB0q/trpPmi6I1DiRQPq0mKfuVQzndpLT2TJJiJfTS14Smb7j1cc
         +yJjPWg/QLhfPeso/2pDgvVkW3ZfkICbhcOv8X0mKfpJx+HEpx1tZAeBDObJpN3wrKy6
         oj5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YFc+p2CWUZ27INFIKo1iQGYRXr1S7VT4yShsvIVH75w=;
        b=ra4P1x+yB3G7l1ZDq22wTuScs0zMC5hu7Cah39Cb5hFCU/VJH8MQQQfM23pyOvZ0Vc
         qkb+gJmJo7/6wjNbikrHEPtzHRCfj0brekoNwXyPWwiKF6Eimk/R2vXGsBSJLT8hM+nW
         w4oW55KLfUyImsJvho0NsrZFkwKaIZDZqDwk1H7KTEmXYnrGsBKqToS2qIJVKLAYZZCy
         ZbFo/QH0JcHHcmzKaDCQYIPkvyZvUgjf5MwCh5dNWFMq2Vxic6/YcgtHXBrcuwAaHweG
         KSmpqePcid9IYZBdNYSPpWL/Nxwj6uUdNq6ba7jvxkfo1zbV0kFz6abGuORll8CTv4H0
         gkMQ==
X-Gm-Message-State: AOAM532mxdAG6xrU8on5VSP34kFB37poKGE6VaIBFo4qIY7yTdeVKWaI
        QnhvnjuaX3rKiqhvVpb/TrY1KA==
X-Google-Smtp-Source: ABdhPJz9Os3rKNk1W8eUTWaqPW0hKizkKc3HSKXdQqXV66JS7rUUXMrARReUKF+MslkNbCpRWrnqyQ==
X-Received: by 2002:a05:600c:47c4:: with SMTP id l4mr4662002wmo.125.1626881893946;
        Wed, 21 Jul 2021 08:38:13 -0700 (PDT)
Received: from localhost.localdomain ([149.86.71.195])
        by smtp.gmail.com with ESMTPSA id n18sm26209714wrt.89.2021.07.21.08.38.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 08:38:13 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH bpf-next v2 2/5] libbpf: rename btf__get_from_id() as btf__load_from_kernel_by_id()
Date:   Wed, 21 Jul 2021 16:38:05 +0100
Message-Id: <20210721153808.6902-3-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210721153808.6902-1-quentin@isovalent.com>
References: <20210721153808.6902-1-quentin@isovalent.com>
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

The other tools calling the deprecated btf__get_from_id() function will
be updated in a future commit.

References:

- https://github.com/libbpf/libbpf/issues/278
- https://github.com/libbpf/libbpf/wiki/Libbpf:-the-road-to-v1.0#btfh-apis

v2:
- Instead of a simple renaming, change the new function to make it
  return the pointer to the btf struct.
- API v0.5.0 instead of v0.6.0.

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
---
 tools/lib/bpf/btf.c      | 25 +++++++++++++++++--------
 tools/lib/bpf/btf.h      |  1 +
 tools/lib/bpf/libbpf.c   |  5 +++--
 tools/lib/bpf/libbpf.map |  1 +
 4 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 7e0de560490e..6654bdee7ad7 100644
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
+		return ERR_PTR(-errno);
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
index fd8a21d936ef..3db9446bc133 100644
--- a/tools/lib/bpf/btf.h
+++ b/tools/lib/bpf/btf.h
@@ -68,6 +68,7 @@ LIBBPF_API const void *btf__get_raw_data(const struct btf *btf, __u32 *size);
 LIBBPF_API const char *btf__name_by_offset(const struct btf *btf, __u32 offset);
 LIBBPF_API const char *btf__str_by_offset(const struct btf *btf, __u32 offset);
 LIBBPF_API int btf__get_from_id(__u32 id, struct btf **btf);
+LIBBPF_API struct btf *btf__load_from_kernel_by_id(__u32 id);
 LIBBPF_API int btf__get_map_kv_tids(const struct btf *btf, const char *map_name,
 				    __u32 expected_key_size,
 				    __u32 expected_value_size,
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 242e97892043..eff005b1eba1 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -9576,8 +9576,8 @@ static int libbpf_find_prog_btf_id(const char *name, __u32 attach_prog_fd)
 {
 	struct bpf_prog_info_linear *info_linear;
 	struct bpf_prog_info *info;
-	struct btf *btf = NULL;
 	int err = -EINVAL;
+	struct btf *btf;
 
 	info_linear = bpf_program__get_prog_info_linear(attach_prog_fd, 0);
 	err = libbpf_get_error(info_linear);
@@ -9591,7 +9591,8 @@ static int libbpf_find_prog_btf_id(const char *name, __u32 attach_prog_fd)
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
index f7d52d76ca3a..ca8cc7a7faad 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -373,6 +373,7 @@ LIBBPF_0.5.0 {
 		bpf_map__initial_value;
 		bpf_map_lookup_and_delete_elem_flags;
 		bpf_object__gen_loader;
+		btf__load_from_kernel_by_id;
 		btf__load_into_kernel;
 		btf_dump__dump_type_data;
 		libbpf_set_strict_mode;
-- 
2.30.2

