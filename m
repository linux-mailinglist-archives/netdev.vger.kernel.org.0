Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78D444202F9
	for <lists+netdev@lfdr.de>; Sun,  3 Oct 2021 18:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbhJCQvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Oct 2021 12:51:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35473 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230504AbhJCQvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Oct 2021 12:51:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633279771;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=9nTD5DvOEAb5Ts4GxYiTYCkd/jR9/VxYpeKb+vjDz+Y=;
        b=RB0S8TbmwtUwIUMtFz+93VQOmOoMm6MQfcnRVaHmqI+EOkomhA7tL9wVIyMKaFC4/tyqgT
        YA913b0u5wXVLR8nnwmRUTX7uczmsTvUMMmvmsJdQn/wBOlO30H9FJ2TnA5eaKvEIRrf5o
        dPcHfrEZZ3goHrW3/Vv7ZBVAc58epPM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-529-bOHfDDmvNuWa_lSmyb-c6A-1; Sun, 03 Oct 2021 12:49:28 -0400
X-MC-Unique: bOHfDDmvNuWa_lSmyb-c6A-1
Received: by mail-wm1-f70.google.com with SMTP id f10-20020a7bcd0a000000b0030d2def848dso3059290wmj.0
        for <netdev@vger.kernel.org>; Sun, 03 Oct 2021 09:49:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=9nTD5DvOEAb5Ts4GxYiTYCkd/jR9/VxYpeKb+vjDz+Y=;
        b=d7Oe5iqhxmYGU0v5PAT0Y0UAHYk11g1LBiqniIXfWgfcbSiu1hdtZ4rLsC2yGK02Nf
         bPTie2za5f0R7+beei0O23yULNOw6GU57XKNveVHzWXuLJqjX3lE8+ta2ya1AC9WZcYn
         EqTd4M0pVq6mC425SxO81WIT9nqaFTy3HvoYya/ooHlG9e+C/gJWeVjQw1+XXEXAQssi
         roVI5gpWIlGvkuxzmGyNz9CpHE0hxNRG2deTjM13pfkq/F7/kBZo6HiwS+N8frfFjlJi
         kvEXFqCb8lBb4C8vpbxT1P2MFeXlTNJp+3EN9iPBvYTYbHBMqG0QBFVEsYk9E5VaaaSF
         f1Iw==
X-Gm-Message-State: AOAM533gacMQUrmS04fzHggA2Tj1HiTMtQv/8vbIH5l1/oUJAuq0XBNo
        mvvJPJML0Amgdx2hIiyyI+pJ7uhO3j8FPwftV605r0A9C7pDedUhyCTvEt+Y09Dbcc3D1Vk7m0U
        yQV5rC0VMDBp/1/Ph
X-Received: by 2002:a05:600c:19cf:: with SMTP id u15mr13376704wmq.45.1633279767695;
        Sun, 03 Oct 2021 09:49:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz6Qs2wCvk7zvI3FmshKL4tuBa7S4kxLFXXMASGobB+wNY7upJ5+cPuGuMeBHQcGyrpYQcwDw==
X-Received: by 2002:a05:600c:19cf:: with SMTP id u15mr13376682wmq.45.1633279767447;
        Sun, 03 Oct 2021 09:49:27 -0700 (PDT)
Received: from krava (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id s13sm10758395wrv.97.2021.10.03.09.49.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Oct 2021 09:49:27 -0700 (PDT)
Date:   Sun, 3 Oct 2021 18:49:25 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: [PATCH bpf-next] selftest/bpf: Switch recursion test to use
 htab_map_delete_elem
Message-ID: <YVnfFTL/3T6jOwHI@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the recursion test is hooking __htab_map_lookup_elem
function, which is invoked both from bpf_prog and bpf syscall.

But in our kernel build, the __htab_map_lookup_elem gets inlined
within the htab_map_lookup_elem, so it's not trigered and the
test fails.

Fixing this by using htab_map_delete_elem, which is not inlined
for bpf_prog calls (like htab_map_lookup_elem is) and is used
directly as pointer for map_delete_elem, so it won't disappear
by inlining.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/recursion.c | 10 +++++-----
 tools/testing/selftests/bpf/progs/recursion.c      |  9 +++------
 2 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/recursion.c b/tools/testing/selftests/bpf/prog_tests/recursion.c
index 0e378d63fe18..f3af2627b599 100644
--- a/tools/testing/selftests/bpf/prog_tests/recursion.c
+++ b/tools/testing/selftests/bpf/prog_tests/recursion.c
@@ -20,18 +20,18 @@ void test_recursion(void)
 		goto out;
 
 	ASSERT_EQ(skel->bss->pass1, 0, "pass1 == 0");
-	bpf_map_lookup_elem(bpf_map__fd(skel->maps.hash1), &key, 0);
+	bpf_map_delete_elem(bpf_map__fd(skel->maps.hash1), &key);
 	ASSERT_EQ(skel->bss->pass1, 1, "pass1 == 1");
-	bpf_map_lookup_elem(bpf_map__fd(skel->maps.hash1), &key, 0);
+	bpf_map_delete_elem(bpf_map__fd(skel->maps.hash1), &key);
 	ASSERT_EQ(skel->bss->pass1, 2, "pass1 == 2");
 
 	ASSERT_EQ(skel->bss->pass2, 0, "pass2 == 0");
-	bpf_map_lookup_elem(bpf_map__fd(skel->maps.hash2), &key, 0);
+	bpf_map_delete_elem(bpf_map__fd(skel->maps.hash2), &key);
 	ASSERT_EQ(skel->bss->pass2, 1, "pass2 == 1");
-	bpf_map_lookup_elem(bpf_map__fd(skel->maps.hash2), &key, 0);
+	bpf_map_delete_elem(bpf_map__fd(skel->maps.hash2), &key);
 	ASSERT_EQ(skel->bss->pass2, 2, "pass2 == 2");
 
-	err = bpf_obj_get_info_by_fd(bpf_program__fd(skel->progs.on_lookup),
+	err = bpf_obj_get_info_by_fd(bpf_program__fd(skel->progs.on_delete),
 				     &prog_info, &prog_info_len);
 	if (!ASSERT_OK(err, "get_prog_info"))
 		goto out;
diff --git a/tools/testing/selftests/bpf/progs/recursion.c b/tools/testing/selftests/bpf/progs/recursion.c
index 49f679375b9d..3c2423bb19e2 100644
--- a/tools/testing/selftests/bpf/progs/recursion.c
+++ b/tools/testing/selftests/bpf/progs/recursion.c
@@ -24,8 +24,8 @@ struct {
 int pass1 = 0;
 int pass2 = 0;
 
-SEC("fentry/__htab_map_lookup_elem")
-int BPF_PROG(on_lookup, struct bpf_map *map)
+SEC("fentry/htab_map_delete_elem")
+int BPF_PROG(on_delete, struct bpf_map *map)
 {
 	int key = 0;
 
@@ -35,10 +35,7 @@ int BPF_PROG(on_lookup, struct bpf_map *map)
 	}
 	if (map == (void *)&hash2) {
 		pass2++;
-		/* htab_map_gen_lookup() will inline below call
-		 * into direct call to __htab_map_lookup_elem()
-		 */
-		bpf_map_lookup_elem(&hash2, &key);
+		bpf_map_delete_elem(&hash2, &key);
 		return 0;
 	}
 
-- 
2.31.1

