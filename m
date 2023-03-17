Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61B636BED71
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 16:56:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbjCQP4J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 11:56:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbjCQPz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 11:55:59 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10093C9C8C
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 08:55:55 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id e129-20020a251e87000000b00b56598237f5so5656866ybe.16
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 08:55:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679068554;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QUMjTTGpzBj+/EOJevtTMimZE+jsZWH0mBOWQgcIhgo=;
        b=Xujbwsw3x4OoRepnMegRlckHrwC/lXhnrpjU+yw/4mttzeyAoQYg4lMuuTGIC3394P
         SgfBBP21hoUw53mWCf8efu9HSkX1wtUmWlh1zIf0SarPE/TU9LGguX1LGQWwAdqNonsN
         kiq2HkwqfL03D1gWmLv0Jb7lDngMura6vQjbiL3kbU5kCxJKJAU4xfca5UI18XkSUMZB
         B5w6pkRYoURTIqvzJh2JaTHvTUD0T3y/78qba3d7cWsXgGsZQp0jimNgEquLQcOBnHs6
         PKpKj6k8yzMMzss2FG7H2hUmpd4lJ37CwDuf5JK5Ciov3MsI48V9aQTtVfZaZSFar5fi
         EOCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679068554;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QUMjTTGpzBj+/EOJevtTMimZE+jsZWH0mBOWQgcIhgo=;
        b=LKE8JgCEwpVfVgRxWRr8y+gvDVTyU5nyGA78C1fsfFDLDiHKhcMyvkeNBnJTWADmmO
         /6WX/Po/6tcFNYKayLywvx7km6Nip20XKl21Qe+rWo3oXDdxAs/8bKbqsN0ThMSMBvg5
         Q4yPsGibOT+8Nu12EerGIN9spJq0TQocPgSsrs4hNScXrkqgiaZ9P4xLVOgiO5cokF4s
         RsUKXnJRbxC664cCM3+8H5kBJYq8uV7zgz7Q66GJ+4ti8qeAEwf3Hljuwf6EW1/28GJp
         owhOGUlw3anowCQ3VhzXo7IpqnyK9gJr76CBTvvGO/HMkZrklSQmLkf0Gws7EvjITbeo
         3WIg==
X-Gm-Message-State: AO0yUKVo7/LDD0rh0X0EPdsDZioGJO6fZIF314mxupcOU1bF6pQM+D/6
        wOz06KmLAVf9lWEFHuwuXKvTohqY0QygJQ==
X-Google-Smtp-Source: AK7set+GInZDisGh1DidYg0ZOFjrslTZLNeYTSuX13P7iJAnSVheMz7W84NJwKBajZ1uyKHRg4zZlEE8BN2iGA==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a5b:c8:0:b0:914:fc5e:bbec with SMTP id
 d8-20020a5b00c8000000b00914fc5ebbecmr5059ybp.13.1679068554310; Fri, 17 Mar
 2023 08:55:54 -0700 (PDT)
Date:   Fri, 17 Mar 2023 15:55:37 +0000
In-Reply-To: <20230317155539.2552954-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230317155539.2552954-1-edumazet@google.com>
X-Mailer: git-send-email 2.40.0.rc2.332.ga46443480c-goog
Message-ID: <20230317155539.2552954-9-edumazet@google.com>
Subject: [PATCH net-next 08/10] x25: preserve const qualifier in [a]x25_sk()
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

We can change [a]x25_sk() to propagate their argument const qualifier,
thanks to container_of_const().

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/ax25.h | 5 +----
 include/net/x25.h  | 5 +----
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/include/net/ax25.h b/include/net/ax25.h
index f8cf3629a41934f96f33e5d70ad90cc8ae796d38..0d939e5aee4eca38d2b1bd86f87fe3cd990af67b 100644
--- a/include/net/ax25.h
+++ b/include/net/ax25.h
@@ -260,10 +260,7 @@ struct ax25_sock {
 	struct ax25_cb		*cb;
 };
 
-static inline struct ax25_sock *ax25_sk(const struct sock *sk)
-{
-	return (struct ax25_sock *) sk;
-}
+#define ax25_sk(ptr) container_of_const(ptr, struct ax25_sock, sk)
 
 static inline struct ax25_cb *sk_to_ax25(const struct sock *sk)
 {
diff --git a/include/net/x25.h b/include/net/x25.h
index d7d6c2b4ffa7153b0caef7dd249ba93f5f39e414..597eb53c471e3386108447d46b054852abfcce6c 100644
--- a/include/net/x25.h
+++ b/include/net/x25.h
@@ -177,10 +177,7 @@ struct x25_forward {
 	atomic_t		refcnt;
 };
 
-static inline struct x25_sock *x25_sk(const struct sock *sk)
-{
-	return (struct x25_sock *)sk;
-}
+#define x25_sk(ptr) container_of_const(ptr, struct x25_sock, sk)
 
 /* af_x25.c */
 extern int  sysctl_x25_restart_request_timeout;
-- 
2.40.0.rc2.332.ga46443480c-goog

