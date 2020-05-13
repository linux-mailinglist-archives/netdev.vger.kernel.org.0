Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD6A91D19FD
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 17:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730219AbgEMP4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 11:56:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728678AbgEMP4Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 11:56:16 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 269A1C061A0C
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 08:56:16 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id k6so18556527iob.3
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 08:56:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rQn+8pZqeeBsYLaYSdtMgaSKYLpReKEXrC5TSLa5UEo=;
        b=bWXbYloOSyV1kgoaQdIGjLPgJcErVmROudPOgGbQAHlLDhMpj6rgqe1bDoDZIjwO+N
         v1xtwJMm1DcmDc+xGDwqoONccJv4dszCE+cDIWqZh+P6wGyvRhLvNZEoplATjWjgg25c
         14IAz0Ql8DIqr4l25GP9+nDvz6wC//N5z1Nc4z3PxxrZyHX50eHF/zDDmR4SCbWUdkqP
         sd2yIRgLWW8pEHCa33eKPwWt2TZWYJA3SFz8fo5od62vcq3BrMFnFgDGVnLYJ/aFhlRi
         sRBP6AzX1trb5NmI669d7MInazpVLX1udgGTPRh6HA1/kdm3o5vABwBV/1TNmvB/O8N1
         q3bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rQn+8pZqeeBsYLaYSdtMgaSKYLpReKEXrC5TSLa5UEo=;
        b=h+Ay9Zd2wtdt7bSGS1jQysyjtbw1gDzOAVmU8jHN5eZ57WXny44r9y7sT7uRRkF8fE
         VUIWeuFPXKtHq67fAKFnu1AmIvX01XP1hw2gByIydoy8vc46hSgqmlUlfIeZkMIfJmCf
         zzZQQbCnKw3JXuQ9gg+dT+JVxlFiEfHSriU6VQZYrWwb9hjiuWuBrgD4PMkSl3dj4QQn
         E/vBfdRaCBVV6rlp8+XinjSgeugPMALsRCXATuPuVmSNklF6RfO8N+Jv0ogvLVjEK2a6
         feqohD7U+PkpH7x3IQFpA5N1drrK9PxRutpur0ETY2d77qok6KmlLV1sqKQABdSt2rW7
         5SNg==
X-Gm-Message-State: AGi0PuZLmvVQm0G9gofo/UZapYPrm+N1KpbdtBV1OiGT1MNJy6A2GFab
        6T6P1bgbqJTS9fQo06U6Lj62C50y58RGzPWl+xM=
X-Google-Smtp-Source: APiQypJ/qwblLRPq5LtXtXxXp/h1Bi1wVZTbaCxSxFRx2aTge/BKhBnqZI3YYDrPYZthrzhuKRwMhyL3Ftt55HydVi4=
X-Received: by 2002:a02:7fd8:: with SMTP id r207mr218174jac.7.1589385375422;
 Wed, 13 May 2020 08:56:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200513153717.15599-1-dqfext@gmail.com> <5d77da58-694a-7f9c-53fb-9d107e271d40@gmail.com>
In-Reply-To: <5d77da58-694a-7f9c-53fb-9d107e271d40@gmail.com>
From:   DENG Qingfang <dqfext@gmail.com>
Date:   Wed, 13 May 2020 23:56:03 +0800
Message-ID: <CALW65jbN-qvEgz01Shff59S77ArZtNVK7kq74XdyDjuvVSA-_g@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dsa: mt7530: set CPU port to fallback mode
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        Russell King <linux@armlinux.org.uk>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>,
        Tom James <tj17@me.com>,
        Stijn Segers <foss@volatilesystems.org>,
        riddlariddla@hotmail.com, Szabolcs Hubai <szab.hu@gmail.com>,
        Paul Fertser <fercerpav@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian

On Wed, May 13, 2020 at 11:46 PM Florian Fainelli <f.fainelli@gmail.com> wrote:
>
>
>
> On 5/13/2020 8:37 AM, DENG Qingfang wrote:
> > Currently, setting a bridge's self PVID to other value and deleting
> > the default VID 1 renders untagged ports of that VLAN unable to talk to
> > the CPU port:
> >
> >       bridge vlan add dev br0 vid 2 pvid untagged self
> >       bridge vlan del dev br0 vid 1 self
> >       bridge vlan add dev sw0p0 vid 2 pvid untagged
> >       bridge vlan del dev sw0p0 vid 1
> >       # br0 cannot send untagged frames out of sw0p0 anymore
> >
> > That is because the CPU port is set to security mode and its PVID is
> > still 1, and untagged frames are dropped due to VLAN member violation.
> >
> > Set the CPU port to fallback mode so untagged frames can pass through.
>
> How about if the bridge has vlan_filtering=1? The use case you present
> seems to be valid to me, that is, you may create a VLAN just for the
> user ports and not have the CPU port be part of it at all.

I forgot to mention that this is ONLY for vlan_filtering=1
`bridge vlan` simply won't do anything if VLAN filtering is disabled.

>
> >
> > Fixes: 83163f7dca56 ("net: dsa: mediatek: add VLAN support for MT7530")
> > Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> > ---
> >  drivers/net/dsa/mt7530.c | 11 ++++++++---
> >  drivers/net/dsa/mt7530.h |  6 ++++++
> >  2 files changed, 14 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> > index 5c444cd722bd..a063d914c23f 100644
> > --- a/drivers/net/dsa/mt7530.c
> > +++ b/drivers/net/dsa/mt7530.c
> > @@ -810,10 +810,15 @@ mt7530_port_set_vlan_aware(struct dsa_switch *ds, int port)
> >                  PCR_MATRIX_MASK, PCR_MATRIX(MT7530_ALL_MEMBERS));
> >
> >       /* Trapped into security mode allows packet forwarding through VLAN
> > -      * table lookup.
> > +      * table lookup. CPU port is set to fallback mode to let untagged
> > +      * frames pass through.
> >        */
> > -     mt7530_rmw(priv, MT7530_PCR_P(port), PCR_PORT_VLAN_MASK,
> > -                MT7530_PORT_SECURITY_MODE);
> > +     if (dsa_is_cpu_port(ds, port))
> > +             mt7530_rmw(priv, MT7530_PCR_P(port), PCR_PORT_VLAN_MASK,
> > +                        MT7530_PORT_FALLBACK_MODE);
> > +     else
> > +             mt7530_rmw(priv, MT7530_PCR_P(port), PCR_PORT_VLAN_MASK,
> > +                        MT7530_PORT_SECURITY_MODE);
> >
> >       /* Set the port as a user port which is to be able to recognize VID
> >        * from incoming packets before fetching entry within the VLAN table.
> > diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
> > index 979bb6374678..d45eb7540703 100644
> > --- a/drivers/net/dsa/mt7530.h
> > +++ b/drivers/net/dsa/mt7530.h
> > @@ -152,6 +152,12 @@ enum mt7530_port_mode {
> >       /* Port Matrix Mode: Frames are forwarded by the PCR_MATRIX members. */
> >       MT7530_PORT_MATRIX_MODE = PORT_VLAN(0),
> >
> > +     /* Fallback Mode: Forward received frames with ingress ports that do
> > +      * not belong to the VLAN member. Frames whose VID is not listed on
> > +      * the VLAN table are forwarded by the PCR_MATRIX members.
> > +      */
> > +     MT7530_PORT_FALLBACK_MODE = PORT_VLAN(1),
> > +
> >       /* Security Mode: Discard any frame due to ingress membership
> >        * violation or VID missed on the VLAN table.
> >        */
> >
>
> --
> Florian
