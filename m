Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3899E1B2EF8
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 20:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729431AbgDUSW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 14:22:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbgDUSW7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 14:22:59 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 102F5C0610D5
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 11:22:59 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id k12so1972872qtm.4
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 11:22:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=FCFoAdp+gpplebsvzRZutt6p9sl8bNSF5bkg2K1ea1Q=;
        b=DtV3lpuBSUF6d3jaz25NP6KJiZ8gtB06plzlPmxAovYzD8MTkmL66H6YLFsoAR1CBr
         XSAlT4jE1F2LlpvymSa4ktP9VZWdLsz45/+IOx0VlpRyLXU0lSE7G1tvagW6ixMMT3hj
         NSxRXsljfk0sx+Ztq97Vrql3kla/1atgHNaXuoHKG+eYmRC1SWRWK6qiOKOAlQj7zGjR
         LuimEqw4c4Z5i4yli2oNc8Aus+n+N6c57xp1hN+WIuCc7JpS0+w5/TC7rhjO4cYcKFRR
         9VHb3EPPTQO5OUInFB0xuzMMY0DEq0+VJ5YkJlXYDNLz0BYEccagFqCL9LRYL0fYPbrJ
         WBsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=FCFoAdp+gpplebsvzRZutt6p9sl8bNSF5bkg2K1ea1Q=;
        b=ZQrekhCSmadQSh13jr8xi9aLWyImthKu9ux64KiUUz+wwHLCQyjCES1u9lhG+4e+75
         oTpthQaK/fvMwKPNIa4mfD0vgp5374ZWwmSOU9XcEfG9yUhRgezxCbswixyD7WC8VRtK
         2aeULS+QttwwvxjOUfVBRWlcjeIAQPlrFCX29EmPQ2m9+cPZeHpYSl0Qoyrks+XL1+mk
         q5VcluiuTKqoKYCcSLOz0VSh9WWNT2sJ9kMQSUtpBENHhJ6yE5jujWa/ikCdinKCq60/
         A/TZyuQDsiL7GJY2FmqF8umdJ3pWNJcsgyCyzPKNwXzgvwsvhvnm6ZtlbLV0KIuGuXp6
         Z/RQ==
X-Gm-Message-State: AGi0PubuaUqn6kraKCI2mBvSSOcILJQhntT1uuOdpo0JA6oj07yTU63i
        V4q2/VPPqdwV4bPU4F23wWU7GQ==
X-Google-Smtp-Source: APiQypIiiVK2DsdwWMGKszUJd8taKUj32s+YLADiLW6HMHpVDcOib9294kUnK3olsAb53XwW/RIfWQ==
X-Received: by 2002:ac8:728b:: with SMTP id v11mr22826308qto.108.1587493378239;
        Tue, 21 Apr 2020 11:22:58 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id t15sm2325193qtc.64.2020.04.21.11.22.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 21 Apr 2020 11:22:57 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jQxXs-0003lE-Lt; Tue, 21 Apr 2020 15:22:56 -0300
Date:   Tue, 21 Apr 2020 15:22:56 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     "Saleem, Shiraz" <shiraz.saleem@intel.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>
Subject: Re: [RFC PATCH v5 01/16] RDMA/irdma: Add driver framework definitions
Message-ID: <20200421182256.GT26002@ziepe.ca>
References: <20200417171251.1533371-1-jeffrey.t.kirsher@intel.com>
 <20200417171251.1533371-2-jeffrey.t.kirsher@intel.com>
 <20200417193421.GB3083@unreal>
 <9DD61F30A802C4429A01CA4200E302A7DCD4853F@fmsmsx124.amr.corp.intel.com>
 <20200421004628.GQ26002@ziepe.ca>
 <9DD61F30A802C4429A01CA4200E302A7DCD4A3E9@fmsmsx124.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9DD61F30A802C4429A01CA4200E302A7DCD4A3E9@fmsmsx124.amr.corp.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 21, 2020 at 06:19:07PM +0000, Saleem, Shiraz wrote:
> > Subject: Re: [RFC PATCH v5 01/16] RDMA/irdma: Add driver framework
> > definitions
> > 
> > On Tue, Apr 21, 2020 at 12:23:45AM +0000, Saleem, Shiraz wrote:
> > > > Subject: Re: [RFC PATCH v5 01/16] RDMA/irdma: Add driver framework
> > > > definitions
> > > >
> > > > On Fri, Apr 17, 2020 at 10:12:36AM -0700, Jeff Kirsher wrote:
> > > > > From: Mustafa Ismail <mustafa.ismail@intel.com>
> > > > >
> > > > > Register irdma as a virtbus driver capable of supporting virtbus
> > > > > devices from multi-generation RDMA capable Intel HW. Establish the
> > > > > interface with all supported netdev peer drivers and initialize HW.
> > > > >
> > > > > Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> > > > > Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> > > > > drivers/infiniband/hw/irdma/i40iw_if.c | 228 ++++++++++
> > > > > drivers/infiniband/hw/irdma/irdma_if.c | 449 ++++++++++++++++++
> > > > >  drivers/infiniband/hw/irdma/main.c     | 573 +++++++++++++++++++++++
> > > > >  drivers/infiniband/hw/irdma/main.h     | 599
> > +++++++++++++++++++++++++
> > > > >  4 files changed, 1849 insertions(+)  create mode 100644
> > > > > drivers/infiniband/hw/irdma/i40iw_if.c
> > > > >  create mode 100644 drivers/infiniband/hw/irdma/irdma_if.c
> > > > >  create mode 100644 drivers/infiniband/hw/irdma/main.c
> > > > >  create mode 100644 drivers/infiniband/hw/irdma/main.h
> > > > >
> > > >
> > > > I didn't look in too much details, but three things caught my attention
> > immediately:
> > > > 1. Existence of ARP cache management logic in RDMA driver.
> > >
> > > Our HW has an independent ARP table for the rdma block.
> > > driver needs to add an ARP table entry via an rdma admin queue command
> > > before QP transitions to RTS.
> > >
> > > > 2. Extensive use of dev_*() prints while we have ibdev_*() prints
> > > The ib device object is not available till the end of the device init
> > > similarly its unavailable early on in device deinit flows. So dev_* is
> > > all we can use in those places.
> > 
> > hns guys were thinking about changing this. It looks fine to just move the name
> > assignment to the device allocation, then we don't have this weirdness
> 
> Did you mean moving name setting from ib_register_device to ib_device_alloc?
> Will that work ok for how rvt is handling the names in rvt_set_ibdev_name
> and its register?

I don't see why not? rvt_set_ibdev_name is always directly after
rvt_alloc_device, which is the thing that calls ib_alloc_device

> This could migrate a lot of the dev_* to ibdev_* but there is still
> going to be a handful of dev_* usages from our HW initialization in
> irdma_prob_dev since ib device allocation is done in irdma_open.

Don't do that?

> > Alternatively, you could do as netdev does and have a special name string when
> > the name is NULL
> 
> Not sure I found what your referring to. 
> Did you mean similar to use of netdev_name in __netdev_printk?

Yes

Jason
