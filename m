Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1B04DC644
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 15:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439443AbfJRNiK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 09:38:10 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:39219 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728150AbfJRNiJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 09:38:09 -0400
Received: by mail-ed1-f68.google.com with SMTP id a15so4586686edt.6;
        Fri, 18 Oct 2019 06:38:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c1TiVRDzq/ZhR78AYJMJD0wbL7b8cjQkHmyKijoEJ04=;
        b=qhfoQh1m/XU4lEWOsNmjHpHy1uYe+0rA4PrsNdn/oNCZ6WDGmxwfGv8NNC4ggwzDqO
         IKMos0ZO0K69hcXuXl4Lib5LJUP/fOCfqWf0ACydUVH+ncB/FvMk8IF1ZP2XfB5TXD1B
         R89kGfrbXjq7LIr/S1IlrlgrdSjCKAmSYLJKG4gMhaCIK6v1SJ8/JGdi5zQabV5bWvmG
         soVrWYhCwzT5tikUiZnldU2h9Bx6sZcfM4Nz/a6QHos9BSprH2aU6AR/mDljc50PkM9h
         6Fehdx3SxB7cUgchFnQ7uSJ9pnFzKWSgXx9iXJnV4MUXexpjL4VlygB/36JiiEN9gQMk
         pFQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c1TiVRDzq/ZhR78AYJMJD0wbL7b8cjQkHmyKijoEJ04=;
        b=Y7WeMh76DnvJsJKQnbaWYFn8A5kCsgf0cdzjDD99rJTC7nNElW0J5LiXhiXYxNnRvL
         6FJ1+y1BcxTSmJm5bN/YhzaM/Ha2CMjU9CXCG4PdxOpL5NPbeaSQFgsLwTrNRZHtIssH
         Zb2KpwXj+sYtWxKZ9gRXppBKJT3GnT+/9gebwfOOCaysWw779fYfjfGyR/oAaCH3rSOh
         kp2o8iMHDm+Oy09t9t50gAJZKZw992qaKOCTLQFHbTqmAyYyoF5dECG73LVqFhAgzatH
         yPLfmakNdJ2hTnUPqkt+Wb/7EXLON+tA7Ru6mzuRmsZKiWmTj8rrRlEAA+2TihzyR6UT
         oehg==
X-Gm-Message-State: APjAAAWlQhoeYGAQ5ILUxsrZgRQ0dN24a17w4uhGOppVijtBY+RwhYcq
        5jZpnnxa4U39NMViEkQUmSdTrI8jffksGj7nuiI=
X-Google-Smtp-Source: APXvYqxbbHx3cqXKCk7rD36HLI+nLI1W6WoGHc/1fSfj75hAgNNTxZTntlNF+EiPSRdkAxp3tfBUxW+UubOqsjH1dOE=
X-Received: by 2002:a17:906:8391:: with SMTP id p17mr8356503ejx.216.1571405887252;
 Fri, 18 Oct 2019 06:38:07 -0700 (PDT)
MIME-Version: 1.0
References: <20191015224953.24199-1-f.fainelli@gmail.com> <20191015224953.24199-3-f.fainelli@gmail.com>
 <4feb3979-1d59-4ad3-b2f1-90d82cfbdf54@gmail.com> <c4244c9a-28cb-7e37-684d-64e6cdc89b67@gmail.com>
 <CA+h21hrLHe2n0OxJyCKTU0r7mSB1zK9ggP1-1TCednFN_0rXfg@mail.gmail.com>
 <20191018130121.GK4780@lunn.ch> <CA+h21hoPrwcgz-q=UROAu0PC=6JbKtbdPhJtZg5ge32_2xJ3TQ@mail.gmail.com>
 <20191018132316.GI25745@shell.armlinux.org.uk>
In-Reply-To: <20191018132316.GI25745@shell.armlinux.org.uk>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 18 Oct 2019 16:37:55 +0300
Message-ID: <CA+h21hqVZ=LF3bQGtqFh4uMu6AhNFcrwQuUcEH-Fc1VrWku-eg@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] net: phy: Add ability to debug RGMII connections
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, cphealy@gmail.com,
        Jose Abreu <joabreu@synopsys.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Oct 2019 at 16:23, Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> On Fri, Oct 18, 2019 at 04:09:30PM +0300, Vladimir Oltean wrote:
> > Hi Andrew,
> >
> > On Fri, 18 Oct 2019 at 16:01, Andrew Lunn <andrew@lunn.ch> wrote:
> > >
> > > > Well, that's the tricky part. You're sending a frame out, with no
> > > > guarantee you'll get the same frame back in. So I'm not sure that any
> > > > identifiers put inside the frame will survive.
> > > > How do the tests pan out for you? Do you actually get to trigger this
> > > > check? As I mentioned, my NIC drops the frames with bad FCS.
> > >
> > > My experience is, the NIC drops the frame and increments some the
> > > counter about bad FCS. I do very occasionally see a frame delivered,
> > > but i guess that is 1/65536 where the FCS just happens to be good by
> > > accident. So i think some other algorithm should be used which is
> > > unlikely to be good when the FCS is accidentally good, or just check
> > > the contents of the packet, you know what is should contain.
> > >
> > > Are there any NICs which don't do hardware FCS? Is that something we
> > > realistically need to consider?
> > >
> > > > Yes, but remember, nobody guarantees that a frame with DMAC
> > > > ff:ff:ff:ff:ff:ff on egress will still have it on its way back. Again,
> > > > this all depends on how you plan to manage the rx-all ethtool feature.
> > >
> > > Humm. Never heard that before. Are you saying some NICs rewrite the
> > > DMAN?
> > >
> >
> > I'm just trying to understand the circumstances under which this
> > kernel thread makes sense.
> > Checking for FCS validity means that the intention was to enable the
> > reception of frames with bad FCS.
> > Bad FCS after bad RGMII setup/hold times doesn't mean there's a small
> > guy in there who rewrites the checksum. It means that frame octets get
> > garbled. All octets are just as likely to get garbled, including the
> > SFD, preamble, DMAC, etc.
> > All I'm saying is that, if the intention of the patch is to actually
> > process the FCS of frames before and after, then it should actually
> > put the interface in promiscuous mode, so that frames with a
> > non-garbled SFD and preamble can still be received, even though their
> > DMAC was the one that got garbled.
>
> Isn't the point of this to see which RGMII setting results in a working
> setup?
>
> So, is it not true that what we're after is receiving a _correct_ frame
> that corresponds to the frame that was sent out?
>

Only true if the MAC does not drop bad frames by itself. Then the FCS
check in the kernel thread is superfluous.

> Hence, if the DMAC got changed, it's irrelevent whether we received the
> packet or not - since "no packet" || "changed packet" = fail.
>
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
> According to speedtest.net: 11.9Mbps down 500kbps up
