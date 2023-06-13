Return-Path: <netdev+bounces-10278-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A056A72D81C
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 05:23:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BB4F4281121
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 03:23:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD6391C02;
	Tue, 13 Jun 2023 03:23:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D17C37F
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 03:23:38 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5001E124;
	Mon, 12 Jun 2023 20:23:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=ls/2w+Jbt2FMuacLpY+NEyKD+0PIo2mAMCryynvWMs4=; b=OBarqweErD8npb6BhQRa/2350C
	KyvzVG56P+TAu5O87pWw7Zyivbc8vIaRzirQ1vh461PsFFwJgqeB8LPFJisO7s3GWarZVacvqo5rK
	40c+ypye9+lUkZMuSTQ/tCAbHt2Lnp2LRxMSD1aZgiwJ4js9dVmNT1teX4yQSRGLgJJw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q8ucv-00FfB4-8o; Tue, 13 Jun 2023 05:23:25 +0200
Date: Tue, 13 Jun 2023 05:23:25 +0200
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
Message-ID: <922466fd-bb14-4b6e-ad40-55b4249c571f@lunn.ch>
References: <ZIfT7UUzj74NyzL_@makrotopia.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZIfT7UUzj74NyzL_@makrotopia.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> +/* Registers on MDIO_MMD_VEND2 */
> +#define MTK_PHY_LED0_ON_CTRL			0x24
> +#define MTK_PHY_LED1_ON_CTRL			0x26
> +#define   MTK_PHY_LED_ON_MASK			GENMASK(6, 0)
> +#define   MTK_PHY_LED_ON_LINK1000		BIT(0)
> +#define   MTK_PHY_LED_ON_LINK100		BIT(1)
> +#define   MTK_PHY_LED_ON_LINK10			BIT(2)
> +#define   MTK_PHY_LED_ON_LINKDOWN		BIT(3)
> +#define   MTK_PHY_LED_ON_FDX			BIT(4) /* Full duplex */
> +#define   MTK_PHY_LED_ON_HDX			BIT(5) /* Half duplex */
> +#define   MTK_PHY_LED_FORCE_ON			BIT(6)
> +#define   MTK_PHY_LED_POLARITY			BIT(14)
> +#define   MTK_PHY_LED_ENABLE			BIT(15)

Would enable being clear result in the LED being off? You can force it
on with MTK_PHY_LED_FORCE_ON | MTK_PHY_LED_ENABLE? That gives you
enough to allow software control of the LED. You can then implement
the led_brightness_set() op, if you want.

I assume the above are specific to LED0? It would be good to include
the 0 in the name, to make that clear.

> +
> +#define MTK_PHY_LED0_BLINK_CTRL			0x25
> +#define MTK_PHY_LED1_BLINK_CTRL			0x27
> +#define   MTK_PHY_LED_1000TX			BIT(0)

So do this mean LINK1000 + blink on TX ?

> +#define   MTK_PHY_LED_1000RX			BIT(1)

So do this mean LINK1000 + blink on RX ?

It would be good to add a comment, because at some point it is likely
somebody will want to offload the ledtrig-netdev and will need to
understand what these really do.

> +#define   MTK_PHY_LED_100TX			BIT(2)
> +#define   MTK_PHY_LED_100RX			BIT(3)
> +#define   MTK_PHY_LED_10TX			BIT(4)
> +#define   MTK_PHY_LED_10RX			BIT(5)
> +#define   MTK_PHY_LED_COLLISION			BIT(6)
> +#define   MTK_PHY_LED_RX_CRC_ERR		BIT(7)
> +#define   MTK_PHY_LED_RX_IDLE_ERR		BIT(8)
> +#define   MTK_PHY_LED_FORCE_BLINK		BIT(9)

Is there a way to force the LED1 off/on?  I guess not setting any of
these bits will force it off.

So the polarity and enable bits apply to LED1? 

> +
>  #define MTK_PHY_RG_BG_RASEL			0x115
>  #define   MTK_PHY_RG_BG_RASEL_MASK		GENMASK(2, 0)
>  
> +/* Register in boottrap syscon defining the initial state of the 4 PHY LEDs */

Should this be bootstrap? You had the same in the commit message.

Also, i'm confused. Here you say 4 PHY LEDs, yet

> +#define MTK_PHY_LED0_ON_CTRL			0x24
> +#define MTK_PHY_LED1_ON_CTRL			0x26

suggests there are two LEDs?

Should these actually be :

> +#define MTK_PHY_LED_ON_CTRL1			0x24
> +#define MTK_PHY_LED_ON_CTRL2			0x26

meaning each LED has two control registers?

MTK_PHY_LED_ON_LINK1000 should actually be MTK_PHY_LED_ON_CTRL1_LINK1000 ?
MTK_PHY_LED_100TX should be MTK_PHY_LED_CTRL2_100TX ?

I find it good practice to ensure a bit value #define includes enough
information in its name to clear indicate what register it applies to.

> +static int mt798x_phy_setup_led(struct phy_device *phydev, bool inverted)
> +{
> +	struct pinctrl *pinctrl;
> +	const u16 led_on_ctrl_defaults = MTK_PHY_LED_ENABLE      |
> +					 MTK_PHY_LED_ON_LINK1000 |
> +					 MTK_PHY_LED_ON_LINK100  |
> +					 MTK_PHY_LED_ON_LINK10;
> +	const u16 led_blink_defaults = MTK_PHY_LED_1000TX |
> +				       MTK_PHY_LED_1000RX |
> +				       MTK_PHY_LED_100TX  |
> +				       MTK_PHY_LED_100RX  |
> +				       MTK_PHY_LED_10TX   |
> +				       MTK_PHY_LED_10RX;
> +
> +	phy_write_mmd(phydev, MDIO_MMD_VEND2, MTK_PHY_LED0_ON_CTRL,
> +		      led_on_ctrl_defaults ^
> +		      (inverted ? MTK_PHY_LED_POLARITY : 0));
> +
> +	phy_write_mmd(phydev, MDIO_MMD_VEND2, MTK_PHY_LED1_ON_CTRL,
> +		      led_on_ctrl_defaults);
> +

Now i'm even more confused. Both have the same value, expect the
polarity bit?

Please add a lot of comments about how this hardware actually works!

> +	phy_write_mmd(phydev, MDIO_MMD_VEND2, MTK_PHY_LED0_BLINK_CTRL,
> +		      led_blink_defaults);
> +
> +	phy_write_mmd(phydev, MDIO_MMD_VEND2, MTK_PHY_LED1_BLINK_CTRL,
> +		      led_blink_defaults);
> +
> +	pinctrl = devm_pinctrl_get_select(&phydev->mdio.dev, "gbe-led");

This is also very unusual. At minimum, it needs a comment as to why it
is needed. But more likely, because no other driver in driver/net does
this, it makes me think it is wrong.

> +static bool mt7988_phy_get_boottrap_polarity(struct phy_device *phydev)
> +{
> +	struct mtk_socphy_shared *priv = phydev->shared->priv;
> +
> +	if (priv->boottrap & BIT(phydev->mdio.addr))
> +		return false;

This can be simplified to

	return !priv->boottrap & BIT(phydev->mdio.addr);

	Andrew

