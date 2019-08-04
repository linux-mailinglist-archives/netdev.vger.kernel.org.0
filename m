Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13E9E80C34
	for <lists+netdev@lfdr.de>; Sun,  4 Aug 2019 21:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbfHDThV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 15:37:21 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:33631 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726392AbfHDThV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 15:37:21 -0400
Received: by mail-ed1-f65.google.com with SMTP id i11so13279270edq.0;
        Sun, 04 Aug 2019 12:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uu9ggnEL8pscFuPcI8b5MtS4sG4ftBvqhUKxW+eJ/v8=;
        b=CyGi5mVOYhNseg8wVhyBX7z1WKM4QRvNO7eVbej4F59kZn6RS3e7bXCRkChJn97+Oq
         +CLYtXCR7jrJ8fkRgEsKu80VmcJ9EG37RTTJKqBzZ93kJMgY0AMi/JlWG3EpypyOVwsl
         DAA5KoQc4jw4BOehb+HFTdj0mUN4R5/8nMGtBPqr314d/a65Oss/3AdTJ+dGa5wYOITz
         r4L0H5lztKUGK6e+xXN7cJIhrV0DZ1Bnsm7JvbJ2HJ8Mpr5SJZtg4obU/hW77MZSSV2t
         iYpyy/eiyYK6aRdR83P0IAtVBWXEZ+q/kSvZRTkyf4w9oymtRQ4gl+JRe54acnVaBNU7
         m32Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uu9ggnEL8pscFuPcI8b5MtS4sG4ftBvqhUKxW+eJ/v8=;
        b=GkYdw8wZCUNygFMHbA7ZlbMLcPkRhqM8h0ur/f4Kvl3mBr8qDYmGdozkGAVaelTkua
         XZOXV8Bk3K8XqCWWfKB3Hm/VGuH22wnUpfxwhF/j9enGQEEfD0FicHs4JOMLWRLb5yaU
         nYLthKEdz8Tr0KMXAXQT8MoVSw5wHVRfaL5Oos3zPI+XXK2gImHMg1dImzx1jtY0hhAa
         /PR1WKiR5VkKrbRDZZ/CQR8pA/rloJqtUPt8oofvi1Zol2IBxOeBNOrZZA+04YYojhIS
         8KLcOnuKYYTmeHC1ELGBVIjUq55Ywn3DJizRYrLQwOE+iZvG73F3OZFdmMfUkeDHFj9o
         ITKg==
X-Gm-Message-State: APjAAAUCuHgdbxpmLkLOBcs817QWD7cjXyyyLjnkmq4h+SnqP/rBHt22
        OiWq9J6O40ASnbL24/qAQSLkz1lvHFvfMxzrX5Y=
X-Google-Smtp-Source: APXvYqw2sv5K1GmCBhppj8uRXdoWOaN4uGMlMGxEiMQHOMCpDYIXUZNis+bWd16dS4x1XChpiD6flKKBh822UFNXvOc=
X-Received: by 2002:a50:ba19:: with SMTP id g25mr129729243edc.123.1564947439502;
 Sun, 04 Aug 2019 12:37:19 -0700 (PDT)
MIME-Version: 1.0
References: <20190731154239.19270-1-h.feurstein@gmail.com>
In-Reply-To: <20190731154239.19270-1-h.feurstein@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sun, 4 Aug 2019 22:37:08 +0300
Message-ID: <CA+h21hqqP0kMpt47GhStCPq2Yt1d_7JuFaoqVyWbFZrh4Am4hw@mail.gmail.com>
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: drop adjust_link to enabled phylink
To:     Hubert Feurstein <h.feurstein@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 31 Jul 2019 at 18:43, Hubert Feurstein <h.feurstein@gmail.com> wrote:
>
> We have to drop the adjust_link callback in order to finally migrate to
> phylink.
>
> Otherwise we get the following warning during startup:
>   "mv88e6xxx 2188000.ethernet-1:10: Using legacy PHYLIB callbacks. Please
>    migrate to PHYLINK!"
>
> The warning is generated in the function dsa_port_link_register_of in
> dsa/port.c:
>
>   int dsa_port_link_register_of(struct dsa_port *dp)
>   {
>         struct dsa_switch *ds = dp->ds;
>
>         if (!ds->ops->adjust_link)
>                 return dsa_port_phylink_register(dp);
>
>         dev_warn(ds->dev,
>                  "Using legacy PHYLIB callbacks. Please migrate to PHYLINK!\n");
>         [...]
>   }
>
> Signed-off-by: Hubert Feurstein <h.feurstein@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

>  drivers/net/dsa/mv88e6xxx/chip.c | 26 --------------------------
>  1 file changed, 26 deletions(-)
>
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index 366f70bfe055..37e8babd035f 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -27,7 +27,6 @@
>  #include <linux/platform_data/mv88e6xxx.h>
>  #include <linux/netdevice.h>
>  #include <linux/gpio/consumer.h>
> -#include <linux/phy.h>
>  #include <linux/phylink.h>
>  #include <net/dsa.h>
>
> @@ -482,30 +481,6 @@ static int mv88e6xxx_phy_is_internal(struct dsa_switch *ds, int port)
>         return port < chip->info->num_internal_phys;
>  }
>
> -/* We expect the switch to perform auto negotiation if there is a real
> - * phy. However, in the case of a fixed link phy, we force the port
> - * settings from the fixed link settings.
> - */
> -static void mv88e6xxx_adjust_link(struct dsa_switch *ds, int port,
> -                                 struct phy_device *phydev)
> -{
> -       struct mv88e6xxx_chip *chip = ds->priv;
> -       int err;
> -
> -       if (!phy_is_pseudo_fixed_link(phydev) &&
> -           mv88e6xxx_phy_is_internal(ds, port))
> -               return;
> -
> -       mv88e6xxx_reg_lock(chip);
> -       err = mv88e6xxx_port_setup_mac(chip, port, phydev->link, phydev->speed,
> -                                      phydev->duplex, phydev->pause,
> -                                      phydev->interface);
> -       mv88e6xxx_reg_unlock(chip);
> -
> -       if (err && err != -EOPNOTSUPP)
> -               dev_err(ds->dev, "p%d: failed to configure MAC\n", port);
> -}
> -
>  static void mv88e6065_phylink_validate(struct mv88e6xxx_chip *chip, int port,
>                                        unsigned long *mask,
>                                        struct phylink_link_state *state)
> @@ -4755,7 +4730,6 @@ static int mv88e6xxx_port_egress_floods(struct dsa_switch *ds, int port,
>  static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
>         .get_tag_protocol       = mv88e6xxx_get_tag_protocol,
>         .setup                  = mv88e6xxx_setup,
> -       .adjust_link            = mv88e6xxx_adjust_link,
>         .phylink_validate       = mv88e6xxx_validate,
>         .phylink_mac_link_state = mv88e6xxx_link_state,
>         .phylink_mac_config     = mv88e6xxx_mac_config,
> --
> 2.22.0
>
