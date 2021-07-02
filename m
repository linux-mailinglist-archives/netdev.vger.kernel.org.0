Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8127C3BA2A9
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 17:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232306AbhGBPRL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 11:17:11 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37646 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232248AbhGBPRK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Jul 2021 11:17:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=OrjOu76OBGPYy39KuvyK91RrT0dYFD2lgNzam5imG+w=; b=aKtlMxctQdlvgLWeJXRAg8VLhm
        EbHsjT0nSPMFHL23FLtPtdhFO8RIfusa7/n27a8xsVCqiN6uWQ8bufbJtVU3c/rYnulI/cHYFKEOV
        uEPPLInjWnn2sTZtkUeUvstH53ajiZ94NbVvRXIfdleKEY1yzXMzLIplwkcTfsZLU7s4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lzKsE-00BvlX-B2; Fri, 02 Jul 2021 17:14:34 +0200
Date:   Fri, 2 Jul 2021 17:14:34 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>, '@lunn.ch
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH net-next v2 3/6] net: dsa: qca: ar9331: add forwarding
 database support'
Message-ID: <YN8tWtqfRRO7kAlb@lunn.ch>
References: <20210702101751.13168-1-o.rempel@pengutronix.de>
 <20210702101751.13168-4-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210702101751.13168-4-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 02, 2021 at 12:17:48PM +0200, Oleksij Rempel wrote:
> This switch provides simple address resolution table, without VLAN or
> multicast specific information.
> With this patch we are able now to read, modify unicast and mulicast

mul_t_icast.

> addresses.
> +static int ar9331_sw_port_fdb_dump(struct dsa_switch *ds, int port,
> +				   dsa_fdb_dump_cb_t *cb, void *data)
> +{
> +	struct ar9331_sw_priv *priv = (struct ar9331_sw_priv *)ds->priv;
> +	int cnt = AR9331_SW_NUM_ARL_RECORDS;
> +	struct ar9331_sw_fdb _fdb = { 0 };

Why use _fdb? There does not appear to be an fdb?

> +static int ar9331_sw_port_fdb_rmw(struct ar9331_sw_priv *priv,
> +				  const unsigned char *mac,
> +				  u8 port_mask_set,
> +				  u8 port_mask_clr)
> +{
> +	struct regmap *regmap = priv->regmap;
> +	u32 f0, f1, f2 = 0;
> +	u8 port_mask, port_mask_new, status, func;
> +	int ret;

Reverse Christmas tree.

> +static int ar9331_sw_port_fdb_add(struct dsa_switch *ds, int port,
> +				  const unsigned char *mac, u16 vid)
> +{
> +	struct ar9331_sw_priv *priv = (struct ar9331_sw_priv *)ds->priv;
> +	u16 port_mask = BIT(port);
> +
> +	dev_info(priv->dev, "%s(%pM, %x)\n", __func__, mac, port);

dev_dbg()?

	Andrew
