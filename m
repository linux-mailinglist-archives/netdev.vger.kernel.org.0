Return-Path: <netdev+bounces-6503-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D5E3716B8F
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 19:49:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EFBE2280FC0
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 17:49:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39A7327730;
	Tue, 30 May 2023 17:49:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B9111EA76
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 17:49:31 +0000 (UTC)
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F0E3E5
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 10:49:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1685468968; x=1717004968;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eHigZOaNBns4j8vcUd6Ee6j31jcYvvAwOTeXGuMFGV8=;
  b=EW1XgzQYMd7zACX7ADpX+GhEkts6M89PROQpDNKdQOlfwILpGm/mAPrF
   dGtohKWsRyoBwNZ32RJkWuzhB2xhAZElKvA//dIH1gyleCIaG+nyXZx/K
   EMhTv3N0LjKAtPIE6tSVVcK+i4/U5f5KpOXRxZBEyfou6K+WUpBnd29oF
   E=;
X-IronPort-AV: E=Sophos;i="6.00,204,1681171200"; 
   d="scan'208";a="330274539"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-a893d89c.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2023 17:49:25 +0000
Received: from EX19MTAUWC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
	by email-inbound-relay-pdx-2b-m6i4x-a893d89c.us-west-2.amazon.com (Postfix) with ESMTPS id 83D3340D3E;
	Tue, 30 May 2023 17:49:21 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 30 May 2023 17:49:20 +0000
Received: from 88665a182662.ant.amazon.com.com (10.106.101.21) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 30 May 2023 17:49:17 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: <simon.horman@corigine.com>
CC: <davem@davemloft.net>, <dsahern@kernel.org>, <edumazet@google.com>,
	<kuba@kernel.org>, <kuni1840@gmail.com>, <kuniyu@amazon.com>,
	<netdev@vger.kernel.org>, <pabeni@redhat.com>,
	<willemdebruijn.kernel@gmail.com>
Subject: Re: [PATCH v1 net-next 02/14] udplite: Retire UDP-Lite for IPv6.
Date: Tue, 30 May 2023 10:49:08 -0700
Message-ID: <20230530174908.75206-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <ZHXzlz94VL+Y72PR@corigine.com>
References: <ZHXzlz94VL+Y72PR@corigine.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.106.101.21]
X-ClientProxiedBy: EX19D046UWB001.ant.amazon.com (10.13.139.187) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
Precedence: Bulk
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Simon Horman <simon.horman@corigine.com>
Date: Tue, 30 May 2023 15:01:11 +0200
> On Mon, May 29, 2023 at 06:03:36PM -0700, Kuniyuki Iwashima wrote:
> > We no longer support IPPROTO_UDPLITE for AF_INET6.
> > 
> > This commit removes udplite.c and udp_impl.h under net/ipv6 and makes
> > some functions static that UDP shared.
> > 
> > Note that udplite.h is included in udp.c temporarily not to introduce
> > breakage, but we will remove it later with dead code.
> > 
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> 
> ...
> 
> > diff --git a/net/ipv6/udp_impl.h b/net/ipv6/udp_impl.h
> > deleted file mode 100644
> > index 0590f566379d..000000000000
> > --- a/net/ipv6/udp_impl.h
> > +++ /dev/null
> > @@ -1,31 +0,0 @@
> > -/* SPDX-License-Identifier: GPL-2.0 */
> > -#ifndef _UDP6_IMPL_H
> > -#define _UDP6_IMPL_H
> > -#include <net/udp.h>
> > -#include <net/udplite.h>
> > -#include <net/protocol.h>
> > -#include <net/addrconf.h>
> > -#include <net/inet_common.h>
> > -#include <net/transp_v6.h>
> > -
> > -int __udp6_lib_rcv(struct sk_buff *, struct udp_table *, int);
> > -int __udp6_lib_err(struct sk_buff *, struct inet6_skb_parm *, u8, u8, int,
> > -		   __be32, struct udp_table *);
> > -
> > -int udpv6_init_sock(struct sock *sk);
> > -int udp_v6_get_port(struct sock *sk, unsigned short snum);
> > -void udp_v6_rehash(struct sock *sk);
> > -
> > -int udpv6_getsockopt(struct sock *sk, int level, int optname,
> > -		     char __user *optval, int __user *optlen);
> > -int udpv6_setsockopt(struct sock *sk, int level, int optname, sockptr_t optval,
> > -		     unsigned int optlen);
> > -int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len);
> > -int udpv6_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int flags,
> > -		  int *addr_len);
> 
> clang-16 with W=1 complains that:
> 
>  +net/ipv6/udp.c:341:5: warning: no previous prototype for 'udpv6_recvmsg' [-Wmissing-prototypes]
>  +  341 | int udpv6_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
>  +      |     ^~~~~~~~~~~~~
>  +net/ipv6/udp.c:1335:5: warning: no previous prototype for 'udpv6_sendmsg' [-Wmissing-prototypes]
>  + 1335 | int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
>  +      |     ^~~~~~~~~~~~~
> 
> Likewise it has similar complains about ipv4 in a subsequent patch.

Good catch!

This series survived allmodconfig and allyesconfig with gcc, but I
didn't add W=1.

Will fix it, thanks!


> 
> > -void udpv6_destroy_sock(struct sock *sk);
> > -
> > -#ifdef CONFIG_PROC_FS
> > -int udp6_seq_show(struct seq_file *seq, void *v);
> > -#endif
> > -#endif	/* _UDP6_IMPL_H */

