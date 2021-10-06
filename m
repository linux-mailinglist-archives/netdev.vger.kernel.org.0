Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A33204240B2
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 17:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239047AbhJFPEl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 11:04:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238226AbhJFPEl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 11:04:41 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4CFFC061746
        for <netdev@vger.kernel.org>; Wed,  6 Oct 2021 08:02:48 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id y23so11998467lfb.0
        for <netdev@vger.kernel.org>; Wed, 06 Oct 2021 08:02:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=R4UxXX9KG4xRnVHb1QP83F57gPSySRp26PaptBp9W+E=;
        b=c2A8rXvYzl1XNvZe6X4yZXQ3DLXLxHVa95fIeuj9rBZ45m5+8eQqA0RVm1pT9i5zOe
         IP0uAHiT77O47MvBhw0735+i5MKafDMF8rm3XY3+GiY3sm1DHFCDtLS1irEQ7rjem6PH
         z6EPzmh3XFxdiXENPbjV4F/Nf8XkcT+AS3X7bYULQ8nuQH/96YZs/87VtOMKIKoncsmB
         wA9+TSN42zh2xgxKchxfLbMFWohuQcgnEa0N5aqbEa5qFEoqSh5C/B6sWPtyoLrUx+Wb
         saDrRNUR/xjybJOgghpZJTkrVZHaWjg59TzFmav3zbSgFAtoov70UgIuygPiykA8TN7O
         vaig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=R4UxXX9KG4xRnVHb1QP83F57gPSySRp26PaptBp9W+E=;
        b=6CyTDOywbMejk2y1TCUlvhsu2kxmCoQKorc1lx5gvK22efEHHW/2fTGT1C7ugnSKQ4
         +/p3RTPnEKJ5nvb28k1W0w3v2cN7E0/vif2T8Ldhi7agusb2LPooKZu5lJwA4yiea1km
         axzm26icE+x4vEoN17MxgwjqsLCUN7NGj7e1lHYbzT3SIJl3ZB0J5ZZgLtSnhDwWYBOv
         h658QyCm5iYydYA7QHPU3FfSH9Re4jClzz4IIGa+5lrDV9L3A8Iy49gqfBlpA4yBHkb+
         odhxX6HA6nNJsrWqIdONm9xGuALaJawnXtXc8RciFmRL25QLCgRFw/ocNsZpVwaUbtVl
         7sSQ==
X-Gm-Message-State: AOAM530W23KHgvvvHvx0iLXFYiffwvL6lFGehzeptUnray3wukkxscmT
        WYsQDixxaPjyBCoN3WFVbuPXSPnAo81JT7F2/Zhq9yhaCdU=
X-Google-Smtp-Source: ABdhPJwzkIcdOlAvbcG0LoR5b5rYqJwoDDhoAr9cF2QmPGsGTRkgcfVrKXVLKuhHnG+954Nczl0s2lh35/naoTki6mY=
X-Received: by 2002:a2e:85c2:: with SMTP id h2mr30410582ljj.367.1633532563483;
 Wed, 06 Oct 2021 08:02:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210920161136.2398632-1-Jerome.Pouiller@silabs.com>
 <20210930170646.cffsuytdpa72izbh@pali> <CAPDyKFoaw8rdPRdjgAJz3-T2_fS1iA9jtonbwZAYE0npUNfOQQ@mail.gmail.com>
 <149139701.nbvtKH4F0p@pc-42>
In-Reply-To: <149139701.nbvtKH4F0p@pc-42>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Wed, 6 Oct 2021 17:02:07 +0200
Message-ID: <CAPDyKFr62Kykg3=9WiXAV8UToqjw8gj4t6bbM7pGQ+iGGQRLmg@mail.gmail.com>
Subject: Re: [PATCH v7 08/24] wfx: add bus_sdio.c
To:     =?UTF-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <jerome.pouiller@silabs.com>
Cc:     =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        driverdevel <devel@driverdev.osuosl.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        DTML <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 Oct 2021 at 10:14, J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@sil=
abs.com> wrote:
>
> On Friday 1 October 2021 17:23:16 CEST Ulf Hansson wrote:
> > On Thu, 30 Sept 2021 at 19:06, Pali Roh=C3=A1r <pali@kernel.org> wrote:
> > > On Thursday 30 September 2021 18:51:09 J=C3=A9r=C3=B4me Pouiller wrot=
e:
> > > > On Thursday 30 September 2021 12:07:55 CEST Ulf Hansson wrote:
> > > > > On Mon, 20 Sept 2021 at 18:12, Jerome Pouiller
> > > > > <Jerome.Pouiller@silabs.com> wrote:
> > > > > >
> > > > > > From: J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com>
> > > > > >
> > > > > > Signed-off-by: J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silab=
s.com>
> > > > > > ---
> > > > > >  drivers/net/wireless/silabs/wfx/bus_sdio.c | 261 +++++++++++++=
++++++++
> > > > > >  1 file changed, 261 insertions(+)
> > > > > >  create mode 100644 drivers/net/wireless/silabs/wfx/bus_sdio.c
> > > > > >
> > > > > > diff --git a/drivers/net/wireless/silabs/wfx/bus_sdio.c b/drive=
rs/net/wireless/silabs/wfx/bus_sdio.c
> > > > >
> > > > > [...]
> > > > >
> > > > > > +
> > > > > > +static int wfx_sdio_probe(struct sdio_func *func,
> > > > > > +                         const struct sdio_device_id *id)
> > > > > > +{
> > > > > > +       struct device_node *np =3D func->dev.of_node;
> > > > > > +       struct wfx_sdio_priv *bus;
> > > > > > +       int ret;
> > > > > > +
> > > > > > +       if (func->num !=3D 1) {
> > > > > > +               dev_err(&func->dev, "SDIO function number is %d=
 while it should always be 1 (unsupported chip?)\n",
> > > > > > +                       func->num);
> > > > > > +               return -ENODEV;
> > > > > > +       }
> > > > > > +
> > > > > > +       bus =3D devm_kzalloc(&func->dev, sizeof(*bus), GFP_KERN=
EL);
> > > > > > +       if (!bus)
> > > > > > +               return -ENOMEM;
> > > > > > +
> > > > > > +       if (!np || !of_match_node(wfx_sdio_of_match, np)) {
> > > > > > +               dev_warn(&func->dev, "no compatible device foun=
d in DT\n");
> > > > > > +               return -ENODEV;
> > > > > > +       }
> > > > > > +
> > > > > > +       bus->func =3D func;
> > > > > > +       bus->of_irq =3D irq_of_parse_and_map(np, 0);
> > > > > > +       sdio_set_drvdata(func, bus);
> > > > > > +       func->card->quirks |=3D MMC_QUIRK_LENIENT_FN0 |
> > > > > > +                             MMC_QUIRK_BLKSZ_FOR_BYTE_MODE |
> > > > > > +                             MMC_QUIRK_BROKEN_BYTE_MODE_512;
> > > > >
> > > > > I would rather see that you add an SDIO_FIXUP for the SDIO card, =
to
> > > > > the sdio_fixup_methods[], in drivers/mmc/core/quirks.h, instead o=
f
> > > > > this.
> > > >
> > > > In the current patch, these quirks are applied only if the device a=
ppears
> > > > in the device tree (see the condition above). If I implement them i=
n
> > > > drivers/mmc/core/quirks.h they will be applied as soon as the devic=
e is
> > > > detected. Is it what we want?
> > > >
> > > > Note: we already have had a discussion about the strange VID/PID de=
clared
> > > > by this device:
> > > >   https://www.spinics.net/lists/netdev/msg692577.html
> > >
> > > Yes, vendor id 0x0000 is invalid per SDIO spec. So based on this vend=
or
> > > id, it is not possible to write any quirk in mmc/sdio generic code.
> > >
> > > Ulf, but maybe it could be possible to write quirk based on OF
> > > compatible string?
> >
> > Yes, that would be better in my opinion.
> >
> > We already have DT bindings to describe embedded SDIO cards (a subnode
> > to the mmc controller node), so we should be able to extend that I
> > think.
>
> So, this feature does not yet exist? Do you consider it is a blocker for
> the current patch?

Yes, sorry. I think we should avoid unnecessary hacks in SDIO func
drivers, especially those that deserve to be fixed in the mmc core.

Moreover, we already support the similar thing for eMMC cards, plus
that most parts are already done for SDIO too.

>
> To be honest, I don't really want to take over this change in mmc/core.

I understand. Allow me a couple of days, then I can post a patch to
help you out.

>
> --
> J=C3=A9r=C3=B4me Pouiller

Kind regards
Uffe
