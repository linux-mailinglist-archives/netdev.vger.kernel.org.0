Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6B946280E
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 00:16:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbhK2XTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 18:19:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231406AbhK2XSs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 18:18:48 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA542C093B56
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 15:06:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=6ilEOEOKIeQfosQ2XTopu/ksY8JyzynO/DGEuW0Z4DY=; b=QFNhYC6wDkQSEXuOCYNOq6WXPf
        II5lU09597MgyXPOfdX5Amz3dI8ktntkhT3IU3Gr8975hHhqct4y3tgUMjPC94MnqfEUydA/jl6xb
        z4LGclWZICYEQU4kxEWEuRVZQ3fSbBIMUkjIjWCd/OO1f+Y8Epvrz0GxeVlpI1t9Ai+LlsfAAGZXG
        CX+IeYSurUBV/XBmTvEhGwowXEfrzEKWAQQstUAVw3qbkNcriwtzm8UAnCM5LDZ7H02GDi3Cw0FQa
        czOwFqQA7OydG/kmqAYXLcAmE4PsAQKsKsto0+Bq7QC/jFl+2tdQmXblpldHWPecTQRmRi572HZvf
        JZ2IDpHA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55964)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mrpjM-0006Ey-Pa; Mon, 29 Nov 2021 23:06:40 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mrpjK-0006Sj-4c; Mon, 29 Nov 2021 23:06:38 +0000
Date:   Mon, 29 Nov 2021 23:06:38 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Subject: Re: [PATCH net 3/6] net: dsa: mv88e6xxx: Save power by disabling
 SerDes trasmitter and receiver
Message-ID: <YaVc/nEDztt5kch9@shell.armlinux.org.uk>
References: <20211129195823.11766-1-kabel@kernel.org>
 <20211129195823.11766-4-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211129195823.11766-4-kabel@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 29, 2021 at 08:58:20PM +0100, Marek Behún wrote:
> +static int mv88e6393x_serdes_power_lane(struct mv88e6xxx_chip *chip, int lane,
> +					bool on)
> +{
> +	u16 reg;
> +	int err;
> +
> +	err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
> +				    MV88E6393X_SERDES_CTRL1, &reg);
> +	if (err)
> +		return err;
> +
> +	if (on)
> +		reg &= !(MV88E6393X_SERDES_CTRL1_TX_PDOWN |
> +			 MV88E6393X_SERDES_CTRL1_RX_PDOWN);

Are you sure this is correct? Don't you want that to be ~(...) ?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
