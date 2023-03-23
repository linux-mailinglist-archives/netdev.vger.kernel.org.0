Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE616C72CC
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 23:12:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231162AbjCWWMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 18:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbjCWWMQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 18:12:16 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DFD9231FB;
        Thu, 23 Mar 2023 15:12:15 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id y5so135253ybu.3;
        Thu, 23 Mar 2023 15:12:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679609534;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4Fdp+ighw/1wg0cIoSJhwoYdek5fqfASCf/bj+B2gh0=;
        b=fdUl2bFkdwwTPS9bdH+qMqYr30cln3V+bctT7mAl7m2aRSq71X/kk43rMfUfQeIh7h
         QtteficrXd13gUhENtJ4W6CIntT3CFz/EgtjJ5dCRP/arL52za4n2hezjqqHbtldCBRJ
         LDi+3fqTZTufjCTb00/rb+h3ZKGt+ZopU18bIhR12c1O8En3W2EIvb084IgGBB8aKbjO
         GdkR7nocuRBuRFjIO+NbWbngCLUjdItdBR25HwtmiQGgMRE7KETWsvTU//V/FVsX9Ksp
         +9yJYsBCY5jf0qAveO7xhruU0M1Di3HvgXnUBQ7V/xhxQya4sLPZZk/K5IK8ZWm93hsj
         Ziqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679609534;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4Fdp+ighw/1wg0cIoSJhwoYdek5fqfASCf/bj+B2gh0=;
        b=BEEx4u/zu25NpM9AjyQageXnvRH/TIq4T3jnNWnrN/QCamp7b+5cfKXhuEOxSPMba2
         9JaBytb/DR4j5TUrKG8vTZp+Eqzf7Sf3YChtN5efG5t3ZonPGpeccAckdSZKVFMCm6Ba
         IVSDpQGrNesTpULk/kPkxdcRJ5pEyN6375mMplA9jgjtIPaMzqiizeEDMyNQDrTqhDai
         cZCakLhAnsGVIjAE54RnaLbA5IDhtW8T7Vt/2bhhBF7PWb7Ae2Yr+cXUTmmXiK5Lr9Zz
         u7tul+Gv1qpxC9wocasq1r5ytQaMWs3ID0++3TQBczUiAP6PJe+02XxcTMhVluVEJvIs
         D4Pw==
X-Gm-Message-State: AAQBX9cuEavSqldA0i/P0vrYAsunN2eFMo0P3n+q/qFM5xtyObyaBSr5
        MTqTNOYD/A0znZdMo1Oxw/uho9qSITrchouGB4w=
X-Google-Smtp-Source: AKy350atNl6gt1/g58lpm2WdHRcRezCukGclqZZteRuX1vj2pRLqmtwoD6/OAZBq8rMZv/1Z7l5oBqfaW0oDoejzTtQ=
X-Received: by 2002:a25:e054:0:b0:b6b:d3f3:45af with SMTP id
 x81-20020a25e054000000b00b6bd3f345afmr2260928ybg.1.1679609534158; Thu, 23 Mar
 2023 15:12:14 -0700 (PDT)
MIME-Version: 1.0
References: <20230323121804.2249605-1-noltari@gmail.com> <20230323121804.2249605-3-noltari@gmail.com>
 <ee867960-91bb-659b-a87b-6c04613608c5@gmail.com> <AM0PR02MB55242C94846EE5598CDA44A2BD879@AM0PR02MB5524.eurprd02.prod.outlook.com>
In-Reply-To: <AM0PR02MB55242C94846EE5598CDA44A2BD879@AM0PR02MB5524.eurprd02.prod.outlook.com>
From:   =?UTF-8?B?w4FsdmFybyBGZXJuw6FuZGV6IFJvamFz?= <noltari@gmail.com>
Date:   Thu, 23 Mar 2023 23:12:03 +0100
Message-ID: <CAKR-sGfjV6=7UHJguv-E6WKcSPEO8igdG97ieMQrqK3Sr09pFA@mail.gmail.com>
Subject: Re: [PATCH 2/2] net: dsa: b53: mdio: add support for BCM53134
To:     Paul Geurts <paul.geurts@prodrive-technologies.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "jonas.gorski@gmail.com" <jonas.gorski@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

El jue, 23 mar 2023 a las 21:10, Paul Geurts
(<paul.geurts@prodrive-technologies.com>) escribi=C3=B3:
>
> > -----Original Message-----
> > From: Florian Fainelli <f.fainelli@gmail.com>
> > Sent: donderdag 23 maart 2023 17:43
> > To: =C3=81lvaro Fern=C3=A1ndez Rojas <noltari@gmail.com>; Paul Geurts
> > <paul.geurts@prodrive-technologies.com>; jonas.gorski@gmail.com;
> > andrew@lunn.ch; olteanv@gmail.com; davem@davemloft.net;
> > edumazet@google.com; kuba@kernel.org; pabeni@redhat.com;
> > robh+dt@kernel.org; krzysztof.kozlowski+dt@linaro.org;
> > netdev@vger.kernel.org; devicetree@vger.kernel.org; linux-
> > kernel@vger.kernel.org
> > Subject: Re: [PATCH 2/2] net: dsa: b53: mdio: add support for BCM53134
> >
> > On 3/23/23 05:18, =C3=81lvaro Fern=C3=A1ndez Rojas wrote:
> > > From: Paul Geurts <paul.geurts@prodrive-technologies.com>
> > >
> > > Add support for the BCM53134 Ethernet switch in the existing b53 dsa
> > driver.
> > > BCM53134 is very similar to the BCM58XX series.
> > >
> > > Signed-off-by: Paul Geurts <paul.geurts@prodrive-technologies.com>
> > > Signed-off-by: =C3=81lvaro Fern=C3=A1ndez Rojas <noltari@gmail.com>
> > > ---
> > >   drivers/net/dsa/b53/b53_common.c | 53
> > +++++++++++++++++++++++++++++++-
> > >   drivers/net/dsa/b53/b53_mdio.c   |  5 ++-
> > >   drivers/net/dsa/b53/b53_priv.h   |  9 +++++-
> > >   3 files changed, 64 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/drivers/net/dsa/b53/b53_common.c
> > > b/drivers/net/dsa/b53/b53_common.c
> > > index 1f9b251a5452..aaa0813e6f59 100644
> > > --- a/drivers/net/dsa/b53/b53_common.c
> > > +++ b/drivers/net/dsa/b53/b53_common.c
> > > @@ -1282,6 +1282,42 @@ static void b53_adjust_link(struct dsa_switch
> > *ds, int port,
> > >     if (is63xx(dev) && port >=3D B53_63XX_RGMII0)
> > >             b53_adjust_63xx_rgmii(ds, port, phydev->interface);
> > >
> > > +   if (is53134(dev) && phy_interface_is_rgmii(phydev)) {
> >
> > Why is not this in the same code block as the one for the is531x5() dev=
ice like
> > this:
> >
> > diff --git a/drivers/net/dsa/b53/b53_common.c
> > b/drivers/net/dsa/b53/b53_common.c
> > index 59cdfc51ce06..1c64b6ce7e78 100644
> > --- a/drivers/net/dsa/b53/b53_common.c
> > +++ b/drivers/net/dsa/b53/b53_common.c
> > @@ -1235,7 +1235,7 @@ static void b53_adjust_link(struct dsa_switch *ds=
,
> > int port,
> >                                tx_pause, rx_pause);
> >          b53_force_link(dev, port, phydev->link);
> >
> > -       if (is531x5(dev) && phy_interface_is_rgmii(phydev)) {
> > +       if ((is531x5(dev) || is53134(dev)) &&
> > phy_interface_is_rgmii(phydev)) {
> >                  if (port =3D=3D dev->imp_port)
> >                          off =3D B53_RGMII_CTRL_IMP;
> >                  else
> >
> > Other than that, LGTM!
> > --
> > Florian
>
> I think the only reason is that the BCM53134 does not support the
> RGMII_CTRL_TIMING_SEL bit, which is set in the original block. I agree
> Putting a if statement around
> rgmii_ctrl |=3D RGMII_CTRL_TIMING_SEL;
> would prevent a lot of code duplication. _however_, after looking at it a=
gain,
> I don=E2=80=99t think the device does not support the bit. When looking a=
t the datasheet,
> The same bit in the this register is called BYPASS_2NS_DEL. It's very unc=
ommon
> For Broadcom to make such a change in the register interface, so maybe th=
ey
> Just renamed it. Do you think this could be the same bit?

What happens if you add that bit on your device? It doesn't work?
I will try with my device and see what happens when I add it...

>
> ---
> Paul

--
=C3=81lvaro
