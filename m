Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED563539321
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 16:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345253AbiEaO01 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 10:26:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345194AbiEaO00 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 10:26:26 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 516527CDDD;
        Tue, 31 May 2022 07:26:23 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id f21so26915779ejh.11;
        Tue, 31 May 2022 07:26:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ue5buJT5E74XVP8su1RZHoIggsGgw6wVZdFRERN/nS8=;
        b=hgm+W3VXAjq8KZl44XJVDPCmVbKiuFupXTbDOVwFC/i0SqYIQ7UGGXAhfRgmtv81Hc
         itxje5RSqtyfD0IFFuT2sVn3J+IcYltNd6YRTKKaqaEyqZo6sZksPASZqPehhiiXvOtl
         LbvNPw0sr2XhZODz8SFIb6D2pa3PdTSG6OaIjLbL0FCsdWE23dHfQ8hu0su8UIf9vvgl
         wZJdedI/9rIsMKySJ9YYpz00156vE8t4ThRdhuAmgnE9aF4Myl5pSoQ6J4xp0UXTFnD1
         B1r3YCRiLdnHtVobebASgYSTS4pl+wncuBxoFNJBVtfDGRwQkvmCr5GYvWPqGMbvJci9
         N69w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ue5buJT5E74XVP8su1RZHoIggsGgw6wVZdFRERN/nS8=;
        b=2w+CfbI7aTR1A5VpaUw27LW1Qp1DAu0bdqUmFrwhCVs27m8+2G+LyMImgKey671sbZ
         9vTru0xdMZiyaMRU5Fvc9PoFs9fRksLKY6RniuWxfZjKZYpzoe9ZWzVMXSGbF264Hn23
         GRckH8rrbY+MAU/cm5tpJuxFDd9IHYa7AJGo0/s3pvAjzXAi0WwCaNfoTxOBDhTp0/hx
         5PwuIzOAKavs7K9Q+abUTEB7qF+GeE35opeIe7Ohdz53Di7DZdRotAWcojstKhkn/OP7
         +4pOmA5792xIye19TPswnGVEo/snJGlHOgXYMBHLoEjJsYmXgo1g9Yg4F6sC7XARlg3z
         a2Vw==
X-Gm-Message-State: AOAM53323oZO69GHJUeQ5XsQqG5FSVneQnyIg/elDwkHDu+VWlvJALU6
        hWQ+XLBwNHnOV+3OVswz34BxYCybUiT8b8n/a/E=
X-Google-Smtp-Source: ABdhPJwBblXBQpuq4eyjn/5jPqzK2zt6AmKmybKN3QSOEhS9NRtAo9tw8rodqQhFfF4khOtqBj9J89KlQUawOwUNwyU=
X-Received: by 2002:a17:907:9712:b0:6ff:c09:33a2 with SMTP id
 jg18-20020a170907971200b006ff0c0933a2mr28418873ejc.50.1654007181855; Tue, 31
 May 2022 07:26:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220531100922.491344-1-gasmibal@gmail.com> <YpYP9NBD+Wmzup+s@sellars>
In-Reply-To: <YpYP9NBD+Wmzup+s@sellars>
From:   Baligh GASMI <gasmibal@gmail.com>
Date:   Tue, 31 May 2022 16:26:10 +0200
Message-ID: <CALxDnQYd5KzaBBxNnj7S_7joZFULY4pEsJ=gdePWcPM-K3i0cA@mail.gmail.com>
Subject: Re: [RFC PATCH v3 1/1] mac80211: use AQL airtime for expected throughput.
To:     =?UTF-8?Q?Linus_L=C3=BCssing?= <linus.luessing@c0d3.blue>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "open list:MAC80211" <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        The list for a Better Approach To Mobile Ad-hoc
         Networking <b.a.t.m.a.n@lists.open-mesh.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
>
> On Tue, May 31, 2022 at 12:09:22PM +0200, Baligh Gasmi wrote:
> > Since the integration of AQL, packet TX airtime estimation is
> > calculated and counted to be used for the dequeue limit.
> >
> > Use this estimated airtime to compute expected throughput for
> > each station.
> >
> > It will be a generic mac80211 implementation. If the driver has
> > get_expected_throughput implementation, it will be used instead.
> >
> > Useful for L2 routing protocols, like B.A.T.M.A.N.
> >
> > Signed-off-by: Baligh Gasmi <gasmibal@gmail.com>
>
> Hi Baligh,
>
> Thanks for your work, this indeed sounds very relevant for
> batman-adv. Do you have some test results on how this compares to
> real throughput? And maybe how it compares to other methods we
> already have in the kernel, like expected throughput via
> minstrel_ht rate control or the estimates performed in 802.11s
> HWMP [0]?

I'll share a comparison between an iperf3 running and the current
value of this implementation.
What I can say, for now, is that they are close to each other.
The minstrel_ht still a better implementation for expected throughput.
That's why if there is minstrel_ht support, it will be used instead of
this implementation.
However, 802.11s metric is another story, it's a parameter used by the
HWMP routing protocol for the path selection, so it could be based on
the expected throughput, but it includes other factors that could be
mesh specific.
For me, 802.11s metric and expected throughput are not necessarily the
same values.

>
> Is there a certain minimum amount of traffic you'd suggest to have
> enough samples to get a meaningful result?

I'm using a burst of 50 ARP packets, padded to have 1024 bytes.
(to be optimized)

>
> I'm also wondering if we are starting to accumulate too many
> places to provide wifi expected throughput calculations. Do you
> see a chance that this generic mac80211 implementation could be made
> good enough to be used as the sole source for both batman-adv and
> 802.11s HWMP, for instance? Or do you see some pros and cons
> between the different methods?
>

I think that this implementation is still based on an estimation, so
it's not good as a minstrel.
It's based on the AQL airtime estimation. With a phy_rate of the last
sent packet, and average aggregated packets, and other stuff ...
The whole idea is not to replace current implementation, but to extend
other drivers (to have something is better than having nothing !)
Since batman-adv needs the expected throughput to make a decision, it
will get a value regardless of the driver implementation.

> Regards, Linus
>
>
> [0]: https://elixir.bootlin.com/linux/v5.18/source/net/mac80211/mesh_hwmp.c#L295
