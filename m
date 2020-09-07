Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6AD2603CD
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 19:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728548AbgIGLWR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 7 Sep 2020 07:22:17 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:53210 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728811AbgIGLV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 07:21:56 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-164-jBWXxxlPOsqCyMA0FODBgg-1; Mon, 07 Sep 2020 07:02:47 -0400
X-MC-Unique: jBWXxxlPOsqCyMA0FODBgg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9EA9D18B9EC1;
        Mon,  7 Sep 2020 11:02:45 +0000 (UTC)
Received: from krava.redhat.com (ovpn-112-180.ams2.redhat.com [10.36.112.180])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1F4661A3D7;
        Mon,  7 Sep 2020 11:02:38 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: [PATCH] perf tools: Do not use deprecated bpf_program__title
Date:   Mon,  7 Sep 2020 13:02:37 +0200
Message-Id: <20200907110237.1329532-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jolsa@kernel.org
X-Mimecast-Spam-Score: 0.001
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bpf_program__title function got deprecated in libbpf,
use the suggested alternative.

Fixes: 521095842027 ("libbpf: Deprecate notion of BPF program "title" in favor of "section name"")
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/bpf-loader.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/bpf-loader.c b/tools/perf/util/bpf-loader.c
index 2feb751516ab..73de3973c8ec 100644
--- a/tools/perf/util/bpf-loader.c
+++ b/tools/perf/util/bpf-loader.c
@@ -328,7 +328,7 @@ config_bpf_program(struct bpf_program *prog)
 	probe_conf.no_inlines = false;
 	probe_conf.force_add = false;
 
-	config_str = bpf_program__title(prog, false);
+	config_str = bpf_program__section_name(prog);
 	if (IS_ERR(config_str)) {
 		pr_debug("bpf: unable to get title for program\n");
 		return PTR_ERR(config_str);
@@ -454,7 +454,7 @@ preproc_gen_prologue(struct bpf_program *prog, int n,
 	if (err) {
 		const char *title;
 
-		title = bpf_program__title(prog, false);
+		title = bpf_program__section_name(prog);
 		if (!title)
 			title = "[unknown]";
 
-- 
2.26.2

