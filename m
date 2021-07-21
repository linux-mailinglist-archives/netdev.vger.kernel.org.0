Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 177853D197E
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 23:58:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbhGUVRw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 17:17:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24495 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229979AbhGUVRu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 17:17:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626904706;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cnthrEhqSK4f18XnoUkLoCiCM8/m0dpLypLCFrHKZCs=;
        b=Oausivt1t+JkFkLEolppqbsSv1R0k57gFkfpNaCxyBB8ZBT2NMDDrhwxSWMyGR5RmowyQ2
        BI2qQ6lCFo+AuZGiWv37qMFF4s1HKoURuZ4NNUk0mJoDbs2P4ZgR0thvSUBgNMBjGYISOa
        tqEYeu/zZhl4M8Dh4fBeMsMSuxYuVVs=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-131-rkq-esfsNGyRLYr5EczCSQ-1; Wed, 21 Jul 2021 17:58:25 -0400
X-MC-Unique: rkq-esfsNGyRLYr5EczCSQ-1
Received: by mail-ej1-f72.google.com with SMTP id k1-20020a17090666c1b029041c273a883dso1305159ejp.3
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 14:58:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cnthrEhqSK4f18XnoUkLoCiCM8/m0dpLypLCFrHKZCs=;
        b=sJKX1YsxOUKr3Ri6W1Tp18iDHFuOjzAu0UjHvZj5vKgonbjCNwfx5wDJ+5ju0KM9qW
         /r7PiYfxzQCkFI92XPAs70u1vZtvnpAwaMnFF8ipv9ZU6Ee1P+HLAHZi0lDBuXTYwO3O
         ygdAOeuttIhNHX4dC6VdhTE2mI7WdWb9MPWkyl8vN6f3255DEV1sJozL6DhNDQNv2k3P
         KT1u7qiqO50ZNRaGArtJxG5pzvOU0Z6sMtG+yJI+vgLSvoIwrszRaPeCh6Ch3hWVdhXH
         4/r/JdN728H8Q8hsXXkeJZBMr7Ozh3xko0goAxPWaNcAtJPSKuDfWzCjzhvueNl9icvL
         UaDQ==
X-Gm-Message-State: AOAM530G+xpGYGYq3pkAAgSXV1q3lUFFEbOi9nNYqovm3DbARHQBAgeb
        N6tIrX+3fzcfE23FDm6//zRfLyb0gHy7uUcKoi8iJuDftdWPOojEpxWn+pShTk/9GepM7+cyX6b
        nrpTu3njI6s+uF0/4
X-Received: by 2002:a17:906:6811:: with SMTP id k17mr40440361ejr.280.1626904704173;
        Wed, 21 Jul 2021 14:58:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyJ4t0XIQQe8fG93ueNgrMdaYO+hzaOLTt1gHNTjIsb+whmwX14SfN65P5+wkYLrPXQbydCmw==
X-Received: by 2002:a17:906:6811:: with SMTP id k17mr40440345ejr.280.1626904703985;
        Wed, 21 Jul 2021 14:58:23 -0700 (PDT)
Received: from krava.cust.in.nbox.cz ([83.240.60.59])
        by smtp.gmail.com with ESMTPSA id q24sm11283244edc.82.2021.07.21.14.58.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 14:58:23 -0700 (PDT)
From:   Jiri Olsa <jolsa@redhat.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH bpf-next 2/3] libbpf: Allow decimal offset for kprobes
Date:   Wed, 21 Jul 2021 23:58:09 +0200
Message-Id: <20210721215810.889975-3-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210721215810.889975-1-jolsa@kernel.org>
References: <20210721215810.889975-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow to specify decimal offset in SEC macro, like:
  SEC("kprobe/bpf_fentry_test7+5")

Adding selftest for that.

Suggested-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/lib/bpf/libbpf.c                                |  2 +-
 .../selftests/bpf/prog_tests/get_func_ip_test.c       |  2 ++
 tools/testing/selftests/bpf/progs/get_func_ip_test.c  | 11 +++++++++++
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index d46c2dd37be2..52f4f1d4f495 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -10424,7 +10424,7 @@ static struct bpf_link *attach_kprobe(const struct bpf_sec_def *sec,
 	func_name = prog->sec_name + sec->len;
 	opts.retprobe = strcmp(sec->sec, "kretprobe/") == 0;
 
-	n = sscanf(func_name, "%m[a-zA-Z0-9_.]+%lx", &func, &offset);
+	n = sscanf(func_name, "%m[a-zA-Z0-9_.]+%li", &func, &offset);
 	if (n < 1) {
 		err = -EINVAL;
 		pr_warn("kprobe name is invalid: %s\n", func_name);
diff --git a/tools/testing/selftests/bpf/prog_tests/get_func_ip_test.c b/tools/testing/selftests/bpf/prog_tests/get_func_ip_test.c
index 088b3653610d..02a465f36d59 100644
--- a/tools/testing/selftests/bpf/prog_tests/get_func_ip_test.c
+++ b/tools/testing/selftests/bpf/prog_tests/get_func_ip_test.c
@@ -17,6 +17,7 @@ void test_get_func_ip_test(void)
 	 */
 #ifndef __x86_64__
 	bpf_program__set_autoload(skel->progs.test6, false);
+	bpf_program__set_autoload(skel->progs.test7, false);
 #endif
 
 	err = get_func_ip_test__load(skel);
@@ -46,6 +47,7 @@ void test_get_func_ip_test(void)
 	ASSERT_EQ(skel->bss->test5_result, 1, "test5_result");
 #ifdef __x86_64__
 	ASSERT_EQ(skel->bss->test6_result, 1, "test6_result");
+	ASSERT_EQ(skel->bss->test7_result, 1, "test7_result");
 #endif
 
 cleanup:
diff --git a/tools/testing/selftests/bpf/progs/get_func_ip_test.c b/tools/testing/selftests/bpf/progs/get_func_ip_test.c
index acd587b6e859..a587aeca5ae0 100644
--- a/tools/testing/selftests/bpf/progs/get_func_ip_test.c
+++ b/tools/testing/selftests/bpf/progs/get_func_ip_test.c
@@ -11,6 +11,7 @@ extern const void bpf_fentry_test3 __ksym;
 extern const void bpf_fentry_test4 __ksym;
 extern const void bpf_modify_return_test __ksym;
 extern const void bpf_fentry_test6 __ksym;
+extern const void bpf_fentry_test7 __ksym;
 
 __u64 test1_result = 0;
 SEC("fentry/bpf_fentry_test1")
@@ -71,3 +72,13 @@ int test6(struct pt_regs *ctx)
 	test6_result = (const void *) addr == &bpf_fentry_test6 + 5;
 	return 0;
 }
+
+__u64 test7_result = 0;
+SEC("kprobe/bpf_fentry_test7+5")
+int test7(struct pt_regs *ctx)
+{
+	__u64 addr = bpf_get_func_ip(ctx);
+
+	test7_result = (const void *) addr == &bpf_fentry_test7 + 5;
+	return 0;
+}
-- 
2.31.1

