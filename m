Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C08D2AB199
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 08:09:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729650AbgKIHJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 02:09:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60686 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728951AbgKIHJQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 02:09:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604905754;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2wjlxhJNJX6q85v1x1b4SdM4od9GwiPjqobsc3U1ceo=;
        b=ZLRBMl8NopdRxAn3QU6m9fhG6D94Feom/rJ9HcR3rpLVki0875490daUHqR9mRbIU/YKvP
        X4FIytkwuHYIZiiZNoatp46MuaBE5PSEWd6/KQkVu27e0EZo9C4Uwd5jyOIAIkRuF6xAwX
        C6wmUPjaBj/MoeDWTMvu6d3yA6/GOj4=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-97-tmoQ6DO9MK6q4szphPTf5w-1; Mon, 09 Nov 2020 02:09:12 -0500
X-MC-Unique: tmoQ6DO9MK6q4szphPTf5w-1
Received: by mail-pl1-f198.google.com with SMTP id g2so3540728plg.1
        for <netdev@vger.kernel.org>; Sun, 08 Nov 2020 23:09:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2wjlxhJNJX6q85v1x1b4SdM4od9GwiPjqobsc3U1ceo=;
        b=mVuE+y2Ordi6EHefpFHt9OqcoGjv/TQw91PJF2PHsLMdGE+9t6rjw3HA5hWZdR+KCl
         /6qjX6SG/IDPdFnHrZellxH5aRX+Z5K8NMj0D+4l988rOuTil65tluyoCZUI2QCKf1W0
         PMW1+XyFpfax7kTjcaTORL4dSn1b4eP25n1FxcAFVZczZQmKv9x54G50p0tJoSIexQml
         LOoiipA8YmDH97fgtke9x6p8Uol0MGQHHZVTJUjXA6915yGO1j7soBW6hSlPuo1MUfGN
         Ct9L5s6wxZ+QU1bFmkMAs2Y5A01e1yKJYQr95mXW6UHulcyBaIo8M5ZojIF8cQ3rbvg3
         Eswg==
X-Gm-Message-State: AOAM533YmEGyhhp2YOK6tB6ZykSw9A1iOTeKNTCbFiuI7Q+YOpQoSD71
        IIZDQyaDd2dhDBSuORleU8gJ/4s+4Vz6j4ftMEi9HUOcBw/94bAKIyCyuifmSKmKa2GEJHb4zHJ
        xpgzJfYrFohdV+yQ=
X-Received: by 2002:a17:902:8685:b029:d7:bb:aa2 with SMTP id g5-20020a1709028685b02900d700bb0aa2mr11433824plo.13.1604905750981;
        Sun, 08 Nov 2020 23:09:10 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwbKAyOwrePJDSDko8yA3wWfUcx8GyndtnLQ9Jylh28aPIJHbtD5vznd0exoOgxZO7KpUeOjw==
X-Received: by 2002:a17:902:8685:b029:d7:bb:aa2 with SMTP id g5-20020a1709028685b02900d700bb0aa2mr11433814plo.13.1604905750758;
        Sun, 08 Nov 2020 23:09:10 -0800 (PST)
Received: from localhost.localdomain.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f17sm2492483pfk.70.2020.11.08.23.09.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2020 23:09:10 -0800 (PST)
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
Subject: [PATCHv4 iproute2-next 2/5] lib: rename bpf.c to bpf_legacy.c
Date:   Mon,  9 Nov 2020 15:07:59 +0800
Message-Id: <20201109070802.3638167-3-haliu@redhat.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201109070802.3638167-1-haliu@redhat.com>
References: <20201029151146.3810859-1-haliu@redhat.com>
 <20201109070802.3638167-1-haliu@redhat.com>
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

v4: Add new file bpf_glue.c to for libbpf/legacy mixed bpf calls.
v2-v3: no update

Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Hangbin Liu <haliu@redhat.com>
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
index 7cba1857..c9502f6a 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -5,7 +5,7 @@ CFLAGS += -fPIC
 
 UTILOBJ = utils.o rt_names.o ll_map.o ll_types.o ll_proto.o ll_addr.o \
 	inet_proto.o namespace.o json_writer.o json_print.o \
-	names.o color.o bpf.o exec.o fs.o cg_map.o
+	names.o color.o bpf_legacy.o bpf_glue.o exec.o fs.o cg_map.o
 
 NLOBJ=libgenl.o libnetlink.o
 
diff --git a/lib/bpf_glue.c b/lib/bpf_glue.c
new file mode 100644
index 00000000..7626a893
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
+	return bpf_load_load_dev(type, insns, size_insns, license, 0, log, size_log);
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

