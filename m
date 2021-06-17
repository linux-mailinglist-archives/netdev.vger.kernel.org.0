Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 606483AB38F
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 14:27:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232106AbhFQMaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 08:30:04 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42512 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230039AbhFQMaC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 08:30:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=GiGpZns0Mi4Sb70U2EK/i9ybnYabrH86R/LdMEIJYSA=; b=f6
        Td2aPkoqdNtPvuI+Q/x/GvVGvXuQ1JI2ZluciH9ImRiLYAy8DQ6ItOCDn8vuAAh/ZE4tM85HYsAMu
        IEj4CeRbRpM8jNG8eJjQ5Nsn7X2gc4/QhDiC2EWXiB8UFte9/PhDsLSIYBcfwZ4qmHusuHdaamrg5
        MNRWVfFVhoiHMBQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ltr7f-009tlx-Ov; Thu, 17 Jun 2021 14:27:51 +0200
Date:   Thu, 17 Jun 2021 14:27:51 +0200
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
Subject: Re: [net-next: PATCH v2 3/7] net/fsl: switch to
 fwnode_mdiobus_register
Message-ID: <YMs/xztdc0xhYbDr@lunn.ch>
References: <20210616190759.2832033-1-mw@semihalf.com>
 <20210616190759.2832033-4-mw@semihalf.com>
 <YMpShczKt1TNAqsV@lunn.ch>
 <CAPv3WKde+LCmxxr6UuA7X=XShF6d4io49baxsjw1kMqR=T7XrA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPv3WKde+LCmxxr6UuA7X=XShF6d4io49baxsjw1kMqR=T7XrA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 17, 2021 at 01:39:40AM +0200, Marcin Wojtas wrote:
> śr., 16 cze 2021 o 21:35 Andrew Lunn <andrew@lunn.ch> napisał(a):
> >
> > On Wed, Jun 16, 2021 at 09:07:55PM +0200, Marcin Wojtas wrote:
> > > Utilize the newly added helper routine
> > > for registering the MDIO bus via fwnode_
> > > interface.
> >
> > You need to add depends on FWNODE_MDIO
> >
> 
> Do you mean something like this?
> 
> --- a/drivers/net/ethernet/freescale/Kconfig
> +++ b/drivers/net/ethernet/freescale/Kconfig
> @@ -68,8 +68,8 @@ config FSL_PQ_MDIO
>  config FSL_XGMAC_MDIO
>         tristate "Freescale XGMAC MDIO"
>         select PHYLIB
> -       depends on OF
> -       select OF_MDIO
> +       depends on ACPI || OF
> +       select FWNODE_MDIO
>         help

You should not need depends on ACPI || OF. FWNODE_MDIO implies
that. And there are no direct calls to of_ functions, so you can drop
the depends on OF.

    Andrew
