Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32427F59F9
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 22:34:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732632AbfKHVdS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 16:33:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33560 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732435AbfKHVdO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 16:33:14 -0500
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com [209.85.167.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 814F059445
        for <netdev@vger.kernel.org>; Fri,  8 Nov 2019 21:33:14 +0000 (UTC)
Received: by mail-lf1-f69.google.com with SMTP id i25so9237lfo.4
        for <netdev@vger.kernel.org>; Fri, 08 Nov 2019 13:33:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=GBjYCkvy2GbEH7Q23GeY3ESuFtUK5AcyN8OZ2vuJJlc=;
        b=SiCvDxkpp85FeVP9MLTIfM8MNqgUDAFSFIafAeLHBxo20/fGC+cSpV2ftw4YflbGQu
         pKY8Sj7oNo0jKJoUmv1tiSZETujrIHKUpCvOH9+2wngYAKQHlIh93YiVAVlUB2mmQP0z
         9TrBZzzQc9785kU98DRLM8IAnE4N291h9pGXiw+8uMQy72EN1YsoV7uc0QSQ7D3j8uOF
         Mohpg7aB+aLjLqwFJDZDpiqYYg4dCQQZU6qoWMn7N32gwViAoHO7J/osks7jLgRYGRIN
         wFG5EyVFVscQSTIa+OPffiPyaCZTYDrYtKlgUZl67t3BYlEGyLmGi9yNUrIfKK21cKeS
         pKyQ==
X-Gm-Message-State: APjAAAV1CAUKnr3k5rO4TimrhoZ9kWdQloFX8jxYv/VfpjIxOVVY1IqO
        aMgbLGaORkayu+C3DviYovCt0B/D6O7MZa372jtdxfqGRwc0FB0vUQVA491+ZKjgBb9nJXB3HAk
        claWW4pqaWmdV59pJ
X-Received: by 2002:ac2:5b1d:: with SMTP id v29mr7905209lfn.54.1573248793074;
        Fri, 08 Nov 2019 13:33:13 -0800 (PST)
X-Google-Smtp-Source: APXvYqyctTL3kNwz/34TK8mIxExHhHL9/rEa+UQvCWQxPGhApNLDQroCsBY/4KDberzmnIS0GFFUkQ==
X-Received: by 2002:ac2:5b1d:: with SMTP id v29mr7905193lfn.54.1573248792938;
        Fri, 08 Nov 2019 13:33:12 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id c19sm2977825ljj.61.2019.11.08.13.33.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2019 13:33:12 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id CD3C91800BD; Fri,  8 Nov 2019 22:33:11 +0100 (CET)
Subject: [PATCH bpf-next v2 6/6] libbpf: Add getter for program size
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Fri, 08 Nov 2019 22:33:11 +0100
Message-ID: <157324879178.910124.2574532467255490597.stgit@toke.dk>
In-Reply-To: <157324878503.910124.12936814523952521484.stgit@toke.dk>
References: <157324878503.910124.12936814523952521484.stgit@toke.dk>
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

Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/lib/bpf/libbpf.c   |    5 +++++
 tools/lib/bpf/libbpf.h   |    1 +
 tools/lib/bpf/libbpf.map |    1 +
 3 files changed, 7 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 582c0fd16697..facd5e1a3a0b 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4790,6 +4790,11 @@ int bpf_program__fd(const struct bpf_program *prog)
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
index f0947cc949d2..10875dc68ec8 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -213,6 +213,7 @@ LIBBPF_API void bpf_program__set_ifindex(struct bpf_program *prog,
 
 LIBBPF_API const char *bpf_program__title(const struct bpf_program *prog,
 					  bool needs_copy);
+LIBBPF_API size_t bpf_program__size(const struct bpf_program *prog);
 
 LIBBPF_API int bpf_program__load(struct bpf_program *prog, char *license,
 				 __u32 kern_version);
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

