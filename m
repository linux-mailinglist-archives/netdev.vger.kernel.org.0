Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D8676BED6B
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 16:56:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbjCQP4E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 11:56:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231393AbjCQPz5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 11:55:57 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 616D6C97FA
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 08:55:48 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-540e3b152a3so50498257b3.2
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 08:55:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679068547;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Dbs/I0DOtCv+iewqkJLf7Kg3v9iYNZTxz8Pm5gPeDaM=;
        b=mqnAspmHPBp57SmEaKrYcOC8jKDqIPb6qezb/G0HzZAjpEwhe8RnHjxjFZntmHdcH3
         mZm7QYTfbomP9gV6FzLoJxp1ahJunZrXLaKLjIU2bqEZcvq8yhTzBNS9lmRPv7k3YJa+
         cXkKCVMXuCVevFYMxIcFw+cRBNiQLWb5qBHYb1wcT+7Dg/QsTHh47vbgqRky80aphwkM
         F9DSo8dzpCLx31vjKBz6PTv8QH+aj2c8tsgqhv0uMd6HCu4JzFM2doAyK7CvuxDITkLR
         ZHZE9CUKZGzSzrooQirhNHyUHRjHl/Tz3AoV+qT0CnqqhBEqZ0U74WwCfvDycC59Q/Ci
         GULw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679068547;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Dbs/I0DOtCv+iewqkJLf7Kg3v9iYNZTxz8Pm5gPeDaM=;
        b=aFiHnriZHYoa8DLo9VcMdOTef3DJfPNQTzOEIE2/6f5n+XWysF11i7GEGiY0FrwfTH
         jmkNnp33CyewNw8aTHvvxUuPaqexQsJoCaGb20DeYztme5nJ57blWqSwfQkWSvYcfWfU
         Gs1YOQc4EhbdjjS3cra3zY+sAtqZRxwOWDMRMfgBcjXdQRx9mT13Gn20zwQ9KjaAuR57
         2diR+R2xCs3VNeOME7UsPOm3qcdnmWmpZ46XJ2EtG2ozlJXr8xa8jkkjJ32haJehJStn
         H4ZricuquHRa/AVFNQ79xqrtXhlzPR2rbay+Bw08mCeDOVdfjnT6O8LxaGqTo94kqDfe
         qglQ==
X-Gm-Message-State: AO0yUKXp7XbXqJ/MMhJipwPmYpLItP0wUqF4TJaFf9d3EsGIw+8YHZtX
        ClFIoXt7rpIv7D6ScvS3Q5TxOmJlElucAg==
X-Google-Smtp-Source: AK7set/A0n1EVwj8Rt7Uz1R6tQfh8t+SLxYuimykbpr0nQB2RkqMWDG+l+GaeQ2/PhaVTwUm+1Ji7aoMtgOQlg==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6902:120b:b0:b51:2cba:b971 with SMTP
 id s11-20020a056902120b00b00b512cbab971mr26743ybu.10.1679068547667; Fri, 17
 Mar 2023 08:55:47 -0700 (PDT)
Date:   Fri, 17 Mar 2023 15:55:33 +0000
In-Reply-To: <20230317155539.2552954-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230317155539.2552954-1-edumazet@google.com>
X-Mailer: git-send-email 2.40.0.rc2.332.ga46443480c-goog
Message-ID: <20230317155539.2552954-5-edumazet@google.com>
Subject: [PATCH net-next 04/10] ipv6: raw: preserve const qualifier in raw6_sk()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Simon Horman <simon.horman@corigine.com>,
        Willem de Bruijn <willemb@google.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        eric.dumazet@gmail.com, Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can change raw6_sk() to propagate its argument const qualifier,
thanks to container_of_const().

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/ipv6.h | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/include/linux/ipv6.h b/include/linux/ipv6.h
index 37dfdcfcdd542fe0efc9a1df967be3da931635d4..839247a4f48ea76b5d6daa9a54a7b87627635066 100644
--- a/include/linux/ipv6.h
+++ b/include/linux/ipv6.h
@@ -336,10 +336,7 @@ static inline struct ipv6_pinfo *inet6_sk(const struct sock *__sk)
 	return sk_fullsock(__sk) ? inet_sk(__sk)->pinet6 : NULL;
 }
 
-static inline struct raw6_sock *raw6_sk(const struct sock *sk)
-{
-	return (struct raw6_sock *)sk;
-}
+#define raw6_sk(ptr) container_of_const(ptr, struct raw6_sock, inet.sk)
 
 #define ipv6_only_sock(sk)	(sk->sk_ipv6only)
 #define ipv6_sk_rxinfo(sk)	((sk)->sk_family == PF_INET6 && \
-- 
2.40.0.rc2.332.ga46443480c-goog

