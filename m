Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19946484B13
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 00:11:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236150AbiADXK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 18:10:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235297AbiADXK5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 18:10:57 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EACDFC061761;
        Tue,  4 Jan 2022 15:10:56 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id s1so79264465wrg.1;
        Tue, 04 Jan 2022 15:10:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dghhemCEyLat9M9H4ByRCHavgb5QYg8+E2Svdwn+RCM=;
        b=ZRamoy/kvpRtZQ1Yl+YjkSZARB/hyR8NDOVh1Lu731WNdUa2B5qdhmf/vnwVu6q299
         Gg9rzjY23A0N4Lptyt5qqw2SKQjAwxGxwvK/MqUUt9bDQFY2n0jM1gtBegGJ+sdIo5wQ
         PwFBs8Ukn0Iy2eURKY4flKTKLrjXGU+mHi/ocPlQ4IUCT+bRYKtEy727QdeN9lYLz16K
         raFt+9x5m1i9QXfeuuHTl0K3gzvxP2UCZS2pI1vZUMyIFWi4psMKspmmVxraQQfRn+ch
         8a8WfC9D6AefaBSGsjlN9UeDpDgoKah8+YElmH2b2ZFj2smTGjhboQzkNy9Z3KuYj1fV
         7veA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dghhemCEyLat9M9H4ByRCHavgb5QYg8+E2Svdwn+RCM=;
        b=TD67kUm7wAcrs9bbIoWgow6lfqMiDn6sf/WKOIuZpTV64BsJ0Wjn1xVdrwvAr5v7c/
         ep3H9Z3mCdd1q5QfgWWWyxoHoLx6fydXxuaBqtmNXLVer2RDK7BoUbK0YY0cEDtMfWF1
         oa/lj8/R1hk7N633nloCXH89DaQb+LEA7uZqkM15RbYrBmNrp52U9lnZzxY9oiv5irGk
         oFR2VbPf/DOJv56AAZbblp45AZzu2rL4jtw8QzQwIZuD7qQ8Ph6bn+t4cFkaQrXs4RKS
         f8zPhf0832Fep6nWuX/7sH2mBeUz2VewLk5mO3KKsB2h6wZyxPxKx5Pl6BsTAx7hIZVZ
         Kwow==
X-Gm-Message-State: AOAM53311AgHj+HnZfwD6jqXRFlrnjmYyZP4plOILNUgOiDV18fsqHTj
        t7zPKvXHqC8paPsSHIbJI0K+t1iaBqUqP7NnAUs=
X-Google-Smtp-Source: ABdhPJxb+I3Kfb0YlojJ6PdB1V9GVaW5OyFKDJMjRmbKiN6la6G5y/xd/zjpxWZBmjFKIf5ei98XRO5wShtxiI/+VGM=
X-Received: by 2002:a5d:46cf:: with SMTP id g15mr45328673wrs.207.1641337855473;
 Tue, 04 Jan 2022 15:10:55 -0800 (PST)
MIME-Version: 1.0
References: <20211222155743.256280-1-miquel.raynal@bootlin.com>
 <20211222155743.256280-2-miquel.raynal@bootlin.com> <CAB_54W7BeSA+2GVzb9Yvz1kj12wkRSqHj9Ybr8cK7oYd7804RQ@mail.gmail.com>
 <20220104164449.1179bfc7@xps13> <CAB_54W6LG4SKdS4HDSj1o2A64UiA6BEv_Bh_5e9WCyyJKeAbtg@mail.gmail.com>
In-Reply-To: <CAB_54W6LG4SKdS4HDSj1o2A64UiA6BEv_Bh_5e9WCyyJKeAbtg@mail.gmail.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Tue, 4 Jan 2022 18:10:44 -0500
Message-ID: <CAB_54W6o-wBD2wu7sohCD0ack5PR_wqc2NqOnYC6WEVV5VF8FQ@mail.gmail.com>
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

On Tue, 4 Jan 2022 at 18:08, Alexander Aring <alex.aring@gmail.com> wrote:
>
> Hi,
>
> On Tue, 4 Jan 2022 at 10:44, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> >
> > Hi Alexander,
> >
> > alex.aring@gmail.com wrote on Tue, 28 Dec 2021 16:05:43 -0500:
> >
> > > Hi,
> > >
> > > On Wed, 22 Dec 2021 at 10:57, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > > >
> > > > A default channel is selected by default (13), let's clarify that this
> > > > is page 0 channel 13. Call the right helper to ensure the necessary
> > > > configuration for this channel has been applied.
> > > >
> > > > So far there is very little configuration done in this helper but we
> > > > will soon add more information (like the symbol duration which is
> > > > missing) and having this helper called at probe time will prevent us to
> > > > this type of initialization at two different locations.
> > > >
> > >
> > > I see why this patch is necessary because in later patches the symbol
> > > duration is set at ".set_channel()" callback like the at86rf230 driver
> > > is doing it.
> > > However there is an old TODO [0]. I think we should combine it and
> > > implement it in ieee802154_set_channel() of "net/mac802154/cfg.c".
> > > Also do the symbol duration setting according to the channel/page when
> > > we call ieee802154_register_hw(), so we have it for the default
> > > settings.
> >
> > While I totally agree on the background idea, I don't really see how
> > this is possible. Every driver internally knows what it supports but
> > AFAIU the core itself has no easy and standard access to it?
> >
>
> I am a little bit confused here, because a lot of timing related
> things in the phy information rate points to "x times symbols". If

s/rate/base/

- Alex
