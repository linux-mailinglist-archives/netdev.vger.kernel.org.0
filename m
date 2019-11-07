Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74713F3515
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 17:52:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389612AbfKGQwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 11:52:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47686 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389576AbfKGQw2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Nov 2019 11:52:28 -0500
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com [209.85.167.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9168E7F41F
        for <netdev@vger.kernel.org>; Thu,  7 Nov 2019 16:52:27 +0000 (UTC)
Received: by mail-lf1-f69.google.com with SMTP id d2so609405lfl.12
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 08:52:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=eS9AG5GhdVciImy8yLqbjNDEvN85ekU2j3TOoMU0fV4=;
        b=iqXqEVRD3Y0xIZnFcDs4D1oFyyVCeQzhGMGCyxluKUDqvkcHUJhrPABmM3f0xcwZzZ
         3BT4V4ramfyoTZIsndttaQ/We0zGgksLCqw8e85o/NUp+eT5iLBSOviTfHdyyXV4uBEP
         qq3x0+5dac8k0ZW7lcW8/XVYdmN+IfaRdPJq2TcCVmFjC2zm1ocg3vsQnf+xvkG4G48C
         RmdU/xpJl7SiJHirEmfK2MaKjRJsTbUy2JKVka5/gLHDAEIDtV9Tre3ToZKo+QTLK8Uu
         Ngw+T2kBFysjtWX4MlgxGzqGicvjnetTZi4NYxlmPUnSidYQp7fr4FYZzYk07zFKebiX
         9Z+w==
X-Gm-Message-State: APjAAAUz91fIgBIspc82vE0pGa+r+wHMwA8Q8NJDv7Zy1JBsGrU1Nh0f
        NIgyAXkTHks7SXOnJgS5MRVTUVKOtmkH1O3OtWhJTo49m9PQVZI/7zsdJ3KsJEXrKfWk/qNSd/c
        9/fP4M1dAqBC+N1Bu
X-Received: by 2002:a2e:b5d4:: with SMTP id g20mr3196168ljn.140.1573145546135;
        Thu, 07 Nov 2019 08:52:26 -0800 (PST)
X-Google-Smtp-Source: APXvYqw8cjQUoLmErsn0B9yhisNaE+K0XRTl3kMBuqPdPTNQvVlZi+wOYJQtSwzvDdf8DUCG0YhP1A==
X-Received: by 2002:a2e:b5d4:: with SMTP id g20mr3196157ljn.140.1573145545981;
        Thu, 07 Nov 2019 08:52:25 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id v15sm2800402lfd.36.2019.11.07.08.52.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2019 08:52:25 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id E77B31818B6; Thu,  7 Nov 2019 17:52:24 +0100 (CET)
Subject: [PATCH bpf-next 6/6] libbpf: Add getter for program size
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Thu, 07 Nov 2019 17:52:24 +0100
Message-ID: <157314554482.693412.362818059218610123.stgit@toke.dk>
In-Reply-To: <157314553801.693412.15522462897300280861.stgit@toke.dk>
References: <157314553801.693412.15522462897300280861.stgit@toke.dk>
User-Agent: StGit/0.20
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
index 45f229af2766..f37d949917d2 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -202,5 +202,6 @@ LIBBPF_0.0.6 {
 		bpf_program__get_type;
 		bpf_program__is_tracing;
 		bpf_program__set_tracing;
+		bpf_program__size;
 		bpf_get_link_xdp_info;
 } LIBBPF_0.0.5;

