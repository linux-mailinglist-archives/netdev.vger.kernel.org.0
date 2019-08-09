Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE46B8783A
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 13:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406349AbfHILJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 07:09:16 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:44924 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727063AbfHILJQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 07:09:16 -0400
Received: by mail-ed1-f68.google.com with SMTP id k8so94539029edr.11;
        Fri, 09 Aug 2019 04:09:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5PC18GBlTDNbjiv1Dgese6hBxfN55ahXT6uAwoWW/Dw=;
        b=BCDWU66fS5xO1T/pFmAB/FqIVpTiPoWRpF2B6ZCpBTb6oYk4k5PL5KaHu08VYJkA9z
         /Qx82QDRi58M5fwbqys6ifwRXfjWseTjJYrrXmtQo4LncxyX8WITejRU1NxT/V7SXM4o
         jm8ywCGf1R0rn2Z4D5A49k+kkMVNc8xjfn6umj9W/plQfI4QWYdoJ8sgYnLwh6QmUyH7
         EF3f6wjr7hA1XAHRJKNnuTxVW7LHbxpj+4XdzzfjNpF/HHvlR2UszScyrQ1BWnFs//+e
         WRm9Jv6EmePFO20gAZ4rjIiUkWwd4s6QrtmxjZjh7+lc/A1zZpLDcMv2fYeAg8nHRg7/
         DM2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5PC18GBlTDNbjiv1Dgese6hBxfN55ahXT6uAwoWW/Dw=;
        b=SIYxxx8cvoMfP9dt8zEL2xSWc3pfHuxIbL7aqcDeqANcghnHb4VeMz+eTTQeLUm0k3
         GO5MMcS6dio8ulaDUiBpZHQK3Ro+oM+2ldmDPbHEB1LaOZoc5GSZpiCjdUX8YJTZM+tW
         FryQTSkyn8f8l2Dc0Fko2uykYUK0PuVxtWGIjuIZgRMAJPaqRSGNwRNGrTpeJh087XnM
         EQNwLP0wGpEK1S94mpxqfclIL4FA4p9bbmmZ3nNbZBAWOVjJLCRdewQ31dfP2uu96DNi
         u3lVzahkL7KIHJSHfkU5uj1XiltuN1fF8mMBhThIoIhG01AIyI6OsoxfVXNTDcko2ZQ+
         7FlQ==
X-Gm-Message-State: APjAAAW7nrdva5XiKmDLGXvl5NjuKXodGXQbq3YktIAQCy0tVUaW6xN2
        Rv2egZTD52QkgUsACefeUUVM6rRCTeHUyQ8Kbdk=
X-Google-Smtp-Source: APXvYqx3KC3U3PMHmPzEGRlwh1/OayXq2z4tGQAH8H4jaGGY1TEg7oUii/6DD027cmZATRVXDPZrL8Z3HOH1a9aWjfk=
X-Received: by 2002:a17:907:2069:: with SMTP id qp9mr6955088ejb.90.1565348954110;
 Fri, 09 Aug 2019 04:09:14 -0700 (PDT)
MIME-Version: 1.0
References: <20190809005754.23009-1-git@andred.net> <CA+h21hp-K0ryB39O4X9n-mCwapiXoWy5WP6ZsvswgcDy-WBYVw@mail.gmail.com>
 <14396bfacec0c4877cb0ea9009dc92b33c169cac.camel@andred.net>
In-Reply-To: <14396bfacec0c4877cb0ea9009dc92b33c169cac.camel@andred.net>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 9 Aug 2019 14:09:02 +0300
Message-ID: <CA+h21hq69YyG3zcs2dzKJBNv-UwDPZ3ARQF9Y++9sLsvf472rg@mail.gmail.com>
Subject: Re: [PATCH] net: phy: at803x: stop switching phy delay config needlessly
To:     =?UTF-8?Q?Andr=C3=A9_Draszik?= <git@andred.net>
Cc:     lkml <linux-kernel@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andre,

On Fri, 9 Aug 2019 at 13:00, Andr=C3=A9 Draszik <git@andred.net> wrote:
>
> Hi Vladimir,
>
> On Fri, 2019-08-09 at 12:43 +0300, Vladimir Oltean wrote:
> > Hi Andre,
> >
> > On Fri, 9 Aug 2019 at 03:58, Andr=C3=A9 Draszik <git@andred.net> wrote:
> > > This driver does a funny dance disabling and re-enabling
> > > RX and/or TX delays. In any of the RGMII-ID modes, it first
> > > disables the delays, just to re-enable them again right
> > > away. This looks like a needless exercise.
> > >
> > > Just enable the respective delays when in any of the
> > > relevant 'id' modes, and disable them otherwise.
> > >
> > > Also, remove comments which don't add anything that can't be
> > > seen by looking at the code.
> > >
> > > Signed-off-by: Andr=C3=A9 Draszik <git@andred.net>
> > > CC: Andrew Lunn <andrew@lunn.ch>
> > > CC: Florian Fainelli <f.fainelli@gmail.com>
> > > CC: Heiner Kallweit <hkallweit1@gmail.com>
> > > CC: "David S. Miller" <davem@davemloft.net>
> > > CC: netdev@vger.kernel.org
> > > ---
> >
> > Is there any particular problem you're facing? Does this make any diffe=
rence?
>
> This is a clean-up, reducing the number of lines and if statements
> by removing unnecessary code paths and comments.
>

Ok. Did checkpatch not complain about the braces which you left open
around a single line?

>
> Cheers,
> Andre'
>
>
> >
> > >  drivers/net/phy/at803x.c | 26 ++++++--------------------
> > >  1 file changed, 6 insertions(+), 20 deletions(-)
> > >
> > > diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
> > > index 222ccd9ecfce..2ab51f552e92 100644
> > > --- a/drivers/net/phy/at803x.c
> > > +++ b/drivers/net/phy/at803x.c
> > > @@ -257,35 +257,21 @@ static int at803x_config_init(struct phy_device=
 *phydev)
> > >          *   after HW reset: RX delay enabled and TX delay disabled
> > >          *   after SW reset: RX delay enabled, while TX delay retains=
 the
> > >          *   value before reset.
> > > -        *
> > > -        * So let's first disable the RX and TX delays in PHY and ena=
ble
> > > -        * them based on the mode selected (this also takes care of R=
GMII
> > > -        * mode where we expect delays to be disabled)
> > >          */
> > > -
> > > -       ret =3D at803x_disable_rx_delay(phydev);
> > > -       if (ret < 0)
> > > -               return ret;
> > > -       ret =3D at803x_disable_tx_delay(phydev);
> > > -       if (ret < 0)
> > > -               return ret;
> > > -
> > >         if (phydev->interface =3D=3D PHY_INTERFACE_MODE_RGMII_ID ||
> > >             phydev->interface =3D=3D PHY_INTERFACE_MODE_RGMII_RXID) {
> > > -               /* If RGMII_ID or RGMII_RXID are specified enable RX =
delay,
> > > -                * otherwise keep it disabled
> > > -                */
> > >                 ret =3D at803x_enable_rx_delay(phydev);
> > > -               if (ret < 0)
> > > -                       return ret;
> > > +       } else {
> > > +               ret =3D at803x_disable_rx_delay(phydev);
> > >         }
> > > +       if (ret < 0)
> > > +               return ret;
> > >
> > >         if (phydev->interface =3D=3D PHY_INTERFACE_MODE_RGMII_ID ||
> > >             phydev->interface =3D=3D PHY_INTERFACE_MODE_RGMII_TXID) {
> > > -               /* If RGMII_ID or RGMII_TXID are specified enable TX =
delay,
> > > -                * otherwise keep it disabled
> > > -                */
> > >                 ret =3D at803x_enable_tx_delay(phydev);
> > > +       } else {
> > > +               ret =3D at803x_disable_tx_delay(phydev);
> > >         }
> > >
> > >         return ret;
> > > --
> > > 2.20.1
> > >
> >
> > Regards,
> > -Vladimir
>

Thanks,
-Vladimir
