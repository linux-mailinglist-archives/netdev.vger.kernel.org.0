Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47364F774F
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 16:01:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbfKKPBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 10:01:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:52460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726843AbfKKPBg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Nov 2019 10:01:36 -0500
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA6AC206BA
        for <netdev@vger.kernel.org>; Mon, 11 Nov 2019 15:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573484494;
        bh=cwEr/tspmdFrPKtpBMGF3aIaoX30thni7q0LOQa7XiQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=wgxs0Z4FxtrNhAooM9+J3SN5dzeKtMO5OZKTs3ZY4/l+oYeDEvOqam3LC+8ElUK+v
         x7hOBw8hCyXXeYOu95KqMaVRS2rgwN0bMjMHmSv3KRnGGLiwnfaLJDG0CReyKK7YtL
         N8zkkXgTNvO0/Sj083mzlO71JBAyIV48ibgdfIOY=
Received: by mail-qt1-f180.google.com with SMTP id g50so15953476qtb.4
        for <netdev@vger.kernel.org>; Mon, 11 Nov 2019 07:01:34 -0800 (PST)
X-Gm-Message-State: APjAAAU2Gn9YWsB2pGa0y5857Tt+0o+jaj4mghDDSYb9rzQqZ1Pxul+m
        BBcYzHtXwpl+Z1qllp+jpdEy4AoWQn1AoZmezA==
X-Google-Smtp-Source: APXvYqzQ6T3lAVXSz8kXU73Bp7zhVMbvDMJCl3rR6ChpFVzoJYbXIrNQszGr8mbxZNiYy0ImWY7GNsKF5fn4FFlPVtM=
X-Received: by 2002:ac8:73ce:: with SMTP id v14mr26607688qtp.136.1573484493933;
 Mon, 11 Nov 2019 07:01:33 -0800 (PST)
MIME-Version: 1.0
References: <20191110142226.GB25745@shell.armlinux.org.uk> <E1iTo7N-0005Sj-Nk@rmk-PC.armlinux.org.uk>
 <20191110161307.GC25889@lunn.ch> <20191110164007.GC25745@shell.armlinux.org.uk>
 <20191110170040.GG25889@lunn.ch> <20191111140114.GH25745@shell.armlinux.org.uk>
In-Reply-To: <20191111140114.GH25745@shell.armlinux.org.uk>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Mon, 11 Nov 2019 09:01:22 -0600
X-Gmail-Original-Message-ID: <CAL_JsqJe1xUKnREx17vY=Umf9dQimvK7QTqAkunvUxF8GKzjMQ@mail.gmail.com>
Message-ID: <CAL_JsqJe1xUKnREx17vY=Umf9dQimvK7QTqAkunvUxF8GKzjMQ@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] net: phy: add core phylib sfp support
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Frank Rowand <frowand.list@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 11, 2019 at 8:01 AM Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> On Sun, Nov 10, 2019 at 06:00:40PM +0100, Andrew Lunn wrote:
> > On Sun, Nov 10, 2019 at 04:40:07PM +0000, Russell King - ARM Linux admin wrote:
> > > On Sun, Nov 10, 2019 at 05:13:07PM +0100, Andrew Lunn wrote:
> > > > On Sun, Nov 10, 2019 at 02:23:05PM +0000, Russell King wrote:
> > > > > Add core phylib help for supporting SFP sockets on PHYs.  This provides
> > > > > a mechanism to inform the SFP layer about PHY up/down events, and also
> > > > > unregister the SFP bus when the PHY is going away.
> > > >
> > > > Hi Russell
> > > >
> > > > What does the device tree binding look like? I think you have SFP
> > > > proprieties in the PHYs node?
> > >
> > > Correct, just the same as network devices.  Hmm, however, neither are
> > > documented... oh dear, it looks like I need to figure out how this
> > > yaml stuff works. :(
> >
> > Yes, that would be good. I also assume you have at least one DT patch
> > for one of the Marvell boards? Seeing that would also help.
>
> So, how does one make sure that the .yaml files are correct?
>
> The obvious thing is to use the "dtbs_check" target, described by
> Documentation/devicetree/writing-schema.md, but that's far from
> trivial.

'dt_binding_check' will check just the bindings. 'dtbs_check' is
pretty slow given we have so many dts files and it generates lots of
warnings.

> First it complained about lack of libyaml development, which is easy
> to solve.  Having given it that, "dtbs_check" now complains:
>
> /bin/sh: 1: dt-doc-validate: not found
> /bin/sh: 1: dt-mk-schema: not foundmake[2]: ***
> [...Documentation/devicetree/bindings/Makefile:12:
> Documentation/devicetree/bindings/arm/stm32/stm32.example.dts] Error 127
>
> (spot the lack of newline character - which is obviously an entirely
> different problem...)
>
> # apt search dt-doc-validate
> Sorting... Done
> Full Text Search... Done
> # apt search dt-mk-schema
> Sorting... Done
> Full Text Search... Done
>
> Searching google, it appears it needs another git repository
> (https://github.com/robherring/dt-schema/) from Rob Herring to use
> this stuff, which is totally undocumented in the kernel tree.

The dependencies are all documented in writing-schema.rst (formerly
.md) in the 'Dependencies' section.

TL;DR: pip3 install git+https://github.com/devicetree-org/dt-schema.git@master


Rob
