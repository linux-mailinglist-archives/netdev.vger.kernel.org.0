Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA7EB265154
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 22:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbgIJUwq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 16:52:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726746AbgIJUwg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 16:52:36 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3EB0C061756;
        Thu, 10 Sep 2020 13:52:33 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id x14so7275891oic.9;
        Thu, 10 Sep 2020 13:52:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VPpl9Z9qKG4w005uSztVwu76pM5CDuAiXfIO8K3+qrE=;
        b=m0IcqgCQ9O8AuJcc7fc+TKNe4VmhTEZJDFncPoOZ5TbiTYuYueITM56QOkId2CVxV2
         0gvEEE765IgF+bY/v5gwti5C0IOA4JSKESYmODEJIf8gORQE1e5sGNzM6BXT31OmqUo1
         lbB/ThjTaUw3H8i+s2aG1yW7Uh+SbdOBzkS6Oj0rHYQqHUDdnEipdQ5744RGzfaYadJB
         eiVWaDByrojf73q7kgDUG26umWC0smerQAkMRe99vw6xU5R0paFJDb1axzoGle9iBok3
         IRNHTi2Rycw0xuyqTC0jEQe8r7WhnrAuW9AVMGRq3ZD9pKFR+uYR833FRY6NLj+mYcS7
         k26Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VPpl9Z9qKG4w005uSztVwu76pM5CDuAiXfIO8K3+qrE=;
        b=sA7gfFoGu5eZZtUm6HMP02T8Fu0y8imCZn+0hLZ1X5IiEAn5MqhPNNf5En+Fe2D4kr
         Vwi8fEZiQ45W4pNQN/GvMY5RfxWuUdUB80e4p/HWNmPVT450X1Ex1ld593PAg0tnWJ6k
         7u0DX4MdjWdtj/V78gPzSnzV9+UYaHjrC6gWIlWkf3MMKUBKWrdIolcR8RDU3ZHZQiDR
         IbH7m6PYjKkI9YSIu0FeHWFIGGmiaQe0mxFVXfxlOLk5mppZsPqDm2nlNgsjlIAE4bE4
         D72HaLBGhF6v2Ay7Jh6tyTftB1FA1bPw63DisTPwUIg+xNd9TBHLVXP3VUYiw3ppbmvI
         RW4A==
X-Gm-Message-State: AOAM532aSk9j93rEjOVg+qjGSLlyCZ/dXkXX31fDyAN820lWTKlW6Q6C
        4kvDSzuv7WocGmzqSHj5pbStwdGhTQzPLyEUKZPZqLO3bKgfZQ==
X-Google-Smtp-Source: ABdhPJz2YnloFEb/FVPpViU/szPTv8JRkAq5DfqeUSr54M6RCUBDo/FV9Z1sv6DupqGJdZStQbnui98DDHhKlm0E+gI=
X-Received: by 2002:a05:6808:3bb:: with SMTP id n27mr1192198oie.130.1599771153123;
 Thu, 10 Sep 2020 13:52:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200910161126.30948-1-oded.gabbay@gmail.com> <20200910130112.1f6bd9e9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAFCwf13SbXqjyu6JHKSTf-EqUxcBZUe4iAfggLhKXOi6DhXYcg@mail.gmail.com>
 <20200910202513.GH3354160@lunn.ch> <CAFCwf11P7pEJ+Av9oiwdQFor5Kh9JeKvVTBXnMzWusKCRz7mHw@mail.gmail.com>
 <20200910203848.GJ3354160@lunn.ch>
In-Reply-To: <20200910203848.GJ3354160@lunn.ch>
From:   Oded Gabbay <oded.gabbay@gmail.com>
Date:   Thu, 10 Sep 2020 23:52:05 +0300
Message-ID: <CAFCwf13NofvixWbdg0g2bGkN-UtgyQxNLyMxj3FmMDG669TXYQ@mail.gmail.com>
Subject: Re: [PATCH 00/15] Adding GAUDI NIC code to habanalabs driver
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, SW_Drivers <SW_Drivers@habana.ai>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 10, 2020 at 11:38 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Thu, Sep 10, 2020 at 11:30:33PM +0300, Oded Gabbay wrote:
> > On Thu, Sep 10, 2020 at 11:25 PM Andrew Lunn <andrew@lunn.ch> wrote:
> > >
> > > > Can you please elaborate on how to do this with a single driver that
> > > > is already in misc ?
> > > > As I mentioned in the cover letter, we are not developing a
> > > > stand-alone NIC. We have a deep-learning accelerator with a NIC
> > > > interface.
> > >
> > > This sounds like an MFD.
> > >
> > >      Andrew
> >
> > Yes and no. There is only one functionality - training of deep
> > learning (Accelerating compute operations) :)
> > The rdma is just our method of scaling-out - our method of
> > intra-connection between GAUDI devices (similar to NVlink or AMD
> > crossfire).
> > So the H/W exposes a single physical function at the PCI level. And
> > thus Linux can call a single driver for it during the PCI probe.
>
> Yes, it probes the MFD driver. The MFD driver then creates platform
> drivers for the sub functions. i.e. it would create an Ethernet
> platform driver. That then gets probed in the usual way. The child
> device can get access to the parent device, if it needs to share
> things, e.g. a device on a bus. This is typically I2C or SPI, but
> there is no reason it cannot be a PCI device.
>
> Go look in drivers/mfd.
>
>       Andrew

I'm slightly familiar with drivers/mfd and as you mentioned, those are
for "simple" devices, which use a bus with different functionality on
them, like I2C with many devices (sensors for various things, etc).
I've never seen anyone doing a PCI device there and frankly, I don't
see the benefit of trying to migrate our complex PCI driver to that
subsystem, if it will even work.
And I would like to reiterate that our NIC ports are highly integrated
with our compute engines.
They "talk" to each other via sync objects inside the SOC, and all of
them are used as part of the training of the deep learning network.
Another example why this is not MFD - when a compute engine gets
stuck, all the NIC ports are going through reset.
So it's not the same as multiple devices that use the same bus or H/W.
It's a single device with some engines that work in harmony.
The bottom line is that we have single functionality and the scale-out
is done via RDMA that is integrated on the device.
We could have chosen other ways to scale-out (like some proprietary
bus) and then would that count as another functionality ? I think not.

So I'm not going to drivers/mfd with our driver. I wish that I had
multiple PCI PF so I could do a proper Ethernet driver but I can't for
this H/W.
And I think that physically splitting the files into two subsystems
will be very hard to maintain and definitely I will want to hear
Greg's opinion on that.

Thanks,
Oded
