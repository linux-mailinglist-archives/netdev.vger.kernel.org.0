Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C62806EE8D7
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 22:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236258AbjDYUKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 16:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236252AbjDYUKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 16:10:19 -0400
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1995313C04
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 13:10:18 -0700 (PDT)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-54fe2e39156so74334147b3.2
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 13:10:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google; t=1682453417; x=1685045417;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ajM0LwQkx5V/I2/UibvsrZZndqIviz/M9DBiru/mXQg=;
        b=dTvvZyFpBT/vP4cJvDwecqbyU3C1xxDniswbOHTFkvd0pEIf0axd4MmboZLWTzEgH9
         muG1HEnAOXQVlKjiu6CWR/NK5EL8p/F4SqMJPUKKJbRxmitYmgvkaCysoxwKpcvlAU7n
         UPXVEZFigyrCV9ZpEjJDoinTLybvaQr+AdOmQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682453417; x=1685045417;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ajM0LwQkx5V/I2/UibvsrZZndqIviz/M9DBiru/mXQg=;
        b=iz30anFVm30Dq9qXbsRfRlAxx23N4/O1DBZCDsDmzmw4+I4HrqFC+r2Z6Lk5/34+Bn
         3yE4bdA+0ggcRi9RgxNvXymLnbmhX9EAKBOUlEh+LxHbxe1LVxv8IadnebYsxdi0H1Z2
         KxEodQgKXaL0mLi496ll+pf8AwIBPOtJLwzXO7t002g7Y/Kjnc74pl3clsbAVMp+MZLX
         zXc4W6L/0/P8aY+lLsli2gKYq+UIHqRjjjfAwoOhoJ95nlx6ypUhCgoaNu8VxnHm6VWc
         686bRFByRn4YdGzi89gbgNf01RtQXPBZNO+S3vnEnMxCRFeatXiSjM0DxJZemw2h2tFu
         IQ/g==
X-Gm-Message-State: AAQBX9cO1mhRYrnYMqzAyd4AC/prAF/q89E27RU8vrc8nezXtlI3JVeU
        CMS2lBiRj7/8NWhSPsUersmfKaWsiFcJuzOBt680Kw==
X-Google-Smtp-Source: AKy350aQ40+4HpZ6RTwx6wGwaL/ZQkmDudx4fSWnKEsjw/eI3Ll2kkGSGGDzzDshudDy4AnnqGlIXyWsPZ8R7tXg9+w=
X-Received: by 2002:a81:6742:0:b0:54c:b26:b0e with SMTP id b63-20020a816742000000b0054c0b260b0emr11871415ywc.25.1682453416722;
 Tue, 25 Apr 2023 13:10:16 -0700 (PDT)
MIME-Version: 1.0
References: <20230423172528.1398158-1-dario.binacchi@amarulasolutions.com>
 <20230423172528.1398158-5-dario.binacchi@amarulasolutions.com>
 <20230423-surplus-spoon-4e8194434663-mkl@pengutronix.de> <CABGWkvqA2hwgfGvVWS08Qu-2ZUbwc82ynhvq8-FqFuhHoV-vhw@mail.gmail.com>
 <20230424-fracture-going-5dcaf06a9e6c-mkl@pengutronix.de>
In-Reply-To: <20230424-fracture-going-5dcaf06a9e6c-mkl@pengutronix.de>
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
Date:   Tue, 25 Apr 2023 22:10:05 +0200
Message-ID: <CABGWkvp+ffrHgOVF48Zug+b4MfTbsQeCkiKDUAMm+M3NHwutJg@mail.gmail.com>
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

On Mon, Apr 24, 2023 at 12:06=E2=80=AFPM Marc Kleine-Budde <mkl@pengutronix=
.de> wrote:
>
> On 24.04.2023 08:56:03, Dario Binacchi wrote:
> > > This probably works. Can we do better, i.e. without this additional c=
ode?
> > >
> > > If you add a syscon node for the single instance CAN, too, you don't
> > > need a code change here, right?
> >
> > I think so.
> >
> > I have only one doubt about it. This implementation allows,
> > implicitly, to distinguish if the peripheral is in single
> > configuration (without handle to the gcan node) or in double
> > configuration (with handle to the gcan node). For example, in single
> > configuration the peripheral has 14 filter banks, while in double
> > configuration there are 26 shared banks. Without code changes, this
> > kind of information is lost. Is it better then, for future
> > developments, to add a new boolean property to the can node of the dts
> > (e.g. single-conf)?
>
> The DT ist not yet mainline, so we can still change it. Another option
> is to have "st,can-primary" and "st,can-secondary" for the shared
> peripherals and nothing for the single instance.

I did some tests following your suggestion. It is however necessary to
make some small changes to the driver.
I will send v2 as soon as possible.

Thanks and regards,
Dario

>
> regards,
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
