Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 537F92156F9
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 14:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729079AbgGFMC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 08:02:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728264AbgGFMCz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 08:02:55 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C567C061794
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 05:02:55 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id md7so1800425pjb.1
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 05:02:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=/2x+x6/EXHMosj9/XKEHqgqlxb+0TqzXOMFNfOMaTKM=;
        b=abOoHqZmq4wBa30q6PG2gY2ruJKpYFt73c51peMfNVeZGtp//6eGJSxJvdtA1vMrNN
         lDs0y5Mt56bRKJEvIUWfj4NAEoCCeOaedFDX3mlaQ/Mq3nJJs6+GHLHljwjuGseWFwXK
         2Op2hkWG6dGXDOyKowwz5/DyPzLATzNKHNI4S7L/9CmH4mUGYsOR6WE9uDK21SzuLeks
         bUzOEJoUFlqQhe45SYVqBvu7HMhbqwJQZRTDUlkTxm225x7pmB0a0p72YyrtjheycnCM
         Vu5QIOkUdIfnjdyaGqqdnuIhQaMPWCsKv4pldea8L1Zc9a8l6A28Ns9ZZWWWKe26SZGZ
         dWCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=/2x+x6/EXHMosj9/XKEHqgqlxb+0TqzXOMFNfOMaTKM=;
        b=GRHgORyHxKg7mPp1r2EwUWTh5ITjUvwDXerGwApfJUvUyL89HlwWV0DRRRdlCRaNV2
         +yGwjJut7KDjzGFeV/0D/PMt1wIostHnkejaHOICogMRrj9eNKJYYUyAmmWk+ARgJGc5
         fPhJSx6PZF67JGm4QSL47rMJwDpMQz/UySNXQlozOGh6gn0MMecYAZT5m7b2/7fjAI8V
         B8I1oqRrBe3DP0JIBjyQSC97lDHOqOYLWLqFH7honqb+J8FJ9B5xR2ypwIraSjDZlrTB
         QHjfhJ2HX7p84bUQFH4N0RMsNpo42ijV6wz0h6mbH3ROWyOFKFDTAN61SyjFYNgGnowF
         xnIQ==
X-Gm-Message-State: AOAM532RYgdOF4GsgqNaGF4ESAWNF5t9/+JDsGuSdwyDV6klPCI3+8Ka
        /8rM2WTHX4ouz+o36QUeuM/cCZA9scY=
X-Google-Smtp-Source: ABdhPJzQ4WF/NlWexI0AlrXXAHK50d/j/scMWPbB6GlJdtKR5rcZtT987IVQyIaEbuQywFNX4781mQ==
X-Received: by 2002:a17:90a:fe6:: with SMTP id 93mr44456335pjz.145.1594036974559;
        Mon, 06 Jul 2020 05:02:54 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g135sm19954113pfb.41.2020.07.06.05.02.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 Jul 2020 05:02:53 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        kbuild test robot <lkp@intel.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCHv3 ipsec-next 08/10] ipcomp: assign if_id to child tunnel from parent tunnel
Date:   Mon,  6 Jul 2020 20:01:36 +0800
Message-Id: <06ee531a2bb8936a1e5bdbb4ac3b3d07aae4199d.1594036709.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <35a313492a554aa64b07bb4fcbf8d577141e6ade.1594036709.git.lucien.xin@gmail.com>
References: <cover.1594036709.git.lucien.xin@gmail.com>
 <2fa6dda741a8a315405989bf3276d9158f4d92e2.1594036709.git.lucien.xin@gmail.com>
 <e852e03656d09a9e469c3fe9c04af25a0551075c.1594036709.git.lucien.xin@gmail.com>
 <2a8edf158432201b796f13ccc2e80f2fcafbb8d8.1594036709.git.lucien.xin@gmail.com>
 <b588daa77c6304119b8578d31d3e29fbc8959178.1594036709.git.lucien.xin@gmail.com>
 <97bd8d867973d769486f5a9b98fe6e13ba3fa821.1594036709.git.lucien.xin@gmail.com>
 <a0c059b3690e690248cbbe1130e160b96b30d989.1594036709.git.lucien.xin@gmail.com>
 <35a313492a554aa64b07bb4fcbf8d577141e6ade.1594036709.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1594036709.git.lucien.xin@gmail.com>
References: <cover.1594036709.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The child tunnel if_id will be used for xfrm interface's lookup
when processing the IP(6)IP(6) packets in the next patches.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv4/ipcomp.c  | 1 +
 net/ipv6/ipcomp6.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/net/ipv4/ipcomp.c b/net/ipv4/ipcomp.c
index 59bfa38..b426832 100644
--- a/net/ipv4/ipcomp.c
+++ b/net/ipv4/ipcomp.c
@@ -72,6 +72,7 @@ static struct xfrm_state *ipcomp_tunnel_create(struct xfrm_state *x)
 	t->props.flags = x->props.flags;
 	t->props.extra_flags = x->props.extra_flags;
 	memcpy(&t->mark, &x->mark, sizeof(t->mark));
+	t->if_id = x->if_id;
 
 	if (xfrm_init_state(t))
 		goto error;
diff --git a/net/ipv6/ipcomp6.c b/net/ipv6/ipcomp6.c
index 99668bf..daef890 100644
--- a/net/ipv6/ipcomp6.c
+++ b/net/ipv6/ipcomp6.c
@@ -91,6 +91,7 @@ static struct xfrm_state *ipcomp6_tunnel_create(struct xfrm_state *x)
 	t->props.mode = x->props.mode;
 	memcpy(t->props.saddr.a6, x->props.saddr.a6, sizeof(struct in6_addr));
 	memcpy(&t->mark, &x->mark, sizeof(t->mark));
+	t->if_id = x->if_id;
 
 	if (xfrm_init_state(t))
 		goto error;
-- 
2.1.0

