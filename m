Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A2A642466B
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 21:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238898AbhJFTEt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 15:04:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:54792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229564AbhJFTEs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 15:04:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF3A1611C6;
        Wed,  6 Oct 2021 19:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633546975;
        bh=DxiX84ET7gi0KSf7MLiFGcfKZcbIEHwGNxmgykcGuBI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=GWtHL3HsVsggAK5Z0j1ZtFQhSgvj8+Uj3zOxOjZq6bR0Vlw+Eh8eU6uVXXLoS1U2l
         woN4Ndrie2zAV9fCdPWGzFZkCQazUs95eRU1/n1/VLTOhVvKyjG6BJYV9MBlTXJNwS
         6fqD3DfQQTYPKm+ua7t33ECr7Tf6tbEpsF8lvrKji4eZAAamJPNw+Bc/fBCIcKSesR
         cb6kKlouaTAIan/l1rJQsjKF65vOnyvaYjoU7ek1shB8xKX1JAYniZoH5LSUqq8cpS
         P/23Bxn6inAXR4u+PbWRpp529v1z3Zs6rSh2NsKm18tEhWrpQ4TY7Mg9wQ21SKeLDF
         GvHJypKWdpO+w==
Received: by mail-ed1-f47.google.com with SMTP id g8so13585002edt.7;
        Wed, 06 Oct 2021 12:02:55 -0700 (PDT)
X-Gm-Message-State: AOAM530mlB1A0HFCXDkY/RCqYys/6wPLP/kZbwzWUuWP+n9Gp3rAfDkQ
        hYg/oZigO7ZCmXynPnYasbzdfECIUmUy9R05sg==
X-Google-Smtp-Source: ABdhPJxPhoRzhOLtW/Zb9nB1Y+liMFNKBNdABFZe6ELJ8Z4pfZRd9ekEn0nvhAanuMAlyJYlDJ2eqKe5iG/3oHi3nVM=
X-Received: by 2002:a17:906:7250:: with SMTP id n16mr33162419ejk.147.1633546974326;
 Wed, 06 Oct 2021 12:02:54 -0700 (PDT)
MIME-Version: 1.0
References: <20211006154426.3222199-1-kuba@kernel.org> <20211006154426.3222199-2-kuba@kernel.org>
 <CAL_JsqK6YzaD0wB0BsP5tghnYMbZzDHq2p6Z_ZGr99EFWhWggw@mail.gmail.com>
 <YV3QAzAWiYdKFB3m@lunn.ch> <CAL_JsqLRQRmhXZm25WKzUSBUyK6q5d-BspW4zQcztW3Qf56EKg@mail.gmail.com>
 <20211006101203.4337e9a4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211006101203.4337e9a4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Wed, 6 Oct 2021 14:02:42 -0500
X-Gmail-Original-Message-ID: <CAL_JsqK81knMX5i2DJDsxEALFjwoj3pijjT9ZMJ73aOCjYFhMQ@mail.gmail.com>
Message-ID: <CAL_JsqK81knMX5i2DJDsxEALFjwoj3pijjT9ZMJ73aOCjYFhMQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/9] of: net: move of_net under net/
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>,
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

On Wed, Oct 6, 2021 at 12:12 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 6 Oct 2021 11:58:07 -0500 Rob Herring wrote:
> > On Wed, Oct 6, 2021 at 11:34 AM Andrew Lunn <andrew@lunn.ch> wrote:
> > >
> > > On Wed, Oct 06, 2021 at 11:18:19AM -0500, Rob Herring wrote:
> > > > The OF_NET kconfig should move or disappear too. I imagine you can do just:
> > >
> > > It is used in a few places:
> >
> > Okay, then just move it for now.
> >
> > I suspect though that most of these can either be dropped or replaced
> > with just 'OF' dependency.
>
> I have something that builds with allmodconfig :) see below.

Sparc is the arch to try. That's generally we we get tripped up with OF options.

> > > net/ethernet/litex/Kconfig:     depends on OF_NET
> > > net/ethernet/amd/Kconfig:       depends on ((OF_NET && OF_ADDRESS) || ACPI || PCI) && HAS_IOMEM
> >
> > If the driver depends on OF or ACPI, then the dependency should just
> > be removed because one of those is almost always enabled.
>
> I assumed any OF_* implies OF so just dropping OF_NET.
>
> > > net/ethernet/mscc/Kconfig:      depends on OF_NET
> > > net/ethernet/ezchip/Kconfig:    depends on OF_IRQ && OF_NET
> > > net/ethernet/arc/Kconfig:       depends on OF_IRQ && OF_NET
> > > net/ethernet/arc/Kconfig:       depends on OF_IRQ && OF_NET && REGULATOR
> >
> > I don't see any OF_IRQ dependency (which would be odd). The OF_NET
> > dependency is just of_get_phy_mode() from a quick glance and we have a
> > stub for it.
>
> Hm. Indeed on the OF_IRQ.
>
> net/ethernet/arc/ has irq_of_parse_and_map()

Ah right, but there is a stub for that. The preference is to use
platform_get_irq() instead of irq_of_parse_and_map(), then the OF_IRQ
dependency would really be gone.

> but I don't see the need in ezchip, but that seems like a separate matter...
