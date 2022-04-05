Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 603F84F3FCF
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 23:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355977AbiDEUDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 16:03:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1452812AbiDEPzf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 11:55:35 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 172177B546;
        Tue,  5 Apr 2022 07:57:25 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id bx5so12076459pjb.3;
        Tue, 05 Apr 2022 07:57:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0fNKMdl5EgB8iVKO3jm7hq1ylGNE7urfWADlkF8zHzk=;
        b=ouZF9rErW74fo9ZonM3kbl48QBEP9m7ukEs8xbgviCGPBdG1trn8OYOgkunWQrv9Xp
         6AsDq1Mz0OFkH2tTIlJgL6697IdMgJIPV0xamecang18e+ZTD9QzKrLKIOemtmNtZW6t
         xMPbhL1GoZEAY6Vnb/Yj+ErgsRHJiFecRFJ2obcylz0YhPP5CkxJZqjNp9VG6pqKtxsD
         U/JfTW3WzHYACaSRHW++KVgDT/a69ci5QEadZN53z7/PEuEX4DIIcYJtAvRS1y5+32vF
         Nt5yBVd89OcTKFi9DIAkhjJiu7wvvHFYZiWP8TTmuLgqCpceUoKOnQWWRSKZRJiimpqL
         se1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0fNKMdl5EgB8iVKO3jm7hq1ylGNE7urfWADlkF8zHzk=;
        b=vYW9t33g0mxb9quEvP2AO+OL4fglUipaaue7Jn8kSMSyggi9I4tVVoYb1ZXNCjTfKw
         dMgGvz7n/v/2l0d/Q8ntK1RVDPfYBBuVtHWPi/Ocu0GgqgPbCIhhYGq4wh8IE25ZCSv+
         w5O9y5ZFytVQRiwrzSO4b7+rtwNA9rdc6NMpKIYdzqXL26lEiGaqJiCLWQoCuaIxCEP5
         JfoAq2NMWVpu+p21kXNfmTjxb4yzhoVq/l0yi6sSxbyv8grvzl2Cy3wNNShDvYcShVr0
         nhQicEUC2AJq0N13Bk8czCGgxtxVJ44HCFXMSVJEt9SawSvHcq5r9JO/gzhTfVnkb7NO
         wO6Q==
X-Gm-Message-State: AOAM532WEqjPW57GTP92zfbAVf/4h2mDAwh2k0R/RAJM2f9B3Q0Rc2Ti
        P9CEOfJotoe9hUIS9roRUv0=
X-Google-Smtp-Source: ABdhPJxNnD+uON5FVNi6s4DMI5cEjuwS1ZmzNMYMxcdxqmxddZ+4IwfYpWLoUaQhrUAbn0pDSnfLsg==
X-Received: by 2002:a17:90a:4604:b0:1bc:8bdd:4a63 with SMTP id w4-20020a17090a460400b001bc8bdd4a63mr4582646pjg.147.1649170644566;
        Tue, 05 Apr 2022 07:57:24 -0700 (PDT)
Received: from localhost.localdomain ([223.212.58.71])
        by smtp.gmail.com with ESMTPSA id 3-20020a17090a034300b001c779e82af6sm2687794pjf.48.2022.04.05.07.57.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 07:57:23 -0700 (PDT)
From:   Yuntao Wang <ytcoode@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Yuntao Wang <ytcoode@gmail.com>
Subject: [PATCH bpf-next] selftests/bpf: Fix file descriptor leak in load_kallsyms()
Date:   Tue,  5 Apr 2022 22:57:11 +0800
Message-Id: <20220405145711.49543-1-ytcoode@gmail.com>
X-Mailer: git-send-email 2.35.1
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

Currently, if sym_cnt > 0, it just returns and does not close file, fix it.

Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
---
 tools/testing/selftests/bpf/trace_helpers.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/trace_helpers.c b/tools/testing/selftests/bpf/trace_helpers.c
index 3d6217e3aff7..9c4be2cdb21a 100644
--- a/tools/testing/selftests/bpf/trace_helpers.c
+++ b/tools/testing/selftests/bpf/trace_helpers.c
@@ -25,15 +25,12 @@ static int ksym_cmp(const void *p1, const void *p2)
 
 int load_kallsyms(void)
 {
-	FILE *f = fopen("/proc/kallsyms", "r");
+	FILE *f;
 	char func[256], buf[256];
 	char symbol;
 	void *addr;
 	int i = 0;
 
-	if (!f)
-		return -ENOENT;
-
 	/*
 	 * This is called/used from multiplace places,
 	 * load symbols just once.
@@ -41,6 +38,10 @@ int load_kallsyms(void)
 	if (sym_cnt)
 		return 0;
 
+	f = fopen("/proc/kallsyms", "r");
+	if (!f)
+		return -ENOENT;
+
 	while (fgets(buf, sizeof(buf), f)) {
 		if (sscanf(buf, "%p %c %s", &addr, &symbol, func) != 3)
 			break;
-- 
2.35.1

