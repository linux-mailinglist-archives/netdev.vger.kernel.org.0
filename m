Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 139AC445214
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 12:18:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230478AbhKDLUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 07:20:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbhKDLUf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 07:20:35 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51694C061714
        for <netdev@vger.kernel.org>; Thu,  4 Nov 2021 04:17:57 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id br12so9377901lfb.8
        for <netdev@vger.kernel.org>; Thu, 04 Nov 2021 04:17:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=X28EUvF37JG8sLJd2ozBBVqVA0+Tv4blId9Jj9wp/Ec=;
        b=Kba8CEph5ohrl+RLrylon7mOj8G/oJQd9Zl6cBD7q5XREzOnLP0t4iIA28IVDbnhbl
         IHOSfMDoT32NINCQLunxGmvDDxlIPyi1VWr4WlyIpH2OK8H4GwJ/7PcVhdWuI10SK5ab
         rqfeZDFy6snIIrIPdxDeOqH86zuccUh4ww00PosvOV/u9M8fpbJ1tOioofH1ABzi4lDX
         p83S3HEoGHtkpjkugJkpFCJI2UBFctNZoic5zKajbMwF8rw6q8MKzWi1oqBSYrkzBDw/
         iX4vEkl4CdkD/w7gcjXqE3HTvmRRvpEhUk46OCbHqe2tF/4wf61iSovsj8L6aGaOXAoS
         +rFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=X28EUvF37JG8sLJd2ozBBVqVA0+Tv4blId9Jj9wp/Ec=;
        b=fk3m+k9MV9KuOh6HhoYZzaly1tVjGX3QNOxWUEArYX8I1YHKsHGXZz2VwxugZJHNuC
         s0n0QVEkn5lc+bsw6Xf+9FFmu0LZ+ohVvH8ssWx3hpCQi6oSqG8DtV1Pd0fl/BUXEzOt
         iaiSnLpzC1JvCDg9lC+G50baHQh/1fxGElhAmOX17FGCD6/LyDtd1tWs7EHft576UP4g
         Ra3D8S0uZp6ZxLFQyhI1CGE1v7GEuAipVbTA3WuCe79X3SdspG9f+TpXBH3l+on8dBWe
         Auu72ERBy/voBfwmenNOil89mz86gF1VWR6zbnu77QiVaXpkPfItIwDIM7C9krKerMZN
         4m5Q==
X-Gm-Message-State: AOAM530U8wPmnBfRtrSIyPnkJ2aK1xZPDIfrMb4YokPW+/76ad3/ItK1
        Bm6SNtWsVv12G+E/pZ7n979O/g==
X-Google-Smtp-Source: ABdhPJyd8PoyhBeFunSzsriFCLUi7D3KZwMqekW2YKlW1ezsboMaQuapPCKvqAxh+g6EmdS5HgJMYQ==
X-Received: by 2002:a05:6512:168b:: with SMTP id bu11mr46014937lfb.293.1636024675590;
        Thu, 04 Nov 2021 04:17:55 -0700 (PDT)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id j20sm438526lfu.199.2021.11.04.04.17.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 04:17:55 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Sean Anderson <sean.anderson@seco.com>
Subject: Re: [RFC PATCH] net: phy/mdio: enable mmd indirect access through
 phy_mii_ioctl()
In-Reply-To: <YYLk0dEKX2Jlq0Se@lunn.ch>
References: <YYCLJnY52MoYfxD8@lunn.ch>
 <YYExmHYW49jOjfOt@shell.armlinux.org.uk>
 <bc9df441-49bf-5c8a-891c-cc3f0db00aba@ti.com>
 <YYF4ZQHqc1jJsE/+@shell.armlinux.org.uk>
 <e18f17bd-9e77-d3ef-cc1e-30adccb7cdd5@ti.com>
 <828e2d69-be15-fe69-48d8-9cfc29c4e76e@ti.com> <YYGxvomL/0tiPzvV@lunn.ch>
 <8d24c421-064c-9fee-577a-cbbf089cdf33@ti.com> <YYHXcyCOPiUkk8Tz@lunn.ch>
 <01a0ebf9-5d3f-e886-4072-acb9bf418b12@ti.com> <YYLk0dEKX2Jlq0Se@lunn.ch>
Date:   Thu, 04 Nov 2021 12:17:47 +0100
Message-ID: <87pmrgjhk4.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 03, 2021 at 20:36, Andrew Lunn <andrew@lunn.ch> wrote:
> On Wed, Nov 03, 2021 at 08:42:07PM +0200, Grygorii Strashko wrote:
>> 
>> 
>> On 03/11/2021 02:27, Andrew Lunn wrote:
>> > > > What i find interesting is that you and the other resent requester are
>> > > > using the same user space tool. If you implement C45 over C22 in that
>> > > > tool, you get your solution, and it will work for older kernels as
>> > > > well. Also, given the diverse implementations of this IOTCL, it
>> > > > probably works for more drivers than just those using phy_mii_ioctl().
>> > > 
>> > > Do you mean change uapi, like
>> > >   add mdio_phy_id_is_c45_over_c22() and
>> > >   flag #define MDIO_PHY_ID_C45_OVER_C22 0x4000?
>> > 
>> > No, i mean user space implements C45 over C22. Make phytool write
>> > MII_MMD_CTRL and MII_MMD_DATA to perform a C45 over C22.
>> 
>> Now I give up - as mentioned there is now way to sync User space vs Kernel
>> MMD transactions and so no way to get trusted results.

Except that there is a way: https://github.com/wkz/mdio-tools

I can see that Sean has already mentioned it in the other branch of the
thread (thanks for the plug :)). I have posted it to netdev before:

https://lore.kernel.org/netdev/C42DZQLTPHM5.2THDSRK84BI3T@wkz-x280/

It allows you to send an entire "MDIO program" to the kernel, where
mdio-netlink will (1) lock the bus, (2) run your program in a small VM,
and (3) unlock the bus.

There are currently two programs in the project:

- `mdio`: A basic register peek/poke program that uses the mdio-netlink
  module in the kernel to do its thing. The source is structured in such
  a way that custom access modes can be easily added. Today there are
  accessors for C22 PHYs, C45 MMDs, Marvell Alaska paged PHYs, Marvell
  LinkStreet switches, and XRS700x switches.

- `mvls`: Specialized read-only debug tool for Marvell LinkStreet
  switches. This does _not_ rely on the mdio-netlink kernel module,
  instead it uses the standard devlink API. Let's you dump the VTU/ATU
  etc.

You could easily add a new addressing mode to `mdio` to do C45-over-C22
accesses. Would that work for you Grygorii?

> Except that it will probably work 99% of the time, which is enough for
> a debug tool.

Why though, why would we not build something that is rock solid? Ever
since ce69e2162f15, the flood gates are open. Any vendor can implement
mdio-netlink on their own, or just download mine. We are only punishing
ourselves at this point.

> phylib is pretty idle most of the time, it just polls
> the PHY once a second to see if the link status has changed. And does
> not poll at all if interrupts are wired up. And you can always do a
> read three times and see if you get the same answer, or do a write
> followed by a read to see if the write actually happened correctly, or
> corrupted some other register.

As a staunch opponent of Vendor SDKs myself, I get where you are coming
from - really.

I guess I just don't have the brain power to operate this kind of Rube
Goldberg machinery and debug my problems at the same time. We have a
mutex right there already, let's use it!

I'll shut up now - I just had to make one final appeal :)
