Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C209679E57
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 17:14:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232827AbjAXQOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 11:14:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbjAXQOb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 11:14:31 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6234745893
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 08:14:30 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id 188so19445808ybi.9
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 08:14:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jgVXq8PSTlTtBOCQ8INpzeYA/px5mpH31Ld+KapWcr0=;
        b=UWgLoE/O4yjgLKj9JK5mJuoacpu7804khse7zBbA7r2BCSjZPVkaIKFYhBRcDnT8xI
         vz29aykz8t0y8sgsFfIzL6SwNR0VVGrMw/wQ2grdJ6pJmZNla4b0C3mJUk4+6uQUQGKo
         lQ9KYZt0FwJ1JX0rO73EXfgBVuGMLfQDMyrdx7Lsyov5gRdwIe35K/d09yNI7exKNNQR
         ecY6x6rUbaEdqdTJxpeH1Lwk39A0ZCjA2jqf2QVlGQMvgeWjB4+IW3t4bCPRTFl0YX2v
         YCVxybbg70Oyq25IALmlkxTMwZjhFLm3NQl8Q5U5rzAywOQF3Heq/zKJ836EBxovXQc9
         ZpNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jgVXq8PSTlTtBOCQ8INpzeYA/px5mpH31Ld+KapWcr0=;
        b=AGDnB4wFVfia+BP18mvLtI2vDIzbTJ50FenFNvIUHhPASWtlFugwjzWRzHD5gmovWd
         jXqVDmoBDuJ0S/wdez1edvVcCLdIPVbLwbGuqK4OMF0uRaYdYOth1ljLZCxw+awRWroY
         ENYfjdn5FE4+QfThFT0LiLafn9j/sBsKSCSJs0kKAFd7tz7kiPqhjDAG7kPbSBoQXC4V
         j15y1R4IbQ82qUjVz5mrP9v+PFClPjRJuvfGec/UQOLIoqY06MlNdTQaDvCD5S/vBBqg
         tLFkZxuRdWsnMoxjMiN6OtqbKeZ1Xx+Yz+XrV2pR4FwOC0F4qYD6M3c9dwIP9OJAjiHU
         XILA==
X-Gm-Message-State: AFqh2krSYjxJICsOZoWZQhmZ17SjMLmqQIEE254vZKwl6zaernUfCoZS
        nRFqdnvWBROYYBoPNC611R85ScYFEA9TYXfMkNmuPg==
X-Google-Smtp-Source: AMrXdXtJhOaI8qesEHVg8kOnYiY9/0ZVlNvuvf2rCpkqOiFJ2U/HBEJ74HPKrs+vaY0KCW1l07at1glZkXSOv8rM6w8=
X-Received: by 2002:a25:fd4:0:b0:803:fbad:94a4 with SMTP id
 203-20020a250fd4000000b00803fbad94a4mr1504887ybp.407.1674576869163; Tue, 24
 Jan 2023 08:14:29 -0800 (PST)
MIME-Version: 1.0
References: <f171a249-1529-4095-c631-f9f54d996b90@gmail.com>
 <CANn89iK1aPiystTAk2qTnzsN-LFskJ4BxL=XgTk2aLpExrWFEw@mail.gmail.com>
 <eaab7495-53d5-0026-842c-acb420408cd0@gmail.com> <CANn89iLQeHsf9=ZqUvU0Y_CVsHbzvd07sdFfOH-poFmGqtn0cA@mail.gmail.com>
 <168aa9cf-d80a-9c1b-887f-97015a0473dc@gmail.com> <CANn89iK7nn6tdQg9QZO_Gudx1BvLxhoLaNYmnOLb6ccYQnLGwg@mail.gmail.com>
 <b2ecff1c-91ad-4217-7fd5-d7bbd5704abe@gmail.com> <CANn89iLV3NDiEA4tPWUxjqoHNx1pv=SEpXd1b38NXU=TK13=tg@mail.gmail.com>
 <CANn89iLKQB=9rYyKXVH=hd2aBUjzhhjXA0FOdSvN3reH+k9cMQ@mail.gmail.com> <71a0050a-2656-1d5b-0302-65000cf854cb@gmail.com>
In-Reply-To: <71a0050a-2656-1d5b-0302-65000cf854cb@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 24 Jan 2023 17:14:17 +0100
Message-ID: <CANn89iKxoJEGf+renKFXO+vajyJTKvBu1zaTiuFhKhDwcMny-g@mail.gmail.com>
Subject: Re: traceroute failure in kernel 6.1 and 6.2
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     =?UTF-8?Q?Mantas_Mikul=C4=97nas?= <grawity@gmail.com>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 24, 2023 at 4:28 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> On 1/24/23 08:57, Eric Dumazet wrote:
> > On Tue, Jan 24, 2023 at 7:03 AM Eric Dumazet <edumazet@google.com> wrote:
> [...]
> >>> It doesn't solve the issue; I tried bumping it from the default of
> >>> 212992 to 4096-times-that, with exactly the same results.
> >>>
> >>> The amount of packets it's able to send is variable, For example, right
> >>> now, on my regular VM (which is smaller than the PC that yesterday's
> >>> trace was done on), the program very consistently fails on the *second*
> >>> sendto() call -- I don't think two packets is an unreasonable amount.
> >>>
> >>> The program has -q and -N options to reduce the number of simultaneous
> >>> probes, but the only effect it has is if I reduce the packets all the
> >>> way down to just one at a time.
> >>
> >> Problem is : if we revert the patch, unpriv users can trivially crash a host.
> >>
> >> Also, sent ICMP packets  look just fine to me, and the patch is
> >> changing tx path.
> >>
> >> The reported issue seems more like rx path related to me.
> >> Like IP_RECVERR being not handled correctly.
> >>
> >> I think more investigations are needed. Maybe contact Pavel Begunkov
> >> <asml.silence@gmail.com>
> >> because the initial crash issue came with
> >> 47cf88993c91 ("net: unify alloclen calculation for paged requests")
> >
> > I am reasonably confident this is a bug in this traceroute binary.
> >
> > It sets
> >   setsockopt(3, SOL_IP, IP_RECVERR, [1], 4) = 0
> >
> > So a sendto() can absolutely return the error set by last received
> > ICMP (cf ping_err()) on the socket,
> > as per RFC1122 4.1.3.3
> >
> >   4.1.3.3  ICMP Messages
> >
> >              UDP MUST pass to the application layer all ICMP error
> >              messages that it receives from the IP layer.  Conceptually
> >              at least, this may be accomplished with an upcall to the
> >              ERROR_REPORT routine (see Section 4.2.4.1).
> >
> >              DISCUSSION:
> >                   Note that ICMP error messages resulting from sending a
> >                   UDP datagram are received asynchronously.  A UDP-based
> >                   application that wants to receive ICMP error messages
> >                   is responsible for maintaining the state necessary to
> >                   demultiplex these messages when they arrive; for
> >                   example, the application may keep a pending receive
> >                   operation for this purpose.  The application is also
> >                   responsible to avoid confusion from a delayed ICMP
> >                   error message resulting from an earlier use of the same
> >
> >
> > Fix would be
> >
> > diff traceroute/traceroute.c.orig traceroute/traceroute.c
> > 1657c1657
> > <     if (errno == EMSGSIZE)
> > ---
> >>      if (errno == EMSGSIZE || errno == EHOSTUNREACH)
> >
> > or to collect a pending socket error (but that would be racy), using
> > SO_ERROR getsockopt()
>
> If it doesn't help I'll take a look, perfectly reproducible for me.
>

My fix has the following consequence:

Instead of pretending ICMP packet has no 'transhdrlen',
it now calls sock_alloc_send_skb() (instead of alloc_skb()),
and thus is able to sleep/schedule (unless application
provides MSG_DONTWAIT), and is also
sensible to a prior setting of sk->sk_err (from ping_err())

This was probably not an intended behavior of initial
ping implementation (which was ignoring sk->sk_err until a recvmsg() or poll())

__ip_append_data()

if (transhdrlen) {
    skb = sock_alloc_send_skb(sk, alloclen,
                       (flags & MSG_DONTWAIT), &err);
} else {
     skb = NULL;
     if (refcount_read(&sk->sk_wmem_alloc) + wmem_alloc_delta <=
                      2 * sk->sk_sndbuf)
                 skb = alloc_skb(alloclen,
                                          sk->sk_allocation);
                   if (unlikely(!skb))
                       err = -ENOBUFS;
}
if (!skb)
           goto error;

The intent for this code is to sleep/schedule only for the first skb,
and uses alloc_skb() for the following skbs, to increase chance
of not breaking the generation of the datagram in the middle.

Downside is that ICMP now reacts like UDP, thus the application
must correctly handle the sendmsg() returning the stored sk->sk_err.

Note 1: ipv6 ping implementation forces a MSG_DONTWAIT
while calling ip6_append_data(), for no apparent reason.

Note 2:
 It seems strange that both udp_err() and ping_err()
 call ip_icmp_error() when a matching socket is found (and used IP_RECVERR)
 _and_ also set sk->sk_err

 Perhaps ip_icmp_error() should return a bool and
 we should not set sk->sk_err if a proper error skb has been
 queued to sk->sk_error_queue
