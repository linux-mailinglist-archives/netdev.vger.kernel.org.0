Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94ABD46A016
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 16:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387075AbhLFP5q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 10:57:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352249AbhLFPyi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 10:54:38 -0500
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADCD2C07E5E2
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 07:40:07 -0800 (PST)
Received: by mail-qv1-xf2b.google.com with SMTP id s9so10163827qvk.12
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 07:40:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=springboard-inc-jp.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=NFjyQ4SZKk8gDilxHySNmh3aQDebTcdpDkr1aDOQht4=;
        b=hJXYogDv7valZcomLCDtZWzRIEtM9IX0bORL27f3hfcw0zMKAqJGY5vHbcnN4OWvmm
         fVu6Dg1ctssuPTCXHHbEbS22QrMVg5Xu3PhxIJIPsrqqVd8hmkXk67Uyj1aat90cid+W
         4CfpTmLghX8NfCKOYmdo8jR0U1oJS4MONvygp9YF3IyH6jmKSgaLtRi7Bp/q4KCn8gGv
         BpN9kjNkVwdeor2I8Kfi/lkdkZhc7VYoTsOwPqn4A8cayCG6obnRoAvQarO6YYjTQmUJ
         6wmo5j5DYcN648vE+acZjHNrKkfGvdFJTsWFNvNCoVICHeDK4n4g0Sz7EsWKCvwg8ry5
         w8Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NFjyQ4SZKk8gDilxHySNmh3aQDebTcdpDkr1aDOQht4=;
        b=FfNEHu8ywTNG/MyErVwPoK8uashOBfiShrOU13CR0iKfwWlcDDFLWMWXS9FcXjxBzN
         /dWKGx6zZzk44KkmOHe3Te29SXw5ve9Ax72TIjGvAQjXwFeq/lyhAnCCeLEG0ULjXb1Q
         bWb3NnetZbN88ixeAGDRpKs5N6RQcXkgKGeg3duoU3fE7JAla6icB+8oTl3UNjZpfZxD
         JF49Y6oZ2nnypNrQ3tFK/A4pAUQoMs8+WriuKPtCPwVIvtC/eEwztyHps2D2vYTe3yG+
         oeRoOyJasZLCTe0xuktBJmzCaTR/noTOYe+fjlCVd2tRO9R0SHEkpglMTg5bGahRJ1yJ
         /PdA==
X-Gm-Message-State: AOAM533RGfdgxm2EwnQuOaLM49hf3SOIlzbLXF01jatlHLhHUKIGBLQe
        rTENOmzaeLvc1L7UYabMDOTOXsGZuHGR9mhisB6U
X-Google-Smtp-Source: ABdhPJwwZdBKxFks/ez3akzC0t3lOT1UXSkhmF7jcB2IaAbuP5KUZzHu2qlMUV32KKRAohzwGLcBxLBs9L5DPUK1MxY=
X-Received: by 2002:a05:6214:906:: with SMTP id dj6mr37551496qvb.11.1638805206779;
 Mon, 06 Dec 2021 07:40:06 -0800 (PST)
MIME-Version: 1.0
References: <20211130073929.376942-1-bjorn@mork.no> <20211202175843.0210476e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YaoFkZ53m7cILdYu@shell.armlinux.org.uk> <YaoUW9KHyEQOt46b@shell.armlinux.org.uk>
 <877dclkd2y.fsf@miraculix.mork.no> <YathNbNBob2kHxrH@shell.armlinux.org.uk> <877dcif2c0.fsf@miraculix.mork.no>
In-Reply-To: <877dcif2c0.fsf@miraculix.mork.no>
From:   =?UTF-8?B?54Wn5bGx5ZGo5LiA6YOO?= <teruyama@springboard-inc.jp>
Date:   Tue, 7 Dec 2021 00:39:57 +0900
Message-ID: <CAOZT0pVXzLWSBf_sKcZaDEbbnnm=FcZH0DCLZbKW7VXo013E_A@mail.gmail.com>
Subject: Re: [PATCH net,stable] phy: sfp: fix high power modules without diag mode
To:     =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        "Russell King (Oracle)" <linux@armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello, Mork!

Sorry for the late reply.
Thanks to you and Russell for your great contribution.

I will test Russell's patch in a few days.
Please wait a while.

2021=E5=B9=B412=E6=9C=886=E6=97=A5(=E6=9C=88) 19:35 Bj=C3=B8rn Mork <bjorn@=
mork.no>:

>
> "Russell King (Oracle)" <linux@armlinux.org.uk> writes:
> > On Fri, Dec 03, 2021 at 02:55:17PM +0100, Bj=C3=B8rn Mork wrote:
> >> "Russell King (Oracle)" <linux@armlinux.org.uk> writes:
> >>
> >> > Thinking a little more, how about this:
> >> >
> >> >  drivers/net/phy/sfp.c | 25 +++++++++++++++++++++----
> >> >  1 file changed, 21 insertions(+), 4 deletions(-)
> >> >
> >> > diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
> >> > index 51a1da50c608..4c900d063b19 100644
> >> > --- a/drivers/net/phy/sfp.c
> >> > +++ b/drivers/net/phy/sfp.c
> >> > @@ -1752,17 +1752,20 @@ static int sfp_sm_probe_for_phy(struct sfp *=
sfp)
> >> >  static int sfp_module_parse_power(struct sfp *sfp)
> >> >  {
> >> >    u32 power_mW =3D 1000;
> >> > +  bool supports_a2;
> >> >
> >> >    if (sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_POWER_DECL))
> >> >            power_mW =3D 1500;
> >> >    if (sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_HIGH_POWER_LEVE=
L))
> >> >            power_mW =3D 2000;
> >> >
> >> > +  supports_a2 =3D sfp->id.ext.sff8472_compliance !=3D
> >> > +                          SFP_SFF8472_COMPLIANCE_NONE ||
> >> > +                sfp->id.ext.diagmon & SFP_DIAGMON_DDM;
> >> > +
> >> >    if (power_mW > sfp->max_power_mW) {
> >> >            /* Module power specification exceeds the allowed maximum=
. */
> >> > -          if (sfp->id.ext.sff8472_compliance =3D=3D
> >> > -                  SFP_SFF8472_COMPLIANCE_NONE &&
> >> > -              !(sfp->id.ext.diagmon & SFP_DIAGMON_DDM)) {
> >> > +          if (!supports_a2) {
> >> >                    /* The module appears not to implement bus addres=
s
> >> >                     * 0xa2, so assume that the module powers up in t=
he
> >> >                     * indicated mode.
> >> > @@ -1779,11 +1782,24 @@ static int sfp_module_parse_power(struct sfp=
 *sfp)
> >> >            }
> >> >    }
> >> >
> >> > +  if (power_mW <=3D 1000) {
> >> > +          /* Modules below 1W do not require a power change sequenc=
e */
> >> > +          return 0;
> >> > +  }
> >> > +
> >> > +  if (!supports_a2) {
> >> > +          /* The module power level is below the host maximum and t=
he
> >> > +           * module appears not to implement bus address 0xa2, so a=
ssume
> >> > +           * that the module powers up in the indicated mode.
> >> > +           */
> >> > +          return 0;
> >> > +  }
> >> > +
> >> >    /* If the module requires a higher power mode, but also requires
> >> >     * an address change sequence, warn the user that the module may
> >> >     * not be functional.
> >> >     */
> >> > -  if (sfp->id.ext.diagmon & SFP_DIAGMON_ADDRMODE && power_mW > 1000=
) {
> >> > +  if (sfp->id.ext.diagmon & SFP_DIAGMON_ADDRMODE) {
> >> >            dev_warn(sfp->dev,
> >> >                     "Address Change Sequence not supported but modul=
e requires %u.%uW, module may not be functional\n",
> >> >                     power_mW / 1000, (power_mW / 100) % 10);
> >>
> >> Looks nice to me at least.  But I don't have the hardware to test it.
> >
> > I don't have the hardware either, so I can't test it - but it does need
> > testing. I assume as you've reported it and sent a patch, you know
> > someone who has run into this issue? It would be great if you could ask
> > them to test it and let us know if it solves the problem.
>
> Hello Teruyama!
>
> Any chance you can test this proposed fix from Russel?  I believe it
> should fix the issue with your NTT OCU SFP as well.
>
>
> Bj=C3=B8rn



--
=E6=A0=AA=E5=BC=8F=E4=BC=9A=E7=A4=BE=E3=82=B9=E3=83=97=E3=83=AA=E3=83=B3=E3=
=82=B0=E3=83=9C=E3=83=BC=E3=83=89
=E7=85=A7=E5=B1=B1=E3=80=80=E5=91=A8=E4=B8=80=E9=83=8E
teruyama@springboard-inc.jp
http://www.springboard-inc.jp/
=E3=80=92110-0005
=E6=9D=B1=E4=BA=AC=E9=83=BD=E5=8F=B0=E6=9D=B1=E5=8C=BA=E4=B8=8A=E9=87=8E3=
=E4=B8=81=E7=9B=AE2=E7=95=AA2=E5=8F=B7
=E3=82=A2=E3=82=A4=E3=82=AA=E3=82=B9=E7=A7=8B=E8=91=89=E5=8E=9F505=E5=8F=B7=
=E5=AE=A4
