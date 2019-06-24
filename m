Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4626750EF2
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 16:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728347AbfFXOrT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 10:47:19 -0400
Received: from mail-qk1-f172.google.com ([209.85.222.172]:40737 "EHLO
        mail-qk1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728127AbfFXOrT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 10:47:19 -0400
Received: by mail-qk1-f172.google.com with SMTP id c70so9929790qkg.7
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 07:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language;
        bh=agc1XoetiK1tZQGmkSTI9mTuho/2kxDiBLT2wo9qXBU=;
        b=pvRTEV4ZlMZZDTdXVUFFPgWXTDuhsYZHvfMowwdzAaSAwIpOEE0UR6AU9OCdNB1MDP
         GDhkz8LkyPr8zznD7WAEwajC/moMcgYDVeTeyM6k+VAPkmpaDYlXLwreQLhXmm99S3+F
         UmwShCevC4yF1ohRkBniDHxkX1impWwLk90GjcamccDchR3DFacG7Dr5tHDD6RHM6OWD
         j25sJM6GQb+x0qw/6bpzdhzd6j5v/Mh3PnqB2O3jhXcRLWITScChLY0l5KigEMuzFILz
         z0Z+hbTgdoit4v6BLhNNcavngcMCMn0RG3iBDr0vL4x+hRLKFRMhY+XsQcRpqe+oEvbJ
         vDfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language;
        bh=agc1XoetiK1tZQGmkSTI9mTuho/2kxDiBLT2wo9qXBU=;
        b=qlWoVeN25lmhED1LBIKtLXDqjbrgr6uZFkgzpzAkCWDyIf5u0p2HNTZli5SQUA7lxO
         Xt7AYHNndaOmLXKhvpazsw5lJYNCA4qxMjNhV/UxoTkWor3Rshsob1/OQ6P/7xLNNAlv
         7UY5u7twCbUW0ekCIfJb5hVnEh0dZbxqWAgkFZo0h0Lw9V+48ROOf8XcsRQC3DG6ZX2g
         lIwCgcpgu1oyItjxKuGVXje7PbGpI0h8PB4ozHd6RnNlAxZs/tBSWGfg1VtZnaB4vSGs
         40CGlsuU2sObhDx+Srl+e94KkizkiEotmNa6MJrN2qqvTWM/pwTRzqUk/5WZ9zBhP9I1
         mfng==
X-Gm-Message-State: APjAAAUakr12B3cs1Wim9XH85b0FpaMLptX+Eg7H6fDjoovFuUTvR0xa
        icAZGHhHyyZO/lNu/ulMoeiJrA==
X-Google-Smtp-Source: APXvYqxgS6Zqr/tyOYxTVB3dA+Za0qHAk/Tbv2PxiPzhumVrjRANB6UJ04TFGxHBSN7mLwMH+Kh71w==
X-Received: by 2002:a37:4bd3:: with SMTP id y202mr9046870qka.253.1561387637888;
        Mon, 24 Jun 2019 07:47:17 -0700 (PDT)
Received: from [10.0.0.170] ([64.26.149.125])
        by smtp.googlemail.com with ESMTPSA id x35sm8173659qta.11.2019.06.24.07.47.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 07:47:16 -0700 (PDT)
Subject: Re: Removing skb_orphan() from ip_rcv_core()
To:     Joe Stringer <joe@wand.net.nz>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Florian Westphal <fw@strlen.de>
Cc:     netdev <netdev@vger.kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Paolo Abeni <pabeni@redhat.com>
References: <CAOftzPisP-3jN8drC6RXcTigXJjdwEnvTRvTHR-Kv4LKn4rhQQ@mail.gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <ab745372-35eb-8bb8-30a4-0e861af27ac2@mojatatu.com>
Date:   Mon, 24 Jun 2019 10:47:15 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAOftzPisP-3jN8drC6RXcTigXJjdwEnvTRvTHR-Kv4LKn4rhQQ@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------ED91D068261E1548D03DB906"
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------ED91D068261E1548D03DB906
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2019-06-21 1:58 p.m., Joe Stringer wrote:
> Hi folks, picking this up again..
[..]
> During LSFMM, it seemed like no-one knew quite why the skb_orphan() is
> necessary in that path in the current version of the code, and that we
> may be able to remove it. Florian, I know you weren't in the room for
> that discussion, so raising it again now with a stack trace, Do you
> have some sense what's going on here and whether there's a path
> towards removing it from this path or allowing the skb->sk to be
> retained during ip_rcv() in some conditions?


Sorry - I havent followed the discussion but saw your email over
the weekend and wanted to be at work to refresh my memory on some
code. For maybe 2-3 years we have deployed the tproxy
equivalent as a tc action on ingress (with no netfilter dependency).

And, of course, we had to work around that specific code you are
referring to - we didnt remove it. The tc action code increments
the sk refcount and sets the tc index. The net core doesnt orphan
the skb if a speacial tc index value is set (see attached patch)

I never bothered up streaming the patch because the hack is a bit 
embarrassing (but worked ;->); and never posted the action code
either because i thought this was just us that had this requirement.
I am glad other people see the need for this feature. Is there effort
to make this _not_ depend on iptables/netfilter? I am guessing if you
want to do this from ebpf (tc or xdp) that is a requirement.
Our need was with tcp at the time; so left udp dependency on netfilter
alone.

cheers,
jamal

--------------ED91D068261E1548D03DB906
Content-Type: text/x-patch;
 name="tp_tcindex.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="tp_tcindex.patch"

commit 4d130b0a883b4aebc36a88ca116746594e176c6a
Author: Jamal Hadi Salim <hadi@mojatatu.com>
Date:   Fri Nov 25 15:45:48 2016 -0400

    transparent proxy workaround so we can get the tcaction to work

diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
index fa2dc8f692c6..29b303dbbfd9 100644
--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -482,8 +482,11 @@ int ip_rcv(struct sk_buff *skb, struct net_device *dev, struct packet_type *pt,
 	memset(IPCB(skb), 0, sizeof(struct inet_skb_parm));
 	IPCB(skb)->iif = skb->skb_iif;
 
-	/* Must drop socket now because of tproxy. */
-	skb_orphan(skb);
+	/* Must drop socket now because of tproxy,
+	 * if we didnt set it already as usable
+	 * */
+	if(skb->tc_index != 0xFFFF)
+		skb_orphan(skb);
 
 	return NF_HOOK(NFPROTO_IPV4, NF_INET_PRE_ROUTING,
 		       net, NULL, skb, dev, NULL,
diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
index 9ee208a348f5..10148f2eec03 100644
--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -77,12 +77,16 @@ int ipv6_rcv(struct sk_buff *skb, struct net_device *dev, struct packet_type *pt
 	u32 pkt_len;
 	struct inet6_dev *idev;
 	struct net *net = dev_net(skb->dev);
+	struct sock *orig_sk = NULL;
 
 	if (skb->pkt_type == PACKET_OTHERHOST) {
 		kfree_skb(skb);
 		return NET_RX_DROP;
 	}
 
+	if(skb->tc_index == 0xFFFF)
+		orig_sk = skb->sk;
+
 	rcu_read_lock();
 
 	idev = __in6_dev_get(skb->dev);
@@ -202,8 +206,17 @@ int ipv6_rcv(struct sk_buff *skb, struct net_device *dev, struct packet_type *pt
 
 	rcu_read_unlock();
 
+	if (skb->tc_index == 0xFFFF && !skb->sk && orig_sk)
+	{
+		skb_orphan(skb);
+		skb->sk = orig_sk;
+		skb->destructor = sock_edemux;
+		atomic_inc_not_zero(&skb->sk->sk_refcnt);
+	}
+
 	/* Must drop socket now because of tproxy. */
-	skb_orphan(skb);
+	if(skb->tc_index != 0xFFFF)
+		skb_orphan(skb);
 
 	return NF_HOOK(NFPROTO_IPV6, NF_INET_PRE_ROUTING,
 		       net, NULL, skb, dev, NULL,

--------------ED91D068261E1548D03DB906--
