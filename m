Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2F2E627ADF
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 11:46:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236111AbiKNKqJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 05:46:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235997AbiKNKqI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 05:46:08 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 357172BD
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 02:46:07 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id bs21so17396375wrb.4
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 02:46:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U5IGLnjmTVG8rRtvQR/v8l6lnh1x9lhCX7lwftre/vE=;
        b=AYk8+w7AK6ujg4WwIA30ZzKayW6dH25U/V3nxQiFACjWCZ1kXof1NVrXs3ecSj/tMA
         yKj/zQBAYcgV8FrDld3XgqGn22LoL1LMaP7ngMq9WhCjmXNiLU6bApCrlBSunZrKkx6k
         7PIZS3grg5Uwltw3g7u08zlIsZ00N95GWquCI7yjNE6sq5B/h2nBxf7NNQes7tr9sVnK
         eISKPck7jH21S+FtgwTqnGFGAHqPdS715O81AO7msXJBVLmfP82nKPVa/LVyyjR/O0+K
         QgFQgifXQkHvmvtlai+xgo97egu9ph8bwX1xKBFW/Jae6vZdZ5xfUzmRlMwq6hMshQVS
         xCJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U5IGLnjmTVG8rRtvQR/v8l6lnh1x9lhCX7lwftre/vE=;
        b=mNYrS/KlrgvhK5JFREkkiLwbiUUA/pnPYIdKkIYKZ/BWkb+GNpLOIGAdWsurPBVVXc
         xbOm+EgtzKfpWUjXzN3qqXS+w5Xrp751uqwVqMRxpkyHEt9u9xVfcRC9JP9vZHyStQxU
         5umADBCliplqvStzA782MsKK2Qag0UVJooXKH0q3Irsjad0NhNMfTXbKtNsr3YyPcXqB
         dScXv7VaUJv4RhCjbtn/wvGnafzIKpG625SYfmvyS4dUgyJPPLw3Zl1FZ/n6XK+beOOL
         /hZ3rIXv+g83amAKDmNrTZ96a0Hz6JI5KzeNhyWFFz6nSTUXmKp1hdrrdbbZ0Fm20qWm
         0kQA==
X-Gm-Message-State: ANoB5plLVyE/leedBre/3GanUEgMT0VbFBPryopdrl6FT4j44qUxPUdn
        IV2LO/IqwqRY4Arl9HdpikL0x+4FTjfhWAvBwo0=
X-Google-Smtp-Source: AA0mqf6tGR1fRv31D0SBRlLx/GDlVF6IsOhkmdIWlJf1mwg/Jl3HCPdiDv7mzOdinASOVlqqgGUXwAZ1qDZyZ1mIsz8=
X-Received: by 2002:adf:ce88:0:b0:23a:ce24:1bf0 with SMTP id
 r8-20020adfce88000000b0023ace241bf0mr6934672wrn.383.1668422765629; Mon, 14
 Nov 2022 02:46:05 -0800 (PST)
MIME-Version: 1.0
References: <20221109180249.4721-1-dnlplm@gmail.com> <20221109180249.4721-2-dnlplm@gmail.com>
 <20221111090720.278326d1@kernel.org> <8b0aba42-627a-f5f5-a9ec-237b69b3b03f@nvidia.com>
 <CAGRyCJF49NMTt9aqPhF_Yp5T3cof_GtL7+v8PeowsBQWG0bkJQ@mail.gmail.com>
In-Reply-To: <CAGRyCJF49NMTt9aqPhF_Yp5T3cof_GtL7+v8PeowsBQWG0bkJQ@mail.gmail.com>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Mon, 14 Nov 2022 02:45:53 -0800
Message-ID: <CAA93jw4OAWRAg+BxftuMgFaHex+BAeV3bS5JUYU7_+pM8ZOaEA@mail.gmail.com>
Subject: Re: [PATCH net-next 1/3] ethtool: add tx aggregation parameters
To:     Daniele Palmas <dnlplm@gmail.com>
Cc:     Gal Pressman <gal@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 14, 2022 at 2:31 AM Daniele Palmas <dnlplm@gmail.com> wrote:
>
> Hello Gal,
>
> Il giorno dom 13 nov 2022 alle ore 10:48 Gal Pressman <gal@nvidia.com>
> ha scritto:
> >
> > On 11/11/2022 19:07, Jakub Kicinski wrote:
> > > On Wed,  9 Nov 2022 19:02:47 +0100 Daniele Palmas wrote:
> > >> Add the following ethtool tx aggregation parameters:
> > >>
> > >> ETHTOOL_A_COALESCE_TX_MAX_AGGR_SIZE
> > >> Maximum size of an aggregated block of frames in tx.
> > > perhaps s/size/bytes/ ? Or just mention bytes in the doc? I think it'=
s
> > > the first argument in coalescing expressed in bytes, so to avoid
> > > confusion we should state that clearly.
> > >
> > >> ETHTOOL_A_COALESCE_TX_MAX_AGGR_FRAMES
> > >> Maximum number of frames that can be aggregated into a block.
> > >>
> > >> ETHTOOL_A_COALESCE_TX_USECS_AGGR_TIME
> > >> Time in usecs after the first packet arrival in an aggregated
> > >> block for the block to be sent.
> > > Can we add this info to the ethtool-netlink.rst doc?
> > >
> > > Can we also add a couple of sentences describing what aggregation is?
> > > Something about copying the packets into a contiguous buffer to submi=
t
> > > as one large IO operation, usually found on USB adapters?
> > >
> > > People with very different device needs will read this and may patter=
n
> > > match the parameters to something completely different like just
> > > delaying ringing the doorbell. So even if things seem obvious they ar=
e
> > > worth documenting.
> >
> > Seems like I am these people, I was under the impression this is kind o=
f
> > a threshold for xmit more or something?
> > What is this contiguous buffer?
>
> I would like to explain the issue I'm trying to solve.
>
> I'm using an USB modem that is driven by qmi_wwan which creates a
> netdevice: on top of this the rmnet module creates another netdevice,
> needed since packets sent to the modem needs to follow the qmap
> protocol both for multiplexing and performance.
>
> Without tx packets aggregation each tx packet sent to the rmnet
> netdevice makes an URB to be sent through qmi_wwan/usbnet, so that
> there is a 1:1 relation between a qmap packet and an URB.
>
> So far, this has not been an issue, but I've run into a family of
> modems for which this behavior does not work well, preventing the
> modem from reaching the maximum throughput both in rx and tx (an
> example of the issue is described at
> https://lore.kernel.org/netdev/CAGRyCJEkTHpLVsD9zTzSQp8d98SBM24nyqq-HA0jb=
vHUre+C4g@mail.gmail.com/
> )
>
> Tx packets aggregation allows to overcome this issue, so that a single
> URB holds N qmap packets, reducing URBs frequency.

While I understand the use case... it's generally been my hope we got
to a BQL-like mechanism for
4G and 5G that keeps the latency under control. Right now, that can be
really, really, really miserable -
measured in *seconds* - and adding in packet aggregation naively is
what messed up Wifi for the
past decade. Please lose 8 minutes of your life to this (hilarious)
explanation of why aggregation can be bad.

https://www.youtube.com/watch?v=3DRb-UnHDw02o&t=3D1560s

So given a choice between being able to drive the modem at the maximum
rate in a testbed...
or having it behave well at all possible (and highly variable) egress
rates, I would so love for more to focus on the latter problem than
the former, at whatever levels and layers in the stack it takes.

As a test, what happens on the flent "rrul" test, before and after
this patch? Under good wireless conditions, and bad?

flent -H server -t my-test-conditions -x --socket-stats rrul
flent -H server -t my-test-conditions -x --socket-stats
--test-parameter=3Dupload_streams=3D4 tcp_nup

I have servers for that all over the world
{de,london,fremont,dallas,singapore,toronto,}.starlink.taht.net

> The maximum number of allowed packets in a single URB and the maximum
> size of the URB are dictated by the modem through the qmi control
> protocol: the values returned by the modem are then configured in the
> driver with the new ethtool parameters.
>
> > Isn't this the same as TX copybreak? TX
> > copybreak for multiple packets?
>
> I tried looking at how tx copybreak works to understand your comment,
> but I could not find any useful document. Probably my fault, but can
> you please point me to something I can read?
>
> Thanks,
> Daniele



--=20
This song goes out to all the folk that thought Stadia would work:
https://www.linkedin.com/posts/dtaht_the-mushroom-song-activity-69813666656=
07352320-FXtz
Dave T=C3=A4ht CEO, TekLibre, LLC
