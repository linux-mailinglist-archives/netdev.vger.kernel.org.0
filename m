Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDC1A48AEBA
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 14:44:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240852AbiAKNoE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 08:44:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240639AbiAKNoE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 08:44:04 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E33A1C06173F;
        Tue, 11 Jan 2022 05:44:03 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id w26so5191076wmi.0;
        Tue, 11 Jan 2022 05:44:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q/1TZTVcMCm0Q08vmDEx0MNqXROMr3/462DjqdnKRfk=;
        b=gBWQgbbuaeUjs2d1kfbB/QbJpLEMbAqkEJiEVFRzII4OWyBQy+MRYbeYqAppx/cqFY
         B9UzJs7nay4+s2dh7ZpVX7aF5P0/YSBRzAzqIRToq7IJLSArQUdJBMeeDhCPP+gPt4Tk
         itXeN76MRYZ6yw6OqFAeMVvk1kjNVRrwbVoP8lKD1L4tZTDeDTYdC7yIXKKgwhQzrOiw
         oTghcMI4E1Xx8PwFtJpe6iEQYwAkHP+eyDgb067StXSBBbjG2gduz5zpd8n4G3eNN+LH
         RL3JIVKpds5DI8Aq5UF6JPu0CtpHDO1UWBNOzeiJ8ql5D7liGcNgD4pAbOjtXmpJVWXZ
         mMbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q/1TZTVcMCm0Q08vmDEx0MNqXROMr3/462DjqdnKRfk=;
        b=OIfMT0fG5wYbzbmXIKODQ+EM89S6pl76q/J+otRQjoeVKcqCDobcs0sBPiTQfjLxw3
         uA/C83cHhd0Sdt7i5E067NXH+6tjCXs3vATSvnaIj6bVHD+Ux62NqTFLdgSGrlPWFCZW
         2yDtSLlULO5+rYz2Np9pTo7MDEr3qGQWGlt0l5iZD6uNri4OvhIuRO8CciLd9b727Q07
         FvrzZHkGFKfaLOT4plW0qa1wBRrbn6RW0HqFziPQ7z+cbTnGXikVxuzn1GsVOzdM5kL2
         qakMpgv+0CHwzohSGPDHRXxykiRHUt3uUxQSsXaqFgC22Ejp3b5AIcgx5GzJzpKB3yIL
         IH7g==
X-Gm-Message-State: AOAM5330/RzcTMhW2EUm1RXm54RuJnC/yecpMkzAXPuSyEeqX9eayzQa
        EcBZIzITRCKBrml23BR5ToG4KH3bbx3nAP4p+Mk=
X-Google-Smtp-Source: ABdhPJzv3sMf2ph7oP+5F3yymz/JZkN8z4oHszysdVs2BKRlhnswFYjmvulwtSDlrMYsQR2+rBHoHGsL3lHVkOT129w=
X-Received: by 2002:a1c:545b:: with SMTP id p27mr2536690wmi.178.1641908642447;
 Tue, 11 Jan 2022 05:44:02 -0800 (PST)
MIME-Version: 1.0
References: <20211222155743.256280-1-miquel.raynal@bootlin.com>
 <20211222155743.256280-18-miquel.raynal@bootlin.com> <CAB_54W7o5b7a-2Gg5ZnzPj3o4Yw9FOAxJfykrA=LtpVf9naAng@mail.gmail.com>
 <SN6PR08MB4464D7124FCB5D0801D26B94E0459@SN6PR08MB4464.namprd08.prod.outlook.com>
 <CAB_54W6ikdGe=ZYqOsMgBdb9KBtfAphkBeu4LLp6S4R47ZDHgA@mail.gmail.com>
 <20220105094849.0c7e9b65@xps13> <CAB_54W4Z1KgT+Cx0SXptvkwYK76wDOFTueFUFF4e7G_ABP7kkA@mail.gmail.com>
 <20220106201526.7e513f2f@xps13> <CAB_54W7=YJu7qJPcGX0O6nkBhmg7EmX2iTy+Q+EgffqE5+0NCQ@mail.gmail.com>
 <20220107084029.21f341a4@xps13>
In-Reply-To: <20220107084029.21f341a4@xps13>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Tue, 11 Jan 2022 08:43:51 -0500
Message-ID: <CAB_54W7kL6XnZxVXKudWXqMa=HVm=dk5ydAy6Ec4iMoU9mCNKA@mail.gmail.com>
Subject: Re: [net-next 17/18] net: mac802154: Let drivers provide their own
 beacons implementation
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     David Girault <David.Girault@qorvo.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        Romuald Despres <Romuald.Despres@qorvo.com>,
        Frederic Blain <Frederic.Blain@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, 7 Jan 2022 at 02:40, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Hi Alexander,
>
> alex.aring@gmail.com wrote on Thu, 6 Jan 2022 23:21:45 -0500:
>
> > Hi,
> >
> > On Thu, 6 Jan 2022 at 14:15, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > >
> > > Hi Alexander,
> > >
> > > alex.aring@gmail.com wrote on Wed, 5 Jan 2022 19:23:04 -0500:
> > >
> > ...
> > > >
> > > > A HardMAC driver does not use this driver interface... but there
> > > > exists a SoftMAC driver for a HardMAC transceiver. This driver
> > > > currently works because we use dataframes only... It will not support
> > > > scanning currently and somehow we should make iit not available for
> > > > drivers like that and for drivers which don't set symbol duration.
> > > > They need to be fixed.
> > >
> > > My bad. I did not look at it correctly. I made a mistake when talking
> > > about a hardMAC.
> > >
> > > Instead, it is a "custom" low level MAC layer. I believe we can compare
> > > the current mac802154 layer mostly to the MLME that is mentioned in the
> > > spec. Well here the additional layer that needs these hooks would be
> > > the MCPS. I don't know if this will be upstreamed or not, but the need
> > > for these hooks is real if such an intermediate low level MAC layer
> > > gets introduced.
> > >
> > > In v2 I will get rid of the two patches adding "driver access" to scans
> > > and beacons in order to facilitate the merge of the big part. Then we
> > > will have plenty of time to discuss how we can create such an interface.
> > > Perhaps I'll be able to propose more code as well to make use of these
> > > hooks, we will see.
> > >
> >
> > That the we have a standardised interface between Ieee802154 and
> > (HardMAC or SoftMAC(mac802154)) (see cfg802154_ops) which is defined
> > according the spec would make it more "stable" that it will work with
> > different HardMAC transceivers (which follows that interface) and
> > mac802154 stack (which also follows that interface). If I understood
> > you correctly.
>
>
> I am not sure. I am really talking about a softMAC. I am not sure
> where to put that layer "vertically" but according to the spec the MCPS
> (MAC Common Part Sublayer) is the layer that contains the data
> primitives, while MLME has been designed for management and
> configuration.
>

ok.

> > I think this is one reason why we are not having any HardMAC
> > transceivers driver supported in a proper way yet.
> >
> > I can also imagine about a hwsim HardMAC transceiver which redirects
> > cfg802154 to mac802154 SoftMAC instance again (something like that),
> > to have a virtual HardMAC transceiver for testing purpose, etc. In
> > theory that should work...
>
> Yeah I see what you mean, but IMHO that's basically duplicating the
> softMAC layer, we already have hwsim wired to cfg802154 through
> mac802154. In a certain way we could argue that this is a hardMAC =)

Would be good to show people "here is how to write a HardMAC
driver..." if this is even possible without any change yet.

- Alex
