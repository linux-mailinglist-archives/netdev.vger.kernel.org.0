Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD2C82EBB70
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 09:56:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbhAFIzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 03:55:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbhAFIzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 03:55:22 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AB18C06134C;
        Wed,  6 Jan 2021 00:54:42 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id u12so2483444ilv.3;
        Wed, 06 Jan 2021 00:54:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Pe37dDiOz2GDrAs6TqKHnU0rqrls99WJSNoQ7pBF+BQ=;
        b=j7VND15jkP8wzb/TkyG/SrSA/P23UDg/Du6YZEKvfxaqbM1e8kbd6NZl13ksugpWHL
         2v14isveuZwDl4YCYkZKljHq0M8jcOIr/PBIB9W9X7cNZZi7VvUqhUW5SHvWgfgiPNty
         Y2nnDWuwZw1g/ZWSwlF6SZzV/F0tM+z9Ka9ya+Sz9PrltqrtnKpk5Usgf+mkvy7e7PuD
         mQ5fg9SQBOFuYy1o6sWY/E6jm7+jYDs/iG8Q0h/m2vQaf1WMuf83PbvMnSeXGazCQQws
         Iw5bJdqi2Q5GwVudFWLIQaYaOoC2V5aBc2b6cbAeGUHbx/Mfg/0YaYm2m4YMf+GSoHWm
         RlIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Pe37dDiOz2GDrAs6TqKHnU0rqrls99WJSNoQ7pBF+BQ=;
        b=p2bs4RCQEKkKLwoatsZkvmrNQ3zicda1J6VpMuFo6WJW3kauZbiSqI+N5LYAbAMfey
         bPy/eQqGcE9+SfLBgNLJhVix4I5cC4VtwfjR7jafciUaBHdDG+ojFptxbNunIkvDY/zb
         vrzrWnpCD2i6/LVgK6/hoFPFCpW104Q7urhpKhiI/vNTe7aGA8CK+ldZ4DzNCwkfMC8I
         g4Eqk7HVH/Vp0PrY178DN+EjNLoNQbtdg8zf4t6a9LqRfzMjxfbrRv+pzt6q+VuYv/Z8
         871TGJRdhqZ1iiQZLIBcmKA6B9ZW9L/H/R+12oepnEncTcTHAozqAScA+l0xGapn3MpY
         ZNrg==
X-Gm-Message-State: AOAM531Ug38Gr3cSISFi21M53wOB+zQGKQZRoXF7rC+ZK1eDRbRkhbE4
        phDSx90cpQhLs3DgC3UJJp1BUkH1zM5gURX2+RR2HyONcukAMg==
X-Google-Smtp-Source: ABdhPJxLD76gm9woaQ8LTtmrcXqKK2YjcQmQiltbE1LY4v7YBqf9JdCbxvZLz3Fag10pP3AOk9Yz1aXNE1lL0BFfdFA=
X-Received: by 2002:a92:c04f:: with SMTP id o15mr3380278ilf.31.1609923281796;
 Wed, 06 Jan 2021 00:54:41 -0800 (PST)
MIME-Version: 1.0
References: <20201230042208.8997-1-dqfext@gmail.com> <441a77e8c30927ce5bc24708e1ceed79@kernel.org>
 <X+ybeg4dvR5Vq8LY@lunn.ch>
In-Reply-To: <X+ybeg4dvR5Vq8LY@lunn.ch>
From:   DENG Qingfang <dqfext@gmail.com>
Date:   Wed, 6 Jan 2021 16:54:36 +0800
Message-ID: <CALW65ja33=+7TGQMYdr=Wztwy_simszSwO6saMvvSeqX3qWGxA@mail.gmail.com>
Subject: Re: Registering IRQ for MT7530 internal PHYs
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Marc Zyngier <maz@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>,
        Sean Wang <sean.wang@mediatek.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Weijie Gao <weijie.gao@mediatek.com>,
        Chuanhong Guo <gch981213@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Wed, Dec 30, 2020 at 11:23 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Wed, Dec 30, 2020 at 09:42:09AM +0000, Marc Zyngier wrote:
> > > +static irqreturn_t
> > > +mt7530_irq(int irq, void *data)
> > > +{
> > > +   struct mt7530_priv *priv = data;
> > > +   bool handled = false;
> > > +   int phy;
> > > +   u32 val;
> > > +
> > > +   val = mt7530_read(priv, MT7530_SYS_INT_STS);
> > > +   mt7530_write(priv, MT7530_SYS_INT_STS, val);
> >
> > If that is an ack operation, it should be dealt with as such in
> > an irqchip callback instead of being open-coded here.
>
> Hi Qingfang
>
> Does the PHY itself have interrupt control and status registers?

MT7531's internal PHY has an interrupt status register, but I don't
know if the same applies to MT7530.

>
> My experience with the Marvell Switch and its embedded PHYs is that
> the PHYs are just the same as the discrete PHYs. There are bits to
> enable different interrupts, and there are status bits indicating what
> event caused the interrupt. Clearing the interrupt in the PHY clears
> the interrupt in the switch interrupt controller. So in the mv88e6xxx
> interrupt code, you see i do a read of the switch interrupt controller
> status register, but i don't write to it as you have done.
>
>        Andrew
