Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 705F126AFCC
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 23:44:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728042AbgIOVnu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 17:43:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728115AbgIOVnp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 17:43:45 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA1BCC06178A;
        Tue, 15 Sep 2020 14:43:30 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id n2so5659815oij.1;
        Tue, 15 Sep 2020 14:43:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d+l2jldbeQ9UXxV/6usRwMcYxfxEm+h+QQLu9/KPPfo=;
        b=iK1rkcFqenCb0YI9hHcWBT5bnl0tpUlBg3OhGqjkK/LUVctJtHJRofUza5v6GakDkd
         xe6igqSoXGel6K5zG+QwFaVC9kVeYm2uzMQe+tHDQwZ3LOYfkBNq6i5xTz1gkZRPtRn1
         Z4dw/2MgoAVJj4GiOuFUZnfE+JgU0aVhSnERoMBgxrVADRRbGb5luYCnaD61TFWg3JJ1
         IJa0SXtkjVgjp+FlCJNY/W9oYzKpvOgBcKKv98quUMGOQgT7vHvknJw49bmwelKx8sro
         K8MqAxPe8yle7BQIAaF1KJliT1cTDDfW9tHvXjG4RB2aFm4Q48jJmew0TieE3OSMNu1e
         rvzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d+l2jldbeQ9UXxV/6usRwMcYxfxEm+h+QQLu9/KPPfo=;
        b=MVBKfmIBZYMo5pU2nU1qrOlrYXIDAwhAo8aNIa74cCLjCL14QqWLq/ALTZu/XymHM8
         8360Bg+rEwaD/433LMtvUoz1x5u24CAZFA5bDHlzwRt5pBPrBTmMu2STelaoelKnpDTM
         0ur7HbZL+RrdEjOSPcDVpenq+zwu+eJ5RBg8CFpamA9Yq/PyWQX5quaiyDqkj6V/v433
         HuB7F5V11I3JKsqO7511ZfqTVy7uJMarzuv+3MJTokjWlPoyK50vwS1BGjSv9YUcAtyF
         Oz4nNjSWTzlOYN2y2y8eU0ruj3k0g5/lXdkZ819/xJyJsvDdVMuv7LbQ+6jOWZqsMjLd
         GY2A==
X-Gm-Message-State: AOAM533oKep1KpcurRo+ukZjEb8jJd9oFd8kkIghRO5QmeecX13nC1tN
        oCuXKWUiXPwLFT5mmpvLgdGck5JpSKcoZziTmRU=
X-Google-Smtp-Source: ABdhPJyrHaeqSL0v1QSP8L8v5HbkpkYYnnsPbdY4KZ5PNcPMMGgDjSfjcXKVtVTtZUja+czo40D5iXcgA6azK+JJqb4=
X-Received: by 2002:aca:c758:: with SMTP id x85mr1076236oif.102.1600206210356;
 Tue, 15 Sep 2020 14:43:30 -0700 (PDT)
MIME-Version: 1.0
References: <20200915171022.10561-1-oded.gabbay@gmail.com> <20200915133556.21268811@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAFCwf12XZRxLYifSfuB+RGhuiKBytzsUTOnEa6FqfJHYvcVJPQ@mail.gmail.com>
 <20200915140418.4afbc1eb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAFCwf10+_hQOSH4Ot+keE9Tc+ybupvp5JyUhFbvfoy6HseVyZg@mail.gmail.com> <20200915213735.GG3526428@lunn.ch>
In-Reply-To: <20200915213735.GG3526428@lunn.ch>
From:   Oded Gabbay <oded.gabbay@gmail.com>
Date:   Wed, 16 Sep 2020 00:43:00 +0300
Message-ID: <CAFCwf13RHWmpAXpWLRtsxjvKPK=7ZChDPD9E6KEgbamLbg09OA@mail.gmail.com>
Subject: Re: [PATCH v3 00/14] Adding GAUDI NIC code to habanalabs driver
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, SW_Drivers <SW_Drivers@habana.ai>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-rdma@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 16, 2020 at 12:37 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > I completely understand but you didn't answer my question. How come
> > there are drivers which create netdev objects, and specifically sgi-xp
> > in misc (but I also saw it in usb drivers) that live outside
> > drivers/net ? Why doesn't your request apply to them as well ?
> > When we wrote the code, we saw those examples and therefore assumed it was fine.
>
> commit 45d9ca492e4bd1522d1b5bd125c2908f1cee3d4a
> Author: Dean Nelson <dcn@sgi.com>
> Date:   Tue Apr 22 14:46:56 2008 -0500
>
>     [IA64] move XP and XPC to drivers/misc/sgi-xp
>
>     Move XPC and XPNET from arch/ia64/sn/kernel to drivers/misc/sgi-xp.
>
>     Signed-off-by: Dean Nelson <dcn@sgi.com>
>     Signed-off-by: Tony Luck <tony.luck@intel.com>
>
> It has been there a long time, and no networking person was involved
> in its move.
>
> drivers/usb/gadget/function/f_ncm.c
> commit 00a2430ff07d4e0e0e7e24e02fd8adede333b797
> Author: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
> Date:   Tue Jul 15 13:09:46 2014 +0200
>
>     usb: gadget: Gadget directory cleanup - group usb functions
>
>     The drivers/usb/gadget directory contains many files.
>     Files which are related can be distributed into separate directories.
>     This patch moves the USB functions implementations into a separate directory.
>
>     Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
>     Signed-off-by: Felipe Balbi <balbi@ti.com>
>
> Again, old.
>
> Can you find an example of a network driver added in the last couple
> of years outside of drivers/met?
I honestly don't know and I admit we didn't look at the dates of when
these drivers were introduced.
Oded

>
> > > > > Please make sure to CC linux-rdma. You clearly stated that the device
> > > > > does RDMA-like transfers.
> > > >
> > > > We don't use the RDMA infrastructure in the kernel and we can't
> > > > connect to it due to the lack of H/W support we have so I don't see
> > > > why we need to CC linux-rdma.
> > >
> > > You have it backward. You don't get to pick and choose which parts of
> > > the infrastructure you use, and therefore who reviews your drivers.
> > > The device uses RDMA under the hood so Linux RDMA experts must very
> > > much be okay with it getting merged. That's how we ensure Linux
> > > interfaces are consistent and good quality.
> >
> > I understand your point of view but If my H/W doesn't support the
> > basic requirements of the RDMA infrastructure and interfaces, then
> > really there is nothing I can do about it. I can't use them.
>
> It is up to the RDMA people to say that. They might see how the RDMA
> core can be made to work for your hardware.
>
>      Andrew
