Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CCE3683803
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 21:55:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231766AbjAaUzV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 15:55:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231764AbjAaUzS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 15:55:18 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18AA8166FB
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 12:55:06 -0800 (PST)
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 57E4F442FD
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 20:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1675198505;
        bh=B79xjy+K/93G68irDU5evQCBz5+5dY2qXWejhUcP4yM=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=i/8NOjjfW+iKS22JuMVldan6hBW+Qyw2fyIzKDCFbwovicoDR/vWbuzTEF8yGREkS
         lys5PB0lNqKr2C/gRzTz+ACaU5X48gp10kW9zq/irTwZA6LW0Lwre4Ye4W6BFC27up
         M5VW7C9V1khthekvW9KOQZXDnI/4BAZF1w6j8rJH27C4E4Cea2JLPLDdjTBNyOWj5c
         8F4wXJ2zlnAWAr/rbioiYDi1kVSQCakuLmcEBAUf8l+mFvJYdRmV8mFadHSOZGU5gG
         vRgVuf6puR3sTiXCDNVsuMug5B9v8V/f3wLnEmN2y+XCw8/Ipc+aVX3hsDlSvyN+32
         S5HUq1VFSQIgg==
Received: by mail-wm1-f69.google.com with SMTP id n7-20020a05600c3b8700b003dc55dcb298so4024367wms.8
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 12:55:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B79xjy+K/93G68irDU5evQCBz5+5dY2qXWejhUcP4yM=;
        b=J5k2g2oQXvqcnnsHXi4tTj+Ag3oquzsp8dOlDKC+wV81xHOLPx4EewbhzvL7Oz5uCq
         8s1JiB7PwfpxB5omhYhoTOaKnBzdIh8ZEvdeqUfToRHiUfy7QOC92jJbU9/z5sHyQpEN
         U1XsDZh2Ny7iooX5R4DfgMqE4qJaPGIl5UOhWRF91e8l1ADxihuooaLWo5I8Xs31HquN
         YI6+GelWfCdKV7dbZwq6R1vwQ4q71Nasz9TQHvzK5o+zWynVzbto0x11WXsGJs7o/4/b
         uxm6lQaJI5EGdWAdpAQfayCv7+Nc0yh/Vj2yrsphY4lJBw6rbkosdrhOeFKHJIyRW2ke
         gjPA==
X-Gm-Message-State: AO0yUKUDnlNb+yaeZRmNNO3NpUVRRcu4nuJ84sg9yUL0EsvoTVHIyGT+
        TN7im5KHHWFUmIxtTrCTjMoIqNXYuAErVu4z8qEu8eAWBifkvxKLNl8Xv5xbd75UoAOT2RnYAQO
        yn14GH7yi+/ds1vX4xbeNcO9eveyTVX1eqQ==
X-Received: by 2002:a05:600c:4f83:b0:3dc:5506:7e2c with SMTP id n3-20020a05600c4f8300b003dc55067e2cmr10463850wmq.19.1675198504850;
        Tue, 31 Jan 2023 12:55:04 -0800 (PST)
X-Google-Smtp-Source: AK7set82sJixkvkLMLHoa3nvqG8TLbzfqqWI1GTKGu1ymE03gyMXrfvh4vUm95VYrte1QuVWUQpV1A==
X-Received: by 2002:a05:600c:4f83:b0:3dc:5506:7e2c with SMTP id n3-20020a05600c4f8300b003dc55067e2cmr10463842wmq.19.1675198504626;
        Tue, 31 Jan 2023 12:55:04 -0800 (PST)
Received: from qwirkle.internal ([81.2.157.149])
        by smtp.gmail.com with ESMTPSA id bd16-20020a05600c1f1000b003d1f3e9df3csm21316535wmb.7.2023.01.31.12.55.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 12:55:04 -0800 (PST)
From:   Andrei Gherzan <andrei.gherzan@canonical.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc:     Andrei Gherzan <andrei.gherzan@canonical.com>,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 1/4] selftests: net: udpgso_bench_rx: Fix 'used uninitialized' compiler warning
Date:   Tue, 31 Jan 2023 20:53:16 +0000
Message-Id: <20230131205318.475414-1-andrei.gherzan@canonical.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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

