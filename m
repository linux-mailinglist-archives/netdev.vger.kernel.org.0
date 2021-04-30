Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF4AF36FD71
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 17:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbhD3PPJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 11:15:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbhD3PPI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 11:15:08 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30948C06174A;
        Fri, 30 Apr 2021 08:14:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=vkFMbuZAZ/puHNl5B/OrVt67vNKKlW694NLPue0ybHQ=; b=ETJkd5rAALSRQHU96f9wHczJ8n
        crIsJrjDIqi0M3Sz0s+TmvfaaZA4Im+odul9V3kDkkpfNrES2O6RNjIXoE9COlGx15bsdneNDusI3
        xSFURWW+3+Pyfew+b6/Y6++J4oUVSk+bDptDGUl6IZ7J9eWhHWmjjm3kQyeX+TiORTiNGIKTInrRc
        +f0ot2Jc8dOjciAtk5QzP1k6K+5BfQ+6iMpzZkqShdol6XpvSqgH9nO33QM5vLrqiHzq/DtlNd2D6
        BvNiw29R8vlCrnVxj5KRpUfKOsfzdVb1LMw+2Dk3nWHJ01o/Hfkr1NtyKzIc4bg4Tc8TWwsgPkUv+
        Zp2FrHOg==;
Received: from [2601:1c0:6280:3f0::df68]
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lcUpR-00BBpW-Tk; Fri, 30 Apr 2021 15:13:27 +0000
Subject: Re: [PATCH net-next v1 1/1] net: selftest: provide option to disable
 generic selftests
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com,
        Fabio Estevam <festevam@gmail.com>,
        David Jander <david@protonic.nl>,
        Russell King <linux@armlinux.org.uk>,
        Philippe Schenker <philippe.schenker@toradex.com>
References: <20210430095308.14465-1-o.rempel@pengutronix.de>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <f0905c84-6bb2-702f-9ae7-614dcd85c458@infradead.org>
Date:   Fri, 30 Apr 2021 08:13:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210430095308.14465-1-o.rempel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/30/21 2:53 AM, Oleksij Rempel wrote:
> Some systems may need to disable selftests to reduce kernel size or for
> some policy reasons. This patch provide option to disable generic selftests.
> 
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Fixes: 3e1e58d64c3d ("net: add generic selftest support")
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  net/Kconfig | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/net/Kconfig b/net/Kconfig
> index f5ee7c65e6b4..dac98c73fcd8 100644
> --- a/net/Kconfig
> +++ b/net/Kconfig
> @@ -431,7 +431,12 @@ config SOCK_VALIDATE_XMIT
>  
>  config NET_SELFTESTS
>  	def_tristate PHYLIB
> +	prompt "Support for generic selftests"
>  	depends on PHYLIB && INET
> +	help
> +	  These selftests are build automatically if any driver with generic

	                      built

> +	  selftests support is enabled. This option can be used to disable
> +	  selftests to reduce kernel size.
>  
>  config NET_SOCK_MSG
>  	bool
> 

Thanks for the patch/option. But I think it should just default to n,
not PHYLIB.

-- 
~Randy

