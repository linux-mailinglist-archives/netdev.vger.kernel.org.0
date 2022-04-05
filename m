Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15F7A4F42BC
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 23:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387015AbiDEO3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 10:29:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357132AbiDEOVl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 10:21:41 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11548633A4;
        Tue,  5 Apr 2022 06:09:36 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id s21so3322273pgs.4;
        Tue, 05 Apr 2022 06:09:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=k28g5EeU/WfIHlZtYq94DWyJZdavi8smqdidXz4XtpQ=;
        b=PULVsb8kzvv6ObZ0JsyKSvI0U//f9rCwRb1q5Y0ExEUHXWzNDgipzq9CXXk5eXhQ37
         KXewAPMKAwgjRreqTNAoJ9xLmh67Tar0UPdWH8AMtXAXejyiU03LTWpoqY6iyWhOyugg
         tsp1DLm+Mk8pQiTbkyrmCgSLwuFSlfRwOdT2NjbZAZAtwt+KO1hhhO7FpCwBDhr3yMj0
         lRXAWCwG5Yp8RfFAqdE+T0Yh5S3g8slQ7MkgVKE3Nol0BFW35lDVGmWaqkAOacRzy/EA
         vO6lb7kxLmEIM26Sldl0racbwgfQ4Q4q5wh6pkvBslySdxPDHXwu9jztWucQsF0Gpsnx
         TLdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k28g5EeU/WfIHlZtYq94DWyJZdavi8smqdidXz4XtpQ=;
        b=z6isbDEiSRxMduIubo5BL4Vmpz69XTrR0ZCgXwliT2PH7yS25b9PsXo40Le8lg+Eud
         4RFyNnjvKImYjO6o+/y7GfKlnkP6cEOOjbqgBoL6Fwo1u0KtQtnYqg5swzymXrdhqr8D
         hsnyyeP270kiBs/qzngxHzf3+TKGdcVtAlem5Hq3mKATlRAq/OIn1g6bs2BMzjH5HouJ
         SOdboySC96KefY6h3R5xl9kagj83+QQgSL2EOJZWCO9AnQwExM1p+cExnBfDWdGu0Rj5
         EpqReEex3Y7vxgiLwcePXpTVeOPJFjzgpaosWltgQ6Yfou5eU40zVXj7gySPgkoT3EML
         FDyA==
X-Gm-Message-State: AOAM532ZX1ar0RUZyGObIn2DT+N8JQHeKSx0wStAwIAnPSPVYUAbjSyA
        VGDEAxbpgULB6zEmFVCjj6s=
X-Google-Smtp-Source: ABdhPJyRmKtYXl+uldeU2/sau6lg4qGKj7BKnbv7aJgX16+TL/snmpPQ8SuJBxDz548WB6/+7LFYlg==
X-Received: by 2002:a05:6a02:114:b0:381:4931:1f96 with SMTP id bg20-20020a056a02011400b0038149311f96mr2754232pgb.331.1649164175654;
        Tue, 05 Apr 2022 06:09:35 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:5271:5400:3ff:feef:3aee])
        by smtp.gmail.com with ESMTPSA id s135-20020a63778d000000b0038259e54389sm13147257pgc.19.2022.04.05.06.09.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 06:09:35 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     andrii@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, shuah@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next v3 16/27] bpf: selftests: Set libbpf 1.0 API mode explicitly in test_tcp_check_syncookie_user
Date:   Tue,  5 Apr 2022 13:08:47 +0000
Message-Id: <20220405130858.12165-17-laoar.shao@gmail.com>
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
 tools/testing/selftests/bpf/test_tcp_check_syncookie_user.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_tcp_check_syncookie_user.c b/tools/testing/selftests/bpf/test_tcp_check_syncookie_user.c
index b9e991d43155..b57f3f0467e5 100644
--- a/tools/testing/selftests/bpf/test_tcp_check_syncookie_user.c
+++ b/tools/testing/selftests/bpf/test_tcp_check_syncookie_user.c
@@ -15,7 +15,6 @@
 #include <bpf/bpf.h>
 #include <bpf/libbpf.h>
 
-#include "bpf_rlimit.h"
 #include "cgroup_helpers.h"
 
 static int start_server(const struct sockaddr *addr, socklen_t len)
@@ -214,6 +213,9 @@ int main(int argc, char **argv)
 		exit(1);
 	}
 
+	/* Use libbpf 1.0 API mode */
+	libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
+
 	results = get_map_fd_by_prog_id(atoi(argv[1]), &xdp);
 	if (results < 0) {
 		log_err("Can't get map");
-- 
2.17.1

