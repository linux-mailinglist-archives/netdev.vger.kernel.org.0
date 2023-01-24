Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5049C678E30
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 03:20:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232235AbjAXCUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 21:20:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232302AbjAXCUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 21:20:22 -0500
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11C5D29162
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 18:20:18 -0800 (PST)
Received: by mail-qt1-x832.google.com with SMTP id m26so2345787qtp.9
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 18:20:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2C8tCkjwUseX03Eq/3m1E4h4dlTxQAC8ymgLg1MBMXk=;
        b=D6jIJiAOz+uJJL8tzRUjt3iWsJXgEH9ZUsYlKP9f8XpBFnLJ36gGxa9Tx0tq7+NAOB
         fvFPTEgcNdoBGKx71PDXUgXENU51qKBg2fHOVJG5Gt3Bn3BrhvWJJlIoHulWH76f5uEF
         fp76oRZeRomM1K85awrNnNMB1Icux2Y/qGueeufk4vxOoP29HKwyWoG88hXUCE516g4i
         pTvxvlwup0Pr/CiSIaiU/TwPX/R9vPl1MX/ndby9XJIJ7Mdfavw9S/DMjWlFO+opGrDR
         xHrVXngdOKjnpaZsqGRDlYRpa7UqdBcAJBOeGQvILG5qOJ9dPExq04GZxl50PLG/2DK3
         gEcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2C8tCkjwUseX03Eq/3m1E4h4dlTxQAC8ymgLg1MBMXk=;
        b=gvZkwg/rNe/vXC1xBLaVAN11OeCXuVZdWvV+HfdxjS473vJo4Flp+KjhE2szW7JbK4
         w5zpb0OEYWo1Yr1/pTRtQfqstDHo/9f3ML5hSV9fmSI51WAV1wwNpWF5ZhDntlFuc6qy
         uBdeo7j9mYYUJ2Cb4XGTbe33XReEj+0oRowX/aB2O5ueS0KFy/9rj7j3IysEd8snp1uK
         ABB0G1QGGyuHmaSDlglnEpZSRgAIJCSvggcIqN8qJztV4NyGcgRzzU8Uu4w1dHcyl2iF
         +EDBspvpjJqaD7qg0Y7uDGGu1OA9bGUJ+ulPg+9dEEs3v4reyMR7bnDfZmk7sYWv2o70
         pKbQ==
X-Gm-Message-State: AFqh2kpSbYwjE6t4yusOUqcYKwyPRio6Tu4DrOK7nMfmaVFxSthUEbs3
        PrwYO6l5+KyZ5l4JkI5WgtzWRzdUe2QckA==
X-Google-Smtp-Source: AMrXdXsPaZVIN7mrDW5cQTZIdqQKB7ucTnUavH2bWXRJ3UxNAE8bVihyQqvHJDxTX5+BU4FhszkNjw==
X-Received: by 2002:a05:622a:4315:b0:3a9:8b48:f8f with SMTP id el21-20020a05622a431500b003a98b480f8fmr31558352qtb.67.1674526817572;
        Mon, 23 Jan 2023 18:20:17 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id f1-20020ac840c1000000b003a981f7315bsm410558qtm.44.2023.01.23.18.20.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 18:20:17 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Aaron Conole <aconole@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Mahesh Bandewar <maheshb@google.com>,
        Paul Moore <paul@paul-moore.com>,
        Guillaume Nault <gnault@redhat.com>
Subject: [PATCHv2 net-next 09/10] net: add support for ipv4 big tcp
Date:   Mon, 23 Jan 2023 21:20:03 -0500
Message-Id: <b4e320e98dd3452e961e826f1a7b94a60d0198ad.1674526718.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1674526718.git.lucien.xin@gmail.com>
References: <cover.1674526718.git.lucien.xin@gmail.com>
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

Similar to Eric's IPv6 BIG TCP, this patch is to enable IPv4 BIG TCP.

Firstly, allow sk->sk_gso_max_size to be set to a value greater than
GSO_LEGACY_MAX_SIZE by not trimming gso_max_size in sk_trim_gso_size()
for IPv4 TCP sockets.

Then on TX path, set IP header tot_len to 0 when skb->len > IP_MAX_MTU
in __ip_local_out() to allow to send BIG TCP packets, and this implies
that skb->len is the length of a IPv4 packet; On RX path, use skb->len
as the length of the IPv4 packet when the IP header tot_len is 0 and
skb->len > IP_MAX_MTU in ip_rcv_core(). As the API iph_set_totlen() and
skb_ip_totlen() are used in __ip_local_out() and ip_rcv_core(), we only
need to update these APIs.

Also in GRO receive, add the check for ETH_P_IP/IPPROTO_TCP, and allows
the merged packet size >= GRO_LEGACY_MAX_SIZE in skb_gro_receive(). In
GRO complete, set IP header tot_len to 0 when the merged packet size
greater than IP_MAX_MTU in iph_set_totlen() so that it can be processed
on RX path.

Note that by checking skb_is_gso_tcp() in API iph_totlen(), it makes
this implementation safe to use iph->len == 0 indicates IPv4 BIG TCP
packets.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/core/gro.c       |  6 +++---
 net/core/sock.c      | 11 ++---------
 net/ipv4/af_inet.c   |  7 ++++---
 net/ipv4/ip_input.c  |  2 +-
 net/ipv4/ip_output.c |  2 +-
 5 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/net/core/gro.c b/net/core/gro.c
index 506f83d715f8..82656dc787f2 100644
--- a/net/core/gro.c
+++ b/net/core/gro.c
@@ -169,9 +169,9 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
 		return -E2BIG;
 
 	if (unlikely(p->len + len >= GRO_LEGACY_MAX_SIZE)) {
-		if (p->protocol != htons(ETH_P_IPV6) ||
-		    skb_headroom(p) < sizeof(struct hop_jumbo_hdr) ||
-		    ipv6_hdr(p)->nexthdr != IPPROTO_TCP ||
+		if (NAPI_GRO_CB(skb)->proto != IPPROTO_TCP ||
+		    (p->protocol == htons(ETH_P_IPV6) &&
+		     skb_headroom(p) < sizeof(struct hop_jumbo_hdr)) ||
 		    p->encapsulation)
 			return -E2BIG;
 	}
diff --git a/net/core/sock.c b/net/core/sock.c
index 7ba4891460ad..602c3d68ce19 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2375,15 +2375,8 @@ EXPORT_SYMBOL_GPL(sk_free_unlock_clone);
 
 static void sk_trim_gso_size(struct sock *sk)
 {
-	if (sk->sk_gso_max_size <= GSO_LEGACY_MAX_SIZE)
-		return;
-#if IS_ENABLED(CONFIG_IPV6)
-	if (sk->sk_family == AF_INET6 &&
-	    sk_is_tcp(sk) &&
-	    !ipv6_addr_v4mapped(&sk->sk_v6_rcv_saddr))
-		return;
-#endif
-	sk->sk_gso_max_size = GSO_LEGACY_MAX_SIZE;
+	if (sk->sk_gso_max_size > GSO_LEGACY_MAX_SIZE && !sk_is_tcp(sk))
+		sk->sk_gso_max_size = GSO_LEGACY_MAX_SIZE;
 }
 
 void sk_setup_caps(struct sock *sk, struct dst_entry *dst)
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 6c0ec2789943..2f992a323b95 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1485,6 +1485,7 @@ struct sk_buff *inet_gro_receive(struct list_head *head, struct sk_buff *skb)
 	if (unlikely(ip_fast_csum((u8 *)iph, 5)))
 		goto out;
 
+	NAPI_GRO_CB(skb)->proto = proto;
 	id = ntohl(*(__be32 *)&iph->id);
 	flush = (u16)((ntohl(*(__be32 *)iph) ^ skb_gro_len(skb)) | (id & ~IP_DF));
 	id >>= 16;
@@ -1618,9 +1619,9 @@ int inet_recv_error(struct sock *sk, struct msghdr *msg, int len, int *addr_len)
 
 int inet_gro_complete(struct sk_buff *skb, int nhoff)
 {
-	__be16 newlen = htons(skb->len - nhoff);
 	struct iphdr *iph = (struct iphdr *)(skb->data + nhoff);
 	const struct net_offload *ops;
+	__be16 totlen = iph->tot_len;
 	int proto = iph->protocol;
 	int err = -ENOSYS;
 
@@ -1629,8 +1630,8 @@ int inet_gro_complete(struct sk_buff *skb, int nhoff)
 		skb_set_inner_network_header(skb, nhoff);
 	}
 
-	csum_replace2(&iph->check, iph->tot_len, newlen);
-	iph->tot_len = newlen;
+	iph_set_totlen(iph, skb->len - nhoff);
+	csum_replace2(&iph->check, totlen, iph->tot_len);
 
 	ops = rcu_dereference(inet_offloads[proto]);
 	if (WARN_ON(!ops || !ops->callbacks.gro_complete))
diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
index e880ce77322a..0aa8c49b4e1b 100644
--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -511,7 +511,7 @@ static struct sk_buff *ip_rcv_core(struct sk_buff *skb, struct net *net)
 	if (unlikely(ip_fast_csum((u8 *)iph, iph->ihl)))
 		goto csum_error;
 
-	len = ntohs(iph->tot_len);
+	len = skb_ip_totlen(skb);
 	if (skb->len < len) {
 		drop_reason = SKB_DROP_REASON_PKT_TOO_SMALL;
 		__IP_INC_STATS(net, IPSTATS_MIB_INTRUNCATEDPKTS);
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 922c87ef1ab5..4e4e308c3230 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -100,7 +100,7 @@ int __ip_local_out(struct net *net, struct sock *sk, struct sk_buff *skb)
 {
 	struct iphdr *iph = ip_hdr(skb);
 
-	iph->tot_len = htons(skb->len);
+	iph_set_totlen(iph, skb->len);
 	ip_send_check(iph);
 
 	/* if egress device is enslaved to an L3 master device pass the
-- 
2.31.1

