Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 182BD530ECF
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 15:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235203AbiEWL42 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 07:56:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235368AbiEWL4O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 07:56:14 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 559FA517FD;
        Mon, 23 May 2022 04:56:07 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id z17so1742366wmf.1;
        Mon, 23 May 2022 04:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xxq/dtScJVM5dKv6qygc3KWh1gjFjuflRzvNDTnM53w=;
        b=pLmmGrFWpXbszthY96rthCc9b4MM/ZEGzTH8IMpe2fliWdFOTZBnGJ/wqMMXmLUsHk
         Vsr5KhbVSa5mtuS33e0dr7Cub55i1F4rCOrGOM5nF1m1xbqOIBT/2E6KXZwpBxfSQM93
         letAfrSKHd7d9GBG4QYSZORwxCEOVYcsyllH3Q0vP/rygjI0BorNdDKb5e4tl1f64frA
         vfrSXDjEeDaW+Xoo0CeF4+HIqyIAD7ocXnthZIV1OfpS9oRWE4d6mgoz/vt3nrGUyo7U
         bqTkBmoVLF1hGRxThHmQxCAjhjO6snZHfKTC94jVJuFXV2TWAJaLyt1zGmmuKPdrxUII
         lZAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xxq/dtScJVM5dKv6qygc3KWh1gjFjuflRzvNDTnM53w=;
        b=67t/C0gA4LHRtkg5EqD5tS5VkTUeZXDY/9IlndiJQs3eGGi9L5JdkcWX0WQLtQqQsh
         ZmawmiY39SmsAEXWtiAKh8akkz/+aVhX2BxQY/7NXsMEx+K6HEz55BV2YarbKag/rR83
         CdO8MjwuHV1yeuNz4AAW8luSLJUcDzulo8XuG3Rwj/eUYi7h/fzGhll0umMc8GVMbx75
         nnhjuZOURdbZHmJJJwZUxaavA9ATfh8juPgjxkd/ZKlo6b9F7o4opluM+xxfY0hhh9vK
         MNYkMkSkUIivIafaghwsZOq6c8zHjAOXU4OmqG91msxqdDCENncqSM0pcROg6wzzibZU
         X3tA==
X-Gm-Message-State: AOAM533wKwxIirLe8SJdAaivMt9LcZwukStL8obGeKY6FHFJ8uYHyrhd
        3kTKUAqBa5A+upfj3yFl5Lo=
X-Google-Smtp-Source: ABdhPJyIvRwYjDWyS5V+7WUUgXAgLnV4DhDTkH4YwdP+WN1QjtWs7C496pfQlB+56nIqjk00XzgJOg==
X-Received: by 2002:a1c:6a01:0:b0:37f:1b18:6b17 with SMTP id f1-20020a1c6a01000000b0037f1b186b17mr20118573wmc.146.1653306965646;
        Mon, 23 May 2022 04:56:05 -0700 (PDT)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id p6-20020a05600c358600b0039726cd3ae5sm10991929wmq.3.2022.05.23.04.56.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 May 2022 04:56:05 -0700 (PDT)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] selftests/bpf: Fix spelling mistake: "unpriviliged" -> "unprivileged"
Date:   Mon, 23 May 2022 12:56:04 +0100
Message-Id: <20220523115604.49942-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are spelling mistakes in ASSERT messages. Fix these.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 tools/testing/selftests/bpf/prog_tests/unpriv_bpf_disabled.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/unpriv_bpf_disabled.c b/tools/testing/selftests/bpf/prog_tests/unpriv_bpf_disabled.c
index 2800185179cf..1ed3cc2092db 100644
--- a/tools/testing/selftests/bpf/prog_tests/unpriv_bpf_disabled.c
+++ b/tools/testing/selftests/bpf/prog_tests/unpriv_bpf_disabled.c
@@ -261,10 +261,10 @@ void test_unpriv_bpf_disabled(void)
 	if (ret == -EPERM) {
 		/* if unprivileged_bpf_disabled=1, we get -EPERM back; that's okay. */
 		if (!ASSERT_OK(strcmp(unprivileged_bpf_disabled_orig, "1"),
-			       "unpriviliged_bpf_disabled_on"))
+			       "unprivileged_bpf_disabled_on"))
 			goto cleanup;
 	} else {
-		if (!ASSERT_OK(ret, "set unpriviliged_bpf_disabled"))
+		if (!ASSERT_OK(ret, "set unprivileged_bpf_disabled"))
 			goto cleanup;
 	}
 
-- 
2.35.3

