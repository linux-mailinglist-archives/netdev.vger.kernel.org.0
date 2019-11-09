Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09CDBF5C20
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 01:01:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729973AbfKIABI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 19:01:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9196 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729674AbfKIABE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 19:01:04 -0500
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com [209.85.167.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0B424BDF9
        for <netdev@vger.kernel.org>; Sat,  9 Nov 2019 00:01:04 +0000 (UTC)
Received: by mail-lf1-f72.google.com with SMTP id t6so1613027lfd.13
        for <netdev@vger.kernel.org>; Fri, 08 Nov 2019 16:01:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=gBaL1gtNlBDHhfBJ4Xqo3UQIQzWjMYYMJE/uEoQa9aA=;
        b=tRCdammKcQtpZ4WKMmUi1TPPyPj4EY7I1TzGrjAHHb939vW7r2oEV77FnEKLYhNTHm
         dc4jGCP2CXRPDSJP+Qvb03CNwBVwrgs3wxsyCsvYmwNEZHQXsqB9USoQ/2fNAVRPOaRn
         WDNVjAAhym3o5sXE+YnxdrnhWVYXQon+zfTeOBmkzHCL6PyYKUvRh+phcKlin0xIJfrx
         cXpeVlf7JUdWHuvvrz/i232jXVMQr1J8PMbyecOQpe/KEzHgl+ZWXk7fx0QPfobL2LTx
         VFVTJmORTgqRXkmhCpDpYTE/7SCfRc5pvd29C65qen8f+334K5QbgVdyrV1ftn5S4N5v
         AWRw==
X-Gm-Message-State: APjAAAW8H7BxMboabVBVRMjlmjKGrdLrudFLDDHvc3ibVqWmRs4T7t10
        h8LdzrVJNi5WcVVQNYbsTGIK8PvJZ1DlIwTyXVfjxu81ucnvTv9A/gzQ6sqiBuQ+EvstHcRD4TP
        LwDBw8jmg+iTnXkNP
X-Received: by 2002:a05:6512:21e:: with SMTP id a30mr2371092lfo.175.1573257662578;
        Fri, 08 Nov 2019 16:01:02 -0800 (PST)
X-Google-Smtp-Source: APXvYqzQYw9LHnlYyKFmDhvnamzpaLMngZPgAjZnCVoyZTROq3L5Agisuanq3gPGoyCMuiUGtz5Fsw==
X-Received: by 2002:a05:6512:21e:: with SMTP id a30mr2371078lfo.175.1573257662427;
        Fri, 08 Nov 2019 16:01:02 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id m12sm3019890lfb.60.2019.11.08.16.01.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2019 16:01:01 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 4530B1800CC; Sat,  9 Nov 2019 01:01:01 +0100 (CET)
Subject: [PATCH bpf-next v3 6/6] libbpf: Add getter for program size
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Sat, 09 Nov 2019 01:01:01 +0100
Message-ID: <157325766119.27401.7134121980544613977.stgit@toke.dk>
In-Reply-To: <157325765467.27401.1930972466188738545.stgit@toke.dk>
References: <157325765467.27401.1930972466188738545.stgit@toke.dk>
User-Agent: StGit/0.21
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

This adds a new getter for the BPF program size (in bytes). This is useful
for a caller that is trying to predict how much memory will be locked by
loading a BPF object into the kernel.

Acked-by: Andrii Nakryiko <andriin@fb.com>
Acked-by: David S. Miller <davem@davemloft.net>
Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/lib/bpf/libbpf.c   |    5 +++++
 tools/lib/bpf/libbpf.h   |    3 +++
 tools/lib/bpf/libbpf.map |    1 +
 3 files changed, 9 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 094f5c64611a..70fec4a565af 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4782,6 +4782,11 @@ int bpf_program__fd(const struct bpf_program *prog)
 	return bpf_program__nth_fd(prog, 0);
 }
 
+size_t bpf_program__size(const struct bpf_program *prog)
+{
+	return prog->insns_cnt * sizeof(struct bpf_insn);
+}
+
 int bpf_program__set_prep(struct bpf_program *prog, int nr_instances,
 			  bpf_program_prep_t prep)
 {
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index f0947cc949d2..5aa27caad6c2 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -214,6 +214,9 @@ LIBBPF_API void bpf_program__set_ifindex(struct bpf_program *prog,
 LIBBPF_API const char *bpf_program__title(const struct bpf_program *prog,
 					  bool needs_copy);
 
+/* returns program size in bytes */
+LIBBPF_API size_t bpf_program__size(const struct bpf_program *prog);
+
 LIBBPF_API int bpf_program__load(struct bpf_program *prog, char *license,
 				 __u32 kern_version);
 LIBBPF_API int bpf_program__fd(const struct bpf_program *prog);
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index d1a782a3a58d..9f39ee06b2d4 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -203,4 +203,5 @@ LIBBPF_0.0.6 {
 		bpf_program__get_type;
 		bpf_program__is_tracing;
 		bpf_program__set_tracing;
+		bpf_program__size;
 } LIBBPF_0.0.5;

