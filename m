Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADA5F312792
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 22:34:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbhBGVdD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 16:33:03 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:53854 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229548AbhBGVcz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 7 Feb 2021 16:32:55 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l8rf7-004iGX-8h; Sun, 07 Feb 2021 22:32:09 +0100
Date:   Sun, 7 Feb 2021 22:32:09 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     stefanc@marvell.com
Cc:     netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        davem@davemloft.net, nadavh@marvell.com, ymarkman@marvell.com,
        linux-kernel@vger.kernel.org, kuba@kernel.org,
        linux@armlinux.org.uk, mw@semihalf.com, rmk+kernel@armlinux.org.uk,
        atenart@kernel.org, devicetree@vger.kernel.org, robh+dt@kernel.org,
        sebastian.hesselbarth@gmail.com, gregory.clement@bootlin.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v9 net-next 03/15] net: mvpp2: add CM3 SRAM memory map
Message-ID: <YCBcWbATtEuw470X@lunn.ch>
References: <1612723137-18045-1-git-send-email-stefanc@marvell.com>
 <1612723137-18045-4-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1612723137-18045-4-git-send-email-stefanc@marvell.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int mvpp2_get_sram(struct platform_device *pdev,
> +			  struct mvpp2 *priv)
> +{
> +	struct resource *res;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 2);
> +	if (!res) {
> +		if (has_acpi_companion(&pdev->dev))
> +			dev_warn(&pdev->dev, "ACPI is too old, Flow control not supported\n");
> +		else
> +			dev_warn(&pdev->dev, "DT is too old, Flow control not supported\n");
> +		return 0;
> +	}
> +
> +	priv->cm3_base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(priv->cm3_base))
> +		return PTR_ERR(priv->cm3_base);
> +
> +	return 0;
> +}

This looks much better. Thanks

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
