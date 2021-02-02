Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF18E30B46B
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 02:08:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbhBBBHn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 20:07:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbhBBBHm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 20:07:42 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B24FC06174A
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 17:07:02 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id z22so21057784edb.9
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 17:07:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9O3/Y02mZhKbj+wuFTkx7iygdgd0EBlMv/0Y8SwCYcM=;
        b=yDEZAxy5uZU3Zn2/yTYJIzBltBGwFyapg1Gz12Fc4WVPuvg3uAOSOgj8oJFIiE7TOq
         dd8paqsGCEg7UO2JImRphebQPayU1P16KtMOfiDiWGNwCtYqKoiL/1yqUCdzX8bdCDFk
         8j3Rab9h3njVuuTVlKDqAFO2jIrt4obtbLvVF6fsUjarUkWvugFT+fwUJVrsEGVi4YOV
         1DWXIb2O33MM8PXZvdny4Q3hr9njQFUWkO5KGWeobOwrr5EfnK8jBcw5NhXaZ1L5LPi3
         IyAazrzWz6X1n4dYwbRsXWISl5zgTVUUwXEBuCAOcuNMPikvIQ0Fz7Q/IqxMtNXInftz
         ItlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9O3/Y02mZhKbj+wuFTkx7iygdgd0EBlMv/0Y8SwCYcM=;
        b=M3rLuGxuJJjeUnYKcdVJj/J0MoA3Wc2pCTjspHunVfD8T27OLs098yiI3yBu3QJEpH
         n7SNnL4Om/aRvbyzOOUEXXQundwprn5vblF0vkXGahu02YUXnvAt4JYlPmrxjZDdOAOf
         xma9Z2Z3ItBYwGSqqojzZaEjQz+sE7oQBD9hAuthAq7P/mBeht97+4ZWI6kbOUl2Srfk
         rSt4FK6YBPMbZtXi6z889vtvhE1Htf0pnwtnm6lXMOE7tnAIQzG1Ai9Yqbb2uVopS38v
         a0Hd/Ge156a7uoBIq/DL0MOu6PjRbSw31YfxeTXelFpBFJGg+sDkiAc/RyAkuKZ4dcvW
         auAw==
X-Gm-Message-State: AOAM533HhGg1nq6wIjEgYjQybWA8ZqL4CxIIdtYUUZKKKTQktirpA4sK
        XbEsOuX1dpYFLzFun9Ev/UjQzFqpqilFRxpF78WNWQ==
X-Google-Smtp-Source: ABdhPJxQEhSxdterZAsPu/4VOXgqxXAypFKYksNZcfO4OSdKFmAh67tkWxtNCMGghWQ3GZkeiHpDAcUlqttirzai6Z8=
X-Received: by 2002:aa7:cd87:: with SMTP id x7mr22380537edv.210.1612228020945;
 Mon, 01 Feb 2021 17:07:00 -0800 (PST)
MIME-Version: 1.0
References: <20210122234827.1353-8-shiraz.saleem@intel.com>
 <20210125184248.GS4147@nvidia.com> <99895f7c10a2473c84a105f46c7ef498@intel.com>
 <20210126005928.GF4147@nvidia.com> <031c2675aff248bd9c78fada059b5c02@intel.com>
 <20210127121847.GK1053290@unreal> <ea62658f01664a6ea9438631c9ddcb6e@intel.com>
 <20210127231641.GS4147@nvidia.com> <20210128054133.GA1877006@unreal>
 <d58f341898834170af1bfb6719e17956@intel.com> <20210201191805.GO4247@nvidia.com>
 <925c33a0b174464898c9fc5651b981ee@intel.com>
In-Reply-To: <925c33a0b174464898c9fc5651b981ee@intel.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Mon, 1 Feb 2021 17:06:58 -0800
Message-ID: <CAPcyv4gbW-27ySTmxf97zzcoVA_myM8uLV=ziscMuSKGBz7dqg@mail.gmail.com>
Subject: Re: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
 implement private channel OPs
To:     "Saleem, Shiraz" <shiraz.saleem@intel.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        "Patil, Kiran" <kiran.patil@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 1, 2021 at 4:40 PM Saleem, Shiraz <shiraz.saleem@intel.com> wrote:
>
> > Subject: Re: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
> > implement private channel OPs
> >
> > On Sat, Jan 30, 2021 at 01:19:36AM +0000, Saleem, Shiraz wrote:
> > > > Subject: Re: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver
> > > > and implement private channel OPs
> > > >
> > > > On Wed, Jan 27, 2021 at 07:16:41PM -0400, Jason Gunthorpe wrote:
> > > > > On Wed, Jan 27, 2021 at 10:17:56PM +0000, Saleem, Shiraz wrote:
> > > > >
> > > > > > Even with another core PCI driver, there still needs to be
> > > > > > private communication channel between the aux rdma driver and
> > > > > > this PCI driver to pass things like QoS updates.
> > > > >
> > > > > Data pushed from the core driver to its aux drivers should either
> > > > > be done through new callbacks in a struct device_driver or by
> > > > > having a notifier chain scheme from the core driver.
> > > >
> > > > Right, and internal to driver/core device_lock will protect from
> > > > parallel probe/remove and PCI flows.
> > > >
> > >
> > > OK. We will hold the device_lock while issuing the .ops callbacks from core
> > driver.
> > > This should solve our synchronization issue.
> > >
> > > There have been a few discussions in this thread. And I would like to
> > > be clear on what to do.
> > >
> > > So we will,
> > >
> > > 1. Remove .open/.close, .peer_register/.peer_unregister 2. Protect ops
> > > callbacks issued from core driver to the aux driver with device_lock
> >
> > A notifier chain is probably better, honestly.
> >
> > Especially since you don't want to split the netdev side, a notifier chain can be
> > used by both cases equally.
> >
>
> The device_lock seems to be a simple solution to this synchronization problem.
> May I ask what makes the notifier scheme better to solve this?
>

Only loosely following the arguments here, but one of the requirements
of the driver-op scheme is that the notifying agent needs to know the
target device. With the notifier-chain approach the target device
becomes anonymous to the notifier agent.
