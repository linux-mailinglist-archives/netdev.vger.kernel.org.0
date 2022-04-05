Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF1C04F450C
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 00:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386997AbiDEO2i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 10:28:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350769AbiDEOVe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 10:21:34 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E92763BF7;
        Tue,  5 Apr 2022 06:09:32 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d15so5509096pll.10;
        Tue, 05 Apr 2022 06:09:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=h7LdoFvQo1dYowij4laTQ3Abm1VMgnAUFDQSNCGV4+8=;
        b=MBpcVXiJYabVjr+AB2B6shNFTIv3+T8kBZri1brekPSjtT2uFwwUuu8FRinmlVap+J
         TAFCwu8eqaR9lriYocP9eg89tPLDZHSgmgvMsDPEIcOob+C0F2WGN7p06qtNQxjOfoOk
         +Z28c0gZxi8gJIjZX3UqWlBdPtGKfo/r4J4xfM8/hSkyUO7QFGWvsfjzmYhOg6XPgda2
         AVub9r4rsIw1+Pmjc4GgvcWIjnSILyGZnM4u0wOV0BxT8zGx3POTptUWecey587pTXZQ
         0lvoGaGkwop/7ANm0/lNcniV1MRTtke5NplxO7YLW1HCddmmbotigKqt+LEdHuUQQoNX
         QIcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h7LdoFvQo1dYowij4laTQ3Abm1VMgnAUFDQSNCGV4+8=;
        b=CkBVd7jCADVOZngwl7g9rjknarVi4wre4Ub9IYfjlY3IpymXg1mD5gniZS6NZy9+Qq
         TjybVUyXWWtvrF6VUIExHI8RH3/icMTjwpfl9wPaE3H9d2IW3Kx23HpAYtTR5fl1aQvw
         PjAbxU1m9x2RKb3p+1s9hGy7KL9y8xnZudYCR9RjerKDXEHHLXF7EhC2z19rMhWZChhf
         ef0XoDbGQLzwzw2WNLNVO1aOGCcrY3rFy65ZrxQl6Yuc4Arwi18jAKQUSAkEQ2VIsHmn
         jHxS0J9zy91jZMs21WIO0tAkgMcUeUEtc1PxitcD9tGzLFdIAipoWcp12djrFEhRe1bE
         ZMdg==
X-Gm-Message-State: AOAM530fpoZXmKsTlBaaNxv4UvqN0uHSgck5nbarBJJJhOKJcPlvlK42
        9b7cw/8OCSsAuzqAS0rxhtDizTtPROEaB6zhSuM=
X-Google-Smtp-Source: ABdhPJymXpm2XVgcNbbwgyfdWolQo0c1Kn1R2p/6WKD2zVPmz7OrkFaHtXtc2cQYbOo6fTe84nbRig==
X-Received: by 2002:a17:902:c105:b0:154:81e0:529d with SMTP id 5-20020a170902c10500b0015481e0529dmr3470701pli.1.1649164171840;
        Tue, 05 Apr 2022 06:09:31 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:5271:5400:3ff:feef:3aee])
        by smtp.gmail.com with ESMTPSA id s135-20020a63778d000000b0038259e54389sm13147257pgc.19.2022.04.05.06.09.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 06:09:31 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     andrii@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, shuah@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next v3 13/27] bpf: selftests: Set libbpf 1.0 API mode explicitly in test_sockmap
Date:   Tue,  5 Apr 2022 13:08:44 +0000
Message-Id: <20220405130858.12165-14-laoar.shao@gmail.com>
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
included bpf_rlimit.h. This patch also removes the useless sys/resource.h.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 tools/testing/selftests/bpf/test_sockmap.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_sockmap.c b/tools/testing/selftests/bpf/test_sockmap.c
index dfb4f5c0fcb9..0fbaccdc8861 100644
--- a/tools/testing/selftests/bpf/test_sockmap.c
+++ b/tools/testing/selftests/bpf/test_sockmap.c
@@ -18,7 +18,6 @@
 #include <sched.h>
 
 #include <sys/time.h>
-#include <sys/resource.h>
 #include <sys/types.h>
 #include <sys/sendfile.h>
 
@@ -37,7 +36,6 @@
 #include <bpf/libbpf.h>
 
 #include "bpf_util.h"
-#include "bpf_rlimit.h"
 #include "cgroup_helpers.h"
 
 int running;
@@ -2017,6 +2015,9 @@ int main(int argc, char **argv)
 		cg_created = 1;
 	}
 
+	/* Use libbpf 1.0 API mode */
+	libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
+
 	if (test == SELFTESTS) {
 		err = test_selftest(cg_fd, &options);
 		goto out;
-- 
2.17.1

