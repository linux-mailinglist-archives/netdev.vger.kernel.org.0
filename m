Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E806C5246B9
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 09:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350869AbiELHS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 03:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350879AbiELHSt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 03:18:49 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F7B1C5E48;
        Thu, 12 May 2022 00:18:44 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id 7so3808495pga.12;
        Thu, 12 May 2022 00:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6UxEmmuG1N0Iwm83q5/mJkqiaq+2A/J4A3rU7XGWf4o=;
        b=QzfF6VRn+PtiqILq7UWQRU7Axj4yufoeYfPInxBX51q6ughZBRyL9y5OxlmnWB8VSl
         M1wqaRGIyhCFmeXWLPiM4/No7e9N5K8A+Ol23ys7+6HieRhL32gIWKFoAEBqEWeC0wn6
         D43q9QbGLGudqgJzOD+06D+gC9NCfBgHR3h/fETyv66GirlkWzWJI1qaaSvdtAHnw/z5
         TTtXUMCPdDLPs6oSE9+v1vD56PL/eZuGQTZEbdadKh3qhjII57SdGdDTvJFxHNfHUubC
         Hldl4fGicdsscSX9siHY/wItIKmsG5wGf4a7rzlOpoUN+KHvjXc146wRKKmFJ+zWn9+J
         xRPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6UxEmmuG1N0Iwm83q5/mJkqiaq+2A/J4A3rU7XGWf4o=;
        b=wHyZBs/K+mAi6rQPFdCS9VWAs3IzmpaGMjvHYJPXlTv/guGVjcfAWUYRg9cRLPCHWd
         ZpQ5mJanDkKE85GQCt/U24Opxrd3J1Z9PB1qW+5lE8pPl3xa6QXtVwtrdNhWoa2KUNL6
         /1HNRHBPlp0OPLQpTa3QMmfWUPhNZ1/rs8Wn0fpYYjxI40Qf7L0FZoPl3LrRKnKlCgzM
         SO2VyPdnaRo0GvYtltoCNXKG0QWzTZoi/fPWzqau8ifEuQKdmgoafVS8Mo4YiK5IiUof
         Capdh/lTHB10VHvY1K0DCnEVX78K8MO6wOPaoyg/ez5ADscyJmrIGaNri8X9hlBg6W69
         mJ7w==
X-Gm-Message-State: AOAM533Wp3xYo0s0M+5e1A8ZRLqisWh/uNj/fqE3b/Oh5JYPsWvfuBkD
        1sB14UFO/OROmcGgw/bl6Snp31NKt7BxZQ==
X-Google-Smtp-Source: ABdhPJx75txHssOaqCjfGXODpikDMzECnWJ48mJvru2gYqIsztZyRWVG9hvJ7GlnfWu3Q+3yFIKP7A==
X-Received: by 2002:a63:7e11:0:b0:3c6:84e3:9c59 with SMTP id z17-20020a637e11000000b003c684e39c59mr18812328pgc.615.1652339923413;
        Thu, 12 May 2022 00:18:43 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w17-20020a170902e89100b0015e8d4eb2b4sm3244533plg.254.2022.05.12.00.18.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 00:18:42 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        linux-kselftest@vger.kernel.org, bpf@vger.kernel.org,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net 2/2] selftests/bpf: add missed ima_setup.sh in Makefile
Date:   Thu, 12 May 2022 15:18:19 +0800
Message-Id: <20220512071819.199873-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220512071819.199873-1-liuhangbin@gmail.com>
References: <20220512071819.199873-1-liuhangbin@gmail.com>
MIME-Version: 1.0
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

When build bpf test and install it to another folder, e.g.

  make -j10 install -C tools/testing/selftests/ TARGETS="bpf" \
	SKIP_TARGETS="" INSTALL_PATH=/tmp/kselftests

The ima_setup.sh is missed in target folder, which makes test_ima failed.

Fix it by adding ima_setup.sh to TEST_PROGS_EXTENDED.

Fixes: 34b82d3ac105 ("bpf: Add a selftest for bpf_ima_inode_hash")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tools/testing/selftests/bpf/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 5944d3a8fff6..b4fd1352a2ac 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -75,7 +75,7 @@ TEST_PROGS := test_kmod.sh \
 	test_xsk.sh
 
 TEST_PROGS_EXTENDED := with_addr.sh \
-	with_tunnels.sh \
+	with_tunnels.sh ima_setup.sh \
 	test_xdp_vlan.sh test_bpftool.py
 
 # Compile but not part of 'make run_tests'
-- 
2.35.1

