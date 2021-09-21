Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 086C6412F85
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 09:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbhIUHeb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 03:34:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230160AbhIUHe2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 03:34:28 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0195C061574
        for <netdev@vger.kernel.org>; Tue, 21 Sep 2021 00:33:00 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id 194so26657946qkj.11
        for <netdev@vger.kernel.org>; Tue, 21 Sep 2021 00:33:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7ovs5q83bHL+D1OJfxB5RAczSsIYkfuAAEVFKvsO42U=;
        b=cuCR7qRr0UBrou/aPWxf7z7Nm3Gx73Nq70Hi36sXogbO3ONtBDWza1iKxi8SsGxhuE
         n5luR2YP462Gm8/Gf/WK0x6dN7xiRWWiGz1F8n9ggZmDuxf7YgVb+DppOzf/gJSLT5yE
         RJW1OBBwmNmROBQnSVFAEztAhy7IddAPB1ABbdbb8KjRdLqPJed7qdwVvDaS5JCKrMG2
         +oKQLILgsiq6c5HQ+Ym/W5GiNEW/Kj5PPa5Uk+kj5SY7u74ENmiD7yTX5+dfM+Y4Vnx9
         PBdWDC/X1L7o8mxP9WhqORmFcUYpKUUtMLD0uX4yocvZQgg0GNJH3pYajHmwdlPyxE+B
         4huw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7ovs5q83bHL+D1OJfxB5RAczSsIYkfuAAEVFKvsO42U=;
        b=QQkU7WRmol6oPoGH/sz4iL+vaI2uzlgLFuxRB8vR6R6GZETlQ8DIy6+1/nuVliS3/s
         8625rSRojNGTkhlybiXMiAtmI7ZfpAUvF6fIDO8xVfD+RkHNVD3qYpdzr3SiH5UWQVZy
         qm9ymabjFB3fTrrCcl8JxTNzUGlpFswH6Hjp6Vb8L26bka7luXP5hl+UHblFz3Oaj4kS
         HR1qH5+9bEuPAwRvXj6FN+YclTp/741bKWTLkj+qIfIf7qY6TOzPneyl7Se+rCBZE8MQ
         DWQb85gGrS3WQ80B16rbLjieGVFRWWQpXMjGMrGwKvqGQ+cSArRy8JBcDX8Dxni7nNri
         /GJg==
X-Gm-Message-State: AOAM53201FzQTZISoNqBdLfjcsJsOnvOSlYQjdpiLC78ic2s0Az95vSK
        Qj/S+4tIf8tl34BoR8AM/w+Xytd5yv54Y5/sVL3y2g==
X-Google-Smtp-Source: ABdhPJx2q/tUhc/xmqcgLTQSgzZXpL+WcqW2qwjZJtMbpIdND15bFTIJD7WtOI7xYdOJI1BZ1hAOjIYWISulXpqFmFA=
X-Received: by 2002:a25:12c4:: with SMTP id 187mr341743ybs.312.1632209580008;
 Tue, 21 Sep 2021 00:33:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210920214209.1733768-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210920214209.1733768-1-vladimir.oltean@nxp.com>
From:   Bartosz Golaszewski <bgolaszewski@baylibre.com>
Date:   Tue, 21 Sep 2021 09:32:49 +0200
Message-ID: <CAMpxmJUxw+9=JqJwDUDZaEVHkd4pr824j2Gq=-ci4PtoH9A=jA@mail.gmail.com>
Subject: Re: [PATCH net 0/2] Fix mdiobus users with devres
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Wolfram Sang <wsa@kernel.org>,
        linux-i2c <linux-i2c@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 20, 2021 at 11:42 PM Vladimir Oltean
<vladimir.oltean@nxp.com> wrote:
>
> Commit ac3a68d56651 ("net: phy: don't abuse devres in
> devm_mdiobus_register()") by Bartosz Golaszewski has introduced two
> classes of potential bugs by making the devres callback of
> devm_mdiobus_alloc stop calling mdiobus_unregister.
>
> The exact buggy circumstances are presented in the individual commit
> messages. I have searched the tree for other occurrences, but at the
> moment:
>
> - for issue (a) I have no concrete proof that other buses except SPI and
>   I2C suffer from it, and the only SPI or I2C device drivers that call
>   of_mdiobus_alloc are the DSA drivers that leave a NULL
>   ds->slave_mii_bus and a non-NULL ds->ops->phy_read, aka ksz9477,
>   ksz8795, lan9303_i2c, vsc73xx-spi.
>
> - for issue (b), all drivers which call of_mdiobus_alloc either use
>   of_mdiobus_register too, or call mdiobus_unregister sometime within
>   the ->remove path.
>
> Although at this point I've seen enough strangeness caused by this
> "device_del during ->shutdown" that I'm just going to copy the SPI and
> I2C subsystem maintainers to this patch series, to get their feedback
> whether they've had reports about things like this before. I don't think
> other buses behave in this way, it forces SPI and I2C devices to have to
> protect themselves from a really strange set of issues.
>
> Vladimir Oltean (2):
>   net: dsa: don't allocate the slave_mii_bus using devres
>   net: dsa: realtek: register the MDIO bus under devres
>
>  drivers/net/dsa/realtek-smi-core.c |  2 +-
>  net/dsa/dsa2.c                     | 12 +++++++++---
>  2 files changed, 10 insertions(+), 4 deletions(-)
>
> --
> 2.25.1
>

Hi Vladimir,

Thanks for the detailed description and sorry for the trouble this
caused. I will revisit this and go through the drivers using those
functions again and possibly come up with some improvement.

Acked-by: Bartosz Golaszewski <brgl@bgdev.pl>

Bartosz
