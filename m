Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2B7E47983A
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 03:45:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231720AbhLRCpb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 21:45:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbhLRCpa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 21:45:30 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 827F8C061574
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 18:45:30 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id h19-20020a9d3e53000000b0056547b797b2so5153840otg.4
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 18:45:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qk3hJCTz5p4iPv896qhk+EJKHjSexX+QrCr/DDTT4Cg=;
        b=mSvRV2gTerd4b5HpIDR4kKR7XrgSi+Dn3kjNcm4cph8njN36EcW6xXUl86CJOEAjd0
         F7TsoK2/SQjADrqFsaq7pV8l57NHk1QmGsb2WUPC+WZ7L2xnGFGMBHU5kj1j1KZvCjQ1
         fTZ7oZJaDUFZ7VW4XOvIx4ryr5WB+aA8Y6OajKW9uJ/wB3EkpZOqVt/6AocVoFtQM2Qm
         l7EY9olPfgdlmu+f6ZXvW88zvElh1KzvcALcH8XTkVwpYU/11/FquS/lFSGp2NjyVWIe
         VcGtcCJ/cIAGgprKDO3/fxycCy7Po636yY0epRubiO10H2A2qJwAL729+sIOtaSTVbOQ
         a8OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qk3hJCTz5p4iPv896qhk+EJKHjSexX+QrCr/DDTT4Cg=;
        b=WS7AJ5ArvNvvbST30cztRVOO/0ZS/e/Od3i4VbKF5rrrHnrSokOX26Ww7iMCGF/EV5
         vQJFOynCqXxeuUDU3xqxNlFYsCEtADdnRojDsPwO3cfdXfXA4gNnl1PecT79d2rEOnMS
         YnWk8Iwgnkv+pu5kTuZtKY5muz77ofFOQUMBw5ddchpP/6CtbZa8Kl+R5UcEC8d+3DI4
         cT7WRyVNztO6mL0uY4gT62nWHHUTGch4c8wMDvmZJPWzTyL5HIuO+dRoogsDs5inDK/A
         igln034xhbYlJtMIrHGrWX/5PjzAN9n3vLFCxQi/v9TD1ULp1HKXalQniuZ6Ud2kxiTq
         Kpfg==
X-Gm-Message-State: AOAM532UJT2lA9aevD1W695F/Md8XJsVD49xP/RWvMQz62CF1YwYK7Bd
        8gN5IY24HWnwhPiUG6IjL5nNqj5n6RKZyN4bB0GHHXW1i0o=
X-Google-Smtp-Source: ABdhPJyCc+nhP4OYJCqQCqtwKRX7Ep5wCu+8QrSoSBsauqlue8d30FIJ8HYznGbVnGtnq8Ni4SFOuG9Lvf0OIk+pqtQ=
X-Received: by 2002:a9d:a42:: with SMTP id 60mr4299652otg.179.1639795529613;
 Fri, 17 Dec 2021 18:45:29 -0800 (PST)
MIME-Version: 1.0
References: <20211216201342.25587-1-luizluca@gmail.com> <20211216201342.25587-4-luizluca@gmail.com>
 <4a95c493-5ea3-5f2d-b57a-70674b10a7f0@bang-olufsen.dk> <CAJq09z4NJhU7NgzHNg=jRhi1nZgpszPzCssb_z4h0qYUzcO_FQ@mail.gmail.com>
In-Reply-To: <CAJq09z4NJhU7NgzHNg=jRhi1nZgpszPzCssb_z4h0qYUzcO_FQ@mail.gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sat, 18 Dec 2021 03:45:18 +0100
Message-ID: <CACRpkdakKuQuRff2Rb=8hkDka=+eeWox_9tvm-nhCrGzffed9w@mail.gmail.com>
Subject: Re: [PATCH net-next 03/13] net: dsa: realtek: rename realtek_smi to realtek_priv
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 17, 2021 at 7:21 AM Luiz Angelo Daros de Luca
<luizluca@gmail.com> wrote:
> Em qui., 16 de dez. de 2021 =C3=A0s 20:22, Alvin =C5=A0ipraga
> <ALSI@bang-olufsen.dk> escreveu:
> >
> > Hi Luiz,
> >
> > On 12/16/21 21:13, luizluca@gmail.com wrote:
> > > From: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> > >
> > > In preparation to adding other interfaces, the private data structure
> > > was renamed to priv. Also the only two direct calls from subdrivers
> > > to realtek-smi lib were converted into references inside priv.
> >
> > Maybe split this patch to separate the churn from the more interesting
> > change, which I guess is needed to support different bus types for the
> > subdrivers.
> >
>
> Yes, it is better to split into two commits:
>
> 1) net: dsa: realtek: rename realtek_smi to realtek_priv (only string
> replace/file move)
> 2) net: dsa: realtek: remove direct calls to realtek-smi (the good stuff)

I wait for this version before reviewing :)

I would probably name it "rtlsw" (for "realtek-switch") instead of
"smi" or "priv" since "priv" doesn't hint about what it is just that it is
a private state of some kind, but it's no big deal.

Yours,
Linus Walleij
