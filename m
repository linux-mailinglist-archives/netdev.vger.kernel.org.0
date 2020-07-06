Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 966202155B3
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 12:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728929AbgGFKiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 06:38:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:53012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728575AbgGFKiQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jul 2020 06:38:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8223B2070B;
        Mon,  6 Jul 2020 10:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594031895;
        bh=h5TXX6vjBsQwJbZ4vh38iLP1VgHYe6MmQWYNUnq/WcI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F74LoH7baSKWcHF2GGEvmZBeB7PsVnPifoM9M6fg0d8UgPWEuHrrX1dQtnipUidfu
         sVXfNWHxvE0Y5jXb6ijtLCSpRSzTA+zpQdcQyCEGzmtIg8sDAVT+S6oTKKsF/szX16
         TJpCMzBkcO2nCFY73414vWqm17CAPQp/eHl5r/RY=
Date:   Mon, 6 Jul 2020 12:38:12 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Robert Richter <rrichter@marvell.com>,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: Re: [PATCH net-next 7/7] net: phy: mdio-octeon: Cleanup module
 loading dependencies
Message-ID: <20200706103812.GA11800@kroah.com>
References: <20200705182921.887441-1-andrew@lunn.ch>
 <20200705182921.887441-8-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200705182921.887441-8-andrew@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 05, 2020 at 08:29:21PM +0200, Andrew Lunn wrote:
> To ensure that the octoen MDIO driver has been loaded, the Cavium
> ethernet drivers reference a dummy symbol in the MDIO driver. This
> forces it to be loaded first. And this symbol has not been cleanly
> implemented, resulting in warnings when build W=1 C=1.
> 
> Since device tree is being used, and a phandle points to the PHY on
> the MDIO bus, we can make use of deferred probing. If the PHY fails to
> connect, it should be because the MDIO bus driver has not loaded
> yet. Return -EPROBE_DEFER so it will be tried again later.
> 
> Cc: Sunil Goutham <sgoutham@marvell.com>
> Cc: Robert Richter <rrichter@marvell.com>
> Cc: Chris Packham <chris.packham@alliedtelesis.co.nz>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
