Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C19BA484B10
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 00:09:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236098AbiADXJA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 18:09:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235297AbiADXI7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 18:08:59 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 344E1C061761;
        Tue,  4 Jan 2022 15:08:59 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id p1-20020a1c7401000000b00345c2d068bdso638942wmc.3;
        Tue, 04 Jan 2022 15:08:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kh8Gfm9+uyUN7wr5xX2KRQaXD7QaZKY7AK/XNvHYC3E=;
        b=hZ6NJRccRCpO4CMIa3yzlhVLl0z63iFcwmvcFPbrifR+2TEYupPRZAk64v5tnDsGSg
         hW1d8cse0R1802dRcEN4zjv93j+qP908LXcxlkfRpFTcVXwJ7Qxk3sGAxO/6ZikuMmf7
         h5uLtH7IGByBpsPCm1QWSdxeTqwZJKlHQBQ6P3I70jHBTq3GnQbpqpCLzWF6PHv+x34w
         zaUQBDs4uCx4ki2JvNBQCFabiTaPpmEN3023spR7Emf2SaigCnqdGJog6InJsOrhCbLP
         TvT0wCgzn8Narm7MUDFRn3TdbIEur+DgjBYJA5V5qZjQ3Gt4GBhitW085KyJcO/shgMW
         6vfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kh8Gfm9+uyUN7wr5xX2KRQaXD7QaZKY7AK/XNvHYC3E=;
        b=MEglmiqze3fzShM3TjKxgOgLSYFeICmWCT/yFC+vrMZHruW5N/kQqOtXc/Rn2AtZbY
         DgDV0NW0AdGurSsoDxG6TP7jAiOJfmjMAg1wLyK5/2ZB4k8qESp6M+1MJB++gMbtMa1i
         pKW/IDdWmuPsLP8nNOZMvV7DKtGCMVcD7TTHOWri/CDBN9QmInxnGid1P6i39QFL09D8
         1SpiqVyJj89Y3ssAftEAVXM1/JZ7ojxmBPi10Z+KCwCnpusDCyo0gVKgRb8SCSmib6Ji
         /mwbjZaXGBttIEOpKwHSre3dn0kL6pgbW8qeENVgtC9eLFGJ2FbL7PLU8fDCBG1J31k4
         Yjrg==
X-Gm-Message-State: AOAM533IhhFBbz697ZZgeZn6tZ9OjTJMiKw3eLXUCGdHw1Mh/sGLJBwy
        2pxmm54a2s2F82MWO7NQ3YuO+oW/xZVuFmIY3dA=
X-Google-Smtp-Source: ABdhPJw6JV+p9Y5d9AhSPvSYGnLv28wD82+I6JVIkMGJ8gQt31cjL/s7aJ+8oKcUz3dn3JH+bE9+wNG74VoskgbqPI8=
X-Received: by 2002:a05:600c:3b12:: with SMTP id m18mr456253wms.54.1641337737792;
 Tue, 04 Jan 2022 15:08:57 -0800 (PST)
MIME-Version: 1.0
References: <20211222155743.256280-1-miquel.raynal@bootlin.com>
 <20211222155743.256280-2-miquel.raynal@bootlin.com> <CAB_54W7BeSA+2GVzb9Yvz1kj12wkRSqHj9Ybr8cK7oYd7804RQ@mail.gmail.com>
 <20220104164449.1179bfc7@xps13>
In-Reply-To: <20220104164449.1179bfc7@xps13>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Tue, 4 Jan 2022 18:08:46 -0500
Message-ID: <CAB_54W6LG4SKdS4HDSj1o2A64UiA6BEv_Bh_5e9WCyyJKeAbtg@mail.gmail.com>
Subject: Re: [net-next 01/18] ieee802154: hwsim: Ensure proper channel
 selection at probe time
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, 4 Jan 2022 at 10:44, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Hi Alexander,
>
> alex.aring@gmail.com wrote on Tue, 28 Dec 2021 16:05:43 -0500:
>
> > Hi,
> >
> > On Wed, 22 Dec 2021 at 10:57, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > >
> > > A default channel is selected by default (13), let's clarify that this
> > > is page 0 channel 13. Call the right helper to ensure the necessary
> > > configuration for this channel has been applied.
> > >
> > > So far there is very little configuration done in this helper but we
> > > will soon add more information (like the symbol duration which is
> > > missing) and having this helper called at probe time will prevent us to
> > > this type of initialization at two different locations.
> > >
> >
> > I see why this patch is necessary because in later patches the symbol
> > duration is set at ".set_channel()" callback like the at86rf230 driver
> > is doing it.
> > However there is an old TODO [0]. I think we should combine it and
> > implement it in ieee802154_set_channel() of "net/mac802154/cfg.c".
> > Also do the symbol duration setting according to the channel/page when
> > we call ieee802154_register_hw(), so we have it for the default
> > settings.
>
> While I totally agree on the background idea, I don't really see how
> this is possible. Every driver internally knows what it supports but
> AFAIU the core itself has no easy and standard access to it?
>

I am a little bit confused here, because a lot of timing related
things in the phy information rate points to "x times symbols". If
this value depends on the transceiver, how are they compatible then?

> Another question that I have: is the protocol and center frequency
> enough to always derive the symbol rate? I am not sure this is correct,
> but I thought not all symbol rates could be derived, like for example
> certain UWB PHY protocols which can use different PRF on a single
> channel which has an effect on the symbol duration?

Regarding UWB PHY I see that for values like LIFS/SIFS they reference
a "preambleSymbols" value which is defined.

I need to do more research regarding this.

- Alex
