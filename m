Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 901D724E8ED
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 18:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728545AbgHVQtu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 12:49:50 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38310 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727856AbgHVQts (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 22 Aug 2020 12:49:48 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k9WiA-00Aljb-KF; Sat, 22 Aug 2020 18:49:46 +0200
Date:   Sat, 22 Aug 2020 18:49:46 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
Cc:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next 3/3] net: dsa: mv88e6xxx: add support for
 88E6393X from Amethyst family
Message-ID: <20200822164946.GI2347062@lunn.ch>
References: <20200819153816.30834-1-marek.behun@nic.cz>
 <20200819153816.30834-4-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200819153816.30834-4-marek.behun@nic.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> --- a/drivers/net/dsa/mv88e6xxx/port.c
> +++ b/drivers/net/dsa/mv88e6xxx/port.c
> @@ -187,11 +187,16 @@ static int mv88e6xxx_port_set_speed_duplex(struct mv88e6xxx_chip *chip,
>  		ctrl = MV88E6XXX_PORT_MAC_CTL_SPEED_1000;
>  		break;
>  	case 2500:
> -		if (alt_bit)
> -			ctrl = MV88E6390_PORT_MAC_CTL_SPEED_10000 |
> -				MV88E6390_PORT_MAC_CTL_ALTSPEED;
> +		if (chip->info->family == MV88E6XXX_FAMILY_6393)
> +			ctrl = MV88E6XXX_PORT_MAC_CTL_SPEED_1000;
>  		else
>  			ctrl = MV88E6390_PORT_MAC_CTL_SPEED_10000;
> +		if (alt_bit)
> +			ctrl |= MV88E6390_PORT_MAC_CTL_ALTSPEED;
> +		break;
> +	case 5000:
> +		ctrl = MV88E6390_PORT_MAC_CTL_SPEED_10000 |
> +			MV88E6390_PORT_MAC_CTL_ALTSPEED;
>  		break;
>  	case 10000:
>  		/* all bits set, fall through... */

This is getting more and more complex. Maybe it is time to refactor it?

     Andrew
