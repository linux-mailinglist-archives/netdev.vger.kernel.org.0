Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB9814353A9
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 21:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231569AbhJTTSK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 15:18:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231593AbhJTTSH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 15:18:07 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32C35C06161C;
        Wed, 20 Oct 2021 12:15:53 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id om14so3158589pjb.5;
        Wed, 20 Oct 2021 12:15:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PHZ7COKM9/LMwsxyYhKVcjTx2YOlHJkrqt4+P2GPsy8=;
        b=aZhA+c7l3HswCX7Zs6BDFGBeedW3SVWs68r6amMX3GLcLrOCP7fABbKxDPOc6CgPaQ
         cGYdrhRHXnMB5Ksd7shBmgUWVEFq16wmuPs/o3e33oPbnDf7VU97dnp+H1Ch06/tZjQr
         /4A3MJqCgQll7/nw/64C2rxUcrzDleuOgix6h+CofakNEraLUbnzRdtGrqRMlpxq6pBk
         d2TwpmENAvm41mBzl1omeM3YN6thRJ/c4cVrskMHa8j7tgo4to5RD2jSAA6Ztcxlf1Ak
         kzxSbIQzI0UPGMLD2bR2pf/FbwaKkOaO9r1uHpmPLd4JwDVgu6YkehT1iXHvJErOGOxy
         G55g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PHZ7COKM9/LMwsxyYhKVcjTx2YOlHJkrqt4+P2GPsy8=;
        b=i0Ge3iegnm0dFAI/mN+KdDnoHvsqpCiaQGzLlUgm2iIouHlMN1iA+Nr8u5IUcHp9Vl
         qR0dsLOhOH86KDy2eKvqjFgcNIBbNM6z7WPZIMjKNNDeHj9vJLzGYebLtq0UJNJYCMRq
         sGNVgLLHWuQ4nDQOvT9nyrMN/l6BK9gbEK7RcgfFcAGekO600z6C7yhMoS18dn+tOf/F
         hcWeMngkzDsc+6L34kGOn5dgXAY6j0WG3yug/t4Z5b1xHjeU36nXdwRY/aiXjdS1uu1A
         3QnOmjDtPk9eT/wH5LJ++QCbUyuqP02i2otbpYWJFG0NaSvUlUoEKny/n7lCwKaQU4i+
         0hKQ==
X-Gm-Message-State: AOAM530d6VBOmHt56DyQcME1D52dwi0eap6mcks36y7ELcpx87tvSuyH
        mF3v7SaMDnS209Uvl0Wl+ZDdXWs67wC6Bg==
X-Google-Smtp-Source: ABdhPJw+BQ+CwJqpdQ1pDVYar36MjqK8hW3thojIS+E1dsnmMNygMFbv6g2F8WY8EzDBw02mRzqD5g==
X-Received: by 2002:a17:903:32c7:b0:13e:ea76:f8cb with SMTP id i7-20020a17090332c700b0013eea76f8cbmr853619plr.74.1634757352503;
        Wed, 20 Oct 2021 12:15:52 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id e20sm3645525pfv.27.2021.10.20.12.15.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 12:15:52 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v4 8/8] selftests/bpf: Fix memory leak in test_ima
Date:   Thu, 21 Oct 2021 00:45:26 +0530
Message-Id: <20211020191526.2306852-9-memxor@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211020191526.2306852-1-memxor@gmail.com>
References: <20211020191526.2306852-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1208; h=from:subject; bh=uttHbwUjSiiWK4gZ/SH6UejWtXd/VoAYQu4qSvYuyG8=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhcGofh1aFK99eOTMqetnrSkPCs7Ql/BebUc1d5jCV fjLyRTiJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYXBqHwAKCRBM4MiGSL8RyqI+D/ 9AqZER5sbMRd7usWgbgjun0gDSAhY1s1GBdSS8R0P05yDBuf4bX3aSEKdotA6kq6FlAOzxCDv4hZwO ig9aKzbzE8pRum7YeVFZkC++Nu8lJj15r4mN9SkbmXuf1IGaJFzGGZ2r7uWvlsK/QkGokc2Z2m+/8p ZLgJEPYfk1BDMfFgFuFD6xiSKT+GMJ+GtT2T8B9eGI1r8aorb3DKMU1SkwS+65SO6leJwmwpwGc7n2 SA2zuNMLdms6GuZlGfAl4w+PegGGlfOjdBR5MYkl6OSC6QnpatWZs+/n8CEBdPkKNoRmgIZuk2hxZL 3GXE0fZpJ+EC7ff61g+6YuwrD2unbHbergeUNEtdAAwJfOzArxKwwn5/dkEqOqwARs08gsIKuj1YIh 3u2GxWioUdjTww4uQJprIisYbXpdrfBzVDTBlVGzTFpwmHdq92cZiGDUYBDb4jL/G02epidk18ukBQ Qh++UefvREF0iz//8vZvFKRam8q+QkLvM/Dlgr4OODOb9YCpVGOcefG+qbpeOsAXJ4Ff+MN4v0ATxt 7mgFB8bRws1zm7JiiHbz5Rj7sAjekAusD1BiTdAk/l5CUh9Y4EzBnm2zg1+ds4/PD0Qj6xOBM4kLXX HvpTYlItCGfvESQdiwpk8qleIoqwG9J0Q5G3Fot2D+wmDbatPor58NfhhVyw==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The allocated ring buffer is never freed, do so in the cleanup path.

Fixes: f446b570ac7e ("bpf/selftests: Update the IMA test to use BPF ring buffer")
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/testing/selftests/bpf/prog_tests/test_ima.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/test_ima.c b/tools/testing/selftests/bpf/prog_tests/test_ima.c
index 0252f61d611a..97d8a6f84f4a 100644
--- a/tools/testing/selftests/bpf/prog_tests/test_ima.c
+++ b/tools/testing/selftests/bpf/prog_tests/test_ima.c
@@ -43,7 +43,7 @@ static int process_sample(void *ctx, void *data, size_t len)
 void test_test_ima(void)
 {
 	char measured_dir_template[] = "/tmp/ima_measuredXXXXXX";
-	struct ring_buffer *ringbuf;
+	struct ring_buffer *ringbuf = NULL;
 	const char *measured_dir;
 	char cmd[256];
 
@@ -85,5 +85,6 @@ void test_test_ima(void)
 	err = system(cmd);
 	CHECK(err, "failed to run command", "%s, errno = %d\n", cmd, errno);
 close_prog:
+	ring_buffer__free(ringbuf);
 	ima__destroy(skel);
 }
-- 
2.33.1

