Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90E49682D44
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 14:05:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231429AbjAaNFx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 08:05:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230360AbjAaNFv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 08:05:51 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB366113DB
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 05:05:37 -0800 (PST)
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 9DF0641AC7
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 13:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1675170335;
        bh=k4C10jaPX9SATgjkcJPgwiqnKoKJu0rj0Lx0+VxMFbA=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=OTcC8sDKIc1YQANEGakG5cBF5JY4WsfSv9i8IUGxHIy0lfVk0SlyeZeZpzAVGPs0X
         HeHJ/5caZyacGyHKJskvVonsGh+1a5K3VUFVrMUpgrGVtcuc55QO7o8G7NoqnI5QO+
         Ou0eTl9fc00OZmZRJp+M3Pe47P0pAqS0SKBYnFnpeR4vDYlkY5PLN1OEH8wlYICK0n
         9YkeAjQ7nSIwQ3e21yhk/xmM4fJVOtdiB+2rAlBdksYRXd6c1XcneNEt1+Lxb5KvAP
         XBIzY8ws18NFS76wSE2/6+yeTUZuRJ9ldPlPpfr/ZQkuovdWKtWNigcD0Il/zSDMza
         TnKrgnDQV0s1g==
Received: by mail-wm1-f69.google.com with SMTP id h18-20020a05600c351200b003dc25fc1849so8628805wmq.6
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 05:05:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k4C10jaPX9SATgjkcJPgwiqnKoKJu0rj0Lx0+VxMFbA=;
        b=hoDmGnkG0xjTE2CmNNE/k9/oC2vBUWtql+r2Oc0AJlSCtU+3OiX8QguCckUxbXPRsF
         bPV9BcLfai378uc0BKwfBHxpHP3FDElcrRtGPSnmtfGKsfhiwvHDnOA5IWvPw9ZLrHiR
         oevc3bknD8N5HDviPm6ZlaU165GabyXYD52hZntxtTv4nceIh0I9mi5akE/LFRSJO8z/
         Ja33n6SUcJStfs74TibybZ9U62j8aBsQTbj5a3RlsWUiuu9Wsf7eiFtF7S5W0qhOaIj/
         u7ZaE/YUBJpv1Qqr186lGu4VHmAcfSWbtOdsK6eRMhgugq5FjcWE0qpHlVM3bRdGBnVk
         S+kQ==
X-Gm-Message-State: AO0yUKW4Y2klVv3espBvGYkrQBjxCXwWVBiIpELnTS3o/PKifBRkik+7
        RQ7iEeqjiwVopiQQG/4b3m232T1ASc5rAZgntiptGGo0pL9HK7TxftlqSci6jbhRN9JculwQMnm
        OjCUatC+IOfHK63GG7wGg4QulijKN7z7qqg==
X-Received: by 2002:adf:c68a:0:b0:2bf:f2f2:7d64 with SMTP id j10-20020adfc68a000000b002bff2f27d64mr5125342wrg.33.1675170335335;
        Tue, 31 Jan 2023 05:05:35 -0800 (PST)
X-Google-Smtp-Source: AK7set/JKOWFouqXY4USuDFfFzUbfIHyMBzspi6+XkMA9ckLWmUhedeQ3yyjl+8b9xB/uwlPFXvVZA==
X-Received: by 2002:adf:c68a:0:b0:2bf:f2f2:7d64 with SMTP id j10-20020adfc68a000000b002bff2f27d64mr5125324wrg.33.1675170335068;
        Tue, 31 Jan 2023 05:05:35 -0800 (PST)
Received: from localhost.localdomain ([2001:67c:1560:8007::aac:c4dd])
        by smtp.gmail.com with ESMTPSA id f6-20020a5d50c6000000b002bfc24e1c55sm14741436wrt.78.2023.01.31.05.05.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 05:05:34 -0800 (PST)
From:   Andrei Gherzan <andrei.gherzan@canonical.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc:     Andrei Gherzan <andrei.gherzan@canonical.com>,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/4] selftests: net: udpgso_bench_rx: Fix 'used uninitialized' compiler warning
Date:   Tue, 31 Jan 2023 13:04:09 +0000
Message-Id: <20230131130412.432549-1-andrei.gherzan@canonical.com>
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

