Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2A715FB45
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 01:02:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728049AbgBOAB5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 19:01:57 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:36080 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726164AbgBOAB5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 19:01:57 -0500
Received: by mail-qk1-f193.google.com with SMTP id w25so10970953qki.3
        for <netdev@vger.kernel.org>; Fri, 14 Feb 2020 16:01:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=XEi2FMlL3FDRXNEQ686FOrWVAjWSu9XOGJ0ePD5RXao=;
        b=Qyd0Jph2hjeTWbf+E6jk4Fwpvy43HacB4yZl2C8TQVUQsfW1fy4/RczMd5TGOu08ax
         mFFSu2+9BtPO5CLtfeQEXuSCQ1qC3SiGQ5HzkwEl1nRSB0MVIQDOqGuPsfN+yJSaDwoj
         dYsztu3iheEnDXIBUaOEo5h21lYirUNIq98645veb2fHhcW5IQoaA2kpICmdrjHbzgYf
         0Qo9f+ZFRObAIqf0mYX9WyrT9poQp0OTCgkCRhE/0YedW2E4yL3/ptw5WH9BUAr9kZyM
         Qs+N2WP6lP9zJA65b9sqJmyKU66PyoF/ewVfOF5DYB6cI7MUxdab18rQ2v0WN8AIl8dv
         EiOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=XEi2FMlL3FDRXNEQ686FOrWVAjWSu9XOGJ0ePD5RXao=;
        b=kjZxjzx4W2F5T0i32+Zfyf5MI9378B8HnFvmgZh5qRFRBx0sV2ItYgVZvcpo1H7LUf
         3h9wL2KmocAtQhTs1PPjpdEIlO8pEkBnX9B2ApDmeYe43kPy+hw8Y5X48b4nadl47TgK
         bpGCetm1sr+LNMB2RtVQUfjz2QbHfXLlfTzNgs+vw/aeo7YWauHDPzl+uXTGc+LF21OQ
         Ho/UMZY7dnnIXK97+Cp7GQUWpvCWMvybkOl6MVaxysY9TxxOZqyUOSlX4ZIGGioKD6zp
         QrUMcKQSnHEr1XgYuIG/ZDbJ4/yyBmcERF8JLMrhVAitLMCixNuNF3yMkHLZcGcXkAao
         4fMw==
X-Gm-Message-State: APjAAAWZsqLg6herTlLZSSvutM0aQ0Tbr+TwBaPbl8vZA4oICuqntyrZ
        iH2hj3vZ8fJjKiAamUTqBL4MLQ==
X-Google-Smtp-Source: APXvYqxvnAT5vgxkxlp1ZQSyjDd9tZKgFJYS+wzd6guOmUylL/cNgKlPVlkr1TkqiQ9Bxp+wYwuq8Q==
X-Received: by 2002:a37:498b:: with SMTP id w133mr4930991qka.52.1581724916142;
        Fri, 14 Feb 2020 16:01:56 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id w60sm4138663qte.39.2020.02.14.16.01.55
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 14 Feb 2020 16:01:55 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1j2kuA-0003gi-Rs; Fri, 14 Feb 2020 20:01:54 -0400
Date:   Fri, 14 Feb 2020 20:01:54 -0400
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
Message-ID: <20200215000154.GZ31668@ziepe.ca>
References: <20200212191424.1715577-1-jeffrey.t.kirsher@intel.com>
 <20200212191424.1715577-2-jeffrey.t.kirsher@intel.com>
 <20200214170240.GA4034785@kroah.com>
 <20200214203455.GX31668@ziepe.ca>
 <20200214204341.GB4086224@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200214204341.GB4086224@kroah.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 14, 2020 at 03:43:41PM -0500, Greg KH wrote:
> On Fri, Feb 14, 2020 at 04:34:55PM -0400, Jason Gunthorpe wrote:
> > On Fri, Feb 14, 2020 at 09:02:40AM -0800, Greg KH wrote:
> > > > +/**
> > > > + * virtbus_dev_register - add a virtual bus device
> > > > + * @vdev: virtual bus device to add
> > > > + */
> > > > +int virtbus_dev_register(struct virtbus_device *vdev)
> > > > +{
> > > > +	int ret;
> > > > +
> > > > +	if (!vdev->release) {
> > > > +		dev_err(&vdev->dev, "virtbus_device .release callback NULL\n");
> > > 
> > > "virtbus_device MUST have a .release callback that does something!\n" 
> > > 
> > > > +		return -EINVAL;
> > > > +	}
> > > > +
> > > > +	device_initialize(&vdev->dev);
> > > > +
> > > > +	vdev->dev.bus = &virtual_bus_type;
> > > > +	vdev->dev.release = virtbus_dev_release;
> > > > +	/* All device IDs are automatically allocated */
> > > > +	ret = ida_simple_get(&virtbus_dev_ida, 0, 0, GFP_KERNEL);
> > > > +	if (ret < 0) {
> > > > +		dev_err(&vdev->dev, "get IDA idx for virtbus device failed!\n");
> > > > +		put_device(&vdev->dev);
> > > 
> > > If you allocate the number before device_initialize(), no need to call
> > > put_device().  Just a minor thing, no big deal.
> > 
> > If *_regster does put_device on error then it must always do
> > put_device on any error, for instance the above return -EINVAL with
> > no put_device leaks memory.
> 
> That's why I said to move the ida_simple_get() call to before
> device_initialize() is called.  Once device_initialize() is called, you
> HAVE to call put_device().

Yes put_device() becomes mandatory, but if the ida is moved up then
the caller doesn't know how to handle an error:

   if (ida_simple_get() < 0)
       return -EINVAL; // caller must do kfree
   device_initialize();
   if (device_register())
       return -EINVAL // caller must do put_device

If the device_initialize is bundled in the function the best answer is
to always do device_initialize() and never do put_device(). The caller
must realize the unwind switches from kfree to put_device (tricky and
uglyifies the goto unwind!).

This is the pattern something like platform_device_register() uses,
and with a random survey I found only __ipmi_bmc_register() getting it
right. Even then it seems to have a bug related to bmc_reg_mutex due
to the ugly split goto unwind..

I prefer to see device_initialize done shortly after allocation, that
seems to be the most likely to end up correct..

Jason
