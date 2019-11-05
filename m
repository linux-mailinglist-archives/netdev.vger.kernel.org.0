Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2CC3EFB17
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 11:27:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388224AbfKEK1v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 05:27:51 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:40561 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387945AbfKEK1v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 05:27:51 -0500
Received: by mail-lj1-f195.google.com with SMTP id q2so14618660ljg.7
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 02:27:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yt1tSYqLolkj0uvfbdz9Mcn4etEr9rczILc48BAo9gw=;
        b=jxinMdzmTEJ4VftbfTsxtKFPmn/427EEqE1+8dOjM8TczntfP9UXTxH+Se2WDQZFgm
         mhPidW0S4Pi7Gl9TQJNXjFj05cyRQR6nDY6bZVGwlHvCtfPhWopEcn3M0sqUqr+/xa3x
         4jr78oF/Aa/rgl2B2xBuEWar+XJu0HRdsmX32DFXI8NJAB6a6/GklD0/lYHuLbZz5Su4
         ekvAKDONibv89WtIJc3Dj6BDmitCHeHy1E6S41Wrruz11HHJYzyEbhbEy0kgUucdN2zh
         gICBKgh19HzvHUoU1Oua3yXOukVmbC6YaoPBiNJz329NHQqMLRSU2dtZytwwH52WRCV8
         lT6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yt1tSYqLolkj0uvfbdz9Mcn4etEr9rczILc48BAo9gw=;
        b=Yy3bFQJE9BvV38o8uf9APaFtaCAjl08FNNpUieH9Y8jxil9rUXPXJKXUgNpVETE6RQ
         xjUMd4gsHmUIeiPZw++4vAjI8fSzYEfk4VSZvBPj/ruzUjHteHjUviAhmYi+Dz+IjLZC
         rGBtVMCm3SrMtPND6Qf3C883An/Yyet7Zx5StXZM2vPzvFpq9tnBQ6Iz5aTSugVj+2Rh
         LtxFPxT8duD6Hy97pBQlOvtj/MbMnCxPwlIeFND/ql1Koh9M0n6LWg88DMXwOCxHTcV/
         FpfDFIST6dJHAmDqFTIJjHZ8vpgPkaFhQESw2HoZ5S6uz0B6Y90H0FiiNSs7q3X5TJhJ
         D6fw==
X-Gm-Message-State: APjAAAU7ofurBHbuPE5vGJ5uZnAmO6zJTD1hIxaFtQgdEWvlvofwaIL1
        PspAD6GNF2Ond+1uIIrVcNmiLE0SOV6zaO7qXNnpqA==
X-Google-Smtp-Source: APXvYqyzCoxN2wjA1IDBmdX9wEjnVodS0Dm2S27oLDYTAT/s6DQZNkwOqZof/qBlGjpbGyrnuzENkeoKQtzGW4V72YU=
X-Received: by 2002:a2e:a0c9:: with SMTP id f9mr22800572ljm.77.1572949668251;
 Tue, 05 Nov 2019 02:27:48 -0800 (PST)
MIME-Version: 1.0
References: <20191101130224.7964-1-linus.walleij@linaro.org>
 <20191101130224.7964-10-linus.walleij@linaro.org> <20191103.174311.1939967870267945019.davem@davemloft.net>
In-Reply-To: <20191103.174311.1939967870267945019.davem@davemloft.net>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 5 Nov 2019 11:27:36 +0100
Message-ID: <CACRpkdaAyupUrosjWPP0AFOPYh5HXEkEHdew+A9A+yvvd0m2RA@mail.gmail.com>
Subject: Re: [PATCH net-next 09/10 v2] net: ethernet: ixp4xx: Get port ID from
 base address
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 4, 2019 at 2:43 AM David Miller <davem@davemloft.net> wrote:

> From: Linus Walleij <linus.walleij@linaro.org>
> Date: Fri,  1 Nov 2019 14:02:23 +0100
>
> > @@ -1388,13 +1387,15 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
> >       regs_phys = res->start;
> >       port->regs = devm_ioremap_resource(dev, res);
> >
> > -     switch (port->id) {
> > -     case IXP4XX_ETH_NPEA:
> > +     switch (res->start) {
> > +     case 0xc800c000:
>
> This is extremely non-portable.
>
> The resource values are %100 opaque architecture specific values.
>
> On sparc64 for example, it is absolutely not the bus address but rather
> the physical address that the cpu needs to use to perform MMIO's to what
> is behind that resource.
>
> I'm not applying this, sorry.

No problem, I'll think of something better, like adapting
Arnd's approach.

Could you apply patches 1-8?

Yours,
Linus Walleij
