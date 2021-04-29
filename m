Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A507936F2EB
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 01:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbhD2Xkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 19:40:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbhD2Xkf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 19:40:35 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77FBFC06138B;
        Thu, 29 Apr 2021 16:39:47 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id s20so19796172plr.13;
        Thu, 29 Apr 2021 16:39:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zgaDDh4BUeyEBjSVBWx2i16ce3Mp8d1zatBCmh68Njs=;
        b=nlBO0mtiBX1r26jk9N2JBN6egc5zeh6PPGLYteCeRrYoCBnmmUTtwdJ3MPJEfXD9mS
         x+/bn+w/B0D+3YsdSA1QHnCpy3Gs8fe/YQ8LYnMNw9IZuc4oA8vSegOSuGqtvmXePe4P
         PgEV1ejjf2JbRjgVTbiyVD5nwu5UUEiU3Y/xzd96cj+gTqruB5MJgtXs3WUHVrmX4QYD
         +rCHpJN90E0SCHUW0y94J0JHgwHW5qM+W0InHSibzf05rbVHdlunQGh8gN4mvA+TgHZc
         EM7VKlTQEf5tyGIrjAjxnIiDG/vIWOW+PITaDBzY7XTyIK1YtH+8XtF7//huvphbDj4t
         hjQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zgaDDh4BUeyEBjSVBWx2i16ce3Mp8d1zatBCmh68Njs=;
        b=PqZFBioH0mvelK/Zqig9UKGv3rzdqFxSU/jCX6si/L/pUuXPcjX+jpG8xR0h2vCWKt
         opluTJVhmzJpCpNoZh+VHCnOeXlZKPJJKqsC4Dr4I3OCiKMR1q1zsNXHaKEpFYjvfMUo
         lvz9OxeUWnnjezTwmKfMk/67r6XrGMV0RiKwUZ7Xx2oMIhQdDUvp1W+y7v4XHFkudA84
         KuqRD3uNMzbcIP8Oc1Gt6IJn8z5EkWHkDdAcufNqgvg/ScMkf3D+vjM8Pg6bfnVJaZvF
         GK2KEAsHgeg2jE+UsaKG1qmtRP3WJeaR/okEEOUZLH+koBAWUBPdGco+AHzYJtxidIcG
         In9w==
X-Gm-Message-State: AOAM5333uqZ3lZ0IetZon3QSbs6VOJ9i+n+MBMMnuS1E1a8DycOv2d5X
        McupKpM20j+K/DGWEuRWcoX5ZeTnWhM=
X-Google-Smtp-Source: ABdhPJyt83TO8FVBQMwQgJp4Ea5UUt4m4YH828W/K6Lk8CqG4H2PP+Go8XhmZqX77olKMuKZi8V2uw==
X-Received: by 2002:a17:902:bf0b:b029:ec:b656:6357 with SMTP id bi11-20020a170902bf0bb02900ecb6566357mr2231222plb.66.1619739586465;
        Thu, 29 Apr 2021 16:39:46 -0700 (PDT)
Received: from [192.168.1.67] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id d199sm95891pfd.187.2021.04.29.16.39.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Apr 2021 16:39:45 -0700 (PDT)
Subject: Re: [PATCH net-next 2/4] net: dsa: mt7530: add interrupt support
To:     DENG Qingfang <dqfext@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Wang <sean.wang@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-staging@lists.linux.dev, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Weijie Gao <weijie.gao@mediatek.com>,
        Chuanhong Guo <gch981213@gmail.com>,
        =?UTF-8?Q?Ren=c3=a9_van_Dorst?= <opensource@vdorst.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>
References: <20210429062130.29403-1-dqfext@gmail.com>
 <20210429062130.29403-3-dqfext@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <18aa9a3b-e286-86b2-8b9b-e519ad884d77@gmail.com>
Date:   Thu, 29 Apr 2021 16:39:36 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210429062130.29403-3-dqfext@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/28/2021 11:21 PM, DENG Qingfang wrote:
> Add support for MT7530 interrupt controller to handle internal PHYs.
> In order to assign an IRQ number to each PHY, the registration of MDIO bus
> is also done in this driver.
> 
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> ---

[snip]

> +static int
> +mt7530_setup_irq(struct mt7530_priv *priv)
> +{
> +	struct device *dev = priv->dev;
> +	struct device_node *np = dev->of_node;
> +	int ret;
> +
> +	if (!of_property_read_bool(np, "interrupt-controller")) {
> +		dev_info(dev, "no interrupt support\n");
> +		return 0;
> +	}
> +
> +	priv->irq = of_irq_get(np, 0);

Using platform_get_irq() may be a bit nicer to avoid using too many
OF-centric APIs, but this does not have to be changed right now.
Likewise for the interrupt-controller above.

> +	if (priv->irq <= 0) {
> +		dev_err(dev, "failed to get parent IRQ: %d\n", priv->irq);
> +		return priv->irq ? : -EINVAL;
> +	}
> +
> +	priv->irq_domain = irq_domain_add_linear(np, MT7530_NUM_PHYS,
> +						 &mt7530_irq_domain_ops, priv);
> +	if (!priv->irq_domain) {
> +		dev_err(dev, "failed to create IRQ domain\n");
> +		return -ENOMEM;
> +	}
> +
> +	/* This register must be set for MT7530 to properly fire interrupts */
> +	if (priv->id != ID_MT7531)
> +		mt7530_set(priv, MT7530_TOP_SIG_CTRL, TOP_SIG_CTRL_NORMAL);
> +
> +	ret = request_threaded_irq(priv->irq, NULL, mt7530_irq_thread_fn,
> +				   IRQF_ONESHOT, KBUILD_MODNAME, priv);

Maybe dev_name() would be more unique in case a system happens to have
more switches in the future so you can easily differentiate them.

> +	if (ret) {

Can you call mt7530_free_irq() to avoid the error repetition?

> +		irq_domain_remove(priv->irq_domain);
> +		dev_err(dev, "failed to request IRQ: %d\n", ret);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static void
> +mt7530_free_mdio_irq(struct mt7530_priv *priv)
> +{
> +	int p;
> +
> +	for (p = 0; p < MT7530_NUM_PHYS; p++) {
> +		if (BIT(p) & priv->ds->phys_mii_mask) {
> +			unsigned int irq;
> +
> +			irq = irq_find_mapping(priv->irq_domain, p);
> +			irq_dispose_mapping(irq);
> +		}
> +	}
> +}
> +
> +static void
> +mt7530_free_irq_common(struct mt7530_priv *priv)
> +{
> +	free_irq(priv->irq, priv);
> +	irq_domain_remove(priv->irq_domain);
> +}
> +
> +static void
> +mt7530_free_irq(struct mt7530_priv *priv)
> +{
> +	mt7530_free_mdio_irq(priv);
> +	mt7530_free_irq_common(priv);
> +}
> +
> +static int
> +mt7530_setup_mdio(struct mt7530_priv *priv)
> +{
> +	struct dsa_switch *ds = priv->ds;
> +	struct device *dev = priv->dev;
> +	struct mii_bus *bus;
> +	static int idx;
> +	int ret;
> +
> +	bus = devm_mdiobus_alloc(dev);
> +	if (!bus)
> +		return -ENOMEM;
> +
> +	ds->slave_mii_bus = bus;
> +	bus->priv = priv;
> +	bus->name = KBUILD_MODNAME "-mii";
> +	snprintf(bus->id, MII_BUS_ID_SIZE, KBUILD_MODNAME "-%d", idx++);

Likewise using dev_name() here would provide an unique name in case you
have multiple switches.

Feel free to address my comments later, they do not seem to be blocking:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
