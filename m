Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC84A6EC699
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 08:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbjDXG4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 02:56:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbjDXG4S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 02:56:18 -0400
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECBBE186
        for <netdev@vger.kernel.org>; Sun, 23 Apr 2023 23:56:15 -0700 (PDT)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-54f945a7bddso47874067b3.0
        for <netdev@vger.kernel.org>; Sun, 23 Apr 2023 23:56:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google; t=1682319375; x=1684911375;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tXWOXpU07qWWq5ZBAlNtZKd+azLb+6DwvPUwR9Hj/T8=;
        b=MYLBm7TYkepV1BobssBHTnsTuOiV5n6qTone3phkpXE/ziPd10/WAMQr+BzInWuP1F
         oP72ie9zCW7APaiHvuA+CI+OaH+cOQbeA4QLlC9fX9RoX9dQcEH6pxeQDsuWms6EkiFe
         rzgs3t7Et0ZbOxclIpoNSxDrfgm06i6Dx4lyM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682319375; x=1684911375;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tXWOXpU07qWWq5ZBAlNtZKd+azLb+6DwvPUwR9Hj/T8=;
        b=eXzkaiQzhp1O0rRLL6XOqK4SQ7yDWpS3SRYrv7XZt7cgYSgnWUV3ewmvwqbNGzOIFV
         /H8TzI1dMJ8tjtp6AOrSkh7ydFGW9yiZDV+OmBFnBNvd5FVpVFO+p5VdgNONYAlp2Yr6
         DgKvqV4vfdGWnTrs2kVVVcPji5pHoofQ7QYxvcl4ltgS15IEAfqmsjBMGwj/A8A/OCq0
         PK4XW54obXztY2obfZ69bpJDTLW2BPwLUmorX4A+gmcxQdiMVwrQA7lmcZ+PTpDIIaj4
         UsQ1sk3M+0QGj67PnVc3zathkIL+d9I2+h+e6rIGDFKAAiUxb+fpzB2k0DomdKP27mvN
         KeWg==
X-Gm-Message-State: AAQBX9e0ncx/ZC3cUPfXRpTiUAwgtMGRNFTooObO/PIopNSWqnSSE5Ee
        8O5QhkpeAsiUBTGYOuCo3NpefsCAAiOTP2qoGHW+0q0euUq+ZqMBq2juqA==
X-Google-Smtp-Source: AKy350beb2BRmegGcoc2HSTePZ6TOnKDldVJICyGg/zu0vYmcvvNRdxFA2DXLR71tMTRtd3TCdvkVMxffMkrEsKc91k=
X-Received: by 2002:a0d:db82:0:b0:555:cce2:8a16 with SMTP id
 d124-20020a0ddb82000000b00555cce28a16mr6447641ywe.22.1682319374876; Sun, 23
 Apr 2023 23:56:14 -0700 (PDT)
MIME-Version: 1.0
References: <20230423172528.1398158-1-dario.binacchi@amarulasolutions.com>
 <20230423172528.1398158-5-dario.binacchi@amarulasolutions.com> <20230423-surplus-spoon-4e8194434663-mkl@pengutronix.de>
In-Reply-To: <20230423-surplus-spoon-4e8194434663-mkl@pengutronix.de>
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
Date:   Mon, 24 Apr 2023 08:56:03 +0200
Message-ID: <CABGWkvqA2hwgfGvVWS08Qu-2ZUbwc82ynhvq8-FqFuhHoV-vhw@mail.gmail.com>
Subject: Re: [PATCH 4/4] can: bxcan: add support for single peripheral configuration
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-kernel@vger.kernel.org,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        michael@amarulasolutions.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

On Sun, Apr 23, 2023 at 9:16=E2=80=AFPM Marc Kleine-Budde <mkl@pengutronix.=
de> wrote:
>
> On 23.04.2023 19:25:28, Dario Binacchi wrote:
> > Add support for bxCAN controller in single peripheral configuration:
> > - primary bxCAN
> > - dedicated Memory Access Controller unit
> > - 512-byte SRAM memory
> > - 14 fiter banks
> >
> > Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
> >
> > ---
> >
> >  drivers/net/can/bxcan.c | 20 +++++++++++++++++---
> >  1 file changed, 17 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/net/can/bxcan.c b/drivers/net/can/bxcan.c
> > index e26ccd41e3cb..9bcbbb85da6e 100644
> > --- a/drivers/net/can/bxcan.c
> > +++ b/drivers/net/can/bxcan.c
> > @@ -155,6 +155,7 @@ struct bxcan_regs {
> >       u32 reserved0[88];              /* 0x20 */
> >       struct bxcan_mb tx_mb[BXCAN_TX_MB_NUM]; /* 0x180 - tx mailbox */
> >       struct bxcan_mb rx_mb[BXCAN_RX_MB_NUM]; /* 0x1b0 - rx mailbox */
> > +     u32 reserved1[12];              /* 0x1d0 */
> >  };
> >
> >  struct bxcan_priv {
> > @@ -922,6 +923,12 @@ static int bxcan_get_berr_counter(const struct net=
_device *ndev,
> >       return 0;
> >  }
> >
> > +static const struct regmap_config bxcan_gcan_regmap_config =3D {
> > +     .reg_bits =3D 32,
> > +     .val_bits =3D 32,
> > +     .reg_stride =3D 4,
> > +};
> > +
> >  static int bxcan_probe(struct platform_device *pdev)
> >  {
> >       struct device_node *np =3D pdev->dev.of_node;
> > @@ -942,11 +949,18 @@ static int bxcan_probe(struct platform_device *pd=
ev)
> >
> >       gcan =3D syscon_regmap_lookup_by_phandle(np, "st,gcan");
> >       if (IS_ERR(gcan)) {
> > -             dev_err(dev, "failed to get shared memory base address\n"=
);
> > -             return PTR_ERR(gcan);
> > +             primary =3D true;
> > +             gcan =3D devm_regmap_init_mmio(dev,
> > +                                          regs + sizeof(struct bxcan_r=
egs),
> > +                                          &bxcan_gcan_regmap_config);
> > +             if (IS_ERR(gcan)) {
> > +                     dev_err(dev, "failed to get filter base address\n=
");
> > +                     return PTR_ERR(gcan);
> > +             }
>
> This probably works. Can we do better, i.e. without this additional code?
>
> If you add a syscon node for the single instance CAN, too, you don't
> need a code change here, right?

I think so.

I have only one doubt about it. This implementation allows, implicitly, to
distinguish if the peripheral is in single configuration (without handle to=
 the
gcan node) or in double configuration (with handle to the gcan node).
For example, in single configuration the peripheral has 14 filter banks, wh=
ile
in double configuration there are 26 shared banks. Without code changes, th=
is
kind of information is lost. Is it better then, for future
developments, to add a new
boolean property to the can node of the dts (e.g. single-conf)?

Thanks and regards,

Dario

>
> > +     } else {
> > +             primary =3D of_property_read_bool(np, "st,can-primary");
> >       }
> >
> > -     primary =3D of_property_read_bool(np, "st,can-primary");
> >       clk =3D devm_clk_get(dev, NULL);
> >       if (IS_ERR(clk)) {
> >               dev_err(dev, "failed to get clock\n");
>
> Marc
>
> --
> Pengutronix e.K.                 | Marc Kleine-Budde          |
> Embedded Linux                   | https://www.pengutronix.de |
> Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129 |
> Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-9   |



--=20

Dario Binacchi

Senior Embedded Linux Developer

dario.binacchi@amarulasolutions.com

__________________________________


Amarula Solutions SRL

Via Le Canevare 30, 31100 Treviso, Veneto, IT

T. +39 042 243 5310
info@amarulasolutions.com

www.amarulasolutions.com
