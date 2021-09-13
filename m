Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D19F4096B6
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 17:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344550AbhIMPGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 11:06:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243199AbhIMPGB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 11:06:01 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7666C0A893D;
        Mon, 13 Sep 2021 06:38:18 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id p2so14084591oif.1;
        Mon, 13 Sep 2021 06:38:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+A1PzhLE74Yrhc1O3usAzGVIUOozgkbbtbY+3Jj7aq0=;
        b=Kfk4WHVTxvJDzCU/g7sFltp5ZTejJF+ZqnqLWtduIYpUdHSJjWiouiG3Uis5RJHXVT
         8mbS881DwXU7XcvJihf9nIhGx5Gu1xrwPxcY3QRDt0A+QVOh3RiW4eyE1WCXTLjFwDIz
         x8o8haSW7/Ytrp/HtRqYATwVZeucP2CFQzL/fU95RhMIGmGjNsuJ9nFIccw3sAQkKOFS
         BmsbhG5r7W3Kp+zk2GZeFx2u1GCAPDPpCsA90yXEgdK+phVPgIdNSFGI2BNm0EYRp0a7
         0HVrYQ68vhgrx3y+Uy4+ETvKUmUyUQRKUfFLU5nHjqezelTR1vjJXE38kqkmYNcVvHsr
         z01Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+A1PzhLE74Yrhc1O3usAzGVIUOozgkbbtbY+3Jj7aq0=;
        b=TTcmgjJjmG4clnTK7UmBlxQ4502foTi7o0av070h6tbSZiW9L0qXPMEHciX6srjuLk
         Uex6zzz2NXL4lVZae1Frg8Nb+xn5CwaNerxio6NPpfgaA2hR2lNkw5UnY6I1AUUCJDMm
         XaapLrB81jHnt1IIfPhmF4DzFHKDsoYrQQMKSDH3QFN6b73BNdP2LrEmW2NliYz8rn1+
         dPHjMThoOi3yAevPNEoFxNDwk6od7nD6FPx7ahWKFEqFojZHqCsI4EK14jwkWeExh5nf
         I5Ts9JeYMJMJvHLKHs7dTwXTBYzyWrxldHKosV/LodwpSF6wrwijN/anHDt/GWVAUIi7
         05+w==
X-Gm-Message-State: AOAM5319gC1C0rSsFklqHfcjdultD32+h7hLH59Zf+7hM+8WZ8gYDGHr
        68hIhR9R5VyM9rwqiNgGgb82VbVLDzBjUcWNfg==
X-Google-Smtp-Source: ABdhPJy5rGtbHvHSEHFoArM2w+Ui69oLC2M+l3QGHrBxg0R3q8AlcvYS1p1U2h5yD9kNDLcff/O1zQaHDfQYNTpHHuA=
X-Received: by 2002:aca:6008:: with SMTP id u8mr8009784oib.127.1631540297900;
 Mon, 13 Sep 2021 06:38:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210912120932.993440-1-vladimir.oltean@nxp.com> <20210912120932.993440-6-vladimir.oltean@nxp.com>
In-Reply-To: <20210912120932.993440-6-vladimir.oltean@nxp.com>
From:   George McCollister <george.mccollister@gmail.com>
Date:   Mon, 13 Sep 2021 08:38:05 -0500
Message-ID: <CAFSKS=NjFM6FhaUntjZ30dbU50JYnNpjrZj2KL=HAgbxk+yyuQ@mail.gmail.com>
Subject: Re: [RFC PATCH net 5/5] net: dsa: xrs700x: be compatible with masters
 which unregister on shutdown
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>,
        linux-mediatek@lists.infradead.org,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 12, 2021 at 7:09 AM Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
>
> Since commit 2f1e8ea726e9 ("net: dsa: link interfaces with the DSA
> master to get rid of lockdep warnings"), DSA gained a requirement which
> it did not fulfill, which is to unlink itself from the DSA master at
> shutdown time.
>
> Since the Arrow SpeedChips XRS700x driver was introduced after the bad
> commit, it has never worked with DSA masters which decide to unregister
> their net_device on shutdown, effectively hanging the reboot process.
> To fix that, we need to call dsa_switch_shutdown.
>
> These devices can be connected by I2C or by MDIO, and if I search for
> I2C or MDIO bus drivers that implement their ->shutdown by redirecting
> it to ->remove I don't see any, however this does not mean it would not
> be possible. To be compatible with that pattern, it is necessary to
> implement an "if this then not that" scheme, to avoid ->remove and
> ->shutdown from being called both for the same struct device.
>
> Fixes: ee00b24f32eb ("net: dsa: add Arrow SpeedChips XRS700x driver")
> Link: https://lore.kernel.org/netdev/20210909095324.12978-1-LinoSanfilippo@gmx.de/
> Reported-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/dsa/xrs700x/xrs700x.c      |  6 ++++++
>  drivers/net/dsa/xrs700x/xrs700x.h      |  1 +
>  drivers/net/dsa/xrs700x/xrs700x_i2c.c  | 18 ++++++++++++++++++
>  drivers/net/dsa/xrs700x/xrs700x_mdio.c | 18 ++++++++++++++++++
>  4 files changed, 43 insertions(+)
>
> diff --git a/drivers/net/dsa/xrs700x/xrs700x.c b/drivers/net/dsa/xrs700x/xrs700x.c
> index 130abb0f1438..469420941054 100644
> --- a/drivers/net/dsa/xrs700x/xrs700x.c
> +++ b/drivers/net/dsa/xrs700x/xrs700x.c
> @@ -822,6 +822,12 @@ void xrs700x_switch_remove(struct xrs700x *priv)
>  }
>  EXPORT_SYMBOL(xrs700x_switch_remove);
>
> +void xrs700x_switch_shutdown(struct xrs700x *priv)
> +{
> +       dsa_switch_shutdown(priv->ds);
> +}
> +EXPORT_SYMBOL(xrs700x_switch_shutdown);
> +
>  MODULE_AUTHOR("George McCollister <george.mccollister@gmail.com>");
>  MODULE_DESCRIPTION("Arrow SpeedChips XRS700x DSA driver");
>  MODULE_LICENSE("GPL v2");
> diff --git a/drivers/net/dsa/xrs700x/xrs700x.h b/drivers/net/dsa/xrs700x/xrs700x.h
> index ff62cf61b091..4d58257471d2 100644
> --- a/drivers/net/dsa/xrs700x/xrs700x.h
> +++ b/drivers/net/dsa/xrs700x/xrs700x.h
> @@ -40,3 +40,4 @@ struct xrs700x {
>  struct xrs700x *xrs700x_switch_alloc(struct device *base, void *devpriv);
>  int xrs700x_switch_register(struct xrs700x *priv);
>  void xrs700x_switch_remove(struct xrs700x *priv);
> +void xrs700x_switch_shutdown(struct xrs700x *priv);
> diff --git a/drivers/net/dsa/xrs700x/xrs700x_i2c.c b/drivers/net/dsa/xrs700x/xrs700x_i2c.c
> index 489d9385b4f0..6deae388a0d6 100644
> --- a/drivers/net/dsa/xrs700x/xrs700x_i2c.c
> +++ b/drivers/net/dsa/xrs700x/xrs700x_i2c.c
> @@ -109,11 +109,28 @@ static int xrs700x_i2c_remove(struct i2c_client *i2c)
>  {
>         struct xrs700x *priv = i2c_get_clientdata(i2c);
>
> +       if (!priv)
> +               return 0;
> +
>         xrs700x_switch_remove(priv);
>
> +       i2c_set_clientdata(i2c, NULL);
> +
>         return 0;
>  }
>
> +static void xrs700x_i2c_shutdown(struct i2c_client *i2c)
> +{
> +       struct xrs700x *priv = i2c_get_clientdata(i2c);
> +
> +       if (!priv)
> +               return;
> +
> +       xrs700x_switch_shutdown(priv);
> +
> +       i2c_set_clientdata(i2c, NULL);
> +}
> +
>  static const struct i2c_device_id xrs700x_i2c_id[] = {
>         { "xrs700x-switch", 0 },
>         {},
> @@ -137,6 +154,7 @@ static struct i2c_driver xrs700x_i2c_driver = {
>         },
>         .probe  = xrs700x_i2c_probe,
>         .remove = xrs700x_i2c_remove,
> +       .shutdown = xrs700x_i2c_shutdown,
>         .id_table = xrs700x_i2c_id,
>  };
>
> diff --git a/drivers/net/dsa/xrs700x/xrs700x_mdio.c b/drivers/net/dsa/xrs700x/xrs700x_mdio.c
> index 44f58bee04a4..d01cf1073d49 100644
> --- a/drivers/net/dsa/xrs700x/xrs700x_mdio.c
> +++ b/drivers/net/dsa/xrs700x/xrs700x_mdio.c
> @@ -136,7 +136,24 @@ static void xrs700x_mdio_remove(struct mdio_device *mdiodev)
>  {
>         struct xrs700x *priv = dev_get_drvdata(&mdiodev->dev);
>
> +       if (!priv)
> +               return;
> +
>         xrs700x_switch_remove(priv);
> +
> +       dev_set_drvdata(&mdiodev->dev, NULL);
> +}
> +
> +static void xrs700x_mdio_shutdown(struct mdio_device *mdiodev)
> +{
> +       struct xrs700x *priv = dev_get_drvdata(&mdiodev->dev);
> +
> +       if (!priv)
> +               return;
> +
> +       xrs700x_switch_shutdown(priv);
> +
> +       dev_set_drvdata(&mdiodev->dev, NULL);
>  }
>
>  static const struct of_device_id __maybe_unused xrs700x_mdio_dt_ids[] = {
> @@ -155,6 +172,7 @@ static struct mdio_driver xrs700x_mdio_driver = {
>         },
>         .probe  = xrs700x_mdio_probe,
>         .remove = xrs700x_mdio_remove,
> +       .shutdown = xrs700x_mdio_shutdown,
>  };
>
>  mdio_module_driver(xrs700x_mdio_driver);
> --
> 2.25.1
>

Looks good to me.
Assuming we do Reviewed-by for RFCs:
Reviewed-by: George McCollister <george.mccollister@gmail.com>
