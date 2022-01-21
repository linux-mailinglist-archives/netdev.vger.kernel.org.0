Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87C5149581A
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 03:06:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348350AbiAUCGb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 21:06:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244982AbiAUCGb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 21:06:31 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD595C061574
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 18:06:30 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id n10so20994194edv.2
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 18:06:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+jqeMXJnFZ5Ghc7lTOyWNGYnnjG/L6CpPIZyv/Bbj/8=;
        b=eagGBWnRrTc0L8Qyk790kybCnUKlk72NzBlpxHRNRT+2ydSR6nS6jz6p+14ehVm50c
         hJ352jlXYyUTGbYntpgPKSz/b53jgDbzI4KtYnBtRBEMmzFb1XeAgc5t0M6wjcGMxcAf
         rU6bIBAtKZWsPB0IWfXi8xTDVbbsNY68KxrpdnHh07cRmbCCse+PmKL3m4ztBtp7fzkK
         xdrYF22HuVqj91IT9z7iLZ8ErtNMdCpgh3bn4a0A4xO1n6ZhWfZ8ZddXrhjQTcp5sFw+
         dxUO13gadxPfqwSADPzY5zdOZ7G6StA3X9CetjkuTlYVXh+VJpuf7pKLpvuhaninIpsJ
         V6Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+jqeMXJnFZ5Ghc7lTOyWNGYnnjG/L6CpPIZyv/Bbj/8=;
        b=Asz4xU8serlF+Vu9XYoZOUfDKHjWRFld5GcMHOpJuEdEUrNQUSgL6XW4hwsdFikz9I
         /gupskFl1vWaEBzG78Wn3NJMBdOmM9EzejOBPlmRaPOIvkZpN+U//pj1UMskjncxXN85
         uvmX/wS+4Z95kdaiDFERQJFFD3ctlZDNYlP8boJcOnhQn8qeYGVzwu7CGWvYV/a0KiEO
         jbh3DuuclKghxYtpaGr8nMBa41FMbYbYJDkdNop92dls74QmEoNadLewG647sYeAVbbw
         WTZcZDYNXxKvRdHRjlGYGZkQ+gv7Q/zp9vuIC5GAFalr/6XdvDw8nGStD6rWg9o+t08Z
         3tdA==
X-Gm-Message-State: AOAM530MgX7VdiSoA8DK+dACZ/PWFbpVHijy/bFFD/QOH4oEt0YZ83Rl
        LC8wd5oAQ2rdOgPDpF7TpRI=
X-Google-Smtp-Source: ABdhPJyRzK/dTaV3aK0FVizw443heRLtQXEb8V3lTs/h6w/VjbQTbah5eDO/2d0UyVngH3NrRW+yIQ==
X-Received: by 2002:aa7:ca47:: with SMTP id j7mr2122676edt.102.1642730789078;
        Thu, 20 Jan 2022 18:06:29 -0800 (PST)
Received: from skbuf ([188.25.255.2])
        by smtp.gmail.com with ESMTPSA id o13sm2015726edj.58.2022.01.20.18.06.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jan 2022 18:06:28 -0800 (PST)
Date:   Fri, 21 Jan 2022 04:06:27 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Frank Wunderlich <frank-w@public-files.de>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Subject: Re: [PATCH net-next v4 11/11] net: dsa: realtek: rtl8365mb: multiple
 cpu ports, non cpu extint
Message-ID: <20220121020627.spli3diixw7uxurr@skbuf>
References: <87ee5fd80m.fsf@bang-olufsen.dk>
 <trinity-ea8d98eb-9572-426a-a318-48406881dc7e-1641822815591@3c-app-gmx-bs62>
 <87r19e5e8w.fsf@bang-olufsen.dk>
 <trinity-4b35f0dc-6bc6-400a-8d4e-deb26e626391-1641926734521@3c-app-gmx-bap14>
 <87v8ynbylk.fsf@bang-olufsen.dk>
 <trinity-d858854a-ff84-4b28-81f4-f0becc878017-1642089370117@3c-app-gmx-bap49>
 <CAJq09z7jC8EpJRGF2NLsSLZpaPJMyc_TzuPK_BJ3ct7dtLu+hw@mail.gmail.com>
 <Yea+uTH+dh9/NMHn@lunn.ch>
 <20220120151222.dirhmsfyoumykalk@skbuf>
 <CAJq09z6UE72zSVZfUi6rk_nBKGOBC0zjeyowHgsHDHh7WyH0jA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJq09z6UE72zSVZfUi6rk_nBKGOBC0zjeyowHgsHDHh7WyH0jA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 20, 2022 at 08:35:54PM -0300, Luiz Angelo Daros de Luca wrote:
> > And what is the problem if the hardware cannot calculate the checksum
> > with an unknown EtherType? Is it the DSA master that drops the packets
> > in hardware? What is the reported error counter?
> 
> No, the issue is with outgoing packets and nothing is dropped inside
> the DSA device.

Ah, sorry, I missed that.

> If the OS is configured to offload (I'm using OpenWrt.), it will send
> a packet with the wrong checksum expecting that the HW will fix that.
> After DSA is brought up, the OS is still expecting the HW to calculate
> the checksums. However, with the EtherType DSA tag from a , it cannot
> understand it anymore, leaving the checksum as is. The DSA switch
> (Realtek) passes the packet to the network and the other end receives
> a broken packet. Maybe if the DSA knew that the CPU Ethernet HW cannot
> handle that DSA tag, it could disable checksums by default. But it is
> difficult to foresee how each offload HW will digest each type of CPU
> tag.
> 
> Is the kernel enabling checksum by default when the driver reports it
> is supported? If so, it would be nice to somehow disable offloading
> with some kind of device-tree dsa cpu port property.

:) device tree properties are not the fix for everything!

I think I know what the problem is. But I'd need to know what the driver
for the DSA master is, to confirm. To be precise, what I'd like to check
is the value of master->vlan_features.
