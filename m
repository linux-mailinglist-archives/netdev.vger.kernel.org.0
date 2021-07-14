Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7E3B3C81FE
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 11:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238958AbhGNJsD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 05:48:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42765 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238894AbhGNJsC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 05:48:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626255910;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZN3a1tvndTSdC7YsooBDBFTgb7MR0oz3akD0iS1avfE=;
        b=UHjzfvzWl9ExW2XTfoR19g13E/VIPrL74CEMuD2dzXUzOXt7++XBxF0Ih2du1U5AWaaeA/
        NEbf79NzWklqzGNtjcKLDcCYoLiV0IX3bmH+WIdFupObhD1fGUxL1aVIkqbDPW5BI+Si80
        cgkd0Lk4TjnqZoZ+oTsCwPmLevc7RbY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-56-bVejZXFKOOK69lmW0tZzpQ-1; Wed, 14 Jul 2021 05:45:09 -0400
X-MC-Unique: bVejZXFKOOK69lmW0tZzpQ-1
Received: by mail-wr1-f69.google.com with SMTP id u13-20020a5d6dad0000b029012e76845945so1205942wrs.11
        for <netdev@vger.kernel.org>; Wed, 14 Jul 2021 02:45:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZN3a1tvndTSdC7YsooBDBFTgb7MR0oz3akD0iS1avfE=;
        b=jKTusLNWEx8yQWX81TrGpl6TUdk/LeVjVyaSuplgUif1FUpaLRnajZXkAU+u3B4mGE
         F6KBxgfwLtTiBoxMsrHLLU9qjRNwVNHG7iTHOKwHK5YUczUFwdDym9otkM2P5WCuszJV
         /K/DGDz69gk/xheGSI7W2CGq/tY4OqxUlLT9VBpjqer8muohS37yOvk28EI0D9cFMdN/
         6iJ2QWL+akJH7+o1T2FU4fJYfPzB5MYB5uIjXjSUAp/1mUeP0fLFc13G37LnpJ93+5Qf
         vnFB7qQMSbx0y7qUxxRP6KjBtUDZ0PYBaPechbNQAx0r9bqTknnIASyZYFmb0l3uDa8i
         hcEg==
X-Gm-Message-State: AOAM533SGsdr/RjhGGVDYLeZAy5KSBzuOMwHr1BrRwDrBb0XPeSNQLYp
        k2voAVE4WuGNU0Ez/BjOZEzu5hsHdwlCy2CnxnOSus1GU8/b9aIBso0MlWsRo/jCCblz3EpFy57
        AOi3EVGzRf8bbuEAj
X-Received: by 2002:a5d:64aa:: with SMTP id m10mr11766430wrp.351.1626255908343;
        Wed, 14 Jul 2021 02:45:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyLVyxjqH+zKP2iLuw7jWabuqEbAAePGdeqkySMndl6Fvplu9NljgNilCAW5cz7H5MlpEdX0w==
X-Received: by 2002:a5d:64aa:: with SMTP id m10mr11766409wrp.351.1626255908218;
        Wed, 14 Jul 2021 02:45:08 -0700 (PDT)
Received: from krava.redhat.com ([5.171.203.6])
        by smtp.gmail.com with ESMTPSA id o18sm1953328wrx.21.2021.07.14.02.45.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 02:45:07 -0700 (PDT)
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
Subject: [PATCHv4 bpf-next 8/8] selftests/bpf: Add test for bpf_get_func_ip in kprobe+offset probe
Date:   Wed, 14 Jul 2021 11:44:00 +0200
Message-Id: <20210714094400.396467-9-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210714094400.396467-1-jolsa@kernel.org>
References: <20210714094400.396467-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding test for bpf_get_func_ip in kprobe+ofset probe.
Because of the offset value it's arch specific, enabling
the new test only for x86_64 architecture.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 .../bpf/prog_tests/get_func_ip_test.c          | 18 ++++++++++++++++--
 .../selftests/bpf/progs/get_func_ip_test.c     | 11 +++++++++++
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/get_func_ip_test.c b/tools/testing/selftests/bpf/prog_tests/get_func_ip_test.c
index 8bb18a8d31a0..088b3653610d 100644
--- a/tools/testing/selftests/bpf/prog_tests/get_func_ip_test.c
+++ b/tools/testing/selftests/bpf/prog_tests/get_func_ip_test.c
@@ -8,10 +8,21 @@ void test_get_func_ip_test(void)
 	__u32 duration = 0, retval;
 	int err, prog_fd;
 
-	skel = get_func_ip_test__open_and_load();
-	if (!ASSERT_OK_PTR(skel, "get_func_ip_test__open_and_load"))
+	skel = get_func_ip_test__open();
+	if (!ASSERT_OK_PTR(skel, "get_func_ip_test__open"))
 		return;
 
+	/* test6 is x86_64 specifc because of the instruction
+	 * offset, disabling it for all other archs
+	 */
+#ifndef __x86_64__
+	bpf_program__set_autoload(skel->progs.test6, false);
+#endif
+
+	err = get_func_ip_test__load(skel);
+	if (!ASSERT_OK(err, "get_func_ip_test__load"))
+		goto cleanup;
+
 	err = get_func_ip_test__attach(skel);
 	if (!ASSERT_OK(err, "get_func_ip_test__attach"))
 		goto cleanup;
@@ -33,6 +44,9 @@ void test_get_func_ip_test(void)
 	ASSERT_EQ(skel->bss->test3_result, 1, "test3_result");
 	ASSERT_EQ(skel->bss->test4_result, 1, "test4_result");
 	ASSERT_EQ(skel->bss->test5_result, 1, "test5_result");
+#ifdef __x86_64__
+	ASSERT_EQ(skel->bss->test6_result, 1, "test6_result");
+#endif
 
 cleanup:
 	get_func_ip_test__destroy(skel);
diff --git a/tools/testing/selftests/bpf/progs/get_func_ip_test.c b/tools/testing/selftests/bpf/progs/get_func_ip_test.c
index ba3e107b52dd..acd587b6e859 100644
--- a/tools/testing/selftests/bpf/progs/get_func_ip_test.c
+++ b/tools/testing/selftests/bpf/progs/get_func_ip_test.c
@@ -10,6 +10,7 @@ extern const void bpf_fentry_test2 __ksym;
 extern const void bpf_fentry_test3 __ksym;
 extern const void bpf_fentry_test4 __ksym;
 extern const void bpf_modify_return_test __ksym;
+extern const void bpf_fentry_test6 __ksym;
 
 __u64 test1_result = 0;
 SEC("fentry/bpf_fentry_test1")
@@ -60,3 +61,13 @@ int BPF_PROG(test5, int a, int *b, int ret)
 	test5_result = (const void *) addr == &bpf_modify_return_test;
 	return ret;
 }
+
+__u64 test6_result = 0;
+SEC("kprobe/bpf_fentry_test6+0x5")
+int test6(struct pt_regs *ctx)
+{
+	__u64 addr = bpf_get_func_ip(ctx);
+
+	test6_result = (const void *) addr == &bpf_fentry_test6 + 5;
+	return 0;
+}
-- 
2.31.1

