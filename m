Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6EBC19E2B9
	for <lists+netdev@lfdr.de>; Sat,  4 Apr 2020 06:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbgDDETg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Apr 2020 00:19:36 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:39700 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726016AbgDDETD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Apr 2020 00:19:03 -0400
Received: by mail-oi1-f194.google.com with SMTP id d63so8119561oig.6
        for <netdev@vger.kernel.org>; Fri, 03 Apr 2020 21:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=je7nuNsfXk26lRmkb6ciZHwSXJTBCDyjnYltMGy9GKw=;
        b=Bk8YVcnE/cBJl2ujaD7DGjNm//e+RUaeMJE3R4oTnEdfER1QAwCHybt2WimOnaczqF
         1UQOyXoQ5Ng6kLHJ49G+EIv+Hp/OFZPCGcmy+f4NwDYWKCk+BOUadj6lUbHedg82lHBR
         aAx/e06OeA3U0eb5Hx5UBQ1gvFdpxplndrMBMnx5B85/dam1NdoOJBBTMzFG784StGTe
         5AyOdVM3AakZGc1Z0N11r2ZZwEg+1tpABlQzQ9+PZSXdXahsklsQqJZURGFY0Zy4FH3y
         2IVsQg9Z9Y0CW14QOuODdQpbGCdj6CcArqPWQe1KA+rV8YGGieKYlryjTjtfk8bxgvVK
         kctQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=je7nuNsfXk26lRmkb6ciZHwSXJTBCDyjnYltMGy9GKw=;
        b=kbULX0Z7hKye2VYmHeE+bEMIz5cSS4wP44FgSs8wApLBw5MzqpRkZ8SKz5u0UwMdNr
         LIOK/QcSsGCC+ir5Nxgz9DBoxKTfu3p4nmSY/9Gh1XZPQIqjB+3hyD+RcGDOC2gjhg6/
         Ci2M0kVK+XeGNquh/ycNAEB4bPT4evz+JVvAh84z6coC2ka49DhJSEoX5MUju2ib/Cbx
         8Mv1J7ss/gH233b7tF+/IWOzAgsbdnPHkxrJ9EfllZSCfSeTwOfsuuL+AYRZBV2LfdsY
         e0+L2kjFHqnWzEHol4ry73dqmk4cRuThELzYfVF1jO6y6ZZz9/JfVTBUfG5eP+8yTHb8
         9SJw==
X-Gm-Message-State: AGi0PuZlF+bbN4dSFLZaZRNjDvwTxl9p4YcCGS156unD5dBdR9pyeFn4
        a7rlOp8E67PWekf8w5YAQ4Fr/lc35qg6LKKiHxOTlQ==
X-Google-Smtp-Source: APiQypLmrSfzfYdNvicoaCyhCetap9MoAIFDaZdmEHGJohfwM7HjZ6WmIj82QvstEFNnMH986goMroldCiSCq9icpyk=
X-Received: by 2002:a05:6808:a0a:: with SMTP id n10mr5721046oij.10.1585973942770;
 Fri, 03 Apr 2020 21:19:02 -0700 (PDT)
MIME-Version: 1.0
References: <TYAPR01MB45443DF63B9EF29054F7C41FD8C60@TYAPR01MB4544.jpnprd01.prod.outlook.com>
 <CALAqxLWopjCkiM=NR868DTcX-apPc1MPnONJMppm1jzCboAheg@mail.gmail.com> <CAMuHMdVtHhq9Nef1pBtBUKfRU2L-KgDffiOv28VqhrewR_j1Dw@mail.gmail.com>
In-Reply-To: <CAMuHMdVtHhq9Nef1pBtBUKfRU2L-KgDffiOv28VqhrewR_j1Dw@mail.gmail.com>
From:   John Stultz <john.stultz@linaro.org>
Date:   Fri, 3 Apr 2020 21:18:50 -0700
Message-ID: <CALAqxLX2AEFJxqXXXKPs8SU7Su2FqNjwbSt5BxwmQJqYQuST9A@mail.gmail.com>
Subject: Re: How to fix WARN from drivers/base/dd.c in next-20200401 if CONFIG_MODULES=y?
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 3, 2020 at 4:47 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Thu, Apr 2, 2020 at 7:27 PM John Stultz <john.stultz@linaro.org> wrote:
> > On Thu, Apr 2, 2020 at 3:17 AM Yoshihiro Shimoda
> > <yoshihiro.shimoda.uh@renesas.com> wrote:
> > >
> > > I found an issue after applied the following patches:
> > > ---
> > > 64c775f driver core: Rename deferred_probe_timeout and make it global
> > > 0e9f8d0 driver core: Remove driver_deferred_probe_check_state_continue()
> > > bec6c0e pinctrl: Remove use of driver_deferred_probe_check_state_continue()
> > > e2cec7d driver core: Set deferred_probe_timeout to a longer default if CONFIG_MODULES is set
>
> Note that just setting deferred_probe_timeout = -1 like for the
> CONFIG_MODULES=n case doesn't help.

Yea. I can see why in that case, as we're checking
!IS_ENABLED(CONFIG_MODULES) directly in
driver_deferred_probe_check_state.

I guess we could switch that to checking
(driver_deferred_probe_timeout == -1) which would have the same logic
and at least make it consistent if someone specifies -1 on the command
line (since now it will effectively have it EPROBE_DEFER forever in
that case). But also having a timeout=infinity could be useful if
folks don't want the deferring to time out.  Maybe in the !modules
case setting it to =0 would be the most clear.

But that's sort of a further cleanup. I'm still more worried about the
NFS failure below.


> > Hey,
> >   Terribly sorry for the trouble. So as Robin mentioned I have a patch
> > to remove the WARN messages, but I'm a bit more concerned about why
> > after the 30 second delay, the ethernet driver loads:
> >   [   36.218666] ravb e6800000.ethernet eth0: Base address at
> > 0xe6800000, 2e:09:0a:02:eb:2d, IRQ 117.
> > but NFS fails.
> >
> > Is it just that the 30 second delay is too long and NFS gives up?
>
> I added some debug code to mount_nfs_root(), which shows that the first
> 3 tries happen before ravb is instantiated, and the last 3 tries happen
> after.  So NFS root should work, if the network works.
>
> However, it seems the Ethernet PHY is never initialized, hence the link
> never becomes ready.  Dmesg before/after:
>
>      ravb e6800000.ethernet eth0: Base address at 0xe6800000,
> 2e:09:0a:02:ea:ff, IRQ 108.
>
> Good.
>
>      ...
>     -gpio_rcar e6052000.gpio: sense irq = 11, type = 8
>
> This is the GPIO the PHY IRQ is connected to.
> Note that that GPIO controller has been instantiated before.
>
>      ...
>     -Micrel KSZ9031 Gigabit PHY e6800000.ethernet-ffffffff:00:
> attached PHY driver [Micrel KSZ9031 Gigabit PHY]
> (mii_bus:phy_addr=e6800000.ethernet-ffffffff:00, irq=197)
>      ...
>     -ravb e6800000.ethernet eth0: Link is Up - 1Gbps/Full - flow control off
>
> Oops.
>
>     -Sending DHCP requests .., OK
>     -IP-Config: Got DHCP answer from ...
>      ...
>     +VFS: Unable to mount root fs via NFS, trying floppy.
>     +VFS: Cannot open root device "nfs" or unknown-block(2,0): error -6
>
> > Does booting with deferred_probe_timeout=0 work?
>
> It does, as now everything using optional links (DMA and IOMMU) is now
> instantiated on first try.

Thanks so much for helping clarify this!

So it's at least good to hear that booting with
deferred_probe_timeout=0 is working!  But I'm bummed the NFS (or as
you pointed out in your later mail,  ip_auto_config) falls over
because the network isn't immediately there.

Looking a little closer at the ip_auto_config() code, I think the
issue may be that wait_for_device_probe() is effectively returning too
early, since the probe_defer_timeout is still active? I need to dig a
bit more on that code, on Monday, as I don't fully understand it yet.

If I can't find a way to address that, I think the best course will be
to set the driver_deferred_probe_timeout value to default to 0
regardless of the value of CONFIG_MODULES, so we don't cause any
apparent regression from previous behavior. That will also sort out
the less intuitive = -1 initialization in the non-modules case.

In any case, I'll try to have a patch to send out on Monday.

thanks
-john
