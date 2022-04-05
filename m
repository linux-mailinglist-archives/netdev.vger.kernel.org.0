Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C74D4F4427
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 00:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237595AbiDEO0s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 10:26:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239002AbiDEOUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 10:20:45 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D568583A5;
        Tue,  5 Apr 2022 06:09:20 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id s14-20020a17090a880e00b001caaf6d3dd1so2457391pjn.3;
        Tue, 05 Apr 2022 06:09:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oJKQa4o5EW97T4GszU9cQl3yQ4+D9/MOy/9Q98ExjgU=;
        b=CKV/+bz9je/AeRZtW8jTOsniv2lYra59+Xo9XDz0xGbuPb3WJ3gbymqtNp5/1ortGe
         gDFTw8ejIlNh1wVHlE5zRUP1lxWNwuGPx2x+xU0cjJo801Zmc4yTJr8hljd8N4pJUZ4t
         83yCEBxjE/vZ4cQBhEt25C9A38+iHKWgEQolPQsMoAXPgi+48q4EJC9/apcJen1iXz4g
         hhXDWwiwgf5Y8L6ew33KF8g1s5/IXS3gPwTxNVDBmbF91zfHWg5fE5p8r4MulGhkXD4h
         a3T4mwMlm48XmvbQOW30oMceB/vXR+5lq3ff3S5JEzPRJ3vNAAIa05jLoObNEcF4tJow
         NTKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oJKQa4o5EW97T4GszU9cQl3yQ4+D9/MOy/9Q98ExjgU=;
        b=SNdZE4dlJ9gpmgIxy7L5yPOCg/zZr01f8BRmmsn4GrgWBbPRWx0tcNqgXpCTpOpuVT
         264eTxmI9qCXnJ/vJC3CdPaaLW00bgAIDOyZSTuCj+2VhYoQ6gUpKk3ZHBvBZvY1QaUz
         EeSkHTLncXa9Ke+gvl+TaNAAFsMwJcysmZu5rTLYLGZGgXrABw/dW9YhDvcYofiBXU3b
         6wRjngsRBSXhyV5Y7yC0KUVRjAUDoGCGvfPqvzCrQOzUprHY+q3TqzqigmT7ampjEvUI
         LxSMLpzcbb1LHqN3wxebWtSQA2MBT+BvTnbgezD2e0WHJpgnzGNaza3l0TScMjzlUvkL
         uZ9A==
X-Gm-Message-State: AOAM533lhJ1uEh2ibJ4w+26sygFwfnOaMe5RbVtoE+YjQ7Y1a2dSbTtv
        4PpmkCiwiRl7KjnTzFlrSOw=
X-Google-Smtp-Source: ABdhPJznP7jESnDNdmvBgmtaRzRN16mcRxehZkNCqEVVX2qXZvG9glkmINSFnyu1JOs3HrKdZNAG3Q==
X-Received: by 2002:a17:90b:4f86:b0:1c9:b52d:9713 with SMTP id qe6-20020a17090b4f8600b001c9b52d9713mr4002616pjb.98.1649164160150;
        Tue, 05 Apr 2022 06:09:20 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:5271:5400:3ff:feef:3aee])
        by smtp.gmail.com with ESMTPSA id s135-20020a63778d000000b0038259e54389sm13147257pgc.19.2022.04.05.06.09.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 06:09:19 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     andrii@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, shuah@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next v3 04/27] bpf: selftests: No need to include bpf_rlimit.h in flow_dissector_load
Date:   Tue,  5 Apr 2022 13:08:35 +0000
Message-Id: <20220405130858.12165-5-laoar.shao@gmail.com>
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
header bpf_rlimit.h any more. This patch also removes the check of the
return value of libbpf_set_strict_mode as it always return 0.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 tools/testing/selftests/bpf/flow_dissector_load.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/flow_dissector_load.c b/tools/testing/selftests/bpf/flow_dissector_load.c
index 87fd1aa323a9..c8be6406777f 100644
--- a/tools/testing/selftests/bpf/flow_dissector_load.c
+++ b/tools/testing/selftests/bpf/flow_dissector_load.c
@@ -11,7 +11,6 @@
 #include <bpf/bpf.h>
 #include <bpf/libbpf.h>
 
-#include "bpf_rlimit.h"
 #include "flow_dissector_load.h"
 
 const char *cfg_pin_path = "/sys/fs/bpf/flow_dissector";
@@ -25,9 +24,8 @@ static void load_and_attach_program(void)
 	int prog_fd, ret;
 	struct bpf_object *obj;
 
-	ret = libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
-	if (ret)
-		error(1, 0, "failed to enable libbpf strict mode: %d", ret);
+	/* Use libbpf 1.0 API mode */
+	libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
 
 	ret = bpf_flow_load(&obj, cfg_path_name, cfg_prog_name,
 			    cfg_map_name, NULL, &prog_fd, NULL);
-- 
2.17.1

