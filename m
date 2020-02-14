Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65CFA15F7C6
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 21:34:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730150AbgBNUe5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 15:34:57 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:33428 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730112AbgBNUe5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 15:34:57 -0500
Received: by mail-qk1-f196.google.com with SMTP id h4so10538252qkm.0
        for <netdev@vger.kernel.org>; Fri, 14 Feb 2020 12:34:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=o6O3tnYqlMJmxPn0Sscur6Hb7BY7qd7JqevA5cfwrFs=;
        b=LMS4umkHQRBnj7llRCGiPvdHMrWWCEI2CXFORne0gSAcUBm9uiVufbp+AIHaXGzyfb
         JGJvPH/sGxW0j8MacvVl0uyKufX16HxAhghW4mzhe2i/kAQw9y6lzeIsyPHI/Q2v5eQA
         llJQJnmWOMcDMutM3L8dFrg3sD2ZmlufeHXiPxa1GXBhwJ7FBXkGkxl2TSvC4gcnu039
         QI0Qm6LPK5MyhzlNMFeSe8vCkb40PdKwo/2VPvuhR7bdmrZUXISnGofznyJNvcAKeoYH
         sSs81WIjOySS6AbUicnywyb7T+5VVmXd7XtC+nITFOEpai94a53arzh1DTdioarMmN3j
         Esvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=o6O3tnYqlMJmxPn0Sscur6Hb7BY7qd7JqevA5cfwrFs=;
        b=rfIl8GKAyMTtSfNb2IxtdVx4nDH8+AhrQDJpIVky3KUwhm13up+VpUoDg7tRARPC3k
         drDmD06sOOlzN16iZGIZ6mpQwgAoRmK45S5ln1zN76FeyRhyNh/gWmG+QqRG39VLVNGo
         35yxREOqyFUYRTYwtqKEdS8tMJ0D4To/oFASo3kySBhbgi+yBoRPiWmWv3YJLyOcfVcQ
         cqKW6EfyJS+jpT55fFtQWkO6XGd+fNlDqMbrvtR1WmK8p1DpiB8USuSIEFrzWJRG2up5
         UG+DxSPZEJzc1XH0DqjEFkdGGd3KfA248bcmqWZXhDl1lEaaWfOwev6yLyEUWBhWaJzg
         AbGw==
X-Gm-Message-State: APjAAAXLn8y+KUmAbjBF36JPHZgQXnuN4RtXRdSXhnDPsgbNZo6fdZjZ
        SiDZXnrrcMYPbo8161JdxxEcYg==
X-Google-Smtp-Source: APXvYqxxXXiXj+lNYVanDfJMu6MImip4ngT7l0QsnRFqn4+O+jsCtSq4iy64PFVvPmC+7brmPm/J7g==
X-Received: by 2002:a37:f60b:: with SMTP id y11mr4424390qkj.183.1581712496498;
        Fri, 14 Feb 2020 12:34:56 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id d69sm3999798qkg.63.2020.02.14.12.34.55
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 14 Feb 2020 12:34:56 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1j2hfr-0007GE-HZ; Fri, 14 Feb 2020 16:34:55 -0400
Date:   Fri, 14 Feb 2020 16:34:55 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, davem@davemloft.net,
        Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, parav@mellanox.com, galpress@amazon.com,
        selvin.xavier@broadcom.com, sriharsha.basavapatna@broadcom.com,
        benve@cisco.com, bharat@chelsio.com, xavier.huwei@huawei.com,
        yishaih@mellanox.com, leonro@mellanox.com, mkalderon@marvell.com,
        aditr@vmware.com, Kiran Patil <kiran.patil@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: Re: [RFC PATCH v4 01/25] virtual-bus: Implementation of Virtual Bus
Message-ID: <20200214203455.GX31668@ziepe.ca>
References: <20200212191424.1715577-1-jeffrey.t.kirsher@intel.com>
 <20200212191424.1715577-2-jeffrey.t.kirsher@intel.com>
 <20200214170240.GA4034785@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200214170240.GA4034785@kroah.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 14, 2020 at 09:02:40AM -0800, Greg KH wrote:
> > +/**
> > + * virtbus_dev_register - add a virtual bus device
> > + * @vdev: virtual bus device to add
> > + */
> > +int virtbus_dev_register(struct virtbus_device *vdev)
> > +{
> > +	int ret;
> > +
> > +	if (!vdev->release) {
> > +		dev_err(&vdev->dev, "virtbus_device .release callback NULL\n");
> 
> "virtbus_device MUST have a .release callback that does something!\n" 
> 
> > +		return -EINVAL;
> > +	}
> > +
> > +	device_initialize(&vdev->dev);
> > +
> > +	vdev->dev.bus = &virtual_bus_type;
> > +	vdev->dev.release = virtbus_dev_release;
> > +	/* All device IDs are automatically allocated */
> > +	ret = ida_simple_get(&virtbus_dev_ida, 0, 0, GFP_KERNEL);
> > +	if (ret < 0) {
> > +		dev_err(&vdev->dev, "get IDA idx for virtbus device failed!\n");
> > +		put_device(&vdev->dev);
> 
> If you allocate the number before device_initialize(), no need to call
> put_device().  Just a minor thing, no big deal.

If *_regster does put_device on error then it must always do
put_device on any error, for instance the above return -EINVAL with
no put_device leaks memory.

Generally I find the design and audit of drivers simpler if the
register doesn't do device_initialize or put_device - have them
distinct and require the caller to manage this.

For instance look at ice_init_peer_devices() and ask who frees
the alloc_ordered_workqueue() if virtbus_dev_register() fails..

It is not all easy to tell if this is right or not..

> > +	put_device(&vdev->dev);
> > +	ida_simple_remove(&virtbus_dev_ida, vdev->id);
> 
> You need to do this before put_device().

Shouldn't it be in the release function? The ida index should not be
re-used until the kref goes to zero..

> > +struct virtbus_device {
> > +	struct device dev;
> > +	const char *name;
> > +	void (*release)(struct virtbus_device *);
> > +	int id;
> > +	const struct virtbus_dev_id *matched_element;
> > +};
> 
> Any reason you need to make "struct virtbus_device" a public structure
> at all? 

The general point of this scheme is to do this in a public header:

+struct iidc_virtbus_object {
+	struct virtbus_device vdev;
+	struct iidc_peer_dev *peer_dev;
+};

And then this when the driver binds:

+int irdma_probe(struct virtbus_device *vdev)
+{
+       struct iidc_virtbus_object *vo =
+                       container_of(vdev, struct iidc_virtbus_object, vdev);
+       struct iidc_peer_dev *ldev = vo->peer_dev;

So the virtbus_device is in a public header to enable the container_of
construction.

Jason
