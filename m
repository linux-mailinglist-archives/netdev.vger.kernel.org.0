Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F38BF229A9E
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 16:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732596AbgGVOw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 10:52:27 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:65359 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730346AbgGVOw1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 10:52:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1595429547; x=1626965547;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=+omhnPDjGYNd4Aearh2KyiqpdHXwk+4wB4wi06Z0vyc=;
  b=HsfQOyNJwjNhekCIKrBeZBldJ06xUeeLGNEzX/q5jwZ5XRfQVelRlZle
   tQ23TunSwxuuj6LJrd7gz9jD4fmpnpEVPaXmgZ9olZVXcHYscFCmZ/yC9
   QNm2hSIJnNSzjom9qFwycbinC8ChThk7/ZE9hWCc4/4Hmo7qv4v2hMuBF
   I=;
IronPort-SDR: je7CCMBZRTnBiWsrQdDcOiwQ4IcE7geaSNzeudp/9vT99k5lvGkQPOBXGXhXdJqU9L8uD6l3ot
 AlU8QQnmv5GA==
X-IronPort-AV: E=Sophos;i="5.75,383,1589241600"; 
   d="scan'208";a="53764065"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-f14f4a47.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 22 Jul 2020 14:42:24 +0000
Received: from EX13MTAUWA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-f14f4a47.us-west-2.amazon.com (Postfix) with ESMTPS id 0F8EEA411A;
        Wed, 22 Jul 2020 14:42:23 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 22 Jul 2020 14:42:22 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.161.34) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 22 Jul 2020 14:42:17 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <jakub@cloudflare.com>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <davem@davemloft.net>,
        <kernel-team@cloudflare.com>, <kuniyu@amazon.co.jp>,
        <linux-kernel@vger.kernel.org>, <linux-next@vger.kernel.org>,
        <netdev@vger.kernel.org>, <sfr@canb.auug.org.au>,
        <willemb@google.com>
Subject: Re: linux-next: manual merge of the bpf-next tree with the net tree
Date:   Wed, 22 Jul 2020 23:42:12 +0900
Message-ID: <20200722144212.27106-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <87wo2vwxq6.fsf@cloudflare.com>
References: <87wo2vwxq6.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.34]
X-ClientProxiedBy: EX13D05UWC004.ant.amazon.com (10.43.162.223) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Jakub Sitnicki <jakub@cloudflare.com>
Date:   Wed, 22 Jul 2020 14:17:05 +0200
> On Wed, Jul 22, 2020 at 05:21 AM CEST, Stephen Rothwell wrote:
> > Hi all,
> >
> > Today's linux-next merge of the bpf-next tree got conflicts in:
> >
> >   net/ipv4/udp.c
> >   net/ipv6/udp.c
> >
> > between commit:
> >
> >   efc6b6f6c311 ("udp: Improve load balancing for SO_REUSEPORT.")
> >
> > from the net tree and commits:
> >
> >   7629c73a1466 ("udp: Extract helper for selecting socket from reuseport group")
> >   2a08748cd384 ("udp6: Extract helper for selecting socket from reuseport group")
> >
> > from the bpf-next tree.
> >
> > I fixed it up (I wasn't sure how to proceed, so I used the latter
> > version) and can carry the fix as necessary. This is now fixed as far
> > as linux-next is concerned, but any non trivial conflicts should be
> > mentioned to your upstream maintainer when your tree is submitted for
> > merging.  You may also want to consider cooperating with the maintainer
> > of the conflicting tree to minimise any particularly complex conflicts.
> 
> This one is a bit tricky.
> 
> Looking at how code in udp[46]_lib_lookup2 evolved, first:
> 
>   acdcecc61285 ("udp: correct reuseport selection with connected sockets")
> 
> 1) exluded connected UDP sockets from reuseport group during lookup, and
> 2) limited fast reuseport return to groups with no connected sockets,
> 
> The second change had an uninteded side-effect of discarding reuseport
> socket selection when reuseport group contained connected sockets.
> 
> Then, recent
> 
>   efc6b6f6c311 ("udp: Improve load balancing for SO_REUSEPORT.")
> 
> rectified it by recording reuseport socket selection as lookup result
> candidate, in case fast reuseport return did not happen because
> reuseport group had connected sockets.
> 
> I belive that changes in commit efc6b6f6c311 can be rewritten as below
> to the same effect, by realizing that we are always setting the 'result'
> if 'score > badness'. Either to what reuseport_select_sock() returned or
> to 'sk' that scored higher than current 'badness' threshold.

Good point!
It looks good to me.


> ---8<---
> static struct sock *udp4_lib_lookup2(struct net *net,
> 				     __be32 saddr, __be16 sport,
> 				     __be32 daddr, unsigned int hnum,
> 				     int dif, int sdif,
> 				     struct udp_hslot *hslot2,
> 				     struct sk_buff *skb)
> {
> 	struct sock *sk, *result;
> 	int score, badness;
> 	u32 hash = 0;
> 
> 	result = NULL;
> 	badness = 0;
> 	udp_portaddr_for_each_entry_rcu(sk, &hslot2->head) {
> 		score = compute_score(sk, net, saddr, sport,
> 				      daddr, hnum, dif, sdif);
> 		if (score > badness) {
> 			result = NULL;
> 			if (sk->sk_reuseport &&
> 			    sk->sk_state != TCP_ESTABLISHED) {
> 				hash = udp_ehashfn(net, daddr, hnum,
> 						   saddr, sport);
> 				result = reuseport_select_sock(sk, hash, skb,
> 							       sizeof(struct udphdr));
> 				if (result && !reuseport_has_conns(sk, false))
> 					return result;
> 			}
> 			if (!result)
> 				result = sk;
> 			badness = score;
> 		}
> 	}
> 	return result;
> }
> ---8<---
> 
> From there, it is now easier to resolve the conflict with
> 
>   7629c73a1466 ("udp: Extract helper for selecting socket from reuseport group")
>   2a08748cd384 ("udp6: Extract helper for selecting socket from reuseport group")
> 
> which extract the 'if (sk->sk_reuseport && sk->sk_state !=
> TCP_ESTABLISHED)' block into a helper called lookup_reuseport().
> 
> To merge the two, we need to pull the reuseport_has_conns() check up
> from lookup_reuseport() and back into udp[46]_lib_lookup2(), because now
> we want to record reuseport socket selection even if reuseport group has
> connections.
> 
> The only other call site of lookup_reuseport() is in
> udp[46]_lookup_run_bpf(). We don't want to discard the reuseport
> selected socket if group has connections there either, so no changes are
> needed. And, now that I think about it, the current behavior in
> udp[46]_lookup_run_bpf() is not right.
> 
> The end result for udp4 will look like:
> 
> ---8<---
> static inline struct sock *lookup_reuseport(struct net *net, struct sock *sk,
> 					    struct sk_buff *skb,
> 					    __be32 saddr, __be16 sport,
> 					    __be32 daddr, unsigned short hnum)
> {
> 	struct sock *reuse_sk = NULL;
> 	u32 hash;
> 
> 	if (sk->sk_reuseport && sk->sk_state != TCP_ESTABLISHED) {
> 		hash = udp_ehashfn(net, daddr, hnum, saddr, sport);
> 		reuse_sk = reuseport_select_sock(sk, hash, skb,
> 						 sizeof(struct udphdr));
> 	}
> 	return reuse_sk;
> }
> 
> /* called with rcu_read_lock() */
> static struct sock *udp4_lib_lookup2(struct net *net,
> 				     __be32 saddr, __be16 sport,
> 				     __be32 daddr, unsigned int hnum,
> 				     int dif, int sdif,
> 				     struct udp_hslot *hslot2,
> 				     struct sk_buff *skb)
> {
> 	struct sock *sk, *result;
> 	int score, badness;
> 
> 	result = NULL;
> 	badness = 0;
> 	udp_portaddr_for_each_entry_rcu(sk, &hslot2->head) {
> 		score = compute_score(sk, net, saddr, sport,
> 				      daddr, hnum, dif, sdif);
> 		if (score > badness) {
> 			result = lookup_reuseport(net, sk, skb,
> 						  saddr, sport, daddr, hnum);
> 			if (result && !reuseport_has_conns(sk, false))
> 				return result;
> 			if (!result)
> 				result = sk;
> 			badness = score;
> 		}
> 	}
> 	return result;
> }
> ---8<---
> 
> I will submit a patch that pulls the reuseport_has_conns() check from
> lookup_reuseport() to bpf-next. That should bring the two sides of the
> merge closer. Please let me know if I can help in any other way.
> 
> Also, please take a look at the 3-way diff below from my attempt to
> merge net tree into bpf-next tree taking the described approach.
> 
> Thanks,
> -jkbs

Can I submit a patch to net tree that rewrites udp[46]_lib_lookup2() to
use only 'result' ?

Best Regards,
Kuniyuki
