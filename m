Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A5BB4F466E
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 01:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387099AbiDEOaC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 10:30:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386611AbiDEOWO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 10:22:14 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B28266CBA;
        Tue,  5 Apr 2022 06:09:40 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id bo5so12048496pfb.4;
        Tue, 05 Apr 2022 06:09:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=37SR7Zn31WWBGX9RkRYaZCh1XxNUj+JjDrpjS5zX3xw=;
        b=JNksm1P71eENbHVREKVq7V+oFiG698bw+ibxUTkrtCwpk5e589wfIVtk06SzOGK6ea
         26zybbYD2Fgn7VqAqwdHWyvRNKU35j4ZUD8hoCUbV4XFijZkRNQvE3w/SV+bCfpe6VrB
         Smlol8WNulgRXh9nAg1lRgjpCb9k4KtTP0xB4PewZ/iMyVqP413FdHcwW+z5AzFmpS1W
         xgq5jdgzwuEYQFqE3CfTkSGtB5N2rcR1LCsY53jDILv/j1JgFJ9lCArekaUuu6Chyw4d
         6BKppHQJMJ7wSY1VFCiKxesks6Z72sg9QnfhG71Y8eYOvCDmiaCDt7oiHVMuGzuI5Xiu
         BkQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=37SR7Zn31WWBGX9RkRYaZCh1XxNUj+JjDrpjS5zX3xw=;
        b=vrY5iY2gbMaEGg2ssE+Eg1JE/1xYZymO6iSH+PdqikUC8Ij78M67kxM6o8NTWOGAGQ
         EmOM2xRA/yeq0MkivmHe0Ubmg//jVPEpTxberqqTtwOxqxXNtiR290wg7AR9aUbmGayh
         pmd76jeNDZBKgn7f7NYeoei5NIKep5To5uQesJtVZ3ZyPk0VlsC87+Wmgu6n9//ScvIi
         UjnvEtVTk9c6ZI0PlWuNcCVZTUpAhY9Kv/VU4Kt/hWi1xqWwSwnI4u6AArgUDV4iZlEG
         DVZtuDmL1cVuPE7guSaSwfuaGiM9zuoi8kCGL2vOW6jp9lsvZCsKtZ3tFW2nQVmboBIh
         NChg==
X-Gm-Message-State: AOAM532CHCwHQx6sVangCrl8//m5JT6oVjoL7GxTvcRc/rGGmQAfbbSW
        2jZQrdh5TGPyRedOlr6Y77c=
X-Google-Smtp-Source: ABdhPJwWpczVL736y96tsDeroidAaWlHqfGEIpmpIQzcnUDPLxSVjZc0aijMy2B9dtOd04PvJ+/HUQ==
X-Received: by 2002:a63:7741:0:b0:386:330e:1dcd with SMTP id s62-20020a637741000000b00386330e1dcdmr2744552pgc.71.1649164179481;
        Tue, 05 Apr 2022 06:09:39 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:5271:5400:3ff:feef:3aee])
        by smtp.gmail.com with ESMTPSA id s135-20020a63778d000000b0038259e54389sm13147257pgc.19.2022.04.05.06.09.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 06:09:38 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     andrii@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, shuah@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next v3 19/27] bpf: selftests: Get rid of bpf_rlimit.h
Date:   Tue,  5 Apr 2022 13:08:50 +0000
Message-Id: <20220405130858.12165-20-laoar.shao@gmail.com>
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

All the files which included bpf_rlimit.h have been set strict mode
explicitly, so we can get rid of it now.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 tools/testing/selftests/bpf/bpf_rlimit.h | 28 ------------------------
 1 file changed, 28 deletions(-)
 delete mode 100644 tools/testing/selftests/bpf/bpf_rlimit.h

diff --git a/tools/testing/selftests/bpf/bpf_rlimit.h b/tools/testing/selftests/bpf/bpf_rlimit.h
deleted file mode 100644
index 9dac9b30f8ef..000000000000
--- a/tools/testing/selftests/bpf/bpf_rlimit.h
+++ /dev/null
@@ -1,28 +0,0 @@
-#include <sys/resource.h>
-#include <stdio.h>
-
-static  __attribute__((constructor)) void bpf_rlimit_ctor(void)
-{
-	struct rlimit rlim_old, rlim_new = {
-		.rlim_cur	= RLIM_INFINITY,
-		.rlim_max	= RLIM_INFINITY,
-	};
-
-	getrlimit(RLIMIT_MEMLOCK, &rlim_old);
-	/* For the sake of running the test cases, we temporarily
-	 * set rlimit to infinity in order for kernel to focus on
-	 * errors from actual test cases and not getting noise
-	 * from hitting memlock limits. The limit is on per-process
-	 * basis and not a global one, hence destructor not really
-	 * needed here.
-	 */
-	if (setrlimit(RLIMIT_MEMLOCK, &rlim_new) < 0) {
-		perror("Unable to lift memlock rlimit");
-		/* Trying out lower limit, but expect potential test
-		 * case failures from this!
-		 */
-		rlim_new.rlim_cur = rlim_old.rlim_cur + (1UL << 20);
-		rlim_new.rlim_max = rlim_old.rlim_max + (1UL << 20);
-		setrlimit(RLIMIT_MEMLOCK, &rlim_new);
-	}
-}
-- 
2.17.1

