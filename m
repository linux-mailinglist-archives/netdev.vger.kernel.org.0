Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1138649310D
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 23:54:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238099AbiARWxt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 17:53:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231467AbiARWxt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 17:53:49 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5365C061574;
        Tue, 18 Jan 2022 14:53:48 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id v123so1333898wme.2;
        Tue, 18 Jan 2022 14:53:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GMpAyQ1dS6joIUFWVHxfy6i3hq32WzmJmn2gggy0r9E=;
        b=Q/2YPqNlEXD0JGUE4naAPeyJkCwAhYxyhxdZxwUvjaCBhOcxpF5WmpYusaAToeeTTu
         ++miyIIqe4fp+LIpIeWnmcJUlBwcEewUZCsqwztXsdWfW+mCZguUzvQa3DRafJPU9n3D
         ioNc7dD43Dr9WspZcBRmZIfMxf1gy7USigT80twp2veoER4INED0pegr+/NlsbQhjbWK
         LeON8KeJC1m64vKx3IRatXMrMtXHmtFuiGF2UkG7p7WRaR4RiCdHktcwD0J5YPqPmeOf
         zCS7UgKvByVUjcBQ9IRD0HGkZLBCBNFf9oDmuX4KmUPkA0Gq1c7DXDR8RPaY514NY3+t
         qarg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GMpAyQ1dS6joIUFWVHxfy6i3hq32WzmJmn2gggy0r9E=;
        b=2ciThM5unFyEcOPTJVY5urECVcY6R+k2x7ZJRcfbV+SVJ2bq55svFQHgo1OgfXYVJN
         A4RqDNPh3wnONAkr8EGahz/poRAoSzgnoTM6+Q9alTbVS8IWV87yOtojAWRXpk5Ue8W9
         u3k3NKwo0U0P8EBgPVYX/G8Gg6O5KDKSMao+6CTaL8wyOZ6RmEM8JvA5zhXb4MXDs9SC
         NYGzQMXLTcDs2uJOTplUnP+XTCWVxKID2h3KrAPmVWJjua3DqSAdZnXvDbaXPSFMyE4N
         ywHA7drpNMkR/PbGWOXCSFvDbUFl3yPC3XMRfyNnrungo/S0f4MdWpAnwq3CVTSoSe63
         edQg==
X-Gm-Message-State: AOAM530AfwWH9b58tkrh2DqTDxYSArS5kYAdvuQpeUY4VjLXBB7ANLZG
        ocVe4tLeAXv6S52Q2gOvpjtTSsPlxRTA+d0/buk=
X-Google-Smtp-Source: ABdhPJz5yKxvT1Sw5hsgj/WHhTIRh1RICrWmevH1DYft7laXtumEzc4FFf/xLDwORyMUNZDPdbAjevhhgsQYBr1NK9g=
X-Received: by 2002:adf:d1c7:: with SMTP id b7mr20706241wrd.81.1642546427368;
 Tue, 18 Jan 2022 14:53:47 -0800 (PST)
MIME-Version: 1.0
References: <20220117115440.60296-1-miquel.raynal@bootlin.com>
 <20220117115440.60296-8-miquel.raynal@bootlin.com> <CAB_54W5_XoTk=DzMmm33csrEKe3m97KnNWnktRiyJsk7vfxO6w@mail.gmail.com>
 <20220118192013.46c42f82@xps13>
In-Reply-To: <20220118192013.46c42f82@xps13>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Tue, 18 Jan 2022 17:53:36 -0500
Message-ID: <CAB_54W4Je4-jCMFkqATfj2c2+5By2PSWOqCUudt1+sgimFKhHw@mail.gmail.com>
Subject: Re: [PATCH v3 07/41] net: ieee802154: mcr20a: Fix lifs/sifs periods
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org Wireless" 
        <linux-wireless@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, 18 Jan 2022 at 13:20, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Hi Alexander,
>
> alex.aring@gmail.com wrote on Mon, 17 Jan 2022 17:52:10 -0500:
>
> > Hi,
> >
> > On Mon, 17 Jan 2022 at 06:54, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > >
> > > These periods are expressed in time units (microseconds) while 40 and 12
> > > are the number of symbol durations these periods will last. We need to
> > > multiply them both with phy->symbol_duration in order to get these
> > > values in microseconds.
> > >
> > > Fixes: 8c6ad9cc5157 ("ieee802154: Add NXP MCR20A IEEE 802.15.4 transceiver driver")
> > > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > > ---
> > >  drivers/net/ieee802154/mcr20a.c | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/drivers/net/ieee802154/mcr20a.c b/drivers/net/ieee802154/mcr20a.c
> > > index f0eb2d3b1c4e..e2c249aef430 100644
> > > --- a/drivers/net/ieee802154/mcr20a.c
> > > +++ b/drivers/net/ieee802154/mcr20a.c
> > > @@ -976,8 +976,8 @@ static void mcr20a_hw_setup(struct mcr20a_local *lp)
> > >         dev_dbg(printdev(lp), "%s\n", __func__);
> > >
> > >         phy->symbol_duration = 16;
> > > -       phy->lifs_period = 40;
> > > -       phy->sifs_period = 12;
> > > +       phy->lifs_period = 40 * phy->symbol_duration;
> > > +       phy->sifs_period = 12 * phy->symbol_duration;
> >
> > I thought we do that now in register_hw(). Why does this patch exist?
>
> The lifs and sifs period are wrong.
>
> Fixing this silently by generalizing the calculation is simply wrong. I
> feel we need to do this in order:
> 1- Fix the period because it is wrong.
> 2- Now that the period is set to a valid value and the core is able to
>    do the same operation and set the variables to an identical content,
>    we can drop these lines from the driver.
>
> #2 being a mechanical change, doing it without #1 means that something
> that appears harmless actually changes the behavior of the driver. We
> generally try to avoid that, no?

yes, maybe Stefan can get this patch then somehow to wpan and queue it
for stable.

Thanks for clarification.

- Alex
