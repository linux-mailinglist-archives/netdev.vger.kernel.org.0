Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1ADCA123826
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 22:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728028AbfLQVAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 16:00:37 -0500
Received: from mail-qv1-f66.google.com ([209.85.219.66]:46145 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728004AbfLQVAg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 16:00:36 -0500
Received: by mail-qv1-f66.google.com with SMTP id t9so4746888qvh.13
        for <netdev@vger.kernel.org>; Tue, 17 Dec 2019 13:00:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=IvjWMA+q5S2q7e5kFQNGF//nvUxKMp0Z+m3ILb72NO8=;
        b=cuzK5VjPeMRhneOuXGqHYN1IFcfrPZkl5N9TW4FjMXLsWQbnSb2ldeYEO/4YhuSjDy
         6DOq0BWzGfaQC5N5MrKjJ0RanG5NaqsGLOQik4aBWIjNRe62VZTu0AyutN3kBSgVBVUF
         Akkk7j5sFQ1W+Hjwdn78CFNYs+vYCGMoCTVc5yGXVY3MuhcTYgNUgSt10L6s1JkXjI7X
         /dFR9w52J2fuNbZF2Y70mfrfnZGwakm3gtGgyz1vphB6NS4TlbWLCQPII5BjzumxtlTW
         N2/l4XuAS5YYOCBNURueWzyNFDZOCeMVAx2p0bNtPogUko5ezqcPYtTyxXnWZhx9f0v3
         ZziA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=IvjWMA+q5S2q7e5kFQNGF//nvUxKMp0Z+m3ILb72NO8=;
        b=UOOSn4LRi7Ii/IyAqRHaoyTWFn9Yn8htoTp1elfInEGKvcW6Vz+u0L1sEhxbs39+qR
         GA4XbsPXhMXsmr6POa0NvojuMvOpVO2jkm1YWkcoIGeQAvTQuuLGmEbBts0td6T+t3z6
         h/dImwh0/B33bVmEJ6tz262uCMuxefsNJhmKrWAoQquEvgfPoSrKMXS5alp1Pf4uzqR8
         zvFFYY3GP633i0GPMTz+KAeOMLRx1QgzY8N+O21zlbnmLLfph/rNTQJQysYfEGevrDoU
         9/OYBN+Z6kzTclahcIwXrqzJQKTGBgcncbDD8K+Hv0xjMSC02+5JxVoZ3Wc9idLOjQfs
         SMmQ==
X-Gm-Message-State: APjAAAVT2si5/rPHMmn5VyuhAT6wNL6l9rRWZBnL51GJJ9lOXQD7m0Z8
        Ccamu1tFJdK0a936cG/dqIEPQiuxk5M=
X-Google-Smtp-Source: APXvYqxk8JLLr0ZCkGikt79tFYLoUje06GWJ/dg8jfHCmSAWS6QfmEmI6BkmmTD0GBhO+RBqD1xryw==
X-Received: by 2002:ad4:4021:: with SMTP id q1mr6352088qvp.211.1576616435490;
        Tue, 17 Dec 2019 13:00:35 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id t7sm7423135qkm.136.2019.12.17.13.00.34
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 17 Dec 2019 13:00:34 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1ihJxJ-0002GJ-W8; Tue, 17 Dec 2019 17:00:34 -0400
Date:   Tue, 17 Dec 2019 17:00:33 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     "Saleem, Shiraz" <shiraz.saleem@intel.com>
Cc:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>
Subject: Re: [PATCH v3 05/20] RDMA/irdma: Add driver framework definitions
Message-ID: <20191217210033.GB17227@ziepe.ca>
References: <20191209224935.1780117-1-jeffrey.t.kirsher@intel.com>
 <20191209224935.1780117-6-jeffrey.t.kirsher@intel.com>
 <20191210190438.GF46@ziepe.ca>
 <9DD61F30A802C4429A01CA4200E302A7B6B8FBCA@fmsmsx124.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9DD61F30A802C4429A01CA4200E302A7B6B8FBCA@fmsmsx124.amr.corp.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 12, 2019 at 01:40:27AM +0000, Saleem, Shiraz wrote:

> > > +/* client interface functions */
> > > +static const struct i40e_client_ops i40e_ops = {
> > > +	.open = i40iw_open,
> > > +	.close = i40iw_close,
> > > +	.l2_param_change = i40iw_l2param_change };
> > 
> > Wasn't the whole point of virtual bus to avoid stuff like this? Why isn't a client the
> > virtual bus object and this information extended into the driver ops?
> 
> These are the private interface calls between lan and rdma.
> These ops are implemented by RDMA driver but invoked by
> netdev driver.

AFAIK you are supposed to provide things like this as part of your
device driver ops, ie open is probe, close is unbind, etc.

> > > +/**
> > > + * irdma_event_handler - Called by LAN driver to notify events
> > > + * @ldev: Peer device structure
> > > + * @event: event from LAN driver
> > > + */
> > > +static void irdma_event_handler(struct iidc_peer_dev *ldev,
> > > +				struct iidc_event *event)
> > > +{
> > > +	struct irdma_l2params l2params = {};
> > > +	struct irdma_device *iwdev;
> > > +	int i;
> > > +
> > > +	iwdev = irdma_get_device(ldev->netdev);
> > > +	if (!iwdev)
> > > +		return;
> > > +
> > > +	if (test_bit(IIDC_EVENT_LINK_CHANGE, event->type)) {
> > 
> > Is this atomic? Why using test_bit?
> No its not. What do you suggest we use?

Just test the bit?

if (event->type & BIT(IIDC_EVENT_LINK_CHANGE)) ?

test_bit is the atomic version of those that matches atomic
set_bit/clear_bit

> > > +		ldev->ops->reg_for_notification(ldev, &events);
> > > +	dev_info(rfdev_to_dev(dev), "IRDMA VSI Open Successful");
> > 
> > Lets not do this kind of logging..
> >
> 
> There is some dev_info which should be cleaned up to dev_dbg.
> But logging this info is useful to know that this functions VSI (and associated ibdev)
> is up and reading for RDMA traffic.
> Is info logging to be avoided altogether?

Certainly not at display-by-default level. If every driver printed
when it binds we'd have a mess.

> > > new file mode 100644
> > > index 000000000000..b418e76a3302
> > > +++ b/drivers/infiniband/hw/irdma/main.c
> > > @@ -0,0 +1,630 @@
> > > +// SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB
> > > +/* Copyright (c) 2015 - 2019 Intel Corporation */ #include "main.h"
> > > +
> > > +/* Legacy i40iw module parameters */
> > > +static int resource_profile;
> > > +module_param(resource_profile, int, 0644);
> > > +MODULE_PARM_DESC(resource_profile, "Resource Profile: 0=PF only,
> > > +1=Weighted VF, 2=Even Distribution");
> > > +
> > > +static int max_rdma_vfs = 32;
> > > +module_param(max_rdma_vfs, int, 0644);
> > MODULE_PARM_DESC(max_rdma_vfs,
> > > +"Maximum VF count: 0-32 32=default");
> > > +
> > > +static int mpa_version = 2;
> > > +module_param(mpa_version, int, 0644); MODULE_PARM_DESC(mpa_version,
> > > +"MPA version: deprecated parameter");
> > > +
> > > +static int push_mode;
> > > +module_param(push_mode, int, 0644);
> > > +MODULE_PARM_DESC(push_mode, "Low latency mode: deprecated
> > > +parameter");
> > > +
> > > +static int debug;
> > > +module_param(debug, int, 0644);
> > > +MODULE_PARM_DESC(debug, "debug flags: deprecated parameter");
> > 
> > Generally no to module parameters
> 
> Agree. But these are module params that existed in i40iw.
> And irdma replaces i40iw and has a module alias
> for it.

Provide non-module parameter alternatives for all of these, and it can
be OK only because of the module alias, and only if Doug lets you
remove i40iw.

 
> > > +static struct workqueue_struct *irdma_wq;
> > 
> > Another wq already?
> This wq is used for deferred handling of irdma service tasks.
> Such as rebuild/recovery after reset.

We have system global wqs. Why are they not OK?
 
Jason
