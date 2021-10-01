Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF5741E55C
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 02:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350409AbhJAAHT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 20:07:19 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42126 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351319AbhJAAHG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 20:07:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=AYZ78MbKE7o+ckLapKuGnIkQLgJnUysGF/DpNN6Cl/M=; b=wCgNyofgxHVLiJOIpzWGKYIK4V
        x3vc55G92ccdld/b1h1gR+bQ6E6SOYp5wql/RqmMMxmj2tbTnAie2vRFPxtvqmg1aQZ3Y0SKo856d
        v3kefxLxBtw25YrQn9+Tv0TRPfBYqFiCx8ZLpq6SkpYMz84gsPq8h/TSTNul+XnRzJOw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mW636-0091Sh-7f; Fri, 01 Oct 2021 02:05:12 +0200
Date:   Fri, 1 Oct 2021 02:05:12 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Frieder Schrempf <frieder@fris.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        Frieder Schrempf <frieder.schrempf@kontron.de>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Russell King <linux@armlinux.org.uk>,
        Steen Hegelund <steen.hegelund@microchip.com>
Subject: Re: [PATCH 1/3] net: phy: mscc: Add possibilty to disable combined
 LED mode
Message-ID: <YVZQuIr2poOfWvcO@lunn.ch>
References: <20210930125747.2511954-1-frieder@fris.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210930125747.2511954-1-frieder@fris.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 30, 2021 at 02:57:43PM +0200, Frieder Schrempf wrote:
> From: Frieder Schrempf <frieder.schrempf@kontron.de>
> 
> By default the LED modes offer to combine two indicators like speed/link
> and activity in one LED. In order to use a LED only for the first of the
> two modes, the combined feature needs to be disabled.
> 
> In order to do this we introduce a boolean devicetree property
> 'vsc8531,led-[N]-combine-disable' and wire it up to the matching
> bits in the LED behavior register.

Sorry, but no DT property. Each PHY has its own magic combination of
DT properties, nothing shared, nothing common. This does not scale.

Please look at the work being done to control PHY LEDs using the Linux
LED infrastructure. That should give us one uniform interface for all
PHY LEDs.

    Andrew
