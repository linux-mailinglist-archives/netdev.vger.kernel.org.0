Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA4C72C09DE
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 14:19:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731728AbgKWNNi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 08:13:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41472 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388551AbgKWNN2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 08:13:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606137207;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZA6nwB26MLn+tYTLxJodRLjBoMCDEYfGLLzqE2UpdxU=;
        b=EEaCeBaJZGDk6YXjza5Aezz6G24xSYcg3JzbsWIP622ny3blRDJWgu/PTbiF84iFhoP/lL
        qLBFT1TJzhWP/jwwGrM5h8BZH0NS+biw0h4846Eo0Sdj0RYAtwfD6QOaYCmp0/VXZxpiXN
        E/WM2XHXUKyQ2OexFE1Pm0k/dhe1rhQ=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-219-HxsOMBNzNrWsIPwdBrV40Q-1; Mon, 23 Nov 2020 08:13:25 -0500
X-MC-Unique: HxsOMBNzNrWsIPwdBrV40Q-1
Received: by mail-pg1-f199.google.com with SMTP id a27so12451230pga.6
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 05:13:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZA6nwB26MLn+tYTLxJodRLjBoMCDEYfGLLzqE2UpdxU=;
        b=Tq5fMqsasD2kytl9/oupvtTClTwzt2smN++h+8LZkFdxsw4LNxcEW9EWaBnwhwbX7k
         pAgs+OHcJ/KeUc+498l20yy18gRFZIAQ3+WbPc4BF13JsfzrYPHk1KsDbgu/uDghx0dO
         FAvXjJQDMh2JaiDwggCaOi+zWkyWJbUwoCYzux8zS0IduEnLrckjVcxkJrYjKxWg9YES
         dH0NdqbOfHfYP0rtj/+q2e701Xec3qV3ySgYx1zauAlaR6yv/eOOqUBv+pnPYKUAlqDx
         g8t9FCjt9RfK60VGlyqZYTzCCd1/BP6PQjJN0WGmexhhTdweQ0BWHlnTk/RuNag1/aMJ
         B2Zg==
X-Gm-Message-State: AOAM531YtK3NO7IcXLKJ4c7lMXw6iV4kkNVYIoMzGVzp6Ifmsh7sKj8J
        pRef/hHHvAM+tHPXWBed7QzfiB90hvu8QGwARFQ6XU+J1s1T06Sanw9geqAwK2xRpOSefiQglky
        rLjbpP6zdmR16W14=
X-Received: by 2002:a17:902:6b4a:b029:d9:f601:1fd9 with SMTP id g10-20020a1709026b4ab02900d9f6011fd9mr8850491plt.67.1606137204345;
        Mon, 23 Nov 2020 05:13:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzKuU5R4n712A5OmStNkmXIY57+abmjBwK3RnS1B9ZZ+1KZK8YBlltkj1QOMzujbUkz1F81XA==
X-Received: by 2002:a17:902:6b4a:b029:d9:f601:1fd9 with SMTP id g10-20020a1709026b4ab02900d9f6011fd9mr8850461plt.67.1606137204099;
        Mon, 23 Nov 2020 05:13:24 -0800 (PST)
Received: from localhost.localdomain.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 84sm12075505pfu.53.2020.11.23.05.13.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2020 05:13:23 -0800 (PST)
From:   Hangbin Liu <haliu@redhat.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Jiri Benc <jbenc@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Hangbin Liu <haliu@redhat.com>
Subject: [PATCHv6 iproute2-next 2/5] lib: make ipvrf able to use libbpf and fix function name conflicts
Date:   Mon, 23 Nov 2020 21:11:58 +0800
Message-Id: <20201123131201.4108483-3-haliu@redhat.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201123131201.4108483-1-haliu@redhat.com>
References: <20201116065305.1010651-1-haliu@redhat.com>
 <20201123131201.4108483-1-haliu@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are directly calls in libbpf for bpf program load/attach.
So we could just use two wrapper functions for ipvrf and convert
them with libbpf support.

Function bpf_prog_load() is removed as it's conflict with libbpf
function name.

bpf.c is moved to bpf_legacy.c for later main libbpf support in
iproute2.

Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Hangbin Liu <haliu@redhat.com>
---
v6: bpf_glue.c is created in previous patch. So I changed the commit
    description.
v5: Fix bpf_prog_load_dev typo.
v4: Add new file bpf_glue.c
v2-v3: no update
---
 include/bpf_util.h          | 10 +++++++---
 ip/ipvrf.c                  |  6 +++---
 lib/Makefile                |  2 +-
 lib/bpf_glue.c              | 23 +++++++++++++++++++++++
 lib/{bpf.c => bpf_legacy.c} | 15 +++------------
 5 files changed, 37 insertions(+), 19 deletions(-)
 rename lib/{bpf.c => bpf_legacy.c} (99%)

diff --git a/include/bpf_util.h b/include/bpf_util.h
index dee5bb02..3235c34e 100644
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
index a02775a5..7c8a197c 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -5,7 +5,7 @@ CFLAGS += -fPIC
 
 UTILOBJ = utils.o rt_names.o ll_map.o ll_types.o ll_proto.o ll_addr.o \
 	inet_proto.o namespace.o json_writer.o json_print.o \
-	names.o color.o bpf.o bpf_glue.o exec.o fs.o cg_map.o
+	names.o color.o bpf_legacy.o bpf_glue.o exec.o fs.o cg_map.o
 
 NLOBJ=libgenl.o libnetlink.o mnl_utils.o
 
diff --git a/lib/bpf_glue.c b/lib/bpf_glue.c
index 67c41c22..fa609bfe 100644
--- a/lib/bpf_glue.c
+++ b/lib/bpf_glue.c
@@ -5,6 +5,29 @@
  *
  */
 #include "bpf_util.h"
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
 
 #ifdef HAVE_LIBBPF
 static const char *_libbpf_compile_version = LIBBPF_VERSION;
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

