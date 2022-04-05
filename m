Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 792994F4661
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 01:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354873AbiDEO1q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 10:27:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238995AbiDEOUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 10:20:44 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5170E55772;
        Tue,  5 Apr 2022 06:09:19 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id 7so5026685pfu.13;
        Tue, 05 Apr 2022 06:09:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RzO5h+RKIrf7Gqk7og6upNh4VsrgEK5buc2FUy3EPRA=;
        b=cGQjMVoqb6TyLf4DVhs2iODHZbs0dHPtB4mVDG4vr8rmLZQwzXX9EKC1zmiNb/UzmI
         vT126bkYA5M8+vj6yEcibFWekKHhU/d0N0IChETDMoFcfVB6EWTWo6negsapPV54xdb4
         F4V2gX5xHAerS2ciPiYtOw4HOObmmYS1Q0TlDX9FSuzOD5nbPEMg4CTz4OtiAW5BDM0U
         26sE2cWIqdGgFdXEje3o0VDK5Kdpu23/dizEqQVQ+EKdwiK0NTazSpR+P6dLesBNSuSE
         mH18W0HF0dMhQ+wsro9bPDz8Mj2QsYOwhMnjpVBeIjQvwd+luA5AwWOlER5QLHPVYnqH
         FlNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RzO5h+RKIrf7Gqk7og6upNh4VsrgEK5buc2FUy3EPRA=;
        b=UdRELxf0A5kpRuhgXjpr+Ru8JRFNd4sXTCBAOBovaDYl4z/owmz0r10IDgh1TH/AZ5
         Z7/XrJcs73xfxgqp+n1Qh5XIJc0M2+jLMaLZmouxAmjlXfFuivTI0YZGkhR+SlvEydvE
         LATk46uIKH9RFplBIPupgRRtwpVUKXLWgbPnkBnfpdoo++2yDoq5NsN+DIqfhhP9x1bW
         ki1ndCxrJr9RHxmw+F2w6TU1l1xUKHmH2oamAJ9FWgr2E2TxOTz+3QqrkxUCltKVTrVr
         Iz5KgbsHETC8qQF3JBRe54Eov5xE87dUEr2BPBGQOgYCQblqoKT3QAAfzSwjkBV0HBSg
         aJfA==
X-Gm-Message-State: AOAM532UKGyqYostkG6w455d8lI0lEUJFhksVThCX5qXoYOHlToyQDU8
        SX8minGG4ykGR59P4xEknRc=
X-Google-Smtp-Source: ABdhPJxYAzS97HgZEW6Wu45iwJ161OfyrZ9vqa6FeZatOXuoC9D3n5QpirVXofY1PLOYKl/ApGgwiw==
X-Received: by 2002:a63:2d47:0:b0:399:53e3:5b4c with SMTP id t68-20020a632d47000000b0039953e35b4cmr2833214pgt.165.1649164158853;
        Tue, 05 Apr 2022 06:09:18 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:5271:5400:3ff:feef:3aee])
        by smtp.gmail.com with ESMTPSA id s135-20020a63778d000000b0038259e54389sm13147257pgc.19.2022.04.05.06.09.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 06:09:18 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     andrii@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, shuah@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next v3 03/27] bpf: selftests: No need to include bpf_rlimit.h in test_tcpnotify_user
Date:   Tue,  5 Apr 2022 13:08:34 +0000
Message-Id: <20220405130858.12165-4-laoar.shao@gmail.com>
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

We have set libbpf 1.0 API mode explicitly, so don't need to include the
header bpf_rlimit.h any more.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 tools/testing/selftests/bpf/test_tcpnotify_user.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_tcpnotify_user.c b/tools/testing/selftests/bpf/test_tcpnotify_user.c
index 4c5114765b23..8284db8b0f13 100644
--- a/tools/testing/selftests/bpf/test_tcpnotify_user.c
+++ b/tools/testing/selftests/bpf/test_tcpnotify_user.c
@@ -19,7 +19,6 @@
 #include <linux/perf_event.h>
 #include <linux/err.h>
 
-#include "bpf_rlimit.h"
 #include "bpf_util.h"
 #include "cgroup_helpers.h"
 
-- 
2.17.1

