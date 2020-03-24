Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5243C190B5F
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 11:49:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727227AbgCXKtV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 06:49:21 -0400
Received: from bmailout1.hostsharing.net ([83.223.95.100]:59317 "EHLO
        bmailout1.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727095AbgCXKtV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 06:49:21 -0400
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by bmailout1.hostsharing.net (Postfix) with ESMTPS id 8D931300034FE;
        Tue, 24 Mar 2020 11:49:19 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 5826214BAB7; Tue, 24 Mar 2020 11:49:19 +0100 (CET)
Date:   Tue, 24 Mar 2020 11:49:19 +0100
From:   Lukas Wunner <lukas@wunner.de>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH 09/14] net: ks8851: Split out SPI specific entries in
 struct ks8851_net
Message-ID: <20200324104919.djfirlzgwpjr52tk@wunner.de>
References: <20200323234303.526748-1-marex@denx.de>
 <20200323234303.526748-10-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200323234303.526748-10-marex@denx.de>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 24, 2020 at 12:42:58AM +0100, Marek Vasut wrote:
> +/**
> + * struct ks8851_net_spi - KS8851 SPI driver private data
> + * @ks8851: KS8851 driver common private data
> + * @spidev: The spi device we're bound to.
> + * @spi_msg1: pre-setup SPI transfer with one message, @spi_xfer1.
> + * @spi_msg2: pre-setup SPI transfer with two messages, @spi_xfer2.

You need to remove these kerneldoc entries further up from struct ks8851_net.


> +struct ks8851_net_spi {
> +	struct ks8851_net	ks8851;	/* Must be first */
> +	struct spi_device	*spidev;
> +	struct spi_message	spi_msg1;
> +	struct spi_message	spi_msg2;
> +	struct spi_transfer	spi_xfer1;
> +	struct spi_transfer	spi_xfer2[2];
> +};
> +
> +#define to_ks8851_spi(ks) container_of((ks), struct ks8851_net_spi, ks8851)

Since it's always the first entry in the struct, a cast instead of
container_of() would seem to be sufficient.

Thanks,

Lukas
