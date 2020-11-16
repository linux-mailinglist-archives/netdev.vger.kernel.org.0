Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 563452B3D5F
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 07:55:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727426AbgKPGxy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 01:53:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36719 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727106AbgKPGxx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 01:53:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605509631;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dDNtQjVIU7wRwDrgYZZs8BZFkND34kEKD/GLlelsLBo=;
        b=QfHskQSHtOIJfa8btExua0M7btYUrN5DnddXsT+9hmJ9pS6QNAof9yaP5eDcn6HdIBzwtd
        7vjD1zTc76E3VG5Pad2pwFynHoD5T5cgnN83J9kR+NQETfHeGwpL8dyjJAPmSHMyGiQYNL
        MvxmcabHYgETTqwqXTzgAq2MeO0GajQ=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-576-Jvh7mighOBal_ZtmDtOjsA-1; Mon, 16 Nov 2020 01:53:47 -0500
X-MC-Unique: Jvh7mighOBal_ZtmDtOjsA-1
Received: by mail-pf1-f197.google.com with SMTP id 9so11491586pfn.5
        for <netdev@vger.kernel.org>; Sun, 15 Nov 2020 22:53:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dDNtQjVIU7wRwDrgYZZs8BZFkND34kEKD/GLlelsLBo=;
        b=Evl3qgQumPeoiqN/qcWDOQCfTFGhYQ/u77i5o1sO8k8Itl15qs5PX172acxbhavCW9
         jUrvRuCJKFZ+W2c25z+pFJ4XHHKXBw7IyTz9fDtVjIBvNG6h2hcy+Hsai+KhWzwAw/Z5
         7Xqf3cApTyErD1ZqC+zVG1luvPUATTSsc+xqatGCi+Q2In8g+yP/+H5LhZENKfambgM6
         lQekHf1pupQwsRt9FeEIbUs83kYCyKAOVkInje9MHSS5qbOeVsEC3tS9QrTRjJPDFAiv
         ctGvnB/2ib+LJdMCn3VVaUbLh/0JNtG/B8v/53Ji3Np6ckY5oicY9XB5C27DDfD3nJg3
         F3QQ==
X-Gm-Message-State: AOAM531xq4y1wwkd3jf4fkBFPZYj70PPMB5cimt3+AWqfq420Wd8011g
        KAyIq1z9x0g8R2hi1URhOq0u0Ccf11n/UtVJfC0ydopq1+FcUy1ZWIBLMU62jDb7XKNhTvJxKsT
        qarhKzv4vr2M6R8k=
X-Received: by 2002:a63:1d12:: with SMTP id d18mr12230121pgd.314.1605509626373;
        Sun, 15 Nov 2020 22:53:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwmaGVu+t7ZbOBx0vFozNp9igw9I29CUKRaFxIWA6fWbP03UpRsV+/2lpujDWWmbV1OOTnHzA==
X-Received: by 2002:a63:1d12:: with SMTP id d18mr12230112pgd.314.1605509626163;
        Sun, 15 Nov 2020 22:53:46 -0800 (PST)
Received: from localhost.localdomain.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 16sm18645837pjf.36.2020.11.15.22.53.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2020 22:53:45 -0800 (PST)
From:   Hangbin Liu <haliu@redhat.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Hangbin Liu <haliu@redhat.com>
Subject: [PATCHv5 iproute2-next 2/5] lib: rename bpf.c to bpf_legacy.c
Date:   Mon, 16 Nov 2020 14:53:02 +0800
Message-Id: <20201116065305.1010651-3-haliu@redhat.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201116065305.1010651-1-haliu@redhat.com>
References: <20201109070802.3638167-1-haliu@redhat.com>
 <20201116065305.1010651-1-haliu@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a preparation for later main libbpf support in iproute2.
bpf.c is moved to bpf_legacy.c first.

A new file bpf_glue.c is added which could call both legacy libbpf code.
There are two wrapper functions added for ipvrf. Function
bpf_prog_load() is removed as it's conflict with libbpf function name.

Signed-off-by: Hangbin Liu <haliu@redhat.com>
---

v5: Fix bpf_prog_load_dev typo.
v4: Add new file bpf_glue.c
v2-v3: no update

---
 include/bpf_util.h          | 10 +++++++---
 ip/ipvrf.c                  |  6 +++---
 lib/Makefile                |  2 +-
 lib/bpf_glue.c              | 35 +++++++++++++++++++++++++++++++++++
 lib/{bpf.c => bpf_legacy.c} | 15 +++------------
 5 files changed, 49 insertions(+), 19 deletions(-)
 create mode 100644 lib/bpf_glue.c
 rename lib/{bpf.c => bpf_legacy.c} (99%)

diff --git a/include/bpf_util.h b/include/bpf_util.h
index 63db07ca..82217cc6 100644
--- a/include/bpf_util.h
+++ b/include/bpf_util.h
@@ -274,12 +274,16 @@ int bpf_trace_pipe(void);
 
 void bpf_print_ops(struct rtattr *bpf_ops, __u16 len);
 
-int bpf_prog_load(enum bpf_prog_type type, const struct bpf_insn *insns,
-		  size_t size_insns, const char *license, char *log,
-		  size_t size_log);
+int bpf_prog_load_dev(enum bpf_prog_type type, const struct bpf_insn *insns,
+		      size_t size_insns, const char *license, __u32 ifindex,
+		      char *log, size_t size_log);
+int bpf_program_load(enum bpf_prog_type type, const struct bpf_insn *insns,
+		     size_t size_insns, const char *license, char *log,
+		     size_t size_log);
 
 int bpf_prog_attach_fd(int prog_fd, int target_fd, enum bpf_attach_type type);
 int bpf_prog_detach_fd(int target_fd, enum bpf_attach_type type);
+int bpf_program_attach(int prog_fd, int target_fd, enum bpf_attach_type type);
 
 int bpf_dump_prog_info(FILE *f, uint32_t id);
 
diff --git a/ip/ipvrf.c b/ip/ipvrf.c
index 28dd8e25..42779e5c 100644
--- a/ip/ipvrf.c
+++ b/ip/ipvrf.c
@@ -256,8 +256,8 @@ static int prog_load(int idx)
 		BPF_EXIT_INSN(),
 	};
 
-	return bpf_prog_load(BPF_PROG_TYPE_CGROUP_SOCK, prog, sizeof(prog),
-			     "GPL", bpf_log_buf, sizeof(bpf_log_buf));
+	return bpf_program_load(BPF_PROG_TYPE_CGROUP_SOCK, prog, sizeof(prog),
+			        "GPL", bpf_log_buf, sizeof(bpf_log_buf));
 }
 
 static int vrf_configure_cgroup(const char *path, int ifindex)
@@ -288,7 +288,7 @@ static int vrf_configure_cgroup(const char *path, int ifindex)
 		goto out;
 	}
 
-	if (bpf_prog_attach_fd(prog_fd, cg_fd, BPF_CGROUP_INET_SOCK_CREATE)) {
+	if (bpf_program_attach(prog_fd, cg_fd, BPF_CGROUP_INET_SOCK_CREATE)) {
 		fprintf(stderr, "Failed to attach prog to cgroup: '%s'\n",
 			strerror(errno));
 		goto out;
diff --git a/lib/Makefile b/lib/Makefile
index 13f4ee15..7c8a197c 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -5,7 +5,7 @@ CFLAGS += -fPIC
 
 UTILOBJ = utils.o rt_names.o ll_map.o ll_types.o ll_proto.o ll_addr.o \
 	inet_proto.o namespace.o json_writer.o json_print.o \
-	names.o color.o bpf.o exec.o fs.o cg_map.o
+	names.o color.o bpf_legacy.o bpf_glue.o exec.o fs.o cg_map.o
 
 NLOBJ=libgenl.o libnetlink.o mnl_utils.o
 
diff --git a/lib/bpf_glue.c b/lib/bpf_glue.c
new file mode 100644
index 00000000..fd4fcc94
--- /dev/null
+++ b/lib/bpf_glue.c
@@ -0,0 +1,35 @@
+/*
+ * bpf_glue.c	BPF code to call both legacy and libbpf code
+ *
+ *		This program is free software; you can redistribute it and/or
+ *		modify it under the terms of the GNU General Public License
+ *		as published by the Free Software Foundation; either version
+ *		2 of the License, or (at your option) any later version.
+ *
+ * Authors:	Hangbin Liu <haliu@redhat.com>
+ *
+ */
+#include "bpf_util.h"
+#ifdef HAVE_LIBBPF
+#include <bpf/bpf.h>
+#endif
+
+int bpf_program_load(enum bpf_prog_type type, const struct bpf_insn *insns,
+		     size_t size_insns, const char *license, char *log,
+		     size_t size_log)
+{
+#ifdef HAVE_LIBBPF
+	return bpf_load_program(type, insns, size_insns, license, 0, log, size_log);
+#else
+	return bpf_prog_load_dev(type, insns, size_insns, license, 0, log, size_log);
+#endif
+}
+
+int bpf_program_attach(int prog_fd, int target_fd, enum bpf_attach_type type)
+{
+#ifdef HAVE_LIBBPF
+	return bpf_prog_attach(prog_fd, target_fd, type, 0);
+#else
+	return bpf_prog_attach_fd(prog_fd, target_fd, type);
+#endif
+}
diff --git a/lib/bpf.c b/lib/bpf_legacy.c
similarity index 99%
rename from lib/bpf.c
rename to lib/bpf_legacy.c
index c7d45077..4246fb76 100644
--- a/lib/bpf.c
+++ b/lib/bpf_legacy.c
@@ -1087,10 +1087,9 @@ int bpf_prog_detach_fd(int target_fd, enum bpf_attach_type type)
 	return bpf(BPF_PROG_DETACH, &attr, sizeof(attr));
 }
 
-static int bpf_prog_load_dev(enum bpf_prog_type type,
-			     const struct bpf_insn *insns, size_t size_insns,
-			     const char *license, __u32 ifindex,
-			     char *log, size_t size_log)
+int bpf_prog_load_dev(enum bpf_prog_type type, const struct bpf_insn *insns,
+		      size_t size_insns, const char *license, __u32 ifindex,
+		      char *log, size_t size_log)
 {
 	union bpf_attr attr = {};
 
@@ -1109,14 +1108,6 @@ static int bpf_prog_load_dev(enum bpf_prog_type type,
 	return bpf(BPF_PROG_LOAD, &attr, sizeof(attr));
 }
 
-int bpf_prog_load(enum bpf_prog_type type, const struct bpf_insn *insns,
-		  size_t size_insns, const char *license, char *log,
-		  size_t size_log)
-{
-	return bpf_prog_load_dev(type, insns, size_insns, license, 0,
-				 log, size_log);
-}
-
 #ifdef HAVE_ELF
 struct bpf_elf_prog {
 	enum bpf_prog_type	type;
-- 
2.25.4

