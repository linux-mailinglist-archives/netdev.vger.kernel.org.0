Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 036B9291378
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 20:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438791AbgJQSLh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 14:11:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:49710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437224AbgJQSLh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Oct 2020 14:11:37 -0400
Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 846D82074A
        for <netdev@vger.kernel.org>; Sat, 17 Oct 2020 18:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602958296;
        bh=wX+lL4WtAuqjsoQQbGH5kcxWF/Isg6XPw3Pf0idG5Ck=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=mPqnvWj32XyeuwJ7TxJtqRPijYQDZVpkITheCM1ijRDJaupDQ1xli81XzbWFhL701
         C7lFSE/+h1FyQlfsHvmsjGtBzjWd3Kw7Vc4tlyfYNDqMWD/kwwJZT/MMB/LY4g+3ga
         eYRH9F/Uv+Pb0poZsLDEMiUemnZlk0TeG4IyBurE=
Received: by mail-oi1-f177.google.com with SMTP id h10so6827998oie.5
        for <netdev@vger.kernel.org>; Sat, 17 Oct 2020 11:11:36 -0700 (PDT)
X-Gm-Message-State: AOAM533BAk7bTEBmIVXjF2GhXSJzZzdRgsCl7lj45FfghK42NGiq7i/T
        5Imez1SxwgyS0REcE0Jl8dAlKH07KX2o/Xpa1is=
X-Google-Smtp-Source: ABdhPJzr9gBiD64POJmS0aoSk5pD02KzBv9Dgeoa0sn33SGPfJsyHzwHKVyhF295qKeeOpbR3VFM77xJu4dO4qhxiuI=
X-Received: by 2002:aca:4085:: with SMTP id n127mr6440941oia.33.1602958295926;
 Sat, 17 Oct 2020 11:11:35 -0700 (PDT)
MIME-Version: 1.0
References: <CAMj1kXEEF_Un-4NTaD5iUN0NoZYaJQn-rPediX0S6oRiuVuW-A@mail.gmail.com>
 <20201017144430.GI456889@lunn.ch> <CAMj1kXHsNrRSkZfSJ_VatES+V1obLcvfo=Qab_4jy58Znpjy6Q@mail.gmail.com>
 <20201017151132.GK456889@lunn.ch> <CAMj1kXH+Z56dkZz8OYMhPuqbjPPCqW=UMV6w--=XXh87UyHVaQ@mail.gmail.com>
 <20201017161435.GA1768480@apalos.home> <CAMj1kXHXYprdC19m1S5p_LQ2BOHtDCbyCWCJ0eJ5xPxFv8hgoA@mail.gmail.com>
 <20201017180453.GM456889@lunn.ch>
In-Reply-To: <20201017180453.GM456889@lunn.ch>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Sat, 17 Oct 2020 20:11:24 +0200
X-Gmail-Original-Message-ID: <CAMj1kXEcrULejk+h1Jv42W=r7odQ9Z_G0XDX_KrEnYYPEVgHkA@mail.gmail.com>
Message-ID: <CAMj1kXEcrULejk+h1Jv42W=r7odQ9Z_G0XDX_KrEnYYPEVgHkA@mail.gmail.com>
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

On Sat, 17 Oct 2020 at 20:04, Andrew Lunn <andrew@lunn.ch> wrote:
>
> > I have tried this, and it seems to fix the issue. I will send out a
> > patch against the netsec driver.
>
> Please also fix the firmware so it does not pass rgmii.
>
> If there are pure DT systems, which do require phy-mode to be used, we
> will need to revert your proposed change in order to make the MAC
> driver work as it should, rather than work around the broken firmware.
>

What do you mean by 'pure' DT system? Only EDK2 based firmware exists
for this platform, and it can be configured to boot either in DT or in
ACPI mode. In both cases, it will pass the same, incorrect PHY mode,
and in both cases, the firmware will already have configured the PHY
correctly.

So what I propose to do is drop the handling of the [mandatory]
phy-mode device property from the netsec driver (which is really only
used by this board). As we don't really need a phy-mode to begin with,
and given that firmware exists in the field that passes the wrong
value, the only option I see for passing a value here is to use a
different, *optional* DT property (force-phy-mode or
phy-mode-override) that takes the place of phy-mode. For ACPI boot,
you will just need to fix your firmware if you are using a different
PHY configuration.
