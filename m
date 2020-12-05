Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7515C2CFCDA
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 19:51:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728789AbgLESTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 13:19:23 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:40330 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727681AbgLERoE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 12:44:04 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1klYZV-00AMfz-Ck; Sat, 05 Dec 2020 15:30:01 +0100
Date:   Sat, 5 Dec 2020 15:30:01 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Claudiu Beznea <claudiu.beznea@microchip.com>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        nicolas.ferre@microchip.com, linux@armlinux.org.uk,
        paul.walmsley@sifive.com, palmer@dabbelt.com, yash.shah@sifive.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org
Subject: Re: [PATCH 3/7] net: macb: unprepare clocks in case of failure
Message-ID: <20201205143001.GC2420376@lunn.ch>
References: <1607085261-25255-1-git-send-email-claudiu.beznea@microchip.com>
 <1607085261-25255-4-git-send-email-claudiu.beznea@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1607085261-25255-4-git-send-email-claudiu.beznea@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 04, 2020 at 02:34:17PM +0200, Claudiu Beznea wrote:
> Unprepare clocks in case of any failure in fu540_c000_clk_init().

Hi Claudiu

Nice patchset. Simple to understand.
> 

> +err_disable_clocks:
> +	clk_disable_unprepare(*tx_clk);

> +	clk_disable_unprepare(*hclk);
> +	clk_disable_unprepare(*pclk);
> +	clk_disable_unprepare(*rx_clk);
> +	clk_disable_unprepare(*tsu_clk);

This looks correct, but it would be more symmetrical to add a

macb_clk_uninit()

function for the four main clocks. I'm surprised it does not already
exist.

	Andrew
