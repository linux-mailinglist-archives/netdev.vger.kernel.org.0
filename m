Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A89723D5AB8
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 15:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234271AbhGZNJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 09:09:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:34870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234201AbhGZNJk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 09:09:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F04E060F5B;
        Mon, 26 Jul 2021 13:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627307409;
        bh=BuNMA3OKwOYxcJ66+DLzg/7KwAyvnoKVkl1tFGUMWS8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=P/1yzU4WFw1YA2y9Y90WL3vvHP25Z+OMrcmhS1A3CHif9fOgqF687i/09CB2QqoYR
         ZlQJoiuwOwSOgQ7YJ/A+qxOaIlPbPLjKxzbgdUmaNGJFK4SnF7A7kU4x5ho3Vh/xQ2
         h2r6nN+DgR9Ar1O893fwL/h+XmuDgp5DyJWLITSVBNeSLRdSAV1XbqE0pvb8HbZCUq
         mJAYSsqLXqdYafBo3MqsBOfklVa3t4QHPvdgg9NrtEzfydX09oRdmSKqugaE6/RzuD
         UETr9EvtzCYKUGwvXAdg3CEwT0R+3smcX6H/rVEPNW0RteW37KDLlI7tW3m2DILuVg
         t/ZSQ6Y4Suemw==
Received: by mail-wm1-f52.google.com with SMTP id n21so5381032wmq.5;
        Mon, 26 Jul 2021 06:50:08 -0700 (PDT)
X-Gm-Message-State: AOAM533fRx2q9IYt0XDc75i0xpcNyzbWCAk2HTvpN5Oj33moX1Z5O3oR
        MD8MZzlPq79OLYGIukYiPniGA3imaqiM6Yxllxs=
X-Google-Smtp-Source: ABdhPJyGJ7XZF274Qssdtdvh4G6RwXymeoSoqclwy/LWz9iPSyyiUet+63KF+hCHfoNCBLc9Lbx4BwTyc4C3DbvqXRg=
X-Received: by 2002:a1c:c90f:: with SMTP id f15mr26978923wmb.142.1627307407556;
 Mon, 26 Jul 2021 06:50:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210722141351.13668-1-biju.das.jz@bp.renesas.com>
 <b295ec23-f8b2-0432-83e6-16078754e5e3@gmail.com> <YPneBpUk6z8iy94G@lunn.ch>
 <TYCPR01MB593398E6E5422E81C01F1F8C86E59@TYCPR01MB5933.jpnprd01.prod.outlook.com>
 <CAMuHMdXecUYTSjGUyDZDFKfwT+Fgi4n4o08b0Yunu70JmpnN=w@mail.gmail.com>
In-Reply-To: <CAMuHMdXecUYTSjGUyDZDFKfwT+Fgi4n4o08b0Yunu70JmpnN=w@mail.gmail.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Mon, 26 Jul 2021 15:49:48 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0zcXT7xtXpt3-Yf=7Oiitrch5KjcqMcRf4ZRK56B_NqA@mail.gmail.com>
Message-ID: <CAK8P3a0zcXT7xtXpt3-Yf=7Oiitrch5KjcqMcRf4ZRK56B_NqA@mail.gmail.com>
Subject: Re: [PATCH net-next 00/18] Add Gigabit Ethernet driver support
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 26, 2021 at 12:56 PM Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> On Fri, Jul 23, 2021 at 8:28 AM Biju Das <biju.das.jz@bp.renesas.com> wrote:
> > >
> > > Are these changes inseparable? If so, you need to be up front on this, and
> > > you need an agreement with the subsystem maintainers how the patches are
> > > going to be merged? Through which tree. And you need Acked-by from the
> > > other tree maintainers.
> > >
> > > Ideally you submit multiple patchsets. This assumes all sets will compile
> > > independently.
> >
> > Agreed. Will split this patch series in 3 patchsets
> >
> > 1) single binding patch
> >
> > 2) Clock patchset
> >
> > 3) ravb driver patchset.
>
> 4) dts part.
>
> Part 2 should pass through renesas-clk.
> Part 4 should pass through renesas-devel.

Sounds good. To clarify: the changes should not just compile, but
each branch should be usable independently with no loss of
functionality. Using the feature depends on having all branches
merged, but they should not introduced regressions when applied
into some other tree.

I hope this was already obvious to everyone involved.

       Arnd
