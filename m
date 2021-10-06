Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1866F42438E
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 18:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239467AbhJFRAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 13:00:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:54172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229992AbhJFRAO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 13:00:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B554E61184;
        Wed,  6 Oct 2021 16:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633539501;
        bh=Pv2GQ9ppIbCDtjJ6FHG8UrZrwL0q5p8yJu6Ox1odcl4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ZxwFTj6h8/4zl+ZbyobZ3gXyH6zFFHuuunpSCeZtGq5yyBh458lN6qgjrPtbzvmEE
         JOOJRKCS+cBjpsGZsFsu2qC7UT2xexuiAP+pKnneMu16nz3F7IlrhMx37GjF8vnwt0
         o61sz2wSwPJd3nZ73vK9cDb7mu9kpL6OH34+xqBitWiiJlEeCZMOz2ORHGj5DzBeHV
         lXnRdLCU5OwkGhGLRRnRM9LBtawkqp+ghPb2wtzyNm0RXi9ToDk7/pzxdw2KZbTxzU
         X/pQ2PLrdiI+gydju+/rHCKwPD4FYD9yeb7qGaLXANvhp6iC/3OhwOMt93GWz9oHi0
         /UKKtVyOralpg==
Received: by mail-ed1-f46.google.com with SMTP id g10so11987533edj.1;
        Wed, 06 Oct 2021 09:58:21 -0700 (PDT)
X-Gm-Message-State: AOAM533dM0l6UJiTdMjGpOF3D/M6sL5L1atLIRlpmJO4Xe5MpZ8aOPW8
        6BSSGDHodG+y8bKM3kL7ZwDbVnkUWkuaBV3Q1A==
X-Google-Smtp-Source: ABdhPJwMHkUzUgd0cGA2QXNsXv0uRtztN2UbQ2gOCNuLs32mPBDjNqEd6cAB6lIHngB5ur8nwNpG3ntFDOFsttuDTVQ=
X-Received: by 2002:a50:d903:: with SMTP id t3mr35230363edj.70.1633539499069;
 Wed, 06 Oct 2021 09:58:19 -0700 (PDT)
MIME-Version: 1.0
References: <20211006154426.3222199-1-kuba@kernel.org> <20211006154426.3222199-2-kuba@kernel.org>
 <CAL_JsqK6YzaD0wB0BsP5tghnYMbZzDHq2p6Z_ZGr99EFWhWggw@mail.gmail.com> <YV3QAzAWiYdKFB3m@lunn.ch>
In-Reply-To: <YV3QAzAWiYdKFB3m@lunn.ch>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Wed, 6 Oct 2021 11:58:07 -0500
X-Gmail-Original-Message-ID: <CAL_JsqLRQRmhXZm25WKzUSBUyK6q5d-BspW4zQcztW3Qf56EKg@mail.gmail.com>
Message-ID: <CAL_JsqLRQRmhXZm25WKzUSBUyK6q5d-BspW4zQcztW3Qf56EKg@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/9] of: net: move of_net under net/
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Saravana Kannan <saravanak@google.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Frank Rowand <frowand.list@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 6, 2021 at 11:34 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Wed, Oct 06, 2021 at 11:18:19AM -0500, Rob Herring wrote:
> > On Wed, Oct 6, 2021 at 10:45 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > >
> > > Rob suggests to move of_net.c from under drivers/of/ somewhere
> > > to the networking code.
> > >
> > > Suggested-by: Rob Herring <robh@kernel.org>
> > > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > > ---
> > > v2: new patch
> > > ---
> > >  drivers/of/Makefile               | 1 -
> > >  net/core/Makefile                 | 1 +
> > >  {drivers/of => net/core}/of_net.c | 0
> > >  3 files changed, 1 insertion(+), 1 deletion(-)
> > >  rename {drivers/of => net/core}/of_net.c (100%)
> > >
> > > diff --git a/drivers/of/Makefile b/drivers/of/Makefile
> > > index c13b982084a3..e0360a44306e 100644
> > > --- a/drivers/of/Makefile
> > > +++ b/drivers/of/Makefile
> > > @@ -7,7 +7,6 @@ obj-$(CONFIG_OF_EARLY_FLATTREE) += fdt_address.o
> > >  obj-$(CONFIG_OF_PROMTREE) += pdt.o
> > >  obj-$(CONFIG_OF_ADDRESS)  += address.o
> > >  obj-$(CONFIG_OF_IRQ)    += irq.o
> > > -obj-$(CONFIG_OF_NET)   += of_net.o
> > >  obj-$(CONFIG_OF_UNITTEST) += unittest.o
> > >  obj-$(CONFIG_OF_RESERVED_MEM) += of_reserved_mem.o
> > >  obj-$(CONFIG_OF_RESOLVE)  += resolver.o
> > > diff --git a/net/core/Makefile b/net/core/Makefile
> > > index 35ced6201814..37b1befc39aa 100644
> > > --- a/net/core/Makefile
> > > +++ b/net/core/Makefile
> > > @@ -36,3 +36,4 @@ obj-$(CONFIG_FAILOVER) += failover.o
> > >  obj-$(CONFIG_NET_SOCK_MSG) += skmsg.o
> > >  obj-$(CONFIG_BPF_SYSCALL) += sock_map.o
> > >  obj-$(CONFIG_BPF_SYSCALL) += bpf_sk_storage.o
> > > +obj-$(CONFIG_OF_NET)   += of_net.o
> >
> > The OF_NET kconfig should move or disappear too. I imagine you can do just:
>
> It is used in a few places:

Okay, then just move it for now.

I suspect though that most of these can either be dropped or replaced
with just 'OF' dependency.

> net/ethernet/litex/Kconfig:     depends on OF_NET
> net/ethernet/amd/Kconfig:       depends on ((OF_NET && OF_ADDRESS) || ACPI || PCI) && HAS_IOMEM

If the driver depends on OF or ACPI, then the dependency should just
be removed because one of those is almost always enabled.

> net/ethernet/mscc/Kconfig:      depends on OF_NET
> net/ethernet/ezchip/Kconfig:    depends on OF_IRQ && OF_NET
> net/ethernet/arc/Kconfig:       depends on OF_IRQ && OF_NET
> net/ethernet/arc/Kconfig:       depends on OF_IRQ && OF_NET && REGULATOR

I don't see any OF_IRQ dependency (which would be odd). The OF_NET
dependency is just of_get_phy_mode() from a quick glance and we have a
stub for it.

Rob
