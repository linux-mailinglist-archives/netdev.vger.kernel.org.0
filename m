Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 733C431D4B8
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 05:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231393AbhBQEta (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 23:49:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbhBQEtX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 23:49:23 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5181C061574
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 20:48:43 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id v1so15952011wrd.6
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 20:48:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nathanrossi.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FPpZYL80ZXGhOaYrDpjFtNkAfVAObPokn1JA454oT50=;
        b=Qw1sV466TRCFi4RnNbR6Y2RtF87P8a/RHzPNUeK0MLH3ypnoyqU/7Mi71r8qZ3N31d
         N+jd945uxOBqf0sUKnz2bcjbjIhlrPeQ1hkAenbjWFl5oQoxVAUHZxLlAN7KoF5763Qi
         VhwYW4poOMvEGAZSecEyTr27iZX2VDrH4q9jNnfaLRf1uY95ACzlr+gkI2iYJBLNihJB
         jQrZ1ZM7GLvda1JcqFLM8W+r5Cfsm4TzyKK4FgN9xJnEfvFAKQ+UAEuRDVNW1xXFWPab
         4jgXLlENXke6FZ9B8+Z2HyPOSfiLpb1I+x0HyXNOd8OFwjr+s7fgqumyQRsywPm5nSU+
         z/Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FPpZYL80ZXGhOaYrDpjFtNkAfVAObPokn1JA454oT50=;
        b=PdOkN4Xr7uiJJYfyLpxxDJINHE+ocIlUZMezylSnXoi6PSisAxxqmyD6Wsc4gl2LjH
         V8JNXBY6h4hl1PuTYCiu5u9hQUVxliptZRda7di7M8EVV3u5R9LNpjv8Jzxvdoj5GStr
         Gk5t1yDqLKQeUnN9yW2qXYNl8J0J5WqDw4eYW5K8xi7mHOY1NRLQWQw4/U8l7svkF20b
         M38+EpOM6K2pPiR/MbdFd7u6fR3TNqsC3pvQp/p4kNb2XRaWrGkmf67PboOeyRG6bB4W
         bSJc2MddlDv9JycZbjN71avD6jqMc03b2Q52fvYKEi6bOZPlfWLL2YjFOG3RkImavkSI
         s/Sg==
X-Gm-Message-State: AOAM5310+zIYmQM0zjCoHj9vYfeAwvgEN4IV7GHXTYRyjrXS3of+iAqh
        LC3+vZ1IXGn+EAW+XpTmmfqX6HH5CcFB3BjV8/o9Rg==
X-Google-Smtp-Source: ABdhPJwBeKYh5fbOf7NudQ6wUduv4+2ZupYr/7PU606LKf49sMVS17WK7gJ82+Lb/F0UCwg+IyUiZWGnW0gBtLmCbuI=
X-Received: by 2002:a05:6000:4e:: with SMTP id k14mr26947801wrx.281.1613537322429;
 Tue, 16 Feb 2021 20:48:42 -0800 (PST)
MIME-Version: 1.0
References: <20210215070218.1188903-1-nathan@nathanrossi.com>
 <YCvDVEvBU5wabIx7@lunn.ch> <55c94cf4-f660-f0f5-fb04-f51f4d175f53@gmail.com>
 <CA+aJhH3SE1s8P+srhO_-Za3E0KdHVn2_bK=Kf+-Jtbm1vJNm1w@mail.gmail.com> <YCyLWhk5zV4Z5Crv@lunn.ch>
In-Reply-To: <YCyLWhk5zV4Z5Crv@lunn.ch>
From:   Nathan Rossi <nathan@nathanrossi.com>
Date:   Wed, 17 Feb 2021 14:48:30 +1000
Message-ID: <CA+aJhH1VeCkk4JB02XVbvgJaM-Ua5i80qaNR7EVUoF-eBx_y5Q@mail.gmail.com>
Subject: Re: [PATCH] of: of_mdio: Handle properties for non-phy mdio devices
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        Nathan Rossi <nathan.rossi@digi.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Feb 2021 at 13:19, Andrew Lunn <andrew@lunn.ch> wrote:
>
> > > The patch does make sense though, Broadcom 53125 switches have a broken
> > > turn around and are mdio_device instances, the broken behavior may not
> > > show up with all MDIO controllers used to interface though. For the
> >
> > Yes the reason we needed this change was to enable broken turn around,
> > specifically with a Marvell 88E6390.
>
> Ah, odd. I've never had problems with the 6390, either connected to a
> Freecale FEC, or the Linux bit banging MDIO bus.
>
> What are you using for an MDIO bus controller? Did it already support
> broken turn around, or did you need to add it?

Using bit bang MDIO to access the 88e6390. I suspect the issue is
specific to the board design, another similar design we have uses bit
bang MDIO but a 88e6193x switch and does not have any issue with turn
around.

Regards,
Nathan
