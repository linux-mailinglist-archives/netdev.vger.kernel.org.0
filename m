Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 129CC51500E
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 17:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378290AbiD2QCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 12:02:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235747AbiD2QCM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 12:02:12 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0969284EDC;
        Fri, 29 Apr 2022 08:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=uMcTfwKPVn7eKm6yUNY2CfJ2VmHi8B0YTZjYC/sPVmw=; b=LPlSmYEQoLqlRHI8hfnwT7EGX3
        001Q4O8BKAqsP3kTy53hFA3QyJu7pP6CobiL21epvgyyJllnkRzhK2tKQ8Psnf0EaCAelVrk6E9R5
        th04OYA5yrNpf3WvwxxJMbbCvUVsVq5a11ah+AomU6JHNsxpdy+LSDH140Uw6/mZOJ79+wVWHPYp0
        l2EmMB5G4BXUtHjDUJtMYcqRq/kkamD2nt7WzYgnoxxGLUHQJ8Bdz31KbKB5SIWHKD6XXC5tHjm09
        F+y+c5YGaGvA2UZFPHmBrd6ya4NmYWvoRrT31OFwesslvtZf//yt1TxLDK4ZX8o/1ERY0Kaozsm6w
        h1KhoJhA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58444)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nkT19-0004EG-Aa; Fri, 29 Apr 2022 16:58:51 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nkT15-00024G-JO; Fri, 29 Apr 2022 16:58:47 +0100
Date:   Fri, 29 Apr 2022 16:58:47 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     andrew@lunn.ch, netdev@vger.kernel.org, olteanv@gmail.com,
        robh+dt@kernel.org, UNGLinuxDriver@microchip.com,
        woojung.huh@microchip.com, hkallweit1@gmail.com,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        devicetree@vger.kernel.org, pabeni@redhat.com
Subject: Re: [RFC PATCH v11 net-next 06/10] net: dsa: microchip: add support
 for phylink management
Message-ID: <YmwLNz1xeTED7xM/@shell.armlinux.org.uk>
References: <20220325165341.791013-1-prasanna.vengateshan@microchip.com>
 <20220325165341.791013-7-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220325165341.791013-7-prasanna.vengateshan@microchip.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 25, 2022 at 10:23:37PM +0530, Prasanna Vengateshan wrote:
> +static void lan937x_apply_rgmii_delay(struct ksz_device *dev, int port,
> +				      phy_interface_t interface, u8 val)
> +{
> +	struct ksz_port *p = &dev->ports[port];
> +
> +	/* Clear Ingress & Egress internal delay enabled bits */
> +	val &= ~(PORT_RGMII_ID_EG_ENABLE | PORT_RGMII_ID_IG_ENABLE);
> +
> +	/* if the delay is 0, do not enable DLL */
> +	if (p->rgmii_tx_val) {
> +		lan937x_update_rgmii_tx_rx_delay(dev, port, true);
> +		dev_info(dev->dev, "Applied rgmii tx delay for the port %d\n",
> +			 port);
> +		val |= PORT_RGMII_ID_EG_ENABLE;
> +	}
> +
> +	/* if the delay is 0, do not enable DLL */
> +	if (p->rgmii_rx_val) {
> +		lan937x_update_rgmii_tx_rx_delay(dev, port, false);
> +		dev_info(dev->dev, "Applied rgmii rx delay for the port %d\n",
> +			 port);
> +		val |= PORT_RGMII_ID_IG_ENABLE;
> +	}
> +
> +	/* Enable RGMII internal delays */
> +	lan937x_pwrite8(dev, port, REG_PORT_XMII_CTRL_1, val);

"interface" doesn't appear to be used in this function, do you need to
pass it?

Other than that, the patch looks good, thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
