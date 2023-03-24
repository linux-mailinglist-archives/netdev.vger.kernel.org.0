Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 455926C7A1D
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 09:44:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231743AbjCXIn7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 04:43:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231835AbjCXIn4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 04:43:56 -0400
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A942514EBA;
        Fri, 24 Mar 2023 01:43:55 -0700 (PDT)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-53d277c1834so20875847b3.10;
        Fri, 24 Mar 2023 01:43:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679647435;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WBXiyiBi1MVjMWFi8bx61/D57O96xN8qenjvC6DR/rc=;
        b=MxP1VC4AEuRdX8z/1f8qcDbubZSDPsT+/1nodIq4f7fh6lCe3wjnK8T46IhZqC2ybH
         te8YtS+RaZ0R/3LYwIFjiCg2tLMcAnWVaGzr5fjcMGWcPQqKzLO/B0gli+A+CstUrFUd
         yUGJViYuSCyRWBChOg4GSErCxGzmdbi34Q8LHKT+c8bNVS2Jmn+e4yiKoJqqsEixoZ3k
         4iPeL7DgCmawZAEaqFlyaDG8fJe/8VL7k1mKQZyJ2O9jwB3EiZpO6pvowQS9y8cVAgmi
         5gL6hlfALI4vlQWlN1k10Jm/7V7Z24y6J3Qs3s7ygtmDSoFTurs/yUSFKgS9WycfT4Vf
         obLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679647435;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WBXiyiBi1MVjMWFi8bx61/D57O96xN8qenjvC6DR/rc=;
        b=jr3m/Gb3l7ug5z+nIDKYfnpchYi/7Jd1LvPmFQ4yuK8tjhkXcFpkQZNMwRxfjJ3DHq
         s5vSaYI7lIVb+s4K6XDzqFrym3RbPZ2n+fPd4SH/TxZPiFkrboZt2mmyWwYtg/WKFVDz
         WxVZHEa7W9PM2+FqceZIGErHnsESvz4YULDvPX5N4wqdLnmvvir+UXLYJOUit0bzeXGV
         YJtVwD53KR2AXwwE77cGVbjW7W8vxjwDCV4HWdx72Dmlls+6FUPyUJinVDGYQeovhHU2
         fRa4YHGy+icPvJGogPgLILT2XxdLK+tCz4u733mRjqzueCZKQPFSzhqqlktZ2jku9v/T
         G/lg==
X-Gm-Message-State: AAQBX9cUk1NQQON5WFyHr8h6h05Yh63ebg6h+AUTPQCEnh7Sr4UidTLD
        HBOwl1213x9NydBCLytraPXDo8Gag3daHrmK2gU=
X-Google-Smtp-Source: AKy350a9V3xWkjFA1n9cz+qBV52p4Sg/CEuXmADUWubDDcgNAXDPds68eP/cVxnK7I5wwHACQrJWCRngCU/z7QzYjOY=
X-Received: by 2002:a81:ac67:0:b0:541:9063:8e9e with SMTP id
 z39-20020a81ac67000000b0054190638e9emr673303ywj.2.1679647434817; Fri, 24 Mar
 2023 01:43:54 -0700 (PDT)
MIME-Version: 1.0
References: <20230323121804.2249605-1-noltari@gmail.com> <20230323121804.2249605-3-noltari@gmail.com>
 <ee867960-91bb-659b-a87b-6c04613608c5@gmail.com> <AM0PR02MB55242C94846EE5598CDA44A2BD879@AM0PR02MB5524.eurprd02.prod.outlook.com>
 <c54fe984-371a-da06-6dcf-da239a26bd5f@gmail.com> <CAKR-sGe3dwv846fE1-JMgGsB01Ybs6LWYTrZs5hP1xc+o+dc7A@mail.gmail.com>
 <AM0PR02MB5524E0D52BCBE7F1123FB7FCBD849@AM0PR02MB5524.eurprd02.prod.outlook.com>
In-Reply-To: <AM0PR02MB5524E0D52BCBE7F1123FB7FCBD849@AM0PR02MB5524.eurprd02.prod.outlook.com>
From:   =?UTF-8?B?w4FsdmFybyBGZXJuw6FuZGV6IFJvamFz?= <noltari@gmail.com>
Date:   Fri, 24 Mar 2023 09:43:43 +0100
Message-ID: <CAKR-sGeSc15PVy+cLzE5tA+c-1gpWYCi+XB65NHf_fkZUr_YoQ@mail.gmail.com>
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

El vie, 24 mar 2023 a las 9:29, Paul Geurts
(<paul.geurts@prodrive-technologies.com>) escribi=C3=B3:
>
> > -----Original Message-----
> > From: =C3=81lvaro Fern=C3=A1ndez Rojas <noltari@gmail.com>
> > Sent: donderdag 23 maart 2023 23:13
> > To: Florian Fainelli <f.fainelli@gmail.com>
> > Cc: Paul Geurts <paul.geurts@prodrive-technologies.com>;
> > jonas.gorski@gmail.com; andrew@lunn.ch; olteanv@gmail.com;
> > davem@davemloft.net; edumazet@google.com; kuba@kernel.org;
> > pabeni@redhat.com; robh+dt@kernel.org;
> > krzysztof.kozlowski+dt@linaro.org; netdev@vger.kernel.org;
> > devicetree@vger.kernel.org; linux-kernel@vger.kernel.org
> > Subject: Re: [PATCH 2/2] net: dsa: b53: mdio: add support for BCM53134
> >
> > El jue, 23 mar 2023 a las 22:02, Florian Fainelli
> > (<f.fainelli@gmail.com>) escribi=C3=B3:
> > >
> > > On 3/23/23 13:10, Paul Geurts wrote:
> > > >> -----Original Message-----
> > > >> From: Florian Fainelli <f.fainelli@gmail.com>
> > > >> Sent: donderdag 23 maart 2023 17:43
> > > >> To: =C3=81lvaro Fern=C3=A1ndez Rojas <noltari@gmail.com>; Paul Geu=
rts
> > > >> <paul.geurts@prodrive-technologies.com>; jonas.gorski@gmail.com;
> > > >> andrew@lunn.ch; olteanv@gmail.com; davem@davemloft.net;
> > > >> edumazet@google.com; kuba@kernel.org; pabeni@redhat.com;
> > > >> robh+dt@kernel.org; krzysztof.kozlowski+dt@linaro.org;
> > > >> netdev@vger.kernel.org; devicetree@vger.kernel.org; linux-
> > > >> kernel@vger.kernel.org
> > > >> Subject: Re: [PATCH 2/2] net: dsa: b53: mdio: add support for
> > > >> BCM53134
> > > >>
> > > >> On 3/23/23 05:18, =C3=81lvaro Fern=C3=A1ndez Rojas wrote:
> > > >>> From: Paul Geurts <paul.geurts@prodrive-technologies.com>
> > > >>>
> > > >>> Add support for the BCM53134 Ethernet switch in the existing b53
> > > >>> dsa
> > > >> driver.
> > > >>> BCM53134 is very similar to the BCM58XX series.
> > > >>>
> > > >>> Signed-off-by: Paul Geurts <paul.geurts@prodrive-technologies.com=
>
> > > >>> Signed-off-by: =C3=81lvaro Fern=C3=A1ndez Rojas <noltari@gmail.co=
m>
> > > >>> ---
> > > >>>    drivers/net/dsa/b53/b53_common.c | 53
> > > >> +++++++++++++++++++++++++++++++-
> > > >>>    drivers/net/dsa/b53/b53_mdio.c   |  5 ++-
> > > >>>    drivers/net/dsa/b53/b53_priv.h   |  9 +++++-
> > > >>>    3 files changed, 64 insertions(+), 3 deletions(-)
> > > >>>
> > > >>> diff --git a/drivers/net/dsa/b53/b53_common.c
> > > >>> b/drivers/net/dsa/b53/b53_common.c
> > > >>> index 1f9b251a5452..aaa0813e6f59 100644
> > > >>> --- a/drivers/net/dsa/b53/b53_common.c
> > > >>> +++ b/drivers/net/dsa/b53/b53_common.c
> > > >>> @@ -1282,6 +1282,42 @@ static void b53_adjust_link(struct
> > > >>> dsa_switch
> > > >> *ds, int port,
> > > >>>     if (is63xx(dev) && port >=3D B53_63XX_RGMII0)
> > > >>>             b53_adjust_63xx_rgmii(ds, port, phydev->interface);
> > > >>>
> > > >>> +   if (is53134(dev) && phy_interface_is_rgmii(phydev)) {
> > > >>
> > > >> Why is not this in the same code block as the one for the is531x5(=
)
> > > >> device like
> > > >> this:
> > > >>
> > > >> diff --git a/drivers/net/dsa/b53/b53_common.c
> > > >> b/drivers/net/dsa/b53/b53_common.c
> > > >> index 59cdfc51ce06..1c64b6ce7e78 100644
> > > >> --- a/drivers/net/dsa/b53/b53_common.c
> > > >> +++ b/drivers/net/dsa/b53/b53_common.c
> > > >> @@ -1235,7 +1235,7 @@ static void b53_adjust_link(struct dsa_switc=
h
> > > >> *ds, int port,
> > > >>                                 tx_pause, rx_pause);
> > > >>           b53_force_link(dev, port, phydev->link);
> > > >>
> > > >> -       if (is531x5(dev) && phy_interface_is_rgmii(phydev)) {
> > > >> +       if ((is531x5(dev) || is53134(dev)) &&
> > > >> phy_interface_is_rgmii(phydev)) {
> > > >>                   if (port =3D=3D dev->imp_port)
> > > >>                           off =3D B53_RGMII_CTRL_IMP;
> > > >>                   else
> > > >>
> > > >> Other than that, LGTM!
> > > >> --
> > > >> Florian
> > > >
> > > > I think the only reason is that the BCM53134 does not support the
> > > > RGMII_CTRL_TIMING_SEL bit, which is set in the original block. I
> > > > agree Putting a if statement around rgmii_ctrl |=3D
> > > > RGMII_CTRL_TIMING_SEL; would prevent a lot of code duplication.
> > > > _however_, after looking at it again, I don=E2=80=99t think the dev=
ice does
> > > > not support the bit. When looking at the datasheet, The same bit in
> > > > the this register is called BYPASS_2NS_DEL. It's very uncommon For
> > > > Broadcom to make such a change in the register interface, so maybe
> > > > they Just renamed it. Do you think this could be the same bit?
> > >
> > > Yes, I think this is exactly the same bit, just named differently.
> > > What strikes me as odd is that neither of the 53115, 53125 or 53128
> > > which are guarded by the is531x5() conditional have it defined.
> >
> > If this is true then we can safely add 53134 to is531x5() conditional a=
nd reuse
> > the existing code.
> >
> > > --
> > > Florian
> > >
> >
> > --
> > =C3=81lvaro
>
> With the bit set on my device, everything keeps working just fine. I inde=
ed think
> This is just the same bit. I have requested some clarity from our FAE at
> Broadcom. We could wait for their answer (which could take a while), or j=
ust
> assume setting this bit is fine an push the patches. I'll leave that up t=
o you.

I've checked and mine works fine too, so I simplified the patch in v2.

>
> ---
> Paul

--
=C3=81lvaro
