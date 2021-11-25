Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5DA745DD9F
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 16:39:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356113AbhKYPmx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 10:42:53 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:52228 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241585AbhKYPkx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 10:40:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=rfKCUy4qXuilF9CuB+H/UhAr2rnyjJAJ6sI2EgS68N4=; b=Z5
        7c9enMvFuZbqV+UbA9HfCPMXXvkOPDAOMyiL6PvZ8BvPAqJYaeGMF7iGiQqcXMiaTCl/QSH4cas1l
        OQwq+HQ403W55LLtOcNuGag0RaA3wnLk4KuYXi+9S0i8I+gHN5UnL45mi5a9h2OR2enO17XFr7zlQ
        vALptQYGNCAhH68=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mqGoe-00Echx-9C; Thu, 25 Nov 2021 16:37:40 +0100
Date:   Thu, 25 Nov 2021 16:37:40 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: Disable AN on 2500base-x for
 Amethyst
Message-ID: <YZ+txKp0sAOjQUka@lunn.ch>
References: <20211125144359.18478-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211125144359.18478-1-kabel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 25, 2021 at 03:43:59PM +0100, Marek Behún wrote:
> Amethyst does not support autonegotiation in 2500base-x mode.

Hi Marek

I tried to avoid using Marvells internal names for these devices. I
don't think these names exist in the datasheet? They are visible in
the SDK, but that is not so widely available. So if you do want to use
these names, please also reference the name we use in the kernel,
mv88e6393x.

> It does not link with AN enabled with other devices.
> Disable autonegotiation for Amethyst in 2500base-x mode.
> 
> +int mv88e6393x_serdes_pcs_config(struct mv88e6xxx_chip *chip, int port,
> +				 int lane, unsigned int mode,
> +				 phy_interface_t interface,
> +				 const unsigned long *advertise)
> +{
> +	if (interface == PHY_INTERFACE_MODE_2500BASEX)
> +		return 0;
> +
> +	return mv88e6390_serdes_pcs_config(chip, port, lane, mode, interface,
> +					   advertise);
> +}

What happens when changing from say 1000BaseX to 2500BaseX? Do you
need to disable the advertisement which 1000BaseX might of enabled?

     Andrew
