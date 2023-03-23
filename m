Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09A946C72D4
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 23:13:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbjCWWNm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 18:13:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbjCWWNk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 18:13:40 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3020DB2;
        Thu, 23 Mar 2023 15:13:38 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id b18so149476ybp.1;
        Thu, 23 Mar 2023 15:13:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679609617;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MNLrgArOYbeC4SneqmgBNc1s6gwTuQ/uP6VwFa/0H38=;
        b=gaSXIjvrGd4p1I+90z0qIe/ppdfjcoNWoqpiyzUQtje0tIz8lu5Vh0wdIUivcp3y09
         sVV8NNSxdKvmY3JeRQCkmMQfNYg9j8R43aHQoIUR5egBlBIgaPkkcVTPSGoxSsnrenRg
         tM9HWWQH2tg7+eRLewopJDwK8/Ea2diROibsU0RzQnHLgqgtzhlM99AYxVipZXgHmBt+
         8teCy5IHGDgfMzegUIPzZ1MgmrRx3rFTTyN1Qtw+sv89xipeV1LmjCwtrCjHhqpfcOyu
         UxBLJCqskJy1Q1dXLEgYm0oXyYYqNbEqxxU2BAMGaFunpC12cqr9DLSoFKk+NRIYSAIc
         Khjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679609617;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MNLrgArOYbeC4SneqmgBNc1s6gwTuQ/uP6VwFa/0H38=;
        b=VYfKdp1L99EY+OlRYnZbT/HmvGIieA29cu5f2l6EjItn6L4jaYEqlCMgZ15Rej11A6
         g6fHKuJR2FXP3jfbmLoYwC/aVEs5EjbS+g705N8lKmdvZmOS3+6+At8o5C5hsnRXOjSk
         kvgSPU8xxf51pb4FSk8Pc/YB7MtDHmOXNkiNyUBdfUMIpOHjkyBBdVUIjwrLAUKLQuq4
         fMusxxstXI3YTiw1Nem6Z/oVhWkV4txhOmkBVJhALKIQcPyFzF6BcUoshaMJRyC0cYGg
         SNIAlC0tpm6FgCZlJ+OaiVVetJL0IJz990YWcgvZdvfTaW8RwVGs3EXZnZo0tlSndW0s
         2x3g==
X-Gm-Message-State: AAQBX9dNd8p/fgOpsTZxyvPtuGBGzV65zzoNyXYTiTlQPE4gHdq+xlT4
        kTda0KBgkIwxyFbuxFKzn7+8DycpJbz9rucq20w=
X-Google-Smtp-Source: AKy350YWI+lZhJiHEgeW3Tf4/FHJBn7kHOLUoZlvkirdwDO2Lt1Zojj7duygzJyNrZsTvbbz1EQFK5dlI8srlK8P3zs=
X-Received: by 2002:a05:6902:102b:b0:b46:4a5e:3651 with SMTP id
 x11-20020a056902102b00b00b464a5e3651mr83113ybt.9.1679609617305; Thu, 23 Mar
 2023 15:13:37 -0700 (PDT)
MIME-Version: 1.0
References: <20230323121804.2249605-1-noltari@gmail.com> <20230323121804.2249605-3-noltari@gmail.com>
 <ee867960-91bb-659b-a87b-6c04613608c5@gmail.com> <AM0PR02MB55242C94846EE5598CDA44A2BD879@AM0PR02MB5524.eurprd02.prod.outlook.com>
 <c54fe984-371a-da06-6dcf-da239a26bd5f@gmail.com>
In-Reply-To: <c54fe984-371a-da06-6dcf-da239a26bd5f@gmail.com>
From:   =?UTF-8?B?w4FsdmFybyBGZXJuw6FuZGV6IFJvamFz?= <noltari@gmail.com>
Date:   Thu, 23 Mar 2023 23:13:26 +0100
Message-ID: <CAKR-sGe3dwv846fE1-JMgGsB01Ybs6LWYTrZs5hP1xc+o+dc7A@mail.gmail.com>
Subject: Re: [PATCH 2/2] net: dsa: b53: mdio: add support for BCM53134
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Paul Geurts <paul.geurts@prodrive-technologies.com>,
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

El jue, 23 mar 2023 a las 22:02, Florian Fainelli
(<f.fainelli@gmail.com>) escribi=C3=B3:
>
> On 3/23/23 13:10, Paul Geurts wrote:
> >> -----Original Message-----
> >> From: Florian Fainelli <f.fainelli@gmail.com>
> >> Sent: donderdag 23 maart 2023 17:43
> >> To: =C3=81lvaro Fern=C3=A1ndez Rojas <noltari@gmail.com>; Paul Geurts
> >> <paul.geurts@prodrive-technologies.com>; jonas.gorski@gmail.com;
> >> andrew@lunn.ch; olteanv@gmail.com; davem@davemloft.net;
> >> edumazet@google.com; kuba@kernel.org; pabeni@redhat.com;
> >> robh+dt@kernel.org; krzysztof.kozlowski+dt@linaro.org;
> >> netdev@vger.kernel.org; devicetree@vger.kernel.org; linux-
> >> kernel@vger.kernel.org
> >> Subject: Re: [PATCH 2/2] net: dsa: b53: mdio: add support for BCM53134
> >>
> >> On 3/23/23 05:18, =C3=81lvaro Fern=C3=A1ndez Rojas wrote:
> >>> From: Paul Geurts <paul.geurts@prodrive-technologies.com>
> >>>
> >>> Add support for the BCM53134 Ethernet switch in the existing b53 dsa
> >> driver.
> >>> BCM53134 is very similar to the BCM58XX series.
> >>>
> >>> Signed-off-by: Paul Geurts <paul.geurts@prodrive-technologies.com>
> >>> Signed-off-by: =C3=81lvaro Fern=C3=A1ndez Rojas <noltari@gmail.com>
> >>> ---
> >>>    drivers/net/dsa/b53/b53_common.c | 53
> >> +++++++++++++++++++++++++++++++-
> >>>    drivers/net/dsa/b53/b53_mdio.c   |  5 ++-
> >>>    drivers/net/dsa/b53/b53_priv.h   |  9 +++++-
> >>>    3 files changed, 64 insertions(+), 3 deletions(-)
> >>>
> >>> diff --git a/drivers/net/dsa/b53/b53_common.c
> >>> b/drivers/net/dsa/b53/b53_common.c
> >>> index 1f9b251a5452..aaa0813e6f59 100644
> >>> --- a/drivers/net/dsa/b53/b53_common.c
> >>> +++ b/drivers/net/dsa/b53/b53_common.c
> >>> @@ -1282,6 +1282,42 @@ static void b53_adjust_link(struct dsa_switch
> >> *ds, int port,
> >>>     if (is63xx(dev) && port >=3D B53_63XX_RGMII0)
> >>>             b53_adjust_63xx_rgmii(ds, port, phydev->interface);
> >>>
> >>> +   if (is53134(dev) && phy_interface_is_rgmii(phydev)) {
> >>
> >> Why is not this in the same code block as the one for the is531x5() de=
vice like
> >> this:
> >>
> >> diff --git a/drivers/net/dsa/b53/b53_common.c
> >> b/drivers/net/dsa/b53/b53_common.c
> >> index 59cdfc51ce06..1c64b6ce7e78 100644
> >> --- a/drivers/net/dsa/b53/b53_common.c
> >> +++ b/drivers/net/dsa/b53/b53_common.c
> >> @@ -1235,7 +1235,7 @@ static void b53_adjust_link(struct dsa_switch *d=
s,
> >> int port,
> >>                                 tx_pause, rx_pause);
> >>           b53_force_link(dev, port, phydev->link);
> >>
> >> -       if (is531x5(dev) && phy_interface_is_rgmii(phydev)) {
> >> +       if ((is531x5(dev) || is53134(dev)) &&
> >> phy_interface_is_rgmii(phydev)) {
> >>                   if (port =3D=3D dev->imp_port)
> >>                           off =3D B53_RGMII_CTRL_IMP;
> >>                   else
> >>
> >> Other than that, LGTM!
> >> --
> >> Florian
> >
> > I think the only reason is that the BCM53134 does not support the
> > RGMII_CTRL_TIMING_SEL bit, which is set in the original block. I agree
> > Putting a if statement around
> > rgmii_ctrl |=3D RGMII_CTRL_TIMING_SEL;
> > would prevent a lot of code duplication. _however_, after looking at it=
 again,
> > I don=E2=80=99t think the device does not support the bit. When looking=
 at the datasheet,
> > The same bit in the this register is called BYPASS_2NS_DEL. It's very u=
ncommon
> > For Broadcom to make such a change in the register interface, so maybe =
they
> > Just renamed it. Do you think this could be the same bit?
>
> Yes, I think this is exactly the same bit, just named differently. What
> strikes me as odd is that neither of the 53115, 53125 or 53128 which are
> guarded by the is531x5() conditional have it defined.

If this is true then we can safely add 53134 to is531x5() conditional
and reuse the existing code.

> --
> Florian
>

--
=C3=81lvaro
