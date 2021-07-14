Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD783C81FA
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 11:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238969AbhGNJrq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 05:47:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51600 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238906AbhGNJrq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 05:47:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626255894;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gS2TUzSMuzLBnMpE+3kD0qi4Lo6QsgvFke4iFwk++og=;
        b=QZXZz3j58JpAMQE8T8mWZn6v8mF8ZlkEtKSwBsC9lUiOCiWfLZFwq6CQDfC/ieHqp48GXa
        8p2I9/MRvT7l4U/FNk8HlnNtCSOzP5L5nymoTGBcQXLsrYVLnPUKEt28+VSA1KN4tKpeuf
        Jk2YwVN7WpN6mLFvFKXhs8KqZZOVIzM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-79-hUzKVF_rOv29SWAWcIK98A-1; Wed, 14 Jul 2021 05:44:53 -0400
X-MC-Unique: hUzKVF_rOv29SWAWcIK98A-1
Received: by mail-wm1-f70.google.com with SMTP id j141-20020a1c23930000b0290212502cb19aso574417wmj.0
        for <netdev@vger.kernel.org>; Wed, 14 Jul 2021 02:44:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gS2TUzSMuzLBnMpE+3kD0qi4Lo6QsgvFke4iFwk++og=;
        b=Ja0D8neR6Vt2em3q5zUzfyeaebjDRTQLj0HlfoWgVBUR9TgBgUMLFIwDE3Uynj/3QS
         TuvltIaX5oD9PBkadal+uctOdqPP6Ks1foTh+cn1LVd/sW8FAF91Sp4d9hhBfhybnz8u
         LCooLyc5d4iO2ciugCh5kzDKFzxD8QnO1QRzCIazaCDoGYS1i3tvhzsxONBAHS0gJ7fE
         9kIzML4789pOKJuGVRJ/D2P/YTzZ7RsmhMTbamLae4xsTCYNZPgso4EPkGKforj9+neD
         iv0Yt83fkP7Dej7nljEzQx2AC3FuiTpH+DdGNjmuDEnimZ+eFONmsQszL5PGmUDv1jKv
         NiTA==
X-Gm-Message-State: AOAM531jKM57nyVT6SiT6sz0JrhgTjM6620CuCyIlP5WYGMYw3T7kXxH
        Rr3sy7aXrsTF5eh5VJrT1G4hs6DybZ3hhhrlIgSgtvVnOezzRI5KJyWw5zbxUMlbfNbWvgDa0fi
        /sOoV3GcjZ0FYsPJS
X-Received: by 2002:a5d:58d6:: with SMTP id o22mr12007028wrf.307.1626255892109;
        Wed, 14 Jul 2021 02:44:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzopcNaGLLt7E6TkmR1jeyOlECEvn3WL1uHMzljuZ/xIarhd2afZNQp9cQ7vRgN7IuLJj4GGQ==
X-Received: by 2002:a5d:58d6:: with SMTP id o22mr12007013wrf.307.1626255891909;
        Wed, 14 Jul 2021 02:44:51 -0700 (PDT)
Received: from krava.redhat.com ([5.171.203.6])
        by smtp.gmail.com with ESMTPSA id a64sm1511979wme.8.2021.07.14.02.44.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 02:44:51 -0700 (PDT)
From:   Jiri Olsa <jolsa@redhat.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCHv4 bpf-next 6/8] libbpf: Add bpf_program__attach_kprobe_opts function
Date:   Wed, 14 Jul 2021 11:43:58 +0200
Message-Id: <20210714094400.396467-7-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210714094400.396467-1-jolsa@kernel.org>
References: <20210714094400.396467-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding bpf_program__attach_kprobe_opts that does the same
as bpf_program__attach_kprobe, but takes opts argument.

Currently opts struct holds just retprobe bool, but we will
add new field in following patch.

The function is not exported, so there's no need to add
size to the struct bpf_program_attach_kprobe_opts for now.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/lib/bpf/libbpf.c | 34 +++++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 9 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 88b99401040c..d93a6f9408d1 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -10346,19 +10346,24 @@ static int perf_event_open_probe(bool uprobe, bool retprobe, const char *name,
 	return pfd;
 }
 
-struct bpf_link *bpf_program__attach_kprobe(struct bpf_program *prog,
-					    bool retprobe,
-					    const char *func_name)
+struct bpf_program_attach_kprobe_opts {
+	bool retprobe;
+};
+
+static struct bpf_link*
+bpf_program__attach_kprobe_opts(struct bpf_program *prog,
+				const char *func_name,
+				struct bpf_program_attach_kprobe_opts *opts)
 {
 	char errmsg[STRERR_BUFSIZE];
 	struct bpf_link *link;
 	int pfd, err;
 
-	pfd = perf_event_open_probe(false /* uprobe */, retprobe, func_name,
+	pfd = perf_event_open_probe(false /* uprobe */, opts->retprobe, func_name,
 				    0 /* offset */, -1 /* pid */);
 	if (pfd < 0) {
 		pr_warn("prog '%s': failed to create %s '%s' perf event: %s\n",
-			prog->name, retprobe ? "kretprobe" : "kprobe", func_name,
+			prog->name, opts->retprobe ? "kretprobe" : "kprobe", func_name,
 			libbpf_strerror_r(pfd, errmsg, sizeof(errmsg)));
 		return libbpf_err_ptr(pfd);
 	}
@@ -10367,23 +10372,34 @@ struct bpf_link *bpf_program__attach_kprobe(struct bpf_program *prog,
 	if (err) {
 		close(pfd);
 		pr_warn("prog '%s': failed to attach to %s '%s': %s\n",
-			prog->name, retprobe ? "kretprobe" : "kprobe", func_name,
+			prog->name, opts->retprobe ? "kretprobe" : "kprobe", func_name,
 			libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
 		return libbpf_err_ptr(err);
 	}
 	return link;
 }
 
+struct bpf_link *bpf_program__attach_kprobe(struct bpf_program *prog,
+					    bool retprobe,
+					    const char *func_name)
+{
+	struct bpf_program_attach_kprobe_opts opts = {
+		.retprobe = retprobe,
+	};
+
+	return bpf_program__attach_kprobe_opts(prog, func_name, &opts);
+}
+
 static struct bpf_link *attach_kprobe(const struct bpf_sec_def *sec,
 				      struct bpf_program *prog)
 {
+	struct bpf_program_attach_kprobe_opts opts;
 	const char *func_name;
-	bool retprobe;
 
 	func_name = prog->sec_name + sec->len;
-	retprobe = strcmp(sec->sec, "kretprobe/") == 0;
+	opts.retprobe = strcmp(sec->sec, "kretprobe/") == 0;
 
-	return bpf_program__attach_kprobe(prog, retprobe, func_name);
+	return bpf_program__attach_kprobe_opts(prog, func_name, &opts);
 }
 
 struct bpf_link *bpf_program__attach_uprobe(struct bpf_program *prog,
-- 
2.31.1

