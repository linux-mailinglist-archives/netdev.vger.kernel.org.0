Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE46755E8A9
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347638AbiF1PSm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 11:18:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345505AbiF1PSl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 11:18:41 -0400
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5140E2EA26
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 08:18:39 -0700 (PDT)
Received: by mail-vs1-xe35.google.com with SMTP id e7so12290832vsp.13
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 08:18:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=aX5ivbwdPU9u03LmDr9z3jgqVDJZa5Fvxm0NFdvgP3s=;
        b=FkpER6OrRNDt5yUsWpWhpz1frPyKxSmP6HvK62OBH+0XnFUnUScQMDmNwIXe2jytZj
         0XYwA2MIHLX2ldjiUvEpqf9HRwpma33REq6W5GMJa5x465riJhkgUjR0KrTLgynmNUHa
         tQ/jjSgp1GHk3jXblNytqMKjTdAcmrvXFVWrxltp7AJ5LWWUD8grFE3kbuHYFhT+nxOf
         KHWMDik6zYGzAjjfVleRrifXBEATjcpjwe4rezmqfHtxIMfy6zj3j3LS0ezOyyb6PiLZ
         ys1gohf8fxn3UgySJpWmXv2kaOt+kD04h/7aISuE7AgSRbr+TKHYh7zrT1S44q8PfY+7
         PCEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=aX5ivbwdPU9u03LmDr9z3jgqVDJZa5Fvxm0NFdvgP3s=;
        b=wzt3rlImBXHqAkm30jIs4h97Sb9QZqF43Mf2R+LonyLBP7rHlrnuDDoRBnCMtqZGbD
         UxgDhtqXkzRSBQlBZ8kiTtcd3mbKa90lV7XN5J+uLtczk+7ZTHSiFhuZ75+sdpnZ0Mhb
         WYAf014pir4taPGaE+Zn7BtUwC5toBzTu3DlSDNCL4kQaXeB6dfG9cSztEaFOtovoY2W
         +nMJ56rFISxKXyr1GuGRhxBuImldNEu/zHfgrs6ZbkZnTKtR2TIEURKTHBIplEY32X+s
         Kry3osXfeTFwExAucd/s1NCAtCZIRYvUdt4b0UGUsdUzWzh+1jh5um4gS+lPyzzZnrBR
         cSzw==
X-Gm-Message-State: AJIora9TNCjACdoTlK41K+hff6TZIMTNhWwz5r/OSjH0l9nPHZyvws4h
        Wu1C57fb+kr/eXko9+QTLUyWDQ32xmz3VTEWD/g=
X-Google-Smtp-Source: AGRyM1uwObJHTtr8E4Aind6Ys/PNiiP2TwTnNY9ANUktS7kVz93eM/E8LHw2EanASZRpM5wwwlWMjZHApscp0SKoEo0=
X-Received: by 2002:a67:5f41:0:b0:356:2a61:5791 with SMTP id
 t62-20020a675f41000000b003562a615791mr2271822vsb.87.1656429518209; Tue, 28
 Jun 2022 08:18:38 -0700 (PDT)
MIME-Version: 1.0
References: <CAJGXZLi_QCZ+4dHv8qtGeyEjdkP3wjoXge_b-zTZ0sgUcEZ8zw@mail.gmail.com>
 <20220622171929.77078c4d@kernel.org> <CAJGXZLiNo=G=5889sPyiCZVjRf65Ygov3=DWFgKmay+Dy3wCYw@mail.gmail.com>
 <20220623202602.650ed2e6@kernel.org> <CAJGXZLg9Z3O8w_bTLhyU1m7Oemfx561X0ji0MdYRZG8XKmxBpg@mail.gmail.com>
 <20220624101743.78d0ece7@kernel.org>
In-Reply-To: <20220624101743.78d0ece7@kernel.org>
From:   Aleksey Shumnik <ashumnik9@gmail.com>
Date:   Tue, 28 Jun 2022 18:18:27 +0300
Message-ID: <CAJGXZLhJd4xYQhvhb8r0QYhjSjNUCe6nmvi5TA_Ma6LO992KYw@mail.gmail.com>
Subject: Re: [PATCH] net/ipv4/ip_gre.c net/ipv6/ip6_gre.c: ip and gre header
 are recorded twice
To:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kuznet@ms2.inr.ac.ru, xeb@mail.ru
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 24, 2022 at 8:17 PM Jakub Kicinski <kuba@kernel.org> wrote:
> On Fri, 24 Jun 2022 16:51:41 +0300 Aleksey Shumnik wrote:
> > On Fri, Jun 24, 2022 at 6:26 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > > > I use SOCK_DGRAM
> > >
> > > Strange.
> >
> > Why is it strange?
>
> I meant surprising, I'd have thought we could miss something like that
> for RAW sockets maybe but DGRAM/ICMP should work.

I was surprised too.

> > > > I want to find out, the creation of gre and ip header twice, is it a
> > > > feature or a bug?
> > >
> > > I can't think why that'd be a feature. Could add this case to selftests
> > > to show how to repro and catch regressions?
> >
> > I don't really know how to do it, but I'll try
> > If we just talk about selftests/net, then everything has passed
>
> What I'm looking for is a bash(?) script which sets up the tunnel sends
> a packet and checks if the headers are valid.

I'm creating a file "mgre0" on spok, and use ifup to create the interface:

auto mgre0
iface mgre0 inet6 static
address 2001:470::1
netmask 64
pre-up ip tunnel add mgre0 mode ip6gre local 4444::1111 key 1 ttl 64 tos inherit
pre-up ethtool -K mgre0 tx off > /dev/null
pre-up ip link set mgre0 mtu 1400
pre-up ip link set mgre0 multicast on
post-down ip link del mgre0

do the same on hub:

auto mgre0
iface mgre0 inet6 static
address 2001:470::100
netmask 64
pre-up ip tunnel add mgre0 mode ip6gre local 4444::4444 key 1 ttl 64 tos inherit
pre-up ethtool -K mgre0 tx off > /dev/null
pre-up ip link set mgre0 mtu 1400
pre-up ip link set mgre0 multicast on
post-down ip link del mgre0

then I use ip neigh to add an entry to the neighbors table
spok:
$ ip -6 neigh add 2001:470::100 lladdr 4444::4444 dev mgre0

hub:
$ ip -6 neigh add 2001:470::1 lladdr 4444::1111 dev mgre0

and then ping hub from spok
$ ping 2001:470::100

To check if the headers are valid, I use tcpdump and look at the packets

> > > > I did everything according to the instructions, hope everything is
> > > > correct this time.
> > >
> > > Nope, still mangled.
> >
> > Strangely, everything works fine for me
>
> Depends on definition of "works", are you saying you can download this:
>
> https://lore.kernel.org/all/CAJGXZLiNo=G=5889sPyiCZVjRf65Ygov3=DWFgKmay+Dy3wCYw@mail.gmail.com/raw
>
> which is your email in text form and `git am` will accept that as a
> patch?

I use the kernel version 5.10.70.
I copy the code (starting from "diff" and up to the end), create a
patch file and apply it to the kernel.
