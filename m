Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FBBB29137D
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 20:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438798AbgJQSRW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 14:17:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:50462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437943AbgJQSRV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Oct 2020 14:17:21 -0400
Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD280207EA
        for <netdev@vger.kernel.org>; Sat, 17 Oct 2020 18:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602958640;
        bh=22my9whyvXnHQnOzc9US7ijZhwD6U2Qie9xsF7Zv9D8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=BXA9LRVgUJvqLP3Gi7GX3P6kVwAw5lTh96iRQ7a3uagsoFs8A2m3muUoAm1ick5ZZ
         JEYrQwmOcE/7hLek2qQ0B6MTDOeQUcQPOqBR2nnmxjmlzD17xnCRKRr9H9RvrGmzDj
         V9Cap/8vNLoAh01flceERA6JQsEsQa1ff76fMpQI=
Received: by mail-oi1-f180.google.com with SMTP id s21so6857409oij.0
        for <netdev@vger.kernel.org>; Sat, 17 Oct 2020 11:17:20 -0700 (PDT)
X-Gm-Message-State: AOAM531+RTEEXQPjchmaXYghrmxrlUgW2XUl/SoovmF+kY8mnQ+zy+lC
        a+acnWP1wl/Jx+vKVneGvH0UTnRPrqDK73UD2Ck=
X-Google-Smtp-Source: ABdhPJzo0M9/ieB0ThJNFiKHcpT+kbVUKbIrRfO7g22xplwnPgwEclj+Vdfx3be4Y9Ym73aT7Naoh98aJNII0q4n/8g=
X-Received: by 2002:aca:4085:: with SMTP id n127mr6456504oia.33.1602958640032;
 Sat, 17 Oct 2020 11:17:20 -0700 (PDT)
MIME-Version: 1.0
References: <CAMj1kXEEF_Un-4NTaD5iUN0NoZYaJQn-rPediX0S6oRiuVuW-A@mail.gmail.com>
 <20201017144430.GI456889@lunn.ch> <CAMj1kXHsNrRSkZfSJ_VatES+V1obLcvfo=Qab_4jy58Znpjy6Q@mail.gmail.com>
 <20201017151132.GK456889@lunn.ch> <CAMj1kXH+Z56dkZz8OYMhPuqbjPPCqW=UMV6w--=XXh87UyHVaQ@mail.gmail.com>
 <20201017161435.GA1768480@apalos.home> <CAMj1kXHXYprdC19m1S5p_LQ2BOHtDCbyCWCJ0eJ5xPxFv8hgoA@mail.gmail.com>
 <20201017180453.GM456889@lunn.ch> <CAMj1kXEcrULejk+h1Jv42W=r7odQ9Z_G0XDX_KrEnYYPEVgHkA@mail.gmail.com>
In-Reply-To: <CAMj1kXEcrULejk+h1Jv42W=r7odQ9Z_G0XDX_KrEnYYPEVgHkA@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Sat, 17 Oct 2020 20:17:09 +0200
X-Gmail-Original-Message-ID: <CAMj1kXF5BGgER0eQjGUmyjX2jh=jmmLsJMo6W19o0EhFLr-k7Q@mail.gmail.com>
Message-ID: <CAMj1kXF5BGgER0eQjGUmyjX2jh=jmmLsJMo6W19o0EhFLr-k7Q@mail.gmail.com>
Subject: Re: realtek PHY commit bbc4d71d63549 causes regression
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
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

On Sat, 17 Oct 2020 at 20:11, Ard Biesheuvel <ardb@kernel.org> wrote:
>
> On Sat, 17 Oct 2020 at 20:04, Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > > I have tried this, and it seems to fix the issue. I will send out a
> > > patch against the netsec driver.
> >
> > Please also fix the firmware so it does not pass rgmii.
> >
> > If there are pure DT systems, which do require phy-mode to be used, we
> > will need to revert your proposed change in order to make the MAC
> > driver work as it should, rather than work around the broken firmware.
> >
>
> What do you mean by 'pure' DT system? Only EDK2 based firmware exists
> for this platform, and it can be configured to boot either in DT or in
> ACPI mode. In both cases, it will pass the same, incorrect PHY mode,
> and in both cases, the firmware will already have configured the PHY
> correctly.
>
> So what I propose to do is drop the handling of the [mandatory]
> phy-mode device property from the netsec driver (which is really only
> used by this board). As we don't really need a phy-mode to begin with,
> and given that firmware exists in the field that passes the wrong
> value, the only option I see for passing a value here is to use a
> different, *optional* DT property (force-phy-mode or
> phy-mode-override) that takes the place of phy-mode. For ACPI boot,
> you will just need to fix your firmware if you are using a different
> PHY configuration.

... or add a property that makes 'phy-mode' take effect, and default
to ignoring it.
