Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 312682765B9
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 03:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbgIXBKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 21:10:54 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52326 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726599AbgIXBKy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 21:10:54 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kLFmd-00FxIn-1n; Thu, 24 Sep 2020 03:10:51 +0200
Date:   Thu, 24 Sep 2020 03:10:51 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, linux@armlinux.org.uk
Subject: Re: [PATCH net-next v2 3/3] dpaa2-mac: add PCS support through the
 Lynx module
Message-ID: <20200924011051.GI3770354@lunn.ch>
References: <20200923154123.636-1-ioana.ciornei@nxp.com>
 <20200923154123.636-4-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200923154123.636-4-ioana.ciornei@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int dpaa2_pcs_create(struct dpaa2_mac *mac,
> +			    struct device_node *dpmac_node, int id)
> +{
> +	struct mdio_device *mdiodev;
> +	struct device_node *node;
> +
> +	node = of_parse_phandle(dpmac_node, "pcs-handle", 0);
> +	if (!node) {
> +		/* do not error out on old DTS files */
> +		netdev_warn(mac->net_dev, "pcs-handle node not found\n");
> +		return 0;
> +	}
> +
> +	if (!of_device_is_available(node) ||
> +	    !of_device_is_available(node->parent)) {
> +		netdev_err(mac->net_dev, "pcs-handle node not available\n");
> +		return -ENODEV;
> +	}

Can a child be available when its parent is not? I've no idea!

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
