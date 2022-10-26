Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 127E860E299
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 15:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233926AbiJZNv6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 09:51:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233743AbiJZNvi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 09:51:38 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 586F04BD2E
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 06:51:37 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id n18so6119764qvt.11
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 06:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WEuotFoVaOLAiftQgcaOJhbegwvFQspN0YI1OO+4yK0=;
        b=p84ee7jQ1JczfzHjXTdsk4pauQdbLNdNlFfmJyizFSrzqu5kDHsEpFrYnmmVwPsBnC
         J6My4pF3eueW2/JrRTb2avSfzutmq4pxxiLBFVX20biFKJgQTIKb2ycwVtoPg27xlwyk
         ax0E6XX1BFa7XitLkSIPkiCJLwhsplQyx8vrw3FlHK7je0MUG/eO2fgkJN3Y9H4FOy/X
         IkIYkNhjDDwhYdvUvIuslEDSZvFPYvscu+G65Fb5ahSC+nBzhgU7HJua6ltXaV7EWaDz
         RzkLMmw2v4TFKuzJuP1H/l9JSu9rChLDOZynNk35SaIOis32uwDHVd3+48ZRm7vetpsg
         d9qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WEuotFoVaOLAiftQgcaOJhbegwvFQspN0YI1OO+4yK0=;
        b=AOFhGfEGXPudtlCYCearuz08prZMJBHsHgPKr8q7+E2JLtsyzKoq9VWaZgxmj2vAwY
         ILiaBqfsJbH9L4akbC+2e3PPtGeJDF32CdHvuteF8+aAz1us8wYO0CqfopZKv8Ab/iRf
         DXMCSFBIh7yyAcV/uwmTDp0TA9snSPPtT8czjiWW6S8LUbXNEd48+ZWfV6o7LjvgQ1Ix
         KwSpJG3KJbgitG9CvVHkglY1LZF3FBMssIGL1v1RYsHKgSJbbN8vaucmOk/JhhvoQbwb
         cNGw4qdutZOGnQxlUdngNROJSjva/5o8/WrwYBGLSgj5VxHZvd9IMjpnueLyNoknfzGu
         BGLg==
X-Gm-Message-State: ACrzQf0H2y2QkaJR9mjeWP9FPhSrPjbbyz9U1IkJVmc07mggJmHvLAFL
        NfkXcPLnBXd1JkNf9UYxDndz1nS3uJIpcw==
X-Google-Smtp-Source: AMsMyM4TQNtjq1mbHQnBnPdPu1KSZiZsWr7NWEqYaWEZ4rIZtr3hmU4wB58b6wUCA0ukEL344mgXKg==
X-Received: by 2002:a05:6214:2467:b0:4ba:f07c:d9f7 with SMTP id im7-20020a056214246700b004baf07cd9f7mr23300290qvb.24.1666792296294;
        Wed, 26 Oct 2022 06:51:36 -0700 (PDT)
Received: from mubashirq.c.googlers.com.com (74.206.145.34.bc.googleusercontent.com. [34.145.206.74])
        by smtp.gmail.com with ESMTPSA id b24-20020ac84f18000000b00397101ac0f2sm3211836qte.3.2022.10.26.06.51.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 06:51:35 -0700 (PDT)
From:   Mubashir Adnan Qureshi <mubashirmaq@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org,
        Mubashir Adnan Qureshi <mubashirq@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net-next 5/5] tcp: add rcv_wnd and plb_rehash to TCP_INFO
Date:   Wed, 26 Oct 2022 13:51:15 +0000
Message-Id: <20221026135115.3539398-6-mubashirmaq@gmail.com>
X-Mailer: git-send-email 2.38.0.135.g90850a2211-goog
In-Reply-To: <20221026135115.3539398-1-mubashirmaq@gmail.com>
References: <20221026135115.3539398-1-mubashirmaq@gmail.com>
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
index 1da7c53b6cb5..de8f0cd7cb32 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3940,6 +3940,8 @@ void tcp_get_info(struct sock *sk, struct tcp_info *info)
 	info->tcpi_reord_seen = tp->reord_seen;
 	info->tcpi_rcv_ooopack = tp->rcv_ooopack;
 	info->tcpi_snd_wnd = tp->snd_wnd;
+	info->tcpi_rcv_wnd = tp->rcv_wnd;
+	info->tcpi_rehash = tp->plb_rehash + tp->timeout_rehash;
 	info->tcpi_fastopen_client_fail = tp->fastopen_client_fail;
 	unlock_sock_fast(sk, slow);
 }
-- 
2.38.0.135.g90850a2211-goog

