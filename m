Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D60FAE3BD1
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 21:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392896AbfJXTKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 15:10:40 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:47010 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390839AbfJXTKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 15:10:39 -0400
Received: by mail-qt1-f194.google.com with SMTP id u22so39457416qtq.13
        for <netdev@vger.kernel.org>; Thu, 24 Oct 2019 12:10:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jtrp2/Y0icwgbdjCzOGSAzrlgUw/RSWUAAwJ8jt3s98=;
        b=Jqu8pMn0751jV9Rpt4EYdC0mLY1Tx/TMRySM/FS25GIbTHFEWl7NSncuSXuCfSH7EB
         ma0CphF1XfwWmowLvyKhMix8aFI0C8/8AJgrx/FGmtPKvkYGSpOfnrCKatBo/HywmGqS
         1BbPolYXcpujS7UruaYQ7SrGeTNwX1Cr6N38zhCbReezS8hquA6bbpF91rSv/TTkXh8c
         1npN5rytz0FyOKqBYwg2W2bVwYyMNSyRLmlF6YvJSANpUzEIOfemRxPUfo7OUKYetSGZ
         gpAh2VUJA1e5U27I11ONH03reuW7BkVCIFWH842/+LFLVxd49rGPa/iR8fkwJcxXKFWg
         I9cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=jtrp2/Y0icwgbdjCzOGSAzrlgUw/RSWUAAwJ8jt3s98=;
        b=XauFsRvCZOoU6WXuSEnYoSZKuEQYAflitJMLqBTVt3KEzNF4ongOtuA75Koi+iXtKR
         c4ssPnYKH9kU47WPlcXNQwYPmfMCg0wRkkONH1gINIEN8c4Zz417xYfeLz+2DfNGseqc
         kvqBEDl7mKJtA7tqYER4Ahxzc2yRZBx2R7tKrvMMzrWPxeLyOXyso1IVJC/2gjUZzWHR
         p9pg4tjLzDKC1CrBYo43arB6p8NIc087Ft6nnnL2i+Kj4amKg/QomuWiqWcfn5p6mq/p
         ftgOJ3h0H5oSYO2rj/e5ohBIbm186QeaVU5jThrtUXGN+ROIpKfgApgykvpa8/M8SzJ9
         cg7Q==
X-Gm-Message-State: APjAAAUSJFsXr6EIaTrCBpBWfrUmwmpoHObjO20a0j7qxtXkILwjzOwj
        C7PhwprTiROtRym5ilGZ4dCp4S/TZoo=
X-Google-Smtp-Source: APXvYqxEUu72jRuFcDMvBpsEiz/Xpp1mDCVKy+IRGKFwWVjEBKzARVlPM7nhA6TNoYLJQbGt2Zawdg==
X-Received: by 2002:ac8:7595:: with SMTP id s21mr5884159qtq.373.1571944238734;
        Thu, 24 Oct 2019 12:10:38 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-180.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.180])
        by smtp.gmail.com with ESMTPSA id v94sm12444568qtd.43.2019.10.24.12.10.38
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 24 Oct 2019 12:10:38 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1iNiVJ-0005BD-Nx; Thu, 24 Oct 2019 16:10:37 -0300
Date:   Thu, 24 Oct 2019 16:10:37 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc:     "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "Patil, Kiran" <kiran.patil@intel.com>
Subject: Re: [RFC 01/20] ice: Initialize and register multi-function device
 to provide RDMA
Message-ID: <20191024191037.GC23952@ziepe.ca>
References: <20190926164519.10471-1-jeffrey.t.kirsher@intel.com>
 <20190926164519.10471-2-jeffrey.t.kirsher@intel.com>
 <20190926180556.GB1733924@kroah.com>
 <7e7f6c159de52984b89c13982f0a7fd83f1bdcd4.camel@intel.com>
 <20190927051320.GA1767635@kroah.com>
 <2B0E3F215D1AB84DA946C8BEE234CCC97B2B1A28@ORSMSX101.amr.corp.intel.com>
 <20191023174448.GP23952@ziepe.ca>
 <2B0E3F215D1AB84DA946C8BEE234CCC97B2E0C84@ORSMSX101.amr.corp.intel.com>
 <20191023180108.GQ23952@ziepe.ca>
 <20191024185659.GE260560@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191024185659.GE260560@kroah.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 24, 2019 at 02:56:59PM -0400, gregkh@linuxfoundation.org wrote:
> On Wed, Oct 23, 2019 at 03:01:09PM -0300, Jason Gunthorpe wrote:
> > On Wed, Oct 23, 2019 at 05:55:38PM +0000, Ertman, David M wrote:
> > > > Did any resolution happen here? Dave, do you know what to do to get Greg's
> > > > approval?
> > > > 
> > > > Jason
> > > 
> > > This was the last communication that I saw on this topic.  I was taking Greg's silence as
> > > "Oh ok, that works" :)  I hope I was not being too optimistic!
> > > 
> > > If there is any outstanding issue I am not aware of it, but please let me know if I am 
> > > out of the loop!
> > > 
> > > Greg, if you have any other concerns or questions I would be happy to address them! 
> > 
> > I was hoping to hear Greg say that taking a pci_device, feeding it to
> > the multi-function-device stuff to split it to a bunch of
> > platform_device's is OK, or that mfd should be changed somehow..
> 
> Again, platform devices are ONLY for actual platform devices.  A PCI
> device is NOT a platform device, sorry.

To be fair to David, IIRC, you did suggest mfd as the solution here
some months ago, but I think you also said it might need some fixing
:)

> If MFD needs to be changed to handle non-platform devices, fine, but
> maybe what you really need to do here is make your own "bus" of
> individual devices and have drivers for them, as you can't have a
> "normal" PCI driver for these.

It does feel like MFD is the cleaner model here otherwise we'd have
each driver making its own custom buses for its multi-function
capability..

David, do you see some path to fix mfd to not use platform devices?

Maybe it needs a MFD bus type and a 'struct mfd_device' ?

I guess I'll drop these patches until it is sorted.

Jason
