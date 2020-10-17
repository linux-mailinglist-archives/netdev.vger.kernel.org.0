Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 163C3291311
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 18:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437698AbgJQQWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 12:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2409937AbgJQQWK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Oct 2020 12:22:10 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93F13C061755
        for <netdev@vger.kernel.org>; Sat, 17 Oct 2020 09:22:10 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id a4so4713863ybq.13
        for <netdev@vger.kernel.org>; Sat, 17 Oct 2020 09:22:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=F+XtgTV+Cf+pCChf89cGLcydIx9HQGzuW2HNG2iRQu0=;
        b=KrS14vNobICUYpKm0kg2G6svAkODA5zNYLh9SGeuZuUxDF23XpchZReX7mTP+oeG13
         tooZlUFMfOr66J6PaqRCGI0O4FLh/8CDjiWAvKMVUL3LvrzusEQNOWBa2GxcVlOw7CXV
         9yMXuA4R5NVO7YlCWmqf6XVQE4Ebmfi6v6xzT0HK4jc7Pk37n0+5n70wjIqh9NdXBrMU
         Kg6khdnty11Zzu1urYco7kdEP+hcSOyalRzLFG+mYRvVecNfMxNmTEg8TKNW9bLmKVo5
         EtYUuYDo4kgmri2mG0sbdcq65KMPw1hC0Xtx3OwxW9KKWTjejlQ4dZioAGmCHwP+RpKu
         nHwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=F+XtgTV+Cf+pCChf89cGLcydIx9HQGzuW2HNG2iRQu0=;
        b=O/H2rx3TjMIJXmxdiiBjjQ0GOehwbSNX4dz9JyoNchY30A9zGi+bMDM4tv871SBywr
         7c1zu1Bp6V1K1xJnN9X71e20XiVQ6Vtie+nIZAuEkjuBXD/0BF2obzohWCZLTONhRrmg
         x8vobqHx2lRDqW2uRPDU5BThx+xQIk4O1tP/DeCK9l+9laTFvyEOGk3aWpkI1Ev3vpkr
         ctP3incCB4T3KCuoaj6E5M/ZIDJfww8aOT883mDiVMflXvWtwtvaaG7WejsyDuN9EvRd
         4SUMTCQn75z/hDy4lP+aIh8nfgQROu3kxj/T0ku3gDlf53gCc1XU3wrkAa3YiZvUf6aK
         Cx3w==
X-Gm-Message-State: AOAM530vLZghVNonuj6zNlijrQ/fEj5WY7XfIaS8UOVElfeaOXUZmAVF
        xQzF15wkMxGN7YzspZNTw5zcCstO51sEEydgh9PfYg==
X-Google-Smtp-Source: ABdhPJzaK2bCpDDG3eCrRMR/OnZ1icF1mU8SuSKIq8jmSsDUdkcsRxtuQ9SCCoohKjm4oZJL/gSXnxzC6JkK8Zriu6I=
X-Received: by 2002:a25:4ed7:: with SMTP id c206mr11759408ybb.256.1602951729751;
 Sat, 17 Oct 2020 09:22:09 -0700 (PDT)
MIME-Version: 1.0
References: <CAMj1kXEEF_Un-4NTaD5iUN0NoZYaJQn-rPediX0S6oRiuVuW-A@mail.gmail.com>
 <20201017144430.GI456889@lunn.ch> <CAMj1kXHsNrRSkZfSJ_VatES+V1obLcvfo=Qab_4jy58Znpjy6Q@mail.gmail.com>
 <20201017151132.GK456889@lunn.ch> <CAMj1kXH+Z56dkZz8OYMhPuqbjPPCqW=UMV6w--=XXh87UyHVaQ@mail.gmail.com>
 <20201017161435.GA1768480@apalos.home> <CAMj1kXHXYprdC19m1S5p_LQ2BOHtDCbyCWCJ0eJ5xPxFv8hgoA@mail.gmail.com>
In-Reply-To: <CAMj1kXHXYprdC19m1S5p_LQ2BOHtDCbyCWCJ0eJ5xPxFv8hgoA@mail.gmail.com>
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date:   Sat, 17 Oct 2020 19:21:58 +0300
Message-ID: <CAC_iWj+yd27cSZMu_+4j=1639y4c07CziTMR03A-kDcWwXHO9A@mail.gmail.com>
Subject: Re: realtek PHY commit bbc4d71d63549 causes regression
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <netdev@vger.kernel.org>, Willy Liu <willy.liu@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Masahisa Kojima <masahisa.kojima@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ard,

[...]
> > > > You can also use '' as the phy-mode, which results in
> > > > PHY_INTERFACE_MODE_NA, which effectively means, don't touch the PHY
> > > > mode, something else has already set it up. This might actually be the
> > > > correct way to go for ACPI. In the DT world, we tend to assume the
> > > > bootloader has done the absolute minimum and Linux should configure
> > > > everything. The ACPI takes the opposite view, the firmware will do the
> > > > basic hardware configuration, and Linux should not touch it, or ask
> > > > ACPI to modify it.
> > > >
> > >
> > > Indeed, the firmware should have set this up.
> >
> > Would EDK2 take care of the RGMII Rx/Tx delays even when configured to
> > use a DT instead of ACPI?
> >
>
> Yes. The network driver has no awareness whatsoever which h/w
> description is being provided to the OS.
>
>
> > > This would mean we could > do this in the driver: it currently uses
> > >
> > > priv->phy_interface = device_get_phy_mode(&pdev->dev);
> > >
> > > Can we just assign that to PHY_INTERFACE_MODE_NA instead?
> >
>
> I have tried this, and it seems to fix the issue. I will send out a
> patch against the netsec driver.

Great thanks!

Cheers
/Ilias
