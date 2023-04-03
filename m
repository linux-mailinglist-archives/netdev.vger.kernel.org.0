Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB496D461B
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 15:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231826AbjDCNro (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 09:47:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232592AbjDCNrn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 09:47:43 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 622A01285D
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 06:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=KnpwjnyjcguJmkihkTORgbtJbwhDWM7JLedJJ0H75PA=; b=PGmkIP3W4MglXC5U/Xv4Vo/bf9
        k0a4n9riD7Kvzj5veLZ5n0Vinh2Ej/EEk3vmP58ya8CXFfCvEBT3bSjq9tU05a2AXuAHdZNAu0cdP
        6vGL1veTFzFzNj0t+8rDy4Th28bvkvJIAv2bzCh2UYqhW0AjWOLcUxh7QM+67Df7Lu2WMl8dvcGZA
        0T6CdvW6I8Eel+IwZXSSNXEEpZAI/iAf28JdNbxc0evqdkxmuvJoDp+a271jDKBsOd/engg/1MWj8
        7t2ZpWNPNuTKLUzskuOsrq7aJF1b+jGZog4upiLAN9rPzoBCWoeWwmBBgImhfMV0U/8FSDb3r+Z0Q
        CAwxoqDg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55320)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pjKX2-0002rD-Fx; Mon, 03 Apr 2023 14:47:36 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pjKWy-0004Hz-G8; Mon, 03 Apr 2023 14:47:32 +0100
Date:   Mon, 3 Apr 2023 14:47:32 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org, mengyuanlou@net-swift.com
Subject: Re: [PATCH net-next 5/6] net: txgbe: Implement phylink pcs
Message-ID: <ZCrY9Pqn+fID63s3@shell.armlinux.org.uk>
References: <20230403064528.343866-1-jiawenwu@trustnetic.com>
 <20230403064528.343866-6-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230403064528.343866-6-jiawenwu@trustnetic.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 03, 2023 at 02:45:27PM +0800, Jiawen Wu wrote:
> +static void txgbe_set_sgmii_an37_ability(struct txgbe *txgbe)
> +{
> +	u16 val;
> +
> +	pcs_write(txgbe, MDIO_MMD_PCS, TXGBE_PCS_DIG_CTRL1,
> +		  TXGBE_PCS_DIG_CTRL1_EN_VSMMD1 |
> +		  TXGBE_PCS_DIG_CTRL1_CLS7_BP |
> +		  TXGBE_PCS_DIG_CTRL1_BYP_PWRUP);
> +	pcs_write(txgbe, MDIO_MMD_VEND2, TXGBE_MII_AN_CTRL,
> +		  TXGBE_MII_AN_CTRL_MII |
> +		  TXGBE_MII_AN_CTRL_TXCFG |
> +		  TXGBE_MII_AN_CTRL_PCS_MODE(2));
> +	pcs_write(txgbe, MDIO_MMD_VEND2, TXGBE_MII_DIG_CTRL1,
> +		  TXGBE_MII_DIG_CTRL1_MAC_AUTOSW);
> +	val = pcs_read(txgbe, MDIO_MMD_VEND2, MDIO_CTRL1);
> +	val |= BMCR_ANRESTART | BMCR_ANENABLE;
> +	pcs_write(txgbe, MDIO_MMD_VEND2, MDIO_CTRL1, val);

Does this really set the hardware up for *CISCO SGMII* or does it
set it up for *1000BASE-X*?

Hint: SGMII is *not* just another name for *1000BASE-X*. SGMII is a
modification of IEEE 802.3 1000BASE-X by Cisco to support 10M and
100M speeds. Please do NOT use SGMII as an inter-changeable term for
1000BASE-X, even if everyone else in industry commits that crime. It
is *incorrect* and an abuse of the term.

> +}
> +
> +static int txgbe_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
> +			    phy_interface_t interface,
> +			    const unsigned long *advertising,
> +			    bool permit_pause_to_mac)
> +{
> +	struct txgbe *txgbe = container_of(pcs, struct txgbe, pcs);
> +	struct wx *wx = txgbe->wx;
> +	int ret, val;
> +
> +	/* Wait xpcs power-up good */
> +	ret = read_poll_timeout(pcs_read, val,
> +				(val & TXGBE_PCS_DIG_STS_PSEQ_ST) ==
> +				TXGBE_PCS_DIG_STS_PSEQ_ST_GOOD,
> +				10000, 1000000, false,
> +				txgbe, MDIO_MMD_PCS, TXGBE_PCS_DIG_STS);
> +	if (ret < 0) {
> +		wx_err(wx, "xpcs power-up timeout.\n");
> +		return ret;
> +	}
> +
> +	/* Disable xpcs AN-73 */
> +	pcs_write(txgbe, MDIO_MMD_AN, MDIO_CTRL1, 0);
> +
> +	/* Disable PHY MPLLA for eth mode change(after ECO) */
> +	txgbe_ephy_write(txgbe, TXGBE_SUP_DIG_MPLLA_OVRD_IN_0, 0x243A);
> +	WX_WRITE_FLUSH(wx);
> +	usleep_range(1000, 2000);

Is all this really appropriate for when pcs_config() gets called to
modify the advertisement? I think, maybe, you probably want to make
this conditional on the interface mode changing?

On that note, I don't see anywhere where you set the advertisement.

> +static void txgbe_pcs_get_state_10gbr(struct txgbe *txgbe,
> +				      struct phylink_link_state *state)
> +{
> +	int ret;
> +
> +	state->link = false;
> +
> +	ret = pcs_read(txgbe, MDIO_MMD_PCS, MDIO_STAT1);
> +	if (ret < 0)
> +		return;
> +
> +	if (ret & MDIO_STAT1_LSTATUS)
> +		state->link = true;
> +
> +	if (state->link) {
> +		state->pause = MLO_PAUSE_TX | MLO_PAUSE_RX;
> +		state->duplex = DUPLEX_FULL;
> +		state->speed = SPEED_10000;
> +	}
> +}
> +
> +static void txgbe_pcs_get_state_1000bx(struct txgbe *txgbe,

I think you're using "bx" here as a shortened 1000base-x, but there
is an official 1000BASE-BX which makes this a little confusing.
Please either use 1000b_x or spell it out as 1000basex.

> +				       struct phylink_link_state *state)
> +{
> +	int lpa, bmsr;
> +
> +	/* For C37 1000BASEX mode */
> +	if (linkmode_test_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
> +			      state->advertising)) {
> +		/* Reset link state */
> +		state->link = false;
> +
> +		/* Poll for link jitter */
> +		read_poll_timeout(pcs_read, lpa, lpa,
> +				  100, 50000, false, txgbe,
> +				  MDIO_MMD_VEND2, MII_LPA);

What jitter are you referring to? If the link is down (and thus this
register reads zero), why do we have to spin here for 50ms each time?

> +
> +		if (lpa < 0 || lpa & LPA_RFAULT) {
> +			wx_err(txgbe->wx, "read pcs lpa error: %d\n", lpa);
> +			return;
> +		}
> +
> +		bmsr = pcs_read(txgbe, MDIO_MMD_VEND2, MII_BMSR);
> +		if (bmsr < 0) {
> +			wx_err(txgbe->wx, "read pcs lpa error: %d\n", bmsr);
> +			return;
> +		}
> +
> +		phylink_mii_c22_pcs_decode_state(state, bmsr, lpa);
> +	}

Don't we also want to read the status of the link when autoneg is
disabled? phylink_mii_c22_pcs_decode_state() will deal with this
for you if you just read the LPA and BMSR registers.

> +}
> +
> +static void txgbe_pcs_get_state(struct phylink_pcs *pcs,
> +				struct phylink_link_state *state)
> +{
> +	struct txgbe *txgbe = container_of(pcs, struct txgbe, pcs);
> +
> +	switch (state->interface) {
> +	case PHY_INTERFACE_MODE_10GBASER:
> +		txgbe_pcs_get_state_10gbr(txgbe, state);
> +		return;
> +	case PHY_INTERFACE_MODE_1000BASEX:
> +		txgbe_pcs_get_state_1000bx(txgbe, state);
> +		return;
> +	default:
> +		return;
> +	}
> +}
> +
> +static void txgbe_pcs_an_restart(struct phylink_pcs *pcs)
> +{
> +	struct txgbe *txgbe = container_of(pcs, struct txgbe, pcs);
> +	int ret;
> +
> +	ret = pcs_read(txgbe, MDIO_MMD_VEND2, MDIO_CTRL1);
> +	if (ret >= 0) {
> +		ret |= BMCR_ANRESTART;
> +		pcs_write(txgbe, MDIO_MMD_VEND2, MDIO_CTRL1, ret);
> +	}

We also have mdiodev_modify() which can be used to set BMCR_ANRESTART,
but you'd need pcs_modify() to wrap it... but I don't understand why
not just use the mdiodev_* accessors directly along with:

	struct mdio_device *mdiodev = txgbe->mdiodev;

at the start of the function? It's probably slightly more efficient
in terms of produced code.

> @@ -197,10 +537,15 @@ static int txgbe_gpio_get(struct gpio_chip *chip, unsigned int offset)
>  	int val, dir;
>  
>  	dir = chip->get_direction(chip, offset);
> -	if (dir == GPIO_LINE_DIRECTION_IN)
> +	if (dir == GPIO_LINE_DIRECTION_IN) {
> +		struct txgbe *txgbe = (struct txgbe *)wx->priv;
> +
>  		val = rd32m(wx, WX_GPIO_EXT, BIT(offset));
> -	else
> +		txgbe->gpio_orig &= ~BIT(offset);
> +		txgbe->gpio_orig |= val;
> +	} else {
>  		val = rd32m(wx, WX_GPIO_DR, BIT(offset));
> +	}
>  
>  	return !!(val & BIT(offset));
>  }
> @@ -334,12 +679,19 @@ static void txgbe_irq_handler(struct irq_desc *desc)
>  	struct txgbe *txgbe = (struct txgbe *)wx->priv;
>  	struct gpio_chip *gc = txgbe->gpio;
>  	irq_hw_number_t hwirq;
> -	unsigned long val;
> +	unsigned long gpioirq;
> +	u32 gpio;
>  
>  	chained_irq_enter(chip, desc);
>  
> -	val = rd32(wx, WX_GPIO_INTSTATUS);
> -	for_each_set_bit(hwirq, &val, gc->ngpio)
> +	gpioirq = rd32(wx, WX_GPIO_INTSTATUS);
> +
> +	/* workaround for hysteretic gpio interrupts */
> +	gpio = rd32(wx, WX_GPIO_EXT);
> +	if (!gpioirq)
> +		gpioirq = txgbe->gpio_orig ^ gpio;
> +
> +	for_each_set_bit(hwirq, &gpioirq, gc->ngpio)
>  		generic_handle_domain_irq(gc->irq.domain, hwirq);
>  
>  	chained_irq_exit(chip, desc);
> @@ -358,6 +710,7 @@ static int txgbe_gpio_init(struct txgbe *txgbe)
>  	int ret;
>  
>  	pdev = wx->pdev;
> +	txgbe->gpio_orig = 0;

What has all this GPIO fiddling got to do with the addition of PCS
support? Shoudln't this be in a different patch?

>  
>  	gc = devm_kzalloc(&pdev->dev, sizeof(*gc), GFP_KERNEL);
>  	if (!gc)
> @@ -428,6 +781,12 @@ int txgbe_init_phy(struct txgbe *txgbe)
>  		return ret;
>  	}
>  
> +	ret = txgbe_mdio_pcs_init(txgbe);
> +	if (ret) {
> +		wx_err(txgbe->wx, "failed to init mdio pcs: %d\n", ret);
> +		goto err;
> +	}
> +
>  	ret = txgbe_i2c_adapter_add(txgbe);
>  	if (ret) {
>  		wx_err(txgbe->wx, "failed to init i2c interface: %d\n", ret);
> @@ -456,6 +815,8 @@ int txgbe_init_phy(struct txgbe *txgbe)
>  
>  void txgbe_remove_phy(struct txgbe *txgbe)
>  {
> +	if (txgbe->mdiodev)
> +		mdio_device_free(txgbe->mdiodev);

Wasn't the mdiodev allocated using a devm_* function? Won't this lead to
a double-free?

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!
