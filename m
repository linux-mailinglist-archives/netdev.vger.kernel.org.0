Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EBF627CBE4
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 14:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732945AbgI2Mao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 08:30:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27113 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732676AbgI2Ma1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 08:30:27 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601382626;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Yx/ea/GfmHPWL8/AZcDWYnHv8D4zYuSPVgAI8rje8mc=;
        b=f9eZupf4tbe7f54CX7/xkagQSCjL/g8aTpy7azDpOFU+5dA77iBA834BlgLhuF2BsBHVNj
        RLLgLRnwb1nrm/XLz8CbKavCBdHk1+PndEsSliz32qIz7f3XV0sgLLSm3/SOIOEgtesUR2
        fZhrqj2ksPPecMRIP57GJy8t1pSmosA=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-177-9YDXDMoFOI2TWRluQ2DNSw-1; Tue, 29 Sep 2020 08:30:21 -0400
X-MC-Unique: 9YDXDMoFOI2TWRluQ2DNSw-1
Received: by mail-oi1-f197.google.com with SMTP id 6so1547615oix.6
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 05:30:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Yx/ea/GfmHPWL8/AZcDWYnHv8D4zYuSPVgAI8rje8mc=;
        b=XisAOOLBSGx1vLOmTEwH1lt9aKEOBNvxvj74jbisdx+UzJpzPHw/PEEXyNw1144Nmq
         s8z6c+9rEe49JlAEqi5iJIINXkc9Io7e74XX+XZMgoFHkv6P6KQ5JtcKw8mVvYGCIaEU
         W+ztkwTzj8gQOgZITFfR2ljZKdsmRg7jjo50/JaaYA+tw9rXRElcgk3dEdAtur/qj7Nk
         V0gP42qdYqiAABjL/seuNSpWyq8VlIJcQzO/e53lPae/Nrg8NoImT/51240xDBYC1mca
         IO0mSA54xdfKdXFAwIftdbw1NKA89DdQ6SKUJpc3PeLMf8FeHN18D3Lnp3FX9VAAufsS
         O6SQ==
X-Gm-Message-State: AOAM531OQsrDm5M8NdHl2U3S+1XJnqdfpCIwOjwzZfPckYs2L5mSPMkq
        wCXDMLPenTg1CFeYjeaCX/6EMGK8FnENecm2RXoIUaqvwXZnskvYnl8fJIPynmJoVKC+W0c0Bj4
        1knRIEUc4UbIFMS+6
X-Received: by 2002:a9d:27a1:: with SMTP id c30mr2511810otb.214.1601382620635;
        Tue, 29 Sep 2020 05:30:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzIICgKLq/qlNj6YFc8BhAhxBj7fivF+xND54hI0ZrNSyZOkCIbFVrOXkue/H2mhcZ6CWn3pg==
X-Received: by 2002:a9d:27a1:: with SMTP id c30mr2511791otb.214.1601382620286;
        Tue, 29 Sep 2020 05:30:20 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id x15sm2864828oor.33.2020.09.29.05.30.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 05:30:19 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 927D8183C5B; Tue, 29 Sep 2020 14:30:17 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     daniel@iogearbox.net, ast@fb.com
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH bpf-next] selftests/bpf_iter: don't fail test due to missing __builtin_btf_type_id
Date:   Tue, 29 Sep 2020 14:30:04 +0200
Message-Id: <20200929123004.46694-1-toke@redhat.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The new test for task iteration in bpf_iter checks (in do_btf_read()) if it
should be skipped due to missing __builtin_btf_type_id. However, this
'skip' verdict is not propagated to the caller, so the parent test will
still fail. Fix this by also skipping the rest of the parent test if the
skip condition was reached.

Fixes: b72091bd4ee4 ("selftests/bpf: Add test for bpf_seq_printf_btf helper")
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/testing/selftests/bpf/prog_tests/bpf_iter.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
index af15630a24dd..448885b95eed 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
@@ -172,17 +172,18 @@ static void test_task_file(void)
 
 static char taskbuf[TASKBUFSZ];
 
-static void do_btf_read(struct bpf_iter_task_btf *skel)
+static int do_btf_read(struct bpf_iter_task_btf *skel)
 {
 	struct bpf_program *prog = skel->progs.dump_task_struct;
 	struct bpf_iter_task_btf__bss *bss = skel->bss;
 	int iter_fd = -1, len = 0, bufleft = TASKBUFSZ;
 	struct bpf_link *link;
 	char *buf = taskbuf;
+	int ret = 0;
 
 	link = bpf_program__attach_iter(prog, NULL);
 	if (CHECK(IS_ERR(link), "attach_iter", "attach_iter failed\n"))
-		return;
+		return ret;
 
 	iter_fd = bpf_iter_create(bpf_link__fd(link));
 	if (CHECK(iter_fd < 0, "create_iter", "create_iter failed\n"))
@@ -198,6 +199,7 @@ static void do_btf_read(struct bpf_iter_task_btf *skel)
 
 	if (bss->skip) {
 		printf("%s:SKIP:no __builtin_btf_type_id\n", __func__);
+		ret = 1;
 		test__skip();
 		goto free_link;
 	}
@@ -212,12 +214,14 @@ static void do_btf_read(struct bpf_iter_task_btf *skel)
 	if (iter_fd > 0)
 		close(iter_fd);
 	bpf_link__destroy(link);
+	return ret;
 }
 
 static void test_task_btf(void)
 {
 	struct bpf_iter_task_btf__bss *bss;
 	struct bpf_iter_task_btf *skel;
+	int ret;
 
 	skel = bpf_iter_task_btf__open_and_load();
 	if (CHECK(!skel, "bpf_iter_task_btf__open_and_load",
@@ -226,7 +230,9 @@ static void test_task_btf(void)
 
 	bss = skel->bss;
 
-	do_btf_read(skel);
+	ret = do_btf_read(skel);
+	if (ret)
+		goto cleanup;
 
 	if (CHECK(bss->tasks == 0, "check if iterated over tasks",
 		  "no task iteration, did BPF program run?\n"))
-- 
2.28.0

