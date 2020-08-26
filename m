Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5AE8253057
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 15:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730539AbgHZNub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 09:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730534AbgHZNuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 09:50:21 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6C2FC061574
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 06:50:20 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id k11so2904863ybp.1
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 06:50:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=lCJ9B3SXwDwW6scb5guoks5aiOHsE7oNfHq5QpIf53o=;
        b=mo7kawrBY/xEPSQGDtn0GowkoVBq/XVviUv2qYD3ocIHisZBZTTquaG0PnlN/d7DNx
         NXaohOJQ3FJwje1t7jwJjUWzIKHwS/OCorqxkibf2Oo2TepFKCJ9w2GSfXKP+LB0iQ9P
         zjJfKsG6hgNEdz++MppLVM/iLR4woARpzLgn2NTBgFQDPMOfEGpVNfr5jtuYn7QaVaMv
         YaRWSG+tBV9Dz0fHb4oN+4ICCzo+xHL48R40P6YaStyNlVNq782ddz+qEs26o8foHrcp
         oUOsZlXZv045nPmftOLfiLeV+F5si2gV2Tw9vJi4bN4kYGOiGGLdzRKZh1IS8wAxfB6c
         MF5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=lCJ9B3SXwDwW6scb5guoks5aiOHsE7oNfHq5QpIf53o=;
        b=tfZoQ9pGXlMZynRv9krWx05MccOEFeshRGvDOYlcAT8xenL0/M8xYjuVGnLEgRUq/4
         zASimJLKZpApoWsR24X7tofioLnnaIac9XLc48DS74k0ZrJRBhZ4+xKd5vaWVHy+wDx1
         85A1X8R0oQ5vbachiwo3Pu+bsdMoS5eyXXxUBeGW/uU35fI3cSOaGTbAUUxkWY4g9Krk
         pilStGPo4riYAUN3iyHqhFSkzv1g2UT4kz00TmcCXu9yVVI3VeXidAPA44FrP2R9d/HL
         py7ebsinllUpPhOB3RHPAdF0Be5pH+7qGf7a5DXa/hepscf3eDYT6zanshWXlTo067LE
         2Oag==
X-Gm-Message-State: AOAM530o+u6uwcIHdgcikkU3oBl5g1PyhNCiF26WDUrH0DQIHqDVc55U
        n2W1JnFdCBjypFXULXEzub7hfPs3OCnyew==
X-Google-Smtp-Source: ABdhPJxNNkp/KeflwmWraYbAv4T2sQEMlsZr5DHoeWJK2W2pHaqYOTDM/MWybkP+tDyXyxFDjGH3vN5qYHZXKg==
X-Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:7220:84ff:fe09:1424])
 (user=edumazet job=sendgmr) by 2002:a25:3758:: with SMTP id
 e85mr20463600yba.254.1598449820084; Wed, 26 Aug 2020 06:50:20 -0700 (PDT)
Date:   Wed, 26 Aug 2020 06:50:16 -0700
Message-Id: <20200826135016.802137-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.297.g1956fa8f8d-goog
Subject: [PATCH net-next] inet: remove inet_sk_copy_descendant()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is no longer used, SCTP now uses a private helper.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/ipv6.h    | 11 -----------
 include/net/inet_sock.h |  7 -------
 2 files changed, 18 deletions(-)

diff --git a/include/linux/ipv6.h b/include/linux/ipv6.h
index a44789d027cc8cdb4a210ad4e17463d941f2f9c2..bac8f4fffbd6b736bf36b6b8188e09243fdc4a1f 100644
--- a/include/linux/ipv6.h
+++ b/include/linux/ipv6.h
@@ -345,17 +345,6 @@ static inline struct raw6_sock *raw6_sk(const struct sock *sk)
 	return (struct raw6_sock *)sk;
 }
 
-static inline void inet_sk_copy_descendant(struct sock *sk_to,
-					   const struct sock *sk_from)
-{
-	int ancestor_size = sizeof(struct inet_sock);
-
-	if (sk_from->sk_family == PF_INET6)
-		ancestor_size += sizeof(struct ipv6_pinfo);
-
-	__inet_sk_copy_descendant(sk_to, sk_from, ancestor_size);
-}
-
 #define __ipv6_only_sock(sk)	(sk->sk_ipv6only)
 #define ipv6_only_sock(sk)	(__ipv6_only_sock(sk))
 #define ipv6_sk_rxinfo(sk)	((sk)->sk_family == PF_INET6 && \
diff --git a/include/net/inet_sock.h b/include/net/inet_sock.h
index a3702d1d48754fbc23b9789f32e1a72d45f5ecf1..89163ef8cf4be2aaf99d09806749911a121a56e0 100644
--- a/include/net/inet_sock.h
+++ b/include/net/inet_sock.h
@@ -296,13 +296,6 @@ static inline void __inet_sk_copy_descendant(struct sock *sk_to,
 	memcpy(inet_sk(sk_to) + 1, inet_sk(sk_from) + 1,
 	       sk_from->sk_prot->obj_size - ancestor_size);
 }
-#if !(IS_ENABLED(CONFIG_IPV6))
-static inline void inet_sk_copy_descendant(struct sock *sk_to,
-					   const struct sock *sk_from)
-{
-	__inet_sk_copy_descendant(sk_to, sk_from, sizeof(struct inet_sock));
-}
-#endif
 
 int inet_sk_rebuild_header(struct sock *sk);
 
-- 
2.28.0.297.g1956fa8f8d-goog

