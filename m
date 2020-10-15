Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77E9128F0A9
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 13:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729378AbgJOLGO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 07:06:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726144AbgJOLGO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 07:06:14 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC2EBC061755;
        Thu, 15 Oct 2020 04:06:12 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id ds1so1626715pjb.5;
        Thu, 15 Oct 2020 04:06:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3agPMtqAij1qga3Qozc4HBm1uOcDmeRGeVCYjoCjyCc=;
        b=pLOQ8l/K7RgbgufocZ1NX2e0Ob/lMxvs2pThx5xdcjy7ggXY/fm1e+RWG1WbuqJkOE
         f8bmhjW7x9DYWEeuLbn0nX1VhyNcPQH9XgIPweNJT2mTBgRqTa7mWwzkQ8tFtfO3OmQr
         tqavvNlCC+yizHYNa7H4taKHnwHAUHEytGfa9CSr6ZQz9uWmBS4TXLYLQWnPGUWkQSpd
         XCoLRKJIIBrLbxTaQTX7i9qMT4Gvayv8uQUzbTsyy3G3dFHaWWsV5OkbnfOSsi+B1iaH
         VFTJd2/RQaYMMI2bAnITzJcZ+20h5A5lDoxxPBtC8S4zuwe1JtEkyXeXoxXmVISsOh6s
         Tbmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3agPMtqAij1qga3Qozc4HBm1uOcDmeRGeVCYjoCjyCc=;
        b=NJq4IGjOIVY8QMkEN2x/l7NCjgqCm1HDwAuXQlkGAuSoO6OZah2b/BpDBcq/gk1RXm
         b7jaEXOWayU0beFLTsAqqg51e9idnwZ2tEiJT9Zd9yv2Eegw/UNMmw++SCERzyGJrFhK
         zYfB4YMbr2LE2UOsC1A/7QZh/x0062SkwEpIK0sZ/l9gJ4nci29O6fyTK4fETKVhXd3q
         eEPSG6G6RYCbP29EWRQBxiwviYYza7Z4hlmqtsuWCa6jWV25XdRyCCFgKXuSswpHd6xk
         0X/9fk2US+V7K77TQrfa8iGcMWdSN2ud28QhchbN427W8KMpSELeZGmA8vHokrxXLdEr
         uTIg==
X-Gm-Message-State: AOAM532yFAe0DCnS9NaTt1pqPSkf5MT3widv4m0tNEasPp941ccpL+LG
        0ggxx/6zEepd52VMZF0Ds8A=
X-Google-Smtp-Source: ABdhPJzWgXIZMNd4WB1mQHIPBb1vFqXu9LmmgWEvLfa6xvXx7x5G6+/sLIRGlqorcO1F8OGG/+w0LA==
X-Received: by 2002:a17:90b:ed3:: with SMTP id gz19mr3852073pjb.53.1602759972000;
        Thu, 15 Oct 2020 04:06:12 -0700 (PDT)
Received: from f3 (ae055068.dynamic.ppp.asahi-net.or.jp. [14.3.55.68])
        by smtp.gmail.com with ESMTPSA id n203sm3253627pfd.81.2020.10.15.04.06.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2020 04:06:10 -0700 (PDT)
Date:   Thu, 15 Oct 2020 20:06:06 +0900
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
Message-ID: <20201015110606.GA52981@f3>
References: <20201008115808.91850-1-coiby.xu@gmail.com>
 <20201008115808.91850-2-coiby.xu@gmail.com>
 <20201010073514.GA14495@f3>
 <20201010102416.hvbgx3mgyadmu6ui@Rk>
 <20201010134855.GB17351@f3>
 <20201012112406.6mxta2mapifkbeyw@Rk>
 <20201013003704.GA41031@f3>
 <20201015033732.qaihehernm2jzoln@Rk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201015033732.qaihehernm2jzoln@Rk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-10-15 11:37 +0800, Coiby Xu wrote:
> On Tue, Oct 13, 2020 at 09:37:04AM +0900, Benjamin Poirier wrote:
> > On 2020-10-12 19:24 +0800, Coiby Xu wrote:
> > [...]
> > > > I think, but didn't check in depth, that in those drivers, the devlink
> > > > device is tied to the pci device and can exist independently of the
> > > > netdev, at least in principle.
> > > >
> > > You are right. Take drivers/net/ethernet/mellanox/mlxsw as an example,
> > > devlink reload would first first unregister_netdev and then
> > > register_netdev but struct devlink stays put. But I have yet to
> > > understand when unregister/register_netdev is needed.
> > 
> > Maybe it can be useful to manually recover if the hardware or driver
> > gets in an erroneous state. I've used `modprobe -r qlge && modprobe
> > qlge` for the same in the past.
> 
> Thank you for providing this user case!
> > 
> > > Do we need to
> > > add "devlink reload" for qlge?
> > 
> > Not for this patchset. That would be a new feature.
> 
> To implement this feature, it seems I need to understand how qlge work
> under the hood. For example, what's the difference between
> qlge_soft_reset_mpi_risc and qlge_hard_reset_mpi_risc? Or should we use
> a brute-force way like do the tasks in qlge_remove and then re-do the
> tasks in qlge_probe?

I don't know. Like I've said before, I'd recommend testing on actual
hardware. I don't have access to it anymore.

> Is a hardware reference manual for qlge device?

I've never gotten access to one.

The only noteworthy thing from Qlogic that I know of is the firmware
update:
http://driverdownloads.qlogic.com/QLogicDriverDownloads_UI/SearchByProduct.aspx?ProductCategory=322&Product=1104&Os=190

It did fix some weird behavior when I applied it so I'd recommend doing
the same if you get an adapter.
