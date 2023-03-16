Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9602D6BD3EF
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 16:36:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231820AbjCPPgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 11:36:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231634AbjCPPgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 11:36:17 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B5E1E2512
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 08:33:51 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id e20-20020a25d314000000b00b33355abd3dso2203452ybf.14
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 08:33:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678980731;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AIfE2HKr49ytMSaGl0Yiq5WDILcsXgC/2cRVrFMjsUw=;
        b=gQOWswxHszA2NFwOApK1Z+JNqPbnRMbhzwzH9/V3l3B76JTV8VnzV6zTGgMyO4iGH1
         OWHvDExZgVhPx81bvHvHNlbxX8YdtOlLq82WCHhP8ft0xp5hHPaD7GUWh2k5LXQjYL2F
         kmDYREKN6ZwZXYKPV3h5Y+kNhQvyeLsAZWDAqpLG+psX+SLxnv44Dw3ML9rGQHxM5Snd
         U2fok+iKs8wUJTvmz50rCWD6mOytWygjv1kkW6FU+P4Sm1qjJXOVrbPYUySpjQNpMciE
         Y2xrb5VeiU7BcBD/ZyZCBP5i9q6kpUg/ESk5gkocvuSQSdz2w6BeToLLAPlluzGR+4zc
         M9EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678980731;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AIfE2HKr49ytMSaGl0Yiq5WDILcsXgC/2cRVrFMjsUw=;
        b=LkuHjGz0RWAFyCwuW2csfph8dOFR0ztoiGzbmIRDy5D8zpwPLMzo3ccNSrKbwJBIBv
         2pzCUCHO349YImHYrbAg7aZLQ7f9Mqc0vq43dAWUVXYz2p5Lc7V2qPqsbK/LJOBmJRns
         fDi9n2cfOKEVj98eGnb7Q0abh+aDrcmJF1cLWCvpBufQSSTX33UJi0aKFuLWIg6r1JcC
         yPax5BWmwmq+zP43DsHouzYG1cfO8i0YjzvUc1FCOiKyEPnsafdErdz6F0DYQ2FwmWoj
         ZvTUAmXT2YPl4HtWbcJbm9fVaBy8WveK6YTCry+khSyv07rr7Ztm/3TuzDvxc8Rx7+1u
         7kfA==
X-Gm-Message-State: AO0yUKVwYZ7+Fw3MWSv+R0b+jDELHaHfa6lVPko0xy5e0TA8CRuzH64E
        762lAHi+on2YFJdNvUjyW4CnmEeDpG98MQ==
X-Google-Smtp-Source: AK7set/2JjMMYHCvqwAuMsykfvjZg1zUnobCfnyyv6oviKsbbGDZR/SHPh/pVKxDkYMqE39Va3agJfbjbv5h/Q==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a5b:6c8:0:b0:b36:32f8:852d with SMTP id
 r8-20020a5b06c8000000b00b3632f8852dmr6933767ybq.4.1678980730838; Thu, 16 Mar
 2023 08:32:10 -0700 (PDT)
Date:   Thu, 16 Mar 2023 15:31:58 +0000
In-Reply-To: <20230316153202.1354692-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230316153202.1354692-1-edumazet@google.com>
X-Mailer: git-send-email 2.40.0.rc2.332.ga46443480c-goog
Message-ID: <20230316153202.1354692-5-edumazet@google.com>
Subject: [PATCH v2 net-next 4/8] ipv6: constify inet6_mc_check()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Simon Horman <simon.horman@corigine.com>,
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

inet6_mc_check() is essentially a read-only function.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
 include/net/addrconf.h | 2 +-
 net/ipv6/mcast.c       | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/net/addrconf.h b/include/net/addrconf.h
index c04f359655b86feed2b4b42cc69b90c63088238a..82da55101b5a30b2a5512d964429d2c5f73d03fd 100644
--- a/include/net/addrconf.h
+++ b/include/net/addrconf.h
@@ -223,7 +223,7 @@ int ipv6_sock_mc_drop(struct sock *sk, int ifindex,
 		      const struct in6_addr *addr);
 void __ipv6_sock_mc_close(struct sock *sk);
 void ipv6_sock_mc_close(struct sock *sk);
-bool inet6_mc_check(struct sock *sk, const struct in6_addr *mc_addr,
+bool inet6_mc_check(const struct sock *sk, const struct in6_addr *mc_addr,
 		    const struct in6_addr *src_addr);
 
 int ipv6_dev_mc_inc(struct net_device *dev, const struct in6_addr *addr);
diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index 1c02160cf7a4c54f0d8687b8368e5f6151ab0bce..714cdc9e2b8edfb925a061a722c38b37b1c6088e 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -627,12 +627,12 @@ int ip6_mc_msfget(struct sock *sk, struct group_filter *gsf,
 	return 0;
 }
 
-bool inet6_mc_check(struct sock *sk, const struct in6_addr *mc_addr,
+bool inet6_mc_check(const struct sock *sk, const struct in6_addr *mc_addr,
 		    const struct in6_addr *src_addr)
 {
-	struct ipv6_pinfo *np = inet6_sk(sk);
-	struct ipv6_mc_socklist *mc;
-	struct ip6_sf_socklist *psl;
+	const struct ipv6_pinfo *np = inet6_sk(sk);
+	const struct ipv6_mc_socklist *mc;
+	const struct ip6_sf_socklist *psl;
 	bool rv = true;
 
 	rcu_read_lock();
-- 
2.40.0.rc2.332.ga46443480c-goog

