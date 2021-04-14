Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53E8C35F480
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 15:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351114AbhDNNI3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 09:08:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232933AbhDNNIX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 09:08:23 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1E66C061574;
        Wed, 14 Apr 2021 06:08:01 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id e14so31270288ejz.11;
        Wed, 14 Apr 2021 06:08:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h2glotSQNv6sLqKL+wvYFAeO5knjRBKMj7UoWHlfyWc=;
        b=NtVk7QEN72VW9Nscr50h789KhTGxyVxK88UL1mfIGSrZ6YHIDLY2H+ylqi3osFVyL5
         HdBrkG/DVuG0makrWXeAABIUSdOrKrS2Ngx4ruxgT3O6zBYPigaZgic5pQEs1ickxZx/
         L+VKsO5+iGHne/kDMz/9wgOs8JcXqLSuEJOEZLPrTmunvdVDSTi4y5WDOmKBQvzBfXVv
         SkNJqNEzo6ObWXYlKWybUFh9SvSS9hNHeLJwEwxN62e0PyvGw9U8rvOVrpWBVbTSmwgP
         We6KZRaSD7fRkiOMiKDulLy4CPV4d3TmkZMNK+86RDSJ8mXZatcMKDiEVK3noGQ1GR7P
         BKzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h2glotSQNv6sLqKL+wvYFAeO5knjRBKMj7UoWHlfyWc=;
        b=sq3Us2gbG9popFIXlh7G5juItENdUSoATFjAjjuoSKPmL7+o6tI6aF/c4af+udz/zl
         qr1o2MLVlzv2x5AtsLqupmPi+YLGWMiLTrkhhZUvfAHh7rcx/4HT+3XXjMtVRM1gsBth
         XtYPlNSu8bZB9bU1yV7Iu2YcaDEuLasNjsA8sgNi9PkDFYonu2VAKKo0o0J5nw59XW1U
         dUJaLZxHoxolRTNcEslYLiaSH+d3lTSJ775M00nLsM4+HRrCgIUSeE6fLNXBB/vJui8B
         wQXEDZn5FE0bwpS/QC3ft3AbGSY/0C7KCc7hN2qtJyhSDqmV+Is9O6QJMmyj5QnCrX7J
         MzUQ==
X-Gm-Message-State: AOAM533nsGaUhkoqYkhbsB08FHzc80YxYOI8GVOxp0+409lsiTO8Ydcs
        H6+rYCiNkWKOgVwVoSoyw7NUQUPeLfpzRi5XzTdzvWkTX8J7FQ==
X-Google-Smtp-Source: ABdhPJwbTgtsFbu/4xK4uFMDsQriGW1hh3UnzmaB0mGG0/FYgZppfrJUndPRT2YiPoZu3AhX3Yts0eNXSFzObDpqDpw=
X-Received: by 2002:a17:906:44b:: with SMTP id e11mr30154715eja.551.1618405680381;
 Wed, 14 Apr 2021 06:08:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210412132619.7896-1-aford173@gmail.com> <20210412132619.7896-2-aford173@gmail.com>
 <CAMuHMdU5RfTGs3SCvJX9epKBLOo6o1BQMng49RjrBn+P7QOSeg@mail.gmail.com>
In-Reply-To: <CAMuHMdU5RfTGs3SCvJX9epKBLOo6o1BQMng49RjrBn+P7QOSeg@mail.gmail.com>
From:   Adam Ford <aford173@gmail.com>
Date:   Wed, 14 Apr 2021 08:07:49 -0500
Message-ID: <CAHCN7xKp1Lp+KAHwo_GobZoDKQCV9_7Yx2ZNKmTzkkShRBzm_Q@mail.gmail.com>
Subject: Re: [PATCH V4 2/2] net: ethernet: ravb: Enable optional refclk
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Adam Ford-BE <aford@beaconembedded.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 2:33 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>
> Hi Adam,
>
> On Mon, Apr 12, 2021 at 3:27 PM Adam Ford <aford173@gmail.com> wrote:
> > For devices that use a programmable clock for the AVB reference clock,
> > the driver may need to enable them.  Add code to find the optional clock
> > and enable it when available.
> >
> > Signed-off-by: Adam Ford <aford173@gmail.com>
> > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> >
> > ---
> > V4:  Eliminate the NULL check when disabling refclk, and add a line
> >      to disable the refclk if there is a failure after it's been
> >      initialized.
>
> Thanks for the update!
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
>
> Note that this will call clk_disable_unprepare() in case of failure, which is
> fine, as that function is a no-op in case of a failed clock.

Geert,

A bot reported that if I jump to out_release may try to free a clock
if some instances where priv isn't defined.
Currently, the priv->clk isn't freed either.  I have heard some
back-and-forth discussions in other threads on whether or not devm
functions auto free or not.

I'm fine with sending a V5 to make the free for the refclock happen
only when the priv has successfully initialized.  Should I also add
one for freeing priv->clk and change all the other goto out_release
commands to point to this new section?

I am thinking it would like something like:

free_refclk:
    clk_disable_unprepare(priv->refclk);
free_clk;
    clk_disable_unprepare(priv->clk);
out_release:
    free_netdev(ndev);
    ....


adam
>
> > +       }
> > +       clk_prepare_enable(priv->refclk);
> > +
> >         ndev->max_mtu = 2048 - (ETH_HLEN + VLAN_HLEN + ETH_FCS_LEN);
> >         ndev->min_mtu = ETH_MIN_MTU;
> >
> > @@ -2244,6 +2251,7 @@ static int ravb_probe(struct platform_device *pdev)
> >         if (chip_id != RCAR_GEN2)
> >                 ravb_ptp_stop(ndev);
> >  out_release:
> > +       clk_disable_unprepare(priv->refclk);
> >         free_netdev(ndev);
> >
> >         pm_runtime_put(&pdev->dev);
>
> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
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
