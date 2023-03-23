Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F30486C6E17
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 17:49:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230500AbjCWQtz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 12:49:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232319AbjCWQtj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 12:49:39 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 372A710C;
        Thu, 23 Mar 2023 09:49:16 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id r187so1511051ybr.6;
        Thu, 23 Mar 2023 09:49:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679590155;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dwoV3gmNkNpNC5jzl06VUkReYtn9s53/my1cgAWnlDI=;
        b=Bu2EK1yQ3ZQVr0rLJl1Z0U6NP/ZjP2zs3EN8k8LH4XkMWW2am5t/w64NcAarDlKBqc
         woh2rX2JelIywNo6JFQAdDSwgFj/TOPBCsCr+kGiXyBhWACvIZwvnfpLBJ4KT4L5JquP
         AsytgRRtivCKASUJm2vizYsjNbLjQpQUoUpG7zoNdhBUXlMVlHVQVAwRNziOnGAOhem4
         8ElN11barkcdkH2bNjizjSNhK2LjMUE3SUjj5xVkDvbgVVvloJ8iS3qxFS1bXs8DJAiD
         ix/bS+kXAPIFKIOs7cH4TVS3rjFWMjuF/5M6FyuFGbvvcsbYTLlDb7QGo6VmogfX3K6Z
         CEug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679590155;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dwoV3gmNkNpNC5jzl06VUkReYtn9s53/my1cgAWnlDI=;
        b=ZAcqaVS1vNSLU46uVsK+FVUjt9B8Z1YeFeHv21Qb29RHECKCJcwgajlArXY9gvtxSK
         Qbjap3u+ZKSCThiqsZS2LV5KKSEWpCbt/+bZT2bTvNKI07J/M0+YuzU6RE3S2q+YMwQ4
         XmMr9vNwhbMaLueYEfcGF28s0C+Q/JyQrIY1YiKi0rA4tYDySuCKB7MdQTKYpQXw2LzH
         bgJALWYkJymuMni+XjSpjD30XSRj8wWsttA/u/8/+afz1Rsr4uUDEqSt5Z3gP1BbNwtH
         zF3JeiP1VcgLoRpulP2xDTPknDlN1wkZz7sgS+0AslUr5knSlL9V6TsGudVOEiU8DMB6
         ZF6Q==
X-Gm-Message-State: AAQBX9f8fZo8/yR/TO4H6T0PYAOpH6cy+xZmIgYRLKfyaIpY+ZAdEaOq
        RVo01wa2Q3+6Fc61q7jXr1g7kRCtbWAWq6Yr36Y=
X-Google-Smtp-Source: AKy350Z+SoFgmE7Fb9j9rcIHPb9emHS6wyfThq3Cf4KKJpyp8YY2Ehz1LoJCn2pl0zUe55El3gzt+EyzZpV7KVhUC6I=
X-Received: by 2002:a25:7456:0:b0:b6b:79a2:8cff with SMTP id
 p83-20020a257456000000b00b6b79a28cffmr2115988ybc.9.1679590155233; Thu, 23 Mar
 2023 09:49:15 -0700 (PDT)
MIME-Version: 1.0
References: <20230323121804.2249605-1-noltari@gmail.com> <20230323121804.2249605-3-noltari@gmail.com>
 <ee867960-91bb-659b-a87b-6c04613608c5@gmail.com>
In-Reply-To: <ee867960-91bb-659b-a87b-6c04613608c5@gmail.com>
From:   =?UTF-8?B?w4FsdmFybyBGZXJuw6FuZGV6IFJvamFz?= <noltari@gmail.com>
Date:   Thu, 23 Mar 2023 17:49:04 +0100
Message-ID: <CAKR-sGdhVTH__KT2bu3NM56QoJgiM0JuKXGabW5uLRg8NMwGmA@mail.gmail.com>
Subject: Re: [PATCH 2/2] net: dsa: b53: mdio: add support for BCM53134
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     paul.geurts@prodrive-technologies.com, jonas.gorski@gmail.com,
        andrew@lunn.ch, olteanv@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

El jue, 23 mar 2023 a las 17:43, Florian Fainelli
(<f.fainelli@gmail.com>) escribi=C3=B3:
>
> On 3/23/23 05:18, =C3=81lvaro Fern=C3=A1ndez Rojas wrote:
> > From: Paul Geurts <paul.geurts@prodrive-technologies.com>
> >
> > Add support for the BCM53134 Ethernet switch in the existing b53 dsa dr=
iver.
> > BCM53134 is very similar to the BCM58XX series.
> >
> > Signed-off-by: Paul Geurts <paul.geurts@prodrive-technologies.com>
> > Signed-off-by: =C3=81lvaro Fern=C3=A1ndez Rojas <noltari@gmail.com>
> > ---
> >   drivers/net/dsa/b53/b53_common.c | 53 +++++++++++++++++++++++++++++++=
-
> >   drivers/net/dsa/b53/b53_mdio.c   |  5 ++-
> >   drivers/net/dsa/b53/b53_priv.h   |  9 +++++-
> >   3 files changed, 64 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53=
_common.c
> > index 1f9b251a5452..aaa0813e6f59 100644
> > --- a/drivers/net/dsa/b53/b53_common.c
> > +++ b/drivers/net/dsa/b53/b53_common.c
> > @@ -1282,6 +1282,42 @@ static void b53_adjust_link(struct dsa_switch *d=
s, int port,
> >       if (is63xx(dev) && port >=3D B53_63XX_RGMII0)
> >               b53_adjust_63xx_rgmii(ds, port, phydev->interface);
> >
> > +     if (is53134(dev) && phy_interface_is_rgmii(phydev)) {
>
> Why is not this in the same code block as the one for the is531x5()
> device like this:

This is what I asked on the cover letter:
> I also added a separate RGMII handling block for is53134() since accordin=
g to
> Paul, BCM53134 doesn't support RGMII_CTRL_TIMING_SEL as opposed to is531x=
5().

Should I add it to the same block and avoid adding
RGMII_CTRL_TIMING_SEL if is53134() or is it compatible with
RGMII_CTRL_TIMING_SEL?

>
> diff --git a/drivers/net/dsa/b53/b53_common.c
> b/drivers/net/dsa/b53/b53_common.c
> index 59cdfc51ce06..1c64b6ce7e78 100644
> --- a/drivers/net/dsa/b53/b53_common.c
> +++ b/drivers/net/dsa/b53/b53_common.c
> @@ -1235,7 +1235,7 @@ static void b53_adjust_link(struct dsa_switch *ds,
> int port,
>                                tx_pause, rx_pause);
>          b53_force_link(dev, port, phydev->link);
>
> -       if (is531x5(dev) && phy_interface_is_rgmii(phydev)) {
> +       if ((is531x5(dev) || is53134(dev)) &&
> phy_interface_is_rgmii(phydev)) {
>                  if (port =3D=3D dev->imp_port)
>                          off =3D B53_RGMII_CTRL_IMP;
>                  else
>
> Other than that, LGTM!
> --
> Florian
>

--
=C3=81lvaro.
