Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB20E3A2C75
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 15:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbhFJNH4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 09:07:56 -0400
Received: from mail-ej1-f53.google.com ([209.85.218.53]:35773 "EHLO
        mail-ej1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230130AbhFJNH4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 09:07:56 -0400
Received: by mail-ej1-f53.google.com with SMTP id h24so44103218ejy.2;
        Thu, 10 Jun 2021 06:05:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=K6VXaindFtCwAZtvv0RXJAabylRODYZL67Vrdekvpic=;
        b=K4MFo3atErEEdiu/639637sRdcUNUB/NtGXl+k+8nuxC7KrzBj880zHxvUGPPUXb/d
         rcD3GR752rK/Lav/aH7ZvBQ9MISsAWTeaf8syuDkLHZudzeBbZEbgyLmc+OiV3c35RtH
         E1WcEgSZiehJyW3RnmXBTbxg+2lcWMteOhd80LPAk0Apn3wV9iQH+4prLf3swvTcTjVd
         NTo08DBvt5m2FWvpadGcej+/UEl3PfRgCt2u3jPTmhl9Aba5yCJMb/QdRBaI2/Ytb8Lk
         1Q5BFoyYsKn3iOdk9ucaftjhw2pBqtCW6zIuHxn/evuivLqcIcwYOyTWtDkvX7JF57rB
         xVzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=K6VXaindFtCwAZtvv0RXJAabylRODYZL67Vrdekvpic=;
        b=CBx2JwfSCoYR7G0MjZ201Zn+FtmOTimF7HLSj9c9FF/ajI4jF0H1rd8t/QmjpEwjfh
         u6f4IpZJDhuQygqM1vil8w93AULk6am4cCMQNlR4r5LeRMFU8wtMc+odRzd05L3mpW8H
         QfIAAHWl23tBTKxsI50hH3+yqDoikvR4243Uj1EQDI5m7vSJEIw+9w3f5GWClA60dXqL
         OKqq2sNx0IElF7XuMB1VD8z6owOcL/A0dFYuBYdGVA5feNGPgcj8llmDTRd+p9TyRNEn
         Hw8id5gxldzNdqDhshf4QsZs+Bhe69tN8EULjid0DKQqTyQ5lvdnx+h0fw+w/SbdCBdU
         jRTg==
X-Gm-Message-State: AOAM530t6YCnsuYrhaboHCRQK6RK21spyMsJ3VAF/wrJ6IEq+q9/7Fsq
        VTMbiJ2ZOjdRCyE+kyYxdeA=
X-Google-Smtp-Source: ABdhPJzCHo46G3aPpyytMVG86B7MNC1yA2t+m56DjcHO2TaTOuhsDm9t0TQbmCb8Ti0op2bCdaD2Ug==
X-Received: by 2002:a17:906:9143:: with SMTP id y3mr4228353ejw.465.1623330288170;
        Thu, 10 Jun 2021 06:04:48 -0700 (PDT)
Received: from skbuf ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id n5sm1340566edd.40.2021.06.10.06.04.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 06:04:47 -0700 (PDT)
Date:   Thu, 10 Jun 2021 16:04:45 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: Re: [PATCH net-next v3 4/9] net: phy: micrel: apply resume errata
 workaround for ksz8873 and ksz8863
Message-ID: <20210610130445.l5iiswxpzpez25cv@skbuf>
References: <20210526043037.9830-1-o.rempel@pengutronix.de>
 <20210526043037.9830-5-o.rempel@pengutronix.de>
 <20210526224329.raaxr6b2s2uid4dw@skbuf>
 <20210610114920.w5xyijxe62svzdfp@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210610114920.w5xyijxe62svzdfp@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 10, 2021 at 01:49:20PM +0200, Oleksij Rempel wrote:
> On Thu, May 27, 2021 at 01:43:29AM +0300, Vladimir Oltean wrote:
> > On Wed, May 26, 2021 at 06:30:32AM +0200, Oleksij Rempel wrote:
> > > The ksz8873 and ksz8863 switches are affected by following errata:
> > > 
> > > | "Receiver error in 100BASE-TX mode following Soft Power Down"
> > > |
> > > | Some KSZ8873 devices may exhibit receiver errors after transitioning
> > > | from Soft Power Down mode to Normal mode, as controlled by register 195
> > > | (0xC3) bits [1:0]. When exiting Soft Power Down mode, the receiver
> > > | blocks may not start up properly, causing the PHY to miss data and
> > > | exhibit erratic behavior. The problem may appear on either port 1 or
> > > | port 2, or both ports. The problem occurs only for 100BASE-TX, not
> > > | 10BASE-T.
> > > |
> > > | END USER IMPLICATIONS
> > > | When the failure occurs, the following symptoms are seen on the affected
> > > | port(s):
> > > | - The port is able to link
> > > | - LED0 blinks, even when there is no traffic
> > > | - The MIB counters indicate receive errors (Rx Fragments, Rx Symbol
> > > |   Errors, Rx CRC Errors, Rx Alignment Errors)
> > > | - Only a small fraction of packets is correctly received and forwarded
> > > |   through the switch. Most packets are dropped due to receive errors.
> > > |
> > > | The failing condition cannot be corrected by the following:
> > > | - Removing and reconnecting the cable
> > > | - Hardware reset
> > > | - Software Reset and PCS Reset bits in register 67 (0x43)
> > > |
> > > | Work around:
> > > | The problem can be corrected by setting and then clearing the Port Power
> > > | Down bits (registers 29 (0x1D) and 45 (0x2D), bit 3). This must be done
> > > | separately for each affected port after returning from Soft Power Down
> > > | Mode to Normal Mode. The following procedure will ensure no further
> > > | issues due to this erratum. To enter Soft Power Down Mode, set register
> > > | 195 (0xC3), bits [1:0] = 10.
> > > |
> > > | To exit Soft Power Down Mode, follow these steps:
> > > | 1. Set register 195 (0xC3), bits [1:0] = 00 // Exit soft power down mode
> > > | 2. Wait 1ms minimum
> > > | 3. Set register 29 (0x1D), bit [3] = 1 // Enter PHY port 1 power down mode
> > > | 4. Set register 29 (0x1D), bit [3] = 0 // Exit PHY port 1 power down mode
> > > | 5. Set register 45 (0x2D), bit [3] = 1 // Enter PHY port 2 power down mode
> > > | 6. Set register 45 (0x2D), bit [3] = 0 // Exit PHY port 2 power down mode
> > > 
> > > This patch implements steps 2...6 of the suggested workaround. The first
> > > step needs to be implemented in the switch driver.
> > 
> > Am I right in understanding that register 195 (0xc3) is not a port register?
> > 
> > To hit the erratum, you have to enter Soft Power Down in the first place,
> > presumably by writing register 0xc3 from somewhere, right?
> > 
> > Where does Linux write this register from?
> > 
> > Once we find that place that enters/exits Soft Power Down mode, can't we
> > just toggle the Port Power Down bits for each port, exactly like the ERR
> > workaround says, instead of fooling around with a PHY driver?
> 
> The KSZ8873 switch is using multiple register mappings.
> https://ww1.microchip.com/downloads/en/DeviceDoc/00002348A.pdf
> Page 38:
> "The MIIM interface is used to access the MII PHY registers defined in
> this section. The SPI, I2C, and SMI interfaces can also be used to access
> some of these registers. The latter three interfaces use a different
> mapping mechanism than the MIIM interface."
> 
> This PHY driver is able to work directly over MIIM (MDIO). Or work with DSA over
> integrated register translation mapping.

This doesn't answer my question of where is the Soft Power Down mode enabled.

> > > 
> > > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > > ---
> > >  drivers/net/phy/micrel.c | 22 +++++++++++++++++++++-
> > >  1 file changed, 21 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
> > > index 227d88db7d27..f03188ed953a 100644
> > > --- a/drivers/net/phy/micrel.c
> > > +++ b/drivers/net/phy/micrel.c
> > > @@ -1048,6 +1048,26 @@ static int ksz8873mll_config_aneg(struct phy_device *phydev)
> > >  	return 0;
> > >  }
> > >  
> > > +static int ksz886x_resume(struct phy_device *phydev)
> > > +{
> > > +	int ret;
> > > +
> > > +	/* Apply errata workaround for KSZ8863 and KSZ8873:
> > > +	 * Receiver error in 100BASE-TX mode following Soft Power Down
> > > +	 *
> > > +	 * When exiting Soft Power Down mode, the receiver blocks may not start
> > > +	 * up properly, causing the PHY to miss data and exhibit erratic
> > > +	 * behavior.
> > > +	 */
> > > +	usleep_range(1000, 2000);
> > > +
> > > +	ret = phy_set_bits(phydev, MII_BMCR, BMCR_PDOWN);
> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	return phy_clear_bits(phydev, MII_BMCR, BMCR_PDOWN);
> > > +}
> > > +
> > >  static int kszphy_get_sset_count(struct phy_device *phydev)
> > >  {
> > >  	return ARRAY_SIZE(kszphy_hw_stats);
> > > @@ -1401,7 +1421,7 @@ static struct phy_driver ksphy_driver[] = {
> > >  	/* PHY_BASIC_FEATURES */
> > >  	.config_init	= kszphy_config_init,
> > >  	.suspend	= genphy_suspend,
> > > -	.resume		= genphy_resume,
> > > +	.resume		= ksz886x_resume,
> > 
> > Are you able to explain the relation between the call paths of
> > phy_resume() and the lifetime of the Soft Power Down setting of the
> > switch? How do we know that the PHYs are resumed after the switch has
> > exited Soft Power Down mode?
> 
> The MII_BMCRs BMCR_PDOWN bit is mapped to the "register 29 (0x1D), bit
> [3]" for the PHY0 and to "register 45 (0x2D), bit [3]" for the PHY1.
> 
> I assume, I'll need to add this comments to the commit message. Or do
> you have other suggestions on how this should be implemented?

According to "3.2 Power Management" in the datasheet you shared:

There are 5 (five) operation modes under the power management function,
which is controlled by two bits in Register 195 (0xC3) and one bit in
Register 29 (0x1D), 45 (0x2D) as shown below:

Register 195 bit[1:0] = 00 Normal Operation Mode
Register 195 bit[1:0] = 01 Energy Detect Mode
Register 195 bit[1:0] = 10 Soft Power Down Mode
Register 195 bit[1:0] = 11 Power Saving Mode
Register 29, 45 bit 3 = 1 Port Based Power Down Mode

3.2.4 SOFT POWER DOWN MODE

The soft power down mode is entered by setting bit[1:0]=10 in register
195. When KSZ8873MLL/FLL/RLL is in this mode, all PLL clocks are
disabled, the PHY and the MAC are off, all internal registers values
will not change. When the host set bit[1:0]=00 in register 195, this
device will be back from current soft power down mode to normal
operation mode.

3.2.5 PORT-BASED POWER DOWN MODE

In addition, the KSZ8873MLL/FLL/RLL features a per-port power down mode.
To save power, a PHY port that is not in use can be powered down via
port control register 29 or 45 bit 3, or MIIM PHY register. It saves
about 15 mA per port.



From the above I understand that the first 4 power management modes are
global, and the 5th isn't.

You've explained how the PHY driver enters port-based power down mode.
But the ERR describes an issue being triggered by a global power down
mode. What you are describing is not what the ERR text is describing.

Excuse my perhaps stupid question, but have you triggered the issue
described by the erratum? Does this patch fix that? Where is the disconnect?
