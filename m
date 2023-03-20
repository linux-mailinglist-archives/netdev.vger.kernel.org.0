Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28C236C220B
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 20:57:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230367AbjCTT5Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 15:57:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230284AbjCTT5T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 15:57:19 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90F4C22DCD;
        Mon, 20 Mar 2023 12:57:12 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id e71so14663020ybc.0;
        Mon, 20 Mar 2023 12:57:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679342230;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FjiTFIZaicqZPKg4tgWcix2/4mnc0nRcF8z1GoU9iFs=;
        b=pCXjtFBoP0sYhX3FsrdPL/RdweNUJZ5MX1Gj8dq0b9ARs2hj5GQknZAeGRs0Ujoeey
         fx++Pq6wOBSoWWMd2uEiyXJDuaVl9A/wn079XcAAxxw6NQxkQv2Vy+ou6reGbzgsGA8q
         nUq9VyK+ZBxW+hwI7nErlrOfcei65wSm+P711I/H1Piok1dJ9kUMz/m7TAAPNAJfFja2
         CqIthudEZw8I4qEEvBLe0pF7I9OudgjYE+qYCqOvU43hpEBc9JqxJAO8OObAx/MrJvYR
         8GuciQ3jjEo9b4OjE9+AKq1fnIM32l8+yFgQ0yL6gF+TqpW+ReeM+8XzqNLuITrQBUm5
         K9CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679342230;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FjiTFIZaicqZPKg4tgWcix2/4mnc0nRcF8z1GoU9iFs=;
        b=omw3yaEXLjMgAoA7+8Sxmkm+A+zlxqOzWURIX7sJBMf8pidRefgi8GOn+KcgvJJdXM
         gKODsJSjh19JZZm2H6I8Ea7tQSbSqgrOCVx6bB61WRSdTe9FmDKVT9FHKyRLpbxaOGc0
         NTkLq/v00sKlP+NiBwB1LpxEhwcHIWF4W+djUCCBAtij+AORro8/vQa3gmrDDozdAtMA
         6rccfyfjfgWSKHtYM3Fc728OQppSePnLsYf7X8Kj0TClcsMkWwgFopykk9FkCMlSUfSw
         lRhhHmpwwKZlz/iqSJKenEs+MFCKopVrIsjIgZx/qaLeSTrNIhP/QtDcdLMW1f2nEbVk
         +rKA==
X-Gm-Message-State: AAQBX9cHyKsmtGLEAGxTbw/x/GHwsd1AzFSD8l4QwpHg/L8qtKey+jMg
        1uOR1jSnGC98zZb2nykSqikq7HLW7XuLEnW2RGc=
X-Google-Smtp-Source: AKy350YMbRZOjsI1y1Dz8cv58UWCBRCd3scf4Ed5jwFEuQBp+qjBHHZuS3sMiOZH1BEf1KQnr3kv0l+pe1scn+0KZb4=
X-Received: by 2002:a25:a326:0:b0:b6c:4d60:1bd6 with SMTP id
 d35-20020a25a326000000b00b6c4d601bd6mr292580ybi.9.1679342230070; Mon, 20 Mar
 2023 12:57:10 -0700 (PDT)
MIME-Version: 1.0
References: <20230320155024.164523-1-noltari@gmail.com> <20230320155024.164523-3-noltari@gmail.com>
 <ZBi56yI4CnY2AAtH@corigine.com>
In-Reply-To: <ZBi56yI4CnY2AAtH@corigine.com>
From:   =?UTF-8?B?w4FsdmFybyBGZXJuw6FuZGV6IFJvamFz?= <noltari@gmail.com>
Date:   Mon, 20 Mar 2023 20:56:58 +0100
Message-ID: <CAKR-sGf1XFP1pE1KmQVQmZADc6udS_8+qqM5NvrNZ266VPkMtw@mail.gmail.com>
Subject: Re: [PATCH 2/4] net: dsa: b53: mmap: add more BCM63xx SoCs
To:     Simon Horman <simon.horman@corigine.com>
Cc:     f.fainelli@gmail.com, andrew@lunn.ch, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

El lun, 20 mar 2023 a las 20:54, Simon Horman
(<simon.horman@corigine.com>) escribi=C3=B3:
>
> On Mon, Mar 20, 2023 at 04:50:22PM +0100, =C3=81lvaro Fern=C3=A1ndez Roja=
s wrote:
> > BCM6318, BCM6362 and BCM63268 are SoCs with a B53 MMAP switch.
> >
> > Signed-off-by: =C3=81lvaro Fern=C3=A1ndez Rojas <noltari@gmail.com>
> > ---
> >  drivers/net/dsa/b53/b53_mmap.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/drivers/net/dsa/b53/b53_mmap.c b/drivers/net/dsa/b53/b53_m=
map.c
> > index 70887e0aece3..464c77e10f60 100644
> > --- a/drivers/net/dsa/b53/b53_mmap.c
> > +++ b/drivers/net/dsa/b53/b53_mmap.c
> > @@ -331,8 +331,11 @@ static void b53_mmap_shutdown(struct platform_devi=
ce *pdev)
> >
> >  static const struct of_device_id b53_mmap_of_table[] =3D {
> >       { .compatible =3D "brcm,bcm3384-switch" },
> > +     { .compatible =3D "brcm,bcm6318-switch" },
> >       { .compatible =3D "brcm,bcm6328-switch" },
> > +     { .compatible =3D "brcm,bcm6362-switch" },
> >       { .compatible =3D "brcm,bcm6368-switch" },
> > +     { .compatible =3D "brcm,bcm63268-switch" },
>
> This patch adds support to this driver for "brcm,bcm63268-switch".
> However, less I am mistaken, this support doesn't work without
> patches 3/4 and 4/4 of this series.

It works for those devices which only use ports 0-3 (Comtrend VR-3032u
for example).
If the device has a external switch or uses any of the RGMIIs then it
won't configure those ports properly.

>
> I think it would be better to re-range this series so
> that support for "brcm,bcm63268-switch" works when it is
> added to/enabled in the driver.
>
> >       { .compatible =3D "brcm,bcm63xx-switch" },
> >       { /* sentinel */ },
> >  };
> > --
> > 2.30.2
> >
