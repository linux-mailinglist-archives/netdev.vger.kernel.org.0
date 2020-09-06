Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91AAD25EF5B
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 19:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729156AbgIFRZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Sep 2020 13:25:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:59026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725816AbgIFRZS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Sep 2020 13:25:18 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D84A220738;
        Sun,  6 Sep 2020 17:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599413118;
        bh=YA6BXBaVAzMARXXVWIRzJEr/Ljjjo9xio4vkwKodA8I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Y1k/cLgtlwkbC5QtE7GzggDZx53kECoiysZ8zN9+CR4uJuf1NdhdyHbMmBJaAuvss
         kwK+kQ0mffaInUzSP4njgtYtKil7lyfsMkDWAOS7YbIAlLwvF58Dug3HUJeSRnParC
         SE/V1z7H+wEFEoTGpqCw1RKXUs3u2/LnYOJ1DyVw=
Date:   Sun, 6 Sep 2020 10:25:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [net-next PATCH v2] net: gemini: Clean up phy registration
Message-ID: <20200906102516.5d1f4014@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200905204257.51044-1-linus.walleij@linaro.org>
References: <20200905204257.51044-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  5 Sep 2020 22:42:57 +0200 Linus Walleij wrote:
> diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
> index ffec0f3dd957..94707c9dda88 100644
> --- a/drivers/net/ethernet/cortina/gemini.c
> +++ b/drivers/net/ethernet/cortina/gemini.c

> @@ -2505,6 +2491,13 @@ static int gemini_ethernet_port_probe(struct platform_device *pdev)
>  	if (ret)
>  		goto unprepare;
>  
> +	ret = gmac_setup_phy(netdev);
> +	if (ret) {
> +		netdev_err(netdev,
> +			   "PHY init failed\n");
> +		return ret;

goto unprepare?

> +	}
> +
>  	ret = register_netdev(netdev);
>  	if (ret)
>  		goto unprepare;
