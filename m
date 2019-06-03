Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE3433318
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 17:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729357AbfFCPG0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 11:06:26 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50754 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729081AbfFCPG0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jun 2019 11:06:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=HVCAKnGE2o6vcUDUe+ngXqRsklPv7HNwpc9aiFTjxqY=; b=tPEEj9eo0d/eQNi5ewgQrBGxFP
        GQsLe/xdWnEr2bRxVObacb7/WZlL7Cnmry6dWAs75DziNxOi486Eqc7Ge73JRDNkcEp6wEqbacgKU
        J9kdRbEtsvrUPrBN88a7uEK6mHjxIWbahGlf6xPFNrbyz5zFJ7UFnndMZqvt1qmB1J5w=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hXoXV-000612-Ku; Mon, 03 Jun 2019 17:06:21 +0200
Date:   Mon, 3 Jun 2019 17:06:21 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rasmus Villemoes <Rasmus.Villemoes@prevas.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v3 07/10] net: dsa: mv88e6xxx: implement
 port_link_state for mv88e6250
Message-ID: <20190603150621.GF19627@lunn.ch>
References: <20190603144112.27713-1-rasmus.villemoes@prevas.dk>
 <20190603144112.27713-8-rasmus.villemoes@prevas.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190603144112.27713-8-rasmus.villemoes@prevas.dk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 03, 2019 at 02:42:20PM +0000, Rasmus Villemoes wrote:
> The mv88e6250 has a rather different way of reporting the link, speed
> and duplex status. A simple difference is that the link bit is bit 12
> rather than bit 11 of the port status register.
> 
> It gets more complicated for speed and duplex, which do not have
> separate fields. Instead, there's a four-bit PortMode field, and
> decoding that depends on whether it's a phy or mii port. For the phy
> ports, only four of the 16 values have defined meaning; the rest are
> called "reserved", so returning {SPEED,DUPLEX}_UNKNOWN seems
> reasonable.
> 
> For the mii ports, most possible values are documented (0x3 and 0x5
> are reserved), but I'm unable to make sense of them all. Since the
> bits simply reflect the Px_MODE[3:0] configuration pins, just support
> the subset that I'm certain about. Support for other setups can be
> added later.

The code looks sensible and covers the most likely scenarios.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
