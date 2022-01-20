Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBCAB495380
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 18:47:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232391AbiATRrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 12:47:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231192AbiATRrG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 12:47:06 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A7E3C061574
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 09:47:05 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id h23so5888524pgk.11
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 09:47:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xnBXxE8aeT6sj3KYzKPBeQ765OlOotkG3CbzXaEL2V8=;
        b=LJh8WZY2BrEny2MPFD7Z5cXuX92gLPknSSFhzcx2j/ZKuzTb9w/UFsLoNirQB0/0zP
         i8Q/7Z8Kgp/2hLGSqKNpmcOq/nAGe3K7bLZfG2qu9a57OG6+57xoIuBBxBcBnDVB6Tte
         RPP7DQqstuLJHt4DR0o2npy7f8PpK+I9O7h5A/D+L3lKn9rjz+N3JbT1Z7SwGDY15JBm
         0MsNFpc0UiblahfYdgD86VYvuLcqQcFP0YORt2YqG1+wiq4jF36BSwEncs5nDyQ5Wvzu
         cwmC2cTNHnFA7atQTUe+Gf3cMN/K75pbMhFoWKO0xSmB8PZXKcLuqVKdmpPzdjkkszee
         CUdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xnBXxE8aeT6sj3KYzKPBeQ765OlOotkG3CbzXaEL2V8=;
        b=rnyVlz8Sv3cwhTYSjf7b+X2zrWAUtbR4gcE22ECpjji1qnyw8uXKwXSFLg81wduDDW
         1HRC3Bz3I04V4F/v9Jx/9K5M2Qgc3bWUqjQS8Hm8IG9qIJleB3gtWrTokhQ5KXpv8apb
         lJhKdronEVjYxZRZUXcPIRvTTjQp5XHTX/7H3fIK+tRIiw3FGXKnGRoTP2HwY75yulO/
         inbq1jNCC9JNdE0NI+XZi9ZaWf4esFukURIwqvBsJ9q7uefXqWhJ1nUsr19pyLPjazgP
         OoJTjYsK+O0pYjOoXHk4Z8e2fl/ZAfUfW8x7dZ5TZ9gXoEzAye1yRW9LGk/bCMbyIrPA
         ASsA==
X-Gm-Message-State: AOAM533QOjQMQ3xAdog3iKTPoSwkOICgfMgZntVnBtELMumLWm90xojq
        sMIDentqSAsTE5vBkXbdrbzRGTrmE3UJwWOS7uvrdY7Dpub2TA==
X-Google-Smtp-Source: ABdhPJwikf1ZBLQbW5g/ubtsmG4fvpgy9h0SwddHeg8bp0VvBt7u0xpJzpyesopW5bzClesFHx2x7VzYDLlEKpNtGZ4=
X-Received: by 2002:a63:40c5:: with SMTP id n188mr32778429pga.118.1642700824763;
 Thu, 20 Jan 2022 09:47:04 -0800 (PST)
MIME-Version: 1.0
References: <20220105031515.29276-1-luizluca@gmail.com> <20220120143630.rimb2y74h2hxueg5@skbuf>
In-Reply-To: <20220120143630.rimb2y74h2hxueg5@skbuf>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Thu, 20 Jan 2022 14:46:53 -0300
Message-ID: <CAJq09z6=NERBGvAfSPYW=w0nJq7odmkFx4dPz_XAhsYPu+uJ1w@mail.gmail.com>
Subject: Re: [PATCH net-next v4 00/11] net: dsa: realtek: MDIO interface and RTL8367S
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Frank Wunderlich <frank-w@public-files.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Wed, Jan 05, 2022 at 12:15:04AM -0300, Luiz Angelo Daros de Luca wrote:
> > The old realtek-smi driver was linking subdrivers into a single
> > realtek-smi.ko After this series, each subdriver will be an independent
> > module required by either realtek-smi (platform driver) or the new
> > realtek-mdio (mdio driver). Both interface drivers (SMI or MDIO) are
> > independent, and they might even work side-by-side, although it will be
> > difficult to find such device. The subdriver can be individually
> > selected but only at buildtime, saving some storage space for custom
> > embedded systems.
> >
> > Existing realtek-smi devices continue to work untouched during the
> > tests. The realtek-smi was moved into a realtek subdirectory, but it
> > normally does not break things.
> >
> > I couldn't identify a fixed relation between port numbers (0..9) and
> > external interfaces (0..2), and I'm not sure if it is fixed for each
> > chip version or a device configuration. Until there is more info about
> > it, there is a new port property "realtek,ext-int" that can inform the
> > external interface.
>
> Generally it isn't a good idea to put in the device tree things that you
> don't understand. The reason being that you'd have to support those
> device tree bindings even when you do understand those things. A device
> tree blob has a separate lifetime compared to the kernel image, so a new
> kernel image would have to support the device trees in circulation which
> have this realtek,ext-int property.
>
> Can you use a fixed relationship between the port number and the
> external interface in the driver, until it is proven that this info
> cannot be known statically or by reading some device configuration?

Thanks, Vladimir. OK. I'll make it automatically defined. I dug again
into the realtek driver and I might be able to remove that property.
There are just a couple of situations that I might select based on
chip_id/version.

BTW, Should I split the series in two, submitting the already consensus patch?

Luiz
