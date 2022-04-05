Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 648494F4068
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 23:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387045AbiDEO3V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 10:29:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384423AbiDEOVu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 10:21:50 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD9156620F;
        Tue,  5 Apr 2022 06:09:38 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id j20-20020a17090ae61400b001ca9553d073so2580654pjy.5;
        Tue, 05 Apr 2022 06:09:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FhL6szaOIov8q1MTsyxKYibc71cWtbvUxaMCdELcukY=;
        b=UdFrH7IfePmS7gBA2Y6A87vLczBLOXlYFS1PAT+68igoxj1xNyLomKwVt5+VwWYusv
         zVVtTgA/Q/4SzRJzHXs0uMahX3fxRxMOs9YDwwC1CeGWd6JV1YYhcnZakrW9G3UZNxq2
         i4NU4/wbJPWSN8SwoInnpqCPUh88xvXwK6ZhJkTdS//g9zusXDCqbSepuYUlQWfJqynN
         AvXocNAg0nkMmX5Xs/9EMkUvtM/4vbDluGk+AJDXQKMH0c4quY0TVBeWBBvsxLW/hW35
         OeW8e7cXfCvmTMP89PpkuHXrpfDOXQw9jeIrJ6vRyvKvDbI4QSSVX5gLPGHvkygKkhQm
         EvGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FhL6szaOIov8q1MTsyxKYibc71cWtbvUxaMCdELcukY=;
        b=zMlqatytD7rDzq3jqDEzHNxNrYI3dFpc7pV0cx5zFUheZrt+qRJAesxWe5580GrUFR
         0dzZcXmrPydzg0uab1DWQVGE3MuInam/8/9TFs0iV/PNsejWdGTLiT/I65kQMcPbPhBe
         qj1Vg5WDR7xQt5xeDsJMVuQdlbH1Fo3F4f0b8TZsgu0/DE+jbGyhsyQlIHMm6Vgq0Rhk
         +Jg2j/kNf8Yb8wgzTgqH+Vlq2CmQQVeKHoqCOyhCKvHhVNmvvp8vdtKFCz8llG6edf9c
         Qe9Cm6CtAiFOEO/wt4QhP26LOxz7cxGXPFJ1QokGCmAUoKD7aE1lhaQmCL2On7eIe/03
         q/Vw==
X-Gm-Message-State: AOAM533L8ch3ynYpxyuL3gwrhvz5LoYQuQSugVF/YI8zbvH92ELlyWpn
        Ql3cje2bpE7qHJupJsm1aw8=
X-Google-Smtp-Source: ABdhPJyNE1zvJOeZNYoK8gwD67tIg4Vc/3Lr8O45kKmMIN3LQF6VWc87lR/RbOBEeJ9KacixB2rPZw==
X-Received: by 2002:a17:902:edc5:b0:156:68e4:416 with SMTP id q5-20020a170902edc500b0015668e40416mr3444008plk.87.1649164178234;
        Tue, 05 Apr 2022 06:09:38 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:5271:5400:3ff:feef:3aee])
        by smtp.gmail.com with ESMTPSA id s135-20020a63778d000000b0038259e54389sm13147257pgc.19.2022.04.05.06.09.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 06:09:37 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     andrii@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, shuah@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next v3 18/27] bpf: samples: Set libbpf 1.0 API mode explicitly in hbm
Date:   Tue,  5 Apr 2022 13:08:49 +0000
Message-Id: <20220405130858.12165-19-laoar.shao@gmail.com>
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
included bpf_rlimit.h. It also remove the useless sys/resource.h.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 samples/bpf/hbm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/samples/bpf/hbm.c b/samples/bpf/hbm.c
index 1fe5bcafb3bc..516fbac28b71 100644
--- a/samples/bpf/hbm.c
+++ b/samples/bpf/hbm.c
@@ -34,7 +34,6 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <assert.h>
-#include <sys/resource.h>
 #include <sys/time.h>
 #include <unistd.h>
 #include <errno.h>
@@ -46,7 +45,6 @@
 #include <bpf/bpf.h>
 #include <getopt.h>
 
-#include "bpf_rlimit.h"
 #include "cgroup_helpers.h"
 #include "hbm.h"
 #include "bpf_util.h"
@@ -510,5 +508,8 @@ int main(int argc, char **argv)
 		prog = argv[optind];
 	printf("HBM prog: %s\n", prog != NULL ? prog : "NULL");
 
+	/* Use libbpf 1.0 API mode */
+	libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
+
 	return run_bpf_prog(prog, cg_id);
 }
-- 
2.17.1

