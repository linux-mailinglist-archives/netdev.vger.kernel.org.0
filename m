Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E362284616
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 08:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727143AbgJFGdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 02:33:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbgJFGdG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 02:33:06 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20042C0613A7
        for <netdev@vger.kernel.org>; Mon,  5 Oct 2020 23:33:06 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id 34so7405060pgo.13
        for <netdev@vger.kernel.org>; Mon, 05 Oct 2020 23:33:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eJt7odAAaoqJqWkvl4bKx65VokapE4qYrDJxFhJYjJA=;
        b=dPDR/JVQFZzCu+zBqWIXwHnMGUjjvBiTtV4F2YMhkbPGwapUbqqW4CHwIZXF4Od5qZ
         shjMNpsWSb8ZdbBCpE4WNX+srWsQvegWIH8CZh8YHq1/TcdHyigEwn7SZoqCNi/0sYQ6
         kDNpJni/LBV3sFTbKj5RizoM69Pom+P0xO8XesRIQsSp7Idu6vSBtD2Fi6IhF14+cbmA
         zpMz5ibXQfyhPh1zFsyZ/1XvWETDcXLTOJAwCjYZtQIxwEbrISAD/VOjRdvZa/Osybjn
         LTV0n/7dvZaSLiE8Y04ViTbRZjjFJGgVfdG8CptgokB4aTyVGOr7QimbzmIUhAHsiTOK
         /zEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eJt7odAAaoqJqWkvl4bKx65VokapE4qYrDJxFhJYjJA=;
        b=P5Ues7E/0jot8xJyVMtr3M3hWviaqdbTDNEEcNVxNtHj+qThER3HyGt0EU5/NcZuao
         TxoNJbDJCB6Q9yDHOeyJQMsDztibFIfE2eEpv/8rra4UkyjJ3MjFa72mZO+06KSFrtab
         4ZwoaCIpARo/6nY/mTsHGbCyl6RBY0mrMxSIIdUjngZOsb/BRzyE47D3eRh5kAB7MfEK
         TeYVSyGitgLT/PyWdn5o5CZrU4kjGJNHh4SSueUIUevSA0zSOowktxOQIbugU5Gzx5dz
         v6ekQhUKrRt8CLt4UnS8eB/PhpGesBs/PWbRqQGzDVp951S+IX3kwMlC3jnAn0irLBUP
         FSjw==
X-Gm-Message-State: AOAM531EFLAva96qTQ1+/MRgyaSrR2QTdP+cVmzcwdjuVpwW6P4x9ZAj
        9DTDMDlFnmwkQzAkyz6anp8=
X-Google-Smtp-Source: ABdhPJwrn0Sk5bzuKiFaMzIWSSxKVjMXvMVanGsOBYlenrrJe1quGZxuHRtej9G7B68BRFvIpkbRzg==
X-Received: by 2002:aa7:96fb:0:b029:152:879f:4782 with SMTP id i27-20020aa796fb0000b0290152879f4782mr2986303pfq.45.1601965985724;
        Mon, 05 Oct 2020 23:33:05 -0700 (PDT)
Received: from localhost.localdomain ([49.207.203.202])
        by smtp.gmail.com with ESMTPSA id 124sm2047361pfd.132.2020.10.05.23.33.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 23:33:05 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     gerrit@erg.abdn.ac.uk, kuba@kernel.org, edumazet@google.com,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        johannes@sipsolutions.net, alex.aring@gmail.com,
        stefan@datenfreihafen.org, santosh.shilimkar@oracle.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org, Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>,
        Allen Pais <apais@linux.microsoft.com>
Subject: [RESEND net-next 8/8] net: xfrm: convert tasklets to use new tasklet_setup() API
Date:   Tue,  6 Oct 2020 12:02:01 +0530
Message-Id: <20201006063201.294959-9-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201006063201.294959-1-allen.lkml@gmail.com>
References: <20201006063201.294959-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <apais@linux.microsoft.com>
---
 net/xfrm/xfrm_input.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index 37456d022..be6351e3f 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -760,9 +760,9 @@ int xfrm_input_resume(struct sk_buff *skb, int nexthdr)
 }
 EXPORT_SYMBOL(xfrm_input_resume);
 
-static void xfrm_trans_reinject(unsigned long data)
+static void xfrm_trans_reinject(struct tasklet_struct *t)
 {
-	struct xfrm_trans_tasklet *trans = (void *)data;
+	struct xfrm_trans_tasklet *trans = from_tasklet(trans, t, tasklet);
 	struct sk_buff_head queue;
 	struct sk_buff *skb;
 
@@ -818,7 +818,6 @@ void __init xfrm_input_init(void)
 
 		trans = &per_cpu(xfrm_trans_tasklet, i);
 		__skb_queue_head_init(&trans->queue);
-		tasklet_init(&trans->tasklet, xfrm_trans_reinject,
-			     (unsigned long)trans);
+		tasklet_setup(&trans->tasklet, xfrm_trans_reinject);
 	}
 }
-- 
2.25.1

