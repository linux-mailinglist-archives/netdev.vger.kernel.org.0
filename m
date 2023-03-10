Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8376B5426
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 23:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231778AbjCJWTW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 17:19:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231340AbjCJWTH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 17:19:07 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33489C80AB
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 14:19:05 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id u9so26461829edd.2
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 14:19:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678486743;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DB0ur3H4BOzuRgNkBl8y1+B2Cc6jLt2y7U0cUu8vBFg=;
        b=fzKNqwzC84P3chlNck8CxPeU0mUuwaynCespdqs7K96G2ZMt4Yp+cpA3oJJU6D63y9
         aL8aiRfiljedYGBkwOZXV5G164M5uq6iHYEABDN8l6v9bbHvt67tfZethRlj5xsazFpc
         KwWC0eH/5IBbH7BkqUCQp2t2+mGGb5jHjjJYXcKrkgLmGPWbUoXY3UlTI80Vevn8RhMK
         epR1MGMj1K0EpYQWTTntr1Yg9m4TSZHxlbX3jWZacWVd1REl9kdo0VHxf5IKjQ58USo/
         z87T6ZCt4CNX/K/HlZPkfMaCGjKn4D8brTAMruAVVICYsfLkqYCTdMC8AUHyigy0yv7L
         UkSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678486743;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DB0ur3H4BOzuRgNkBl8y1+B2Cc6jLt2y7U0cUu8vBFg=;
        b=tTpYgTGLctR482QOGYFvYX5Bz/dKZxnzXzqOcEXENCwmpxumXgo+2utDI1JPSQp709
         i8zMNbc9M1LIpNJlmmEYYpNyv12Ajs1o5FRSPh+ViQqn8NAwk1ExB6jPNBR+MwbmGPTJ
         mDDHovOfAVl755PCdnJa5buH1MdjXRxI6FeEGWiTnVm2wAfdQ9T3ANFg7kqtFiZ8gDDg
         pEcDLDyeea6iMsuML1MKkej45kI/5LrF4XoNoWthe18GxtdmMO9Ox1oc4LRqmVjcPTqE
         fqdtKOpD7Dc9WlPrk0P2ENcE8BySU3DRDbLe4iRsJbZhZ60VBoNr4fNuoKcbgu0vOxGs
         sF2A==
X-Gm-Message-State: AO0yUKWPWR+pRAFjFNMR7qkjzWDUivW0Y8zDCGEoGVoMSJX/fqiJTaOz
        S8UGv4DPpQHWvrjP1zXiSkF5VIFumra/Cw==
X-Google-Smtp-Source: AK7set/6oQ5ISXmCtwWOCTeeiirOk3Dgq3Kgck1Vj5WlRKr3n+cgqAZvvaMYDzQ5pcjjphxi8YhAwQ==
X-Received: by 2002:a17:906:5f95:b0:91f:c7e:22ba with SMTP id a21-20020a1709065f9500b0091f0c7e22bamr869328eju.27.1678486742617;
        Fri, 10 Mar 2023 14:19:02 -0800 (PST)
Received: from localhost.localdomain ([2001:b07:5d37:537d:5e25:9ef5:7977:d60c])
        by smtp.gmail.com with ESMTPSA id kw5-20020a170907770500b008e204a57e70sm340710ejc.214.2023.03.10.14.19.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 14:19:00 -0800 (PST)
From:   Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
To:     netdev@vger.kernel.org
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        davem@davemloft.net, kuniyu@amazon.com,
        Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
Subject: [PATCH v2] net: socket: suppress unused warning
Date:   Fri, 10 Mar 2023 23:18:51 +0100
Message-Id: <20230310221851.304657-1-vincenzopalazzodev@gmail.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

suppress unused warnings and fix the error that there is
with the W=1 enabled.

Warning generated

net/socket.c: In function ‘__sys_getsockopt’:
net/socket.c:2300:13: error: variable ‘max_optlen’ set but not used [-Werror=unused-but-set-variable]
 2300 |         int max_optlen;

Signed-off-by: Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
---
 net/socket.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/socket.c b/net/socket.c
index 6bae8ce7059e..ad081c9b429f 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2295,9 +2295,9 @@ INDIRECT_CALLABLE_DECLARE(bool tcp_bpf_bypass_getsockopt(int level,
 int __sys_getsockopt(int fd, int level, int optname, char __user *optval,
 		int __user *optlen)
 {
+	int max_optlen __maybe_unused;
 	int err, fput_needed;
 	struct socket *sock;
-	int max_optlen;
 
 	sock = sockfd_lookup_light(fd, &err, &fput_needed);
 	if (!sock)
-- 
2.39.2

