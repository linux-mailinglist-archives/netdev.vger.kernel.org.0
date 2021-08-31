Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78E683FCDCE
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 22:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240776AbhHaT2D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 15:28:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240674AbhHaT2C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 15:28:02 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29F50C061760
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 12:27:07 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id e131so431582ybb.7
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 12:27:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MiOmjNUrQTixfmxuIIBr9b2mal/6TnKrZ2hUhLBArdA=;
        b=LQ5DfuisFfwLylONTNqaEbGbMDFUlrFBwbH7uzQmaiairk1VdXureNF3ast1bdtiHJ
         1OhdNZOseCGceTZIndqQ3bkMer4XSld2e7dnAd9uMTEiA7PS8GaXCTdO3IDSicU2Sopy
         pPjQFl+IV7DnIZbTdxmgiujRlcFdDgQnyqd0HafORlQfaUcKzeJM+rtI6EvQcmE9wSPe
         toKIFSnBzzG7JSG3KcpCza54fQ+OUPbOrF9BJ/H9MuW3cKGhLbtDSLThszd042O+RdCn
         EMxVbcUSYa78NwDnBcDw/h4mGE0H0xlIhxDKiCa6UwAdwH/aWI6HM1IWE+Uv/Z3fLQx9
         QWDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MiOmjNUrQTixfmxuIIBr9b2mal/6TnKrZ2hUhLBArdA=;
        b=U6IGJJ5MiG97BLt2S4RpKG22KW3ZE8YCOg/lZavzezxTDPugdEe+PJ4b/HJOsSMwxh
         dZjqMjEI8yz/4RBC5tqg8P6f2vp+rXNzUM5P3tYT3sngoqD2pNgLaN8qZlmIrSuQsgT6
         94XxgZtCDoKvQyJ5/h0Di/AbHChkf7mQiOd1LZC+lL7dTYNcRbZJz0LEn8Xs70MaWNBM
         r4+gielZW3qYEwwNyXAhfUQ092GV7F+xHgM5DFrrXcqnaeEYG2Eely9e/yJ5vLhcN/wb
         VbjdcQPVF5k1/ZRojjihojl/a219n0plk2VACUrHRaqjzi8TsvWsru1kKJmec3WxVNLI
         TJnA==
X-Gm-Message-State: AOAM533O9FybViTga4M0rECtpjl1ZjrhNHnc+YU4qie8M9Cb/GJ0eIgL
        1n9kIbEL96CKTfWTtbnB6Pe9tAuehARQyS8ZScbkSwBSH4Q=
X-Google-Smtp-Source: ABdhPJzbL1ke9geoFZR/f+VEBhnoIaAb/U4CLoY6acRJ2ip3Tlo8GdKSCEA0zQzpPM8yo2/DFDO0RlBa+uEN/mbu/fY=
X-Received: by 2002:a25:d213:: with SMTP id j19mr33717553ybg.20.1630438026156;
 Tue, 31 Aug 2021 12:27:06 -0700 (PDT)
MIME-Version: 1.0
References: <YSf/Mps9E77/6kZX@lunn.ch> <CAGETcx_h6moWbS7m4hPm6Ub3T0tWayUQkppjevkYyiA=8AmACw@mail.gmail.com>
 <YSg+dRPSX9/ph6tb@lunn.ch> <CAGETcx_r8LSxV5=GQ-1qPjh7qGbCqTsSoSkQfxAKL5q+znRoWg@mail.gmail.com>
 <YSjsQmx8l4MXNvP+@lunn.ch> <CAGETcx_vMNZbT-5vCAvvpQNMMHy-19oR-mSfrg6=eSO49vLScQ@mail.gmail.com>
 <YSlG4XRGrq5D1/WU@lunn.ch> <CAGETcx-ZvENq8tFZ9wb_BCPZabpZcqPrguY5rsg4fSNdOAB+Kw@mail.gmail.com>
 <YSpr/BOZj2PKoC8B@lunn.ch> <CAGETcx_mjY10WzaOvb=vuojbodK7pvY1srvKmimu4h6xWkeQuQ@mail.gmail.com>
 <YS4rw7NQcpRmkO/K@lunn.ch>
In-Reply-To: <YS4rw7NQcpRmkO/K@lunn.ch>
From:   Saravana Kannan <saravanak@google.com>
Date:   Tue, 31 Aug 2021 12:26:30 -0700
Message-ID: <CAGETcx_QPh=ppHzBdM2_TYZz3o+O7Ab9-JSY52Yz1--iLnykxA@mail.gmail.com>
Subject: Re: [PATCH v1 1/2] driver core: fw_devlink: Add support for FWNODE_FLAG_BROKEN_PARENT
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        Alvin Sipraga <ALSI@bang-olufsen.dk>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 31, 2021 at 6:16 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > > I must admit, my main problem at the moment is -rc1 in two weeks
> > > time. It seems like a number of board with Ethernet switches will be
> > > broken, that worked before. phy-handle is not limited to switch
> > > drivers, it is also used for Ethernet drivers. So it could be, a
> > > number of Ethernet drivers are also going to be broken in -rc1?
> >
> > Again, in those cases, based on your FEC example, fw_devlink=on
> > actually improves things.
>
> Debatable. I did some testing. As expected some boards with Ethernet
> switches are now broken.

To clarify myself, I'm saying the patch to parse "ethernet" [8] will
make things better with fw_devlink=on for FEC. Not sure if you tested
that patch or not.

And yes, "phy-handle" will make things worse for switches because it
has two issues that need to be fixed. One is this deferred probe thing
for which I gave a patch in the previous email and the other is what
Marek reported (fix in the works). So can you revert "phy-handle"
support and test with [8] and you should see things be better with
fw_devlink=on.

[8] - https://lore.kernel.org/netdev/CAGETcx9=AyEfjX_-adgRuX=8a0MkLnj8sy2KJGhxpNCinJu4yA@mail.gmail.com/

> Without fw_devlink=on, some boards are not
> optimal, but they actually work. With it, they are broken.
>
> I did a bisect, and they have been broken since:
>
> ea718c699055c8566eb64432388a04974c43b2ea is the first bad commit
> commit ea718c699055c8566eb64432388a04974c43b2ea
> Author: Saravana Kannan <saravanak@google.com>
> Date:   Tue Mar 2 13:11:32 2021 -0800
>
>     Revert "Revert "driver core: Set fw_devlink=on by default""
>
>     This reverts commit 3e4c982f1ce75faf5314477b8da296d2d00919df.
>
>     Since all reported issues due to fw_devlink=on should be addressed by
>     this series, revert the revert. fw_devlink=on Take II.
>
>     Signed-off-by: Saravana Kannan <saravanak@google.com>
>     Link: https://lore.kernel.org/r/20210302211133.2244281-4-saravanak@google.com
>     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
>  drivers/base/core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> So however it is fixed, it needs to go into stable, not just -rc1.

Not sure what was the tip of the tree with which you bisected. For
example, if phy-handle broke things, bisect could still point at this
patch above depending on whether the first bisect is good/bad. Because
reverting this patch effectively disabled phy-handle parsing too.

To be clear, I'm not saying things aren't broken. I'm just pointing
out some nuances with the bisect that we need to be aware of.

> > Again, it's not a widespread problem as I explained before.
> > fw_devlink=on has been the default for 2 kernel versions now. With no
> > unfixed reported issues.
>
> Given that some Ethernet switches have been broken all that time, i
> wonder what else has been broken? Normally, the kernel which is
> release in December becomes the next LTS. It then gets picked up by
> the distros and more wide spread tested. So it could be, you get a
> flood of reports in January and February about things which are
> broken. This is why i don't think you should be relying on bug
> reports, you should be taking a more proactive stance and trying to
> analyse the DTB blobs.

As I mentioned earlier, just looking at DTB doesn't tell me much
because the driver could still be fine depending on how it's written.
Also, I don't have an easy way to do this. If I find a way, I'll do
it.

Btw, most bug reports that have been raised have been fixed with
generic fixes that address general DT patterns. For example,
fw_devlink has cycle detection built in, has support for devices that
never get probed, etc. Enabling fw_devlink=on and handling bug reports
with generic fixes has worked well so far to get fw_devlink to where
it is today. I've tried to be very quick in responding to fw_devlink
issues -- and that has worked out so far and hopefully it'll continue
to work out.

> I will spend some time trying out your proposed fix. See if they are a
> quick fix for stable.

Thanks for testing it out. And worst case, we'll revert phy-handle support.


-Saravana
