Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 105D950A0D9
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 15:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385870AbiDUNdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 09:33:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358404AbiDUNdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 09:33:31 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6986918340
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 06:30:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=PxUmZ2CxHLIu9mwYA1zs6hKOX8cIVgW8NkKgnMjC/Ys=; b=0FA+/5/4W4+gov+D5ZdX3J/E6j
        YLL3ZD4hNIHd/agJ2OFGYyI26S2p2f0au0H5MJSVLUsJcVndF4aWdsJmM5dHeTnNs93hY1MHFDgH2
        UG6kgnBcaiAXBC7vqHwGe4x6JYrAXI3pNfsSnmhfMRVHBqcrkUs29S2mZKQjpNb9rbMY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nhWtK-00Go5U-JP; Thu, 21 Apr 2022 15:30:38 +0200
Date:   Thu, 21 Apr 2022 15:30:38 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Josua Mayer <josua@solid-run.com>, netdev@vger.kernel.org,
        alvaro.karsz@solid-run.com, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>
Subject: Re: [PATCH v2 3/3] ARM: dts: imx6qdl-sr-som: update phy
 configuration for som revision 1.9
Message-ID: <YmFcfhzOmi1GwTvS@lunn.ch>
References: <20220410104626.11517-1-josua@solid-run.com>
 <20220419102709.26432-1-josua@solid-run.com>
 <20220419102709.26432-4-josua@solid-run.com>
 <YmFNpLLLDzBNPqGf@lunn.ch>
 <YmFWFzYz/iV4t2cW@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YmFWFzYz/iV4t2cW@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The only other ways around this that I can see would be to have some
> way to flag in DT that the PHYs are "optional" - if they're not found
> while probing the hardware, then don't whinge about them. Or have
> u-boot discover which address the PHY is located, and update the DT
> blob passed to the kernel to disable the PHY addresses that aren't
> present. Or edit the DT to update the node name and reg property. Or
> something along those lines.

uboot sounds like the best option. I don't know if we currently
support the status property for PHYs. Maybe the .dtsi file should have
them all status = "disabled"; and uboot can flip the populated ones to
"okay". Or maybe the other way around to handle older bootloaders.

	Andrew
