Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00EC81EB0C8
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 23:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728742AbgFAVOv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 17:14:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:43304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728182AbgFAVOv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jun 2020 17:14:51 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48F612073B;
        Mon,  1 Jun 2020 21:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591046091;
        bh=oesPaHSxlLM0tRAdPu2n/jhqjyu8C6D0M0gqLrskH14=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ULACOW4WZiFwC+GYYtdv0yWWhyZBQl0XZL+RFp01e2fZTsnz7syvN2jffcBKqouXo
         1HxWlkYv+/SmeObUymZcXIAUJtcQsebkCTZvYMyoNnQsFc0LOY5JjOgstI1BwuCILQ
         57o3hVN30bje7xsVkcFT/Y64I1bQ7gR92r8+ii1M=
Date:   Mon, 1 Jun 2020 14:14:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        antoine.tenart@bootlin.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, madalin.bucur@oss.nxp.com,
        radu-andrei.bulie@nxp.com, fido_max@inbox.ru, broonie@kernel.org
Subject: Re: [PATCH v3 net-next 13/13] net: dsa: felix: introduce support
 for Seville VSC9953 switch
Message-ID: <20200601141448.1f9f3c78@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20200531122640.1375715-14-olteanv@gmail.com>
References: <20200531122640.1375715-1-olteanv@gmail.com>
        <20200531122640.1375715-14-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 31 May 2020 15:26:40 +0300 Vladimir Oltean wrote:
> From: Maxim Kochetkov <fido_max@inbox.ru>
> 
> This is another switch from Vitesse / Microsemi / Microchip, that has
> 10 port (8 external, 2 internal) and is integrated into the Freescale /
> NXP T1040 PowerPC SoC. It is very similar to Felix from NXP LS1028A,
> except that this is a platform device and Felix is a PCI device, and it
> doesn't support IEEE 1588 and TSN.
> 
> Like Felix, this driver configures its own PCS on the internal MDIO bus
> using a phy_device abstraction for it (yes, it will be refactored to use
> a raw mdio_device, like other phylink drivers do, but let's keep it like
> that for now). But unlike Felix, the MDIO bus and the PCS are not from
> the same vendor. The PCS is the same QorIQ/Layerscape PCS as found in
> Felix/ENETC/DPAA*, but the internal MDIO bus that is used to access it
> is actually an instantiation of drivers/net/phy/mdio-mscc-miim.c. But it
> would be difficult to reuse that driver (it doesn't even use regmap, and
> it's less than 200 lines of code), so we hand-roll here some internal
> MDIO bus accessors within seville_vsc9953.c, which serves the purpose of
> driving the PCS absolutely fine.
> 
> Also, same as Felix, the PCS doesn't support dynamic reconfiguration of
> SerDes protocol, so we need to do pre-validation of PHY mode from device
> tree and not let phylink change it.
> 
> Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

drivers/net/dsa/ocelot/seville_vsc9953.c:1003:19: warning: symbol 'seville_info_vsc9953' was not declared. Should it be static?
