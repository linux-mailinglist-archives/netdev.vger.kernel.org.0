Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9EC04F4099
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 23:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243940AbiDEO1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 10:27:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239486AbiDEOUx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 10:20:53 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A8EB5469B;
        Tue,  5 Apr 2022 06:09:16 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id y6so10870393plg.2;
        Tue, 05 Apr 2022 06:09:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wSuFwOYpdtbASUJoe+qWyA3r8BIwMHUAdZNI2pGENlA=;
        b=Uus7pT+YXAs7zc8LdNuZkMZCLiVRn9G8HSRKzeLRwo30ybJnF/VS0lKGiqBpCP9ke3
         Qtiyobxb4FLUgbsp8cB4+NHGFKGFhtq+TDLYqHbWJOVPCm4DmwqQ08foLlr9qUNHoSV2
         I0b9zoFuqmQH9xF7qMOieQuweW5X85bj7BUTtWbxfIuqqk1+lFHkZyzm9mzFcIcarrKF
         okcBDZLqrmxUaGsjtccZ7Ut7TZikn7ak+My+8spiMlU+MuQcLuiL8MQPtwl7Y9rUoP/k
         rdSe0rp58lbfs1+YdT7hrnWuR7wIruye1tpHbQRHgXtUXMeB6OPxutpYYol6bRUnwXbz
         ZVIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wSuFwOYpdtbASUJoe+qWyA3r8BIwMHUAdZNI2pGENlA=;
        b=Kryks27smKlTFK5XmZZt5rzdo+Kon4M9555z9VN35TSZAvwiS95Nk2d79SC2KoyQrT
         TJlKS0QMDV6nFAUuMkSPXRn5D6BdbRxuwhChJzPRt4YxJ8lYyWLHLAOAm6nekcOnphM3
         JUqDyo1AcEGL3rUnPwT81NL2zHaj5Zw5d5o+EEVP+nz5BS/aZlwQ+d/4n8vqh0LKS2+4
         R1chfx6tBHh8yj7ruZBxqjlqDwi6v3RHCQDq3gpzbjFMJ/tcK7pqgZEqhZhqDB5bg36A
         ZCeoMg1+pkaeZ/Peoa9yY0EixXd/UN+CWEflarzz4uIqYuF8L9hIFl95/EfZe5MiiPDU
         nrhw==
X-Gm-Message-State: AOAM530tKCkuWS2UzwZsKc4r4X6abRxOAmGYDc1Juhhzwy5Qe65jTQJE
        2aLVcODWU0RVQTCYN6aqkYfgi6KndsESDbQoi5E=
X-Google-Smtp-Source: ABdhPJwNOnvF5W8WDLD3aQec7f1GksrKIIZSRzrtFHy7ECMGCxBC4lOWRyztJT6yzEZThB6CK838EQ==
X-Received: by 2002:a17:903:1251:b0:156:9d8e:1077 with SMTP id u17-20020a170903125100b001569d8e1077mr3297756plh.116.1649164156322;
        Tue, 05 Apr 2022 06:09:16 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:5271:5400:3ff:feef:3aee])
        by smtp.gmail.com with ESMTPSA id s135-20020a63778d000000b0038259e54389sm13147257pgc.19.2022.04.05.06.09.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 06:09:15 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     andrii@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, shuah@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next v3 01/27] bpf: selftests: Use libbpf 1.0 API mode instead of RLIMIT_MEMLOCK in xdping
Date:   Tue,  5 Apr 2022 13:08:32 +0000
Message-Id: <20220405130858.12165-2-laoar.shao@gmail.com>
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

Explicitly set libbpf 1.0 API mode, then we can avoid using the deprecated
RLIMIT_MEMLOCK.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 tools/testing/selftests/bpf/xdping.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdping.c b/tools/testing/selftests/bpf/xdping.c
index c567856fd1bc..5b6f977870f8 100644
--- a/tools/testing/selftests/bpf/xdping.c
+++ b/tools/testing/selftests/bpf/xdping.c
@@ -12,7 +12,6 @@
 #include <string.h>
 #include <unistd.h>
 #include <libgen.h>
-#include <sys/resource.h>
 #include <net/if.h>
 #include <sys/types.h>
 #include <sys/socket.h>
@@ -89,7 +88,6 @@ int main(int argc, char **argv)
 {
 	__u32 mode_flags = XDP_FLAGS_DRV_MODE | XDP_FLAGS_SKB_MODE;
 	struct addrinfo *a, hints = { .ai_family = AF_INET };
-	struct rlimit r = {RLIM_INFINITY, RLIM_INFINITY};
 	__u16 count = XDPING_DEFAULT_COUNT;
 	struct pinginfo pinginfo = { 0 };
 	const char *optstr = "c:I:NsS";
@@ -167,10 +165,8 @@ int main(int argc, char **argv)
 		freeaddrinfo(a);
 	}
 
-	if (setrlimit(RLIMIT_MEMLOCK, &r)) {
-		perror("setrlimit(RLIMIT_MEMLOCK)");
-		return 1;
-	}
+	/* Use libbpf 1.0 API mode */
+	libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
 
 	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
 
-- 
2.17.1

