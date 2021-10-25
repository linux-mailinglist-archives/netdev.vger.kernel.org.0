Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B58C743A40C
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 22:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233499AbhJYUMG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 16:12:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237233AbhJYULq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 16:11:46 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 365C0C04A410
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 12:30:11 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id l13so3561378edi.8
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 12:30:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kryo-se.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WpgMH3xxaoecpeOJaRPaLgLJl4EJJvdRqRH9yCLdUuA=;
        b=lSY+KrUe51PreKwfNsCUG5hB6Fg/pLD9K5auf3Y5p4qrG3/aeUyP004kV4dC+qzqtm
         dH+Ns/Il1Z/qL/N8b8kSHqRhkcsQRWKGQkJYKTLtxdL0uksoUjif1JfXxv9XVUnJ1kBe
         9lnzmHg71fmYpm9iH6vqXCZOvVZ9qRFKLM/h9MecRaA4tvLV0wFp18RY4Y3bj5jUDnDe
         apOD7afUEGD9QRUPMrVXN0Wj7Vr7GPZ6ROeeREJAmiyWryzv8Ye5fPGlCGgsmAnuS0F0
         Q2MTTzbAImBCY4fmCwR6m5BinlQSkKIyNZxE53+yddRiZcEoCKn3/srxf5MVp4zWaKwx
         Gifg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WpgMH3xxaoecpeOJaRPaLgLJl4EJJvdRqRH9yCLdUuA=;
        b=7YBKhXGTVEYVWWpn55sBIU1XNnWQjRUQ49YyP2fGiF6k3oEELkh9HmcGJxy6/KvGIU
         126remh2oQr6silJCJMvgQn7q8fb6guVja3mkVlIBtnCqs1qq84/mAIfIE+kQryyaIll
         PpPOHEloT72EI7SzIxOvWHOuj4trxpi13P78oZBGitK4RpcsVH8J8/a8zNXsZsllsdVF
         ZnvtJ9pYYaCkSKWS+vSvFLoPCsvKjmUjIp+EAbFkCDYo6h1tg4LtAOGC90/+1Qb7dqda
         /WZkxSQFj+zTv2bacVOwUWHAeZeTbe1OaI41dY4Twy+OldqNXFlcMiR8rxx87VzJ229b
         qqdg==
X-Gm-Message-State: AOAM530ThZjn6KC6wc5JL0hO/GM4wp3f4vlncWmld9e24SPCMEXaazDK
        2DxfImeMLC7pSYHKl/PSrv2GqMLWACplEVkTrHdGrA==
X-Google-Smtp-Source: ABdhPJwR4qhv23sVCCOh5hluM+Cw3u1d10jot+dP7ZIHC/1faNML/JDFhTeMoD/uBPEO+vb2wDOD1XPRVUHuIkThJ90=
X-Received: by 2002:aa7:de12:: with SMTP id h18mr17165835edv.109.1635190209558;
 Mon, 25 Oct 2021 12:30:09 -0700 (PDT)
MIME-Version: 1.0
References: <20211017171657.85724-1-erik@kryo.se> <YW7idC0/+zq6dDNv@lunn.ch>
 <CAGgu=sCBUU29tkjqOP9j7EZJL-T4O6NoTDNB+-PFNhUkOTdWuw@mail.gmail.com>
 <YW8OiIpcncIaANzN@lunn.ch> <CAGgu=sD=cuqTEK3760wGFELLBgy3S6QgY_776KeDDDZV8GvZNQ@mail.gmail.com>
In-Reply-To: <CAGgu=sD=cuqTEK3760wGFELLBgy3S6QgY_776KeDDDZV8GvZNQ@mail.gmail.com>
From:   Erik Ekman <erik@kryo.se>
Date:   Mon, 25 Oct 2021 21:29:58 +0200
Message-ID: <CAGgu=sBPv6qSfy-+g__UjcMWf6TcYT0KDoxcz7RFXZ59RdjZTw@mail.gmail.com>
Subject: Re: [PATCH] sfc: Fix reading non-legacy supported link modes
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Oct 2021 at 20:58, Erik Ekman <erik@kryo.se> wrote:
>
> On Tue, 19 Oct 2021 at 20:29, Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > On Tue, Oct 19, 2021 at 07:41:46PM +0200, Erik Ekman wrote:
> > > On Tue, 19 Oct 2021 at 17:21, Andrew Lunn <andrew@lunn.ch> wrote:
> > > >
> > > > On Sun, Oct 17, 2021 at 07:16:57PM +0200, Erik Ekman wrote:
> > > > > Everything except the first 32 bits was lost when the pause flags were
> > > > > added. This makes the 50000baseCR2 mode flag (bit 34) not appear.
> > > > >
> > > > > I have tested this with a 10G card (SFN5122F-R7) by modifying it to
> > > > > return a non-legacy link mode (10000baseCR).
> > > >
> > > > Does this need a Fixes: tag? Should it be added to stable?
> > > >
> > >
> > > The speed flags in use that can be lost are for 50G and 100G.
> > > The affected devices are ones based on the Solarflare EF100 networking
> > > IP in Xilinx FPGAs supporting 10/25/40/100-gigabit.
> > > I don't know how widespread these are, and if there might be enough
> > > users for adding this to stable.
> > >
> > > The gsettings api code for sfc was added in 7cafe8f82438ced6d ("net:
> > > sfc: use new api ethtool_{get|set}_link_ksettings")
> > > and the bug was introduced then, but bits would only be lost after
> > > support for 25/50/100G was added in
> > > 5abb5e7f916ee8d2d ("sfc: add bits for 25/50/100G supported/advertised speeds").
> > > Not sure which of these should be used for a Fixes tag.
> >
> > I would you this second one, since that is when it becomes visible to
> > users.
> >
> Thanks
>
> I found that the SFC9250 is also affected (it supports 10/25/40/50/100G)
>
> Fixes: 5abb5e7f916ee8 ("sfc: add bits for 25/50/100G
> supported/advertised speeds")
>
> /Erik

I see that the other patch adding new modes (c62041c5baa9d, "sfc:
Export fibre-specific supported link mode") has been merged to net
(and upstream), so this is needed there as well.

/Erik
