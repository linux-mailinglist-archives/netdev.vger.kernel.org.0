Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 959CA361698
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 01:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235375AbhDOXx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 19:53:29 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54612 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235758AbhDOXx2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 19:53:28 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lXBn9-00GzB0-VQ; Fri, 16 Apr 2021 01:52:59 +0200
Date:   Fri, 16 Apr 2021 01:52:59 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 net-next 08/10] net: korina: Get mdio input clock via
 common clock framework
Message-ID: <YHjR244c9MJU9lli@lunn.ch>
References: <20210414230648.76129-1-tsbogend@alpha.franken.de>
 <20210414230648.76129-9-tsbogend@alpha.franken.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210414230648.76129-9-tsbogend@alpha.franken.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -1079,6 +1078,14 @@ static int korina_probe(struct platform_device *pdev)
>  			eth_hw_addr_random(dev);
>  	}
>  
> +	clk = devm_clk_get(&pdev->dev, NULL);

You should use a name here. It makes future expansion of the binding
easier. devm_clk_get_optional() is probably better. If there is a real
error it will return an error. If the clock does not exist, you get a
NULL. Real errors should cause the problem to fail, but with a NULL
you can use the fallback value.

You also need to document the device tree binding.

    Andrew
