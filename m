Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE4B3F923B
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 04:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244034AbhH0CMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 22:12:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231613AbhH0CMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 22:12:23 -0400
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56754C061757
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 19:11:35 -0700 (PDT)
Received: by mail-vs1-xe2d.google.com with SMTP id h29so3504769vsr.7
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 19:11:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nathanrossi.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/pTXWfBzPoSBuLIXB3TTD+KInYhfRFajXWqEQUhDSB0=;
        b=YMtKSLqHaU2d3mlQxjjvfR6Nn6dyXwD/JX0hS6bagBm+KG4jzawY3um+fjkhRallDV
         /RQgf5zLQ+QLBI/Nymi13cHiFpJSmXNqup5sJJD0ZVwXOQpzlGd+Z2+i8j+zd2QywGZG
         vOiOhiOWAoxi9w4LWXESAQUASiU+zAT4JnAwKGMi0RcVQw0euqGxpMfmaSuA+9UW9gkw
         rLKfRcouzYMqPVaXHK9ionGunpmm0u5seSLYZzB4LXvHIOdtJHbjs4KJYENxVNiP+OOX
         Y3p15ZLatWYfbhaW0gQuZmZl4s+oSN+HeXPFUJZS18MBLsHW/43uCFnwu7TCvuUuaJl8
         sEuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/pTXWfBzPoSBuLIXB3TTD+KInYhfRFajXWqEQUhDSB0=;
        b=Btve+ylv8X850molUR1OiIz7nJmH+9d/c08qvhisyQ+kb0sm+JbMxAxH1bEhCXKp78
         98VHwtn+Pkze/HbqL9N4iPVi4qJT5Q7Q7Zvi270mFjCgk5qSFYZzYxLVKdyE4i+zrQCl
         crdag24PhsrmZyrVEiZEyWWnthgLaVetknYn/5mUYO5iSRS9vvHXTW+IFeAow6VgqtKm
         jWBMR1h/dLRnqoVtj+bwdCL60D3fqgwi1zykTXC0xEbkbKE1M/wvEZ+SmH8jEoS9+YLn
         FwG5JOv+G9xfd+V4WGhfxOznx2ikvO/f5MDohtjPmog76Fw9ZPHrZmaEXiZWo8dXougV
         7TQg==
X-Gm-Message-State: AOAM533i/Q6oVx5dFpVzhEGA+cCG6L9MwqWu9tguYNOPTEhtq2JaNfI3
        1wdiTJ2RB5dgiUx+m5t2XaSUPSuAa67luPU1Wn+4i1ngejzMFs1ZtsU=
X-Google-Smtp-Source: ABdhPJxGMsEpvzBBA2y8FKwIHztIu1I4WI5uOGwMq2IiAuMagOF6b3vr9NALjSdE2PiZibGSTBDNRNj7EQJX+YBZoXA=
X-Received: by 2002:a67:a24f:: with SMTP id t15mr5378238vsh.25.1630030294396;
 Thu, 26 Aug 2021 19:11:34 -0700 (PDT)
MIME-Version: 1.0
References: <20210826071230.11296-1-nathan@nathanrossi.com> <20210826092511.GQ22278@shell.armlinux.org.uk>
In-Reply-To: <20210826092511.GQ22278@shell.armlinux.org.uk>
From:   Nathan Rossi <nathan@nathanrossi.com>
Date:   Fri, 27 Aug 2021 12:11:23 +1000
Message-ID: <CA+aJhH2mQFbF6nRPi5SCT4Nw3kb0JhxtFzthJC4TubFUsb_F4g@mail.gmail.com>
Subject: Re: [PATCH] net: phylink: Update SFP selected interface on
 advertising changes
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Nathan Rossi <nathan.rossi@digi.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 Aug 2021 at 19:25, Russell King (Oracle)
<linux@armlinux.org.uk> wrote:
>
> On Thu, Aug 26, 2021 at 07:12:30AM +0000, Nathan Rossi wrote:
> > From: Nathan Rossi <nathan.rossi@digi.com>
> >
> > Currently changes to the advertising state via ethtool do not cause any
> > reselection of the configured interface mode after the SFP is already
> > inserted and initially configured.
> >
> > While it is not typical to change the advertised link modes for an
> > interface using an SFP in certain use cases it is desirable. In the case
> > of a SFP port that is capable of handling both SFP and SFP+ modules it
> > will automatically select between 1G and 10G modes depending on the
> > supported mode of the SFP. However if the SFP module is capable of
> > working in multiple modes (e.g. a SFP+ DAC that can operate at 1G or
> > 10G), one end of the cable may be attached to a SFP 1000base-x port thus
> > the SFP+ end must be manually configured to the 1000base-x mode in order
> > for the link to be established.
> >
> > This change causes the ethtool setting of advertised mode changes to
> > reselect the interface mode so that the link can be established.
>
> This may be a better solution than the phylink_helper_basex_speed()
> approach used to select between 2500 and 1000 base-X, but the config
> needs to be validated after selecting a different interface mode, as
> per what phylink_sfp_config() does.

I will add this in a v2. But will wait to get your feedback on the below before
sending that out.

>
> I also suspect that this will allow you to select e.g. 1000base-X but
> there will be no way back to 10G modes as they will be masked out of
> the advertising mask from that point on, as the 1000base-X interface
> mode does not allow them.

Because only the advertising bitmap is changed it is possible to revert any
changes because the supported bitmap is not affected. Although I may be
misunderstanding the exact details of the issue you are describing?

Note, the phylink_sfp_config phylink_validate call after sfp_select_interface
does not modify the supported bitmap so adding that validate call in this change
will not affect the ability to reselect changed advertised bits.

I did some additional testing and noticed that the advertising mask is not
updated in phylink_sfp_config if supported does not change (e.g. SFP reinsert),
which leads to the advertising state mismatching (e.g. advertising at 1G, but
actually operating at 10G). This just needs to check if the advertising also
mismatches in phylink_sfp_config.

Thanks,
Nathan

>
> So, I think the suggested code is problematical as it stands.
>
> phylink_sfp_config() uses a multi-step approach to selecting the
> interface mode for a reason - first step is to discover what the MAC
> is capable of in _any_ interface mode using _NA to reduce the supported
> and advertised mask down, and then to select the interface from that.
> I'm not entirely convinced that is a good idea here yet though.
>
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
