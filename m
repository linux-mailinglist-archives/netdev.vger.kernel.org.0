Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3991B6429
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 21:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730371AbgDWTDc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 15:03:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730366AbgDWTDb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 15:03:31 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F14AC09B043
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 12:03:29 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id c23so5277118qtp.11
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 12:03:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=rZtX23hw1mDQPuScQ5YaUda61/3w5TZYvLEZ6jNWCt0=;
        b=Xf6kX2y3lAHY7/NPaFvUbcNmV/gai3T0WQ1lG+u6e5LZWSlwfrxfzSsMEQu0z+YSxd
         pHhek810+1F39o2ynxdh0ygZlRJdca9CyY4tVsq+aZ/4nTTYy504Ir4Q6cXFkiq6jipl
         vR8oyllAS0oApdUavbEIZ1GDxg1o/J9r6ar2e5xIM4RJiiAMMSyoTf7BkChMNSUAmh93
         T74z4D7iqViU+jcBxVwS8W26MZx/74mCcE+OCnU28sxG5S7lih35H6jSpo5UirZ4I6Ar
         aX71daIrJs4EetvmbQtH97aJmhdno+AfMRGcQfPiv15b7FDyhcHOtM7oH2ANf17VZD+W
         I6Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=rZtX23hw1mDQPuScQ5YaUda61/3w5TZYvLEZ6jNWCt0=;
        b=StUcn/96eMUOlP1uBgmZkcqJwxG0o1SO0kDOz/2GuTnoNBjocerT7d8NzwLnn7yG70
         3ky8W7TIliUpkj+QbZvTL8ka8JXfW/pTI4dC5bZjTwDE7ZKSPCOcSaCZd+Ze/Zr+ay/r
         IpoSJ92pqFWfmQdbcnvKA2y1sQR91OPWlvyUDIVWF9qxFSvfNOUrLXiif125QzgbE5vv
         GVyDsk9CqAoZ6dGAHs7zG9wkZKLYk0+uZqoYXxGgI/gL49ej5mF8ySXxx5KNqVCmG95v
         X9Qs03ca9nspZZVW8ChCSRK548vHl+RmEu8CoAKyP+f/LDmjjd69ZEZKegZ01hmQcojE
         EOOw==
X-Gm-Message-State: AGi0PuYeR+988hx29Q4p+gIMBmGKmA1beRELOvsmxKc4U0s6nSJHPNCT
        K4m5WZTkjtJ2AZtvhWPFMAmBgQ==
X-Google-Smtp-Source: APiQypLmXL81PXHuXcYxD1Wx4ZeLiaRBGhAFUaA2MxhgdlZm8avrmnKCJLrIprTv7LJl8de0iPTc5Q==
X-Received: by 2002:ac8:4809:: with SMTP id g9mr5623041qtq.33.1587668609092;
        Thu, 23 Apr 2020 12:03:29 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id b1sm2161158qkf.103.2020.04.23.12.03.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 23 Apr 2020 12:03:28 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jRh8C-0006m7-0o; Thu, 23 Apr 2020 16:03:28 -0300
Date:   Thu, 23 Apr 2020 16:03:28 -0300
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
Message-ID: <20200423190327.GC26002@ziepe.ca>
References: <20200417171251.1533371-1-jeffrey.t.kirsher@intel.com>
 <20200417171251.1533371-2-jeffrey.t.kirsher@intel.com>
 <20200417193421.GB3083@unreal>
 <9DD61F30A802C4429A01CA4200E302A7DCD4853F@fmsmsx124.amr.corp.intel.com>
 <20200421004628.GQ26002@ziepe.ca>
 <9DD61F30A802C4429A01CA4200E302A7DCD4A3E9@fmsmsx124.amr.corp.intel.com>
 <20200421182256.GT26002@ziepe.ca>
 <9DD61F30A802C4429A01CA4200E302A7DCD4DB92@fmsmsx124.amr.corp.intel.com>
 <20200423150201.GY26002@ziepe.ca>
 <9DD61F30A802C4429A01CA4200E302A7DCD4ED27@fmsmsx124.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9DD61F30A802C4429A01CA4200E302A7DCD4ED27@fmsmsx124.amr.corp.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 23, 2020 at 05:15:22PM +0000, Saleem, Shiraz wrote:
> > Subject: Re: [RFC PATCH v5 01/16] RDMA/irdma: Add driver framework
> > definitions
> > 
> > On Thu, Apr 23, 2020 at 12:32:48AM +0000, Saleem, Shiraz wrote:
> > 
> > > we have a split initialization design for gen2 and future products.
> > > phase1 is control path resource initialization in irdma_probe_dev and
> > > phase-2 is the rest of the resources with the ib registration at the
> > > end of irdma_open. irdma_close must de-register the ib device which
> > > will take care of ibdev free too. So it makes sense to keep allocation
> > > of the ib device in irdma_open.
> > 
> > The best driver pattern is to allocate the ib_device at the very start of probe() and
> > use this to anchor all the device resources and memories.
> > 
> > The whole close/open thing is really weird, you should get rid of it.
> maybe I missing something. But why is it weird?

Because the RDMA driver should exist as its own entity. It does not
shutdown unless the remove() method on is struct device_driver is
closed.

So what exactly are open/cose supposed to be doing? I think it is a
left over of trying to re-implement the driver model.

> underlying configuration changes and reset management for the physical
> function need a light-weight mechanism which is realized with the close/open
> from netdev PCI drv --> rdma drv.

> Without a teardown and re-add of virtual device off the bus.

Yes, that is exactly right. If you have done something so disruptive
that the ib_device needs to be destroyed then you should unplug/replug
the entire virtual bus device, that is the correct and sane thing to
do. There is no 'light weight' here, destroying the ib_device is
incredibly expensive and disruptive.

Jason
