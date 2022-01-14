Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74F9C48ED1A
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 16:25:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238390AbiANPZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 10:25:38 -0500
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:49666
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243496AbiANPZc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 10:25:32 -0500
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id E613A402A5
        for <netdev@vger.kernel.org>; Fri, 14 Jan 2022 15:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1642173930;
        bh=1r53LGbRrCdIDFkdFatBJl+cYRNX8emZDBqZeKrVhA0=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=WF6xMjWZ8ZBKCWeqPYriEsqqlXaD86sZgG2N67dKGDFAUgpOLSirTy0YOCFFbmsGZ
         Ym3Q5to0NGs+xPjASooHN3MYHYvtXa0TUJnigDJWd+4ckkLoeWupU0mPBWK7Q+hheD
         2s1EuGEdb5sl6DesBuhzRuqTy5xh3hJ3Q+Pk06PKk8Lt/BQrrOeqbtCZXm5n6bC13p
         3sqnkQowhifIsHslyWD88lOWScswL/QM9s56PRv58RGu+7zHYxcjaUv0j5QklluvqX
         YJeZMpNN5JW23A8PGNL4a+znkSfVE1qoOt1Fex5DxVyGa2NfW0e5jawDpIqwaTUBM8
         S6spDvXhC9rXw==
Received: by mail-oi1-f197.google.com with SMTP id s134-20020acaa98c000000b002c9a0ceb881so3103856oie.12
        for <netdev@vger.kernel.org>; Fri, 14 Jan 2022 07:25:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1r53LGbRrCdIDFkdFatBJl+cYRNX8emZDBqZeKrVhA0=;
        b=GykppAxnqHVGMP+YTfS2gPEHiWl0Cyc6PYOxsWSL7MoNI1oEPi1dvZ9jMYe8L7nyzo
         /ANK8nclfy4xXzKPcHdfLhPV2sLGhyfyLHvShybbE2Ko9N9HALtHlHYUWix7MIF64ZBN
         OXx+vZGdDa553FtRfgTqD5yLrEpbs0DjiIW2aYZtPPftCnD2IptVL+eYbSn/ZTVvK+KZ
         v5bL5fBSkyYgUNS4lntgtXJGZu905JR3VRDX9hxegahNVzVjn+I2BzT7dq2XnIr5H48r
         iU94i0LmZO/C/CoeiWE1ApRlj9zeaqnejA/UiTgCZqD8zjcqzJt22Kb5FyYhLGqnMYYi
         lTZQ==
X-Gm-Message-State: AOAM5326pU5BcHov+DpgQMc9a8ilQU+vbYKbFk5IWe29GHnLZuYjE1dB
        QYQ59NfhWlLaoz1epu4/xS4+uXk6n8asnLNzWz6/zO6t8Vv5yal/FHr0O8T3H/6xPiPo0m8lZgg
        4E0srDjk3DvbyNEwh2RMqV2p7WJ91tA+TwrMEIwMIb0qDNAVR+g==
X-Received: by 2002:a05:6808:199a:: with SMTP id bj26mr13097374oib.98.1642173929761;
        Fri, 14 Jan 2022 07:25:29 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwjc8OhFrl0+4UKcBWR0AvxTCF+lZaB9wkXprPPao3yjX3bM54hzP09Hoph4ybKCG+Gsz+cmAnQZkDe5pkkoW8=
X-Received: by 2002:a05:6808:199a:: with SMTP id bj26mr13097353oib.98.1642173929496;
 Fri, 14 Jan 2022 07:25:29 -0800 (PST)
MIME-Version: 1.0
References: <20220114040755.1314349-1-kai.heng.feng@canonical.com>
 <20220114040755.1314349-2-kai.heng.feng@canonical.com> <YeF4kbsqag+kZ7ji@lunn.ch>
In-Reply-To: <YeF4kbsqag+kZ7ji@lunn.ch>
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
Date:   Fri, 14 Jan 2022 23:25:17 +0800
Message-ID: <CAAd53p4P9STxTUsZ2fXNqOnmwLMfOBXpYR5hvcJHk5-0V7MPgA@mail.gmail.com>
Subject: Re: [PATCH 2/2] stmmac: intel: Honor phy LED set by system firmware
 on a Dell hardware
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        =?UTF-8?B?TWFyZWsgQmVow7pu?= <kabel@kernel.org>,
        Ivan Bornyakov <i.bornyakov@metrotek.ru>,
        =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 14, 2022 at 9:20 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> >  static void marvell_config_led(struct phy_device *phydev)
> >  {
> > -     u16 def_config;
> > +     struct marvell_priv *priv = phydev->priv;
> >       int err;
> >
> > -     switch (MARVELL_PHY_FAMILY_ID(phydev->phy_id)) {
> > -     /* Default PHY LED config: LED[0] .. Link, LED[1] .. Activity */
> > -     case MARVELL_PHY_FAMILY_ID(MARVELL_PHY_ID_88E1121R):
> > -     case MARVELL_PHY_FAMILY_ID(MARVELL_PHY_ID_88E1318S):
> > -             def_config = MII_88E1121_PHY_LED_DEF;
> > -             break;
> > -     /* Default PHY LED config:
> > -      * LED[0] .. 1000Mbps Link
> > -      * LED[1] .. 100Mbps Link
> > -      * LED[2] .. Blink, Activity
> > -      */
> > -     case MARVELL_PHY_FAMILY_ID(MARVELL_PHY_ID_88E1510):
> > -             if (phydev->dev_flags & MARVELL_PHY_LED0_LINK_LED1_ACTIVE)
> > -                     def_config = MII_88E1510_PHY_LED0_LINK_LED1_ACTIVE;
> > -             else
> > -                     def_config = MII_88E1510_PHY_LED_DEF;
> > -             break;
> > -     default:
> > +     if (priv->led_def_config == -1)
> >               return;
> > +
> > +     if (priv->led_def_config)
> > +             goto write;
>
> Really?
>
> Please restructure this code. Take it apart into helpers. You need:
>
> A function to set the actual LED configuration.
> A function to decide what, if any, configuration to set
> A function to store the current configuration on suspend.
> A function to restore the current configuration on resume.
>
> Lots of little functions will make it much easier to understand, and
> avoid 1980s BASIC style.

Sure, will turn these into helper functions.

>
> I'm also surprised you need to deal with suspend/resume. Why does the
> BIOS not set the LED mode on resume, same as it does on power up?

I was told this is a BIOS limitation. I'll ask vendor _why_ the LED
can't be restored by BIOS.

Kai-Heng

>
>       Andrew
