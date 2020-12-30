Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23FEF2E7752
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 10:09:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726317AbgL3JI3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 04:08:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726161AbgL3JI3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 04:08:29 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0124BC061799;
        Wed, 30 Dec 2020 01:07:48 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id n9so14324910ili.0;
        Wed, 30 Dec 2020 01:07:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bRbWMy4dJ12pPwYrP4XCH+qF0EmChfEKCOKQxp85vNs=;
        b=R4UP0ST/ciRLa4u9+EjBWOF5K5r4wQ3qsPZb9s74D7NzSw00b4IoEBRhX77ergtLya
         LDDKOb6hZlQ352n05WHdyEB+eylAt2NRHeNEE1yXn0zuuqAUaClAMJ3bkraRA7ciZU6P
         JfEDxh8FayqFI8TC1dU0J7BVkEVmH/vSuxq+dnwRUUz5XN4oqbLUF0SfdYoRm+EVKSpU
         Co4uoWWgZPjbyk5hN+XvtSGmpyNo/qVoZKM7oR1cfVb63HExEaB8pk/d5klvZ+XNY8fQ
         26HDuvJsCPcj+dwnHBV/RzXB46/ndryCWZXtP7hzkc5Xe6qUQZZGktSLX+/cng13NYuw
         2W7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bRbWMy4dJ12pPwYrP4XCH+qF0EmChfEKCOKQxp85vNs=;
        b=OrbIAqJ7539fjHjkGNoUwpd2dRIxiXNLlGuHcVo2FkPOp3f27TDavk676/LF0eG5G8
         zBoImr3OuMWk01fWYeKzcPkSVJ1qClSTBsZE9tAQga71StVcUIWC3adjqUrUbZa3hyUn
         hzfOZOQKtbKr9LwXz2jDCL6WRKFq59OgM7NDEwePny7pT6JbN1ZvxaXepbat8VdrzfAl
         JAyOjKRNtZYF15pnZhw00rb28nMmXyJ+U/ur1185pV3BfdOallaszmSt7BGgjA64C/fs
         dtBVy5xh7ZLbStiC8fd/uRri+a/LiGW1Lstap+iFPfgJTIWdtXAusYYHCOv879nt152H
         gylw==
X-Gm-Message-State: AOAM533D88jV2GCHyZ+DMH0VGZx+2Nax/W4BRtCqxkHdYI3fL75AfgEw
        f8SGMQyk+zRQoQcZpgzAddNnflnbGcZIz2fyhfM=
X-Google-Smtp-Source: ABdhPJzQ9OM8NlxoosopDzZNK5wwPcUnGqp3kTBGDDA91Ry9s6SvHtaV3UWgrYbLL+YZK8E7kz/dnnmBjqwtPBzmwTA=
X-Received: by 2002:a92:d6cb:: with SMTP id z11mr50724669ilp.169.1609319268333;
 Wed, 30 Dec 2020 01:07:48 -0800 (PST)
MIME-Version: 1.0
References: <20201230042208.8997-1-dqfext@gmail.com> <a64312eb-8b4c-d6d4-5624-98f55e33e0b7@gmail.com>
In-Reply-To: <a64312eb-8b4c-d6d4-5624-98f55e33e0b7@gmail.com>
From:   DENG Qingfang <dqfext@gmail.com>
Date:   Wed, 30 Dec 2020 17:07:38 +0800
Message-ID: <CALW65jbV-RwbmmiGjfq8P-ZcApOW0YyN6Ez5FvhhP4dgaA+VjQ@mail.gmail.com>
Subject: Re: Registering IRQ for MT7530 internal PHYs
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Marc Zyngier <maz@kernel.org>,
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

Hi Heiner,
Thanks for your reply.

On Wed, Dec 30, 2020 at 3:39 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
> I don't think that's the best option.

I'm well aware of that.

> You may want to add a PHY driver for your chip. Supposedly it
> supports at least PHY suspend/resume. You can use the RTL8366RB
> PHY driver as template.

There's no MediaTek PHY driver yet. Do we really need a new one just
for the interrupts?

> > +     dev_info_ratelimited(priv->dev, "interrupt status: 0x%08x\n", val);
> > +     dev_info_ratelimited(priv->dev, "interrupt enable: 0x%08x\n", mt7530_read(priv, MT7530_SYS_INT_EN));
> > +
> This is debug code to be removed in the final version?

Yes.

> > +     for (phy = 0; phy < MT7530_NUM_PHYS; phy++) {
> > +             if (val & BIT(phy)) {
> > +                     unsigned int child_irq;
> > +
> > +                     child_irq = irq_find_mapping(priv->irq_domain, phy);
> > +                     handle_nested_irq(child_irq);
> > +                     handled = true;
> > +             }
> > +     }
> > +
> > +     return handled ? IRQ_HANDLED : IRQ_NONE;
>
> IRQ_RETVAL() could be used here.

Good to know :)

>
> > +}
> > +
> > +static void mt7530_irq_mask(struct irq_data *d)
> > +{
> > +     struct mt7530_priv *priv = irq_data_get_irq_chip_data(d);
> > +
> > +     priv->irq_enable &= ~BIT(d->hwirq);
>
> Here you don't actually do something. HW doesn't support masking
> interrupt generation for a port?

priv->irq_enable will be written to MT7530_SYS_INT_EN in
mt7530_irq_bus_sync_unlock. You can think of it as an inverted mask.
