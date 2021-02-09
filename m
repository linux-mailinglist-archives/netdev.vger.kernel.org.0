Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99B71315243
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 16:01:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232274AbhBIO73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 09:59:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232223AbhBIO7X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 09:59:23 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09F3BC06178A
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 06:58:43 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id q2so20971393eds.11
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 06:58:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WjnZ+lf0rzSbGvVNdx0+PwHC+l7Tql3OkLWocDuesLs=;
        b=cf7YjV4V97+iHjta9sBgI8VIOhq59EpYYWI8W5NFHlLUhaj8GpY8OCq/OQK5RzvGTu
         Mrm0B+m+XH5DbEN8+MuB4g5TYORFUkXL9e+XXdi7svUBVrpBX0VsFRoWt8o0avyx9hOA
         b/qgEbqqRA4kRp2MVFJQ/XbiPuiRrdSKRMcmHDKhbuAE3WuBhTuoYFil2mcoQIOWG9pO
         gxXdQfyKVw8BB+b1jX3b3AOtT2QlVcxX/n28KWWiWYyjaDrngulCGvXpRO7b8I/uhr1D
         tznFEUXxAT9v17LpACdM4UeJmVtxSK5ROeOwQ//35wgN0tt2PavUsIhG+uRA/Orrx0es
         rHXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WjnZ+lf0rzSbGvVNdx0+PwHC+l7Tql3OkLWocDuesLs=;
        b=ZzK+sa3uk5QfcYDeF1h9naC+IX75zinE1+A6XrjIVSljKBt86VYQ0o+FHZxF8WKuex
         TZ/wVntiSXDvTYWuJsSMRe0A3g9p0UD7j5RF9DoYkGciQgQ30HebJLbjTMTcCnZREZ3Y
         TeLwi6pC+N8PfIct9TmQi2Ag4XwuzWXcnpOgywCcgobX4I052x8y7LiFBSe1jOHGKy9k
         9mgFnPVgAGQwCa+1+/TtCC/ZGuHdVACup9QdChNMPn0He2qQMp7ZScPoIN0Q/GwRQeEV
         vp8yU2Aufm07lA7WfGB7w+iczswWTxyEz0GRsSeG2ochhzMfEIcrbd5k60gYJHg7VQzX
         bBJg==
X-Gm-Message-State: AOAM530nNEzm9ucKtMrEiZUum0tnU00Ad5KdsM7olE5/xjllUyaechPL
        y/CLSos0XhP8oxLGD619f0O3kZQivH7wyc10sck=
X-Google-Smtp-Source: ABdhPJxYq2+RUn1P0fxzlzX2fq91sYF4YIs7eek67HXUOblGnok6ui3pgm0DuhjNESCzrzsQYYPInSV5sKw7e+Go2Gk=
X-Received: by 2002:a05:6402:d09:: with SMTP id eb9mr23500453edb.285.1612882721778;
 Tue, 09 Feb 2021 06:58:41 -0800 (PST)
MIME-Version: 1.0
References: <20210129002136.70865-1-weiwan@google.com> <a0b2cb8d-eb8f-30fb-2a22-678e6dd2f58f@redhat.com>
 <CAF=yD-+aPBF2RaCR8L5orTM37bf7Z4Z8Qko2D2LZjOz0khHTUg@mail.gmail.com>
 <3a3e005d-f9b2-c16a-5ada-6e04242c618e@redhat.com> <CAF=yD-+NVKiwS6P2=cS=gk2nLcsWP1anMyy4ghdPiNrhOmLRDw@mail.gmail.com>
 <9b0b8f2a-8476-697e-9002-e9947e3eab63@redhat.com> <CA+FuTScVOuoHKtrdrRFswjA3Zq1-7sgMVhnP2iMB5sYFFS8NFg@mail.gmail.com>
 <50ae0b71-df87-f26c-8b4d-8035f9f6a58d@redhat.com> <CAF=yD-J5-60D=JDwvpecjaO6J03SZHoHJyCsR3B1HbP1-jbqng@mail.gmail.com>
 <00de1b0f-f2aa-de54-9c7e-472643400417@redhat.com>
In-Reply-To: <00de1b0f-f2aa-de54-9c7e-472643400417@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 9 Feb 2021 09:58:04 -0500
Message-ID: <CAF=yD-K9xTBStGR5BEiS6WZd=znqM_ENcj9_nb=rrpcMORqE8g@mail.gmail.com>
Subject: Re: [PATCH net] virtio-net: suppress bad irq warning for tx napi
To:     Jason Wang <jasowang@redhat.com>
Cc:     Wei Wang <weiwan@google.com>, David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >>> I have no preference. Just curious, especially if it complicates the patch.
> >>>
> >> My understanding is that. It's probably ok for net. But we probably need
> >> to document the assumptions to make sure it was not abused in other drivers.
> >>
> >> Introduce new parameters for find_vqs() can help to eliminate the subtle
> >> stuffs but I agree it looks like a overkill.
> >>
> >> (Btw, I forget the numbers but wonder how much difference if we simple
> >> remove the free_old_xmits() from the rx NAPI path?)
> > The committed patchset did not record those numbers, but I found them
> > in an earlier iteration:
> >
> >    [PATCH net-next 0/3] virtio-net tx napi
> >    https://lists.openwall.net/netdev/2017/04/02/55
> >
> > It did seem to significantly reduce compute cycles ("Gcyc") at the
> > time. For instance:
> >
> >      TCP_RR Latency (us):
> >      1x:
> >        p50              24       24       21
> >        p99              27       27       27
> >        Gcycles         299      432      308
> >
> > I'm concerned that removing it now may cause a regression report in a
> > few months. That is higher risk than the spurious interrupt warning
> > that was only reported after years of use.
>
>
> Right.
>
> So if Michael is fine with this approach, I'm ok with it. But we
> probably need to a TODO to invent the interrupt handlers that can be
> used for more than one virtqueues. When MSI-X is enabled, the interrupt
> handler (vring_interrup()) assumes the interrupt is used by a single
> virtqueue.

Thanks.

The approach to schedule tx-napi from virtnet_poll_cleantx instead of
cleaning directly in this rx-napi function was not effective at
suppressing the warning, I understand.

It should be easy to drop the spurious rate to a little under 99%
percent, if only to suppress the warning. By probabilistically
cleaning in virtnet_poll_cleantx only every 98/100, say. But that
really is a hack.

There does seem to be a huge potential for cycle savings if we can
really avoid the many spurious interrupts.

As scheduling napi_tx from virtnet_poll_cleantx is not effective,
agreed that we should probably look at the more complete solution to
handle both tx and rx virtqueues from the same IRQ.

And revert this explicit warning suppression patch once we have that.
