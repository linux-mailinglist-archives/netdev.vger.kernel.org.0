Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C78E388E51
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 14:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353451AbhESMqx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 08:46:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237386AbhESMqw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 08:46:52 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03740C06175F;
        Wed, 19 May 2021 05:45:33 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id g38so17845412ybi.12;
        Wed, 19 May 2021 05:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=jtt1n0eLEl1LiBWRCYz9qpVqUohhN38baHabydz3ycA=;
        b=NEnDsXCtA1Q9wuBI9XmJzViOobsr3kWfvewlt3fs1skzH1I2LWqW5vPgJNGukWOSnf
         Jsjz4pmKgAegaSN3iuTLyOQo4XpmEakW0Z/rMqgUYMkHRsOuivqr+xCdYUMA98KO8QMa
         uQudefXAZw03lyObXywpGpAbOxZXHO4/aldF9qCMQsPMKMHx0aDh3g3QwB+/GCDndUTD
         n7vIMexAqOffcxD9oSnFV5AGoDoBrjevwa4rTgYXR2UtCY2a2ue52/7wNYvoH6eHjhGS
         3FOWkdgQPJ9ZnH426Z39D2aunf5XAYK2CUrxiqVlqYbY3/RmWWlR1oEIZwLyYEVY7tV0
         vCzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=jtt1n0eLEl1LiBWRCYz9qpVqUohhN38baHabydz3ycA=;
        b=ewHoGOtfr5T9sx+7hRhvaI0vs2cuGz9DafKT1HVLgtwzOaWaD8i8tdz2dH8SqBPsxK
         Kh1e2DtQj5wKyFDVHpZGWpGnt1pqgXDU29wEWjR+O0bgHfjaTp566OgBqTjB5AUF+nF2
         9m/UUKddoLLEtyCvDSrnU9l89TDrx/CJUKChB8Osx7YJ4ZzcQNsD9/wOoS8P9dkCI0Pu
         IM2g6RUhBjhuZUPnDUsy28SVAekpVtvTpBWMn91x1YKe9040iVoSS/o/RHoTO2fWEmyK
         AeNi3O8yND27lPMejF1DRlCbBWyLCNML13MMuwcCLCYKyFvtF1UesZ0EiMynS+Ee/dmv
         UkfQ==
X-Gm-Message-State: AOAM530u2Yf1xjxPTMxRm7C7DNxiAIWCwJhLM/3SATzc5ToH7QDi8nYf
        iB8pPMBDEcyhSj+BAEBcsxFGQ4utAskrcCWWGNM=
X-Google-Smtp-Source: ABdhPJwMPTCVxlE6gNu2UuKI2B+TaQHhVUaLrY8DYMRGX/iv5HI7su7W5ZPqm8e85CihgSH4tsd9j1Y2SDbOIfNw+PM=
X-Received: by 2002:a25:1009:: with SMTP id 9mr14973539ybq.386.1621428332190;
 Wed, 19 May 2021 05:45:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210511214605.2937099-1-pgwipeout@gmail.com> <YKOB7y/9IptUvo4k@unreal>
 <CAMdYzYrV0T9H1soxSVpQv=jLCR9k9tuJddo1Kw-c3O5GJvg92A@mail.gmail.com>
 <YKTJwscaV1WaK98z@unreal> <cbfecaf2-2991-c79e-ba80-c805d119ac2f@gmail.com> <YKT7bLjzucl/QEo2@unreal>
In-Reply-To: <YKT7bLjzucl/QEo2@unreal>
From:   Peter Geis <pgwipeout@gmail.com>
Date:   Wed, 19 May 2021 08:45:21 -0400
Message-ID: <CAMdYzYpVYuNuYgZp-sNj4QFbgHH+SoFpffbdCNJST2_KZEhSug@mail.gmail.com>
Subject: Re: [PATCH] net: phy: add driver for Motorcomm yt8511 phy
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 19, 2021 at 7:50 AM Leon Romanovsky <leon@kernel.org> wrote:
>
> On Wed, May 19, 2021 at 12:37:43PM +0200, Heiner Kallweit wrote:
> > On 19.05.2021 10:18, Leon Romanovsky wrote:
> > > On Tue, May 18, 2021 at 08:20:03PM -0400, Peter Geis wrote:
> > >> On Tue, May 18, 2021 at 4:59 AM Leon Romanovsky <leon@kernel.org> wr=
ote:
> > >>>
> > >>> On Tue, May 11, 2021 at 05:46:06PM -0400, Peter Geis wrote:
> > >>>> Add a driver for the Motorcomm yt8511 phy that will be used in the
> > >>>> production Pine64 rk3566-quartz64 development board.
> > >>>> It supports gigabit transfer speeds, rgmii, and 125mhz clk output.
> > >>>>
> > >>>> Signed-off-by: Peter Geis <pgwipeout@gmail.com>
> > >>>> ---
> > >>>>  MAINTAINERS                 |  6 +++
> > >>>>  drivers/net/phy/Kconfig     |  6 +++
> > >>>>  drivers/net/phy/Makefile    |  1 +
> > >>>>  drivers/net/phy/motorcomm.c | 85 ++++++++++++++++++++++++++++++++=
+++++
> > >>>>  4 files changed, 98 insertions(+)
> > >>>>  create mode 100644 drivers/net/phy/motorcomm.c
> > >>>
> > >>> <...>
> > >>>
> > >>>> +static const struct mdio_device_id __maybe_unused motorcomm_tbl[]=
 =3D {
> > >>>> +     { PHY_ID_MATCH_EXACT(PHY_ID_YT8511) },
> > >>>> +     { /* sentinal */ }
> > >>>> +}
> > >>>
> > >>> Why is this "__maybe_unused"? This *.c file doesn't have any compil=
ation option
> > >>> to compile part of it.
> > >>>
> > >>> The "__maybe_unused" is not needed in this case.
> > >>
> > >> I was simply following convention, for example the realtek.c,
> > >> micrel.c, and smsc.c drivers all have this as well.
> > >
> > > Maybe they have a reason, but this specific driver doesn't have such.
> > >
> >
> > It's used like this:
> > MODULE_DEVICE_TABLE(mdio, <mdio_device_id_tbl>);
> >
> > And MODULE_DEVICE_TABLE is a no-op if MODULE isn't defined:
> >
> > #ifdef MODULE
> > /* Creates an alias so file2alias.c can find device table. */
> > #define MODULE_DEVICE_TABLE(type, name)                                =
       \
> > extern typeof(name) __mod_##type##__##name##_device_table             \
> >   __attribute__ ((unused, alias(__stringify(name))))
> > #else  /* !MODULE */
> > #define MODULE_DEVICE_TABLE(type, name)
> > #endif
> >
> > In this case the table is unused.
>
> Do you see compilation warning for such scenario?

The issue you are describing has been fixed since 2010:

commit cf93c94581bab447a5634c6d737c1cf38c080261
Author: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>
Date:   Sun Oct 3 23:43:32 2010 +0000

    net/phy: fix many "defined but unused" warnings

    MODULE_DEVICE_TABLE only expands to something if it's compiled
    for a module.  So when building-in support for the phys, the
    mdio_device_id tables are unused.  Marking them with __maybe_unused
    fixes the following warnings:

There is a strong push to fix all warnings during build, including W=3D1 wa=
rnings.
For fun I rebuilt without module support and confirmed that removing
this does trigger a W=3D1 warning.

>
> Thanks
>
> >
> > > Thanks
> > >
> > >>
> > >>>
> > >>> Thanks
> >
> >
