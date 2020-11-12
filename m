Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AEC72B12BD
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 00:26:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726176AbgKLX0j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 18:26:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbgKLX0j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 18:26:39 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB51DC0613D1;
        Thu, 12 Nov 2020 15:26:20 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id v22so8462471edt.9;
        Thu, 12 Nov 2020 15:26:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TlYFcKTRc4uJxNFNgTXByAJcJNBkENTDk/UqmoZAVtg=;
        b=R36fpCiiFn3VZYBIKh8DMHqlpcqbsG9UwqutfvgQXKuR4nz5yDi07yljQ56HcTEeDq
         vqLrpPALLdwnHSMZzAruXhfTbMgdIEz7w9BU2wb/5SHU3ioBe7RPmC9RcsB/2L29TSEi
         gniYCKg/hpFqxWUsVIyDBLqF+/nbIeqWvoz/ciqg0lE3U5/f3WyLBQWEV6qy+UB9JP5/
         5r49RBwvBEXsad8R60L9CW8+qthLZ/dwNM1wNmQWEWbUAOTRlANewmqg2xUG1LvDfxCI
         Nm/6AsYXDDXapKSTK0soSNg/bvNY6MX4xOqfcKP0hrr1ThNZ0Adrj1JP6nEn0ozd88LW
         8W6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TlYFcKTRc4uJxNFNgTXByAJcJNBkENTDk/UqmoZAVtg=;
        b=Th7OTEgZjj6VBQycur/mUWPdwvr/Ovc3QxTZ9z38+ztkMem/pMzpJZEuQNlH2+UjVp
         GC1AOpQ3VJvctley3i10WkKam5sM5tNiYxjAWwxkeGM+OhbB7UTGLeEI/kmq6ugzWO+J
         VCfJJ9CVNfDojIghdZDr8YOEasOChqsjOoxbNYs8C9LBhMT+uK8+jIhJLahCyfinvyuk
         vi+yJPTzhjySTE6/8zgNXoGas+7fn+UT3mmXMrbrOA/WVPjzg2LlauCeIQ0f4v9OQ38e
         LqQYYUEZU4YtWasvAD5ktozTMSJmcDL0453jDLXCU+ReludHsog52eSSC/8/68BNbsiT
         HI4Q==
X-Gm-Message-State: AOAM531IE6h4q7HGzKwkoljcuJVN8XSADcmtt4+cxjC4gbczsobX3tIm
        aN20d5IdCvbDFXgRh4iSymQ=
X-Google-Smtp-Source: ABdhPJwsBcy6ESeUmZ85R4GIsO8XO4KI+CEQs/e7meIe3wfVUEfAWJjPfnOWq+1Kla9Nf7KIU/MGbQ==
X-Received: by 2002:a05:6402:1813:: with SMTP id g19mr2530615edy.105.1605223579359;
        Thu, 12 Nov 2020 15:26:19 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id h22sm2754224ejt.21.2020.11.12.15.26.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 15:26:18 -0800 (PST)
Date:   Fri, 13 Nov 2020 01:26:17 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Richard Cochran <richardcochran@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
        George McCollister <george.mccollister@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 06/11] net: dsa: microchip: ksz9477: basic
 interrupt support
Message-ID: <20201112232617.dka72sudrbii52aq@skbuf>
References: <20201112153537.22383-1-ceggers@arri.de>
 <20201112153537.22383-7-ceggers@arri.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201112153537.22383-7-ceggers@arri.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 12, 2020 at 04:35:32PM +0100, Christian Eggers wrote:
> Interrupts are required for TX time stamping. Probably they could also
> be used for PHY connection status.

Do the KSZ switches have an internal PHY? And there's a single interrupt
line, shared between the PTP timestamping engine, and the internal PHY
that is driver by phylib?

> This patch only adds the basic infrastructure for interrupts, no
> interrupts are actually enabled nor handled.
>
> ksz9477_reset_switch() must be called before requesting the IRQ (in
> ksz9477_init() instead of ksz9477_setup()).

A patch can never be "too simple". Maybe you could factor out that code
movement into a separate patch.

> Signed-off-by: Christian Eggers <ceggers@arri.de>
> ---
>  drivers/net/dsa/microchip/ksz9477_i2c.c  |   2 +
>  drivers/net/dsa/microchip/ksz9477_main.c | 103 +++++++++++++++++++++--
>  drivers/net/dsa/microchip/ksz9477_spi.c  |   2 +
>  include/linux/dsa/ksz_common.h           |   1 +
>  4 files changed, 100 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/net/dsa/microchip/ksz9477_i2c.c b/drivers/net/dsa/microchip/ksz9477_i2c.c
> index 4e053a25d077..4ed1f503044a 100644
> --- a/drivers/net/dsa/microchip/ksz9477_i2c.c
> +++ b/drivers/net/dsa/microchip/ksz9477_i2c.c
> @@ -41,6 +41,8 @@ static int ksz9477_i2c_probe(struct i2c_client *i2c,
>  	if (i2c->dev.platform_data)
>  		dev->pdata = i2c->dev.platform_data;
>
> +	dev->irq = i2c->irq;
> +
>  	ret = ksz9477_switch_register(dev);
>
>  	/* Main DSA driver may not be started yet. */
> diff --git a/drivers/net/dsa/microchip/ksz9477_main.c b/drivers/net/dsa/microchip/ksz9477_main.c
> index abfd3802bb51..6b5a981fb21f 100644
> --- a/drivers/net/dsa/microchip/ksz9477_main.c
> +++ b/drivers/net/dsa/microchip/ksz9477_main.c
> @@ -7,7 +7,9 @@
>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
> +#include <linux/interrupt.h>
>  #include <linux/iopoll.h>
> +#include <linux/irq.h>
>  #include <linux/platform_data/microchip-ksz.h>
>  #include <linux/phy.h>
>  #include <linux/if_bridge.h>
> @@ -1345,19 +1347,12 @@ static void ksz9477_config_cpu_port(struct dsa_switch *ds)
>  static int ksz9477_setup(struct dsa_switch *ds)
>  {
>  	struct ksz_device *dev = ds->priv;
> -	int ret = 0;
>
>  	dev->vlan_cache = devm_kcalloc(dev->dev, sizeof(struct vlan_table),
>  				       dev->num_vlans, GFP_KERNEL);
>  	if (!dev->vlan_cache)
>  		return -ENOMEM;
>
> -	ret = ksz9477_reset_switch(dev);
> -	if (ret) {
> -		dev_err(ds->dev, "failed to reset switch\n");
> -		return ret;
> -	}
> -
>  	/* Required for port partitioning. */
>  	ksz9477_cfg32(dev, REG_SW_QM_CTRL__4, UNICAST_VLAN_BOUNDARY,
>  		      true);
> @@ -1535,12 +1530,84 @@ static const struct ksz_chip_data ksz9477_switch_chips[] = {
>  	},
>  };
>
> +static irqreturn_t ksz9477_switch_irq_thread(int irq, void *dev_id)
> +{
> +	struct ksz_device *dev = dev_id;
> +	u32 data;
> +	int port;
> +	int ret;
> +	irqreturn_t result = IRQ_NONE;

Please keep local variable declaration sorted in the reverse order of
line length. But....

> +
> +	/* Read global port interrupt status register */
> +	ret = ksz_read32(dev, REG_SW_PORT_INT_STATUS__4, &data);
> +	if (ret)
> +		return result;

...Is there any point at all in keeping the "result" variable?

> +
> +	for (port = 0; port < dev->port_cnt; port++) {
> +		if (data & BIT(port)) {

You can reduce the indentation level by 1 here using:

		if (!(data & BIT(port)))
			continue;

> +			u8 data8;
> +
> +			/* Read port interrupt status register */
> +			ret = ksz_read8(dev, PORT_CTRL_ADDR(port, REG_PORT_INT_STATUS),
> +					&data8);
> +			if (ret)
> +				return result;
> +
> +			/* ToDo: Add specific handling of port interrupts */

Buggy? Please return IRQ_HANDLED, otherwise the system, when bisected to
this commit exactly, will emit interrupts and complain that nobody cared.

> +		}
> +	}
> +
> +	return result;
> +}
> +
> +static int ksz9477_enable_port_interrupts(struct ksz_device *dev)
> +{
> +	u32 data;
> +	int ret;
> +
> +	ret = ksz_read32(dev, REG_SW_PORT_INT_MASK__4, &data);
> +	if (ret)
> +		return ret;
> +
> +	/* Enable port interrupts (0 means enabled) */
> +	data &= ~((1 << dev->port_cnt) - 1);

And what's the " - 1" for?

> +	ret = ksz_write32(dev, REG_SW_PORT_INT_MASK__4, data);
> +	if (ret)
> +		return ret;
> +
> +	return 0;

	return ksz_write32(dev, REG_SW_PORT_INT_MASK__4, data);

> +}
> +
> +static int ksz9477_disable_port_interrupts(struct ksz_device *dev)
> +{
> +	u32 data;
> +	int ret;
> +
> +	ret = ksz_read32(dev, REG_SW_PORT_INT_MASK__4, &data);
> +	if (ret)
> +		return ret;
> +
> +	/* Disable port interrupts (1 means disabled) */
> +	data |= ((1 << dev->port_cnt) - 1);
> +	ret = ksz_write32(dev, REG_SW_PORT_INT_MASK__4, data);
> +	if (ret)
> +		return ret;
> +
> +	return 0;

same comments as above.

Also, it's almost as if you want to implement these in the same
function, with a "bool enable"?

> +}
> +
>  static int ksz9477_switch_init(struct ksz_device *dev)
>  {
> -	int i;
> +	int i, ret;
>
>  	dev->ds->ops = &ksz9477_switch_ops;
>
> +	ret = ksz9477_reset_switch(dev);
> +	if (ret) {
> +		dev_err(dev->dev, "failed to reset switch\n");
> +		return ret;
> +	}
> +
>  	for (i = 0; i < ARRAY_SIZE(ksz9477_switch_chips); i++) {
>  		const struct ksz_chip_data *chip = &ksz9477_switch_chips[i];
>
> @@ -1584,12 +1651,32 @@ static int ksz9477_switch_init(struct ksz_device *dev)
>
>  	/* set the real number of ports */
>  	dev->ds->num_ports = dev->port_cnt;
> +	if (dev->irq > 0) {
> +		unsigned long irqflags = irqd_get_trigger_type(irq_get_irq_data(dev->irq));

What is irqd_get_trigger_type and what does it have to do with the
"irqflags" argument of request_threaded_irq? Where else have you even
seen this?

> +
> +		irqflags |= IRQF_ONESHOT;

And shared maybe?

> +		ret = devm_request_threaded_irq(dev->dev, dev->irq, NULL,
> +						ksz9477_switch_irq_thread,
> +						irqflags,
> +						dev_name(dev->dev),
> +						dev);
> +		if (ret) {
> +			dev_err(dev->dev, "failed to request IRQ.\n");
> +			return ret;
> +		}
> +
> +		ret = ksz9477_enable_port_interrupts(dev);
> +		if (ret)
> +			return ret;

Could you also clear pending interrupts before enabling the line?

> +	}
>
>  	return 0;
>  }
>
>  static void ksz9477_switch_exit(struct ksz_device *dev)
>  {
> +	if (dev->irq > 0)
> +		ksz9477_disable_port_interrupts(dev);

I think it'd look a bit nicer if you moved this condition into
ksz9477_disable_port_interrupts:

	if (!dev->irq)
		return;

>  	ksz9477_reset_switch(dev);
>  }
>
