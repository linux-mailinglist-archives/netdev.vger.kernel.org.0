Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B46C94242C6
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 18:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234705AbhJFQgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 12:36:25 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52602 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235957AbhJFQgX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 12:36:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=M7ourfR7N3IREsZHWkmqZNuXaEfP+RZhu9KUMFheoaQ=; b=olYX4XZNKj5XTuB2L4XSCVljGC
        eA6Lu3jv+5rZr4Y6hdPVyg6bie9iLsYzdp6XtkJ+4crUwXhmlhEMboo7rQwPaiM+BST6qDXEzlPmg
        HsfyLloe1knYy8y/deIMNYttKHUrUzAVfZiR7F8ngu2tK8TBo2pCMYBBjaPFR2E5SEy8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mY9rv-009rE7-1T; Wed, 06 Oct 2021 18:34:11 +0200
Date:   Wed, 6 Oct 2021 18:34:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Rob Herring <robh+dt@kernel.org>
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
Subject: Re: [PATCH net-next v2 1/9] of: net: move of_net under net/
Message-ID: <YV3QAzAWiYdKFB3m@lunn.ch>
References: <20211006154426.3222199-1-kuba@kernel.org>
 <20211006154426.3222199-2-kuba@kernel.org>
 <CAL_JsqK6YzaD0wB0BsP5tghnYMbZzDHq2p6Z_ZGr99EFWhWggw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_JsqK6YzaD0wB0BsP5tghnYMbZzDHq2p6Z_ZGr99EFWhWggw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 06, 2021 at 11:18:19AM -0500, Rob Herring wrote:
> On Wed, Oct 6, 2021 at 10:45 AM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > Rob suggests to move of_net.c from under drivers/of/ somewhere
> > to the networking code.
> >
> > Suggested-by: Rob Herring <robh@kernel.org>
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > ---
> > v2: new patch
> > ---
> >  drivers/of/Makefile               | 1 -
> >  net/core/Makefile                 | 1 +
> >  {drivers/of => net/core}/of_net.c | 0
> >  3 files changed, 1 insertion(+), 1 deletion(-)
> >  rename {drivers/of => net/core}/of_net.c (100%)
> >
> > diff --git a/drivers/of/Makefile b/drivers/of/Makefile
> > index c13b982084a3..e0360a44306e 100644
> > --- a/drivers/of/Makefile
> > +++ b/drivers/of/Makefile
> > @@ -7,7 +7,6 @@ obj-$(CONFIG_OF_EARLY_FLATTREE) += fdt_address.o
> >  obj-$(CONFIG_OF_PROMTREE) += pdt.o
> >  obj-$(CONFIG_OF_ADDRESS)  += address.o
> >  obj-$(CONFIG_OF_IRQ)    += irq.o
> > -obj-$(CONFIG_OF_NET)   += of_net.o
> >  obj-$(CONFIG_OF_UNITTEST) += unittest.o
> >  obj-$(CONFIG_OF_RESERVED_MEM) += of_reserved_mem.o
> >  obj-$(CONFIG_OF_RESOLVE)  += resolver.o
> > diff --git a/net/core/Makefile b/net/core/Makefile
> > index 35ced6201814..37b1befc39aa 100644
> > --- a/net/core/Makefile
> > +++ b/net/core/Makefile
> > @@ -36,3 +36,4 @@ obj-$(CONFIG_FAILOVER) += failover.o
> >  obj-$(CONFIG_NET_SOCK_MSG) += skmsg.o
> >  obj-$(CONFIG_BPF_SYSCALL) += sock_map.o
> >  obj-$(CONFIG_BPF_SYSCALL) += bpf_sk_storage.o
> > +obj-$(CONFIG_OF_NET)   += of_net.o
> 
> The OF_NET kconfig should move or disappear too. I imagine you can do just:

It is used in a few places:

net/ethernet/litex/Kconfig:	depends on OF_NET
net/ethernet/amd/Kconfig:	depends on ((OF_NET && OF_ADDRESS) || ACPI || PCI) && HAS_IOMEM
net/ethernet/mscc/Kconfig:	depends on OF_NET
net/ethernet/ezchip/Kconfig:	depends on OF_IRQ && OF_NET
net/ethernet/arc/Kconfig:	depends on OF_IRQ && OF_NET
net/ethernet/arc/Kconfig:	depends on OF_IRQ && OF_NET && REGULATOR

so it cannot just disappear. These will need reviewing and changing as
well.

	Andrew
