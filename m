Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE163A5A28
	for <lists+netdev@lfdr.de>; Sun, 13 Jun 2021 21:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232052AbhFMTWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Jun 2021 15:22:14 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33784 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231912AbhFMTWN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 13 Jun 2021 15:22:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=b+44vKs6VriBl5euKFeZE0tFHHDGn+m9x2DT4kAxVlI=; b=SbxmZ24OJykt28WsfYLMGUq/lV
        YHXkl/CsWs8O+1XAXJ2EDQ+0p/LmbkwU8Lbu2SMF1UNt8vZ18FeNMquIQzMC4FZCK1Dy7mEX+2Vzi
        q46496XbqHG+HqMu+xHyHRet8DeCxas4epEEq0gHJbk217G4G6iMb+BUy7lx2cz2iGvA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lsVeR-009Bnd-Ny; Sun, 13 Jun 2021 21:20:07 +0200
Date:   Sun, 13 Jun 2021 21:20:07 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
        jaz@semihalf.com, gjb@semihalf.com, upstream@semihalf.com,
        Samer.El-Haj-Mahmoud@arm.com, jon@solid-run.com
Subject: Re: [net-next: PATCH 1/3] net: mvmdio: add ACPI support
Message-ID: <YMZaZx3oZ7tYCEPH@lunn.ch>
References: <20210613183520.2247415-1-mw@semihalf.com>
 <20210613183520.2247415-2-mw@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210613183520.2247415-2-mw@semihalf.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -	ret = of_mdiobus_register(bus, pdev->dev.of_node);
> +	if (pdev->dev.of_node)
> +		ret = of_mdiobus_register(bus, pdev->dev.of_node);
> +	else if (is_acpi_node(pdev->dev.fwnode))
> +		ret = acpi_mdiobus_register(bus, pdev->dev.fwnode);
> +	else
> +		ret = -EINVAL;


This seems like something which could be put into fwnode_mdio.c.

     Andrew
