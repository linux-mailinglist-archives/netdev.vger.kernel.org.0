Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88BF443DB48
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 08:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbhJ1Gh6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 02:37:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbhJ1Ghx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 02:37:53 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C512C061570;
        Wed, 27 Oct 2021 23:35:27 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id k2-20020a17090ac50200b001a218b956aaso3890974pjt.2;
        Wed, 27 Oct 2021 23:35:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PHZ7COKM9/LMwsxyYhKVcjTx2YOlHJkrqt4+P2GPsy8=;
        b=MilSpwY0NJFvQgPvcWLI9XPN52ShqSEfEcKySoaEbZ+XG1p8kP1R8TpvzHUWFkyqTO
         nPLNx5K3U9UYtdTIXGxlcWI22YLyLCQKx85Tyd8CfCJAzbhSlPvxWUQJLB1EtH7X7snv
         18YMjFUcb4FMBnIvauJpl2yCQLdVMwmL1qri6zMeIc2EFJ5lvdb6qe+Gi5Eazd2tNcvG
         S1XHYGkxE1Zt8SQvMRvu4kXnxD9UVO19oILcDfG1E3s5pahs2u3jHafvmZRm3Ws35bEQ
         XiVuSm/reDnp9khPBbcalp3cTqNE9L6jGOMuXNAUKb63mApotegUmJLIr/yXMtRYMoHo
         +Ppw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PHZ7COKM9/LMwsxyYhKVcjTx2YOlHJkrqt4+P2GPsy8=;
        b=AZWpJ1ks0JBiWC44Q2gx1FIzZ+eZ85FwMHd+4ab+yKVXu7hOl4BkpVnLDCkC1ow2Sy
         pXbZeI6qg1WlOAINM3Eo0nuZEjOpMksiyTUlvx67tkfHfDwLy/Dnz8TBGEPXy4/YMUbE
         mNGi8yoKCrQgbqSR+IsoOIpyKVGmzep07W3YEeOCtm7HR2rXdYnpKNUD0g+q1NBiOdDl
         WNn2dNBGp+Zq8RarE2lgA3q5t26BtVtka8B+iLPyKyBUdNbKVvc4n5P9kL7bpO11q6z6
         +vZqu5RdiM/cvPPlnYTZJqXjRqRtIPEUlBr7rY5tBIqzaxKxPj6gwp+/EYskI4tX5Kty
         8xig==
X-Gm-Message-State: AOAM532b1evsJI4qal5VJtG5wjGt5IFo9FrYyL5h8cj7T4ul/UfkWXNO
        9l6JCs6CPYjOTZ8ZS4NZQSgNowpZsKsKcw==
X-Google-Smtp-Source: ABdhPJwitAjTcIJBIbSsTHaOv7dVkeYyOsD33GoDOBa3EPwZhmg/Eb9q5FxJhpzrWys6lFIseBKejw==
X-Received: by 2002:a17:902:930c:b0:13e:42b4:9149 with SMTP id bc12-20020a170902930c00b0013e42b49149mr2242964plb.86.1635402926693;
        Wed, 27 Oct 2021 23:35:26 -0700 (PDT)
Received: from localhost ([2405:201:6014:d916:31fc:9e49:a605:b093])
        by smtp.gmail.com with ESMTPSA id w7sm2117085pfu.147.2021.10.27.23.35.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 23:35:26 -0700 (PDT)
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
Subject: [PATCH bpf-next v5 8/8] selftests/bpf: Fix memory leak in test_ima
Date:   Thu, 28 Oct 2021 12:05:01 +0530
Message-Id: <20211028063501.2239335-9-memxor@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211028063501.2239335-1-memxor@gmail.com>
References: <20211028063501.2239335-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1208; h=from:subject; bh=uttHbwUjSiiWK4gZ/SH6UejWtXd/VoAYQu4qSvYuyG8=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhekR/h1aFK99eOTMqetnrSkPCs7Ql/BebUc1d5jCV fjLyRTiJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYXpEfwAKCRBM4MiGSL8RyuddD/ 42nUPj6yH++GVblUlRaINBsTqT+MzD9rhFtZAelyZ8/PIWGAiiP48iYgall1G4QzkAfZ3tzRMapPb/ lmhEWqjSSdB5Isym6rxOiF77QjuUWc6vw8rcRXCh+VvE/uvQ7KP6jdwJzwx26fPUDEniEGsHMqZB+p I1jG788I4WaSFjiNwayMoN+739q5/sWDhUrh1HPYjZ3Y5acsY8aeC1AE87tIdkvSvnC2gc3pbJNyK8 r/5ME574e/JK3XUg3Og1w6kFtb9RyhX1DXAKyZFi9CnjqnLFucZ8zz6ZD3OMK/mSyPrHP8EA6CFw3W LM1veaUloo7ykhdGxKzRqVB8cjW/vDP6tK3fcp5MX42hS792ZQS2j2SC77Qp9CAsmK8TGO7EccYlLo em8u6oGPZpm6VQURY8FSC56pk+CkayjfV7EAk3wvBgaVDSvlbJSxoijeIvYIfzYccVIcEqsg73bKOK FOjTIb6lJSpSls+TScRoc7zHfFFk3XWksQevfMB5fp2A5QQTGrTM2BROBIzjz1RrHh+T0D0QOAtPcN 0Z3m+x2YoNrXlLToY5dQ7YRrhkxY1QENU39FdwiSsXLXUeZTfqsYCcbcLrW2KKgqPeNIhZ+OTJwzn9 m3MNXO//LEJ3SPLmJugqZ5rDYcWzEpxU8SQmm+TZqi5dKjutQawEzvFRCnXw==
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

