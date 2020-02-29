Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FFCF174580
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 08:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbgB2HTa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Feb 2020 02:19:30 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:43023 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbgB2HTa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Feb 2020 02:19:30 -0500
Received: by mail-lf1-f66.google.com with SMTP id s23so3777101lfs.10
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 23:19:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jsteward.moe; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WPAzadvMLcFlPpBLWtaNTOLgIC32jAs7Hyvm5Qo9aW8=;
        b=gMYIVksi0dFDz77rpt3nWQG/Hbw8CwsgDCQCdXqB5EaaSwfqyPDoUkkIn+fVol/cqY
         cDGgxbrZhLnZPXuQA83VrLqd7pTwRKPNHhAL5Bsv5/el09cthmQCTntCO1HJQueo4NGw
         MZsiM3G45ioDs0NOHOQtvFMecpMrrLNXTdDV4BaDPQ6Wu/oymVdc0U6lvrKhrOUjvnfT
         34PRY4/+MCUCmpYugIvuBeSlZa1x8sjkhChoqv8VBSfFkDRK4yH2dKDOjQMtB1ne+hVL
         DfUUInNw7nVWOlbGNRfRUrGYrt4ZyXJJf/K5McdInxStRKLcE3V1AYb8dz0pvJV+5900
         6RHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WPAzadvMLcFlPpBLWtaNTOLgIC32jAs7Hyvm5Qo9aW8=;
        b=DCUT3uCDAKfLwkNj0z0IEQ1wzjqakklC436EDj5hnC45loxiJpS1cZJ/uSvYWy/5V7
         Gedb4aB7a3fca6f/OVwjoQPwbFRjwS8EhzxyWUolv+dHAtnSUxW4aEOjL9P11C7mYxZC
         9Z7jJoA66t24C1QmWd0QnKywJxkuTmmlzndmWBTgtZlOWFcYP4E1b25pnrL1cwVjCh8V
         CL1e26I0+Ncffx7M3pEL3gxM8xMHNu5lncfPgTbVRdTkTu0HayBtgfmrmRtctwmSef+2
         C5VRkyOt7owLK/Uf9rCJ8VV5NYBhxI3nHRlix75SfSQ0XOTy5gQDIRBhyRgLghpyz0wH
         zAjw==
X-Gm-Message-State: ANhLgQ37H07zzI90hjunUlXin3P44+uae8dn9ROiYDS2fPCTl7BzvyYi
        ni7StP787/wL+XuwhbWS2R6jjxLeXkRRdljh2ngjOw==
X-Google-Smtp-Source: ADFU+vt6oKs6+JrOJlA7O2Sr7BLob3BFsLEYA8mJcI1RDRo8bDVa90StvFpMiiCb/X4KU+KZRfFEsYiq05NFuSIYy6o=
X-Received: by 2002:a19:ee0d:: with SMTP id g13mr4772580lfb.179.1582960766475;
 Fri, 28 Feb 2020 23:19:26 -0800 (PST)
MIME-Version: 1.0
References: <20200229070902.1294280-1-i@jsteward.moe>
In-Reply-To: <20200229070902.1294280-1-i@jsteward.moe>
From:   Pengcheng Xu <i@jsteward.moe>
Date:   Sat, 29 Feb 2020 15:19:15 +0800
Message-ID: <CADuippAvUXHH2Mjuxyz+9JFf-SR5j8itmRi5YvUJowmbVXR9Og@mail.gmail.com>
Subject: Re: [PATCH] net: macb: add support for fixed-link
To:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry for forgetting to CC the mailing lists.  Adding them now.

2020=E5=B9=B42=E6=9C=8829=E6=97=A5(=E5=9C=9F) 15:09 Pengcheng Xu <i@jstewar=
d.moe>:
>
> The Cadence macb driver did not support fixed-link PHYs.  This patch
> adds support for fixed-link PHYs to the driver.
>
> The driver only checks if there's a valid PHY over MDIO, which is either
> present as a device tree node, or (if absent) searched on the MDIO bus.
> This patch detects if there is a `fixed-link` PHY instead of a regular
> MDIO-attached PHY.  The device tree node of the MAC is checked for a
> fixed-link PHY via `of_phy_is_fixed_link`, and, if so, the normal MDIO
> register routine is skipped, and `of_phy_register_fixed_link` is
> performed instead.
>
> The changes were borrowed from
> drivers/net/ethernet/altera/altera_tse_main.c and tested to work on a
> Xilinx Zynq UltraScale+ device.
>
> Signed-off-by: Pengcheng Xu <i@jsteward.moe>
> ---
>  drivers/net/ethernet/cadence/macb_main.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ether=
net/cadence/macb_main.c
> index 2c28da1737fe..fb359ce90ae4 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -744,6 +744,7 @@ static int macb_mdiobus_register(struct macb *bp)
>
>  static int macb_mii_init(struct macb *bp)
>  {
> +       struct device_node *np =3D bp->pdev->dev.of_node;
>         int err =3D -ENXIO;
>
>         /* Enable management port */
> @@ -765,9 +766,17 @@ static int macb_mii_init(struct macb *bp)
>
>         dev_set_drvdata(&bp->dev->dev, bp->mii_bus);
>
> -       err =3D macb_mdiobus_register(bp);
> -       if (err)
> -               goto err_out_free_mdiobus;
> +       if (of_phy_is_fixed_link(np)) {
> +               err =3D of_phy_register_fixed_link(np);
> +               if (err) {
> +                       netdev_err(bp->dev, "cannot register fixed-link P=
HY\n");
> +                       goto err_out_free_mdiobus;
> +               }
> +       } else {
> +               err =3D macb_mdiobus_register(bp);
> +               if (err)
> +                       goto err_out_free_mdiobus;
> +       }
>
>         err =3D macb_mii_probe(bp->dev);
>         if (err)
> --
> 2.25.1
>
