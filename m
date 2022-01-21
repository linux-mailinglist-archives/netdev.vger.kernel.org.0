Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73610496070
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 15:06:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350897AbiAUOGh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 09:06:37 -0500
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:45384
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1350698AbiAUOGh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 09:06:37 -0500
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com [209.85.210.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 01F833F1C9
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 14:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1642773996;
        bh=gsucdAdnAt+qawYVmHjSJKScVDH3+ziXYTq9TSgSLmM=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=PYAY3aK2mCn1IH/TnVYVVQTss3g5A+ZiZeFJXlevCpd1AnlgAmEIOpZq2N1AElOGC
         clhkgPiRxKszsAs5jVnvjWjOdY9IUb8EnDePU1bP+BBEBBbQ7kbrXX5tXMONAQWnSo
         1Tx6WUS0FtQcCdI70q3aSDTDfdt3FmUO3vIpaCrAhAHKIt/WngkkCN0hRooNGMk9eU
         CFAFk2nuelUDnBimLbrvaBbNIDMiCvymNDfAlk1odSNUHdJW/wZcNWPpuFq3KTG1Nx
         cQjsBQpWxe7DW7CsEYz94JBTI6sKWxA8K+wg8cG3aI27bxi1N0X7YTHSz23oiRsUPy
         I/j5Qd78DjBwQ==
Received: by mail-ot1-f69.google.com with SMTP id h11-20020a056830400b00b00591920a8f96so5558172ots.1
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 06:06:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gsucdAdnAt+qawYVmHjSJKScVDH3+ziXYTq9TSgSLmM=;
        b=wbsZcb8CVtcroZvijnnFaayFegIph1bp4z4vECIdwRViEz9oaUjrlVShqlrd9kUPwn
         te08DjBLdtNPuGnJ3kRoQTJaKEKQ1urTblF3KKGuGF5aQEc9gEuGcNwqz2jz/TBAE8lr
         hBJhHGVeWVa0OIZlomXT+qWGeEwfWYCHi+yTQ5xpYY803mJcTF8fT+UyPc8uPIieZugN
         EfHZV7IZLVt++QPI8MNW3jXdUXwiTrW9DuOj83q5P97p56RwY4izHylRgl0L/OpksWEZ
         mpEpSSl1s1n/bwZchPwB0a+HmvETuMrZGFVdjqssC0AaeZJtwYIhdGTqrH12W0zT+V4i
         q8WA==
X-Gm-Message-State: AOAM531AHa625343hP2XEBrVdvEoVkHUsyLilRwrVFGopjDQpAF6Ws3Q
        YPnyxlePgD4stKRO79RaqX5mQl2iyh2FfzWEuqbSydDp4jce98AIZnR2Igr1XYa1csgeOgn7nAu
        Xn2soFeqvHD1zoea3+8L3bUr5ZPtKZibIr1jbjfuLSAWkgQtFig==
X-Received: by 2002:a9d:6f0e:: with SMTP id n14mr2830876otq.269.1642773994841;
        Fri, 21 Jan 2022 06:06:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwLe0uxL6DXDEfmDU3PioZe0YlmQrLFaefnz3Q3nSyxYua4m/q2j6GAlzunza6qJecQbF/lsG/IDcxqHEKkJHg=
X-Received: by 2002:a9d:6f0e:: with SMTP id n14mr2830853otq.269.1642773994615;
 Fri, 21 Jan 2022 06:06:34 -0800 (PST)
MIME-Version: 1.0
References: <20220120051929.1625791-1-kai.heng.feng@canonical.com>
 <Yelnzrrd0a4Bl5AL@lunn.ch> <CAAd53p45BbLy0T8AG5QTKhP00zMBsMHfm7i-bTmZmQWM5DpLnQ@mail.gmail.com>
 <YeqwyeVvFQoH+9Uu@lunn.ch>
In-Reply-To: <YeqwyeVvFQoH+9Uu@lunn.ch>
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
Date:   Fri, 21 Jan 2022 22:06:23 +0800
Message-ID: <CAAd53p6C5SsYwKt4xsJ+qiqhrF45UW_VG8O+EiJcgeWy=MqzPw@mail.gmail.com>
Subject: Re: [PATCH v2] net: phy: marvell: Honor phy LED set by system
 firmware on a Dell hardware
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 21, 2022 at 9:10 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > > > -static void marvell_config_led(struct phy_device *phydev)
> > > > +static int marvell_find_led_config(struct phy_device *phydev)
> > > >  {
> > > > -     u16 def_config;
> > > > -     int err;
> > > > +     int def_config;
> > > > +
> > > > +     if (phydev->dev_flags & PHY_USE_FIRMWARE_LED) {
> > > > +             def_config = phy_read_paged(phydev, MII_MARVELL_LED_PAGE, MII_PHY_LED_CTRL);
> > > > +             return def_config < 0 ? -1 : def_config;
> > >
> > > What about the other two registers which configure the LEDs?
> >
> > Do you mean the other two LEDs? They are not used on this machine.
>
> Have you read the datasheet for the PHY? It has three registers for
> configuring the LEDs. There is one register which controls the blink
> mode, a register which controls polarity, and a third register which
> controls how long each blink lasts, and interrupts. If you are going
> to save the configuration over suspend/resume you probably need to
> save all three.

OK, will change it in next iteration.

>
> This last register is also important for WoL, which is why i asked
> about it.

The Marvell PHY on the system doesn't support WoL.

Kai-Heng

>
>       Andrew
