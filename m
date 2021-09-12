Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4D17407D88
	for <lists+netdev@lfdr.de>; Sun, 12 Sep 2021 15:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235322AbhILNT5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Sep 2021 09:19:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235178AbhILNTz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Sep 2021 09:19:55 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 859EAC061574;
        Sun, 12 Sep 2021 06:18:41 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id j13so9958562edv.13;
        Sun, 12 Sep 2021 06:18:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JjkuUFG8aC+b+dNRAS0GS2+3+6SH7OL6eP6H9dMuzpg=;
        b=BiD1DLf1/KO0J+5uDPTUYwSBh2enT2UXVgZYGoTFKRywIyeDX5XQIpvnhvAgZHP5st
         qhz3Wekn2YD6xs+28AmtEaUDMkeK7Jqy9QMk85cd0xF+bNoXh4djm644eAiIK/pNSxRi
         0MwT4zb/xuN4r4tF4zLuYDWeYjWUDxDfjdCEGHJaGu7z+pf/Go7zRQRBkebGaxq8BjTl
         po/wkDpWa07/rXmNVd72uodQMzucaseosATGHRjFK5XzVJ2ixVeNQM7xqjq6vrlH93Ma
         NYzVzggZ7Px7QBiqd2RGRrVxediX6V3kqAwUOPQpW5JTV+K+E1bSYZy6nxEXEo3kZeGY
         oh3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JjkuUFG8aC+b+dNRAS0GS2+3+6SH7OL6eP6H9dMuzpg=;
        b=pND7wKMxWvd1YpWAmHVKLvpRGrwBo2KgN0xbJ+Wb6l/DNfWE3NGdkmEkJ/lEg2rwos
         SufTlwP2YwsEZBzwXabRdNimnQ9TQPXV6k9wrnCwAFHLdV2aRMUd4ZFC3hcKIlEJ2NPL
         vo5fgkFlL4aDmCNwtCpbbGiJN0/eqOZ9zLTWWG6A+q6vIE92LkoE5rxZCKDJrB1bEJ9W
         d4V7NmnY/FtAId/zNItoikiZsxpJKfN1IZ3sxLjZtKGYWQ9dcJcFsfHEJ905eb876WbU
         e3x7prkUCtPHTZDfou9nF/f5fQlRHdZgIFH9bYWCz1z09xaZQro5womEJpmTtAsEfDC2
         8cmQ==
X-Gm-Message-State: AOAM533czWgwpNcao9bd5XBafihxXVEnYtSd1VYCAo1mjvlKozUi6YwC
        Q9tagJq4EgbBYbVw1G5e6nA=
X-Google-Smtp-Source: ABdhPJwU34hiWxo3W+6lr2nqbitJVT+uVLKsSOEIKBVD1dGl3QZsS9x7NyNMcwCYUhOZSyIM+lZHtw==
X-Received: by 2002:a05:6402:5c2:: with SMTP id n2mr8010126edx.239.1631452719669;
        Sun, 12 Sep 2021 06:18:39 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id a15sm2425158edr.2.2021.09.12.06.18.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Sep 2021 06:18:39 -0700 (PDT)
Date:   Sun, 12 Sep 2021 16:18:37 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        George McCollister <george.mccollister@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: Re: [RFC PATCH net 2/5] net: dsa: be compatible with masters which
 unregister on shutdown
Message-ID: <20210912131837.4i6pzwgn573xutmo@skbuf>
References: <20210912120932.993440-1-vladimir.oltean@nxp.com>
 <20210912120932.993440-3-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210912120932.993440-3-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 12, 2021 at 03:09:29PM +0300, Vladimir Oltean wrote:
> +static int b53_mmap_shutdown(struct platform_device *pdev)
> +{
> +	struct b53_device *dev = platform_get_drvdata(pdev);
> +
> +	if (dev)
> +		b53_switch_shutdown(dev);
> +
> +	platform_set_drvdata(pdev, NULL);
> +}
> +
>  static const struct of_device_id b53_mmap_of_table[] = {
>  	{ .compatible = "brcm,bcm3384-switch" },
>  	{ .compatible = "brcm,bcm6328-switch" },
> @@ -331,6 +343,7 @@ MODULE_DEVICE_TABLE(of, b53_mmap_of_table);
>  static struct platform_driver b53_mmap_driver = {
>  	.probe = b53_mmap_probe,
>  	.remove = b53_mmap_remove,
> +	.shutdown = b53_mmap_shutdown,
>  	.driver = {
>  		.name = "b53-switch",
>  		.of_match_table = b53_mmap_of_table,

I forgot to enable all variants of the b53 driver, and as such, the mmap
version fails to build (the shutdown function should return void, not int).

I will fix this when I send the v2 patch, but I will not send that now,
as I would like to get some feedback on the approach first.
