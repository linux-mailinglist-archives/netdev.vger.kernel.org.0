Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB6F843BE59
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 02:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240359AbhJ0AKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 20:10:40 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60680 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230500AbhJ0AKj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 20:10:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=l3HKwrI4aii/N0e3D8E0FITj+tQPQCyffkihHJ5j0nc=; b=n3q9Nv1+OxmGCua+s3bMYSsIw0
        v4zsQ7/sayqijhOCuHnryTEhDexB3O5CNiNM3TkuySjXvXqEmMJJFp3kKOCu4Pdq/B39BombxpMJR
        Cds3ckIsl9FUw4fj9iKtev+oMdO0m9Xdtx+M3GjF1Myt+5TChIIILEEY8RXs7d9pmkaM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mfWU8-00Bpoe-Nx; Wed, 27 Oct 2021 02:08:04 +0200
Date:   Wed, 27 Oct 2021 02:08:04 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Corentin Labbe <clabbe@baylibre.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linus.walleij@linaro.org,
        ulli.kroll@googlemail.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: cortina: permit to set mac address in DT
Message-ID: <YXiYZGEiVMLdN1zt@lunn.ch>
References: <20211026191703.1174086-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211026191703.1174086-1-clabbe@baylibre.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 07:17:03PM +0000, Corentin Labbe wrote:
> Add ability of setting mac address in DT for cortina ethernet driver.
> 
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> ---
>  drivers/net/ethernet/cortina/gemini.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
> index 941f175fb911..f6aa2387a1af 100644
> --- a/drivers/net/ethernet/cortina/gemini.c
> +++ b/drivers/net/ethernet/cortina/gemini.c
> @@ -2356,12 +2356,14 @@ static void gemini_port_save_mac_addr(struct gemini_ethernet_port *port)
>  static int gemini_ethernet_port_probe(struct platform_device *pdev)
>  {
>  	char *port_names[2] = { "ethernet0", "ethernet1" };
> +	struct device_node *np = pdev->dev.of_node;
>  	struct gemini_ethernet_port *port;
>  	struct device *dev = &pdev->dev;
>  	struct gemini_ethernet *geth;
>  	struct net_device *netdev;
>  	struct device *parent;
>  	unsigned int id;
> +	u8 mac[ETH_ALEN];

Off by one in terms of reverse Christmas tree.

    Andrew
