Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8936C48E0FB
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 00:34:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238236AbiAMXeO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 18:34:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238218AbiAMXeO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 18:34:14 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A63F7C06161C;
        Thu, 13 Jan 2022 15:34:13 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id l25so12809738wrb.13;
        Thu, 13 Jan 2022 15:34:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MdTpEP43Y6K41askxgi7sRoWBbsxkKMukf1PIOUZT3U=;
        b=a4Qdy+XaoF3+AigjiLuYeTJOsGhiw4i+U7AZFfForsDmOhLAC0o1PGkTvSo970sK5R
         jku2D7GHb7hxWjwNd2YWeZda8HnqYMRN7+Rl3v5pnlbezrqJ4qF0BIfjfHJpR5yTuK8V
         JGqi/tYbILJOZZY2VauHThPKn2HOfaB/jj1LR1biThGozVzfOZFQAIkfZb/fJHb/KEYn
         JnB/cUVlhbRuO4Jfp9MG0NfwJWIkS3Vwm9buIRlmh4oVnaRj121F+/JOoudFVb0eLoYe
         KW/7y9xsmCVNLuGsDB+/AJBN0V6hXp3+U8Fk/nTTE1E2cEdYRUKpvLMf01WU74vE+f9v
         EyNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MdTpEP43Y6K41askxgi7sRoWBbsxkKMukf1PIOUZT3U=;
        b=jiNulxQ3otEC7/IfjlApW17pUKsw1Dkp9eCHLuwh+vUocWp3tknTwPGVzDxOKRtgCj
         NGXlh6vB5wuYzX0zhUjXskAfGnLXebBO9/1H8xZkknbID8W4tatjXwWDk80aISvP/S4c
         cm6JGglSAo6pcFE2owRj72RrcObNvdyLAt1N00kixuKsVN1CfjacaIJD7/uFY8ve1Gt5
         yo/QiJpe8mVjW6TQZ9PNg+0PNPHaHEecMgwDxEMpainUli9H8DPSVKc33PuaTN5yopL3
         X/klG/hLSA4Aidk4oWeXrBWDrmS+HLbj3WY9h/JOrTjaH590eJoV/rTLCMXnRGPr8NDH
         hZaw==
X-Gm-Message-State: AOAM533OQKRLRs9LVSyVfuvUSoNTTyQVwZYWtnQvYJZ9VbikKUxawH3c
        h1JswabAapa4HqW0/sbWL/ttj5YC5k3Io4zRJvY=
X-Google-Smtp-Source: ABdhPJw8+dgEmX4xc6Cx/lzXsv4oB9Lhqlni9WSZRAJ1RSqPyP6yYXdw6X1Q9XFrJqQWjviaJwT/57y4aLxjAV4WM7o=
X-Received: by 2002:a05:6000:105:: with SMTP id o5mr260063wrx.56.1642116852264;
 Thu, 13 Jan 2022 15:34:12 -0800 (PST)
MIME-Version: 1.0
References: <20220112173312.764660-1-miquel.raynal@bootlin.com>
 <20220112173312.764660-9-miquel.raynal@bootlin.com> <CAB_54W5QU5JCtQYwvTKREd6ZeQWmC19LF4mj853U0Gz-mCObVQ@mail.gmail.com>
 <20220113121645.434a6ef6@xps13>
In-Reply-To: <20220113121645.434a6ef6@xps13>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Thu, 13 Jan 2022 18:34:00 -0500
Message-ID: <CAB_54W5_x88zVgSJep=yK5WVjPvcWMy8dmyOJWcjy=5o0jCy0w@mail.gmail.com>
Subject: Re: [wpan-next v2 08/27] net: ieee802154: Drop symbol duration
 settings when the core does it already
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Harry Morris <h.morris@cascoda.com>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "linux-wireless@vger.kernel.org Wireless" 
        <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, 13 Jan 2022 at 06:16, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Hi Alexander,
>
> alex.aring@gmail.com wrote on Wed, 12 Jan 2022 17:26:14 -0500:
>
> > Hi,
> >
> > On Wed, 12 Jan 2022 at 12:33, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > >
> > > The core now knows how to set the symbol duration in a few cases, when
> > > drivers correctly advertise the protocols used on each channel. For
> > > these drivers, there is no more need to bother with symbol duration, so
> > > just drop the duplicated code.
> > >
> > > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > > ---
> > >  drivers/net/ieee802154/ca8210.c | 1 -
> > >  drivers/net/ieee802154/mcr20a.c | 2 --
> > >  2 files changed, 3 deletions(-)
> > >
> > > diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
> > > index 82b2a173bdbd..d3a9e4fe05f4 100644
> > > --- a/drivers/net/ieee802154/ca8210.c
> > > +++ b/drivers/net/ieee802154/ca8210.c
> > > @@ -2977,7 +2977,6 @@ static void ca8210_hw_setup(struct ieee802154_hw *ca8210_hw)
> > >         ca8210_hw->phy->cca.mode = NL802154_CCA_ENERGY_CARRIER;
> > >         ca8210_hw->phy->cca.opt = NL802154_CCA_OPT_ENERGY_CARRIER_AND;
> > >         ca8210_hw->phy->cca_ed_level = -9800;
> > > -       ca8210_hw->phy->symbol_duration = 16 * 1000;
> > >         ca8210_hw->phy->lifs_period = 40;
> > >         ca8210_hw->phy->sifs_period = 12;
> > >         ca8210_hw->flags =
> > > diff --git a/drivers/net/ieee802154/mcr20a.c b/drivers/net/ieee802154/mcr20a.c
> > > index 8aa87e9bf92e..da2ab19cb5ee 100644
> > > --- a/drivers/net/ieee802154/mcr20a.c
> > > +++ b/drivers/net/ieee802154/mcr20a.c
> > > @@ -975,7 +975,6 @@ static void mcr20a_hw_setup(struct mcr20a_local *lp)
> > >
> > >         dev_dbg(printdev(lp), "%s\n", __func__);
> > >
> > > -       phy->symbol_duration = 16 * 1000;
> > >         phy->lifs_period = 40;
> > >         phy->sifs_period = 12;
> > >
> > > @@ -1010,7 +1009,6 @@ static void mcr20a_hw_setup(struct mcr20a_local *lp)
> > >         phy->current_page = 0;
> > >         /* MCR20A default reset value */
> > >         phy->current_channel = 20;
> > > -       phy->symbol_duration = 16 * 1000;
> > >         phy->supported.tx_powers = mcr20a_powers;
> > >         phy->supported.tx_powers_size = ARRAY_SIZE(mcr20a_powers);
> > >         phy->cca_ed_level = phy->supported.cca_ed_levels[75];
> >
> > What's about the atrf86230 driver?
>
> I couldn't find reliable information about what this meant:
>
>         /* SUB:0 and BPSK:0 -> BPSK-20 */
>         /* SUB:1 and BPSK:0 -> BPSK-40 */
>         /* SUB:0 and BPSK:1 -> OQPSK-100/200/400 */
>         /* SUB:1 and BPSK:1 -> OQPSK-250/500/1000 */
>
> None of these comments match the spec so I don't know what to put
> there. If you know what these protocols are, I will immediately
> provide this information into the driver and ensure the core handles
> these durations properly before dropping the symbol_durations settings
> from the code.

I think those are from the transceiver datasheets (which are free to
access). Can you not simply merge them or is there a conflict?

- Alex
