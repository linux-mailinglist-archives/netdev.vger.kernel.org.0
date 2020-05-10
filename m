Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 183E01CCA08
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 12:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728098AbgEJKCb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 06:02:31 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:36215 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725994AbgEJKCa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 May 2020 06:02:30 -0400
Received: by mail-oi1-f195.google.com with SMTP id x7so11643762oic.3;
        Sun, 10 May 2020 03:02:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uhGhXkwAnudsO1fllJWrpsXdeLLIzy97nFY9CXO1+nw=;
        b=OAy+hG6hd1y/HtIUzzOIJQb//g+Wr30ddCKZCigY4tdApsP2QaIQJ6TBMGfmxfCpN4
         /XqvJOq8MOcxe8UxdBFK01i1GNVvzkMU8Q5TMMghiQucz5HBUjyLlp9G9UoklVBREgjg
         21tB/qoUDm6nhWOVFLhrHj7SdOBqeQLAd1qTFmoqxcJt7AavXWjSN2SBGvxFus7UMj4o
         H0d8iOuEPRob8IIWRudRH+ocAzHcpbWWyYBn/MkoIisX4N5ypThQXnY9Q+oTCeXHID6g
         gpZfZ2sQUsFFoG2ZuEBBzvXWf2nY/ovztUKo2Hhxe4eTg6EfJVtTRU9q+e8JzX6JimYc
         fgKg==
X-Gm-Message-State: AGi0PuZYYUYxFH4eNTCjyZ+tVWncrvKXElB8uFTsAKD+/JBsqjAfbn2L
        l23it4TPdZe4U6Oj/f5EIQBKAcszswgcoLske9w=
X-Google-Smtp-Source: APiQypI6MNOlMp5xNWwpK2JOi1MxHLYjrx64et3fqx4JVNC9XxBJFG/hK3FNkiB6iaWh1YqlXk9JjJ7Uj8XOOec3M4Q=
X-Received: by 2002:aca:f541:: with SMTP id t62mr15608111oih.148.1589104949874;
 Sun, 10 May 2020 03:02:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200508223216.6611-1-f.fainelli@gmail.com> <CAMuHMdU2A1rzqsnNZFt-Gd+ZO5qc6Mzeyunn-LXpbxk_6zq-Ng@mail.gmail.com>
 <ebac4532-6dae-5609-9629-ba10197671c3@gmail.com>
In-Reply-To: <ebac4532-6dae-5609-9629-ba10197671c3@gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Sun, 10 May 2020 12:02:18 +0200
Message-ID: <CAMuHMdVKAjh1TyNOFdNP_zXy8RNU8kD-Saoqha+wjcrR0v5YvQ@mail.gmail.com>
Subject: Re: [PATCH net] net: broadcom: Imply BROADCOM_PHY for BCMGENET
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Stefan Wahren <wahrenst@gmx.net>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tal Gilboa <talgi@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Andy Gospodarek <gospo@broadcom.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On Sat, May 9, 2020 at 7:12 PM Florian Fainelli <f.fainelli@gmail.com> wrote:
> On 5/9/2020 12:38 AM, Geert Uytterhoeven wrote:
> > On Sat, May 9, 2020 at 12:32 AM Florian Fainelli <f.fainelli@gmail.com> wrote:
> >> The GENET controller on the Raspberry Pi 4 (2711) is typically
> >> interfaced with an external Broadcom PHY via a RGMII electrical
> >> interface. To make sure that delays are properly configured at the PHY
> >> side, ensure that we get a chance to have the dedicated Broadcom PHY
> >> driver (CONFIG_BROADCOM_PHY) enabled for this to happen.
> >
> > I guess it can be interfaced to a different external PHY, too?
>
> Yes, although this has not happened yet to the best of my knowledge.
>
> >
> >> Fixes: 402482a6a78e ("net: bcmgenet: Clear ID_MODE_DIS in EXT_RGMII_OOB_CTRL when not needed")
> >> Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
> >> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> >
> >> --- a/drivers/net/ethernet/broadcom/Kconfig
> >> +++ b/drivers/net/ethernet/broadcom/Kconfig
> >> @@ -69,6 +69,7 @@ config BCMGENET
> >>          select BCM7XXX_PHY
> >>          select MDIO_BCM_UNIMAC
> >>          select DIMLIB
> >> +       imply BROADCOM_PHY if ARCH_BCM2835
> >
> > Which means support for the BROADCOM_PHY is always included
> > on ARCH_BCM2835, even if a different PHY is used?
>
> It is included by default on  and can be deselected if needed, which is
> exactly what we want here, a sane default, but without the inflexibility
> of "select".

I stand corrected: I can confirm the "imply" no longer selects the target
symbol, but merely changes the default.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
