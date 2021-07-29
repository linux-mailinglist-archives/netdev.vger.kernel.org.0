Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85AFF3DA8D2
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 18:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231903AbhG2QUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 12:20:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231329AbhG2QUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 12:20:44 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97C55C0613C1
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 09:20:40 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id l34-20020a05600c1d22b02902573c214807so1765954wms.2
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 09:20:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Nw65+paVQXUOMSFGAQ4tePwCAzumt7oYHuBlsDEPx6I=;
        b=b7BYnH9VuW+Uq8w0ARUy30TtoaOLYJ8WP2aAZOFjUuCQFY4NT0ENMI6yGpbB96RMcQ
         EJ8lLUI10U8ZmEmesfq5FkatOTMRBmAY6rUbeclAlkDYoYBF40HOtx4YuZfgzIn2jXRt
         FIvckvwFH/o+MQXkHItxv3YV0MLMoBrND12x4QuBlyuRaAewRnN7Jg91Ys1Kj9ScVSJy
         NzXbDp4og5FqjfuNO+2Sc+TmILa2Mge1Od69T9jIBA09aY3yHYWt9akXdahOlJ/Umyct
         KX5lln1zJM1KmF4dM0S1+YzTG6w5ola3mwn0zl+nfDvynFp2tUyo4EO0z2d4LU0WqGeb
         n76w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Nw65+paVQXUOMSFGAQ4tePwCAzumt7oYHuBlsDEPx6I=;
        b=mfbNxeOU1JGASZH6qkPK4+W7/m3IeUSlWhoqTgMFMjJRKxg25EGqfExln5F2NHc2FQ
         wxgkfiUfcpWVhgIh5lZuRZW5TQo1qzVqBRKv1934BCSodV3rdPDf0+GagOASUcVOvJe/
         2IueUsjvIF8XLLQqZcshOjWuvJeKUJJpNOGqLWXL2k8y6cRzmpExJOZWA+/H1b16qAy5
         exLGFxpJq2tiNBmNkDCbw5KphHDdSVWmVwj52TYkcWvcUWNthPrFCdKfAZwca3EJxV8w
         ekSIwxyoqWuoVigZEK/M0y3hK2a18lVyOYt0uxqNUs8y80CBx4cdgp/p/i98mDKsnV2z
         p6Qg==
X-Gm-Message-State: AOAM53049aBAYNUf4mlRJvVs7TdIxIV8/gkXjEuOHkd5A2hl0Y2C8cNH
        KcIEMtyfNMpdENs00z0XyWuylQ==
X-Google-Smtp-Source: ABdhPJw2HZYYsn3cvXNLFg/nOYdOCnpuicrIQev50z7zPVPyq/3Z94MnIUTglBpfRHFib5FwySTtoA==
X-Received: by 2002:a1c:7706:: with SMTP id t6mr5700289wmi.36.1627575639147;
        Thu, 29 Jul 2021 09:20:39 -0700 (PDT)
Received: from localhost.localdomain ([149.86.66.250])
        by smtp.gmail.com with ESMTPSA id c10sm3854853wmb.40.2021.07.29.09.20.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 09:20:38 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH bpf-next v3 2/8] libbpf: rename btf__load() as btf__load_into_kernel()
Date:   Thu, 29 Jul 2021 17:20:22 +0100
Message-Id: <20210729162028.29512-3-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210729162028.29512-1-quentin@isovalent.com>
References: <20210729162028.29512-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As part of the effort to move towards a v1.0 for libbpf, rename
btf__load() function, used to "upload" BTF information into the kernel,
as btf__load_into_kernel(). This new name better reflects what the
function does.

References:

- https://github.com/libbpf/libbpf/issues/278
- https://github.com/libbpf/libbpf/wiki/Libbpf:-the-road-to-v1.0#btfh-apis

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
---
 tools/lib/bpf/btf.c      | 3 ++-
 tools/lib/bpf/btf.h      | 1 +
 tools/lib/bpf/libbpf.c   | 2 +-
 tools/lib/bpf/libbpf.map | 1 +
 4 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index b46760b93bb4..7e0de560490e 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -1180,7 +1180,7 @@ int btf__finalize_data(struct bpf_object *obj, struct btf *btf)
 
 static void *btf_get_raw_data(const struct btf *btf, __u32 *size, bool swap_endian);
 
-int btf__load(struct btf *btf)
+int btf__load_into_kernel(struct btf *btf)
 {
 	__u32 log_buf_size = 0, raw_size;
 	char *log_buf = NULL;
@@ -1228,6 +1228,7 @@ int btf__load(struct btf *btf)
 	free(log_buf);
 	return libbpf_err(err);
 }
+int btf__load(struct btf *) __attribute__((alias("btf__load_into_kernel")));
 
 int btf__fd(const struct btf *btf)
 {
diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
index 374e9f15de2e..fd8a21d936ef 100644
--- a/tools/lib/bpf/btf.h
+++ b/tools/lib/bpf/btf.h
@@ -46,6 +46,7 @@ LIBBPF_API struct btf *btf__parse_raw_split(const char *path, struct btf *base_b
 
 LIBBPF_API int btf__finalize_data(struct bpf_object *obj, struct btf *btf);
 LIBBPF_API int btf__load(struct btf *btf);
+LIBBPF_API int btf__load_into_kernel(struct btf *btf);
 LIBBPF_API __s32 btf__find_by_name(const struct btf *btf,
 				   const char *type_name);
 LIBBPF_API __s32 btf__find_by_name_kind(const struct btf *btf,
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 7b2b5d261a08..9a657d6d7da3 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -2769,7 +2769,7 @@ static int bpf_object__sanitize_and_load_btf(struct bpf_object *obj)
 		 */
 		btf__set_fd(kern_btf, 0);
 	} else {
-		err = btf__load(kern_btf);
+		err = btf__load_into_kernel(kern_btf);
 	}
 	if (sanitize) {
 		if (!err) {
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index c240d488eb5e..4d80eb8c56b0 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -375,6 +375,7 @@ LIBBPF_0.5.0 {
 		bpf_map_lookup_and_delete_elem_flags;
 		bpf_program__attach_kprobe_opts;
 		bpf_object__gen_loader;
+		btf__load_into_kernel;
 		btf_dump__dump_type_data;
 		libbpf_set_strict_mode;
 } LIBBPF_0.4.0;
-- 
2.30.2

