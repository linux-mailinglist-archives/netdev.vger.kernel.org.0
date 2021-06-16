Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C415D3AA490
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 21:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232689AbhFPTud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 15:50:33 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41182 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229709AbhFPTuc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 15:50:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=/OgS9IDgZUfseOqXobzndXcQ/hFmfhDswGwNc8BKGZU=; b=tOGaCoTO/f0w/a38To9IZv22Rw
        Kd89mfE7SnGVYR6yVcxKbGwucB4GbPibBkcJHMoM9ZPVfpge1iXw5e5F6117Ktes7VkTTkWipXAwZ
        y0zHbWhDhQzavGxTnUrBSwvhdhBOQcXxy3+zD5dmPfLSTm/GVAMU8ghtoblQh6Y5PxTI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ltbWR-009lpI-GI; Wed, 16 Jun 2021 21:48:23 +0200
Date:   Wed, 16 Jun 2021 21:48:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
        jaz@semihalf.com, gjb@semihalf.com, upstream@semihalf.com,
        Samer.El-Haj-Mahmoud@arm.com, jon@solid-run.com, tn@semihalf.com,
        rjw@rjwysocki.net, lenb@kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [net-next: PATCH v2 4/7] net: mvmdio: simplify clock handling
Message-ID: <YMpVhxxPxB/HKOn2@lunn.ch>
References: <20210616190759.2832033-1-mw@semihalf.com>
 <20210616190759.2832033-5-mw@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210616190759.2832033-5-mw@semihalf.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +	dev->clks[0].id = "core";
> +	dev->clks[1].id = "mg";
> +	dev->clks[2].id = "mg_core";
> +	dev->clks[3].id = "axi";
> +	ret = devm_clk_bulk_get_optional(&pdev->dev, MVMDIO_CLOCK_COUNT,
> +					 dev->clks);

Kirkwood:

                mdio: mdio-bus@72004 {
                        compatible = "marvell,orion-mdio";
                        #address-cells = <1>;
                        #size-cells = <0>;
                        reg = <0x72004 0x84>;
                        interrupts = <46>;
                        clocks = <&gate_clk 0>;
                        status = "disabled";

Does this work? There is no clock-names in DT.

     Andrew
