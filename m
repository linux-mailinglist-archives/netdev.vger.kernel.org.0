Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02F9D34D04D
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 14:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231263AbhC2Mpk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 08:45:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231363AbhC2MpN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 08:45:13 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF319C061574;
        Mon, 29 Mar 2021 05:45:12 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a7so19240756ejs.3;
        Mon, 29 Mar 2021 05:45:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PRjvtr4F64Lfhlb500oBv4oKg6yHpyCw2SlD0qWwryU=;
        b=XK57e1dCm3jZAiJj1Hq1O9xpkLK+sjO6QIX20Xy5urts752G58q13Ey2E0AbxR6mEN
         QObTaMS54TQo3/dDAl4CyiTympMoqOcljosYp9tPC3bqJawZa6pM6wSiyRbqkp4Yda+z
         4Lsc9n+65sP7ibXp/gmHA/XOka3nVOcuTELm2/GIP4lYvabNKHe9YNQOd+JKK5G+rJ8u
         LfkY94E/MfXvXhRPnqbMwvJkA62+sGivKE1c5tl/nK1rlBqIZNjGKJ8uwHC4v8GsKo1G
         t6hsxWNYQsjkXIlxmP6IdUGxqN11vN4sxKJmiom6aixIUr1o10xC1JFWO4B8gXaouxqY
         dhOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PRjvtr4F64Lfhlb500oBv4oKg6yHpyCw2SlD0qWwryU=;
        b=jC/7d7znEN9F9TO9/BtgjG8rQTS6YPZt7dYqiJZKQVBY240RPNZhh3yNARQUJ88CvX
         tLcvzoFHKGdEldhZzAwlOkuJPetHfJZ6nnZ+V/0wBkrP1f+QwJb3yuBJm+OriOPOlxF+
         frsoJhDR0oIdWBhfzCPgQFsZCXb+BNCRjXlUs1v2Ev3TcrOwE7PTTkvb7U4VuOQcPYmh
         nxeYUr2ORUBnA7/x2BJBuWsxW+vuAZkvn0mOScpW89VoepERXzMyKcosEONvHPRm23t1
         xl8pCiRRspHp8dSbXb9W27C7BHluCpiLaKMMU7DTsNzVYhV3lS1l45wlM7Xpo3iMAXmN
         UN1Q==
X-Gm-Message-State: AOAM533H2oz5g1RaTNZy8FTtyviNL/EFNLbuhK4hmu4rIQ2GnDRSvKg/
        0CpaMhyZCfeCdoOvsFF0Q9VgKjWyHF+XRCoAlU4=
X-Google-Smtp-Source: ABdhPJzLjyvBi3ljZHfxd7NFG8eK4gJgPcDHpB4gdejVWYO7wINAxWSv/i65H/7AETTy1a3ouUk2ejg0NE7896GNpfU=
X-Received: by 2002:a17:906:ae8d:: with SMTP id md13mr28348994ejb.275.1617021911347;
 Mon, 29 Mar 2021 05:45:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210224115146.9131-1-aford173@gmail.com> <20210224115146.9131-4-aford173@gmail.com>
 <CAMuHMdXjQV7YrW5T_P4tkJk_d44NNTQ8Eu7v2ReESjg6R3tvfw@mail.gmail.com>
In-Reply-To: <CAMuHMdXjQV7YrW5T_P4tkJk_d44NNTQ8Eu7v2ReESjg6R3tvfw@mail.gmail.com>
From:   Adam Ford <aford173@gmail.com>
Date:   Mon, 29 Mar 2021 07:45:00 -0500
Message-ID: <CAHCN7xLWDx_AjtN7=moJ6VFsimuf16AJOhrxEryvdw5VnKsJwA@mail.gmail.com>
Subject: Re: [PATCH V3 4/5] net: ethernet: ravb: Enable optional refclk
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Adam Ford-BE <aford@beaconembedded.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 4, 2021 at 2:08 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>
> Hi Adam,
>
> On Wed, Feb 24, 2021 at 12:52 PM Adam Ford <aford173@gmail.com> wrote:
> > For devices that use a programmable clock for the AVB reference clock,
> > the driver may need to enable them.  Add code to find the optional clock
> > and enable it when available.
> >
> > Signed-off-by: Adam Ford <aford173@gmail.com>
>
> Thanks for your patch!
>
> > --- a/drivers/net/ethernet/renesas/ravb_main.c
> > +++ b/drivers/net/ethernet/renesas/ravb_main.c
> > @@ -2148,6 +2148,13 @@ static int ravb_probe(struct platform_device *pdev)
> >                 goto out_release;
> >         }
> >
> > +       priv->refclk = devm_clk_get_optional(&pdev->dev, "refclk");
> > +       if (IS_ERR(priv->refclk)) {
> > +               error = PTR_ERR(priv->refclk);
> > +               goto out_release;
> > +       }
> > +       clk_prepare_enable(priv->refclk);
> > +
>
> Shouldn't the reference clock be disabled in case of any failure below?
>
I'll generate a V4.

Should I just regenerate this patch since it seems like the rest are
OK, or should I regenerate the whole series?

adam
> >         ndev->max_mtu = 2048 - (ETH_HLEN + VLAN_HLEN + ETH_FCS_LEN);
> >         ndev->min_mtu = ETH_MIN_MTU;
> >
> > @@ -2260,6 +2267,9 @@ static int ravb_remove(struct platform_device *pdev)
> >         if (priv->chip_id != RCAR_GEN2)
> >                 ravb_ptp_stop(ndev);
> >
> > +       if (priv->refclk)
> > +               clk_disable_unprepare(priv->refclk);
> > +
> >         dma_free_coherent(ndev->dev.parent, priv->desc_bat_size, priv->desc_bat,
> >                           priv->desc_bat_dma);
> >         /* Set reset mode */
>
> Gr{oetje,eeting}s,
>
>                         Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
