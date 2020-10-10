Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E69C928A3D6
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 01:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389759AbgJJWzw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:55:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730932AbgJJTwD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 15:52:03 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA0F9C05BD14;
        Sat, 10 Oct 2020 06:49:01 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id e10so9392811pfj.1;
        Sat, 10 Oct 2020 06:49:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kC9TWaG7yp5ewJLHtI5Tz3MDkqf7FFIgPPjwgWQ0j4I=;
        b=V5dlcnRgTj5UdC+szz9bftOxKaNSU7wBlGhTMz6V2WvyjNqR/IdptvTMgaAi08ICdz
         WsxnQQoK8yMMJNTpT8nBHcI0SRPEuAViyK0DU80Syo+U0pKWcTDuMTKv7x7h6RkyCpMA
         /qOCSn0lE8JFcIPr8J3MsxPoB3eBvWSLSdiIxA7gRvQ9sqFOXjwbYJq3OSnhaxJ9eROX
         8zffhikWDK/hY0e/LWGUzLb9cWx8/XDVaXMV7fcOyzOYX7Ssv3llOTknlvGCS9N2N1wp
         LysOcPy3yMhgEkF22ssRV5wfVxR8Gx6qZki4m69us9f0XynPSW3tyJhvGKCQOogpijGi
         Aurg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kC9TWaG7yp5ewJLHtI5Tz3MDkqf7FFIgPPjwgWQ0j4I=;
        b=FDduFAD+FdIiMzM3krOaR7Nvbz3rhHc5BL3+Rj7gAuwUL/oW2mCdN1z4QMIF31hBRy
         pvBa624WMOFCZIpyli4gC5mI++IGjrsAhPbEI1m0kuO3JB81glcvGSKLToAporTrUzJB
         G4bqLP5Zksry81pNPyLCFufi2kQClQAzX3JiTR3R8+tysO6SfLqMpRMsqXBeiHthim1u
         4ekh+ylk80aIuC0wnWtpu+W8UmA8Vhp+5u5pv8wdzw4HKOnruzbU7oL849aOqkevUNtN
         SB2WLQ2YWXsR6CaUrvTRDT2mBt0nDKG79/wWQQeZ29dVl0qHfoTB3Ua2qzYHZdI15nRE
         4GDA==
X-Gm-Message-State: AOAM530ti/vpLf8/zH7cq+BY2TGjBq0pK1R4MQAAND08L1IcT7kxpOmM
        q9gS8O6CoWITcb4bolzShmg=
X-Google-Smtp-Source: ABdhPJwQBpFJ3ZD+MYSjv81yJ9YaF1Uz9iMqM4xk8zmnBMZtggfc6h8sY59CITsoLlxlamjwS1v8tg==
X-Received: by 2002:a17:90a:8007:: with SMTP id b7mr10168719pjn.84.1602337741209;
        Sat, 10 Oct 2020 06:49:01 -0700 (PDT)
Received: from f3 (ae055068.dynamic.ppp.asahi-net.or.jp. [14.3.55.68])
        by smtp.gmail.com with ESMTPSA id gl24sm7323884pjb.50.2020.10.10.06.48.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2020 06:49:00 -0700 (PDT)
Date:   Sat, 10 Oct 2020 22:48:55 +0900
From:   Benjamin Poirier <benjamin.poirier@gmail.com>
To:     Coiby Xu <coiby.xu@gmail.com>
Cc:     devel@driverdev.osuosl.org, Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Manish Chopra <manishc@marvell.com>,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:QLOGIC QLGE 10Gb ETHERNET DRIVER" <netdev@vger.kernel.org>
Subject: Re: [PATCH v1 1/6] staging: qlge: Initialize devlink health dump
 framework for the dlge driver
Message-ID: <20201010134855.GB17351@f3>
References: <20201008115808.91850-1-coiby.xu@gmail.com>
 <20201008115808.91850-2-coiby.xu@gmail.com>
 <20201010073514.GA14495@f3>
 <20201010102416.hvbgx3mgyadmu6ui@Rk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201010102416.hvbgx3mgyadmu6ui@Rk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-10-10 18:24 +0800, Coiby Xu wrote:
> On Sat, Oct 10, 2020 at 04:35:14PM +0900, Benjamin Poirier wrote:
> > On 2020-10-08 19:58 +0800, Coiby Xu wrote:
> > > Initialize devlink health dump framework for the dlge driver so the
> > > coredump could be done via devlink.
> > > 
> > > Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
> > > ---
> > >  drivers/staging/qlge/Kconfig        |  1 +
> > >  drivers/staging/qlge/Makefile       |  2 +-
> > >  drivers/staging/qlge/qlge.h         |  9 +++++++
> > >  drivers/staging/qlge/qlge_devlink.c | 38 +++++++++++++++++++++++++++++
> > >  drivers/staging/qlge/qlge_devlink.h |  8 ++++++
> > >  drivers/staging/qlge/qlge_main.c    | 28 +++++++++++++++++++++
> > >  6 files changed, 85 insertions(+), 1 deletion(-)
> > >  create mode 100644 drivers/staging/qlge/qlge_devlink.c
> > >  create mode 100644 drivers/staging/qlge/qlge_devlink.h
> > > 
> > > diff --git a/drivers/staging/qlge/Kconfig b/drivers/staging/qlge/Kconfig
> > > index a3cb25a3ab80..6d831ed67965 100644
> > > --- a/drivers/staging/qlge/Kconfig
> > > +++ b/drivers/staging/qlge/Kconfig
> > > @@ -3,6 +3,7 @@
> > >  config QLGE
> > >  	tristate "QLogic QLGE 10Gb Ethernet Driver Support"
> > >  	depends on ETHERNET && PCI
> > > +	select NET_DEVLINK
> > >  	help
> > >  	This driver supports QLogic ISP8XXX 10Gb Ethernet cards.
> > > 
> > > diff --git a/drivers/staging/qlge/Makefile b/drivers/staging/qlge/Makefile
> > > index 1dc2568e820c..07c1898a512e 100644
> > > --- a/drivers/staging/qlge/Makefile
> > > +++ b/drivers/staging/qlge/Makefile
> > > @@ -5,4 +5,4 @@
> > > 
> > >  obj-$(CONFIG_QLGE) += qlge.o
> > > 
> > > -qlge-objs := qlge_main.o qlge_dbg.o qlge_mpi.o qlge_ethtool.o
> > > +qlge-objs := qlge_main.o qlge_dbg.o qlge_mpi.o qlge_ethtool.o qlge_devlink.o
> > > diff --git a/drivers/staging/qlge/qlge.h b/drivers/staging/qlge/qlge.h
> > > index b295990e361b..290e754450c5 100644
> > > --- a/drivers/staging/qlge/qlge.h
> > > +++ b/drivers/staging/qlge/qlge.h
> > > @@ -2060,6 +2060,14 @@ struct nic_operations {
> > >  	int (*port_initialize)(struct ql_adapter *qdev);
> > >  };
> > > 
> > > +
> > > +
> > > +struct qlge_devlink {
> > > +        struct ql_adapter *qdev;
> > > +        struct net_device *ndev;
> > 
> > This member should be removed, it is unused throughout the rest of the
> > series. Indeed, it's simple to use qdev->ndev and that's what
> > qlge_reporter_coredump() does.
> 
> It reminds me that I forgot to reply to one of your comments in RFC and
> sorry for that,
> > > +
> > > +
> > > +struct qlge_devlink {
> > > +        struct ql_adapter *qdev;
> > > +        struct net_device *ndev;
> > 
> > I don't have experience implementing devlink callbacks but looking at
> > some other devlink users (mlx4, ionic, ice), all of them use devlink
> > priv space for their main private structure. That would be struct
> > ql_adapter in this case. Is there a good reason to stray from that
> > pattern?

Thanks for getting back to that comment.

> 
> struct ql_adapter which is created via alloc_etherdev_mq is the
> private space of struct net_device so we can't use ql_adapter as the
> the devlink private space simultaneously. Thus struct qlge_devlink is
> required.

Looking at those drivers (mlx4, ionic, ice), the usage of
alloc_etherdev_mq() is not really an obstacle. Definitely, some members
would need to be moved from ql_adapter to qlge_devlink to use that
pattern.

I think, but didn't check in depth, that in those drivers, the devlink
device is tied to the pci device and can exist independently of the
netdev, at least in principle.

In any case, I see now that some other drivers (bnxt, liquidio) have a
pattern similar to what you use so I guess that's acceptable too.
