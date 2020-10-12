Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC16728B3E1
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 13:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388219AbgJLLgf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 07:36:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387617AbgJLLgf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 07:36:35 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C8CAC0613CE;
        Mon, 12 Oct 2020 04:36:35 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id 10so3713523pfp.5;
        Mon, 12 Oct 2020 04:36:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xrf/Yzf3OlPHd/NKkYODnBDZ/j7v6gR8d9YmSo4CLhw=;
        b=PTbjXLDLKuyuI0yo+S/K9JscItFqiPn9GBIfKJLSsCpXW2XI7B4RnR7IDBxgmTf6YD
         0SfsC3ZDA4UA28tpye6Yid75qWsIPtrD8BAJW8aCw7hTL8bO3pNS0JnF8O1YCJ77v5ff
         G0pIXy8kUlv4rSHEGcX7mQAxNdGbKgcKa22EEq9YCNKuv9n4PZ6DZS5F/eZP0sNL9ZDM
         C4mJHyW8f4DpRtKgPDpaGAIw6WMeXsBGOjfLT3LMJ+mwy4t+2R7GDxuLl7w+XrBC9y6j
         5kDyzGjGhI/cIFevkpWF14cDgnlxOlA5UGzJv8Xi8eDx2VmhrOC4YmMPJGPPXaHYQtyo
         yb+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xrf/Yzf3OlPHd/NKkYODnBDZ/j7v6gR8d9YmSo4CLhw=;
        b=Xqzg7pXlC9FQKik2OPKjfEvG+ccNMHScR/0kgnlOzQTGU4WKIlfhVZc6BzwjL7q7Gc
         KhwP+zeySrl8n4mgM98de7UG+5aXpul2Cx3xsjvzfBlqOjfeOmp74Lo/ieDHFW6ZZO/q
         fcELDTgEXoxyTW+NOGjUTUuP85oPM0mIybkmyf5vyL4utHkhgrSHpn4Cmzr+YSlOe8+5
         kyIdHKtq+TbCZAevnWVMhyLmCrrhig0+n46OFuqPuQp9FZvCMs5OmehdYjWhczv3Yh1r
         DfhH7wdzMS5j2ChSBviE16HHBATVFhgK+uuvKpn6+oQAjJY2UNJD9Nx2WTTDTl1SHM9X
         S2Yw==
X-Gm-Message-State: AOAM5319NeXIElRW7CCwCEBcRC5zyKAng7O17gnX0ZIL0PAimKpl2kVf
        /LBaqLUSbQzRkh6gxVXsmMerSRXmIoCy9Mn1
X-Google-Smtp-Source: ABdhPJzlSX5HWhQP2RWG1GYsnfITGXhdleQaKy7Ie257ryN6Km+oRHvLMoxwLryiZYN4p67aVRayUQ==
X-Received: by 2002:aa7:911a:0:b029:155:8521:ba6c with SMTP id 26-20020aa7911a0000b02901558521ba6cmr14691848pfh.8.1602502594576;
        Mon, 12 Oct 2020 04:36:34 -0700 (PDT)
Received: from localhost ([160.16.113.140])
        by smtp.gmail.com with ESMTPSA id n2sm25486923pja.41.2020.10.12.04.36.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 04:36:34 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
X-Google-Original-From: Coiby Xu <Coiby.Xu@gmail.com>
Date:   Mon, 12 Oct 2020 19:24:06 +0800
To:     Benjamin Poirier <benjamin.poirier@gmail.com>
Cc:     devel@driverdev.osuosl.org, Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Manish Chopra <manishc@marvell.com>,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:QLOGIC QLGE 10Gb ETHERNET DRIVER" <netdev@vger.kernel.org>
Subject: Re: [PATCH v1 1/6] staging: qlge: Initialize devlink health dump
 framework for the dlge driver
Message-ID: <20201012112406.6mxta2mapifkbeyw@Rk>
References: <20201008115808.91850-1-coiby.xu@gmail.com>
 <20201008115808.91850-2-coiby.xu@gmail.com>
 <20201010073514.GA14495@f3>
 <20201010102416.hvbgx3mgyadmu6ui@Rk>
 <20201010134855.GB17351@f3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201010134855.GB17351@f3>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 10, 2020 at 10:48:55PM +0900, Benjamin Poirier wrote:
>On 2020-10-10 18:24 +0800, Coiby Xu wrote:
>> On Sat, Oct 10, 2020 at 04:35:14PM +0900, Benjamin Poirier wrote:
>> > On 2020-10-08 19:58 +0800, Coiby Xu wrote:
>> > > Initialize devlink health dump framework for the dlge driver so the
>> > > coredump could be done via devlink.
>> > >
>> > > Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
>> > > ---
>> > >  drivers/staging/qlge/Kconfig        |  1 +
>> > >  drivers/staging/qlge/Makefile       |  2 +-
>> > >  drivers/staging/qlge/qlge.h         |  9 +++++++
>> > >  drivers/staging/qlge/qlge_devlink.c | 38 +++++++++++++++++++++++++++++
>> > >  drivers/staging/qlge/qlge_devlink.h |  8 ++++++
>> > >  drivers/staging/qlge/qlge_main.c    | 28 +++++++++++++++++++++
>> > >  6 files changed, 85 insertions(+), 1 deletion(-)
>> > >  create mode 100644 drivers/staging/qlge/qlge_devlink.c
>> > >  create mode 100644 drivers/staging/qlge/qlge_devlink.h
>> > >
>> > > diff --git a/drivers/staging/qlge/Kconfig b/drivers/staging/qlge/Kconfig
>> > > index a3cb25a3ab80..6d831ed67965 100644
>> > > --- a/drivers/staging/qlge/Kconfig
>> > > +++ b/drivers/staging/qlge/Kconfig
>> > > @@ -3,6 +3,7 @@
>> > >  config QLGE
>> > >  	tristate "QLogic QLGE 10Gb Ethernet Driver Support"
>> > >  	depends on ETHERNET && PCI
>> > > +	select NET_DEVLINK
>> > >  	help
>> > >  	This driver supports QLogic ISP8XXX 10Gb Ethernet cards.
>> > >
>> > > diff --git a/drivers/staging/qlge/Makefile b/drivers/staging/qlge/Makefile
>> > > index 1dc2568e820c..07c1898a512e 100644
>> > > --- a/drivers/staging/qlge/Makefile
>> > > +++ b/drivers/staging/qlge/Makefile
>> > > @@ -5,4 +5,4 @@
>> > >
>> > >  obj-$(CONFIG_QLGE) += qlge.o
>> > >
>> > > -qlge-objs := qlge_main.o qlge_dbg.o qlge_mpi.o qlge_ethtool.o
>> > > +qlge-objs := qlge_main.o qlge_dbg.o qlge_mpi.o qlge_ethtool.o qlge_devlink.o
>> > > diff --git a/drivers/staging/qlge/qlge.h b/drivers/staging/qlge/qlge.h
>> > > index b295990e361b..290e754450c5 100644
>> > > --- a/drivers/staging/qlge/qlge.h
>> > > +++ b/drivers/staging/qlge/qlge.h
>> > > @@ -2060,6 +2060,14 @@ struct nic_operations {
>> > >  	int (*port_initialize)(struct ql_adapter *qdev);
>> > >  };
>> > >
>> > > +
>> > > +
>> > > +struct qlge_devlink {
>> > > +        struct ql_adapter *qdev;
>> > > +        struct net_device *ndev;
>> >
>> > This member should be removed, it is unused throughout the rest of the
>> > series. Indeed, it's simple to use qdev->ndev and that's what
>> > qlge_reporter_coredump() does.
>>
>> It reminds me that I forgot to reply to one of your comments in RFC and
>> sorry for that,
>> > > +
>> > > +
>> > > +struct qlge_devlink {
>> > > +        struct ql_adapter *qdev;
>> > > +        struct net_device *ndev;
>> >
>> > I don't have experience implementing devlink callbacks but looking at
>> > some other devlink users (mlx4, ionic, ice), all of them use devlink
>> > priv space for their main private structure. That would be struct
>> > ql_adapter in this case. Is there a good reason to stray from that
>> > pattern?
>
>Thanks for getting back to that comment.
>
>>
>> struct ql_adapter which is created via alloc_etherdev_mq is the
>> private space of struct net_device so we can't use ql_adapter as the
>> the devlink private space simultaneously. Thus struct qlge_devlink is
>> required.
>
>Looking at those drivers (mlx4, ionic, ice), the usage of
>alloc_etherdev_mq() is not really an obstacle. Definitely, some members
>would need to be moved from ql_adapter to qlge_devlink to use that
>pattern.
>
I see what you mean now. I thought we were going to use struct ql_adapter
as the shared private structure of devlink and net_device. If we are
going to use ql_adapter as the private structure of devlink then we have
to define another private structure for net_device.

>I think, but didn't check in depth, that in those drivers, the devlink
>device is tied to the pci device and can exist independently of the
>netdev, at least in principle.
>
You are right. Take drivers/net/ethernet/mellanox/mlxsw as an example,
devlink reload would first first unregister_netdev and then
register_netdev but struct devlink stays put. But I have yet to
understand when unregister/register_netdev is needed. Do we need to
add "devlink reload" for qlge?

>In any case, I see now that some other drivers (bnxt, liquidio) have a
>pattern similar to what you use so I guess that's acceptable too.

--
Best regards,
Coiby
