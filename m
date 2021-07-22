Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 363573D2142
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 11:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231400AbhGVJKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 05:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231421AbhGVJKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 05:10:20 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C99FEC061575
        for <netdev@vger.kernel.org>; Thu, 22 Jul 2021 02:50:53 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id h8so6031209eds.4
        for <netdev@vger.kernel.org>; Thu, 22 Jul 2021 02:50:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=afOvuUyBtr0TcfV4r0srwkaU5LgoOmO/9k1OVhh31NA=;
        b=IKJeTWz7Vmxsx1FNzDXy6kpE4AcTEd5Av3k4N9Baj2+zCCAggYkTbG3sn2SDSDNk89
         SIAlVBH1nEznIXWHIudE1+lGEexleYp+l7VAkdep+SVBvfS1GMRvw0xmsdFB59honDoD
         7Hli0D20PwabYnP+SiT4ri7UJd/5I26cT+ZYc0B4/kWy3LRYo/mwixHogiNE4GJQrgy5
         jEabIpz5wMq5Mx4QrLEJXp42HnOZ+N31yfYYq5b6aDk8ncLCWT5DMvJo2qSifxA/1Wq9
         HmdB0Uq5M7+j8IzW36alw3+/0uhbmSwOplVd2UQa0pSxdTN1fO83Uet/4SuKmAT2Wg2A
         J6GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=afOvuUyBtr0TcfV4r0srwkaU5LgoOmO/9k1OVhh31NA=;
        b=Z8PsTyoWlpeNQrhI6HUsb6KTBuOYjUwW85dIVpwxM4hLc29uXQcZ4uQ0piJYKzyyZC
         xfYSXZ5IlLUcsgetx6o4dDm56kwE4aosmebv0UhgGPdb3g+JMPN+EJeIXKgx6n2S20t7
         0LGUxk5MC47DZaGX+MAEHn3iHLhplw1gWIe3GFk+zVqW9M+6S87dQutklBXTrm2d6u8a
         wVFCNWGC7QTHWH3kyDujVzvkvIamNtFO18IWjBJ2uYZMe6XnLZIzFuWA/ILo41NhZp35
         VNfHMM+pdJm33blYXeSUEq3mflhvYlZWskZzhjy20oAzNji3hrGQAd2Uta2cr1Ea64BS
         GjcQ==
X-Gm-Message-State: AOAM533wJ0RWAb2i8YSdfvCNRNpXd0+TdYliK0Go3Tn+oqDs6Sue/k6x
        zuVnvkBP7PT2dP1lBvzHVH0=
X-Google-Smtp-Source: ABdhPJwO0VolPHC7ExU3yOW/2Hy7G1zj+URK5AKgvjjZWCfBnALhiNaOPwOxq0P04ry6Z3TN7D4RDQ==
X-Received: by 2002:aa7:c641:: with SMTP id z1mr44787533edr.289.1626947452326;
        Thu, 22 Jul 2021 02:50:52 -0700 (PDT)
Received: from skbuf ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id gw15sm9322340ejb.42.2021.07.22.02.50.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jul 2021 02:50:51 -0700 (PDT)
Date:   Thu, 22 Jul 2021 12:50:49 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Marek Behun <kabel@blackhole.sk>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: Re: [RFC PATCH v3 net-next 00/24] Allow forwarding for the software
 bridge data path to be offloaded to capable devices
Message-ID: <20210722095049.pym33fyuyu5b4gfs@skbuf>
References: <20210712152142.800651-1-vladimir.oltean@nxp.com>
 <20210712174059.7916c0da@thinkpad>
 <20210712170120.xo34ztomimq5oqdg@skbuf>
 <20210712192711.126f2b35@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210712192711.126f2b35@thinkpad>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 12, 2021 at 07:27:11PM +0200, Marek Behun wrote:
> Hi Vladimir,
> 
> On Mon, 12 Jul 2021 17:01:21 +0000
> Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
> 
> > Hi Marek,
> > 
> > On Mon, Jul 12, 2021 at 05:40:59PM +0200, Marek Behun wrote:
> > > Vladimir, on what mv88e6xxx devices are you developing this stuff?
> > > Do you use Turris MOX for this?  
> > 
> > I didn't develop the Marvell stuff nor did I come up with the idea
> > there, Tobias did. I also am not particularly interested in supporting
> > this for Marvell beyond making sure that the patches look simple and
> > okay, and pave the way for other drivers to do the same thing.
> > 
> > I did my testing using a different DSA driver and extra patches which
> > I did not post here yet. I just reposted/adapted Tobias' work because
> > mv88e6xxx needs less work to support the TX data plane offload, and this
> > framework does need a first user to get accepted, so why delay it any
> > further if mv88e6xxx needs 2 patches whereas other drivers need 30.
> > 
> > I did use the MOX for some minimal testing however, at least as far as
> > I could - there is this COMPHY SERDES bug in the bootloader which makes
> > the board fail to boot, and now the device tree workaround you gave me
> > does not appear to bypass the issue any longer or I didn't reaply it
> > properly.
> 
> Sorry about that. Current upstream U-Boot solves this issue, but we did
> not release official update yet because there are still some things that
> need to be done. We have some RCs, though.
> 
> If you are interested, it is pretty easy to upgrade:
> - MTD partition "secure-firmware" needs to be flashed with
>     https://gitlab.nic.cz/turris/mox-boot-builder/uploads/8d5a17fae8f6e14ca11968ee5174c7ca/trusted-secure-firmware.bin
>   (this file needs to be signed by CZ.NIC)
> - MTD partition "a53-firmware" (or "u-boot" in older DTS) needs to be
>   flashed with
>     https://secure.nic.cz/files/mbehun/a53-firmware.bin
>   (this file can be built by users themselves)

Thanks. This worked in the sense that I could flash the trust zone
firmware and U-Boot, and net-next will boot without hanging, but now the
board is in a boot loop, due to what appears to be watchdog timer
expiration. This happens regardless of whether CONFIG_ARMADA_37XX_WATCHDOG
is set to y or n in the booted kernel.
