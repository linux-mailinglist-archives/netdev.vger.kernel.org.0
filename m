Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F299016450D
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 14:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727280AbgBSNLE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 08:11:04 -0500
Received: from mail-qv1-f65.google.com ([209.85.219.65]:46742 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726617AbgBSNLE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 08:11:04 -0500
Received: by mail-qv1-f65.google.com with SMTP id y2so110134qvu.13
        for <netdev@vger.kernel.org>; Wed, 19 Feb 2020 05:11:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vlvlwshc67nfmD8mnuDhiaIo5+M0W9hN5kIZIDEuy2Q=;
        b=Rtapr6oXl/ZaEBtZq5MfyQnS/XVirN0sBqwZyUReZu3pzXQ2HAamZkYWPIMCtWRriL
         PlfqwVm3qUiKuPhjgf2FqEOb+9LWbcBCTU0xBqkoZ4U5iBzYnXMvl909/fXT0InfuC8B
         N70oP0+7MZYJDZZXXBUxPVRTR5UdfeLhq0Lh2CTq7o9GjhBv/uMIfVcKsNgtBKWUA9Bd
         687rV989HvQ3dUWl7k2hSZ8DC/1JiuaaFAFdwdrXBvqkfrDwFIG5yF4aQW32+XtdODc3
         C5J+OVhXMAC39OjPPCXmC+cRSbvP8SRplMyRJ8iDX10PRgz2xf6J2YBsk10bMlJIqOjF
         /bBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=vlvlwshc67nfmD8mnuDhiaIo5+M0W9hN5kIZIDEuy2Q=;
        b=P25HJ4JX2cjQo79gqeY8hTAUlxaAAwH0ze4YuKx8NaGCgDSaRLnjajeuH67UVrW7ob
         yfK9f9D51N62jYYu74kAMoJOnZqwusdcK22aPMEow/0XPO9ZFvG/8SKIioMlUqBjdUj7
         X32XdAlwLW7HIpUU/vviYQVmI8cJjhesqsR32xdFzLsA8ig26aSRJVKpCElriDpvxqtE
         ILUPW9IOk6wOK8dLsBKmZ1oOxsa73y4UMgU4py21mVPvo+aNeLLXREGWCBc7ksJl+ErE
         iOFAmn8sUIdInEkt+qTynWA8J416CBRDL7AcjEWjtmWPjwY5ul48Q3rhoKSQPB5pwEmb
         7pdw==
X-Gm-Message-State: APjAAAVDAmgTE2+GHu+0/NndfUwHTlN2AzvC0ess83pdXytUVmwIvAIc
        Hd/bKroN9FelkYcV1BYwDEDN4A==
X-Google-Smtp-Source: APXvYqyZcNxGLb7eHMU18r0zr3qpKpcwiysfX6S+jAaXMEUPECzgHhYx1h9AJGMzMfZeBkbc96JYEA==
X-Received: by 2002:a05:6214:965:: with SMTP id do5mr20929587qvb.202.1582117863137;
        Wed, 19 Feb 2020 05:11:03 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id m95sm939421qte.41.2020.02.19.05.11.02
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 19 Feb 2020 05:11:02 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1j4P82-000137-AB; Wed, 19 Feb 2020 09:11:02 -0400
Date:   Wed, 19 Feb 2020 09:11:02 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Tiwei Bie <tiwei.bie@intel.com>
Cc:     mst@redhat.com, jasowang@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, shahafs@mellanox.com,
        rob.miller@broadcom.com, haotian.wang@sifive.com,
        eperezma@redhat.com, lulu@redhat.com, parav@mellanox.com,
        rdunlap@infradead.org, hch@infradead.org, jiri@mellanox.com,
        hanand@xilinx.com, mhabets@solarflare.com,
        maxime.coquelin@redhat.com, lingshan.zhu@intel.com,
        dan.daly@intel.com, cunming.liang@intel.com, zhihong.wang@intel.com
Subject: Re: [PATCH] vhost: introduce vDPA based backend
Message-ID: <20200219131102.GN31668@ziepe.ca>
References: <20200131033651.103534-1-tiwei.bie@intel.com>
 <20200218135359.GA9608@ziepe.ca>
 <20200219025217.GA971968@___>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200219025217.GA971968@___>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 19, 2020 at 10:52:38AM +0800, Tiwei Bie wrote:
> > > +static int __init vhost_vdpa_init(void)
> > > +{
> > > +	int r;
> > > +
> > > +	idr_init(&vhost_vdpa.idr);
> > > +	mutex_init(&vhost_vdpa.mutex);
> > > +	init_waitqueue_head(&vhost_vdpa.release_q);
> > > +
> > > +	/* /dev/vhost-vdpa/$vdpa_device_index */
> > > +	vhost_vdpa.class = class_create(THIS_MODULE, "vhost-vdpa");
> > > +	if (IS_ERR(vhost_vdpa.class)) {
> > > +		r = PTR_ERR(vhost_vdpa.class);
> > > +		goto err_class;
> > > +	}
> > > +
> > > +	vhost_vdpa.class->devnode = vhost_vdpa_devnode;
> > > +
> > > +	r = alloc_chrdev_region(&vhost_vdpa.devt, 0, MINORMASK + 1,
> > > +				"vhost-vdpa");
> > > +	if (r)
> > > +		goto err_alloc_chrdev;
> > > +
> > > +	cdev_init(&vhost_vdpa.cdev, &vhost_vdpa_fops);
> > > +	r = cdev_add(&vhost_vdpa.cdev, vhost_vdpa.devt, MINORMASK + 1);
> > > +	if (r)
> > > +		goto err_cdev_add;
> > 
> > It is very strange, is the intention to create a single global char
> > dev?
> 
> No. It's to create a per-vdpa char dev named
> vhost-vdpa/$vdpa_device_index in dev.
> 
> I followed the code in VFIO which creates char dev
> vfio/$GROUP dynamically, e.g.:
> 
> https://github.com/torvalds/linux/blob/b1da3acc781c/drivers/vfio/vfio.c#L2164-L2180
> https://github.com/torvalds/linux/blob/b1da3acc781c/drivers/vfio/vfio.c#L373-L387
> https://github.com/torvalds/linux/blob/b1da3acc781c/drivers/vfio/vfio.c#L1553
> 
> Is it something unwanted?

Yes it is unwanted. This is some special pattern for vfio's unique
needs. 

Since this has a struct device for each char dev instance please use
the normal cdev_device_add() driven pattern here, or justify why it
needs to be special like this.

Jason
