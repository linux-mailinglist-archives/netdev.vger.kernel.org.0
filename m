Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 332901C607F
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 20:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728798AbgEES5e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 14:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727785AbgEES5e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 14:57:34 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E4ABC061A0F
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 11:57:34 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id a7so1567968pju.2
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 11:57:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=baKPDXK84t/+KcDc27e7wEO3Oj3JjOYYo4AL+8KJlq0=;
        b=q9b6KcDZFzza0x4eqfA83QLO/ntXPpScCELGE1HoBXZ2fxaWgazGtqR8ulTPqhVRyD
         8CQhF8A0vcsaaQNoXc46k1aBwAB3zm/H8iFE42JrL/hzWFeeBppyPIoxdc37Oi+9wFV/
         dMB+/qru+yIAtfOdy0bT5vD4e1H70pc8hJ8AYa0UMxrKLgKpIX1U04RpnJcNqdOTSTHr
         fmLJhAhoP0FGTYMtjXQjdH5mWDJ4xqnAkXyvuwIRXtGyPOUitLvwNWr/Wk9m7h/pwOdX
         jOkDk58kSEU1Xt11OUGb2Z0dGApzvCqQMta5cAJzBxqiNMAom6q2R/y80sagzPqnv/u7
         71UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=baKPDXK84t/+KcDc27e7wEO3Oj3JjOYYo4AL+8KJlq0=;
        b=WKDcymlhZlQI0JtlDuypy/9vwHfsTT2ARS8b4+0PWDVwu66c0AacQa6huRwIeXcM1y
         aaf+I7nWNQdD7076Ag4pT/jEpr7d1kKfN3xbKhKoZEYAn7bRDspTzlwn+zmfdKMFh8A/
         iHHW6RUPiChGPO4rTGSlEQsNIO3L9e8tMKJvVeVP76Bgk4/J/pgUvm4MPyfRdg0RuG9w
         7e8LuDKfZ/3pa7k4NvALFXEN8L/iSwm1el6s02/4JitPN22ei3wqf8OfxtRB9nsM0WNl
         /BtGLfa7zSUzO/wCm5vLSM9PfEYqhy2Gldx6JTLqfRXm5RfR2xJOMnmzXsehOqHju3oH
         nenQ==
X-Gm-Message-State: AGi0PuZUmPz5BI0sRcuXDZGYglzkbs6eLl/mO1AoqZboP+GhOofkxLgq
        LfOdu33TCUgszv1fI01OCMw=
X-Google-Smtp-Source: APiQypIwro8ab3tLY8vMuZj0G2VW69GnFGzXelh+ciTBEOYw+mw1uLVoFBa/24Vck5TdOMKHz8BueA==
X-Received: by 2002:a17:902:8d95:: with SMTP id v21mr4655275plo.322.1588705053607;
        Tue, 05 May 2020 11:57:33 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id l37sm2755115pje.12.2020.05.05.11.57.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 11:57:32 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Xin Long <lucien.xin@gmail.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>
Subject: [PATCH] Revert "ipv6: add mtu lock check in __ip6_rt_update_pmtu"
Date:   Tue,  5 May 2020 11:57:23 -0700
Message-Id: <20200505185723.191944-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.26.2.526.g744177e7f7-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

This reverts commit 19bda36c4299ce3d7e5bce10bebe01764a655a6d:

| ipv6: add mtu lock check in __ip6_rt_update_pmtu
|
| Prior to this patch, ipv6 didn't do mtu lock check in ip6_update_pmtu.
| It leaded to that mtu lock doesn't really work when receiving the pkt
| of ICMPV6_PKT_TOOBIG.
|
| This patch is to add mtu lock check in __ip6_rt_update_pmtu just as ipv4
| did in __ip_rt_update_pmtu.

The above reasoning is incorrect.  IPv6 *requires* icmp based pmtu to work.
There's already a comment to this effect elsewhere in the kernel:

  $ git grep -p -B1 -A3 'RTAX_MTU lock'
  net/ipv6/route.c=4813=

  static int rt6_mtu_change_route(struct fib6_info *f6i, void *p_arg)
  ...
    /* In IPv6 pmtu discovery is not optional,
       so that RTAX_MTU lock cannot disable it.
       We still use this lock to block changes
       caused by addrconf/ndisc.
    */

This reverts to the pre-4.9 behaviour.

Cc: Eric Dumazet <edumazet@google.com>
Cc: Willem de Bruijn <willemb@google.com>
Cc: Xin Long <lucien.xin@gmail.com>
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: Maciej Żenczykowski <maze@google.com>
Fixes: 19bda36c4299 ("ipv6: add mtu lock check in __ip6_rt_update_pmtu")
---
 net/ipv6/route.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 8d418038fe32..ff847a324220 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -2722,8 +2722,10 @@ static void __ip6_rt_update_pmtu(struct dst_entry *dst, const struct sock *sk,
 	const struct in6_addr *daddr, *saddr;
 	struct rt6_info *rt6 = (struct rt6_info *)dst;
 
-	if (dst_metric_locked(dst, RTAX_MTU))
-		return;
+	/* Note: do *NOT* check dst_metric_locked(dst, RTAX_MTU)
+	 * IPv6 pmtu discovery isn't optional, so 'mtu lock' cannot disable it.
+	 * [see also comment in rt6_mtu_change_route()]
+	 */
 
 	if (iph) {
 		daddr = &iph->daddr;
-- 
2.26.2.526.g744177e7f7-goog

