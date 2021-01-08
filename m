Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC2742EF378
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 14:52:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727262AbhAHNvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 08:51:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:41384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725816AbhAHNvy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 08:51:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0187C239EB;
        Fri,  8 Jan 2021 13:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610113873;
        bh=FsnpMffrFjU8QNG4HSQZDRreCmhoh3nlasLo7s3XS7I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VERne2zeZqNODbmsWrcrVc6gfEzpEYxWJ9xpRrcuYakXHuDIvEW+PmsnL7qyrCZnC
         K5BKupAybKwfGh8IRP4+yiJjjmJweDJDiXjll0tkM48x3IzES9tZhXaWLLqiqrqCgs
         aHxtwLl+HSnSzs3r0uqLbTTRa3i/B817ULeJUgQSxLmD2zIU5CdF4EBKp2E3pd8sh8
         Ji4cSFBD3fAuZ1c8Ugkd55+5fIF0CqwD9Tb9ZaYBZWgDI4pAdxGHSD6ueSEP//5DL7
         k3bkfZ5l+iosEnUwozVaduO3EIeyJR0R71ZEZsKNndc1S55cxkXLYnzVMVZA00ys9o
         EeU0Jd902pURg==
Date:   Fri, 8 Jan 2021 14:51:09 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Pavana Sharma <pavana.sharma@digi.com>
Cc:     andrew@lunn.ch, ashkan.boldaji@digi.com, davem@davemloft.net,
        f.fainelli@gmail.com, kuba@kernel.org, lkp@intel.com,
        netdev@vger.kernel.org, vivien.didelot@gmail.com
Subject: Re: [net-next PATCH v13 4/4] net: dsa: mv88e6xxx: Add support for
 mv88e6393x family of Marvell
Message-ID: <20210108145109.71264cbe@kernel.org>
In-Reply-To: <0044dda2a5d1d03494ff753ee14ed4268f653e9c.1610071984.git.pavana.sharma@digi.com>
References: <cover.1610071984.git.pavana.sharma@digi.com>
        <0044dda2a5d1d03494ff753ee14ed4268f653e9c.1610071984.git.pavana.sharma@digi.com>
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pavana, some last nitpicks, sorry I didn't check this before.

I will send another patch to you which shall fix all this things.

On Fri,  8 Jan 2021 19:50:56 +1000
Pavana Sharma <pavana.sharma@digi.com> wrote:

> +/* Support 10, 100, 200, 1000, 2500, 5000, 10000 Mbps (e.g. 88E6393X)
> + * This function adds new speed 5000 supported by Amethyst family.
> + * Function mv88e6xxx_port_set_speed_duplex() can't be used as the register
> + * values for speeds 2500 & 5000 conflict.
> + */
> +
> +int mv88e6393x_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
> +		int speed, int duplex)

There are basically 2 empty lines between the comment and the function
signature, one containting only comment end token " */" and the other
truly empty. I think you can remove the empty line, since the comment
is already visibly separated from the function body.

I think you can also remove the second line of the comment:
  "This function adds new speed 5000 supported by Amethyst family."
The alignment of the speed argument is wrong. It should start at the
same column as the first argument.

So:

/* Support 10, 100, 200, 1000, 2500, 5000, 10000 Mbps (e.g. 88E6393X)
 * Function mv88e6xxx_port_set_speed_duplex() can't be used as the register
 * values for speeds 2500 & 5000 conflict.
 */
int mv88e6393x_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
				     int speed, int duplex)

> +	reg &= ~(MV88E6XXX_PORT_MAC_CTL_SPEED_MASK |
> +			MV88E6390_PORT_MAC_CTL_ALTSPEED |
> +			MV88E6390_PORT_MAC_CTL_FORCE_SPEED);

alignment:

	reg &= ~(MV88E6XXX_PORT_MAC_CTL_SPEED_MASK |
		 MV88E6390_PORT_MAC_CTL_ALTSPEED |
		 MV88E6390_PORT_MAC_CTL_FORCE_SPEED);

> +static int mv88e6393x_port_policy_write(struct mv88e6xxx_chip *chip, u16 pointer,
> +				u8 data)
> +{
> +
> +	int err = 0;

Unneeded empty line before int err = 0;
Also alignment of the data argument:

static int mv88e6393x_port_policy_write(struct mv88e6xxx_chip *chip, u16 pointer,
				        u8 data)

(It seems to me that you only align with tabs. If you need to align for
 example to 20th column, use 2 tabs and 4 spaces (2*8 + 4 = 20).)

> +int mv88e6393x_port_set_ether_type(struct mv88e6xxx_chip *chip, int port,
> +					u16 etype)

Alignment:
int mv88e6393x_port_set_ether_type(struct mv88e6xxx_chip *chip, int port,
				   u16 etype)

> +#define MV88E6XXX_PORT_STS_CMODE_5GBASER	0x000c
> +#define MV88E6XXX_PORT_STS_CMODE_10GBASER	0x000d
> +#define MV88E6XXX_PORT_STS_CMODE_USXGMII	0x000e

These macros should have prefix
  MV88E6393X_
instead of
  MV88E6XXX_
since these values apply for 6393X family and they conflict with the
values for other switches.

> +int mv88e6xxx_port_wait_bit(struct mv88e6xxx_chip *chip, int port, int reg,
> +		int bit, int val);

Alignment.

> +int mv88e6393x_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
> +					int speed, int duplex);

Alignment.

> +int mv88e6393x_port_set_ether_type(struct mv88e6xxx_chip *chip, int port,
> +				u16 etype);

Alignment.

> +/* Only Ports 0, 9 and 10 have SERDES lanes. Return the SERDES lane address
> + * a port is using else Returns -ENODEV.
> + */
> +int mv88e6393x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
> +{
> +	u8 cmode = chip->ports[port].cmode;
> +	int lane = -ENODEV;
> +
> +	if (port != 0 && port != 9 && port != 10)
> +		return -EOPNOTSUPP;
> +
> +	if (cmode == MV88E6XXX_PORT_STS_CMODE_1000BASEX ||
> +		cmode == MV88E6XXX_PORT_STS_CMODE_SGMII ||
> +		cmode == MV88E6XXX_PORT_STS_CMODE_2500BASEX ||
> +		cmode == MV88E6XXX_PORT_STS_CMODE_5GBASER ||
> +		cmode == MV88E6XXX_PORT_STS_CMODE_10GBASER ||
> +		cmode == MV88E6XXX_PORT_STS_CMODE_USXGMII)

Alignment.

> +		lane = port;
> +	return lane;
> +}

> +int mv88e6393x_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port,
> +				int lane, bool enable)

Alignment.

> +irqreturn_t mv88e6393x_serdes_irq_status(struct mv88e6xxx_chip *chip, int port,
> +					int lane)

Alignment.

> +static int mv88e6393x_serdes_port_config(struct mv88e6xxx_chip *chip, int lane,
> +					bool on)

Alignment.

> +		mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
> +				MV88E6393X_SERDES_POC, &config);
> +		config &= ~(MV88E6393X_SERDES_POC_PCS_MODE_MASK |
> +				MV88E6393X_SERDES_POC_PDOWN);
> +		config |= pcs;
> +		mv88e6390_serdes_write(chip, lane, MDIO_MMD_PHYXS,
> +				MV88E6393X_SERDES_POC, config);
> +		config |= MV88E6393X_SERDES_POC_RESET;
> +		mv88e6390_serdes_write(chip, lane, MDIO_MMD_PHYXS,
> +				MV88E6393X_SERDES_POC, config);
> +
> +		/* mv88e6393x family errata 3.7 :
> +		 * When changing cmode on SERDES port from any other mode to
> +		 * 1000BASE-X mode the link may not come up due to invalid
> +		 * 1000BASE-X advertisement.
> +		 * Workaround: Correct advertisement and reset PHY core.
> +		 */
> +		config = MV88E6390_SGMII_ANAR_1000BASEX_FD;
> +		mv88e6390_serdes_write(chip, lane, MDIO_MMD_PHYXS,
> +				MV88E6390_SGMII_ANAR, config);
> +
> +		/* soft reset the PCS/PMA */
> +		mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
> +				MV88E6390_SGMII_CONTROL, &config);
> +		config |= MV88E6390_SGMII_CONTROL_RESET;
> +		mv88e6390_serdes_write(chip, lane, MDIO_MMD_PHYXS,
> +				MV88E6390_SGMII_CONTROL, config);

Alignment in all calls to mv88e6390_serdes_write.

> +int mv88e6393x_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
> +		    bool on)

Alignment.

> +int mv88e6393x_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
> +		    bool on);

Alignment.

> +int mv88e6393x_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port,
> +	    int lane, bool enable);

Alignment.

> +irqreturn_t mv88e6393x_serdes_irq_status(struct mv88e6xxx_chip *chip, int port,
> +					int lane);

Alignment.
