Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC79942E2F5
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 22:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232402AbhJNU7L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 16:59:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232467AbhJNU7K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 16:59:10 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9684BC061570;
        Thu, 14 Oct 2021 13:57:04 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id lk8-20020a17090b33c800b001a0a284fcc2so7838592pjb.2;
        Thu, 14 Oct 2021 13:57:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uGJypVP0LSdHJsPF64m+oQSB4IwFYdW+hk4M0oJYwes=;
        b=hAFpU981llIxCCKzv3FkVj3hu3yz/bD4sjfem9GLz6AmYNSVUTCh5tpbzWGaBl0SpB
         y4bFCTq/xN2D4wPL8zHDSRhB7MGUaB/Gby97Cbn+DugeuiwQ42OzofQMQER7MBd37U47
         5SbpaUYJUTdbp/K0Fpfz5NQFn1+SvWfDBmJUnbtkOCNLgxPaYZDTirlx1oWy+fokM02Q
         6BJNnpa1rdD79hxm9c9C6IXnrLUCenpubjXibHO+qs1lbUM6Q1QWqRSG63duLoqg3l/J
         btkOZY2Wpv7Cc9rubqu0ZvjPkd3sNWnXwatCM18GDI0NTO8byjdcf0/YRcm6pWudHEZN
         eGwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uGJypVP0LSdHJsPF64m+oQSB4IwFYdW+hk4M0oJYwes=;
        b=bqipQoNO2H0TZ4196ID6PauSInUw8qS8ngaxxio2mhk/rxaWk1zAmw0AXFlniEOrdL
         RVtiAeBXgTu/HLuI8ZEighuOD0HapkNo8ZDzexGsyy/yJJnSVPqEQQnBABGN7buMqkvH
         Q2a38ydjxkXU4GjFvOLMNjOSJ+7PnxLZqLOR2hQlrPNdtlXDMtHGClFoIJv1Uk6/NB2Q
         6rVu6cRB5Fn3uEF6Fi/jlSLasNCzqIHflxCMWjYIM4uqpdlEuyDdIN63TI7PKBYKG9v9
         pjzJn8ubl4H+cw7z+3uUf6+IYMypFhlklo6RmWCTewuAh0bVLYc/86wN9OVtAuXOC2Q8
         OA7A==
X-Gm-Message-State: AOAM5319sldl9fmfyFcD/JSWmsQP4GkgwJdZbOf/TLS0bQsTLwyT60Y9
        g/if771d5Fz/WNo5FmI8fHNwWM62GZQ=
X-Google-Smtp-Source: ABdhPJxW6Z0qeV4/am30zOoxP4qEZJlGMg3Y4+CksXz061SxJHsQDQGkWjBufCp+XdJRNRkwAtJqmg==
X-Received: by 2002:a17:902:8bc4:b029:12b:8470:e29e with SMTP id r4-20020a1709028bc4b029012b8470e29emr7184862plo.2.1634245023938;
        Thu, 14 Oct 2021 13:57:03 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id o14sm3279225pfh.145.2021.10.14.13.57.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 13:57:03 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v3 5/8] libbpf: Use O_CLOEXEC uniformly when opening fds
Date:   Fri, 15 Oct 2021 02:26:41 +0530
Message-Id: <20211014205644.1837280-6-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211014205644.1837280-1-memxor@gmail.com>
References: <20211014205644.1837280-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4473; h=from:subject; bh=FKKozzSHJ71MClmNbogdMEPIOs+69DDD1f21NC0pk00=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhaJk/2XqnJ+Sb8y6Em5Rd9293CWcKWIt4nFJISFyG RI7pK9aJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYWiZPwAKCRBM4MiGSL8Ryq36D/ 0WJHGn/6RMUAZ6vVZ42WKx+eix9+BHGDcccSh1s3h2wrOU9grzAKNTHf3EihaJ2SGSP+4mWXCFoGVW zVWI5GQMFdekfZNpHwmjV5PxXpHAGfJEgz/t2XLsOeVCIAYcRsP/hcVFA8trzeOBpkll3BfjCzNKog kvQ0StJgdmnQeQmRtQi35qIJpRtLZRBXJNJOILZpOF8fPTWrPzmkruC1AubomG136yTbIH7AwZxfvq jaw7a5xUPp+ddh+7DNev4P1ify/lOtM4gTxiT/M8b9B1Vo32ybLEaF/iVIw0loo4yY7Im4VYp01AD9 8VjPSgOAGGuZOhZ2BSJlWvt13hgyMdJlCuRwLFLZJxnH8SMUJCEOX9SmDD8T9lBSmauOnWqZCxj5q8 W94Hc/R59EwdF0B2lzX14d6fGYUKZ3rmmfdr22/8a+qRNtWtOc7dmW1HzaZc5IU5s7s8pmR9O3V7+3 el7vI6geim7X01fWA0wGdUEWB6euxLJU2HMz8Lf0Vweo30Ntd5v2b12TAjJaRbKXqFs2PAIjgvBWyZ rnGwifAIOR1RXDXRIvTkZN1kGYgrSwwb8hOVCf00aWSVv3IXv919yvKYy691mSEdyPifJCWMBodiYB F1ZM1ZIndoqRLjfd0u+UfJNIINtzzhDNbKOm3pCSfqlBoE+BoSNJgh4SwRcg==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are some instances where we don't use O_CLOEXEC when opening an
fd, fix these up. Otherwise, it is possible that a parallel fork causes
these fds to leak into a child process on execve.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/lib/bpf/btf.c           | 2 +-
 tools/lib/bpf/libbpf.c        | 6 +++---
 tools/lib/bpf/libbpf_probes.c | 2 +-
 tools/lib/bpf/linker.c        | 4 ++--
 tools/lib/bpf/xsk.c           | 6 +++---
 5 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 60fbd1c6d466..06a7a4e52134 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -886,7 +886,7 @@ static struct btf *btf_parse_elf(const char *path, struct btf *base_btf,
 		return ERR_PTR(-LIBBPF_ERRNO__LIBELF);
 	}
 
-	fd = open(path, O_RDONLY);
+	fd = open(path, O_RDONLY | O_CLOEXEC);
 	if (fd < 0) {
 		err = -errno;
 		pr_warn("failed to open %s: %s\n", path, strerror(errno));
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 0a5ff7f2d16d..e7d8bb34f58c 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1223,7 +1223,7 @@ static int bpf_object__elf_init(struct bpf_object *obj)
 		obj->efile.elf = elf_memory((char *)obj->efile.obj_buf,
 					    obj->efile.obj_buf_sz);
 	} else {
-		obj->efile.fd = ensure_good_fd(open(obj->path, O_RDONLY));
+		obj->efile.fd = ensure_good_fd(open(obj->path, O_RDONLY | O_CLOEXEC));
 		if (obj->efile.fd < 0) {
 			char errmsg[STRERR_BUFSIZE], *cp;
 
@@ -9331,7 +9331,7 @@ static int append_to_file(const char *file, const char *fmt, ...)
 	int fd, n, err = 0;
 	va_list ap;
 
-	fd = open(file, O_WRONLY | O_APPEND, 0);
+	fd = open(file, O_WRONLY | O_APPEND | O_CLOEXEC, 0);
 	if (fd < 0)
 		return -errno;
 
@@ -10976,7 +10976,7 @@ int parse_cpu_mask_file(const char *fcpu, bool **mask, int *mask_sz)
 	int fd, err = 0, len;
 	char buf[128];
 
-	fd = open(fcpu, O_RDONLY);
+	fd = open(fcpu, O_RDONLY | O_CLOEXEC);
 	if (fd < 0) {
 		err = -errno;
 		pr_warn("Failed to open cpu mask file %s: %d\n", fcpu, err);
diff --git a/tools/lib/bpf/libbpf_probes.c b/tools/lib/bpf/libbpf_probes.c
index cd8c703dde71..68f2dbf364aa 100644
--- a/tools/lib/bpf/libbpf_probes.c
+++ b/tools/lib/bpf/libbpf_probes.c
@@ -33,7 +33,7 @@ static int get_vendor_id(int ifindex)
 
 	snprintf(path, sizeof(path), "/sys/class/net/%s/device/vendor", ifname);
 
-	fd = open(path, O_RDONLY);
+	fd = open(path, O_RDONLY | O_CLOEXEC);
 	if (fd < 0)
 		return -1;
 
diff --git a/tools/lib/bpf/linker.c b/tools/lib/bpf/linker.c
index 6106a0b5572a..f993706eff77 100644
--- a/tools/lib/bpf/linker.c
+++ b/tools/lib/bpf/linker.c
@@ -302,7 +302,7 @@ static int init_output_elf(struct bpf_linker *linker, const char *file)
 	if (!linker->filename)
 		return -ENOMEM;
 
-	linker->fd = ensure_good_fd(open(file, O_WRONLY | O_CREAT | O_TRUNC, 0644));
+	linker->fd = ensure_good_fd(open(file, O_WRONLY | O_CREAT | O_TRUNC | O_CLOEXEC, 0644));
 	if (linker->fd < 0) {
 		err = -errno;
 		pr_warn("failed to create '%s': %d\n", file, err);
@@ -557,7 +557,7 @@ static int linker_load_obj_file(struct bpf_linker *linker, const char *filename,
 
 	obj->filename = filename;
 
-	obj->fd = open(filename, O_RDONLY);
+	obj->fd = open(filename, O_RDONLY | O_CLOEXEC);
 	if (obj->fd < 0) {
 		err = -errno;
 		pr_warn("failed to open file '%s': %d\n", filename, err);
diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index a2111696ba91..81f8fbc85e70 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -300,7 +300,7 @@ int xsk_umem__create_v0_0_4(struct xsk_umem **umem_ptr, void *umem_area,
 	if (!umem)
 		return -ENOMEM;
 
-	umem->fd = socket(AF_XDP, SOCK_RAW, 0);
+	umem->fd = socket(AF_XDP, SOCK_RAW | SOCK_CLOEXEC, 0);
 	if (umem->fd < 0) {
 		err = -errno;
 		goto out_umem_alloc;
@@ -549,7 +549,7 @@ static int xsk_get_max_queues(struct xsk_socket *xsk)
 	struct ifreq ifr = {};
 	int fd, err, ret;
 
-	fd = socket(AF_LOCAL, SOCK_DGRAM, 0);
+	fd = socket(AF_LOCAL, SOCK_DGRAM | SOCK_CLOEXEC, 0);
 	if (fd < 0)
 		return -errno;
 
@@ -1046,7 +1046,7 @@ int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
 	}
 
 	if (umem->refcount++ > 0) {
-		xsk->fd = socket(AF_XDP, SOCK_RAW, 0);
+		xsk->fd = socket(AF_XDP, SOCK_RAW | SOCK_CLOEXEC, 0);
 		if (xsk->fd < 0) {
 			err = -errno;
 			goto out_xsk_alloc;
-- 
2.33.0

