Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4752F10C6
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 12:05:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729544AbhAKLFD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 06:05:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728387AbhAKLFD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 06:05:03 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB1A5C061786;
        Mon, 11 Jan 2021 03:04:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=L+GBxSxQTI4Xb+fBuV7rsaceskolDWPmYIZDlSCrKEA=; b=Sb6+uLCnIDe9NNSGTDhKzutUR
        3XCa5whm7rOxRR2NqRXfjjnuMhKhz2ginjFbvJi/KOEwMYKQnkby0iYFFyVCayFxgrXbSoMdYUeV6
        tmD562vzE6D9MZp/yRnWkbzGbjHzv90Haeejy9+IRa/plE6JHMM7ZFF7ExcVtAr+Pa/F1de836+79
        2pLD9tOzsHgdMbVvoxq9jydHrE/N3CMs96arbO/hEI0LLvSbHSMhJX65fS+I35XiZO05y4XTGbXFj
        EsUTwkmUBuZ1zWjWu8C6OUA5u/gmQ7cssfqiftQLA1J3MD2cLhpgj+7yRoxjWQSBEQ0wugwRfKcO8
        TB485TmFg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:46558)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kyuzb-0006rM-1o; Mon, 11 Jan 2021 11:04:11 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kyuzX-0005At-T2; Mon, 11 Jan 2021 11:04:07 +0000
Date:   Mon, 11 Jan 2021 11:04:07 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Philipp Zabel <p.zabel@pengutronix.de>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>,
        Frank Wunderlich <frank-w@public-files.de>
Subject: Re: [PATCH net-next 2/2] drivers: net: dsa: mt7530: MT7530 optional
 GPIO support
Message-ID: <20210111110407.GR1551@shell.armlinux.org.uk>
References: <20210111054428.3273-1-dqfext@gmail.com>
 <20210111054428.3273-3-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210111054428.3273-3-dqfext@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021 at 01:44:28PM +0800, DENG Qingfang wrote:
> +static int
> +mt7530_gpio_direction_output(struct gpio_chip *gc, unsigned int offset, int value)
> +{
> +	struct mt7530_priv *priv = gpiochip_get_data(gc);
> +	u32 bit = mt7530_gpio_to_bit(offset);
> +
> +	mt7530_set(priv, MT7530_LED_GPIO_DIR, bit);
> +	mt7530_set(priv, MT7530_LED_GPIO_OE, bit);
> +	mt7530_gpio_set(gc, offset, value);

FYI, Documentation/driver-api/gpio/consumer.rst says:

  For output GPIOs, the value provided becomes the initial output value.
  This helps avoid signal glitching during system startup.

Setting the pin to be an output, and then setting its initial value
does not avoid the glitch. You may wish to investigate whether you
can set the value before setting the pin as an output to avoid this
issue.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
