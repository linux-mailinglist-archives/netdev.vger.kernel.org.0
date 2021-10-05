Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA957422825
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 15:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235074AbhJENpE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 09:45:04 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49868 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235002AbhJENpC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 09:45:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ovSUEtGPSxl/nybmRBxSi47cRQoVCb66ArRug3qzPRw=; b=o9FkshonziVohapuf/ejhvec8/
        4qy9q6yDuA2BH/3dV13boXtdKffTyuWuI074YfiFVnRA/pGrAEhzsZ4oUBj2y0TCCUFByPPmORCoI
        Mw7zGb/HvUtgF5aSCvi6lx8hKFK44Hg+5r8jjkuDBrn04lSEjutqL6ZVBFGycsepePdY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mXkio-009hJZ-83; Tue, 05 Oct 2021 15:43:06 +0200
Date:   Tue, 5 Oct 2021 15:43:06 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Sean Anderson <sean.anderson@seco.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [RFC net-next PATCH 06/16] net: phylink: Add function for
 optionally adding a PCS
Message-ID: <YVxWaif9jE/fCE0O@lunn.ch>
References: <20211004191527.1610759-1-sean.anderson@seco.com>
 <20211004191527.1610759-7-sean.anderson@seco.com>
 <YVwgKnxuOeZC6IxW@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YVwgKnxuOeZC6IxW@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 05, 2021 at 10:51:38AM +0100, Russell King (Oracle) wrote:
> On Mon, Oct 04, 2021 at 03:15:17PM -0400, Sean Anderson wrote:
> > This adds a function to set the PCS only if there is not one currently
> > set. The intention here is to allow MAC drivers to have a "default" PCS
> > (such as an internal one) which may be used when one has not been set
> > via the device tree. This allows for backwards compatibility for cases
> > where a PCS was automatically attached if necessary.
> 
> I'm not sure I entirely like this approach. Why can't the network
> driver check for the pcs-handle property and avoid using its
> "default" if present?

And that would also be in line with

ethernet/freescale/dpaa2/dpaa2-mac.c:	node = fwnode_find_reference(dpmac_node, "pcs-handle", 0);

We need a uniform meaning of pcs-handle. And dpaa2-mac.c has set the
precedent that the MAC uses it, not phylink. That can however be
changed, if it make sense, but both users should do the same.

	 Andrew
