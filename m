Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47CEF40817E
	for <lists+netdev@lfdr.de>; Sun, 12 Sep 2021 22:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236342AbhILUae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Sep 2021 16:30:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236311AbhILUab (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Sep 2021 16:30:31 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28096C06175F;
        Sun, 12 Sep 2021 13:29:16 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id n10so11108384eda.10;
        Sun, 12 Sep 2021 13:29:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nDiAjJkyqCsELYW0aSzatGXsLEfOimLAHoAsEf0YhTo=;
        b=TLjlk0wDcQ3/zoJe9KWiL8augt8//w8eLROYIVaHADRT/inwkXxW0t0oc4nfJme/g5
         iJ+56TYDJM9ySNqJ8h25EKoNJ5UtLu/6fsq5ZZSVYfom8eAEm6qY29k2ZHKnDkMhOIvE
         pfsMiDhKoM6vwMU0PIQueal82Y4lrK0XUdf7DNsoXvqCbkY0H0ENgYUIgK9nZadAGxPI
         4E01Pamra6Mx31s40sLX+9Xq5SZ5f9iL+8xJ4y5wpgpQg431Tq3k9GEZ8/eLN1XW4iEl
         dKdJD6ipsZWLtAn5cFyc+fgs223W6tCYeeRua0TN1/HAFZ04+CXG7lLO7jUEPqqEuPZo
         ysrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nDiAjJkyqCsELYW0aSzatGXsLEfOimLAHoAsEf0YhTo=;
        b=8BfHzYDAdFIxdYEaV0oqZDCNq+oyXDgx8y23ilXCdUApvWKaE9POFZ1jBvcCiBzuUu
         o4/L6A4BEUCl8LN2B8PFV1g0PJT5RAZykgcMFH+iIOokGTstZpZo9qI2TS0VcmpljJdk
         4CACHQzF72TE4gqioG+sS3iGFptutqfcqMmpbBnHUJcVlq6HK+BSkE6FRglHy3xCpYdd
         9E1KcLfOYlz1iXGOOU32f6DZ33hSupJVMjgDmrqE7U87SMa9HGJy7j5H1QIw8jGvLv9D
         jEzXDIkl++aoNTuOFBITjYSOqZ5tlezUupnaO4DQZ594NwPtKxKIPoeIvWeJNLlVj1eB
         S20w==
X-Gm-Message-State: AOAM530EbFGPK3IsWPkkMmKuQoMCVbQXM2fOA64KZM0drjNb3ZPu2cNE
        0qkUiNxD7U1VOo7Nw2umD50=
X-Google-Smtp-Source: ABdhPJy9obgdlbIv+kBC4v7uDrCA1dGNJPuefkh4eizMm1cWDxYr63HzegGy96XFswBmPQaF1HHVug==
X-Received: by 2002:a05:6402:648:: with SMTP id u8mr9637158edx.394.1631478554638;
        Sun, 12 Sep 2021 13:29:14 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id 90sm2761308edc.36.2021.09.12.13.29.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Sep 2021 13:29:14 -0700 (PDT)
Date:   Sun, 12 Sep 2021 23:29:13 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Saravana Kannan <saravanak@google.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>, p.rosenberger@kunbus.com,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        vivien.didelot@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Fix for KSZ DSA switch shutdown
Message-ID: <20210912202913.mu3o5u2l64j7mpwe@skbuf>
References: <trinity-85ae3f9c-38f9-4442-98d3-bdc01279c7a8-1631193592256@3c-app-gmx-bs01>
 <20210909154734.ujfnzu6omcjuch2a@skbuf>
 <8498b0ce-99bb-aef9-05e1-d359f1cad6cf@gmx.de>
 <2b316d9f-1249-9008-2901-4ab3128eed81@gmail.com>
 <5b899bb3-ed37-19ae-8856-3dabce534cc6@gmx.de>
 <20210909225457.figd5e5o3yw76mcs@skbuf>
 <35466c02-16da-0305-6d53-1c3bbf326418@gmail.com>
 <YTtG3NbYjUbu4jJE@lunn.ch>
 <20210910145852.4te2zjkchnajb3qw@skbuf>
 <53f2509f-b648-b33d-1542-17a2c9d69966@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53f2509f-b648-b33d-1542-17a2c9d69966@gmx.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 12, 2021 at 10:19:24PM +0200, Lino Sanfilippo wrote:
> 
> Hi,
> 
> On 10.09.21 at 16:58, Vladimir Oltean wrote:
> > On Fri, Sep 10, 2021 at 01:51:56PM +0200, Andrew Lunn wrote:
> >>> It does not really scale but we also don't have that many DSA masters to
> >>> support, I believe I can name them all: bcmgenet, stmmac, bcmsysport, enetc,
> >>> mv643xx_eth, cpsw, macb.
> >>
> >> fec, mvneta, mvpp2, i210/igb.
> >
> > I can probably double that list only with Freescale/NXP Ethernet
> > drivers, some of which are not even submitted to mainline. To name some
> > mainline drivers: gianfar, dpaa-eth, dpaa2-eth, dpaa2-switch, ucc_geth.
> > Also consider that DSA/switchdev drivers can also be DSA masters of
> > their own, we have boards doing that too.
> >
> > Anyway, I've decided to at least try and accept the fact that DSA
> > masters will unregister their net_device on shutdown, and attempt to do
> > something sane for all DSA switches in that case.
> >
> > Attached are two patches (they are fairly big so I won't paste them
> > inline, and I would like initial feedback before posting them to the
> > list).
> >
> > As mentioned in those patches, the shutdown ordering guarantee is still
> > very important, I still have no clue what goes on there, what we need to
> > do, etc.
> >
> 
> I tested these patches with my 5.10 kernel (based on Gregs 5.10.27 stable
> kernel) and while I do not see the message "unregister_netdevice: waiting
> for eth0 to become free. Usage count = 2." any more the shutdown/reboot hangs, too.
> After a few attempts without any error messages on the console I was able to get a
>  stack trace. Something still seems to go wrong in bcm2835_spi_shutdown() (see attachment).
> I have not had the time yet to investigate this further (or to test the patches
>  with a newer kernel).

Could you post the full kernel output? The picture you've posted is
truncated and only shows a WARN_ON in rpi_firmware_transaction and is
probably a symptom and not the issue (which is above and not shown).
