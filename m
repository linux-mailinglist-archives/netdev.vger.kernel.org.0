Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96213315685
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 20:10:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233644AbhBITIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 14:08:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233456AbhBIS47 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 13:56:59 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8D01C061574
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 10:00:34 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id i71so19040961ybg.7
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 10:00:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K41UsSV4bOHK00Kpx5OjcGmuxcw2UTmKBRRxzzoel8E=;
        b=EJEP+8Ze989t1+ZZfr/dJPVYgA2UGWmsqLglq4ETySfGBtgZXYvOT5SwX9q8VA+6/S
         QAxdxlOHsuLnVrUhQsyVl+dLQijk2d93GbMCMYn3Pj/aDGe1VyHZskRkwORNKw8ZA5b4
         bUGRzVq2FyNu3KQ+fmhXpYer5oblwdJiugdlPtsywZIqBHox5ZRmzuMbPw1wdc0H1kzZ
         pbzz4qHM/XLunNxpo9k1lz4/ydwJaktgqtMHA2GWqhCJgfpdYvU/wnardi7kzC3Rd/c8
         UI1JJPvk9VBa0n1fomYgI5odKrie5iuE1KM7b+matRBoJ59eYvt8Agb5ycjYzHnSj47+
         ++5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K41UsSV4bOHK00Kpx5OjcGmuxcw2UTmKBRRxzzoel8E=;
        b=ofyxitGuUsYcdbj6GqbkWG/wWbo6CWyGXKk15dqetcQXqmGc4bGMDcUtnFyinwcHQC
         UNWxEHaqXOOMwsa8NU9l/k81AV7mLLEKJz/MYs6IWgVNHYRnh1d+wROKa6UHxhKntReW
         FF9lOWZgswOj/JoZiL0uNkBikR7heC1r1tKAV0nTW/Qci08HECcmTzqJlD/N+7YtN4UP
         JzNa78wV7D8ED5GGyYHcUIFFWQiO61uPr6Jne6gpd2jLP/vRL1ygmm4vQGW5zwCem3HS
         gLYTENkDQZMQcndYjZPkPA1fBfF8n0aTEL0+Tz6W33GhrD08XP6Di8mlCBU066V6R9d2
         kwrQ==
X-Gm-Message-State: AOAM531eLDEgtQ6+UYzb/aHFJOrycJ0KnjM9rABd36GPBM98HmNs+fnF
        lZYEUvT2HbFB9qVKRO/KMidriq6ffUruxrIP39ZAxQ==
X-Google-Smtp-Source: ABdhPJzMjMcq3lHuTrw7/n46FoWhKVOViV2PF53ENWm49jQ5S68XG1af9bH07AnpwjaUbgSILpfMdWsJ5E7Z3BDlIMQ=
X-Received: by 2002:a25:99c6:: with SMTP id q6mr33750728ybo.408.1612893633901;
 Tue, 09 Feb 2021 10:00:33 -0800 (PST)
MIME-Version: 1.0
References: <20210129002136.70865-1-weiwan@google.com> <a0b2cb8d-eb8f-30fb-2a22-678e6dd2f58f@redhat.com>
 <CAF=yD-+aPBF2RaCR8L5orTM37bf7Z4Z8Qko2D2LZjOz0khHTUg@mail.gmail.com>
 <3a3e005d-f9b2-c16a-5ada-6e04242c618e@redhat.com> <CAF=yD-+NVKiwS6P2=cS=gk2nLcsWP1anMyy4ghdPiNrhOmLRDw@mail.gmail.com>
 <9b0b8f2a-8476-697e-9002-e9947e3eab63@redhat.com> <CA+FuTScVOuoHKtrdrRFswjA3Zq1-7sgMVhnP2iMB5sYFFS8NFg@mail.gmail.com>
 <50ae0b71-df87-f26c-8b4d-8035f9f6a58d@redhat.com> <CAF=yD-J5-60D=JDwvpecjaO6J03SZHoHJyCsR3B1HbP1-jbqng@mail.gmail.com>
 <00de1b0f-f2aa-de54-9c7e-472643400417@redhat.com> <CAF=yD-K9xTBStGR5BEiS6WZd=znqM_ENcj9_nb=rrpcMORqE8g@mail.gmail.com>
In-Reply-To: <CAF=yD-K9xTBStGR5BEiS6WZd=znqM_ENcj9_nb=rrpcMORqE8g@mail.gmail.com>
From:   Wei Wang <weiwan@google.com>
Date:   Tue, 9 Feb 2021 10:00:22 -0800
Message-ID: <CAEA6p_Bi1OMTas0W4VuxAMz8Frf+vBNc8c7xCDUxb_uwUy8Zgw@mail.gmail.com>
Subject: Re: [PATCH net] virtio-net: suppress bad irq warning for tx napi
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 9, 2021 at 6:58 AM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> > >>> I have no preference. Just curious, especially if it complicates the patch.
> > >>>
> > >> My understanding is that. It's probably ok for net. But we probably need
> > >> to document the assumptions to make sure it was not abused in other drivers.
> > >>
> > >> Introduce new parameters for find_vqs() can help to eliminate the subtle
> > >> stuffs but I agree it looks like a overkill.
> > >>
> > >> (Btw, I forget the numbers but wonder how much difference if we simple
> > >> remove the free_old_xmits() from the rx NAPI path?)
> > > The committed patchset did not record those numbers, but I found them
> > > in an earlier iteration:
> > >
> > >    [PATCH net-next 0/3] virtio-net tx napi
> > >    https://lists.openwall.net/netdev/2017/04/02/55
> > >
> > > It did seem to significantly reduce compute cycles ("Gcyc") at the
> > > time. For instance:
> > >
> > >      TCP_RR Latency (us):
> > >      1x:
> > >        p50              24       24       21
> > >        p99              27       27       27
> > >        Gcycles         299      432      308
> > >
> > > I'm concerned that removing it now may cause a regression report in a
> > > few months. That is higher risk than the spurious interrupt warning
> > > that was only reported after years of use.
> >
> >
> > Right.
> >
> > So if Michael is fine with this approach, I'm ok with it. But we
> > probably need to a TODO to invent the interrupt handlers that can be
> > used for more than one virtqueues. When MSI-X is enabled, the interrupt
> > handler (vring_interrup()) assumes the interrupt is used by a single
> > virtqueue.
>
> Thanks.
>
> The approach to schedule tx-napi from virtnet_poll_cleantx instead of
> cleaning directly in this rx-napi function was not effective at
> suppressing the warning, I understand.

Correct. I tried the approach to schedule tx napi instead of directly
do free_old_xmit_skbs() in virtnet_poll_cleantx(). But the warning
still happens.

>
> It should be easy to drop the spurious rate to a little under 99%
> percent, if only to suppress the warning. By probabilistically
> cleaning in virtnet_poll_cleantx only every 98/100, say. But that
> really is a hack.
>
> There does seem to be a huge potential for cycle savings if we can
> really avoid the many spurious interrupts.
>
> As scheduling napi_tx from virtnet_poll_cleantx is not effective,
> agreed that we should probably look at the more complete solution to
> handle both tx and rx virtqueues from the same IRQ.
>
> And revert this explicit warning suppression patch once we have that.

If everyone agrees, I will submit a new version of this patch to
address previous comments, before a more complete solution is
proposed.
