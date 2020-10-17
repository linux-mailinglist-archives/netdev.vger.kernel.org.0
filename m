Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34FA72914E8
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 00:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439783AbgJQWTh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 18:19:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:35878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439607AbgJQWTh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Oct 2020 18:19:37 -0400
Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9D8C208E4
        for <netdev@vger.kernel.org>; Sat, 17 Oct 2020 22:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602973176;
        bh=6ZbCRjM+xVodquQC+ShbslhmyoudSB7EMR+xqk/7iAY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=YdspOESzwmnRMmQswEFrxk1R3NHCcDBJP1tbmmXJ238yZaTvZyrE4NLE8QOBsqdd8
         BRP0pQoInaWP3SZirWvHygQUMBMYHIQ/INBR17pDPU2l/+ArCyWk7q2gg0jXgtN5/L
         0DRjnV8JIw/QCcD23O0bQLeCfT7OhqYIRXb6xU80=
Received: by mail-oi1-f179.google.com with SMTP id u17so7402950oie.3
        for <netdev@vger.kernel.org>; Sat, 17 Oct 2020 15:19:36 -0700 (PDT)
X-Gm-Message-State: AOAM533XfRwL0/UuAKImkPLmWqZzWo/G1qjHmMFKlv0OMqgGSfK0JWew
        IQVb+YDg4C/RGJ5i/zNDoA1LFDV6hqXN3EQAWA8=
X-Google-Smtp-Source: ABdhPJzzxOg3Lr63DqVjdzS5RwiU9Z4oqp4FWiKSuSrL/8+X7NWaTkW8G8a7omGgrnFMT+U9M1RkRhKcDcu8R081h1A=
X-Received: by 2002:aca:d64f:: with SMTP id n76mr7362917oig.174.1602973176039;
 Sat, 17 Oct 2020 15:19:36 -0700 (PDT)
MIME-Version: 1.0
References: <20201017144430.GI456889@lunn.ch> <CAMj1kXHsNrRSkZfSJ_VatES+V1obLcvfo=Qab_4jy58Znpjy6Q@mail.gmail.com>
 <20201017151132.GK456889@lunn.ch> <CAMj1kXH+Z56dkZz8OYMhPuqbjPPCqW=UMV6w--=XXh87UyHVaQ@mail.gmail.com>
 <20201017161435.GA1768480@apalos.home> <CAMj1kXHXYprdC19m1S5p_LQ2BOHtDCbyCWCJ0eJ5xPxFv8hgoA@mail.gmail.com>
 <20201017180453.GM456889@lunn.ch> <CAMj1kXEcrULejk+h1Jv42W=r7odQ9Z_G0XDX_KrEnYYPEVgHkA@mail.gmail.com>
 <20201017182738.GN456889@lunn.ch> <CAMj1kXHwYkd0L63K3+e_iwfoSYEUOmYdWf_cKv90_qVXSxEesg@mail.gmail.com>
 <20201017194904.GP456889@lunn.ch>
In-Reply-To: <20201017194904.GP456889@lunn.ch>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Sun, 18 Oct 2020 00:19:25 +0200
X-Gmail-Original-Message-ID: <CAMj1kXEY5jK7z+_ezDX733zbtHnaGUNCkJ_gHcPqAavOQPOzBQ@mail.gmail.com>
Message-ID: <CAMj1kXEY5jK7z+_ezDX733zbtHnaGUNCkJ_gHcPqAavOQPOzBQ@mail.gmail.com>
Subject: Re: realtek PHY commit bbc4d71d63549 causes regression
To:     Andrew Lunn <andrew@lunn.ch>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Sumit Garg <sumit.garg@linaro.org>,
        =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        Masami Hiramatsu <mhiramat@kernel.org>, steve@einval.com
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

(cc'ing some folks who may care about functional networking on SynQuacer)

On Sat, 17 Oct 2020 at 21:49, Andrew Lunn <andrew@lunn.ch> wrote:
>
> > So we can fix this firmware by just setting phy-mode to the empty
> > string, right?
>
> I've never actually tried it, but i think so. There are no DT files
> actually doing that, so you really do need to test it and see. And
> there might be some differences between device_get_phy_mode() and
> of_get_phy_mode().
>

Yes, that works fine. Fixed now in the latest firmware build [0]

But that still leaves the question whether and how to work around this
for units in the field. Ignoring the PHY mode in the driver would
help, as all known hardware ships with firmware that configures the
PHY with the correct settings, but we will lose the ability to use
other PHY modes in the future, in case the SoC is ever used with DT
based minimal firmware that does not configure networking.

Since ACPI implies rich firmware, we could make ACPI probing of the
driver ignore the phy-mode setting in the DSDT. But if we don't do the
same for DT, it would mean DT users are forced to upgrade their
firmware, and hopefully do so before upgrading to a kernel that breaks
networking. (These boxes are often used headless, so this can be
annoying)


[0] http://snapshots.linaro.org/components/kernel/leg-96boards-developerbox-edk2/83/
