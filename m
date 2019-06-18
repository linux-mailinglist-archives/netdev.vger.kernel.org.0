Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7212497BD
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 05:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728058AbfFRDUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 23:20:10 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:42767 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbfFRDUK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 23:20:10 -0400
Received: by mail-pf1-f194.google.com with SMTP id q10so6770186pff.9
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 20:20:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C1Jk93XJ83NAuFApWwnZFah6NEoqsyIjEs142h2g6FM=;
        b=muEi0+mHyMVAgk6X8ScyEbw6U9NohJRR1xlS7kqTUOBKpqNbH6lppDLXSjTAvUKVF+
         0eTsr84vizNHIRXrslRjVoKJeOmBbAVQbhdtftTiIbQ3Ig8leK+3r0Aa54yA0hLb8Nsu
         9XYhX3nC0qNAEd4s9t8qflHzF1SRHVPRQqVqDC5GZdWXOKJLkzdBazXwMvMxrUpP3Q3O
         4fKzsNWST0W9NETzpZbsgy6z5dAewRn5dsG9JtJo4CVG5+gnoPrfh8qReL9odFuRJOV+
         TWvgbkTYEzmOSth7VPyH/ND+CYNxmlftSSY0B+uS6qG7RQiynCJN5oO4kbJd3/u3nFjS
         Uegw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C1Jk93XJ83NAuFApWwnZFah6NEoqsyIjEs142h2g6FM=;
        b=MTCg67MgjcYL0XZ1TToXGjixQUo5tNomQAClfwgs0APjzsFmJ3tbw9ldG2zVWKiMmf
         eoVRTYCSpbv21jGh47FlDot86u4VOVBcMl2UgYBHjtePmF/Yds07OsJfJ+SNi1cR9EC+
         hQoFYCYNToL0ddyJGvhMtNylAROHS0OvePK1uU26tEW7De3N12ZJZHedS5Bxj1FhOFA3
         JRqhKafQD8Nv6ZVBXWysKHrKrHZGtCzfaqKOWGzVCpJn/fayLsB5ECRYciNOlQYCx0mr
         r7407nw20q++BHsa/BVZyx0hmetLZhTMvHlrfT8tZXhyZZT8TquetG5tlqJOt/0BV8EM
         j5vQ==
X-Gm-Message-State: APjAAAXPZZ8IMS+1GBiHXGoief/mP3ukJ+Ho5qgEtAyZhu65x+9Y9dTe
        g/Pbq/eH1WE+e7MhcmEs0vgzibx3dz3ZM8BdwM4=
X-Google-Smtp-Source: APXvYqwr5AggzGKsuO6dVyqsTWfy1DjJIOClqFJd38GYJV9ANIfnf3y8nAcp29k5HVHLrT2BVSVRuasVx4FmCG2jRMM=
X-Received: by 2002:a62:4dc5:: with SMTP id a188mr119154513pfb.8.1560828009911;
 Mon, 17 Jun 2019 20:20:09 -0700 (PDT)
MIME-Version: 1.0
References: <20190617170354.37770-1-edumazet@google.com> <20190617170354.37770-3-edumazet@google.com>
 <CALMXkpYVRxgeqarp4gnmX7GqYh1sWOAt6UaRFqYBOaaNFfZ5sw@mail.gmail.com> <03cbcfdf-58a4-dbca-45b1-8b17f229fa1d@gmail.com>
In-Reply-To: <03cbcfdf-58a4-dbca-45b1-8b17f229fa1d@gmail.com>
From:   Christoph Paasch <christoph.paasch@gmail.com>
Date:   Mon, 17 Jun 2019 20:19:58 -0700
Message-ID: <CALMXkpZ4isoXpFp_5=nVUcWrt5TofYVhpdAjv7LkCH7RFW1tYw@mail.gmail.com>
Subject: Re: [PATCH net 2/4] tcp: tcp_fragment() should apply sane memory limits
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Looney <jtl@netflix.com>,
        Neal Cardwell <ncardwell@google.com>,
        Tyler Hicks <tyhicks@canonical.com>,
        Yuchung Cheng <ycheng@google.com>,
        Bruce Curtis <brucec@netflix.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Dustin Marquess <dmarquess@apple.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 17, 2019 at 7:28 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 6/17/19 5:18 PM, Christoph Paasch wrote:
> >
> > Hi Eric, I now have a packetdrill test that started failing (see
> > below). Admittedly, a bit weird test with the SO_SNDBUF forced so low.
> >
> > Nevertheless, previously this test would pass, now it stalls after the
> > write() because tcp_fragment() returns -ENOMEM. Your commit-message
> > mentions that this could trigger when one sets SO_SNDBUF low. But,
> > here we have a complete stall of the connection and we never recover.
> >
> > I don't know if we care about this, but there it is :-)
>
> I guess it is WAI :)
>
> Honestly I am not sure we want to add code just to allow these degenerated use cases.
>
> Upstream kernels could check if rtx queue is empty or not, but this check will be not trivial to backport
>
>
> Can you test :

Yes, this does the trick for my packetdrill-test.

I wonder, is there a way we could end up in a situation where we can't
retransmit anymore?
For example, sk_wmem_queued has grown so much that the new test fails.
Then, if we legitimately need to fragment in __tcp_retransmit_skb() we
won't be able to do so. So we will never retransmit. And if no ACK
comes back in to make some room we are stuck, no?


Christoph



>
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index 00c01a01b547ec67c971dc25a74c9258563cf871..06576540133806222f43d4a9532c5a929a2965b0 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -1296,7 +1296,8 @@ int tcp_fragment(struct sock *sk, enum tcp_queue tcp_queue,
>         if (nsize < 0)
>                 nsize = 0;
>
> -       if (unlikely((sk->sk_wmem_queued >> 1) > sk->sk_sndbuf)) {
> +       if (unlikely((sk->sk_wmem_queued >> 1) > sk->sk_sndbuf &&
> +                    !tcp_rtx_queue_empty(sk))) {
>                 NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPWQUEUETOOBIG);
>                 return -ENOMEM;
>         }
