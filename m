Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9751BB27B
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 02:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbgD1ADr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 20:03:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726282AbgD1ADq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 20:03:46 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A57D5C0610D5
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 17:03:46 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id n143so20117358qkn.8
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 17:03:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+dJHzHn3P3N/q9k7RcYAVsGHDtVe7jVKqq70yFQhzc0=;
        b=KKYhkj2FeBFdqsp/q8cx2WVbbNF2nkENbcnp4aPJvbMpvqJB7jmxB8Fk2YWn27WraL
         Z5sOQhyHwgeNbNkyNqfZUu9qgUDBOzuoDntUFLSxgO77gh2kymx4GUexp90rqqGiZEIl
         LHpyBI18IEA0AZtDqy2wIxNrifRK3RE8SHAbO6v9eM38nmQ3mJejidj9EFW1ejqRAdG9
         sXJhiUq+Vey6A92z/qJ+/u4AbD5sS1FJTis4xuOwTSmva3l8LHhIDfouEDDK74m0u2az
         W//yRIPuY8iM8hj6EP1ae4QJubFC/AQoSQq8q8FJ+HdhmWy0wyRuW3Gf/yTnP2wx2fSa
         A2QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+dJHzHn3P3N/q9k7RcYAVsGHDtVe7jVKqq70yFQhzc0=;
        b=eFu3M4ycVNJytvPDsQgwpzrSCyppG/umRkMC0B9a9VPYEmQqbHTZY+4kIdMB/9bWp/
         GSeHgyRmtV060wc7O07LddgpnnsxDn/NIkQBqOO67pR1KlHGONn5ICRhmtVeOUF56rXv
         5XYeh8nH3omXZX55GBgxTl9sRicM2+tVUC2E4JeAfI34VulgVYreOvYxFQYLtVdcTUBK
         mEdZj4ZqkLxsAHs8sXk5hB6DsUzbGsKZlZJPhy6JkVsw7wQsQFRnFCkU+c6oVQSRml6P
         Ir2IhJuSkp8a60VRnRsXt3ClVLWrvrGid41LvQKp7MedVfd1rgUpOnuUQZK917vC8VRn
         S/Hw==
X-Gm-Message-State: AGi0PuY4E/LycscMsSqxxQCPIAYi+wZ1CQE1X0Pg+ymT6gY703VRm9Oy
        6q8PRtpGyUYYSeMspVFc/T1FRL/DFMRr/A==
X-Google-Smtp-Source: APiQypJNnMmCgxqMQi9ZBtOvvkq6cwBClxPeotMbRiAQPWM5AIuUcQ17eADRALmm6Dvu9ReDyz1D6w==
X-Received: by 2002:a37:7d0:: with SMTP id 199mr22580629qkh.499.1588032225741;
        Mon, 27 Apr 2020 17:03:45 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id 28sm12255259qkp.10.2020.04.27.17.03.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 27 Apr 2020 17:03:45 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jTDiy-0002Jv-Gh; Mon, 27 Apr 2020 21:03:44 -0300
Date:   Mon, 27 Apr 2020 21:03:44 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     "Saleem, Shiraz" <shiraz.saleem@intel.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Patil, Kiran" <kiran.patil@intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Sharp, Robert O" <robert.o.sharp@intel.com>,
        "Lacombe, John S" <john.s.lacombe@intel.com>
Subject: Re: [RFC PATCH v5 01/16] RDMA/irdma: Add driver framework definitions
Message-ID: <20200428000344.GO26002@ziepe.ca>
References: <20200421004628.GQ26002@ziepe.ca>
 <9DD61F30A802C4429A01CA4200E302A7DCD4A3E9@fmsmsx124.amr.corp.intel.com>
 <20200421182256.GT26002@ziepe.ca>
 <9DD61F30A802C4429A01CA4200E302A7DCD4DB92@fmsmsx124.amr.corp.intel.com>
 <20200423150201.GY26002@ziepe.ca>
 <9DD61F30A802C4429A01CA4200E302A7DCD4ED27@fmsmsx124.amr.corp.intel.com>
 <20200423190327.GC26002@ziepe.ca>
 <9DD61F30A802C4429A01CA4200E302A7DCD4FD03@fmsmsx124.amr.corp.intel.com>
 <20200424004841.GD26002@ziepe.ca>
 <9DD61F30A802C4429A01CA4200E302A7DCD5588C@fmsmsx124.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9DD61F30A802C4429A01CA4200E302A7DCD5588C@fmsmsx124.amr.corp.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 27, 2020 at 11:57:51PM +0000, Saleem, Shiraz wrote:
> > Subject: Re: [RFC PATCH v5 01/16] RDMA/irdma: Add driver framework
> > definitions
> > 
> > On Thu, Apr 23, 2020 at 11:54:18PM +0000, Saleem, Shiraz wrote:
> > > > Subject: Re: [RFC PATCH v5 01/16] RDMA/irdma: Add driver framework
> > > > definitions
> > > >
> > > > On Thu, Apr 23, 2020 at 05:15:22PM +0000, Saleem, Shiraz wrote:
> > > > > > Subject: Re: [RFC PATCH v5 01/16] RDMA/irdma: Add driver
> > > > > > framework definitions
> > > > > >
> > > > > > On Thu, Apr 23, 2020 at 12:32:48AM +0000, Saleem, Shiraz wrote:
> > > > > >
> > > > > > > we have a split initialization design for gen2 and future products.
> > > > > > > phase1 is control path resource initialization in
> > > > > > > irdma_probe_dev and
> > > > > > > phase-2 is the rest of the resources with the ib registration
> > > > > > > at the end of irdma_open. irdma_close must de-register the ib
> > > > > > > device which will take care of ibdev free too. So it makes
> > > > > > > sense to keep allocation of the ib device in irdma_open.
> > > > > >
> > > > > > The best driver pattern is to allocate the ib_device at the very
> > > > > > start of probe() and use this to anchor all the device resources and
> > memories.
> > > > > >
> > > > > > The whole close/open thing is really weird, you should get rid of it.
> > > > > maybe I missing something. But why is it weird?
> > > >
> > > > Because the RDMA driver should exist as its own entity. It does not
> > > > shutdown unless the remove() method on is struct device_driver is closed.
> > > > So what exactly are open/cose supposed to be doing? I think it is a
> > > > left over of trying to re-implement the driver model.
> > > >
> > > > > underlying configuration changes and reset management for the
> > > > > physical function need a light-weight mechanism which is realized
> > > > > with the close/open from netdev PCI drv --> rdma drv.
> > > >
> > > > > Without a teardown and re-add of virtual device off the bus.
> > > >
> > > > Yes, that is exactly right. If you have done something so disruptive
> > > > that the ib_device needs to be destroyed then you should
> > > > unplug/replug the entire virtual bus device, that is the correct and sane thing to
> > do.
> > >
> > > Well we have resources created in rdma driver probe which are used by
> > > any VF's regardless of the registration of the ib device on the PF.
> > 
> > Ugh, drivers that have the VF driver require the PF driver have a lot of problems.
> > 
> > But, even so, with your new split design, resources held for a VF belong in the
> > core pci driver, not the rdma virtual bus device.
> > 
> 
> This is not a new design per se but been this way from the get go in our first
> submission.
> 
> What your suggesting makes sense if we had a core PCI driver and
> function specific drivers (i.e netdev and rdma driver in our case).
> The resources held for VF, device IRQs and other common resource
> initialization would be done by this core PCI driver. Function specific
> drivers would bind to their virtual devices and access their slice of
> resources. It sounds architecturally more clean but this is a major
> undertaking that needs a re-write of both netdev and rdma drivers.
> Moreover not sure if we are solving any problem here and the current
> design is proven out to work for us.
> 
> As it stands now, the netdev driver is the pci driver and moving rdma
> specific admin queues / resources out of rdma PF driver to be managed
> by the netdev driver does not make a lot of sense in the present design.
> We want rdma VF specific resources be managed by rdma PF driver.
> And netdev specific VF resources by netdev PF driver.

While I won't say you need to undertake such work, it does seem very
hacky considering the new virtual bus/etc to leave it like this.

Still, you need to be able to cope with the user unbinding your
drivers in any order via sysfs. What happens to the VFs when the PF is
unbound and releases whatever resources? This is where the broadcom
driver ran into troubles..

Jason
