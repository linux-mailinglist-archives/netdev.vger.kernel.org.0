Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26C525EF774
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 16:26:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235662AbiI2OZl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 10:25:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235037AbiI2OZT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 10:25:19 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2040A371B1
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 07:25:17 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id j8so976643qvt.13
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 07:25:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=QpSUqvuYKWyxulQJNLmEPQOpbUSNuFMaRfMdKlbnkag=;
        b=l/GWf25EWMBKnnuA43FYzGfnccDl4ssXZNkQSWhhK+6LeFwrSAfPhTbOzMVWqAGHa2
         eC6u+opJf2WW/go7aAYipVtkZomE2KKspc0K8J0kpO4bjmqXkKClVRCMNWdafv4I3Q4y
         UG2b1Sss+JDF+a4yzg/x0ETjgEkT/lT8gQhW8Jikt52hH2lM2NhCwQGYAw77Cb95g2PD
         5+pK8HTzA3tz8q2VO0T8tG49igG1iOQkpBpytGJ1kFcHkbwwWM0ZtlQ1PNbisaLgUKXB
         49gGuVFJNTZsrPYjn3rRruLAAVOEztqm73EZDQjwoURyB5Jjyvbc9f1rI34cyLmjdvWL
         dPOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=QpSUqvuYKWyxulQJNLmEPQOpbUSNuFMaRfMdKlbnkag=;
        b=UbJYYR2pFTMaI8wzntUhKwplVCC2fffEkpQP3rVLXjOUY1XXCjDzdwi8bCD+WbMI7H
         GlW6fUK+xaZYbgbO4ehJVakXQboBdciW5sKn8jKp9oaqIZnsICDakkWMLWiIFRH9Qt9b
         QOUSJDzDTAIjTfGauAfOdcGZWbOpQeVwPt7qU178ixPGBT4biNSkh8PHXmrycRAh0yUN
         LFKUGOG/fUHRn6hnoRBWVz5pmHmx28yaAw3n9mP1YxXojEDwyON6660HEvl+hVrFFD7R
         cXQ+xspSiaMnJ9QuApnhaOztdTWIVJcEANgZKXB0ZdlBhlfpTYaeJ5fe4vh+kxzBR1yR
         0p3w==
X-Gm-Message-State: ACrzQf1SZJ45Y7G9Wye4pSbGMefVE9NziTnL09nC5OpFzAZAMbHaJHL+
        T0odiOt5CyYe2pbL3O8s7eT+uN/YOaU=
X-Google-Smtp-Source: AMsMyM4NiAQ577AwqK8JOIVcT9U1EoOf82EYtLzFhNjez0JyYmtX2flAo/bYAOYeSUeTWsgIRbfREw==
X-Received: by 2002:a05:6214:1cce:b0:4ad:72d5:d2e1 with SMTP id g14-20020a0562141cce00b004ad72d5d2e1mr2731333qvd.43.1664461516196;
        Thu, 29 Sep 2022 07:25:16 -0700 (PDT)
Received: from mubashirq.c.googlers.com.com (74.206.145.34.bc.googleusercontent.com. [34.145.206.74])
        by smtp.gmail.com with ESMTPSA id z21-20020ac87f95000000b00342f8984348sm5889952qtj.87.2022.09.29.07.25.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 07:25:15 -0700 (PDT)
From:   Mubashir Adnan Qureshi <mubashirmaq@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org,
        Mubashir Adnan Qureshi <mubashirq@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net-next 5/5] tcp: add rcv_wnd and plb_rehash to TCP_INFO
Date:   Thu, 29 Sep 2022 14:24:47 +0000
Message-Id: <20220929142447.3821638-6-mubashirmaq@gmail.com>
X-Mailer: git-send-email 2.37.3.998.g577e59143f-goog
In-Reply-To: <20220929142447.3821638-1-mubashirmaq@gmail.com>
References: <20220929142447.3821638-1-mubashirmaq@gmail.com>
MIME-Version: 1.0
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

From: Mubashir Adnan Qureshi <mubashirq@google.com>

rcv_wnd can be useful to diagnose TCP performance where receiver window
becomes the bottleneck. rehash reports the PLB and timeout triggered
rehash attempts by the TCP connection.

Signed-off-by: Mubashir Adnan Qureshi <mubashirq@google.com>
Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
---
 include/uapi/linux/tcp.h | 5 +++++
 net/ipv4/tcp.c           | 2 ++
 2 files changed, 7 insertions(+)

diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index c9abe86eda5f..879eeb0a084b 100644
--- a/include/uapi/linux/tcp.h
+++ b/include/uapi/linux/tcp.h
@@ -284,6 +284,11 @@ struct tcp_info {
 	__u32	tcpi_snd_wnd;	     /* peer's advertised receive window after
 				      * scaling (bytes)
 				      */
+	__u32	tcpi_rcv_wnd;	     /* local advertised receive window after
+				      * scaling (bytes)
+				      */
+
+	__u32   tcpi_rehash;         /* PLB or timeout triggered rehash attempts */
 };
 
 /* netlink attributes types for SCM_TIMESTAMPING_OPT_STATS */
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index f5902a965693..aa100f52f330 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3937,6 +3937,8 @@ void tcp_get_info(struct sock *sk, struct tcp_info *info)
 	info->tcpi_reord_seen = tp->reord_seen;
 	info->tcpi_rcv_ooopack = tp->rcv_ooopack;
 	info->tcpi_snd_wnd = tp->snd_wnd;
+	info->tcpi_rcv_wnd = tp->rcv_wnd;
+	info->tcpi_rehash = tp->plb_rehash + tp->timeout_rehash;
 	info->tcpi_fastopen_client_fail = tp->fastopen_client_fail;
 	unlock_sock_fast(sk, slow);
 }
-- 
2.37.3.998.g577e59143f-goog

