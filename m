Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B3E7685C0E
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 01:18:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231663AbjBAASA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 19:18:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbjBAAR4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 19:17:56 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BC3F46AD
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 16:17:54 -0800 (PST)
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 1134E41AC9
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 00:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1675210672;
        bh=B79xjy+K/93G68irDU5evQCBz5+5dY2qXWejhUcP4yM=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=rjPmCxsbqVNOZ3otec8u7yUXIPwukZtrEyPkfA5Yo7mOeS9yOjCSmGo6tgW2hBJhC
         x64DJjgwXjYtLb4C1cHQFtgTNsGqOM17fnkI6bQa8OxnXjhefZLx1QnFnJg0r+2wy6
         pJphmAaNs/aKCtDNEGe2DItlBJDbiGvV4OG9pkbetCYzxRGEC7epHgJv/J4ohFyNA5
         AWvPOLQKM+3ZEHW30NTiCiaVOcXr0WJSSAqCWB9mn24Yl67a2fzQDSH65vIzo9MkH1
         xH6iMcjKPGZ2ayiv3eqiDt1nJTkJwJGn1+TY3FOpV6phDE63QPvUlmaB5k/KWXSh4f
         FgvDoFHtGxl9w==
Received: by mail-wm1-f70.google.com with SMTP id r15-20020a05600c35cf00b003d9a14517b2so172509wmq.2
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 16:17:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B79xjy+K/93G68irDU5evQCBz5+5dY2qXWejhUcP4yM=;
        b=llSaQh/RNKl3T3mSeQmuPKTDpln7AiI3ZTiDoe7GmIgfr6WB59EW0i3IehP2nbtKrQ
         MYC00zZR3pZQzd44vcPuo85vzacTQsRWOpHfxFXywOspkrD5Xt4M9qn3nyrHTWQsTQhG
         G1uFTFWgs/0S+bEDlGVoTxYLo1Q/M3OtytFXkUGFbzF7F4/NRiMnCQe5E8PqT/yzo7O/
         dxCBewYwPoyKe+21+MkSBTOKF5qtcHT5IdgmoGKS3Ts3TaPlc8LkvwRZehAxIctTmziy
         VZBIIL7GG6NL3SPf1PH2w3FQlqAnS3zF8leSd2KG48SYPjetkzmrdWE1agBTyyzDt/tW
         +mLg==
X-Gm-Message-State: AO0yUKVk+vRi0FfbYsfxlQlheVliuyuDaCnYLrHe5YrqaDx2MzNMQEG/
        W+woCl2HF2Goi4azJRUhNpV31xkw3woqhuyqm4/bZqz0TjINawLkarmvGJI454F9YhTp+ljVVE/
        lNhhr93qR7HDlKn7yExvrLz56dAvo7QFR+g==
X-Received: by 2002:a05:600c:3c9b:b0:3dc:46e8:982 with SMTP id bg27-20020a05600c3c9b00b003dc46e80982mr117935wmb.19.1675210667536;
        Tue, 31 Jan 2023 16:17:47 -0800 (PST)
X-Google-Smtp-Source: AK7set8m3rFOUfn/2s9rRm1ZfRJ7ufmOaC/r+T7Sr9ucuwaqVN8rvqtqmrDhvLO6w1KBkptDz3dggA==
X-Received: by 2002:a05:600c:3c9b:b0:3dc:46e8:982 with SMTP id bg27-20020a05600c3c9b00b003dc46e80982mr117926wmb.19.1675210667336;
        Tue, 31 Jan 2023 16:17:47 -0800 (PST)
Received: from qwirkle.internal ([81.2.157.149])
        by smtp.gmail.com with ESMTPSA id n6-20020a7bcbc6000000b003d237d60318sm108925wmi.2.2023.01.31.16.17.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 16:17:46 -0800 (PST)
From:   Andrei Gherzan <andrei.gherzan@canonical.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc:     Andrei Gherzan <andrei.gherzan@canonical.com>,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net v4 1/4] selftests: net: udpgso_bench_rx: Fix 'used uninitialized' compiler warning
Date:   Wed,  1 Feb 2023 00:16:10 +0000
Message-Id: <20230201001612.515730-1-andrei.gherzan@canonical.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change fixes the following compiler warning:

/usr/include/x86_64-linux-gnu/bits/error.h:40:5: warning: ‘gso_size’ may
be used uninitialized [-Wmaybe-uninitialized]
   40 |     __error_noreturn (__status, __errnum, __format,
   __va_arg_pack ());
         |
	 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	 udpgso_bench_rx.c: In function ‘main’:
	 udpgso_bench_rx.c:253:23: note: ‘gso_size’ was declared here
	   253 |         int ret, len, gso_size, budget = 256;

Fixes: 3327a9c46352 ("selftests: add functionals test for UDP GRO")
Signed-off-by: Andrei Gherzan <andrei.gherzan@canonical.com>
---
 tools/testing/selftests/net/udpgso_bench_rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/udpgso_bench_rx.c b/tools/testing/selftests/net/udpgso_bench_rx.c
index 6a193425c367..d0895bd1933f 100644
--- a/tools/testing/selftests/net/udpgso_bench_rx.c
+++ b/tools/testing/selftests/net/udpgso_bench_rx.c
@@ -250,7 +250,7 @@ static int recv_msg(int fd, char *buf, int len, int *gso_size)
 static void do_flush_udp(int fd)
 {
 	static char rbuf[ETH_MAX_MTU];
-	int ret, len, gso_size, budget = 256;
+	int ret, len, gso_size = 0, budget = 256;
 
 	len = cfg_read_all ? sizeof(rbuf) : 0;
 	while (budget--) {
-- 
2.34.1

