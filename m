Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 669482F5EDC
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 11:35:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728691AbhANKfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 05:35:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726472AbhANKe7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 05:34:59 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48404C061575
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 02:34:09 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id h16so5162974edt.7
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 02:34:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=g6ySYwe3rKDUmAjRvcLib6IPpYoRLvLF3DJxt2PAalw=;
        b=pjUBjshFZ4Id88jZl/D3JjPWw5nDqvx3gAvw3DY+BzlNvo4Gsrp6F0R1IgnqIL50To
         tqcnhA9ImEUYcWGJR63QRmhenyVM8WtgkJJg4K4VXVESg2YO79rKF2a85IlCDvrKwpXj
         VmhZ5Ne0nBoqyPEx5pbmO7aoz2m+5jvKDah8H7RoQ+BhhYXHCy9AOaaDb+TYmF3LCAea
         0RVd8FVKOJiiIBtBEc0myFLFT+ttdpVz7gA9Z9tvZTjcvbcZTtGuIv6L+/iDVi4Z7a/J
         L0sTzffQ9fYgYQ4J9FlsgMY1+LRYDUVJzArkUV7ocKyPs0yjdWu6b6wYlveqjIUk7O+1
         Sg5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=g6ySYwe3rKDUmAjRvcLib6IPpYoRLvLF3DJxt2PAalw=;
        b=TwvHLXYBVLcVvfSDe5lS8tD4QZgWlzLFam0ZLEbQ3UHJfXEGEd99Y8dx92qJTsNF3S
         70STmfhOXF06bR1pZ6UTiJFOn5EI6CyYAnKkc6U0FnRiWjsjXXPxFlR4Us2N281GhA2x
         g3aPlbSIwIvdE6um9zHYNVK4g0DHlvwBcUvYI2vJnDl6zrRKR8MRoc/0d2eXBn4nZBWY
         s6cnKZnixTSnc+DnD4qgjFBlINUVZgXxxMddHhJQ3j7BWPLZk6L/IslvWG37TS6rTV0C
         b3MvQZifsiNCgEtxo22feXT8AHWZhcn6vVLnNU8q/sV8tmbYwVZlJ5Ka+lrMCx54wEHL
         0+Xg==
X-Gm-Message-State: AOAM532dJOLINhZTMYsbV+D6T968HvZjhzV/UOcDLn0GI8E0Mr66r6MG
        IluuHnZxpfmGyVKS9ovnU50=
X-Google-Smtp-Source: ABdhPJzT9RLtsP03iOlCnrzCugoHMClKKJLtOTuawkIOKHqV66JtRqr/MB9M8VLQrv7Dl6xZ1OxCbA==
X-Received: by 2002:a50:f9cc:: with SMTP id a12mr5051012edq.335.1610620447969;
        Thu, 14 Jan 2021 02:34:07 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id e19sm2021320edr.61.2021.01.14.02.34.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 02:34:07 -0800 (PST)
Date:   Thu, 14 Jan 2021 12:34:05 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, jiri@resnulli.us,
        idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v3 net-next 08/10] net: mscc: ocelot: register devlink
 ports
Message-ID: <20210114103405.yizjfsk4idzgnpot@skbuf>
References: <20210108175950.484854-1-olteanv@gmail.com>
 <20210108175950.484854-9-olteanv@gmail.com>
 <20210109174439.404713f6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210111171344.j6chsp5djr5t5ykk@skbuf>
 <20210111111909.4cf0174f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210111111909.4cf0174f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021 at 11:19:09AM -0800, Jakub Kicinski wrote:
> > > devlink_port_attrs_set() should be called before netdev is registered,
> > > and devlink_port_type_eth_set() after. So this sequence makes me a tad
> > > suspicious.
> > >
> > > In particular IIRC devlink's .ndo_get_phys_port_name depends on it,
> > > because udev event needs to carry the right info for interface renaming
> > > to work reliably. No?
> >
> > If I change the driver's Kconfig from tristate to bool, all is fine,
> > isn't it?
>
> How does Kconfig change the order of registration of objects to
> subsystems _within_ the driver?

The registration order within the driver is not what matters. What
matters is that the devlink_port and net_device are both registered
_before_ udev is up.

> Can you unbind and bind the driver back and see if phys_port_name
> always gets the correct value? (replay/udevadm test is not sufficient)

Yes, and that udev renaming test failed miserably still.

I have dhcpcd in my system, and it races with my udev script by
auto-upping the interfaces when they probe. Then, dev_change_name()
returns -EBUSY because the interfaces are up but its priv_flags do not
declare IFF_LIVE_RENAME_OK.

How is that one solved?
