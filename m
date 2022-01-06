Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2938348690D
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 18:47:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242307AbiAFRrP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 12:47:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242286AbiAFRqw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 12:46:52 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03788C061212;
        Thu,  6 Jan 2022 09:46:52 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id e202so9627464ybf.4;
        Thu, 06 Jan 2022 09:46:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hAigF3aNRm8SXiKNyYPtYfiDgs5b1MpEWjLvBm/tJa8=;
        b=eGMAPYAgBGaE13rv4QGD/ffg6wh1fb87PE9zAplN+tPmwBmb04djs4hEn1GWPstWBI
         l4+bewM6CablMRk/oXeBhZdv6rCn/HSPc3i6wRSvPaxkNPQg/dLVL1KFO2zhkVSsUyqD
         wPI5xjfECRxyUwyOCPcUpDRQim95yRI51dxX90J7SkcXzh54blsKDLODCgos8o5G2Ya5
         I6tWbcxdq8Te4quWpy/mjcntJPhkEwsDdNuD60OLdIwUCNV9/2KHJ0OecOuuPuuUjLjV
         9hNbdiC4kZRUoQM12nqgyVGzYlK+4gw3Cb2K5MQVjIien5jHl4I2WBspZjXLc5IQz3VU
         e6Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hAigF3aNRm8SXiKNyYPtYfiDgs5b1MpEWjLvBm/tJa8=;
        b=49YJtWyxLccqalEMKR7lrk6gHGDK4TphZHS3wN2Lls9IWFCpj4Rc8us4Z4rfFNT+wp
         gATnfpqaycYQ1H+j1+OYaiKiiTIwIWiwbmFL+HTl10GgsxE26Knq/4tkLW12tWXyx/Bn
         VDpFbSyJchU2K8RcSLaW+AAYa1aykRLDN3CT5zcww2h6fF/Q9MUDBUgG9EBWreaeL9go
         Lb4i7XE6JH8HuXUXlTLfKb/ITGnqybcRLknrE3Y6CIsZZzh0qByW1xehkk7q92Cz1K6S
         hrE8Av5o3tqgF+7zu2i+b5FKD/OGvXvnBbsZc1wX9JNL04dVDF5tOWw5g2sqFMx3YXhv
         8IEA==
X-Gm-Message-State: AOAM530DgAgb+vE6ZEw6KM9/mFYVSptVTStvRRuS4V3pEdCPt9ZApK6n
        udKtSj92LkpG2oSe111IG3yyJaCqqOzaJHJyyR5kbvNE7JQ=
X-Google-Smtp-Source: ABdhPJzPhHvgZ4sBE0eCVW7kQOFDDzs3uxp/E4oHS3gwHBnNDNg4m3c/bbkzxBlV5FM5QR2ZPANL7LaPDXw69W5N7WY=
X-Received: by 2002:a25:98c4:: with SMTP id m4mr76336835ybo.613.1641491211217;
 Thu, 06 Jan 2022 09:46:51 -0800 (PST)
MIME-Version: 1.0
References: <20220106114801.20563-1-prabhakar.mahadev-lad.rj@bp.renesas.com> <164148400405.10801.375398277921411297@Monstersaurus>
In-Reply-To: <164148400405.10801.375398277921411297@Monstersaurus>
From:   "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date:   Thu, 6 Jan 2022 17:46:25 +0000
Message-ID: <CA+V-a8saaXGBJweW9dE6+Vp8k2fpYob2tbVbhxCqK-PU_y1PWg@mail.gmail.com>
Subject: Re: [PATCH] can: rcar_canfd: Make sure we free CAN network device
To:     Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Pavel Machek <pavel@denx.de>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        linux-can@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kieran,

Thank you for the  review.

On Thu, Jan 6, 2022 at 3:46 PM Kieran Bingham
<kieran.bingham@ideasonboard.com> wrote:
>
> Quoting Lad Prabhakar (2022-01-06 11:48:00)
> > Make sure we free CAN network device in the error path. There are several
> > jumps to fail label after allocating the CAN network device successfully.
> > This patch places the free_candev() under fail label so that in failure
> > path a jump to fail label frees the CAN network device.
> >
> > Fixes: 76e9353a80e9 ("can: rcar_canfd: Add support for RZ/G2L family")
> > Reported-by: Pavel Machek <pavel@denx.de>
> > Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> > ---
> >  drivers/net/can/rcar/rcar_canfd.c | 5 ++---
> >  1 file changed, 2 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
> > index ff9d0f5ae0dd..388521e70837 100644
> > --- a/drivers/net/can/rcar/rcar_canfd.c
> > +++ b/drivers/net/can/rcar/rcar_canfd.c
> > @@ -1640,8 +1640,7 @@ static int rcar_canfd_channel_probe(struct rcar_canfd_global *gpriv, u32 ch,
> >         ndev = alloc_candev(sizeof(*priv), RCANFD_FIFO_DEPTH);
> >         if (!ndev) {
> >                 dev_err(&pdev->dev, "alloc_candev() failed\n");
> > -               err = -ENOMEM;
> > -               goto fail;
> > +               return -ENOMEM;
>
> Aha good - so we don't try to call free_candev() on a null pointer.
> (which doesn't look null-safe, in free_netdev).
>
Yep.

> >         }
> >         priv = netdev_priv(ndev);
> >
> > @@ -1735,8 +1734,8 @@ static int rcar_canfd_channel_probe(struct rcar_canfd_global *gpriv, u32 ch,
> >
> >  fail_candev:
>
> Is this label still appropriately named now that the free_candev is
> moved out of it? I wonder if it should be fail_netif:
>
I was tempted for this change, but wanted to keep the changes minimal.
Maybe I'll do it anyway to improve the readability.

> So aside from potential naming, the !ndev case is safely handled, so it
> looks fine to me.
>
>
> Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>
> >         netif_napi_del(&priv->napi);
> > -       free_candev(ndev);
> >  fail:
> > +       free_candev(ndev);
>
>
>
> >         return err;
> >  }
> >
> > --
> > 2.17.1
> >

Cheers,
Prabhakar
