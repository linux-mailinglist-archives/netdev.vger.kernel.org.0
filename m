Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4831F9123
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 14:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbfKLN4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 08:56:03 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:35888 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725947AbfKLN4D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 08:56:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=aIOH3AD5Cngnp8xXdrUPvILP4EAiKUJ0S65j+szD2W0=; b=njhbYA6lhGUyw2wgNDh7i1Qr2D
        0pCjgaU5t4UeplhFiMxQCvp0pgFF8xCj6YJVWj3akWk/HhYgVspACZRIv75lmENi21H+h43tN6bzU
        9OSZpR1LZgCx+AR/eRy6ckL44l82ivLPDIR/1piN8B51Xx5EvpQNdC2bevYkHCDl2Dbo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iUWeF-0001jx-BG; Tue, 12 Nov 2019 14:55:59 +0100
Date:   Tue, 12 Nov 2019 14:55:59 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     jakub.kicinski@netronome.com, davem@davemloft.net,
        alexandre.belloni@bootlin.com, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, horatiu.vultur@microchip.com,
        claudiu.manoil@nxp.com, netdev@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next 07/12] net: mscc: ocelot: separate the
 implementation of switch reset
Message-ID: <20191112135559.GI5090@lunn.ch>
References: <20191112124420.6225-1-olteanv@gmail.com>
 <20191112124420.6225-8-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191112124420.6225-8-olteanv@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 12, 2019 at 02:44:15PM +0200, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The Felix switch has a different reset procedure, so a function pointer
> needs to be created and added to the ocelot_ops structure.
> 
> The reset procedure has been moved into ocelot_init.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/ethernet/mscc/ocelot.c       |  3 ++
>  drivers/net/ethernet/mscc/ocelot.h       |  1 +
>  drivers/net/ethernet/mscc/ocelot_board.c | 37 +++++++++++++++---------

I'm wondering about the name board. So far, the code you have moved
into ocelot_board has nothing to do with the board as such. This is
not a GPIO used to reset the switch, it is not a regulator, etc. It is
all internal to the device, but just differs per family. Maybe you can
think of a better name?

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
