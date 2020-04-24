Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8716F1B6A77
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 02:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728441AbgDXAso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 20:48:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728052AbgDXAso (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 20:48:44 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11E8DC09B042
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 17:48:43 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id c23so6095657qtp.11
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 17:48:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=kqQ/23kvMPhmrmbio1Pott7UiPk/E3soHL+iEgcmvJE=;
        b=pUYxO/YhdP6mGEU94Urf8DYtAWFKRSHq1lS8SA6GdE/cfQUQwzkDrLdQZuKpZLNzgs
         Bn9pqYw3xEAf68z5eCZWB4Ah2+CN4i1tPETngY5flIQZoyhjpxJYTqdkYRMsqQYAGFc+
         mzB8E8n9Bq/wBIvmgHLz+bLi6CXq0/3+WCrT3kxDF7Dxty/EtrlsRMvVTR2TfKLdfMdG
         4KrKGjhLOExomMrHST7/Buv/w+2Ny/WkkmJQV73YlwexX5lPAcb/Qs7wuFyjwdMLnhta
         Xf38fW4vxQoDlLz/kgBOsgXcnq1GowAwSMsPhUTSCT8jYROFFNMXnD+Hz/iLF6yNpw2I
         VKNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=kqQ/23kvMPhmrmbio1Pott7UiPk/E3soHL+iEgcmvJE=;
        b=T9Pp5Zqts2oSEIZyKmuV+S1ucFija1bZ7hfEjljVHbJG8SJsyP8Kvu95Us3HnFqP6I
         rXj20AYuVAA2ALM0aHGdGi3NiiePTbA5EuZ12oADBRauUYH+6Nq6o3E/V73oEL3DNHxC
         G3izM8vlg8RdXlY+eH8Z5VXc+pq6qpL4FPF657cHO5WMhbi6I/xN08p+vXGUamgwqJj9
         OzXq5Ml5d/Y0MM2qNgTvl8wmXtYfByEXrX6DySVa8OwXTDj37kCM/ch1X0NGuU71t0/N
         wTooYFxrt9U9JlsvGi0uQou9hCppiWJptfJl+cmpk3VuIVP0sI95KFJgiStJ9mvHlxM9
         Krjg==
X-Gm-Message-State: AGi0PubX1NqQnmRDrCTQvQiVs4An060BSTak1qJVVDjOp4RKT9u2cCk5
        N3JCjTd3+Y4Rn9vmLV97bDE6bg==
X-Google-Smtp-Source: APiQypKWwi1lUphnIm1u0yFW06VhOaNprkeE+qFrgi+iix9qyLy8VLygPu09qSBXOAZrrWLCnoHffw==
X-Received: by 2002:ac8:359d:: with SMTP id k29mr7227438qtb.106.1587689322283;
        Thu, 23 Apr 2020 17:48:42 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id t75sm2659650qke.127.2020.04.23.17.48.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 23 Apr 2020 17:48:41 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jRmWH-0002OL-A5; Thu, 23 Apr 2020 21:48:41 -0300
Date:   Thu, 23 Apr 2020 21:48:41 -0300
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
        "Ertman, David M" <david.m.ertman@intel.com>
Subject: Re: [RFC PATCH v5 01/16] RDMA/irdma: Add driver framework definitions
Message-ID: <20200424004841.GD26002@ziepe.ca>
References: <20200417193421.GB3083@unreal>
 <9DD61F30A802C4429A01CA4200E302A7DCD4853F@fmsmsx124.amr.corp.intel.com>
 <20200421004628.GQ26002@ziepe.ca>
 <9DD61F30A802C4429A01CA4200E302A7DCD4A3E9@fmsmsx124.amr.corp.intel.com>
 <20200421182256.GT26002@ziepe.ca>
 <9DD61F30A802C4429A01CA4200E302A7DCD4DB92@fmsmsx124.amr.corp.intel.com>
 <20200423150201.GY26002@ziepe.ca>
 <9DD61F30A802C4429A01CA4200E302A7DCD4ED27@fmsmsx124.amr.corp.intel.com>
 <20200423190327.GC26002@ziepe.ca>
 <9DD61F30A802C4429A01CA4200E302A7DCD4FD03@fmsmsx124.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9DD61F30A802C4429A01CA4200E302A7DCD4FD03@fmsmsx124.amr.corp.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 23, 2020 at 11:54:18PM +0000, Saleem, Shiraz wrote:
> > Subject: Re: [RFC PATCH v5 01/16] RDMA/irdma: Add driver framework
> > definitions
> > 
> > On Thu, Apr 23, 2020 at 05:15:22PM +0000, Saleem, Shiraz wrote:
> > > > Subject: Re: [RFC PATCH v5 01/16] RDMA/irdma: Add driver framework
> > > > definitions
> > > >
> > > > On Thu, Apr 23, 2020 at 12:32:48AM +0000, Saleem, Shiraz wrote:
> > > >
> > > > > we have a split initialization design for gen2 and future products.
> > > > > phase1 is control path resource initialization in irdma_probe_dev
> > > > > and
> > > > > phase-2 is the rest of the resources with the ib registration at
> > > > > the end of irdma_open. irdma_close must de-register the ib device
> > > > > which will take care of ibdev free too. So it makes sense to keep
> > > > > allocation of the ib device in irdma_open.
> > > >
> > > > The best driver pattern is to allocate the ib_device at the very
> > > > start of probe() and use this to anchor all the device resources and memories.
> > > >
> > > > The whole close/open thing is really weird, you should get rid of it.
> > > maybe I missing something. But why is it weird?
> > 
> > Because the RDMA driver should exist as its own entity. It does not shutdown
> > unless the remove() method on is struct device_driver is closed.
> > So what exactly are open/cose supposed to be doing? I think it is a left over of
> > trying to re-implement the driver model.
> > 
> > > underlying configuration changes and reset management for the physical
> > > function need a light-weight mechanism which is realized with the
> > > close/open from netdev PCI drv --> rdma drv.
> > 
> > > Without a teardown and re-add of virtual device off the bus.
> > 
> > Yes, that is exactly right. If you have done something so disruptive that the
> > ib_device needs to be destroyed then you should unplug/replug the entire virtual
> > bus device, that is the correct and sane thing to do.
> 
> Well we have resources created in rdma driver probe which are used by any
> VF's regardless of the registration of the ib device on the PF.

Ugh, drivers that have the VF driver require the PF driver have a lot
of problems.

But, even so, with your new split design, resources held for a VF
belong in the core pci driver, not the rdma virtual bus device.

Jason
