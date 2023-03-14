Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC2C6B9F6D
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 20:15:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbjCNTPE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 15:15:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbjCNTO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 15:14:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B325832507;
        Tue, 14 Mar 2023 12:14:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70AB1B81B61;
        Tue, 14 Mar 2023 19:14:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EBDEC433AF;
        Tue, 14 Mar 2023 19:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678821290;
        bh=/o++2orgkh0eYVR24mG2HNDYYvTQagQPn7YxqtJRIGM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=HOI98Pw9VCCF8s+F6gT0/O1R6qRkVaDVxGLQ8shxkdNBfBdydmcUvFW6EQfLc7YM0
         vmBilZVquc485LrVfceEBDtZ5LybBi3iYyZJu5Atg66iC/jClxnCI2aezJYdFFoATb
         zNO4ffMMmIujIN8SSLwFySmlQoHxUQvvxe7gYff9gAP/mw3Qg4H2W8KnmPzBqFmV95
         G4EAy1yl9InhDz5pDcACZQnS0w4q+XWfFxqzwmWoan2fay6DQ7ZJw+WU+KfGEmfVb6
         j4wRetXsbLov1/7Zp70w8um2hZFbKP7zYGebUQ5xbc0+mXL+JgIwQSiCO2mSEkyh8Z
         nDFNqyakCiYkA==
Received: by mail-vs1-f53.google.com with SMTP id u16so4371382vso.1;
        Tue, 14 Mar 2023 12:14:50 -0700 (PDT)
X-Gm-Message-State: AO0yUKWggbywteOCS6gqLO+ZDMp7c0tX5VpUQDA+Uqz52UJXCnuSAd3B
        dhLZSjd8nKVUoNjSsTW63a/4z0DqStM8R+tjZA==
X-Google-Smtp-Source: AK7set+w7Dteu6Gz2fQIttAdFvbMZqpID4AHKHx68t3xQwsHx6BtKsv/C7yfYxJySG1yjFVS7BCS5PCUX/PHC6Xr3l0=
X-Received: by 2002:a67:b142:0:b0:41b:dc0c:a668 with SMTP id
 z2-20020a67b142000000b0041bdc0ca668mr25692104vsl.7.1678821289005; Tue, 14 Mar
 2023 12:14:49 -0700 (PDT)
MIME-Version: 1.0
References: <20230310144718.1544169-1-robh@kernel.org> <ZAxrBtNdou28yPPB@corigine.com>
In-Reply-To: <ZAxrBtNdou28yPPB@corigine.com>
From:   Rob Herring <robh@kernel.org>
Date:   Tue, 14 Mar 2023 14:14:37 -0500
X-Gmail-Original-Message-ID: <CAL_JsqJTsgmdwZZTfcMRnqaUfCNbgjO2mshxtAQK-qwoFqwCyw@mail.gmail.com>
Message-ID: <CAL_JsqJTsgmdwZZTfcMRnqaUfCNbgjO2mshxtAQK-qwoFqwCyw@mail.gmail.com>
Subject: Re: [PATCH] net: Use of_property_read_bool() for boolean properties
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Wei Fang <wei.fang@nxp.com>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Francois Romieu <romieu@fr.zoreil.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Zhao Qiang <qiang.zhao@nxp.com>, Kalle Valo <kvalo@kernel.org>,
        Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        devicetree@vger.kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 11, 2023 at 5:50=E2=80=AFAM Simon Horman <simon.horman@corigine=
.com> wrote:
>
> On Fri, Mar 10, 2023 at 08:47:16AM -0600, Rob Herring wrote:
> > It is preferred to use typed property access functions (i.e.
> > of_property_read_<type> functions) rather than low-level
> > of_get_property/of_find_property functions for reading properties.
> > Convert reading boolean properties to to of_property_read_bool().
> >
> > Signed-off-by: Rob Herring <robh@kernel.org>
>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
>
> ...
>
> > diff --git a/drivers/net/ethernet/via/via-velocity.c b/drivers/net/ethe=
rnet/via/via-velocity.c
> > index a502812ac418..86f7843b4591 100644
> > --- a/drivers/net/ethernet/via/via-velocity.c
> > +++ b/drivers/net/ethernet/via/via-velocity.c
> > @@ -2709,8 +2709,7 @@ static int velocity_get_platform_info(struct velo=
city_info *vptr)
> >       struct resource res;
> >       int ret;
> >
> > -     if (of_get_property(vptr->dev->of_node, "no-eeprom", NULL))
> > -             vptr->no_eeprom =3D 1;
> > +     vptr->no_eeprom =3D of_property_read_bool(vptr->dev->of_node, "no=
-eeprom");
>
> As per my comment on "[PATCH] nfc: mrvl: Use of_property_read_bool() for
> boolean properties".
>
> I'm not that enthusiastic about assigning a bool value to a field
> with an integer type. But that is likely a topic for another patch.
>
> >       ret =3D of_address_to_resource(vptr->dev->of_node, 0, &res);
> >       if (ret) {
>
> ...
>
> > diff --git a/drivers/net/wan/fsl_ucc_hdlc.c b/drivers/net/wan/fsl_ucc_h=
dlc.c
> > index 1c53b5546927..47c2ad7a3e42 100644
> > --- a/drivers/net/wan/fsl_ucc_hdlc.c
> > +++ b/drivers/net/wan/fsl_ucc_hdlc.c
> > @@ -1177,14 +1177,9 @@ static int ucc_hdlc_probe(struct platform_device=
 *pdev)
> >       uhdlc_priv->dev =3D &pdev->dev;
> >       uhdlc_priv->ut_info =3D ut_info;
> >
> > -     if (of_get_property(np, "fsl,tdm-interface", NULL))
> > -             uhdlc_priv->tsa =3D 1;
> > -
> > -     if (of_get_property(np, "fsl,ucc-internal-loopback", NULL))
> > -             uhdlc_priv->loopback =3D 1;
> > -
> > -     if (of_get_property(np, "fsl,hdlc-bus", NULL))
> > -             uhdlc_priv->hdlc_bus =3D 1;
> > +     uhdlc_priv->tsa =3D of_property_read_bool(np, "fsl,tdm-interface"=
);
>
> Here too.

These are already bool. Turns out the only one that needs changing is
no_eeprom. netdev folks marked this as changes requested, so I'll add
that in v2.

Rob
