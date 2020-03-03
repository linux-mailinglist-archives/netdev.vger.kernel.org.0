Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB7FA177372
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 11:04:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728144AbgCCKES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 05:04:18 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:44878 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727121AbgCCKES (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 05:04:18 -0500
Received: by mail-ed1-f65.google.com with SMTP id g19so3520206eds.11;
        Tue, 03 Mar 2020 02:04:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0AD4bpZ8c1wq7SQSp4vgpTJGHedOrSryx6E4q6XFYFk=;
        b=SyoM0C84gbHJ5Jluoig5lRyl+cLIp3NOhJximlGPzAUZdfPngJd4IIUHv1YOPdTqXd
         nhM3ABo8W1AIKxhv9fWas516GZIDJX98ZP5GgG+RTSEKPT86ulM/LnmcwUWoudG926M5
         JHZXwumAM9oak9e4eI0uh6005tonqOlK7tRtvA1t9+nulplTSS+PtGhsCwltVVld8Jp2
         MkorfG49ZzzxTs/gmTqwbWB0pJKtLzlqdDIdI/Qi0hhERWGDRXrKrUXf6ZzimJhtsaDI
         HeHe3y4gIRXmPFzSDWx9/FNHXJt8uyIn67agWXubB4Ee8PcYuSz/f+xfb+k+3SnwOfhw
         xZXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0AD4bpZ8c1wq7SQSp4vgpTJGHedOrSryx6E4q6XFYFk=;
        b=s7wfMCGJ46QVY4+kSOKqvQZxigyrNDQXh4WM+FHsdTAoD2o3hdwRQ0FAQwcI5oFrj9
         F5Nob/S2YI8nsaZje4yJTsXduZpr8MPKQsZKX3DzhDj7NMTftrYyfVF1WpzSHGph9hpl
         zlXRJQxEvrHkQC6ET/3hKa/gnJAr2jYS4NGYqeawjIrlCUHV206n1BVW+2HWkSN48Lxd
         YE3Mg9kjeWUn1NXsweLN0oec85HocMXfUFB5UDBFClZME8ngfUu7xq1dW3RjGFJiE5GR
         kxRzk65GqWpp1+0Uj8OWgUUWJzB3HLuiY24x9MJuIjZI73Hm88TVRr0Z2Q5oKhzrTEac
         sEcg==
X-Gm-Message-State: ANhLgQ3ixFHI/5Ybs/VYxJAl6rbaeXWKr6IDgIsocBsKZ0O7HaKsUAbQ
        0L5Hu23IjvKnuSVweslG+xzT6YylIpgeRwV9oDosjA==
X-Google-Smtp-Source: ADFU+vsLRLu5CHq+4KDeNc9afsPRrbpSLhURhzK+3Pwhm0HC+0bu+COR0T6jrEwJk36YWXYuiJcHtrPO3fI+aoD3OXU=
X-Received: by 2002:aa7:d50b:: with SMTP id y11mr3185084edq.139.1583229855409;
 Tue, 03 Mar 2020 02:04:15 -0800 (PST)
MIME-Version: 1.0
References: <20200303074414.30693-1-o.rempel@pengutronix.de>
In-Reply-To: <20200303074414.30693-1-o.rempel@pengutronix.de>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 3 Mar 2020 12:04:04 +0200
Message-ID: <CA+h21hrkVr4-Bgop0bor9nkKDUm4dYdyuDWJ_jthjKpy98ZQ1A@mail.gmail.com>
Subject: Re: [PATCH v1] net: dsa: sja1105: add 100baseT1_Full support
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     mkl@pengutronix.de, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>, kernel@pengutronix.de,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, david@protonic.nl,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 3 Mar 2020 at 09:44, Oleksij Rempel <o.rempel@pengutronix.de> wrote:
>
> Validate 100baseT1_Full to make this driver work with TJA1102 PHY.
>
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---

I was expecting this patch sooner or later.

Acked-by: Vladimir Oltean <olteanv@gmail.com>

I should take this opportunity and express the fact that it is strange
for MAC drivers to have to sign off all possible copper and fiber
media types in their .phylink_validate method. Sooner or later
somebody is going to want to add 1000Base-T1 too. I don't think it is
going to scale very well. Russell, with your plan to make MAC drivers
just populate a bitmap of phy_modes (MII side), is it also going to
get rid of media side validation?

>  drivers/net/dsa/sja1105/sja1105_main.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
> index 34544b1c30dc..7b5a80ba12bd 100644
> --- a/drivers/net/dsa/sja1105/sja1105_main.c
> +++ b/drivers/net/dsa/sja1105/sja1105_main.c
> @@ -866,6 +866,7 @@ static void sja1105_phylink_validate(struct dsa_switch *ds, int port,
>         phylink_set(mask, MII);
>         phylink_set(mask, 10baseT_Full);
>         phylink_set(mask, 100baseT_Full);
> +       phylink_set(mask, 100baseT1_Full);
>         if (mii->xmii_mode[port] == XMII_MODE_RGMII)
>                 phylink_set(mask, 1000baseT_Full);
>
> --
> 2.25.0
>

Regards,
-Vladimir
