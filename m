Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A337F1A2E3
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 20:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727535AbfEJSRU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 14:17:20 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:45592 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727453AbfEJSRT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 May 2019 14:17:19 -0400
Received: by mail-qk1-f194.google.com with SMTP id j1so4220482qkk.12
        for <netdev@vger.kernel.org>; Fri, 10 May 2019 11:17:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=l+dTlD8EzUiEZ36qCTDTFyiWR4lfkfM2VCg1MNYurkY=;
        b=Zgib1X4YQpQ2wp128y5tUYsG2Hjp4NFwNmZl/CXkRDeIIAehtHLLb7f2CPpXOI4+X5
         zyLagT0bavmw9FVZfJG2MXZtFx3ghMZ7Q8uURoGkgGdvb58PtAA9ET3jJHHZmKguSrN1
         soJeFbh7jT0q6Ji7CwW8ezK2pYaRw15jIOG/lOz7EOdehY7IM9KmfewSe4HMFYu282Sh
         9Q4AQR/v6p4X/CFJpyWfp7prfUkg1bq5dyRubms3f7PRFX94RlWZb1L8qQVcL2DYuVwj
         fgBeoy1rE+HIyzWjxwtx8GekACJ/XpXMVEcoP4DYlBcevbxbapazhHYH7oGpNzr0zKyO
         Bixw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=l+dTlD8EzUiEZ36qCTDTFyiWR4lfkfM2VCg1MNYurkY=;
        b=I3M902/tIKE1EAM9939jTXGp2hdzEEP2Db/CNVrvlcM6TogTmVyAYtdiPIyUOJFhXy
         iPqkZ/ndFGa81v7y/QvZc6mkkWmi6kKQ1BJZdB9gD5449ihzO92F6A6o8K3JRb1yTqPk
         r10CzzO4Fs2DAQwPdd5KLW4E9AE80CsuXnt5iJcNcyiH3DtVQvg6PxT+JDeZk+O0DQ3N
         O9sZotkLL9z2GSScAgwPp3L0s6gJiYbfTU3EbS3rBpyy1yTeE2kFE6TjXo5MyH1ficGR
         Cn4UlQFtIdBRviqutIvVBmb10d0/9P85E7R5mD6xhtbcQdmRfhig7CKx63rvXLi6eeyk
         U/kw==
X-Gm-Message-State: APjAAAUFeuSXdSQ+9csZ3n0ex0SrEEcRnkFlMfbj8n3Px2W+KxLOl4ld
        Ek/NEa1WJZ9uDiMLeZtIIio0pg==
X-Google-Smtp-Source: APXvYqw95u1KxHc5IxcBPSE1I7gQ9e3pljAG3yIWIYntu9vpvwCQvLIaGtrdNrdCYFrBsIIb5YPzmQ==
X-Received: by 2002:a37:aa55:: with SMTP id t82mr4344515qke.136.1557512238725;
        Fri, 10 May 2019 11:17:18 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-49-251.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.49.251])
        by smtp.gmail.com with ESMTPSA id u21sm3946092qtk.61.2019.05.10.11.17.18
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 10 May 2019 11:17:18 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1hPA57-0006oe-Mh; Fri, 10 May 2019 15:17:17 -0300
Date:   Fri, 10 May 2019 15:17:17 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Shiraz Saleem <shiraz.saleem@intel.com>
Cc:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "Patil, Kiran" <kiran.patil@intel.com>
Subject: Re: [RFC v1 01/19] net/i40e: Add peer register/unregister to struct
 i40e_netdev_priv
Message-ID: <20190510181717.GG13038@ziepe.ca>
References: <20190215171107.6464-1-shiraz.saleem@intel.com>
 <20190215171107.6464-2-shiraz.saleem@intel.com>
 <20190215172233.GC30706@ziepe.ca>
 <9DD61F30A802C4429A01CA4200E302A7A5A471B8@fmsmsx124.amr.corp.intel.com>
 <20190221193523.GO17500@ziepe.ca>
 <2B0E3F215D1AB84DA946C8BEE234CCC97B11DF23@ORSMSX101.amr.corp.intel.com>
 <20190222202340.GY17500@ziepe.ca>
 <c53c117d58b8bbe325b3b32d6681b84cf422b773.camel@intel.com>
 <20190313132841.GI20037@ziepe.ca>
 <20190510133102.GA13780@ssaleem-MOBL4.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190510133102.GA13780@ssaleem-MOBL4.amr.corp.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 10, 2019 at 08:31:02AM -0500, Shiraz Saleem wrote:
> On Wed, Mar 13, 2019 at 07:28:41AM -0600, Jason Gunthorpe wrote:
> > 
> > > > Register a device driver to the driver core and wait for the driver
> > > > core to call that driver's probe method.
> > > 
> > > Yes, the LAN PF driver is the software component exposing and managing the
> > > bus, so it is the one who will call probe/remove of the peer driver (RDMA
> > > driver).  Although netdev notifiers based approach is needed if the RDMA
> > > driver was loaded first before the LAN PF driver (i40e or ice) is loaded.
> > 
> > Why would notifiers be needed? Driver core handles all these ordering
> > things. If you have a device_driver with no device it waits until a
> > device gets plugged in to call probe.
> > 
> 
> Hi Jason - Your feedback here is much appreciated and we have revisited our design based on it.
> The platform driver/device model is a good fit for us with the addition of RDMA capable devices
> to the virtual platform bus. Here are the highlights of design and how they address your concerns.
> 
> (1) irdma driver registers itself as a platform driver with its own probe()/remove() routines.
>     It will support RDMA capable platform devices from different Intel HW generations. 
> (2) The intel net driver will register RDMA capable devices on the platform bus.
> (3) Exposing a virtual bus type in the netdev driver is redundant and thus removed.
>     Additionally, it would require the bus object to be exported in order for irdma to register,
>     which doesnt allow irdma to be unified. 
> (4) In irdma bus probe(), we are able to reach each platform dev's associated net-specific
>     data including the netdev. 
> (5) There are no ordering dependencies between net-driver and irdma since it's managed by driver
>     core as you stated. Listening to netdev notifiers for attachment is no longer required and
>     thus removed.

This sounds a bount right, but you will want to run these details by
Greg KH. I think he will tell you to use the multi-function device
stuff, not a platform device.

Jason
