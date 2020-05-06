Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D624D1C7DE7
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 01:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727955AbgEFXco (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 19:32:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727088AbgEFXco (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 19:32:44 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE1B8C061A0F;
        Wed,  6 May 2020 16:32:43 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id k8so2946853ejv.3;
        Wed, 06 May 2020 16:32:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PyQtyzfpEi11D12YIo9CY2Ai/69JbjG0nmbCVjCYT+Q=;
        b=F4Io3OgGcJpxtvJtxEwwIQOL+8gShv7UL9fM8M+vuC5/ZU2s8LRdB7GuUsDXLvtcL1
         ML+/afleaQR+tNqZFburj0jhDpa5CLwvJjOFaNGlOYDE6PPDk2I0XoA3TXJSjy07yEEm
         JxxyQXm9Po+5iwgAuVEHXMBdQX85kUBKOtqhJzNEaiRUxvsSS0tp4RoYAtExXssFtUti
         2tWnRMAR641gO49w72cQChLHv3oRt/da9UEeV39DR0rjBpMbUJscoJKgdzGK0EBc+n1T
         K2yUgvvSkkOawmCQYMRkHAHD9FqXNzbN6KOO/Qu7GWsQNNzamHHpyPHyV6FT1PlASSk6
         jRow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PyQtyzfpEi11D12YIo9CY2Ai/69JbjG0nmbCVjCYT+Q=;
        b=OSipleIq0CBfzS5ZUkjtk8KAjEqAt020XtUFXnJzU6TuWa+Wbo4uVQEpdVyD0Li4uu
         n6d0drKvlSVs2DnYCxpXacnctHrBqgwmUo/2wPEBA671z2SLoawj2p8Sgqj9yJv0+mH4
         5eRt8M3ylqIqeTVl3MdJhNrhvavzYOZdX9y0vf+dBxEekEQO/kEwI5DoeLkGnP0rzx4F
         pU/6JDPKHJfMOzxCNLV5II5m5pknbq090tpsWD7tiYqoWp6TCDIF8EzlT0LXCztsaEXp
         w4Z9C56G68sX9Q6OTysNkm4r2BexO/3zaUUkRao3XG3zbdSEiCAVCGz2Zsrl63oUNJtk
         i8Ug==
X-Gm-Message-State: AGi0PuZTwkX1RE6yHRRmYVKV3syrUXXTJjbunLyNsRvPKBKJeJhKvftN
        Ks2MTA3L8Pq1MZ47fRZXXT0XFX/jq9Y2U6S6VT4=
X-Google-Smtp-Source: APiQypIQCyTIuPEEp1VjyAMeJ0nSR+gVWjNQWhEv4iJMafIi9Jc3YYJF/ceHOIfQmoxB+sYXp2PumtD92nOc/dJC2t4=
X-Received: by 2002:a17:906:355b:: with SMTP id s27mr9781545eja.184.1588807962270;
 Wed, 06 May 2020 16:32:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200505210253.20311-1-f.fainelli@gmail.com> <20200505172302.GB1170406@t480s.localdomain>
 <d681a82b-5d4b-457f-56de-3a439399cb3d@gmail.com> <CA+h21hpvC6ST2iv-4xjpwpmRHQJvk-AufYFvG0J=5KzUgcnC5A@mail.gmail.com>
 <97c93b65-3631-e694-78ac-7e520e063f95@gmail.com>
In-Reply-To: <97c93b65-3631-e694-78ac-7e520e063f95@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 7 May 2020 02:32:31 +0300
Message-ID: <CA+h21hp0-3n7OBuBxXiAeicicpkbXu9XnURjONvgfYgd=b1zLA@mail.gmail.com>
Subject: Re: [RFC net] net: dsa: Add missing reference counting
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 7 May 2020 at 01:45, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
>
>
> On 5/6/2020 2:40 PM, Vladimir Oltean wrote:
> > Hi Florian,
> >
> > On Thu, 7 May 2020 at 00:24, Florian Fainelli <f.fainelli@gmail.com> wrote:
> >>
> >>
> >>
> >> On 5/5/2020 2:23 PM, Vivien Didelot wrote:
> >>> On Tue,  5 May 2020 14:02:53 -0700, Florian Fainelli <f.fainelli@gmail.com> wrote:
> >>>> If we are probed through platform_data we would be intentionally
> >>>> dropping the reference count on master after dev_to_net_device()
> >>>> incremented it. If we are probed through Device Tree,
> >>>> of_find_net_device() does not do a dev_hold() at all.
> >>>>
> >>>> Ensure that the DSA master device is properly reference counted by
> >>>> holding it as soon as the CPU port is successfully initialized and later
> >>>> released during dsa_switch_release_ports(). dsa_get_tag_protocol() does
> >>>> a short de-reference, so we hold and release the master at that time,
> >>>> too.
> >>>>
> >>>> Fixes: 83c0afaec7b7 ("net: dsa: Add new binding implementation")
> >>>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> >>>
> >>> Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>
> >>>
> >> Andrew, Vladimir, any thoughts on that?
> >> --
> >> Florian
> >
> > I might be completely off because I guess I just don't understand what
> > is the goal of keeping a reference to the DSA master in this way for
> > the entire lifetime of the DSA switch. I think that dev_hold is for
> > short-term things that cannot complete atomically, but I think that
> > you are trying to prevent the DSA master from getting freed from under
> > our feet, which at the moment would fault the kernel instantaneously?
>
> Yes, that's the idea, you should not be able to rmmod/unbind the DSA
> master while there is a DSA switch tree hanging off of it.
>
> >
> > If this is correct, it certainly doesn't do what it intends to do:
> > echo 0000\:00\:00.5> /sys/bus/pci/drivers/mscc_felix/unbind
> > [   71.576333] unregister_netdevice: waiting for swp0 to become free.
> > Usage count = 1
> > (hangs there)
>
> Is this with the sja1105 switch hanging off felix?

Yes, but it actually doesn't matter that the DSA master is a DSA slave too.

> If so, is not it
> working as expected because you still have sja1150 being bound to one of
> those ports? If not, then I will look into why.
>

I just unbound the driver for the DSA master and the shell got stuck
in kernel process context telling me that it's waiting for the
reference to be freed. So I think it's just that my "expected" is not
the same as yours - it looks like what I'm doing would qualify as
"incorrect usage".

> >
> > But if I'm right and that's indeed what you want to achieve, shouldn't
> > we be using device links instead?
> > https://www.kernel.org/doc/html/v4.14/driver-api/device_link.html
>
> device links could work but given that the struct device and struct
> net_device have almost the same lifetime, with the net_device being a
> little bit shorter, and that is what DSA uses, I am not sure whether
> device link would bring something better.

At the very least, I think they would bring us graceful teardown of
consumers of the DSA master device.

> --
> Florian

Thanks,
-Vladimir
