Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 736043240AF
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 16:30:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233931AbhBXPUF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 10:20:05 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:55860 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237844AbhBXNss (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 08:48:48 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lEuWB-008EUB-7q; Wed, 24 Feb 2021 14:47:55 +0100
Date:   Wed, 24 Feb 2021 14:47:55 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Adam Ford <aford173@gmail.com>
Cc:     netdev@vger.kernel.org, aford@beaconembedded.com,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 4/5] net: ethernet: ravb: Enable optional refclk
Message-ID: <YDZZC+d9eti8RSbI@lunn.ch>
References: <20210224115146.9131-1-aford173@gmail.com>
 <20210224115146.9131-4-aford173@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210224115146.9131-4-aford173@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -2260,6 +2267,9 @@ static int ravb_remove(struct platform_device *pdev)
>  	if (priv->chip_id != RCAR_GEN2)
>  		ravb_ptp_stop(ndev);
>  
> +	if (priv->refclk)
> +		clk_disable_unprepare(priv->refclk);
> +

Hi Adam

You don't need the if (). The clk API is happy with a NULL pointer and
will do the right thing. Otherwise:

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
