Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 296A01B1AE1
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 02:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbgDUAo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 20:44:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726161AbgDUAo5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 20:44:57 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F026C061A0E
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 17:44:56 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id t3so12937208qkg.1
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 17:44:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=x91/ZYzYkmQg9m8d0IVBnaTRXLpBPzU3AODYJJ1vy4k=;
        b=YDP9zqlP1MCIhXjqiTaUeZdM6Fpb0U7ngh89QFOobUMQeOw9cGxU5C7ls0c4qWTZ4d
         k0zUDBDnQp17GC5ilGS7ij/GY8K/pypGqx+Z734YZyWTndwz4a91nLmXyaoHh33c7AeD
         1LGy+Ae/rjft7SzboxjBUbabM0ykrmdpHu+jo0PWf46mW4sJYDtzu9mpf8DU5U3Jrt88
         4cntCciCQ/LuRh9bRTb+Vc5qKbPOtdJPxDuWG4fK20PPSgLETPjyocvnVw3zjDer/bjN
         yFB/DDqnV86kj4VSY7YGWzAJ8wcCaXv+zvvxo/ul5b6dpB543VTnsrvZO+cCMTnnNZTC
         4c7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=x91/ZYzYkmQg9m8d0IVBnaTRXLpBPzU3AODYJJ1vy4k=;
        b=j7RaRphD+ZKm+a6NEyLeAthEHY2ecPtVsSUmeMmnNt2jCJMuBdFHt0mhV+RieBFUFw
         ynQlieysxuWZdCijuTFP78R5ZKfhL7R1QmpzN5g2h6IZEdJ5BxYsF3otgHgEA/oiQlEs
         VafmVEBhVT/rf1AX8EfZq81Q/jiSVkTNu9N99nL3mwqP8YHQNzSo/eQ4sh4p8HlWbfV0
         kuk/jAJDm4171wga2RL4aye2Yv3kdJ83j4LiTLptQpe7CB5Oj3ckswTSqtKRobCwZ8wY
         iwiYZEbNi5XEHJsUpO/4prvpGjsp7W74W2aKzs62A7heMTXhgUO5goV/ph3KDvJm7jAB
         iN1Q==
X-Gm-Message-State: AGi0PuawGK0EHLQ1LCEcug+M/GOu0Tg+KlgbG++idEAGhT4dl1+1Seih
        ZSCNjKCHdjwGr3cHAEZQtImCjg==
X-Google-Smtp-Source: APiQypLpAawcTprI4p8JJq5XF8xlKLVPh959xCmQtZ+XZiB9WLa4JZe6SBjXN8xr2867p4oBbZp3MQ==
X-Received: by 2002:a05:620a:844:: with SMTP id u4mr2154881qku.20.1587429895694;
        Mon, 20 Apr 2020 17:44:55 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id o94sm727048qtd.34.2020.04.20.17.44.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 20 Apr 2020 17:44:55 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jQh1y-00059E-6n; Mon, 20 Apr 2020 21:44:54 -0300
Date:   Mon, 20 Apr 2020 21:44:54 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     "Ertman, David M" <david.m.ertman@intel.com>
Cc:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "galpress@amazon.com" <galpress@amazon.com>,
        "selvin.xavier@broadcom.com" <selvin.xavier@broadcom.com>,
        "sriharsha.basavapatna@broadcom.com" 
        <sriharsha.basavapatna@broadcom.com>,
        "benve@cisco.com" <benve@cisco.com>,
        "bharat@chelsio.com" <bharat@chelsio.com>,
        "xavier.huwei@huawei.com" <xavier.huwei@huawei.com>,
        "yishaih@mellanox.com" <yishaih@mellanox.com>,
        "leonro@mellanox.com" <leonro@mellanox.com>,
        "mkalderon@marvell.com" <mkalderon@marvell.com>,
        "aditr@vmware.com" <aditr@vmware.com>,
        "ranjani.sridharan@linux.intel.com" 
        <ranjani.sridharan@linux.intel.com>,
        "pierre-louis.bossart@linux.intel.com" 
        <pierre-louis.bossart@linux.intel.com>,
        "Patil, Kiran" <kiran.patil@intel.com>,
        "Bowers, AndrewX" <andrewx.bowers@intel.com>
Subject: Re: [net-next 1/9] Implementation of Virtual Bus
Message-ID: <20200421004454.GP26002@ziepe.ca>
References: <20200417171034.1533253-1-jeffrey.t.kirsher@intel.com>
 <20200417171034.1533253-2-jeffrey.t.kirsher@intel.com>
 <20200417195148.GL26002@ziepe.ca>
 <DM6PR11MB284111B69E966E68EBC2C508DDD40@DM6PR11MB2841.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR11MB284111B69E966E68EBC2C508DDD40@DM6PR11MB2841.namprd11.prod.outlook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 20, 2020 at 11:16:38PM +0000, Ertman, David M wrote:
> > > +/**
> > > + * virtbus_register_device - add a virtual bus device
> > > + * @vdev: virtual bus device to add
> > > + */
> > > +int virtbus_register_device(struct virtbus_device *vdev)
> > > +{
> > > +	int ret;
> > > +
> > > +	/* Do this first so that all error paths perform a put_device */
> > > +	device_initialize(&vdev->dev);
> > > +
> > > +	if (!vdev->release) {
> > > +		ret = -EINVAL;
> > > +		dev_err(&vdev->dev, "virtbus_device MUST have a .release
> > callback that does something.\n");
> > > +		goto device_pre_err;
> > 
> > This does put_device but the release() hasn't been set yet. Doesn't it
> > leak memory?
> 
> The KO registering the virtbus_device is responsible for allocating
> and freeing the memory for the virtbus_device (which should be done
> in the release() function).  If there is no release function
> defined, then the originating KO needs to handle this.  We are
> trying to not recreate the platform_bus, so the design philosophy
> behind virtual_bus is minimalist.

Oh, a precondition assertion should just be written as something like:

   if (WARN_ON(!vdev->release))
       return -EINVAL;

And done before device_initialize

But I wouldn't bother, things will just reliably crash on null pointer
exceptions if a driver mis-uses the API.

> > > +	}
> > > +
> > > +	/* All device IDs are automatically allocated */
> > > +	ret = ida_simple_get(&virtbus_dev_ida, 0, 0, GFP_KERNEL);
> > > +	if (ret < 0) {
> > > +		dev_err(&vdev->dev, "get IDA idx for virtbus device failed!\n");
> > > +		goto device_pre_err;
> > 
> > Do this before device_initialize()
>
> The memory for virtbus device is allocated by the KO registering the
> virtbus_device before it calls virtbus_register_device().  If this
> function is exiting on an error, then we have to do a put_device()
> so that the release is called (if it exists) to clean up the memory.

put_device() must call virtbus_release_device(), which does
ida_simple_remove() on vdev->id which hasn't been set yet.

Also ->release wasn't initialized at this point so its leaks memory..

> The ida_simple_get is not used until later in the function when
> setting the vdev->id.  It doesn't matter what IDA it is used, as
> long as it is unique.  So, since we cannot have the error state
> before the device_initialize, there is no reason to have the
> ida_sinple_get before the device_initialization.

I was a bit wrong on this advice because no matter what you have to do
put_device(), so you need to add some kind of flag that the vdev->id
is not valid.

It is ugly. It is nicer to arrange thing so initialization is done
after kalloc but before device_initialize. For instance look how
vdpa_alloc_device() and vdpa_register() work, very clean, very simple
goto error unwinds everywhere.

> GregKH was pretty insistent that all error paths out of this
> function go through a put_device() when possible.

After device_initialize() is called all error paths must go through
put_device.

> > Can't understand why vdev->name is being passed in with the struct,
> > why not just a function argument?
> 
> This avoids having the calling KO have to manage a separate piece of memory
> to hold the name during the call to virtbus_device_regsiter.  It is a cleaner
> memory model to just store it once in the virtbus_device itself.  This name is
> the abbreviated name without the ID appended on the end, which will be used
> for matching drivers and devices.

Your other explanation was better. This would be less confusing if it
was called match_name/device_label/driver_key or something, as it is
not the 'name'.

> > > + * virtbus_unregister_device - remove a virtual bus device
> > > + * @vdev: virtual bus device we are removing
> > > + */
> > > +void virtbus_unregister_device(struct virtbus_device *vdev)
> > > +{
> > > +	device_del(&vdev->dev);
> > > +	put_device(&vdev->dev);
> > > +}
> > > +EXPORT_SYMBOL_GPL(virtbus_unregister_device);
> > 
> > Just inline this as wrapper around device_unregister
> 
> I thought that EXPORT_SYMBOL makes inline meaningless?
> But, putting device_unregister here is a good catch.

I mean move it to the header file and inline it

Jason
