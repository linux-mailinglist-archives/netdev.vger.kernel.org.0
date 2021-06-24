Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA7C73B2481
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 03:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbhFXB0y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 21:26:54 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52734 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229758AbhFXB0x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Jun 2021 21:26:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=jVNl6CYZ01C5i4KBiOlGFn8//idNYh9yzFXxk2AnPuQ=; b=am
        1v1G+/9ktIZjtXECprM9EcvCf16/b1RAJ+Y2ThcFk/IFEXf8qRh1LfpMjTD1LcUyeSp6hR4mxNFzB
        +mCRc+Ys3EAC1CPRXVWnPplak+/BWbY+I+rr4hsTezt20lvxhJathWEVojr/LddoOfLBC6PGFKgOK
        64yGtaYe+27Z9gM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lwE6b-00Aux1-0D; Thu, 24 Jun 2021 03:24:33 +0200
Date:   Thu, 24 Jun 2021 03:24:32 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Grzegorz Bernacki <gjb@semihalf.com>, upstream@semihalf.com,
        Samer El-Haj-Mahmoud <Samer.El-Haj-Mahmoud@arm.com>,
        Jon Nettleton <jon@solid-run.com>,
        Tomasz Nowicki <tn@semihalf.com>, rjw@rjwysocki.net,
        lenb@kernel.org
Subject: Re: [net-next: PATCH v3 4/6] net: mvmdio: add ACPI support
Message-ID: <YNPe0JyCuHxOQBPZ@lunn.ch>
References: <20210621173028.3541424-1-mw@semihalf.com>
 <20210621173028.3541424-5-mw@semihalf.com>
 <YNOZfB4pBRrOYETA@lunn.ch>
 <CAPv3WKc5G07Te2yK+zJo=M0w-fmPVDZ3_YgNoO-BbssWHLtU7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPv3WKc5G07Te2yK+zJo=M0w-fmPVDZ3_YgNoO-BbssWHLtU7Q@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 23, 2021 at 11:58:14PM +0200, Marcin Wojtas wrote:
> śr., 23 cze 2021 o 22:28 Andrew Lunn <andrew@lunn.ch> napisał(a):
> >
> > On Mon, Jun 21, 2021 at 07:30:26PM +0200, Marcin Wojtas wrote:
> > > This patch introducing ACPI support for the mvmdio driver by adding
> > > acpi_match_table with two entries:
> > >
> > > * "MRVL0100" for the SMI operation
> > > * "MRVL0101" for the XSMI mode
> >
> > Same as the freescale MDIO bus driver, you should add
> >
> > depends on FWNODE_MDIO
> >
> > Otherwise you might find randconfig builds end up with it disabled,
> > and then linker errors.
> >
> 
> The CONFIG_MVMDIO is selected by CONFIG_MV643XX_ETH and actually there
> is a real example of the previously discussed fallback to the
> mdiobus_register() (without DT/ACPI and now FWNODE_MDIO). I just
> checked and successfully built the kernel out of the dove_defconfig. I
> only needed below fix, that will be submitted in v4:

You could be correct, but i've seen randconfig builds find issues. So
i tend to add dependencies to avoid possible problems.  Such problem
reports tend to come weeks later, when Arnd does such builds.

	Andrew
