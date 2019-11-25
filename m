Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E142108B86
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 11:20:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727426AbfKYKUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 05:20:06 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:38627 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727266AbfKYKUE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 05:20:04 -0500
Received: by mail-ed1-f66.google.com with SMTP id s10so12161124edi.5;
        Mon, 25 Nov 2019 02:20:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s00peLUfoWinM2SfHWjbV7HKo9HO7vaFN9uRGqLoplI=;
        b=L/oZrUep+QpQeWsilYHaY3WFk8O/BvCHFYw79CHFPxO8m1V7gp2NR0E5pL7z81kPpB
         jXW0p1YKJykMxwweaku5N5A3yOBcgQL4gr3fMX+CUY4gLQvN0LllxlY7Eh4AVVgOHxdN
         AY+hvttlqf1HRL6cxVqaPlSttxIKy8u1SjEs+D1meBh8wgZDFttHPWUjxb+NAlG65G8+
         ter3ccmtcVavXkFK2iTPVMYOLcbRMtAE1O3dyQuEeLrPS6laToIC9taqS2z3FUVnS66Z
         p3qLByC+Kt2MPSIa+U+aINPVj6Ih/Dr5yRDLKHDn1dvwEFBmp031VUIezqgHSzet3jfk
         nvzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s00peLUfoWinM2SfHWjbV7HKo9HO7vaFN9uRGqLoplI=;
        b=lQUSiIXtajRzmtFk0T/3DjnocRDmvwvuxTki7NHNqmOgyykNgxOQydaRHfx9XKXFKv
         fy+nRbfSZSreEuv3BndnMf/+zQHL9iu6K/eGZGukIpQU9SMvqOqkLpA77kGD40eDq+DJ
         +DplEtcIu1zHhIJaoECIQ4WwALgDO/YC0ozBWkOTQHKnmuWw9gFvxdvczYF14j0URZkC
         vmHfmmtc+/FWXJvZlGcSA4FXbblSx2YBHhhWakmkY0WL9Ua6FtpAiZAi4wmAW6fTI/0i
         MYwqQQtzH4sRW6NwbL6ex8zxkc7p2rzVzc8jvvmuf5OGwRBNlgVQo2V1XVVTLGkzcutI
         l2Lg==
X-Gm-Message-State: APjAAAU6T3c+KtYZbQ9DHnyp4z/2FJNgrDv2xBvP+1CQHSZ+PonxkznB
        QsEPPIS6zLaerEz36qbJfNU8NwwuRTQARAIFigo=
X-Google-Smtp-Source: APXvYqy0BsUCpD6s3pntKidc8OTKecnUvGQDaid6kEAAFpRt+BWseGNpF3yFueq2wMxleXEIJMZNMGg1sVWJmuk3i7s=
X-Received: by 2002:a05:6402:51:: with SMTP id f17mr17586667edu.123.1574677201422;
 Mon, 25 Nov 2019 02:20:01 -0800 (PST)
MIME-Version: 1.0
References: <20191125100259.5147-1-o.rempel@pengutronix.de>
In-Reply-To: <20191125100259.5147-1-o.rempel@pengutronix.de>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 25 Nov 2019 12:19:50 +0200
Message-ID: <CA+h21hrOO6AFhvXQL47LwqCKU9vpRZ47feWB6fkn=WfrdZr6tA@mail.gmail.com>
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

Hi Oleksij,

On Mon, 25 Nov 2019 at 12:03, Oleksij Rempel <o.rempel@pengutronix.de> wrote:
>
> Currently we will get "Probed switch chip" notification multiple times
> if first probe filed by some reason. To avoid this confusing notifications move
> dev_info to the end of probe.
>
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
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

I don't think cosmetic patches should be send against the "net" tree.
At the very least I would not keep the RGMII delays fix and this one
in the same series, since they aren't related and they can be applied
independently.

If you want to actually fix something, there is also a memory leak
related to this. It is present in most DSA drivers. When
dsa_register_switch returns -EPROBE_DEFER, anything allocated with
devm_kzalloc will be overwritten and the old memory will leak. It's a
bit tricky to solve though, and especially tricky to figure out a
proper Fixes: tag, since that devm_kzalloc was also hidden in
dsa_switch_alloc for most of the time (which in net-next was
eliminated by Vivien, thus making it more obvious).

So I think some better mechanism should be thought of, that as little
as possible is done in the period of time where -EPROBE_DEFER can be
returned.

Thanks,
-Vladimir
