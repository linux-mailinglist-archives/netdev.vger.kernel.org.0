Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0563B40CAE6
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 18:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbhIOQqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 12:46:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbhIOQqO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 12:46:14 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E729C061764
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 09:44:55 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id i12so6939977ybq.9
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 09:44:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SoEro/pOot3RDQ6oHi20QrcukaWZiRl8hEvD0rocWMM=;
        b=h84HDKGSfFbvCCheUBvsV5ZXDbwYVjGSIKtBjTdvax/i4LEqGK3JrAEhwzUpMhZyBS
         cSnWQtBb2krYDxK7KjZWFWVtR5cq55F+pXvJq22D1JOhDVuahKYAYTsKWqDKmuLkN/+t
         UuaakJFAQYaaB1mzq4SgCTkJXuMyLCGT/7kvxl+n2mxzgUHyfscnJJSQtQ38zeQ9u+Le
         LT8i1jv/j2J0P674H5M+bvBFngQT80M/Yy1lkDIvza7zhdACAKZmZHOfRJ+nwM0+wf8z
         K+ZMxh6Vr7320YJinCwXo/8H7lQVHMTREPlgXgXK9sn6FTQZGlrFfiBpuk/Ecqc4XBtK
         FS2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SoEro/pOot3RDQ6oHi20QrcukaWZiRl8hEvD0rocWMM=;
        b=rN+65NlhbtAcS0i/VUfk41SQHFEbmylU34rQY6JOEqwIPuq2lsEvWLA1N2RnG7kKaO
         OgYnKwnRT7Q6UWH5kNvOOt9YCWiM9q4Z6S+znbg47KH5QSjBzEjYyCfGsBHQm0gBXMJ1
         ec/GbJQEb0RsuAZ/N5HJzhUsUUcm0q29sLihLvrMDtam8FNzbCxi/lqlFhgkOZs0mh3V
         OhyJJWzjya7ZXFaguC1e0Htvwsh7X8TdD6TPNTl0yxxThrUhZTmzwCkAwCV0zRFyD/X8
         2iPImAPdY94GdegquTVxBZbpuwTWrFHZM2nOuO4OS9TtTbRrNCtrTa9jjByucAyKy/VC
         tGag==
X-Gm-Message-State: AOAM530Ersetw/yJNmP80fGT38oHPKvcrml0LExQAFYt1om6KYiFGyuX
        JDcs76w/EuHb/L42kKj8jViWET2lGDLzDVeXUuB5Lw==
X-Google-Smtp-Source: ABdhPJynAzZvXI3gSdy0YPIzVlH0PpPiIWWFob0j+Akw0Mx/NnZ6oq39PZR9NHlAxE9NtA1aCYvps4T2VvDzG9qPvCs=
X-Received: by 2002:a25:2b07:: with SMTP id r7mr1047682ybr.296.1631724294182;
 Wed, 15 Sep 2021 09:44:54 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20210915081147eucas1p130ee8d5f1910ea3be265d37e4236a606@eucas1p1.samsung.com>
 <20210915081139.480263-1-saravanak@google.com> <9c437d41-05b2-8e22-a537-d9aa7865f01b@samsung.com>
In-Reply-To: <9c437d41-05b2-8e22-a537-d9aa7865f01b@samsung.com>
From:   Saravana Kannan <saravanak@google.com>
Date:   Wed, 15 Sep 2021 09:44:16 -0700
Message-ID: <CAGETcx_C8N8r4nQiUU1eGdkE3E1b=wxUTFEtKhSfobqrdDrTQw@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] fw_devlink improvements
To:     Marek Szyprowski <m.szyprowski@samsung.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Vladimir Oltean <olteanv@gmail.com>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 15, 2021 at 1:44 AM Marek Szyprowski
<m.szyprowski@samsung.com> wrote:
>
> Hi Saravana,
>
> On 15.09.2021 10:11, Saravana Kannan wrote:
> > Patches ready for picking up:
> > Patch 1 fixes a bug in fw_devlink.
> > Patch 2-4 are meant to make debugging easier
> > Patch 5 and 6 fix fw_devlink issues with PHYs and networking
>
> Is this patchset supposed to fix the PHY related issues I've experienced
> or does it also require the Andrew's patch for 'mdio-parent-bus'? If the
> first, then applying only this patchset on top of today's linux-next
> doesn't fix the ethernet issue on my Amlogic SoC based test boards.

Marek,

The issue you hit was actually a general issue with fw_devlink and
that's fixed by Patch 1. But I also needed to revert the phy-handle
patch for other reasons (see commit text) and that fixes the issue you
were hitting without needing the 'mdio-parent-bus' patch.
https://lore.kernel.org/lkml/20210915081933.485112-1-saravanak@google.com/

When I eventually bring back phy-handle support, I'll need the
'mdio-parent-bus' to not break your use case.

Hope that clarifies things.

-Saravana

>
> > Andrew,
> >
> > I think Patch 5 and 6 should be picked up be Greg too. Let me know if
> > you disagree.
> >
> > -Saravana
> >
> > Cc: John Stultz <john.stultz@linaro.org>
> > Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> > Cc: Rob Herring <robh+dt@kernel.org>
> > Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> > Cc: Andrew Lunn <andrew@lunn.ch>
> > Cc: Vladimir Oltean <olteanv@gmail.com>
> >
> > v1->v2:
> > - Added a few Reviewed-by and Tested-by tags
> > - Addressed Geert's comments in patches 3 and 5
> > - Dropped the fw_devlink.debug patch
> > - Added 2 more patches to the series to address other fw_devlink issues
> >
> > Thanks,
> > Saravana
> >
> > Saravana Kannan (6):
> >    driver core: fw_devlink: Improve handling of cyclic dependencies
> >    driver core: Set deferred probe reason when deferred by driver core
> >    driver core: Create __fwnode_link_del() helper function
> >    driver core: Add debug logs when fwnode links are added/deleted
> >    driver core: fw_devlink: Add support for FWNODE_FLAG_NEEDS_CHILD_BOUND_ON_ADD
> >    net: mdiobus: Set FWNODE_FLAG_NEEDS_CHILD_BOUND_ON_ADD for mdiobus parents
> >
> >   drivers/base/core.c        | 90 ++++++++++++++++++++++++++------------
> >   drivers/net/phy/mdio_bus.c |  4 ++
> >   include/linux/fwnode.h     | 11 +++--
> >   3 files changed, 75 insertions(+), 30 deletions(-)
> >
> Best regards
> --
> Marek Szyprowski, PhD
> Samsung R&D Institute Poland
>
