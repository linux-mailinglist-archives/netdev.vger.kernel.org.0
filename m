Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3810C337F22
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 21:36:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231243AbhCKUgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 15:36:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230516AbhCKUfz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 15:35:55 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4B9AC061574
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 12:35:55 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id cl21-20020a17090af695b02900c61ac0f0e9so3747881pjb.1
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 12:35:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=h8XVbQKdXCWJQp+umGqqBJDYSqgM/CA/nG8vr+0C1eI=;
        b=n/cnfUpru2OKNmHrzw+FfXNRavHTpJBic0/dX96BvTsAR/QF2/GBX4PVb0s7uHiGhj
         GuKmhjDZcYfReQcydiNpHw9pKJ3xLKDJTfONsu7afATM/aeyR//WoXQtGqxg3UDgIiHX
         bI6a0TIpjsSLPGUKndpvebCURwcQPs28gBFWD9Vuih4UUFY4qt72qWBVsQdQm4PPmOjz
         1SlFRHdtZpIIkgxekSPJFOfLYbCXaF/MYd96Kxk+Py3gbfJ3l17SjM1f2SScMyhqiRxx
         E1Pm9Z3810WRrp8gpcUcoRdGi2OhXimEOlv0guUm3gMn3U8omhTEsB3hHxy+p7784hfA
         RxRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h8XVbQKdXCWJQp+umGqqBJDYSqgM/CA/nG8vr+0C1eI=;
        b=udZ0/9aNWgYsTHDPM4dUVO5MsfOU5JpciVYpY6w7gzf7GSGK2HSrmKdTeB2+kAinNA
         G/uuoO/oHnn+OSYIWdDtNcKduk4WAcnSWWVQvIXa7Ti7g6OVqm+VHXDC33k5m56tUh2W
         3FZhneY0PSPi7+On07dkFz5r21uG9JN647YIBdvdsAXi+mmoAkYlnSwVX2obH0pW/o13
         oJHr0/lIq10ME7qiAoILJmdBa1kxlPzRO+ZpHxYdbF0B2bxGBys4oqGCNIC8t8bQL+SM
         nL54Oo6a1d9cSfyVfRkKq6m/yMBZ8LbM9c7l0KxQmeCn/5Fp+v8lxaVYgOSTdd5KXHlq
         M7jg==
X-Gm-Message-State: AOAM532zXKAWxYm1drslk26zHbrYEds/5tVJ9+87/vg5ipWJIQfj9IDV
        XgtZb4FVQy9DDc25wehemJY=
X-Google-Smtp-Source: ABdhPJx0oSWkTIcVePmOGr3MP7l1aUvnjfFLGi3jRFhoD18Xd/+7p+YI0ELxSFW+uCwIujpdMG4UYQ==
X-Received: by 2002:a17:902:d64d:b029:de:8aaa:d6ba with SMTP id y13-20020a170902d64db02900de8aaad6bamr9858688plh.0.1615494955254;
        Thu, 11 Mar 2021 12:35:55 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:5186:d796:2218:6442])
        by smtp.gmail.com with ESMTPSA id 25sm3232745pfh.199.2021.03.11.12.35.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 12:35:54 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Neil Spring <ntspring@fb.com>
Subject: [PATCH net-next 3/3] tcp: remove obsolete check in __tcp_retransmit_skb()
Date:   Thu, 11 Mar 2021 12:35:06 -0800
Message-Id: <20210311203506.3450792-4-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
In-Reply-To: <20210311203506.3450792-1-eric.dumazet@gmail.com>
References: <20210311203506.3450792-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

TSQ provides a nice way to avoid bufferbloat on individual socket,
including retransmit packets. We can get rid of the old
heuristic:

	/* Do not sent more than we queued. 1/4 is reserved for possible
	 * copying overhead: fragmentation, tunneling, mangling etc.
	 */
	if (refcount_read(&sk->sk_wmem_alloc) >
	    min_t(u32, sk->sk_wmem_queued + (sk->sk_wmem_queued >> 2),
		  sk->sk_sndbuf))
		return -EAGAIN;

This heuristic was giving false positives according to Jakub,
whenever TX completions are delayed above RTT. (Ack packets
are processed by TCP stack before clones are orphaned/freed)

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Jakub Kicinski <kuba@kernel.org>
Cc: Neal Cardwell <ncardwell@google.com>
Cc: Yuchung Cheng <ycheng@google.com>
---
 net/ipv4/tcp_output.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 0dbf208a4f2f17c630084e87f4a9a2ad0dc24168..bde781f46b41a5dd9eb8db3fb65b45d73e592b4b 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3151,14 +3151,6 @@ int __tcp_retransmit_skb(struct sock *sk, struct sk_buff *skb, int segs)
 	if (icsk->icsk_mtup.probe_size)
 		icsk->icsk_mtup.probe_size = 0;
 
-	/* Do not sent more than we queued. 1/4 is reserved for possible
-	 * copying overhead: fragmentation, tunneling, mangling etc.
-	 */
-	if (refcount_read(&sk->sk_wmem_alloc) >
-	    min_t(u32, sk->sk_wmem_queued + (sk->sk_wmem_queued >> 2),
-		  sk->sk_sndbuf))
-		return -EAGAIN;
-
 	if (skb_still_in_host_queue(sk, skb))
 		return -EBUSY;
 
-- 
2.31.0.rc2.261.g7f71774620-goog

