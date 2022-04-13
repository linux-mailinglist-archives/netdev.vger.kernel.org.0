Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 852794FFFFC
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 22:28:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235917AbiDMUar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 16:30:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232705AbiDMUaq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 16:30:46 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6F8182D2F
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 13:28:23 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id x17so5558811lfa.10
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 13:28:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=stPKuc9/DjQLOg92Qty3+0zAk8yZJ1MXBf39gZf90jk=;
        b=e5K1tK1Pv9oAMx51KI2RetWYTyJxnpaLeHhPlg4V9kGUqX3Si/SCR9u3vD41kjVawl
         Yxx3x3VaOv9QeUxPK4mWXvySk30PUSI37BfZjDXB2m/De+7/ANtvwKpAZixIJmMJW41V
         oydG6qE1rkcb8CwPMVZxH9qGC+BNjyXt3en7/Dp6dgE0SphQxPSgMiNF0+gzXCDDR0zT
         mjeePZrQ0ZxYcD2u0nVVvaFvem7U3Q9wLhXZ8pRiBCpgeshiQaLbp1+YDgTvOBzKotzr
         YKqgHZQ+O7oh0/JKUQk51mHpQoOj55D310xhqSslQkoyB2wilaRvMAEErMQjKWg4BM04
         Za9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=stPKuc9/DjQLOg92Qty3+0zAk8yZJ1MXBf39gZf90jk=;
        b=kgS5Hex3Do1bIqWljkxNlb7FIMDpCis/8tgMv2NK8M5iat+ZywGjxraXJvPEJonv6r
         p3Nu/pL5+o3sXEhSdhvzFxv2DYhJvrQ1R/9iBBmikTqOo01Z3FPf8swTMkxGYGrSiPQH
         nrUE99bKnvtg2fkomgAMnLmwuTHqZPbiHDbJMWsp1FSP/ewS1BStWasWKxmTxniYvovp
         38ZYjwSAGy+n8j6CuydZE7pU6MGs/P1LnSdr1d/BdTSEeZZdaO3S4tohj1tNUqeGS4iM
         RJQSytg6c6Pd5Scha45EwU6PdOU28nqF9lGOitwKMvI3M6eVlP9fC8n7Pk0NoS1+MZx8
         He+Q==
X-Gm-Message-State: AOAM533an15SnHHIQwgOG0sgvU7193RoRP8KcunAmMFKrpJQE+K7mSpo
        evjLXA/IaARii1kLTMM5xhJ9pbuhTlrV0HaQUjl15w==
X-Google-Smtp-Source: ABdhPJxwNzx3ZyDgcngUeZJIoeL+K+TntmPU+xGBg7X0NzvYq8kAKNzsf5j+datrCZ43fmMtpVyipAYAn/kSYEJS0SQ=
X-Received: by 2002:a05:6512:12d5:b0:44a:9c24:9254 with SMTP id
 p21-20020a05651212d500b0044a9c249254mr28799899lfg.39.1649881701924; Wed, 13
 Apr 2022 13:28:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220403175544.26556-1-gerhard@engleder-embedded.com>
 <20220403175544.26556-5-gerhard@engleder-embedded.com> <20220410072930.GC212299@hoboy.vegasvil.org>
 <CANr-f5xhH31yF8UOmM=ktWULyUugBGDoHzOiYZggiDPZeTbdrw@mail.gmail.com>
 <20220410134215.GA258320@hoboy.vegasvil.org> <CANr-f5xriLzQ+3xtM+iV8ahu=J1mA7ixbc49f0i2jxkySthTdQ@mail.gmail.com>
 <CANr-f5yn9LzMQ8yAP8Py-EP_NyifFyj1uXBNo+kuGY1p8t0CFw@mail.gmail.com> <87sfqiypvl.fsf@intel.com>
In-Reply-To: <87sfqiypvl.fsf@intel.com>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
Date:   Wed, 13 Apr 2022 22:28:10 +0200
Message-ID: <CANr-f5zrUikbE6N5zYcHYFL=R_tkqP63P2VybHbtqr9m8=08fA@mail.gmail.com>
Subject: Re: [PATCH net-next v2 4/5] ptp: Support late timestamp determination
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     Richard Cochran <richardcochran@gmail.com>, yangbo.lu@nxp.com,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mlichvar@redhat.com,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >> > > > > @@ -887,18 +885,28 @@ void __sock_recv_timestamp(struct msghdr *msg, struct sock *sk,
> >> > > > >       if (shhwtstamps &&
> >> > > > >           (sk->sk_tsflags & SOF_TIMESTAMPING_RAW_HARDWARE) &&
> >> > > > >           !skb_is_swtx_tstamp(skb, false_tstamp)) {
> >> > > > > +             rcu_read_lock();
> >> > > > > +             orig_dev = dev_get_by_napi_id(skb_napi_id(skb));
> >> > > >
> >> > > > __sock_recv_timestamp() is hot path.
> >> > > >
> >> > > > No need to call dev_get_by_napi_id() for the vast majority of cases
> >> > > > using plain old MAC time stamping.
> >> > >
> >> > > Isn't dev_get_by_napi_id() called most of the time anyway in put_ts_pktinfo()?
> >> >
> >> > No.  Only when SOF_TIMESTAMPING_OPT_PKTINFO is requested.
> >>
> >> You are right, my fault.
> >>
> >> > > That's the reason for the removal of a separate flag, which signals the need to
> >> > > timestamp determination based on address/cookie. I thought there is no need
> >> > > for that flag, as netdev is already available later in the existing code.
> >> > >
> >> > > > Make this conditional on (sk->sk_tsflags & SOF_TIMESTAMPING_BIND_PHC).
> >> > >
> >> > > This flag tells netdev_get_tstamp() which timestamp is required. If it
> >> > > is not set, then
> >> > > netdev_get_tstamp() has to deliver the normal timestamp as always. But
> >> > > this normal
> >> > > timestamp is only available via address/cookie. So netdev_get_tstamp() must be
> >> > > called.
> >> >
> >> > It should be this:
> >> >
> >> > - normal, non-vclock:   use hwtstamps->hwtstamp directly
> >> > - vclock:               use slower path with lookup
> >> >
> >> > I don't see why you can't implement that.
> >>
> >> I will try to implement it that way.
> >
> > I'm thinking about why there should be a slow path with lookup. If the
> > address/cookie
> > points to a defined data structure with two timestamps, then no lookup
> > for the phc or
> > netdev is necessary. It should be possible for every driver to
> > allocate a skbuff with enough
> > space for this structure
On Tue, Apr 12, 2022 at 11:05 PM Vinicius Costa Gomes
<vinicius.gomes@intel.com> wrote:
>
> Gerhard Engleder <gerhard@engleder-embedded.com> writes:
> in front of the received Ethernet frame. The
> > structure could be:
> >
> > struct skb_inline_hwtstamps {
> >         ktime_t hwtstamp;
> >         ktime_t hwcstamp;
> > };
> >
> > Actually my device and igc are storing the timestamps in front of the
> > received Ethernet
> > frame. In my opinion it is obvious to the store metadata of received
> > Ethernet frames in
> > front of it, because it eliminates the need for another DMA transfer.
> > What is your opinion
> > Vinicius?
>
> If I am understanding this right, the idea is providing both "cycles"
> (free running cycles measurement) and PHC timestamp for all packets, for
> igc, it will work fine for RX (the HW already writes the timestamps for
> two timer registers in the host memory), but for TX it's going be
> awkward/slow (I would have to read two extra registers), but I think
> it's still possible.
>
> But it would be best to avoid the overhead, and only providing the
> "extra" (the cycles one) measurement if necessary for TX, so
> SKBTX_HW_TSTAMP_USE_CYCLES would still be needed.
>
> So, in short, I am fine with it, as long as I can get away with only
> providing the cycles measurement for TX if necessary.

Of course for TX only cycles measurement shall be provided and
SKBTX_HW_TSTAMP_USE_CYCLES is used for that.

Thanks!

Gerhard
