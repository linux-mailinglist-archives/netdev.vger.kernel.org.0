Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 163A080C2A
	for <lists+netdev@lfdr.de>; Sun,  4 Aug 2019 21:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbfHDTWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 15:22:14 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:38433 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726392AbfHDTWO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 15:22:14 -0400
Received: by mail-ed1-f67.google.com with SMTP id r12so41966962edo.5;
        Sun, 04 Aug 2019 12:22:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pj0ikRyiM2M9/CD5d5FXd58Pei1+6t41sEsA8s09Pcw=;
        b=gPsfzmbWFNebo/r/tjyKdRsMpRqU7/GEJfVm12iwmr3CNve3wsyxGbCCPz/l4auW7j
         JPHC/iGCWCazjhXUo/D9KqaSGNBR1FDgiuaMKXJ7csIm6LSP9oPszFw2+rn5MwDyTxes
         8RkOp2C3q/x1XIognnm732OGX1WYSZVsDKzM0Ct+yCeSh5C79g8D/sS5rphnKHMvFmkx
         LTZkHNeAr3L62qSi4W6sgffugyxMDLgSu1QnB4jR6VZsLDcA4i1j82xcpWm8Yswl5T6P
         khPBEn4QQNyuy+ZXFDUDoarTya3UGTurgdSA6k/salgjZ7FMA22rOKhSfc1U8YbQ90ib
         GvKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pj0ikRyiM2M9/CD5d5FXd58Pei1+6t41sEsA8s09Pcw=;
        b=QUXMb9W0Av9gKH/ASswsfJglmGG/vTWZPWuhsSg+Km5vyz/bj6F1e/kLC9c+JjvkBo
         95aiAT8D5wqv0WpjY7M/nmoFL1x5lkfRkUvMQ77mMw6TvQ38EI5y2ZoqFB8acTakTUUp
         7DHDlwJgUEBR9KmiX/7j3u+6K3YYKQDfC8c075DfHd7MgSxTh62MqcfdcLQAxKZlaHfv
         E3+6t+0PDBNfeDcvnE/H4u5Yv4K8W2vygiaeIDMHNU/unUzHnPSYObjtk9THbdirvVNB
         6id684Gk3l7+kATYxUVzeZIfJzrla78J9G+KjDzBfQ5leOy/d2X+KNggQrjFXV23GB9m
         qPQQ==
X-Gm-Message-State: APjAAAUSCJRZ5FG50CzcEDTUQFE2pO8ArFOUB9TMiREJmUzstxbdgjnk
        s8qnCMOzE/kkLEo6GvdKJw5OEKj63ZleecvQHSM=
X-Google-Smtp-Source: APXvYqySJFhDQZLNHXF8JQtrbX7ltOk9v6vkJxguWkKjYjXZq6sNO150ER/Wv1dGCfkPRz29WtcXiXs6SnoLaT60K5s=
X-Received: by 2002:a17:906:19d3:: with SMTP id h19mr13839881ejd.300.1564946532348;
 Sun, 04 Aug 2019 12:22:12 -0700 (PDT)
MIME-Version: 1.0
References: <20190802215419.313512-1-taoren@fb.com> <CA+h21hrOEape89MTqCUyGFt=f6ba7Q-2KcOsN_Vw2Qv8iq86jw@mail.gmail.com>
 <53e18a01-3d08-3023-374f-2c712c4ee9ea@fb.com> <20190804145152.GA6800@lunn.ch>
 <CA+h21hrUDaSxKpsy9TuWqwgaxKYaoXHyhgS=xSoAcPwxXzvrHg@mail.gmail.com> <f8de2514-081a-0e6e-fbe2-bcafcd459646@gmail.com>
In-Reply-To: <f8de2514-081a-0e6e-fbe2-bcafcd459646@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sun, 4 Aug 2019 22:22:01 +0300
Message-ID: <CA+h21hov3WzqYSUcxOnH0DOMO2dYdh_Q30Q_GQJpxa4nFM7MsQ@mail.gmail.com>
Subject: Re: [PATCH net-next v3] net: phy: broadcom: add 1000Base-X support
 for BCM54616S
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Tao Ren <taoren@fb.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Arun Parameswaran <arun.parameswaran@broadcom.com>,
        Justin Chen <justinpopo6@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 4 Aug 2019 at 19:07, Heiner Kallweit <hkallweit1@gmail.com> wrote:
>
> On 04.08.2019 17:59, Vladimir Oltean wrote:
> > On Sun, 4 Aug 2019 at 17:52, Andrew Lunn <andrew@lunn.ch> wrote:
> >>
> >>>> The patchset looks better now. But is it ok, I wonder, to keep
> >>>> PHY_BCM_FLAGS_MODE_1000BX in phydev->dev_flags, considering that
> >>>> phy_attach_direct is overwriting it?
> >>>
> >>
> >>> I checked ftgmac100 driver (used on my machine) and it calls
> >>> phy_connect_direct which passes phydev->dev_flags when calling
> >>> phy_attach_direct: that explains why the flag is not cleared in my
> >>> case.
> >>
> >> Yes, that is the way it is intended to be used. The MAC driver can
> >> pass flags to the PHY. It is a fragile API, since the MAC needs to
> >> know what PHY is being used, since the flags are driver specific.
> >>
> >> One option would be to modify the assignment in phy_attach_direct() to
> >> OR in the flags passed to it with flags which are already in
> >> phydev->dev_flags.
> >>
> >>         Andrew
> >
> > Even if that were the case (patching phy_attach_direct to apply a
> > logical-or to dev_flags), it sounds fishy to me that the genphy code
> > is unable to determine that this PHY is running in 1000Base-X mode.
> >
> > In my opinion it all boils down to this warning:
> >
> > "PHY advertising (0,00000200,000062c0) more modes than genphy
> > supports, some modes not advertised".
> >
> The genphy code deals with Clause 22 + Gigabit BaseT only.
> Question is whether you want aneg at all in 1000Base-X mode and
> what you want the config_aneg callback to do.
> There may be some inspiration in the Marvel PHY drivers.
>

AN for 1000Base-X still gives you duplex and pause frame settings. I
thought the base page format for exchanging that info is standardized
in clause 37.
Does genphy cover only copper media by design, or is it desirable to
augment genphy_read_status?

> > You see, the 0x200 in the above advertising mask corresponds exactly
> > to this definition from ethtool.h:
> >     ETHTOOL_LINK_MODE_1000baseX_Full_BIT    = 41,
> >
> > But it gets truncated and hence lost.
> >
> > Regards,
> > -Vladimir
> >
> Heiner
