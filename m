Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB4E4F452C
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 00:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387008AbiDEO25 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 10:28:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355258AbiDEOVj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 10:21:39 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D393F652F0;
        Tue,  5 Apr 2022 06:09:34 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id q142so9209584pgq.9;
        Tue, 05 Apr 2022 06:09:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kEvX7e1LRk8hq7EVC3eBy2OeVtrJmQlrIB7WWAJzilU=;
        b=aAXm1ETsLlBg2pebplD2DAO8ZOpD8sm3uSZtJsg9vwmAg0ZExijiYvoiZr+4iG4e1H
         U6rm2IL2gwyTBTywqvmn2Sp4+ZmiUrNFw9Lgw2i1AEWZzsatJYBQxpPAyuUpLYpFa6lc
         ED7oiFFQ7NlzuzTbS3cEvSPfFcqosfZn6Hg5s6YHDuDRo5ckOPI3yT0xXrnR3bKcp3HI
         iB835vR/jzg0XQz6k0bROHd162OQruI4Lli449zaxIwYM9eZqUaZzSJv1mYLqidZwv5n
         BnCXZkfOGdSGH/2ab8++dCS2CGDkCQGA9+3A7JrbU3XGSfiWhYT+PcQczYScoU1ywNgg
         b6EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kEvX7e1LRk8hq7EVC3eBy2OeVtrJmQlrIB7WWAJzilU=;
        b=Xo7l+gXtcUyGJeJCTOc0j+FFgYGZug6RcWPt9jlS8DWoaTpEinekObjl4LlQLmtd6P
         VZtXpKEntW+hj4qI5A+RWGazRXU6hwwYEMevIaWpfaVNeP9QnaM/6b84YprlVsndy5cS
         hx1lSVK6zXXeDW6VMxRm53Wug1m3JNJtZnBHRNI3zcaXQuxqflC97is8o55TiHnFjwAi
         HoKkqcS36RDqBJBT300iyeyOfKfkdk04wr3K8y7Dd3ELoDAtRp0LwuNZ2fmOzSJ2juf5
         VnEg/XIhr3CyBKLjckBrcQqbTreEsPtfIcXHsRGo4SjV+zGoP1OhbpWT/F/T28jNTcW2
         Qs6Q==
X-Gm-Message-State: AOAM533K6lbM2VB27pqNOah3iPOZuuqUita6+vXMws//jBmlaLeRW0Rq
        S0ZBOpoCbrshWU15ZtEwGfM=
X-Google-Smtp-Source: ABdhPJzV/FBtnA3fMwNnZGWzf3lprriAFgMU658FYakS9xPeDccuO6wPRtGV1fDrEV7npZ5AzY+Teg==
X-Received: by 2002:a05:6a00:87:b0:4fb:39f9:bb9d with SMTP id c7-20020a056a00008700b004fb39f9bb9dmr3585296pfj.48.1649164174417;
        Tue, 05 Apr 2022 06:09:34 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:5271:5400:3ff:feef:3aee])
        by smtp.gmail.com with ESMTPSA id s135-20020a63778d000000b0038259e54389sm13147257pgc.19.2022.04.05.06.09.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 06:09:33 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     andrii@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, shuah@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next v3 15/27] bpf: selftests: Set libbpf 1.0 API mode explicitly in test_tag
Date:   Tue,  5 Apr 2022 13:08:46 +0000
Message-Id: <20220405130858.12165-16-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220405130858.12165-1-laoar.shao@gmail.com>
References: <20220405130858.12165-1-laoar.shao@gmail.com>
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

Let's set libbpf 1.0 API mode explicitly, then we can get rid of the
included bpf_rlimit.h.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 tools/testing/selftests/bpf/test_tag.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_tag.c b/tools/testing/selftests/bpf/test_tag.c
index 0851c42ee31c..5546b05a0486 100644
--- a/tools/testing/selftests/bpf/test_tag.c
+++ b/tools/testing/selftests/bpf/test_tag.c
@@ -20,7 +20,6 @@
 #include <bpf/bpf.h>
 
 #include "../../../include/linux/filter.h"
-#include "bpf_rlimit.h"
 #include "testing_helpers.h"
 
 static struct bpf_insn prog[BPF_MAXINSNS];
@@ -189,6 +188,9 @@ int main(void)
 	uint32_t tests = 0;
 	int i, fd_map;
 
+	/* Use libbpf 1.0 API mode */
+	libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
+
 	fd_map = bpf_map_create(BPF_MAP_TYPE_HASH, NULL, sizeof(int),
 				sizeof(int), 1, &opts);
 	assert(fd_map > 0);
-- 
2.17.1

