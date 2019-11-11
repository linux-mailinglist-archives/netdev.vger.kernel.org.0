Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C364F77F7
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 16:44:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727015AbfKKPoa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 10:44:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:37320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726908AbfKKPoa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Nov 2019 10:44:30 -0500
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A5D3222C2
        for <netdev@vger.kernel.org>; Mon, 11 Nov 2019 15:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573487068;
        bh=x7SR6fdBWAz/l54llm+ur+VDErM1R98oI3VyvdUnkrs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=0CqAM1NQ5FcDXdVlDVGNAPQFTMm1f/pI+PXQxRgEiSWyaMzTx2H7K+lQVTu0bPGt5
         eo5C0dT8zcPXVetMUvPzkhIRIyLJE9Pzg9WCAlGIiw6dTgbnXr1jdPi/lcrG9giH45
         GyAy3bmXlP/bgA8+EXu9ewNIKHwX+p3P++PCg7VA=
Received: by mail-qk1-f174.google.com with SMTP id z16so11558368qkg.7
        for <netdev@vger.kernel.org>; Mon, 11 Nov 2019 07:44:28 -0800 (PST)
X-Gm-Message-State: APjAAAVUlHtZ5doQp3UIJrEjfWMd1L66e7I6JdzK19FxSS1u5xElZe0h
        6pheLj4fiSWFVCJKZqy7mJYvG4sF/35AFoYL7w==
X-Google-Smtp-Source: APXvYqxBp0XQw8G1lAZcBjGpep7ojhIMPI0eXcjcWEAN1PpBf/jHS1av7i8zVw/vylKxRSUa4hFBQQiVtToK8tH/gvg=
X-Received: by 2002:ae9:dd83:: with SMTP id r125mr2655352qkf.223.1573487067567;
 Mon, 11 Nov 2019 07:44:27 -0800 (PST)
MIME-Version: 1.0
References: <20191110142226.GB25745@shell.armlinux.org.uk> <E1iTo7N-0005Sj-Nk@rmk-PC.armlinux.org.uk>
 <20191110161307.GC25889@lunn.ch> <20191110164007.GC25745@shell.armlinux.org.uk>
 <20191110170040.GG25889@lunn.ch> <20191111140114.GH25745@shell.armlinux.org.uk>
 <CAL_JsqJe1xUKnREx17vY=Umf9dQimvK7QTqAkunvUxF8GKzjMQ@mail.gmail.com> <20191111150754.GI25745@shell.armlinux.org.uk>
In-Reply-To: <20191111150754.GI25745@shell.armlinux.org.uk>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Mon, 11 Nov 2019 09:44:16 -0600
X-Gmail-Original-Message-ID: <CAL_JsqK5hm6-WJtUBf1don7=iDHC4aAGwFMaJQjzWwyKH4U=fg@mail.gmail.com>
Message-ID: <CAL_JsqK5hm6-WJtUBf1don7=iDHC4aAGwFMaJQjzWwyKH4U=fg@mail.gmail.com>
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

On Mon, Nov 11, 2019 at 9:08 AM Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> On Mon, Nov 11, 2019 at 09:01:22AM -0600, Rob Herring wrote:
> > On Mon, Nov 11, 2019 at 8:01 AM Russell King - ARM Linux admin
> > <linux@armlinux.org.uk> wrote:
> > >
> > > On Sun, Nov 10, 2019 at 06:00:40PM +0100, Andrew Lunn wrote:
> > > > On Sun, Nov 10, 2019 at 04:40:07PM +0000, Russell King - ARM Linux admin wrote:
> > > > > On Sun, Nov 10, 2019 at 05:13:07PM +0100, Andrew Lunn wrote:
> > > > > > On Sun, Nov 10, 2019 at 02:23:05PM +0000, Russell King wrote:
> > > > > > > Add core phylib help for supporting SFP sockets on PHYs.  This provides
> > > > > > > a mechanism to inform the SFP layer about PHY up/down events, and also
> > > > > > > unregister the SFP bus when the PHY is going away.
> > > > > >
> > > > > > Hi Russell
> > > > > >
> > > > > > What does the device tree binding look like? I think you have SFP
> > > > > > proprieties in the PHYs node?
> > > > >
> > > > > Correct, just the same as network devices.  Hmm, however, neither are
> > > > > documented... oh dear, it looks like I need to figure out how this
> > > > > yaml stuff works. :(
> > > >
> > > > Yes, that would be good. I also assume you have at least one DT patch
> > > > for one of the Marvell boards? Seeing that would also help.
> > >
> > > So, how does one make sure that the .yaml files are correct?
> > >
> > > The obvious thing is to use the "dtbs_check" target, described by
> > > Documentation/devicetree/writing-schema.md, but that's far from
> > > trivial.
> >
> > 'dt_binding_check' will check just the bindings. 'dtbs_check' is
> > pretty slow given we have so many dts files and it generates lots of
> > warnings.
> >
> > > First it complained about lack of libyaml development, which is easy
> > > to solve.  Having given it that, "dtbs_check" now complains:
> > >
> > > /bin/sh: 1: dt-doc-validate: not found
> > > /bin/sh: 1: dt-mk-schema: not foundmake[2]: ***
> > > [...Documentation/devicetree/bindings/Makefile:12:
> > > Documentation/devicetree/bindings/arm/stm32/stm32.example.dts] Error 127
> > >
> > > (spot the lack of newline character - which is obviously an entirely
> > > different problem...)
> > >
> > > # apt search dt-doc-validate
> > > Sorting... Done
> > > Full Text Search... Done
> > > # apt search dt-mk-schema
> > > Sorting... Done
> > > Full Text Search... Done
> > >
> > > Searching google, it appears it needs another git repository
> > > (https://github.com/robherring/dt-schema/) from Rob Herring to use
> > > this stuff, which is totally undocumented in the kernel tree.
> >
> > The dependencies are all documented in writing-schema.rst (formerly
> > .md) in the 'Dependencies' section.
> >
> > TL;DR: pip3 install git+https://github.com/devicetree-org/dt-schema.git@master
>
> What is pip3, and where do I get it from (I'm running Debian stable).

apt install python3-pip

This is not in the documentation because it is distro specific.

> # apt search pip3
> Sorting... Done
> Full Text Search... Done
>
> Don't expect people know python.

How about rewording:

'The DT schema project can be installed with pip:'

to this:

'The DT schema project is a Python project and is most easily
installed using the Python package manager "pip":

pip3 install git+https://github.com/devicetree-org/dt-schema.git@master

It is also possible to install by cloning the git repository and
running "setup.py".
'

Googling 'python pip' or 'setup.py' should get folks the rest of the
way if 'pip' or 'setup.py' is new to them.

Rob
