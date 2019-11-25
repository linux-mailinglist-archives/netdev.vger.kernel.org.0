Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3C59108B8B
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 11:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727440AbfKYKWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 05:22:15 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:41673 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727133AbfKYKWO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 05:22:14 -0500
Received: by mail-ed1-f68.google.com with SMTP id a21so12137634edj.8;
        Mon, 25 Nov 2019 02:22:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pVANvWs2+jC3SmocbkUjd8tCAfu3FchChqY44ysSev0=;
        b=PqFvj7PdBChAuLSe4+klvLSJQ5+OWJVblfpPWf0WNQBJLh2VRKP5d0SXenVeYJ7gOS
         4y7y3Lxa9VCQ0tBodBhVLANhxXN7LR4Det8zxbzCX6A1p05vbd4h+6ZBkCQXbVhniU3h
         gfAy6S6SD0TU8tS5TOOhzMkAYdFwbKWNDO+n7O8aFbb9bZ94PSJ9EnM7I4y+tvmFqnEV
         Tpuws73CpKi6NhQyJ0xRtaHwwLKl7IGN6FdJ5khYwilIyXmmGHMur3DH/WRmooUpz3Sc
         W1MYtGithNo6SmjJ08HOuYwf0v8Axzirwud2uxy1XoSesxC9Nw341ZiUSgpKE5E8/pcx
         vyIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pVANvWs2+jC3SmocbkUjd8tCAfu3FchChqY44ysSev0=;
        b=pVPZqq6Vg0XcGynz66gccghrfBHtuL3fol11+terZV3kSbO8K8q/4qdsqeXpP+XFG7
         sd/WMwWonHZtjmf3fnJ9Eke733u8h8Y+XWyMUZ5CZN/F9GWdS0TmLVhBClj8ku8aQ2QP
         DOF1TQpbFzQVkMis+Ab74vQicMv5wAlcaE241J/r/xGdgUTQkrQGttWtn6Tep9tWgsUn
         2vtHlrPl301530RMxgHgjLmPfy8DhpnP9zCkUR8pkW7Bhp4NXa8qqOYNxPIMt9nxCYFP
         +1bnVcpQ1oPWO/Gi5vTIxHOeTrlEagXdlcIhotv/C8ltqfh1VDYwzq1vSpuouwIkFsGc
         93og==
X-Gm-Message-State: APjAAAWruPPCteIwKcL8/YiVH9xeLYzCNx2KvUaS56AfZT0FrKIcAmHz
        YBY3k2dF3qyiFXLWDGQX6pGQ1t0xZSq6TwpUnjavdw==
X-Google-Smtp-Source: APXvYqyPw47PjESWkbKFLFJ8LPOgO5BV+2lhg8QlMqo5plNbR4Ns89Gnwc1AeJBnw3K3Nv22jigJ80DMKF8fIfqnmyY=
X-Received: by 2002:a05:6402:51:: with SMTP id f17mr17594952edu.123.1574677332782;
 Mon, 25 Nov 2019 02:22:12 -0800 (PST)
MIME-Version: 1.0
References: <20191125100259.5147-1-o.rempel@pengutronix.de>
In-Reply-To: <20191125100259.5147-1-o.rempel@pengutronix.de>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 25 Nov 2019 12:22:01 +0200
Message-ID: <CA+h21hrwK-8TWcAowcLC5MOaqE+XYXdogmAE7TYVG5B3dG57cA@mail.gmail.com>
Subject: Re: [PATCH v1 1/2] net: dsa: sja1105: print info about probet chip
 only after every thing was done.
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     mkl@pengutronix.de, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, kernel@pengutronix.de,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, david@protonic.nl
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Nov 2019 at 12:03, Oleksij Rempel <o.rempel@pengutronix.de> wrote:
>
> Currently we will get "Probed switch chip" notification multiple times
> if first probe filed by some reason. To avoid this confusing notifications move
> dev_info to the end of probe.
>
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---

Also there are some typos which should be corrected:
probet -> probed
every thing -> everything
filed -> failed

"failed for some reason" -> "was deferred"

>  drivers/net/dsa/sja1105/sja1105_main.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
> index 7687ddcae159..1238fd68b2cd 100644
> --- a/drivers/net/dsa/sja1105/sja1105_main.c
> +++ b/drivers/net/dsa/sja1105/sja1105_main.c
> @@ -2191,8 +2191,6 @@ static int sja1105_probe(struct spi_device *spi)
>                 return rc;
>         }
>
> -       dev_info(dev, "Probed switch chip: %s\n", priv->info->name);
> -
>         ds = dsa_switch_alloc(dev, SJA1105_NUM_PORTS);
>         if (!ds)
>                 return -ENOMEM;
> @@ -2218,7 +2216,13 @@ static int sja1105_probe(struct spi_device *spi)
>
>         sja1105_tas_setup(ds);
>
> -       return dsa_register_switch(priv->ds);
> +       rc = dsa_register_switch(priv->ds);
> +       if (rc)
> +               return rc;
> +
> +       dev_info(dev, "Probed switch chip: %s\n", priv->info->name);
> +
> +       return 0;
>  }
>
>  static int sja1105_remove(struct spi_device *spi)
> --
> 2.24.0
>

Thanks,
-Vladimir
