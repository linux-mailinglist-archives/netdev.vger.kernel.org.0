Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68BC446CBB9
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 04:45:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235245AbhLHDsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 22:48:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbhLHDsw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 22:48:52 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11930C061574;
        Tue,  7 Dec 2021 19:45:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 30F1ACE1F9B;
        Wed,  8 Dec 2021 03:45:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C03FCC00446;
        Wed,  8 Dec 2021 03:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638935116;
        bh=46wLcB7r3H9zQ70Kio1fqmSd6TE5pgs+NV5gDht8ovI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AKmOMZzuxiUPyZuHwsCw9HcFTFefSXZ14xe8Ey3DLERFLp6mLHBOxc08PHuO8HLNa
         QrZslUCdu49HSBZPo8iv1z5xvbFJ3mYgrRlkQsH/fYgfscIalhwzEI2t0iHnBpXymD
         LWUz+2WXPFlrDPNy722D8nVkbTgUV/BeUGCTz4b+I8PsXDw38a+/Q3suXHVI0+H1Uq
         F9j57Up+wNaXN4PDQA5XVsqtDkEfm4tCioMsizNM9Nketyr+D82E4b1GMUWydjSWQX
         OeM6+EJ4HwKJGlpg6aon/TsArtsZhQ9B5g1sUlswPasuDUADVvjXpftSjM5+NB+ehD
         6GnCW3hPLTr5Q==
Date:   Tue, 7 Dec 2021 19:45:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Denis Kirjanov <dkirjanov@suse.de>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: Re: [PATCH net-next v6 4/4] net: ocelot: add FDMA support
Message-ID: <20211207194514.32218911@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211207154839.1864114-5-clement.leger@bootlin.com>
References: <20211207154839.1864114-1-clement.leger@bootlin.com>
        <20211207154839.1864114-5-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  7 Dec 2021 16:48:39 +0100 Cl=C3=A9ment L=C3=A9ger wrote:
> + * struct ocelot_fdma - FDMA struct
> + *
> + * @ocelot: Pointer to ocelot struct
> + * @base: base address of FDMA registers
> + * @irq: FDMA interrupt
> + * @ndev: Net device used to initialize NAPI
> + * @dcbs_base: Memory coherent DCBs
> + * @dcbs_dma_base: DMA base address of memory coherent DCBs
> + * @tx_ring: Injection ring
> + * @rx_ring: Extraction ring
> + */
> +struct ocelot_fdma {
> +	int irq;
> +	struct net_device *ndev;
> +	struct ocelot_fdma_dcb *dcbs_base;
> +	dma_addr_t dcbs_dma_base;
> +	struct ocelot_fdma_tx_ring tx_ring;
> +	struct ocelot_fdma_rx_ring rx_ring;
> +	struct napi_struct napi;
> +	struct ocelot *ocelot;

one more nit:

drivers/net/ethernet/mscc/ocelot_fdma.h:156: warning: Function parameter or=
 member 'napi' not described in 'ocelot_fdma'
