Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81F33F9EDB
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 01:08:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727058AbfKMAIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 19:08:21 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:34229 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726970AbfKMAIV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 19:08:21 -0500
Received: by mail-qk1-f193.google.com with SMTP id 205so215420qkk.1
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 16:08:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=r4K7R0tR2iKjDwGj7h2AdFnAhKVb+PEh8hKXGhwzheo=;
        b=fZud3ib9ugZ1H45gqE3Ufx6TkhfidwZqwWlQe2U/+whtXNqUICQgqqYOrhI9G7ja5h
         8wz4z83SrHf90CcjxE/pqx7yyuqeqCwhGO/PglcW50daiLjpDhHLPtWIatjp83enLA1i
         eCn9Cyh3/+6bkiKsYvohTq3vxERaDLgekZag44JZToiXvIR712sgs35f7P5IOnKrux9T
         5/A7S2MFI7LRleIsmz6Z3nMdOR0RBtn0kvaVabK8o6Xbo0T11MJiJ4l+a9OV5hwhSrKI
         CO6qigj/t+1GvMCaBySSbYJ+NLrLbAnXsZiSCRrRr749BBN2dmr4pM9uOxk+1bx6QohQ
         /xig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=r4K7R0tR2iKjDwGj7h2AdFnAhKVb+PEh8hKXGhwzheo=;
        b=jwWN0wZ+kFX8GHNamKVXQY2XxGFdKvXxctzWMadswfMrvIGRvWTikktcr0YhciluxB
         0h55gejQPhG19VtSfAF5i4I4EWoLDRhNZPv2Gc2DP3IiZHit9EJlpm2jTyqLHLLAc8Kp
         /W4Yi4Omada44JtslGaZHsbeN4dDQrXqYip4xg+xpIFvV/oBKWzv1jv202ZdXZ0CMRRz
         IzAJSs9RU3vZaY4T4j8pAVORhRKorJfM83H9s505UNpe+1AKiPOfiHIcD/jgno/Fbxo+
         OIXiN2Jccfa1chphFKi54erON2dJIxmmRGRkDyinwCTLxdvG9QEtG5IREH2UiWXENkLd
         Za0Q==
X-Gm-Message-State: APjAAAXq3T/EMNHZ8FWUJd9ia7BUrRdtqW6ii/wvjeP2ftsu+ExUJMZx
        iJrqQloLiSZ8smO9nDMheM41lA==
X-Google-Smtp-Source: APXvYqxUvDZJyIu1NzBqLzNMQJZcQEwGmA0sBjLaQeHkMjfR4xinoVbyQQ2cr4JogKuX1pAuI/x5jw==
X-Received: by 2002:a05:620a:205d:: with SMTP id d29mr156309qka.152.1573603700172;
        Tue, 12 Nov 2019 16:08:20 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-113-180.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.180])
        by smtp.gmail.com with ESMTPSA id m25sm309243qtc.0.2019.11.12.16.08.19
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 12 Nov 2019 16:08:19 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1iUgCp-0005iu-4h; Tue, 12 Nov 2019 20:08:19 -0400
Date:   Tue, 12 Nov 2019 20:08:19 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, davem@davemloft.net,
        Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, parav@mellanox.com,
        Kiran Patil <kiran.patil@intel.com>
Subject: Re: [net-next 1/1] virtual-bus: Implementation of Virtual Bus
Message-ID: <20191113000819.GB19615@ziepe.ca>
References: <20191111192219.30259-1-jeffrey.t.kirsher@intel.com>
 <20191112212826.GA1837470@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191112212826.GA1837470@kroah.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 12, 2019 at 10:28:26PM +0100, Greg KH wrote:

> > + */
> > +struct virtbus_device {
> > +	const char			*name;
> > +	int				id;
> > +	const struct virtbus_dev_id	*dev_id;
> > +	struct device			dev;
> > +	void				*data;
> > +};
> > +
> > +struct virtbus_driver {
> > +	int (*probe)(struct virtbus_device *);
> > +	int (*remove)(struct virtbus_device *);
> > +	void (*shutdown)(struct virtbus_device *);
> > +	int (*suspend)(struct virtbus_device *, pm_message_t state);
> > +	int (*resume)(struct virtbus_device *);
> > +	struct device_driver driver;
> > +	const struct virtbus_dev_id *id_table;
> > +};
> > +
> > +#define virtbus_get_dev_id(vdev)	((vdev)->id_entry)
> > +#define virtbus_get_devdata(dev)	((dev)->devdata)
> 
> What are these for?

As far as I can see, the scheme here, using the language from the most
recent discussion is:

   // in core or netdev module
   int mlx5_core_create()
   {
      struct mlx5_core_dev *core = kzalloc(..)

      [..]

      core->vdev = virtbus_dev_alloc("mlx5_core", core);
   }


   // in rdma module
   static int mlx5_rdma_probe(struct virtbus_device *dev)
   {
        // Get the value passed to virtbus_dev_alloc()
	struct mlx5_core_dev *core = virtbus_get_devdata(dev)

	// Use the huge API surrounding struct mlx5_core_dev
	qp = mlx5_core_create_qp(core, ...);
   }

   static struct virtbus_driver mlx5_rdma_driver = {
      .probe = mlx5_rdma_probe,
      .match = {"mlx5_core"}
   }

Drivers that match "mlx5_core" know that the opaque
'virtbus_get_devdata()' is a 'struct mlx5_core_dev *' and use that
access the core driver.

A "ice_core" would know it is some 'struct ice_core_dev *' for Intel
and uses that pointer, etc.

ie it is just a way to a pass a 'void *' from one module to another
while using the driver core to manage module autoloading and binding.

Jason
