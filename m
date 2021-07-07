Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00B2A3BF081
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 21:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233090AbhGGTt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 15:49:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33200 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233086AbhGGTt6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 15:49:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625687237;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zbTjAalRT8G7ucBl7KamxhzUVx0mh7mTfA4EZ32X+1U=;
        b=gwodM7Q5OGzlScxodxH/mBqHiQwVRtah9sz55ovP9qsFTX/Q4eqaLpl6919aB+qLPyjOTz
        3cTQxNm6GL32zOc37v6UnJQKsJ5rkll646CMpbXH88Qxc0kgEZ1bSNTQLq/gPVQpCkLsRk
        7W0aC0RA8ngkSSwXwWqCv8YMoVlPBU0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-359-ym0Ub-7nPcKR7lvtAeWDtA-1; Wed, 07 Jul 2021 15:47:16 -0400
X-MC-Unique: ym0Ub-7nPcKR7lvtAeWDtA-1
Received: by mail-wr1-f71.google.com with SMTP id w4-20020a05600018c4b0290134e4f784e8so1127398wrq.10
        for <netdev@vger.kernel.org>; Wed, 07 Jul 2021 12:47:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zbTjAalRT8G7ucBl7KamxhzUVx0mh7mTfA4EZ32X+1U=;
        b=dIXHl2xt1gwvHGYT5OaYum+KIx329Vnh/Srq012KVxOV4AQRaIcuDNGeIm2F2cz7DY
         hg18JLbO8vSK/A+XzZ6WkYzmbrRVznbWs97++BKVhobWGDTm5OiAU/6VNcfHioPIghwA
         oSWuWgbQhYTf4kemWXBQggNnZT+upfz7nryC/E4o+35w+D3zfbqYjt8bdgkO/4Kcq0/l
         ADo8la4cdLAkK5Nzdkcuj88uH5v+YRmiv06c9yxDxMsAd4Vk9NeuwdafkF5Qg7tJgB21
         1EkgcLdKZmUf+9wRJaNfhv8XwXRNUtgk148QqBwopK4JFirDHgtJdEEVs+vH9puGfzYV
         Ad4w==
X-Gm-Message-State: AOAM530vpzQvK2eODVnVxmiJWPukyiIn6sBZVkHk0ennh5QzdChWOIxk
        5xz0h740mBsc8zPFmJYMBrFyc98MNM7l38oUP2PdWhAYlS6u6tLaVX10yuewUjKlbICCbYl0mhH
        oYwrg9eAmHEwAKqkv
X-Received: by 2002:a5d:4d4b:: with SMTP id a11mr5812959wru.325.1625687235391;
        Wed, 07 Jul 2021 12:47:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxCeEyHGUskiHM337qfooE0f3Ro/cCDcwbEMlSi+dsBwOUNqQw0kh8Z0/fopTxAKcSeFTYUDw==
X-Received: by 2002:a5d:4d4b:: with SMTP id a11mr5812949wru.325.1625687235220;
        Wed, 07 Jul 2021 12:47:15 -0700 (PDT)
Received: from krava.redhat.com ([185.153.78.55])
        by smtp.gmail.com with ESMTPSA id l16sm7619853wmj.47.2021.07.07.12.47.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 12:47:14 -0700 (PDT)
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
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH 7/7] selftests/bpf: Add test for bpf_get_func_ip in kprobe+offset probe
Date:   Wed,  7 Jul 2021 21:46:19 +0200
Message-Id: <20210707194619.151676-8-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210707194619.151676-1-jolsa@kernel.org>
References: <20210707194619.151676-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding test for bpf_get_func_ip in kprobe+ofset probe.
Because of the offset value it's arch specific, adding
it only for x86_64 architecture.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 .../testing/selftests/bpf/progs/get_func_ip_test.c  | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/tools/testing/selftests/bpf/progs/get_func_ip_test.c b/tools/testing/selftests/bpf/progs/get_func_ip_test.c
index 8ca54390d2b1..e8a9428a0ea3 100644
--- a/tools/testing/selftests/bpf/progs/get_func_ip_test.c
+++ b/tools/testing/selftests/bpf/progs/get_func_ip_test.c
@@ -10,6 +10,7 @@ extern const void bpf_fentry_test2 __ksym;
 extern const void bpf_fentry_test3 __ksym;
 extern const void bpf_fentry_test4 __ksym;
 extern const void bpf_modify_return_test __ksym;
+extern const void bpf_fentry_test6 __ksym;
 
 __u64 test1_result = 0;
 SEC("fentry/bpf_fentry_test1")
@@ -60,3 +61,15 @@ int BPF_PROG(fmod_ret_test, int a, int *b, int ret)
 	test5_result = (const void *) addr == &bpf_modify_return_test;
 	return ret;
 }
+
+#ifdef __x86_64__
+__u64 test6_result = 0;
+SEC("kprobe/bpf_fentry_test6+0x5")
+int test6(struct pt_regs *ctx)
+{
+	__u64 addr = bpf_get_func_ip(ctx);
+
+	test6_result = (const void *) addr == &bpf_fentry_test6 + 5;
+	return 0;
+}
+#endif
-- 
2.31.1

