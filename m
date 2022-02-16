Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48D614B8FC4
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 18:57:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237369AbiBPR5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 12:57:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230424AbiBPR5f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 12:57:35 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3955B2731CF;
        Wed, 16 Feb 2022 09:57:23 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id 75so2802653pgb.4;
        Wed, 16 Feb 2022 09:57:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7y8q6OneMcYJn/oXpuf4sPWEGuBdMP1my8DiPVgdjX0=;
        b=Txm8TRHo7HhSusITLNfaXifnUaXbIewk6UBdDzIMVVn0JQg4vytJWACECNn4zpZTo8
         C/7SLPOhN/vxl6ZrOFnZbi7X4H84x+zdHJkB9aTvjUW1QedJPbv4VyFbtamx+LiSsfWe
         UJPbnhL/X21mX7bx1BEzrTwbzPUxbiEaCy3XbJ7AHFbRnEOqKrstKHfORpF4bbmNc5l7
         +qZr0+8BIPcqnoJH73OTu6azbFBEdjbdiHZqIVOjmqd5RIV1ad2WMS3BrERPuFWtjqp9
         TQb69F3KzbZtcF0FPvzt8Rmn1Np/+jXqlTUVFr00CZHxkz4FUHc7PzgKOFtA8nGn2XBE
         D9TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7y8q6OneMcYJn/oXpuf4sPWEGuBdMP1my8DiPVgdjX0=;
        b=zo31Qu+0AQdzH6qiJ/iDY/jnkBQlVIPxTqtY8lEjWsyPVd1Cjy03/MuvgnwIWwHpcy
         Y3HbKDvJBdEBvfFwSIRREACqrSC+o/cblJcBRvPwGRvjFDpCg7m5zJipxCEJl+w8G94c
         ShHnPdhnvIiE5jCeSdpY3B8QW8Mo/84TnAoAh5K+uHD/sQrmhi+QEpgNuazC3F22rH7k
         qW/Lu0fVDd5yWufWoSA8A7JOGAP+Paa0R6HJ5YCBg7FV7RSHGygkvXjbMqMrrE/LQG7K
         dFG5PO3tSA6iK00J1eax5RRK7WzFNdM56mgnhGtG+eEpF9sEcwTO0E+PEyi6dHfDQXSx
         jn8w==
X-Gm-Message-State: AOAM530ImOAMgq7Vx4aP6odC/AEkwJt/VQ6GAju2dkV6mdhMO1Y7jMvE
        uT2ZZ1c+MuGIOmCTBQbgx8nklCzDacSWcJDKv8XdMvDqf8w=
X-Google-Smtp-Source: ABdhPJyQ83J9X1nM7p80Xvvd3VhxPrCSbOrawZLlO8Oib1ZlhChp0TbAMyetYQaCD9rPwrvsekT2vwBUaIsyugeiTkE=
X-Received: by 2002:a63:ce54:0:b0:364:f310:6e0c with SMTP id
 r20-20020a63ce54000000b00364f3106e0cmr3223250pgi.456.1645034242701; Wed, 16
 Feb 2022 09:57:22 -0800 (PST)
MIME-Version: 1.0
References: <20220216160500.2341255-1-alvin@pqrs.dk>
In-Reply-To: <20220216160500.2341255-1-alvin@pqrs.dk>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Wed, 16 Feb 2022 14:57:11 -0300
Message-ID: <CAJq09z6Mr7QFSyqWuM1jjm9Dis4Pa2A4yi=NJv1w4FM0WoyqtA@mail.gmail.com>
Subject: Re: [PATCH net-next 0/2] net: dsa: realtek: fix PHY register read corruption
To:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alvin@pqrs.dk>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Rasmussen <mir@bang-olufsen.dk>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> These two patches fix the issue reported by Ar=C4=B1n=C3=A7 where PHY reg=
ister
> reads sometimes return garbage data.
>
> MAINTAINERS: Please can you help me with the targetting of these two
> patches? This bug is present ca. 5.16, when the SMI version of the
> rtl8365mb driver was introduced. But now in net-next we have the MDIO
> interface from Luiz, where the issue is also present. I am sending what
> I think is an ideal patch series, but should I split it up and send the
> SMI-related changes to net and the MDIO changes to net-next? If so, how
> would I go about splitting it while preventing merge conflicts and build
> errors?
>
> For now I am sending it to net-next so that the whole thing can be
> reviewed. If it's applied, I would gladly backport the fix to the stable
> tree for 5.16, but I am still confused about what to do for 5.17.
>
> Thanks for your help.
>
>
> Alvin =C5=A0ipraga (2):
>   net: dsa: realtek: allow subdrivers to externally lock regmap
>   net: dsa: realtek: rtl8365mb: serialize indirect PHY register access
>
>  drivers/net/dsa/realtek/realtek-mdio.c | 46 +++++++++++++++++++++-
>  drivers/net/dsa/realtek/realtek-smi.c  | 48 +++++++++++++++++++++--
>  drivers/net/dsa/realtek/realtek.h      |  2 +
>  drivers/net/dsa/realtek/rtl8365mb.c    | 54 ++++++++++++++++----------
>  4 files changed, 124 insertions(+), 26 deletions(-)
>
> --
> 2.35.0
>

Thanks for the fix, Alvin.

I still feel like we are trying to go around a regmap limitation
instead of fixing it there. If we control regmap lock (we can define a
custom lock/unlock) and create new regmap_{read,write}_nolock
variants, we'll just need to lock the regmap, do whatever you need,
and unlock it.

BTW, I believe that, for realtek-mdio, a regmap custom lock mechanism
could simply use mdio lock while realtek-smi already has priv->lock.

Regards,
