Return-Path: <netdev+bounces-10398-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F20BF72E553
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 16:15:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 37AA11C20C66
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 14:15:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 228C6370DA;
	Tue, 13 Jun 2023 14:15:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12406522B
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 14:15:04 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01F86EC;
	Tue, 13 Jun 2023 07:14:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=5dUDV/ulY1VwPUL5mH+Lz5QqPr6DjLH8cBAyedpbDYo=; b=iYD6PUgaB/68RBS8u9Ym/rotRl
	FXw1OvFMWOiYd+gt0bp4wsTYby3J9Z85iZkj97SrcFBXrifSj1oiaAnZxTwfzEtELzMoetFthNaX8
	++pqz+HsX9OMSh6EAY7Q/mglNu3XoptYmD/63DJJunhrjHc9Br9OPsfspuSK+HPP5/2o=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q94nG-00FjYJ-Fe; Tue, 13 Jun 2023 16:14:46 +0200
Date: Tue, 13 Jun 2023 16:14:46 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Daniel Golle <daniel@makrotopia.org>
Cc: netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Russell King <linux@armlinux.org.uk>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	SkyLake Huang <SkyLake.Huang@mediatek.com>,
	Qingfang Deng <dqfext@gmail.com>
Subject: Re: [PATCH net-next] net: phy: mediatek-ge-soc: initialize MT7988
 PHY LEDs default state
Message-ID: <7fc15ef7-ab5d-4af7-8d9b-bf0928f476a0@lunn.ch>
References: <ZIfT7UUzj74NyzL_@makrotopia.org>
 <922466fd-bb14-4b6e-ad40-55b4249c571f@lunn.ch>
 <ZIhreKECr8nsNgrh@makrotopia.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZIhreKECr8nsNgrh@makrotopia.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 13, 2023 at 02:13:28PM +0100, Daniel Golle wrote:
> Hi Andrew,
> 
> On Tue, Jun 13, 2023 at 05:23:25AM +0200, Andrew Lunn wrote:
> > > +/* Registers on MDIO_MMD_VEND2 */
> > > +#define MTK_PHY_LED0_ON_CTRL			0x24
> > > +#define MTK_PHY_LED1_ON_CTRL			0x26
> > > +#define   MTK_PHY_LED_ON_MASK			GENMASK(6, 0)
> > > +#define   MTK_PHY_LED_ON_LINK1000		BIT(0)
> > > +#define   MTK_PHY_LED_ON_LINK100		BIT(1)
> > > +#define   MTK_PHY_LED_ON_LINK10			BIT(2)
> > > +#define   MTK_PHY_LED_ON_LINKDOWN		BIT(3)
> > > +#define   MTK_PHY_LED_ON_FDX			BIT(4) /* Full duplex */
> > > +#define   MTK_PHY_LED_ON_HDX			BIT(5) /* Half duplex */
> > > +#define   MTK_PHY_LED_FORCE_ON			BIT(6)
> > > +#define   MTK_PHY_LED_POLARITY			BIT(14)
> > > +#define   MTK_PHY_LED_ENABLE			BIT(15)

> The PHY has two LED outputs, LED0 and LED1. Both have an ON_CTRL and
> a BLINK_CTRL register each with identical layouts for LED0_ON_CTRL and
> LED1_ON_CTRL as well as LED0_BLINK_CTRL as well as LED1_BLINK_CTRL.
 
O.K. So i think the naming could be better

#define MTK_PHY_LED0_ON_CTRL			0x24
#define MTK_PHY_LED1_ON_CTRL			0x26
#define   MTK_PHY_LEDX_ON_CTRL_MASK		GENMASK(6, 0)
#define   MTK_PHY_LEDX_ON_CTRL_LINK1000		BIT(0)
#define   MTK_PHY_LEDX_ON_CTRL_LINK100		BIT(1)

#define MTK_PHY_LED0_BLINK_CTRL			0x25
#define MTK_PHY_LED1_BLINK_CTRL			0x27
#define   MTK_PHY_LEDX_BLINK_CTRL_1000TX	BIT(0)
#define   MTK_PHY_LEDX_BLINK_CTRL_1000RX	BIT(1)

I've taken over code where i found a few examples of a register write
which used the wrong macro for bits because there was no clear
indication which register is belonged to.

	   phy_write(phydev, MTK_PHY_LED1_ON_CTRL,
	   	     MTK_PHY_LEDX_BLINK_CTRL_1000TX |
	             MTK_PHY_LEDX_BLINK_CTRL_1000RX)

is pretty obvious it is wrong.

> The LED controller of both LEDs are identical. The SoC's pinmux assigns
> LED0 as LED_A, LED_B, LED_C and LED_D respectively. And those pins are
> used for bootstrapping board configuration bits, and that then implies
> the polarity of the connected LED.
> 
> Ie.
> -----------------------------+ SoC pin
> --------------+-------+      |
>        port 0 = PHY 0 - LED0 - LED_A
>               +-------\ LED1 - JTAG_JTDI
>        port 1 = PHY 1 - LED0 - LED_B
> MT7530        +-------\ LED1 - JTAG_JTDO
>        port 2 = PHY 2 - LED0 - LED_C
>               +-------\ LED1 - JTAG_JTMS
>        port 3 = PHY 3 - LED0 - LED_D
> --------------+-------\ LED1 - JTAG_JTCLK
>        2P5G PHY       - LED0 - LED_E
> ----------------------\ LED1 - JTAG_JTRST_N
> --------------+--------------+

So you can skip the JTAG interface and have two LEDs. This is purely
down to pinmux settings. In fact, with careful design, it might be
possible to have both LEDs and JTAG.

> > >  #define MTK_PHY_RG_BG_RASEL			0x115
> > >  #define   MTK_PHY_RG_BG_RASEL_MASK		GENMASK(2, 0)
> > >  
> > > +/* Register in boottrap syscon defining the initial state of the 4 PHY LEDs */
> > 
> > Should this be bootstrap? You had the same in the commit message.
> > 
> > Also, i'm confused. Here you say 4 PHY LEDs, yet
> > 
> > > +#define MTK_PHY_LED0_ON_CTRL			0x24
> > > +#define MTK_PHY_LED1_ON_CTRL			0x26
> > 
> > suggests there are two LEDs?
> 
> There are 4 PHYs with two LEDs each. Only LED0 of each PHY is using
> a pin which is used for bootstrapping, hence LED polarity is known
> only for those, polarity of LED1 is unknown and always set the default
> at this point.

So hopefully you can see my sources of confusion and can add some
comments to make this clearer.

> > > +static int mt798x_phy_setup_led(struct phy_device *phydev, bool inverted)
> > > +{
> > > +	struct pinctrl *pinctrl;
> > > +	const u16 led_on_ctrl_defaults = MTK_PHY_LED_ENABLE      |
> > > +					 MTK_PHY_LED_ON_LINK1000 |
> > > +					 MTK_PHY_LED_ON_LINK100  |
> > > +					 MTK_PHY_LED_ON_LINK10;
> > > +	const u16 led_blink_defaults = MTK_PHY_LED_1000TX |
> > > +				       MTK_PHY_LED_1000RX |
> > > +				       MTK_PHY_LED_100TX  |
> > > +				       MTK_PHY_LED_100RX  |
> > > +				       MTK_PHY_LED_10TX   |
> > > +				       MTK_PHY_LED_10RX;
> > > +
> > > +	phy_write_mmd(phydev, MDIO_MMD_VEND2, MTK_PHY_LED0_ON_CTRL,
> > > +		      led_on_ctrl_defaults ^
> > > +		      (inverted ? MTK_PHY_LED_POLARITY : 0));
> > > +
> > > +	phy_write_mmd(phydev, MDIO_MMD_VEND2, MTK_PHY_LED1_ON_CTRL,
> > > +		      led_on_ctrl_defaults);
> > > +
> > 
> > Now i'm even more confused. Both have the same value, expect the
> > polarity bit?
> 
> Only LED0 polarity of each PHY is affected by the bootstrap pins
> LED_A, LED_B, LED_C and LED_D of the SoC, see above.
> Hence we need to XOR polarity only for LED0.

However, if there are two LEDs, you are likely to want to configure
them to show different things, not identical. You are setting the
defaults here which all boards will get. So i would set LED1 to
something different, something which makes sense when there are two
LEDs.

> > > +	pinctrl = devm_pinctrl_get_select(&phydev->mdio.dev, "gbe-led");
> > 
> > This is also very unusual. At minimum, it needs a comment as to why it
> > is needed. But more likely, because no other driver in driver/net does
> > this, it makes me think it is wrong.
> 
> The reason for not using the "default" pinctrl name is simply that then
> the "default" state will already be requested by device model *before*
> the LED registers are actually setup. This results in a short but unwanted
> blink of the LEDs during setup.
> Requesting the pinctrl state only once the setup is done allows avoiding
> that, but of course this is of purely aesthetic nature.

So i assume the pin can have other functions? Just for an example, say
it can also be an I2C clock line, which might be connected to an
SFP. The I2C node in DT will have a pinmux to configure the pin for
I2C. What happens when the PHY driver loads and executes this?

     Andrew

