Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1CB3D57D5
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 12:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232498AbhGZKPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 06:15:25 -0400
Received: from mail-vs1-f47.google.com ([209.85.217.47]:47042 "EHLO
        mail-vs1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231792AbhGZKPY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 06:15:24 -0400
Received: by mail-vs1-f47.google.com with SMTP id e4so4929272vsr.13;
        Mon, 26 Jul 2021 03:55:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PC9p+DhA09pyYVa2lDRMUzwd/1DxS6/ThMpBKEZ540I=;
        b=pILa0j9bgOz0YPQ3fL1228VorzEe/yXfYV0eQVs150f+EsrOYwibcE2SEqAjLg1Pa4
         8cd4NKDr+4/592gakN1X65/2Qoo1iGo0m9nXCNXLDOoXTnjjyd1PEj2qFYejdziXhbEJ
         0/kU9LMT1KN7gB1OuxfqethV3OKBGiiyLvyJZoyAiHuE3TWnkkx1jAUGvjqt0qUX0tSI
         PUZ+D8kArYGcS5jTW3dgO8It+ed3apkm44e9N2zJXt1BWu4uFHngG4yCa1G9sRMH/U3U
         BLxNJ3UljHfqqe0/Xiz7GKXkMnwSCi36t0Co+8t5Z160eiAdqdhTguGoy+wa9SuSV/Aq
         nITQ==
X-Gm-Message-State: AOAM530it2fctg1clvT5FrQMGrfLTY0N6GwTYW/wc0h3Ez1UMjwTaLnG
        gzEnlDBHzvWFkiG317D4tOG3AAZrNJrfTO4XKQQ=
X-Google-Smtp-Source: ABdhPJwFkdsN6fVdy6k+zl2b/JKqOhILxbWjTtcaJLtfiCJQtkV2QMsJyCiySjUSMG67/vOSXvXz2+fRSOJ220Rj3HA=
X-Received: by 2002:a67:7789:: with SMTP id s131mr8454510vsc.40.1627296952092;
 Mon, 26 Jul 2021 03:55:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210722141351.13668-1-biju.das.jz@bp.renesas.com>
 <b295ec23-f8b2-0432-83e6-16078754e5e3@gmail.com> <YPneBpUk6z8iy94G@lunn.ch> <TYCPR01MB593398E6E5422E81C01F1F8C86E59@TYCPR01MB5933.jpnprd01.prod.outlook.com>
In-Reply-To: <TYCPR01MB593398E6E5422E81C01F1F8C86E59@TYCPR01MB5933.jpnprd01.prod.outlook.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 26 Jul 2021 12:55:41 +0200
Message-ID: <CAMuHMdXecUYTSjGUyDZDFKfwT+Fgi4n4o08b0Yunu70JmpnN=w@mail.gmail.com>
Subject: Re: [PATCH net-next 00/18] Add Gigabit Ethernet driver support
To:     Biju Das <biju.das.jz@bp.renesas.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
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

Hi Biju,

On Fri, Jul 23, 2021 at 8:28 AM Biju Das <biju.das.jz@bp.renesas.com> wrote:
> > Subject: Re: [PATCH net-next 00/18] Add Gigabit Ethernet driver support
> >
> > On Thu, Jul 22, 2021 at 11:53:59PM +0300, Sergei Shtylyov wrote:
> > > On 7/22/21 5:13 PM, Biju Das wrote:
> > >
> > > > The DMAC and EMAC blocks of Gigabit Ethernet IP is almost similar to
> > Ethernet AVB.
> > > >
> > > > The Gigabit Etherner IP consists of Ethernet controller (E-MAC),
> > Internal TCP/IP Offload Engine (TOE) and Dedicated Direct memory access
> > controller (DMAC).
> > > >
> > > > With few changes in driver, we can support Gigabit ethernet driver as
> > well.
> > > >
> > > > This patch series is aims to support the same
> > > >
> > > > RFC->V1
> > > >   * Incorporated feedback from Andrew, Sergei, Geert and Prabhakar
> > > >   *
> > > > https://jpn01.safelinks.protection.outlook.com/?url=https%3A%2F%2Fpa
> > > > tchwork.kernel.org%2Fproject%2Flinux-renesas-soc%2Flist%2F%3Fseries%
> > > > 3D515525&amp;data=04%7C01%7Cbiju.das.jz%40bp.renesas.com%7C6fe3922cc
> > > > 35d4178cb1d08d94d54bc75%7C53d82571da1947e49cb4625a166a4a2a%7C0%7C0%7
> > > > C637625848601442706%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQ
> > > > IjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=bOpIqV1g
> > > > lMUXqz9rsX0UK3Oqap2J1cY86TGVOJvzYe4%3D&amp;reserved=0
> > > >
> > > > Biju Das (18):
> > > >   dt-bindings: net: renesas,etheravb: Document Gigabit Ethernet IP
> > > >   drivers: clk: renesas: rzg2l-cpg: Add support to handle MUX clocks
> > > >   drivers: clk: renesas: r9a07g044-cpg: Add ethernet clock sources
> > > >   drivers: clk: renesas: r9a07g044-cpg: Add GbEthernet clock/reset
> > >
> > >
> > >    It's not a good idea to have the patch to the defferent subsystems
> > > lumped all together in a single series...
> >
> > Agreed.
> >
> > Are these changes inseparable? If so, you need to be up front on this, and
> > you need an agreement with the subsystem maintainers how the patches are
> > going to be merged? Through which tree. And you need Acked-by from the
> > other tree maintainers.
> >
> > Ideally you submit multiple patchsets. This assumes all sets will compile
> > independently.
>
> Agreed. Will split this patch series in 3 patchsets
>
> 1) single binding patch
>
> 2) Clock patchset
>
> 3) ravb driver patchset.

4) dts part.

Part 2 should pass through renesas-clk.
Part 4 should pass through renesas-devel.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
