Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 355B95770A3
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 20:18:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbiGPSSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 14:18:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiGPSSD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 14:18:03 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 354AA1D30E;
        Sat, 16 Jul 2022 11:18:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Zhn6tvE5+8CyuVHKgG04QJMIHxjVmfp1yFh7W+dOEn0=; b=ckUpcQkpziX4I/aTi7P9MUk6Cx
        YA50TTZq5d9JssCLzR3TLz+NAWAY0OyJbcAXmc9Krr3Zpb7k6J58i9VMMo9GBh14SZgNV1cFRfTOy
        kpB5YBIGQbFiQcHGzet0pHGwJf6QXtTyZdq5/aCIGwCKUcO+jpkABPXAYZdwh2Lfgc94=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oCmM8-00AZ7p-4L; Sat, 16 Jul 2022 20:17:32 +0200
Date:   Sat, 16 Jul 2022 20:17:32 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next v3 12/47] net: phy: aquantia: Add support for
 AQR115
Message-ID: <YtMAvHXuI76cTLAj@lunn.ch>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
 <20220715215954.1449214-13-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220715215954.1449214-13-sean.anderson@seco.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 15, 2022 at 05:59:19PM -0400, Sean Anderson wrote:
> This adds support for the AQR115 (which I have on my LS1046A RDB). I had a
> quick look over the registers, and it seems to be compatible with the
> AQR107. I couldn't find this oui anywhere, but that's what I have on my
> board. It's possible that NXP used a substitute here; I can't confirm
> the part number since there is a heatsink on top of the phy.

If i remember correctly, the OUI can be part of the provisioning for
Aquantia PHYs. And i think there is often per board provisioning,
specially for the SERDEs configuration. So aQuantia/Marvell probably
set this OUI, but maybe at NXP request.

Did you get the part number from the schematic? That should be enough
to confirm it is a AQR115.

> To avoid breaking <10G ethernet on the LS1046ARDB, we must add this
> vendor id as an exception to dpaa_phy_init. This will be removed once
> the DPAA driver is converted to phylink.

I suggest you split this into two. The PHY changes can be merged right
away, and is independent of the DPAA. Given the size of this patchset,
the more you can split it up into parallel submissions the better. So
please submit the PHY patches independent of the rest.

> Signed-off-by: Sean Anderson <sean.anderson@seco.com>

For the aquantia_main.c change only:

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
