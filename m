Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14E872968DB
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 05:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S374960AbgJWDja (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 23:39:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28595 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S374956AbgJWDj3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 23:39:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603424367;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M7X83YXQrTBsbNhEbcdOm/nIWlpTd9yUgaPY4aMl/O4=;
        b=CwOeH3ENTztRZDSy7S8czrec/oCKk8ZFbT59jqVE1E+Zr8h74FAdCeNuiye4PwWtbFXORL
        PJMWonwvKGI+w2DeuL0MJh1AFMvCAQh+VAEkIXrSbyDWb6WKstHvuPx6EDS5FiCw2ucjBK
        imc5MbARYuiDe8L5aCHUlQ9C1JRqXwM=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-195-zzKKfVzYPgm_HpSoD9duLw-1; Thu, 22 Oct 2020 23:39:26 -0400
X-MC-Unique: zzKKfVzYPgm_HpSoD9duLw-1
Received: by mail-pl1-f198.google.com with SMTP id h1so163306pll.10
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 20:39:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=M7X83YXQrTBsbNhEbcdOm/nIWlpTd9yUgaPY4aMl/O4=;
        b=Xf9SeISoTh2DtvI8ca5QS4yvljF7D+gXCkyRXzldgkFBKe4xkjsrVxoFhh0SO1/30F
         uKpB0Vld1SO9bZO1Jm8+jZPDIZ+8+nILO5YrrjIIyxKRqtK86okpfyBKF3xqxYh5bI+d
         A5GTO3fyejuEOCS3B2HY9cKtXhdMBSQvw2KUcKcPMgPwtcyLZt3r+lje1BIIHOHjFtFp
         oNc2zKeKHrEPuTfoOOoE9rT8MetH5doBotfka/PgU/EmVm4kdyRJFdJ0Iz0IrmW1DYgt
         2KBY3NcxwsIhOTNYkKhGd1lqaSUdJKsA4CzMXH/tvkWhH3xD/MASsTt/xBWtpZfYhhWJ
         VYHg==
X-Gm-Message-State: AOAM530/BZMVV0JsJozjIUcTtoXl/FwHoYvA8zZnj2DfOlRcmP9M0STr
        1i9eeNVALpGXW+eTDSh2UGhS0xbhkU4uPunKw+P4HVazq2ffWrszGGOPsgoYx4HXmmnjHBog+w7
        BV/UfEGTCA2J3I/0=
X-Received: by 2002:a17:90a:ec0c:: with SMTP id l12mr252280pjy.28.1603424365154;
        Thu, 22 Oct 2020 20:39:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxcRUn/glA9TRTzKrnRqfKZFDiZ3Xu+FZlXvWDtlcHwvo1DW0RP9TkJFBkK3HbwpbbYXbs47Q==
X-Received: by 2002:a17:90a:ec0c:: with SMTP id l12mr252260pjy.28.1603424364979;
        Thu, 22 Oct 2020 20:39:24 -0700 (PDT)
Received: from localhost.localdomain.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e23sm185442pfi.191.2020.10.22.20.39.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2020 20:39:24 -0700 (PDT)
From:   Hangbin Liu <haliu@redhat.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Ahern <dsahern@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Hangbin Liu <haliu@redhat.com>
Subject: [PATCH iproute2-next 2/5] lib: rename bpf.c to bpf_legacy.c
Date:   Fri, 23 Oct 2020 11:38:52 +0800
Message-Id: <20201023033855.3894509-3-haliu@redhat.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201023033855.3894509-1-haliu@redhat.com>
References: <20201023033855.3894509-1-haliu@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a preparation for later libbpf support in iproute2. Function
bpf_prog_load() is also renamed to bpf_prog_load_buf() as there is a
conflict with libbpf.

Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Hangbin Liu <haliu@redhat.com>
---
 include/bpf_util.h          | 6 +++---
 ip/ipvrf.c                  | 4 ++--
 lib/Makefile                | 2 +-
 lib/{bpf.c => bpf_legacy.c} | 6 +++---
 4 files changed, 9 insertions(+), 9 deletions(-)
 rename lib/{bpf.c => bpf_legacy.c} (99%)

diff --git a/include/bpf_util.h b/include/bpf_util.h
index 63db07ca..72d3a32c 100644
--- a/include/bpf_util.h
+++ b/include/bpf_util.h
@@ -274,9 +274,9 @@ int bpf_trace_pipe(void);
 
 void bpf_print_ops(struct rtattr *bpf_ops, __u16 len);
 
-int bpf_prog_load(enum bpf_prog_type type, const struct bpf_insn *insns,
-		  size_t size_insns, const char *license, char *log,
-		  size_t size_log);
+int bpf_prog_load_buf(enum bpf_prog_type type, const struct bpf_insn *insns,
+		      size_t size_insns, const char *license, char *log,
+		      size_t size_log);
 
 int bpf_prog_attach_fd(int prog_fd, int target_fd, enum bpf_attach_type type);
 int bpf_prog_detach_fd(int target_fd, enum bpf_attach_type type);
diff --git a/ip/ipvrf.c b/ip/ipvrf.c
index 28dd8e25..33150ac2 100644
--- a/ip/ipvrf.c
+++ b/ip/ipvrf.c
@@ -256,8 +256,8 @@ static int prog_load(int idx)
 		BPF_EXIT_INSN(),
 	};
 
-	return bpf_prog_load(BPF_PROG_TYPE_CGROUP_SOCK, prog, sizeof(prog),
-			     "GPL", bpf_log_buf, sizeof(bpf_log_buf));
+	return bpf_prog_load_buf(BPF_PROG_TYPE_CGROUP_SOCK, prog, sizeof(prog),
+			         "GPL", bpf_log_buf, sizeof(bpf_log_buf));
 }
 
 static int vrf_configure_cgroup(const char *path, int ifindex)
diff --git a/lib/Makefile b/lib/Makefile
index 7cba1857..a326fb9f 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -5,7 +5,7 @@ CFLAGS += -fPIC
 
 UTILOBJ = utils.o rt_names.o ll_map.o ll_types.o ll_proto.o ll_addr.o \
 	inet_proto.o namespace.o json_writer.o json_print.o \
-	names.o color.o bpf.o exec.o fs.o cg_map.o
+	names.o color.o bpf_legacy.o exec.o fs.o cg_map.o
 
 NLOBJ=libgenl.o libnetlink.o
 
diff --git a/lib/bpf.c b/lib/bpf_legacy.c
similarity index 99%
rename from lib/bpf.c
rename to lib/bpf_legacy.c
index c7d45077..2e6e0602 100644
--- a/lib/bpf.c
+++ b/lib/bpf_legacy.c
@@ -1109,9 +1109,9 @@ static int bpf_prog_load_dev(enum bpf_prog_type type,
 	return bpf(BPF_PROG_LOAD, &attr, sizeof(attr));
 }
 
-int bpf_prog_load(enum bpf_prog_type type, const struct bpf_insn *insns,
-		  size_t size_insns, const char *license, char *log,
-		  size_t size_log)
+int bpf_prog_load_buf(enum bpf_prog_type type, const struct bpf_insn *insns,
+		      size_t size_insns, const char *license, char *log,
+		      size_t size_log)
 {
 	return bpf_prog_load_dev(type, insns, size_insns, license, 0,
 				 log, size_log);
-- 
2.25.4

