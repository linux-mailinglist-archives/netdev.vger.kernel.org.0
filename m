Return-Path: <netdev+bounces-8420-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 11856723FB9
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 12:36:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 69CC91C20FC7
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 10:36:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 807E115AE8;
	Tue,  6 Jun 2023 10:35:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764E915AE5
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 10:35:40 +0000 (UTC)
Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com [209.85.219.180])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0B8CE6E;
	Tue,  6 Jun 2023 03:35:38 -0700 (PDT)
Received: by mail-yb1-f180.google.com with SMTP id 3f1490d57ef6-bb131cd7c4aso5146786276.1;
        Tue, 06 Jun 2023 03:35:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686047738; x=1688639738;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0ydybIENrvkznJ3jdND4RX/3pvLeHeCWFjJ95HKeLNA=;
        b=BSv6qxjKLbMUzSKvH1jL04mdmLCWhbrdmvtJ9bN0C6hmAewTsHa/utCVP4998cpBU8
         /UO7hyYoDDCRTRtB4Ev6+tuOWvGyHBVWEUkQkZtqeNlIBLZQkpXSJ0ManmiS5F3osabX
         ru1JrY/XgDJNiSonC7IkMNihXHSrHlfvnZPmTPHFHSGJI0zBZf2VkjCA7Mrvu9SbR6HL
         OYb6IMTjVexGLnUblgdisOfRnScySOaPoQF0/S9mRS6mOrvEaQIK5Gq022LnfxUo9lA1
         lHaUSNFOT4F8j7rqT9R9q7tiJEKYbH1mLYCaWN4yrrp+otvxxMMfhowAuX0voiNlBdkO
         nbdg==
X-Gm-Message-State: AC+VfDzl1fT8JL2MPqwSH/bEvcNwmxYmibhPk+XKL6ttsV2F0Tvfg71E
	nxMw+J2H+dhKZq+kiwrord123XAOFYP9sw==
X-Google-Smtp-Source: ACHHUZ405Y7oZAFnLkqbJ4UmsV7kUX/+L2SPwwZGcgmY5YPC/01X9dE3uCNbojvuiJSEeaCy9sXpAQ==
X-Received: by 2002:a25:fc3:0:b0:ba8:1c9e:c77f with SMTP id 186-20020a250fc3000000b00ba81c9ec77fmr1158966ybp.22.1686047737722;
        Tue, 06 Jun 2023 03:35:37 -0700 (PDT)
Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com. [209.85.219.176])
        by smtp.gmail.com with ESMTPSA id 124-20020a250182000000b00ba773472647sm3160223ybb.19.2023.06.06.03.35.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jun 2023 03:35:35 -0700 (PDT)
Received: by mail-yb1-f176.google.com with SMTP id 3f1490d57ef6-bb15165ba06so5139183276.2;
        Tue, 06 Jun 2023 03:35:35 -0700 (PDT)
X-Received: by 2002:a0d:f605:0:b0:561:b58e:31ff with SMTP id
 g5-20020a0df605000000b00561b58e31ffmr1669654ywf.44.1686047734832; Tue, 06 Jun
 2023 03:35:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230606064914.134945-1-maxime.chevallier@bootlin.com>
 <20230606064914.134945-2-maxime.chevallier@bootlin.com> <889297a0-88c3-90df-7752-efa00184859@linux-m68k.org>
 <ZH78uGBfeHjI4Cdn@shell.armlinux.org.uk> <20230606121311.3cc5aa78@pc-7.home> <ZH8JxF+TNuX0C1vC@shell.armlinux.org.uk>
In-Reply-To: <ZH8JxF+TNuX0C1vC@shell.armlinux.org.uk>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 6 Jun 2023 12:35:23 +0200
X-Gmail-Original-Message-ID: <CAMuHMdWnqmwT_rEe5G4e+yZYAeTQxjjE=Xqq7R6No9SAF16sdg@mail.gmail.com>
Message-ID: <CAMuHMdWnqmwT_rEe5G4e+yZYAeTQxjjE=Xqq7R6No9SAF16sdg@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] net: stmmac: Add PCS_LYNX as a dependency
 for the whole driver
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Maxime Chevallier <maxime.chevallier@bootlin.com>, davem@davemloft.net, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	alexis.lothore@bootlin.com, thomas.petazzoni@bootlin.com, 
	Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>, Eric Dumazet <edumazet@google.com>, 
	Paolo Abeni <pabeni@redhat.com>, Florian Fainelli <f.fainelli@gmail.com>, 
	Heiner Kallweit <hkallweit1@gmail.com>, Vladimir Oltean <vladimir.oltean@nxp.com>, 
	Ioana Ciornei <ioana.ciornei@nxp.com>, linux-stm32@st-md-mailman.stormreply.com, 
	linux-arm-kernel@lists.infradead.org, 
	Maxime Coquelin <mcoquelin.stm32@gmail.com>, Jose Abreu <joabreu@synopsys.com>, 
	Alexandre Torgue <alexandre.torgue@foss.st.com>, Giuseppe Cavallaro <peppe.cavallaro@st.com>, 
	Simon Horman <simon.horman@corigine.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Russell,

On Tue, Jun 6, 2023 at 12:26=E2=80=AFPM Russell King (Oracle)
<linux@armlinux.org.uk> wrote:
> On Tue, Jun 06, 2023 at 12:13:11PM +0200, Maxime Chevallier wrote:
> > On Tue, 6 Jun 2023 10:30:32 +0100
> > "Russell King (Oracle)" <linux@armlinux.org.uk> wrote:
> > > On Tue, Jun 06, 2023 at 10:29:20AM +0200, Geert Uytterhoeven wrote:
> > > > On Tue, 6 Jun 2023, Maxime Chevallier wrote:
> > > > > Although pcs_lynx is only used on dwmac_socfpga for now, the clea=
nup
> > > > > path is in the generic driver, and triggers build issues for othe=
r
> > > > > stmmac variants. Make sure we build pcs_lynx in all cases too, as=
 for
> > > > > XPCS.
> > > >
> > > > That seems suboptimal to me, as it needlesly increases kernel size =
for
> > > > people who do not use dwmac_socfpga.  Hence I made an alternative p=
atch:
> > > > https://lore.kernel/org/7b36ac43778b41831debd5c30b5b37d268512195.16=
86039915.git.geert+renesas@glider.be
> > >
> > > A better solution would be to re-architect the removal code so that
> > > whatever creates the PCS is also responsible for removing it.
> > >
> > > Also, dwmac_socfpga nees to be reorganised anyway, because it calls
> > > stmmac_dvr_probe() which then goes on to call register_netdev(),
> > > publishing the network device, and then after stmmac_dvr_probe(),
> > > further device setup is done. As the basic driver probe flow should
> > > be setup and then publish, the existing code structure violates that.
> > >
> >
> > I agree that this solution is definitely suboptimal, I wanted mostly to=
 get it
> > fixed quickly as this breaks other stmmac variants.
> >
> > Do we still go on with the current patch (as Geert's has issues) and th=
en
> > consider reworking dwmac_socfpga ?
>
> As Geert himself mentioned, passed on from Arnd:
>   As pointed out by Arnd, this doesn't work when PCS_LYNX is a loadable
>   module and STMMAC is built-in:
>   https://lore.kernel.org/r/11bd37e9-c62e-46ba-9456-8e3b353df28f@app.fast=
mail.com
>
> So Geert's solution will just get rid of the build error, but leave the
> Lynx PCS undestroyed. I take Geert's comment as a self-nack on his
> proposed patch.

Exactly...

> The changes are only in net-next at the moment, and we're at -rc5.
> There's probably about 2.5 weeks to get this sorted before the merge
> window opens.
>
> So, we currently have your suggestion. Here's mine as an immediate
> fix. This doesn't address all the points I've raised, but should
> resolve the immediate issue.
>
> Untested since I don't have the hardware... (the test build is
> running):
>
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c b/driver=
s/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
> index e399fccbafe5..239c7e9ed41d 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
> @@ -494,6 +494,17 @@ static int socfpga_dwmac_probe(struct platform_devic=
e *pdev)
>         return ret;
>  }
>
> +static void socfpga_dwmac_remove(struct platform_device *pdev)
> +{
> +       struct net_device *ndev =3D platform_get_drvdata(pdev);
> +       struct stmmac_priv *priv =3D netdev_priv(ndev);
> +       struct phylink_pcs *pcs =3D priv->hw->lynx_pcs;
> +
> +       stmmac_pltfr_remove(pdev);
> +
> +       lynx_pcs_destroy(pcs);
> +}
> +
>  #ifdef CONFIG_PM_SLEEP
>  static int socfpga_dwmac_resume(struct device *dev)
>  {
> @@ -565,7 +576,7 @@ MODULE_DEVICE_TABLE(of, socfpga_dwmac_match);
>
>  static struct platform_driver socfpga_dwmac_driver =3D {
>         .probe  =3D socfpga_dwmac_probe,
> -       .remove_new =3D stmmac_pltfr_remove,
> +       .remove_new =3D socfpga_dwmac_remove,
>         .driver =3D {
>                 .name           =3D "socfpga-dwmac",
>                 .pm             =3D &socfpga_dwmac_pm_ops,
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/=
net/ethernet/stmicro/stmmac/stmmac_main.c
> index fa07b0d50b46..1801f8cc8413 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -940,9 +940,6 @@ static struct phylink_pcs *stmmac_mac_select_pcs(stru=
ct phylink_config *config,
>         if (priv->hw->xpcs)
>                 return &priv->hw->xpcs->pcs;
>
> -       if (priv->hw->lynx_pcs)
> -               return priv->hw->lynx_pcs;
> -
>         return NULL;
>  }

I think the above hunk is wrong, and should be replaced by a removal
of the call to lynx_pcs_destroy()?

Gr{oetje,eeting}s,

                        Geert

--=20
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds

