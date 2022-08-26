Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8863E5A2D76
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 19:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344234AbiHZR04 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 13:26:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344166AbiHZR0v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 13:26:51 -0400
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08528D83C4;
        Fri, 26 Aug 2022 10:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1661534810; x=1693070810;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+E3gZEVExD1z44FOK7JD6oLW988G9moQbbrKNkQ8AiE=;
  b=GV1eT9OjjHHkH6HZ31QeR4O06u44JSFmcM8AEeupynhxNCeVyE4g7Kll
   RQxGRb8LejDhU2nulfOPXautcSIwWz1d3nWRoFmsJCsoLM6zk/530L36P
   lnPevX/ewV/oDrAz52wwDJtuSvWQBbxftJ5G1cGsTs6N6v6mKLXFplp1R
   s=;
X-IronPort-AV: E=Sophos;i="5.93,265,1654560000"; 
   d="scan'208";a="237881398"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-5feb294a.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2022 17:26:37 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-5feb294a.us-west-2.amazon.com (Postfix) with ESMTPS id 3B8D3908F2;
        Fri, 26 Aug 2022 17:26:36 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Fri, 26 Aug 2022 17:26:35 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.121) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Fri, 26 Aug 2022 17:26:32 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <edumazet@google.com>
CC:     <chuck.lever@oracle.com>, <davem@davemloft.net>,
        <jlayton@kernel.org>, <keescook@chromium.org>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <kuniyu@amazon.com>,
        <linux-fsdevel@vger.kernel.org>, <mcgrof@kernel.org>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>, <yzaikin@google.com>
Subject: Re: [PATCH v1 net-next 06/13] tcp: Set NULL to sk->sk_prot->h.hashinfo.
Date:   Fri, 26 Aug 2022 10:26:23 -0700
Message-ID: <20220826172623.97832-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CANn89iK0FeokqWLPrWY8iger7iYXU5fJQyxaGbGecTe11+8p7A@mail.gmail.com>
References: <CANn89iK0FeokqWLPrWY8iger7iYXU5fJQyxaGbGecTe11+8p7A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.121]
X-ClientProxiedBy: EX13D39UWB002.ant.amazon.com (10.43.161.116) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 26 Aug 2022 08:40:49 -0700
> On Thu, Aug 25, 2022 at 5:07 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> >
> > We will soon introduce an optional per-netns ehash.
> >
> > This means we cannot use the global sk->sk_prot->h.hashinfo
> > to fetch a TCP hashinfo.
> >
> > Instead, set NULL to sk->sk_prot->h.hashinfo for TCP and get
> > a proper hashinfo from net->ipv4.tcp_death_row->hashinfo.
> >
> > Note that we need not use sk->sk_prot->h.hashinfo if DCCP is
> > disabled.
> >
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > ---
> >  include/net/inet_hashtables.h   | 10 ++++++++++
> >  net/ipv4/af_inet.c              |  2 +-
> >  net/ipv4/inet_connection_sock.c |  6 +++---
> >  net/ipv4/inet_hashtables.c      | 14 +++++++-------
> >  net/ipv4/tcp_ipv4.c             |  2 +-
> >  net/ipv6/tcp_ipv6.c             |  2 +-
> >  6 files changed, 23 insertions(+), 13 deletions(-)
> >
> > diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
> > index 44a419b9e3d5..2c866112433e 100644
> > --- a/include/net/inet_hashtables.h
> > +++ b/include/net/inet_hashtables.h
> > @@ -170,6 +170,16 @@ struct inet_hashinfo {
> >         struct inet_listen_hashbucket   *lhash2;
> >  };
> >
> > +static inline struct inet_hashinfo *inet_get_hashinfo(const struct sock *sk)
> > +{
> > +#if IS_ENABLED(CONFIG_IP_DCCP)
> > +       return sk->sk_prot->h.hashinfo ? :
> > +               sock_net(sk)->ipv4.tcp_death_row->hashinfo;
> > +#else
> > +       return sock_net(sk)->ipv4.tcp_death_row->hashinfo;
> > +#endif
> > +}
> >
> 
> If the sk_prot->h.hashinfo must disappear, I would rather add a new
> inet->hashinfo field
> 
> return inet_sk(sk)->hashinfo
> 
> Conceptually, the pointer no longer belongs to sk_prot, and not in struct net,
> otherwise you should name this helper   tcp_or_dccp_get_hashinfo() to avoid
> any temptation to use it for other inet protocol.

That makes sense.

To keep the series simple, I'll use tcp_or_dccp_get_hashinfo() in v2 and
post follow-up patch to add inet_sk(sk)->hashinfo, which needs a little
bit more work/test I think.

Thank you!
