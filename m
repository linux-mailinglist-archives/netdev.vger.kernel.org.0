Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 015111E35E0
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 04:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728216AbgE0CtE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 22:49:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbgE0CtE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 22:49:04 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFB8BC061A0F
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 19:49:02 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id r18so23339845ybg.10
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 19:49:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=uvN/1C83gvca1O7SBpsQF5zHNhCfn4HbK94ypBuXVcM=;
        b=d+H1A5S8GclPVH3sZG8KJNfgyOu14gegyuhoya2YGzmOxtMB7x6CVWZ4P/OQO0Ghs0
         oF56TDt3UyHIkn9d3ZgvHxP8Qn/oQgzvQMBMivXzjIc6Z5qjVYsJ0IZESJ3/Zr4gQoTb
         NJTZfNokAExA2jXc4Q9MDHi6DnW/Nq7jF+wiz336qTZ3CGONDmqgWBSwBlVqDiKW8S1i
         RWgNyMk+0A9HeRYy4aX2m5dvi5SLa7qIr5/xuMofLV7XXoeRZZRqrjkAbjyZjTHC8KbL
         RnuWphzesTPMMejERs9DQZgLr/AkgbuAuYGspniuUeCjnkai2fJ01IGNpDmWRX1eCfxw
         qQkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=uvN/1C83gvca1O7SBpsQF5zHNhCfn4HbK94ypBuXVcM=;
        b=a9SKz9sxeBgz42Cb+NaapNL2blHXNlP+K5oB6AMxYcL+ho23B/R4i2arfY+hxbYoef
         zSDsMIH0alOgMdvOelDgatz4Igw/vosGpizZ8WyFEYCzIDfMnsMscH9bRYfXQcyoz3R/
         nN47q8fk9dn313lqlT8voan9FuxKgqxGRWfrfkYp82O+EwLkGgV7pVDX6QLzHbbZW8x8
         lOnnsvtCa/HQZRviMS1nR+MoVMfJWtikqJU2jXwSwU3QYq8Hm16NEBTeTSxfbr656KTp
         FC1xbwTQtppmgl1uGy6C9lNMYC9qpwy1lTjJemBGlA40u4ZLzLYc/pCddPQIIUqtKEHq
         +8vg==
X-Gm-Message-State: AOAM533uc+4RkSDwmGPzBWtBhbiXv7ZZeRS4d3rS01qw2uiM+PeHLTbH
        SPOURLposS6A+u55LxvrnyUd32vXgUUiyQ==
X-Google-Smtp-Source: ABdhPJze+1i0dYOuu3e+vtH7qz/dLmsRn8pYg37jMSNbyYghs3tp34fPjtUElO6ntY3UphiVMPhdIEyMQHQkUQ==
X-Received: by 2002:a25:aa2a:: with SMTP id s39mr6312589ybi.492.1590547742088;
 Tue, 26 May 2020 19:49:02 -0700 (PDT)
Date:   Tue, 26 May 2020 19:48:50 -0700
In-Reply-To: <20200527024850.81404-1-edumazet@google.com>
Message-Id: <20200527024850.81404-3-edumazet@google.com>
Mime-Version: 1.0
References: <20200527024850.81404-1-edumazet@google.com>
X-Mailer: git-send-email 2.27.0.rc0.183.gde8f92d652-goog
Subject: [PATCH net-next 2/2] tcp: rename tcp_v4_err() skb parameter
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

This essentially reverts 4d1a2d9ec1c1 ("Revert Backoff [v3]:
Rename skb to icmp_skb in tcp_v4_err()")

Now we have tcp_ld_RTO_revert() helper, we can use the usual
name for sk_buff parameter, so that tcp_v4_err() and
tcp_v6_err() use similar names.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp_ipv4.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 8b257a92c98ffdb4618b8cde0937740ad5fe2e64..3a1e2becb1e8d1e0513e87bdfc0e1d5769ffc8e8 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -458,23 +458,23 @@ static void tcp_ld_RTO_revert(struct sock *sk, u32 seq)
  *
  */
 
-int tcp_v4_err(struct sk_buff *icmp_skb, u32 info)
+int tcp_v4_err(struct sk_buff *skb, u32 info)
 {
-	const struct iphdr *iph = (const struct iphdr *)icmp_skb->data;
-	struct tcphdr *th = (struct tcphdr *)(icmp_skb->data + (iph->ihl << 2));
+	const struct iphdr *iph = (const struct iphdr *)skb->data;
+	struct tcphdr *th = (struct tcphdr *)(skb->data + (iph->ihl << 2));
 	struct tcp_sock *tp;
 	struct inet_sock *inet;
-	const int type = icmp_hdr(icmp_skb)->type;
-	const int code = icmp_hdr(icmp_skb)->code;
+	const int type = icmp_hdr(skb)->type;
+	const int code = icmp_hdr(skb)->code;
 	struct sock *sk;
 	struct request_sock *fastopen;
 	u32 seq, snd_una;
 	int err;
-	struct net *net = dev_net(icmp_skb->dev);
+	struct net *net = dev_net(skb->dev);
 
 	sk = __inet_lookup_established(net, &tcp_hashinfo, iph->daddr,
 				       th->dest, iph->saddr, ntohs(th->source),
-				       inet_iif(icmp_skb), 0);
+				       inet_iif(skb), 0);
 	if (!sk) {
 		__ICMP_INC_STATS(net, ICMP_MIB_INERRORS);
 		return -ENOENT;
@@ -524,7 +524,7 @@ int tcp_v4_err(struct sk_buff *icmp_skb, u32 info)
 	switch (type) {
 	case ICMP_REDIRECT:
 		if (!sock_owned_by_user(sk))
-			do_redirect(icmp_skb, sk);
+			do_redirect(skb, sk);
 		goto out;
 	case ICMP_SOURCE_QUENCH:
 		/* Just silently ignore these. */
@@ -578,7 +578,7 @@ int tcp_v4_err(struct sk_buff *icmp_skb, u32 info)
 		if (fastopen && !fastopen->sk)
 			break;
 
-		ip_icmp_error(sk, icmp_skb, err, th->dest, info, (u8 *)th);
+		ip_icmp_error(sk, skb, err, th->dest, info, (u8 *)th);
 
 		if (!sock_owned_by_user(sk)) {
 			sk->sk_err = err;
-- 
2.27.0.rc0.183.gde8f92d652-goog

