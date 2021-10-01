Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68A2341F129
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 17:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354697AbhJAPZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 11:25:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232091AbhJAPZk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 11:25:40 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B0F4C06177C
        for <netdev@vger.kernel.org>; Fri,  1 Oct 2021 08:23:56 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id u18so40427174lfd.12
        for <netdev@vger.kernel.org>; Fri, 01 Oct 2021 08:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=HcXgng2hGoCgpa31It0A0pLwW+Q4lJvcKTzTM93uitk=;
        b=RFJCXjfPz7w+MgF8CFN1piJl7iQ8/TURuVojjSPJssZjjMtcBF9liI0WwJNfyFEEcd
         8IJSGrlA9u3b9pWEImoCky/7xFxWVqnXBg+dKziSgxFWho1RtTOFho0iLNT5Va/Pfr0z
         CLUDEENIVFDT1hlQWnfJK7Dcioabcr33NG3vFFewmv7Uky1hvd7bMjHgrXNJgBDAJhc1
         HWIP5+uxMehbvFplWuzCEvNm3/bj6BPP+wASfjqky2EetC1AMTYbX72aiCpjVBKiYjDq
         qD/+xxRSHt9ODqns8AAJAREeH/j10omS6wxAm8Pmcm2JHgakO4yZLEHgECVaK92EKVWg
         vyog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=HcXgng2hGoCgpa31It0A0pLwW+Q4lJvcKTzTM93uitk=;
        b=JbutV9GJNyj+d4zW1pcgQav5F7QirMZygggKgcvsjea6DzCjgF7+mi0jyCG5bTgKTT
         8xHZzswe6x3Y6Om5OEtDVHlfF/M/PuasBzxroFyvJurHgG29NhghoeQG5abOgIsxe2EH
         e48OkCZqTcUjLeDSH9YTckX5dolbBfh1Kufm6vtIVEJTU9LW3/QbLPDrgN0vGL12JoyH
         YC6uTFCGVUKu1vbj+ylNCf1gmnIvdX8WJusFT4HkeW8LnitsBQzBnzPqKu6GG7hJTwrY
         8jnMPjvF7O4xzpeEyIbHR2z3SxTuKLtu/ED8Yv4xR+5sGFcVf1KS+TFu6rOimp3pa6AY
         i5YQ==
X-Gm-Message-State: AOAM533etp5MeMPavW9uiXLAHmzZ57QtYrNYr9kcnX8+v6wkU/WeeMw/
        EtXIb+aafXhHHccckvCdBWxEFAlydvr8FH22wkcCPc+/Rto=
X-Google-Smtp-Source: ABdhPJyd+dupirVhzxZl8i5tUK5MA4VFOlbkWZql2eI+cR5FeK8ToELQVt75Qd+XOf7vM9xDkeQcoV0JFkAVU9VSXDY=
X-Received: by 2002:ac2:4157:: with SMTP id c23mr5908876lfi.184.1633101833061;
 Fri, 01 Oct 2021 08:23:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210920161136.2398632-1-Jerome.Pouiller@silabs.com>
 <20210920161136.2398632-9-Jerome.Pouiller@silabs.com> <CAPDyKFp2_41mScO=-Ev+kvYD5xjShQdLugU_2FTTmvzgCxmEWA@mail.gmail.com>
 <19731906.ZuIkq4dnIL@pc-42> <20210930170646.cffsuytdpa72izbh@pali>
In-Reply-To: <20210930170646.cffsuytdpa72izbh@pali>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Fri, 1 Oct 2021 17:23:16 +0200
Message-ID: <CAPDyKFoaw8rdPRdjgAJz3-T2_fS1iA9jtonbwZAYE0npUNfOQQ@mail.gmail.com>
Subject: Re: [PATCH v7 08/24] wfx: add bus_sdio.c
To:     =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
        =?UTF-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <jerome.pouiller@silabs.com>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
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

On Thu, 30 Sept 2021 at 19:06, Pali Roh=C3=A1r <pali@kernel.org> wrote:
>
> On Thursday 30 September 2021 18:51:09 J=C3=A9r=C3=B4me Pouiller wrote:
> > Hello Ulf,
> >
> > On Thursday 30 September 2021 12:07:55 CEST Ulf Hansson wrote:
> > > On Mon, 20 Sept 2021 at 18:12, Jerome Pouiller
> > > <Jerome.Pouiller@silabs.com> wrote:
> > > >
> > > > From: J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com>
> > > >
> > > > Signed-off-by: J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.co=
m>
> > > > ---
> > > >  drivers/net/wireless/silabs/wfx/bus_sdio.c | 261 +++++++++++++++++=
++++
> > > >  1 file changed, 261 insertions(+)
> > > >  create mode 100644 drivers/net/wireless/silabs/wfx/bus_sdio.c
> > > >
> > > > diff --git a/drivers/net/wireless/silabs/wfx/bus_sdio.c b/drivers/n=
et/wireless/silabs/wfx/bus_sdio.c
> > >
> > > [...]
> > >
> > > > +
> > > > +static int wfx_sdio_probe(struct sdio_func *func,
> > > > +                         const struct sdio_device_id *id)
> > > > +{
> > > > +       struct device_node *np =3D func->dev.of_node;
> > > > +       struct wfx_sdio_priv *bus;
> > > > +       int ret;
> > > > +
> > > > +       if (func->num !=3D 1) {
> > > > +               dev_err(&func->dev, "SDIO function number is %d whi=
le it should always be 1 (unsupported chip?)\n",
> > > > +                       func->num);
> > > > +               return -ENODEV;
> > > > +       }
> > > > +
> > > > +       bus =3D devm_kzalloc(&func->dev, sizeof(*bus), GFP_KERNEL);
> > > > +       if (!bus)
> > > > +               return -ENOMEM;
> > > > +
> > > > +       if (!np || !of_match_node(wfx_sdio_of_match, np)) {
> > > > +               dev_warn(&func->dev, "no compatible device found in=
 DT\n");
> > > > +               return -ENODEV;
> > > > +       }
> > > > +
> > > > +       bus->func =3D func;
> > > > +       bus->of_irq =3D irq_of_parse_and_map(np, 0);
> > > > +       sdio_set_drvdata(func, bus);
> > > > +       func->card->quirks |=3D MMC_QUIRK_LENIENT_FN0 |
> > > > +                             MMC_QUIRK_BLKSZ_FOR_BYTE_MODE |
> > > > +                             MMC_QUIRK_BROKEN_BYTE_MODE_512;
> > >
> > > I would rather see that you add an SDIO_FIXUP for the SDIO card, to
> > > the sdio_fixup_methods[], in drivers/mmc/core/quirks.h, instead of
> > > this.
> >
> > In the current patch, these quirks are applied only if the device appea=
rs
> > in the device tree (see the condition above). If I implement them in
> > drivers/mmc/core/quirks.h they will be applied as soon as the device is
> > detected. Is it what we want?
> >
> > Note: we already have had a discussion about the strange VID/PID declar=
ed
> > by this device:
> >   https://www.spinics.net/lists/netdev/msg692577.html
>
> Yes, vendor id 0x0000 is invalid per SDIO spec. So based on this vendor
> id, it is not possible to write any quirk in mmc/sdio generic code.
>
> Ulf, but maybe it could be possible to write quirk based on OF
> compatible string?

Yes, that would be better in my opinion.

We already have DT bindings to describe embedded SDIO cards (a subnode
to the mmc controller node), so we should be able to extend that I
think.

The main reason why I think it's a good idea, is that we may need to
know (future wise) about quirks from the mmc core point of view,
before the SDIO func driver gets probed.

[...]

Kind regards
Uffe
