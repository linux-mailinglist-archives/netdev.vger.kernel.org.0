Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C0404F4517
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 00:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387112AbiDEOaH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 10:30:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239653AbiDEOWz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 10:22:55 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF7D16C926;
        Tue,  5 Apr 2022 06:09:45 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d15so5509571pll.10;
        Tue, 05 Apr 2022 06:09:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AoLorMs2QPgOPZx/oN2eqUEASVkggfVUhBUk0oLgaIg=;
        b=WVhseiONPVkjXGRNnbzJf1cwdGlUzmhqLfwTxM8ffS3nH9X8W+39MZqpIuJgRdVNrd
         g6qbXWDc/Cm8HMgzHQ5qchrKayqLLWH7J4Ct0P/H1rgjenypPZhz0n/TitSWMGHJ46BH
         3JnQe2Kof4b4sN+pBGY73x/Pwy+6dN/XF8kewnSb4b00x3MdT8RrRILcqUXZXA10IE2r
         8MjvaoOR9CG0uiuR82dkHNkJ5bhpKOqGr8OvT8kw0Hi0xPCakbYLSfHtYwnlGJLkwz1W
         eyjz3vTp6jFxtrESgV2M8TDfMC/QcQSTN7wj/OEyvP/igtgTN4f0WSXKH8Eek5hXLZc1
         6soQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AoLorMs2QPgOPZx/oN2eqUEASVkggfVUhBUk0oLgaIg=;
        b=cI5raQBYw4fZRAIgMSEQBgBG7W98XsGt9eOnuJD2IDMaoxAK3OeWPmq4mn7M1BLzC1
         bi0hOF/xSJqfUmaPvmUnbquZC8bczM/50QQ0oSyNriEuFH738J1lCFxEmKtzbSUmRKx1
         eW55S2+CY1xfvxbnn8cuoc66tyk4cdURAYKukPXCiUUM9VWjqh3X+Y3j2gERlcaSB7jQ
         rM2l/XGzLa8F+uowgOsy53xfYiNKIDCrenUUuYL6E/9e9jmnBLrxasBy0Rb7UCML02kJ
         uXiYv7PFdyXR/u6GyY1LOEa8rlel5F6yEqWmE45U2axFLZzROtnmyR7rzMMl/8c39oNe
         /SRg==
X-Gm-Message-State: AOAM531sOLvEoslWXPDFWWajT6dn9giHi7/6Vem19oN/jTpci7LL/xjH
        vfii/0baNAqUNm311ZVlGZnw1HgCThXcw5tqH3M=
X-Google-Smtp-Source: ABdhPJy9Z75yqt2caLKMmfNSTkEFqHRvzIzosB9B7l1484grBYN61cIXBVUYYCR2FLCueukUQCexUA==
X-Received: by 2002:a17:90b:1d04:b0:1c7:b10f:e33d with SMTP id on4-20020a17090b1d0400b001c7b10fe33dmr4069150pjb.165.1649164184763;
        Tue, 05 Apr 2022 06:09:44 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:5271:5400:3ff:feef:3aee])
        by smtp.gmail.com with ESMTPSA id s135-20020a63778d000000b0038259e54389sm13147257pgc.19.2022.04.05.06.09.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 06:09:44 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     andrii@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, shuah@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next v3 21/27] bpf: samples: Use libbpf 1.0 API mode instead of RLIMIT_MEMLOCK in xdpsock_user
Date:   Tue,  5 Apr 2022 13:08:52 +0000
Message-Id: <20220405130858.12165-22-laoar.shao@gmail.com>
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
 samples/bpf/xdpsock_user.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index 6f3fe30ad283..be7d2572e3e6 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -25,7 +25,6 @@
 #include <string.h>
 #include <sys/capability.h>
 #include <sys/mman.h>
-#include <sys/resource.h>
 #include <sys/socket.h>
 #include <sys/types.h>
 #include <sys/un.h>
@@ -1886,7 +1885,6 @@ int main(int argc, char **argv)
 {
 	struct __user_cap_header_struct hdr = { _LINUX_CAPABILITY_VERSION_3, 0 };
 	struct __user_cap_data_struct data[2] = { { 0 } };
-	struct rlimit r = {RLIM_INFINITY, RLIM_INFINITY};
 	bool rx = false, tx = false;
 	struct sched_param schparam;
 	struct xsk_umem_info *umem;
@@ -1917,11 +1915,8 @@ int main(int argc, char **argv)
 				data[1].effective, data[1].inheritable, data[1].permitted);
 		}
 	} else {
-		if (setrlimit(RLIMIT_MEMLOCK, &r)) {
-			fprintf(stderr, "ERROR: setrlimit(RLIMIT_MEMLOCK) \"%s\"\n",
-				strerror(errno));
-			exit(EXIT_FAILURE);
-		}
+		/* Use libbpf 1.0 API mode */
+		libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
 
 		if (opt_num_xsks > 1)
 			load_xdp_program(argv, &obj);
-- 
2.17.1

