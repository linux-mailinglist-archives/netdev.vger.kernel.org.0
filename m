Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9C429D810
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:29:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387560AbgJ1W3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:29:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45004 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387540AbgJ1W3P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:29:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603924153;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M7X83YXQrTBsbNhEbcdOm/nIWlpTd9yUgaPY4aMl/O4=;
        b=RSW/h4Shwe/6YDwRZu+ODMZ4x9tTXGe39UQKdAITvZlJ6JjlmdPCK8ut4d6eISSR0K/w+1
        r4whAF9ha5AttUjNVafWO/6iiEsLvx5p1yLFAlHDd552AP9T4iiYfne4t18w/zEK62vCG+
        wvkxt4slApwLvrUjPcu0bBq8fAceYuw=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-95-5gvFWTS8NzOqcGDVfW2t8Q-1; Wed, 28 Oct 2020 09:25:56 -0400
X-MC-Unique: 5gvFWTS8NzOqcGDVfW2t8Q-1
Received: by mail-pl1-f199.google.com with SMTP id z11so2762096pln.0
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 06:25:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=M7X83YXQrTBsbNhEbcdOm/nIWlpTd9yUgaPY4aMl/O4=;
        b=hz6OcFessoW7p7VknvWUViGcHvDycwZ2aN/Y1HO4pM7JRqZpQxFTDYK4DlTFfK0lEf
         Dpw3h7oL/CupfmSTz/3czCWTKtu3jL9B/gv8vcLl+8sVIR7YoF8xOi12jd+tI+mWi2/G
         h7aM67qkoqlir+GascYt636frAi6QOVZFahtrU9qdEpdvYmi/3rD/Ri+iBUQGIaPJpH4
         cgWUbHLhdo1KIy4v6zgYEdFiKUV4lpqY9smAM/ty0ykQEPiagBY49/5PlDao/8DbTK1j
         Dv0Va+kJNoYZPY5QeFaUoVZ79V2p+zMh6691HFPffjS/8kXZ+CzKIEO2aAT21Xb1EOE0
         /rYQ==
X-Gm-Message-State: AOAM532LlQiWFHxQ8E3J9qkJErpr1RddxYJLZurgHfA8NoihuuZBzVCE
        7BGHjbQn9yZJuPt36pLk+NDd13uSkK/0nozg+1towR9HxlWtQPpOD/+lFupznREVilQo3wy98fG
        QOiXOg6nHdhqxKCI=
X-Received: by 2002:a17:902:b196:b029:d5:a8fd:9a1c with SMTP id s22-20020a170902b196b02900d5a8fd9a1cmr7808829plr.44.1603891555080;
        Wed, 28 Oct 2020 06:25:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxnG26lrG13uvXWzvksvP/WjF0omLIssQf7/jEiKOuIIt9MIMSdvTi5uvsA7aQ+D9jIQia5dA==
X-Received: by 2002:a17:902:b196:b029:d5:a8fd:9a1c with SMTP id s22-20020a170902b196b02900d5a8fd9a1cmr7808805plr.44.1603891554825;
        Wed, 28 Oct 2020 06:25:54 -0700 (PDT)
Received: from localhost.localdomain.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z20sm6055521pfk.199.2020.10.28.06.25.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 06:25:54 -0700 (PDT)
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
Subject: [PATCHv2 iproute2-next 2/5] lib: rename bpf.c to bpf_legacy.c
Date:   Wed, 28 Oct 2020 21:25:26 +0800
Message-Id: <20201028132529.3763875-3-haliu@redhat.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201028132529.3763875-1-haliu@redhat.com>
References: <20201023033855.3894509-1-haliu@redhat.com>
 <20201028132529.3763875-1-haliu@redhat.com>
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

