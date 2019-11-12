Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9DAF92E9
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 15:42:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbfKLOm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 09:42:57 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:36052 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726008AbfKLOm5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 09:42:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=CvGIcWa1AgIe1GWVRKf0dJ7uQMosCXIHqjgnaIbTKU0=; b=SfTEuqVj4LwsXk7jRMpfxBFbXw
        DbKcwCt/RzJU0Wpaqb921NDF1xU/li4z9oUbA72bbxV9haYHUhRntXK8fEAHRTIFa69c9EOtnOUzg
        gj2fMvXl6v/2Jkck7xb8mnEbslofO3Xh9LRQK6uq6cxPBBvP9RhaslwYerVNNh+8oqzs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iUXNb-00020v-PV; Tue, 12 Nov 2019 15:42:51 +0100
Date:   Tue, 12 Nov 2019 15:42:51 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     jakub.kicinski@netronome.com, davem@davemloft.net,
        alexandre.belloni@bootlin.com, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, horatiu.vultur@microchip.com,
        claudiu.manoil@nxp.com, netdev@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next 08/12] net: mscc: ocelot: publish structure
 definitions to include/soc/mscc/ocelot.h
Message-ID: <20191112144251.GF10875@lunn.ch>
References: <20191112124420.6225-1-olteanv@gmail.com>
 <20191112124420.6225-9-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191112124420.6225-9-olteanv@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h

..

> +#else
> +
> +/* I/O */
> +u32 ocelot_port_readl(struct ocelot_port *port, u32 reg)
> +{
> +	return 0;
> +}

These stubs are for when the core is missing? I don't think that makes
sense. What use is a DSA or switchdev driver without the core? I would
put in a hard dependency in the Kconfig, so the DSA driver can only be
built when the core is available, and skip these stubs.

      Andrew
