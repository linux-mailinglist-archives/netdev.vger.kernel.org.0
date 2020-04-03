Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B956819D940
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 16:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391007AbgDCOgf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 10:36:35 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:34584 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728066AbgDCOgf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 10:36:35 -0400
Received: by mail-ed1-f66.google.com with SMTP id o1so9550603edv.1
        for <netdev@vger.kernel.org>; Fri, 03 Apr 2020 07:36:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dLYxFS/lHjikx1GU+rKGyo4p+aUj5IVG7njebZp2DQs=;
        b=lOP6qq+H65qWwsABM6qfyhlqAg38kxGYUQPTZ+NU1Yws+fhsBy5I8gUS70g9lheJ2E
         pEiDbjBrwYxfJaCG6H9RKFUfKsNIUTeccsYdIAuD+TJuMqoiYFfrTZXT+TndJb7czo46
         QkABe+rhq83Qiq4PefNKDwgn+zjmSqT/2PwjUWjPz7AwIC/xX1qqX7bxdTIiQWXTrB99
         Og3Bm9oyVDhcmwzwaOC8/Aot0JJWxoBZlj/FmtKKPIoWaQGfNaORyzJeuYkjhPBHyILp
         U9YsNoIat1tmjLOF1RJ5jYAdcyyJycyyyeAvci39ZW4tQ2GJ0MDTQP43aJhaiNI9R1ra
         6yWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dLYxFS/lHjikx1GU+rKGyo4p+aUj5IVG7njebZp2DQs=;
        b=uMDLwqsKWgpS9DBsDcJVomQSRCTarG6vr5KNvl8da3K70HeqKC7GL5PGZUDnpFAMvm
         SAU7tw2DGhZbIRc2IW6VwyUBCxReYj762RvQfKnNNNzrjBJyPox72bWl0OhiqLykdAXB
         m0vMQxmxeUGrLN6hpRQq4ZSxsn5Y6YSHvrLZzBTSAd16ylGzTNMlEA7OUmCSSnX0eVd0
         cwfEgb0eNpLs12H+GlkzsMofjaH6UCc8PLzJu86ZQSOsnQqJwJx0AFRcr/+YU73JDJKe
         GdPZy4fvFxrqlL+XCuwiDCqwTKBwJn+RvcdMxN9MPx2eYzhleP3ZxJ6OnX5BbezHltt8
         /8qw==
X-Gm-Message-State: AGi0PuYovJHMdxnUYUOdqDwxyPu4al4ag0ij/ggIsBWEhR2XJXBZE/yy
        n1cYIifvJS1W58kYIoNJybRucWQPIRYUDy7kepc=
X-Google-Smtp-Source: APiQypJpi+kL5/olhpdNmVxYp8klgvhKR2cKoIDQ/zjzYUoj5vbxjGpSPiMtdrpyEMhILgGXzeqS4BhDZiJODSvRJn0=
X-Received: by 2002:aa7:d602:: with SMTP id c2mr8219172edr.118.1585924592910;
 Fri, 03 Apr 2020 07:36:32 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.DEB.2.21.2004031542220.2694@hadrien>
In-Reply-To: <alpine.DEB.2.21.2004031542220.2694@hadrien>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 3 Apr 2020 17:36:21 +0300
Message-ID: <CA+h21hrP-0Tdpqje-xbPHmh+v+zndsFyxaEfadMwdAHY+9QK+g@mail.gmail.com>
Subject: Re: question about drivers/net/dsa/sja1105/sja1105_main.c
To:     Julia Lawall <julia.lawall@inria.fr>
Cc:     netdev <netdev@vger.kernel.org>, Joe Perches <joe@perches.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Julia,

On Fri, 3 Apr 2020 at 16:46, Julia Lawall <julia.lawall@inria.fr> wrote:
>
> Hello,
>
> The function sja1105_static_config_reload in sja1105_main.c contains the
> code:
>
>                 if (!an_enabled) {
>                         int speed = SPEED_UNKNOWN;
>
>                         if (bmcr & BMCR_SPEED1000)
>                                 speed = SPEED_1000;
>                         else if (bmcr & BMCR_SPEED100)
>                                 speed = SPEED_100;
>                         else if (bmcr & BMCR_SPEED10)
>                                 speed = SPEED_10;
>
>                         sja1105_sgmii_pcs_force_speed(priv, speed);
>                 }
>
> The last test bmcr & BMCR_SPEED10 does not look correct, because according
> to include/uapi/linux/mii.h, BMCR_SPEED10 is 0.  What should be done
> instead?
>
> thanks,
> julia

Thanks for pointing out, you raise a good point.
Correct usage would be:

include/uapi/linux/mii.h:
#define BMCR_SPEED_MASK 0x2040

drivers/net/dsa/sja1105/sja1105_main.c:
                         int speed = SPEED_UNKNOWN;

                         if (bmcr & BMCR_SPEED_MASK == BMCR_SPEED1000)
                                 speed = SPEED_1000;
                         else if (bmcr & BMCR_SPEED_MASK == BMCR_SPEED100)
                                 speed = SPEED_100;
                         else if (bmcr & BMCR_SPEED_MASK == BMCR_SPEED10)
                                 speed = SPEED_10;

but the BMCR_SPEED_MASK doesn't exist, it looks like. I believe that
is because drivers (or the PHY library) don't typically need to read
the speed from the MII_BMCR register, they just need to write it. If
the PHY library maintainers think there is any value in defining
BMCR_SPEED_MASK as part of the UAPI, we can do that. Otherwise, the
definition can be restricted to drivers/net/dsa/sja1105/sja1105.h.

Thanks,
-Vladimir
