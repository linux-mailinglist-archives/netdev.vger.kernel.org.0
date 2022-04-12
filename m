Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3DE94FE892
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 21:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352457AbiDLT0n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 15:26:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352481AbiDLT0l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 15:26:41 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97F18DEE1
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 12:24:21 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id g21so23391633iom.13
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 12:24:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DuzpI5+gI4QC2zZ90kKkEZpjGpL7sKT9sDW/X8onmRQ=;
        b=KvIvjqcFvT4ZmyI5eGhn1kT78KyKXTfOQbAJGm6U8lcMVgaOzigOhGrmb1aYoh7Zdo
         kiCg7ueZFhMmjjL1YFZ6eFC0xfe5Z0ih4/D2+lKRQ67njqhNfj+OQ0MZ6396brVuv5U/
         O5WCWypcPhYlTssl5Xo5sYQI5Y8iJx4pqcgpB2Rd9IoY2yWzy4GRv5YgAyk9Fpf2Oikm
         Jxl6QpBv0J3gXiFZRTHegNo0Pz7aARukuzom2M3rxvvwluUUSYkl3S+TxLwWPXfMkyK1
         HGM/qgzeVTIDQqmVIjNlVuGHo30WATTJvEMQbmXvBKLewJ1bnSTd9tZZmVOMDLpGnfbP
         b9uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DuzpI5+gI4QC2zZ90kKkEZpjGpL7sKT9sDW/X8onmRQ=;
        b=JBbIUjxD0P87F26ZpFcUEbKxJtfLpAOBNRPMkmm9I7c544NtJK1EvFLhhgLfWaVqqz
         IJAKpBu/qhmvROhkeeMF9rQ+zklxxFBKirjl39C2wx6OPEevhELYzlYEs3nYQ89YSCxQ
         xlHEC6sqL3hZPjNnflqBW9YcgQC2NeM2G7kz0Nyu5VC7Y5/bPxrQyAP7x2XPTJ9z8Y/m
         d6Sik3AOq8jihbhaZrvM9Bt2cl48GRgDGyYDv8XsaNQBdD0A0gaqjjxDUDjgxcEdpkqz
         YLc0d5Udv8CXsUEmiNPntJY0li6w4HW+4LJtYqLH1/lubj1QTp+0HRSYKAU0IwgZd85h
         T8zw==
X-Gm-Message-State: AOAM532hL9LFcnKYEjw03If7o++ZiOlpXfkJ6Hj4x82CngOPYO/ERWNx
        w2e28jhv9eSqBCe/UKbv9HYJATaH7ELmScrnI97Wkg==
X-Google-Smtp-Source: ABdhPJxV4JmhqRLRKgB2bxvSpoX67aPLQwGPkaS77X58HeitGMhu3sPJ2SFBztUG+d6mMFjk/rvXADTgeb1Qg5tpnKo=
X-Received: by 2002:a05:6638:1654:b0:323:bcf1:193a with SMTP id
 a20-20020a056638165400b00323bcf1193amr19538168jat.115.1649791461012; Tue, 12
 Apr 2022 12:24:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220403175544.26556-1-gerhard@engleder-embedded.com>
 <20220403175544.26556-5-gerhard@engleder-embedded.com> <20220410072930.GC212299@hoboy.vegasvil.org>
 <CANr-f5xhH31yF8UOmM=ktWULyUugBGDoHzOiYZggiDPZeTbdrw@mail.gmail.com>
 <20220410134215.GA258320@hoboy.vegasvil.org> <CANr-f5xriLzQ+3xtM+iV8ahu=J1mA7ixbc49f0i2jxkySthTdQ@mail.gmail.com>
In-Reply-To: <CANr-f5xriLzQ+3xtM+iV8ahu=J1mA7ixbc49f0i2jxkySthTdQ@mail.gmail.com>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
Date:   Tue, 12 Apr 2022 21:24:10 +0200
Message-ID: <CANr-f5yn9LzMQ8yAP8Py-EP_NyifFyj1uXBNo+kuGY1p8t0CFw@mail.gmail.com>
Subject: Re: [PATCH net-next v2 4/5] ptp: Support late timestamp determination
To:     Richard Cochran <richardcochran@gmail.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     yangbo.lu@nxp.com, David Miller <davem@davemloft.net>,
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

> > > > > @@ -887,18 +885,28 @@ void __sock_recv_timestamp(struct msghdr *msg, struct sock *sk,
> > > > >       if (shhwtstamps &&
> > > > >           (sk->sk_tsflags & SOF_TIMESTAMPING_RAW_HARDWARE) &&
> > > > >           !skb_is_swtx_tstamp(skb, false_tstamp)) {
> > > > > +             rcu_read_lock();
> > > > > +             orig_dev = dev_get_by_napi_id(skb_napi_id(skb));
> > > >
> > > > __sock_recv_timestamp() is hot path.
> > > >
> > > > No need to call dev_get_by_napi_id() for the vast majority of cases
> > > > using plain old MAC time stamping.
> > >
> > > Isn't dev_get_by_napi_id() called most of the time anyway in put_ts_pktinfo()?
> >
> > No.  Only when SOF_TIMESTAMPING_OPT_PKTINFO is requested.
>
> You are right, my fault.
>
> > > That's the reason for the removal of a separate flag, which signals the need to
> > > timestamp determination based on address/cookie. I thought there is no need
> > > for that flag, as netdev is already available later in the existing code.
> > >
> > > > Make this conditional on (sk->sk_tsflags & SOF_TIMESTAMPING_BIND_PHC).
> > >
> > > This flag tells netdev_get_tstamp() which timestamp is required. If it
> > > is not set, then
> > > netdev_get_tstamp() has to deliver the normal timestamp as always. But
> > > this normal
> > > timestamp is only available via address/cookie. So netdev_get_tstamp() must be
> > > called.
> >
> > It should be this:
> >
> > - normal, non-vclock:   use hwtstamps->hwtstamp directly
> > - vclock:               use slower path with lookup
> >
> > I don't see why you can't implement that.
>
> I will try to implement it that way.

I'm thinking about why there should be a slow path with lookup. If the
address/cookie
points to a defined data structure with two timestamps, then no lookup
for the phc or
netdev is necessary. It should be possible for every driver to
allocate a skbuff with enough
space for this structure in front of the received Ethernet frame. The
structure could be:

struct skb_inline_hwtstamps {
        ktime_t hwtstamp;
        ktime_t hwcstamp;
};

Actually my device and igc are storing the timestamps in front of the
received Ethernet
frame. In my opinion it is obvious to the store metadata of received
Ethernet frames in
front of it, because it eliminates the need for another DMA transfer.
What is your opinion
Vinicius?

Gerhard
