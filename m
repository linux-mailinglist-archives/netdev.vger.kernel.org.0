Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6B6D43DB46
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 08:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbhJ1Ghx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 02:37:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbhJ1Ghu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 02:37:50 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77EB3C061745;
        Wed, 27 Oct 2021 23:35:24 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id t184so5086171pfd.0;
        Wed, 27 Oct 2021 23:35:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=q0bVxXKtgDaX+ebNe+4UMBEyHHvU9zTFgy/ps9QbqC8=;
        b=Xlx1nswPVT0E1IRhZaBo7lfQ8sHmsw63h0pq0F0Q+QD2lXwjFIDVr6M1MRwo6f+tNI
         oHUGWxrZUBhxpg/DBY8BaOSbhS5vPFX4UFM+GBHD9sbmVPklKzIaB+mTtmq4bCdAX0lK
         MBZyxOHnuttU5yP/JGX4TCrCVMOh4p4/APsYlXuZzoycHIfrmm3497fBZ70AqxpnpFSJ
         rPaDH8atAPVsyTtYVaSNCZjjpCIhL01AIASy7PhyeKnXz/rPfYKIRgU308rYGB0nZ3lV
         YY8t10TOExTErJrSkeu+w2biqsv3H8odmlVctspPLtWWDyoWXjWq5WEJbx3WuNilcMwj
         TyXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q0bVxXKtgDaX+ebNe+4UMBEyHHvU9zTFgy/ps9QbqC8=;
        b=wErK4/g89iIEQXZ0++rO0K2HUbFY0jBpwSiHfAP1pCgmOMGzbC0XPYdA4vAT6VCkWz
         oj9Xm1kRyCI+mkx3W9SuzWSdY4oIATheKeES842tC55KoqX1Vo577j5AGiIn/+x3xNCl
         6FWb2Op8AwmnVut7/r3B9qyzYuPhhVDwD0Py13ysQ9G/Kdt6nfBbbc5YsJcpuNdSOjtt
         XDGmX9azRXyrRVA+PPVaZF4vbA6Q+sVjYd/lYSKextDOq4rEH8aPXvjeJbJkPkLqIIe9
         7Wuji6cp8nNOFr9UZ149Qv4awF1iaS+1V4gyotw/pT2PZtC5Q5/8f9nxmccF1cAxkOdD
         8syw==
X-Gm-Message-State: AOAM533vpfm/WdCKj9AQVDgmZHTz2eNkUpARTSLeGBHH//YzXIV4H0+v
        mOMnQ2lZULOJAWQyYv9sndRFvsSin2EuSw==
X-Google-Smtp-Source: ABdhPJyNf3buPqs+PbjC//LCbWyW/vETp4MTMG7gMfXh5OJPCxo6vXasCu9KP3zXoUnj8OC8MY1p5Q==
X-Received: by 2002:a62:e90d:0:b0:44d:35a1:e5a0 with SMTP id j13-20020a62e90d000000b0044d35a1e5a0mr2292408pfh.54.1635402923852;
        Wed, 27 Oct 2021 23:35:23 -0700 (PDT)
Received: from localhost ([2405:201:6014:d916:31fc:9e49:a605:b093])
        by smtp.gmail.com with ESMTPSA id e9sm2144382pfv.189.2021.10.27.23.35.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 23:35:23 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Jakub Sitnicki <jakub@cloudflare.com>,
        Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v5 7/8] selftests/bpf: Fix fd cleanup in sk_lookup test
Date:   Thu, 28 Oct 2021 12:05:00 +0530
Message-Id: <20211028063501.2239335-8-memxor@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211028063501.2239335-1-memxor@gmail.com>
References: <20211028063501.2239335-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1786; h=from:subject; bh=+5DynpNUcgFEkNXUjTtqW/47IvO1DY3p6ovoPQknE/A=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhekR/VjCGHwLxjKPni7CcXORFQPW3flPsjVyQAfjF cdl419GJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYXpEfwAKCRBM4MiGSL8RypymD/ sEw8NCMCh0uNpVX9v9fuNyKROHoQSSW2dGNKUawOg6G/EKD3Wmw6IfhSFJt3L30dsU+QXqFxmdrmo/ /IXkDQK1JqiRXNwTAoUzGesPp0d1EGMwCdz9X8mLgkpAyfIZAmvq9YiR8joqI1XEXHDuje309qWnGz BpPugZ7CFFDehISGG2AWvE9rZugQLpmQz/wE5iRvcFNN7JUIYwfJNtVKobYsMEJl6gPd9NkEGObtiH YzqYBzlyR9XiLGCPRZmtRIQOtdSdG+weLXOjTHMqudMP94Xo62EZtEcrfu6E+2gG/yqYt39TPjIZH3 G9Kli1eHfdkslFZhjZulxuClU4qFIVFyhGh+1Z+xIRTrZKwmVuGPl52SecdooBkBTDbL4KM+7m02TN NE7Mema6F+MG9SxWrmY4yiplcVNTTq0xr5gPs8dzDvSbntgmrLDtSNfzdW6/ZAPzlzYLmY+hboERUn JeTgrFEuR+GsyjrFO4E5BguU6OFZr1BJaQv5Y6j+ipnOxSkdRsO6+kt+GHf8hJ13ynRq0P0QZgI/IU fQQh6d7k0yhfOVEfNE3Ere5BaFkz6btgK18lN5W5pFt6VFYuQADZqDVOv4M6nRSvVDM1+EXs8EUO16 LqwxK3YigWCDj2PmeIvceqcfy8a6Vy74QIRM5zIuPg/+2mXDH1WrIoeTJ9kQ==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to the fix in commit:
e31eec77e4ab ("bpf: selftests: Fix fd cleanup in get_branch_snapshot")

We use designated initializer to set fds to -1 without breaking on
future changes to MAX_SERVER constant denoting the array size.

The particular close(0) occurs on non-reuseport tests, so it can be seen
with -n 115/{2,3} but not 115/4. This can cause problems with future
tests if they depend on BTF fd never being acquired as fd 0, breaking
internal libbpf assumptions.

Fixes: 0ab5539f8584 ("selftests/bpf: Tests for BPF_SK_LOOKUP attach point")
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/testing/selftests/bpf/prog_tests/sk_lookup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/sk_lookup.c b/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
index aee41547e7f4..6db07401bc49 100644
--- a/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
+++ b/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
@@ -598,7 +598,7 @@ static void query_lookup_prog(struct test_sk_lookup *skel)
 
 static void run_lookup_prog(const struct test *t)
 {
-	int server_fds[MAX_SERVERS] = { -1 };
+	int server_fds[] = { [0 ... MAX_SERVERS - 1] = -1 };
 	int client_fd, reuse_conn_fd = -1;
 	struct bpf_link *lookup_link;
 	int i, err;
@@ -1053,7 +1053,7 @@ static void run_sk_assign(struct test_sk_lookup *skel,
 			  struct bpf_program *lookup_prog,
 			  const char *remote_ip, const char *local_ip)
 {
-	int server_fds[MAX_SERVERS] = { -1 };
+	int server_fds[] = { [0 ... MAX_SERVERS - 1] = -1 };
 	struct bpf_sk_lookup ctx;
 	__u64 server_cookie;
 	int i, err;
-- 
2.33.1

