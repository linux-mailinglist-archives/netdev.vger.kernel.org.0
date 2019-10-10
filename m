Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93759D2A17
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 14:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387927AbfJJMz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 08:55:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8892 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387470AbfJJMz0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Oct 2019 08:55:26 -0400
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BDC9681DF7
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 12:55:25 +0000 (UTC)
Received: by mail-wm1-f72.google.com with SMTP id 190so2587272wme.4
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 05:55:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Nq/uA9hbiLadGUMtvDysqPg6doejpIGdIlN33a9wYx0=;
        b=qt7IoiMj8mv/0ttPaacc3JYqfCNikanfP+niA9rc2O8+xK0+X6z/PuTVcNCcZDAjAV
         TxMUKusfZ6q7J1+NNR/JnAmN7gBqAEitHeTCupLKdB2dkejpVRFZArYqYxJVQTKpRRlo
         6XoPMBCAbjzOBDp8uaQCHF66VMTmFuMJjo3iqHs54bONvllJ6eyqiWNvYE6kGTMMnjzS
         GaVkn25MG8c4j0lUGFJL28HyN+bu6M8rW5tt+2yGHwItuX80ijIVWoY0jLAFjv48/xtw
         74qpLikA2lQduCteZ+CM9t+bLMV2kSycPMr4+ASn4t8reivbYZbLxs9/+doE7i/0IAcd
         ogEg==
X-Gm-Message-State: APjAAAU8k2AAGGyvx8PM1aNVYASv53C7BjCa/eYYbbE/cstRstbVFY1D
        ik9NxH1++i38Y+Ir5ieOZjlP5kuWc9iEG1QSW7GyJK7tBrY3WDhKuvV8GVl3T67zVtq5nM6qKwW
        o4fj4dZtwzm/tYUTH
X-Received: by 2002:a05:600c:2291:: with SMTP id 17mr7030805wmf.171.1570712124316;
        Thu, 10 Oct 2019 05:55:24 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyHOfBhX3Ib0GwJrD9aqpSGkSJYDsUzMmEl6DpZun/qWkG6+vpHW5DvYVap0QI8aDPovc/J9Q==
X-Received: by 2002:a05:600c:2291:: with SMTP id 17mr7030775wmf.171.1570712124033;
        Thu, 10 Oct 2019 05:55:24 -0700 (PDT)
Received: from steredhat (host174-200-dynamic.52-79-r.retail.telecomitalia.it. [79.52.200.174])
        by smtp.gmail.com with ESMTPSA id u68sm8140030wmu.12.2019.10.10.05.55.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 05:55:23 -0700 (PDT)
Date:   Thu, 10 Oct 2019 14:55:21 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Stefan Hajnoczi <stefanha@gmail.com>
Cc:     netdev@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        linux-hyperv@vger.kernel.org,
        Stephen Hemminger <sthemmin@microsoft.com>,
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Dexuan Cui <decui@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jorgen Hansen <jhansen@vmware.com>
Subject: Re: [RFC PATCH 10/13] vsock: add multi-transports support
Message-ID: <20191010125521.mf7elqjpwhwjhwpo@steredhat>
References: <20190927112703.17745-1-sgarzare@redhat.com>
 <20190927112703.17745-11-sgarzare@redhat.com>
 <20191009131123.GK5747@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191009131123.GK5747@stefanha-x1.localdomain>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 09, 2019 at 02:11:23PM +0100, Stefan Hajnoczi wrote:
> On Fri, Sep 27, 2019 at 01:27:00PM +0200, Stefano Garzarella wrote:
> > RFC:
> > - I'd like to move MODULE_ALIAS_NETPROTO(PF_VSOCK) to af_vsock.c.
> >   @Jorgen could this break the VMware products?
> 
> What will cause the vmw_vsock_vmci_transport.ko module to be loaded
> after you remove MODULE_ALIAS_NETPROTO(PF_VSOCK)?  Perhaps
> drivers/misc/vmw_vmci/vmci_guest.c:vmci_guest_probe_device() could do
> something when the guest driver loads.

Good idea, maybe we can call some function provided by vmci_transport
to register it as a guest (I'll remove the type from the transport
and I add it as a parameter of vsock_core_register())

>                                         There would need to be something
> equivalent for the host side too.

Maybe in the vmci_host_do_init_context().

> 
> This will solve another issue too.  Today the VMCI transport can be
> loaded if an application creates an AF_VSOCK socket during early boot
> before the virtio transport has been probed.  This happens because the
> VMCI transport uses MODULE_ALIAS_NETPROTO(PF_VSOCK) *and* it does not
> probe whether this system is actually a VMware guest.
> 
> If we instead load the core af_vsock.ko module and transports are only
> loaded based on hardware feature probing (e.g. the presence of VMware
> guest mode, a virtio PCI adapter, etc) then transports will be
> well-behaved.

Yes, I completely agree with you. I'll try to follow your suggestion,

> 
> > - DGRAM sockets are handled as before, I don't know if make sense work
> >   on it now, or when another transport will support DGRAM. The big
> >   issues here is that we cannot link 1-1 a socket to transport as
> >   for stream sockets since DGRAM is not connection-oriented.
> 
> Let's ignore DGRAM for now since only VMCI supports it and we therefore
> do not require multi-transpor) support.

Okay :)

> 
> > diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
> > index 86f8f463e01a..2a081d19e20d 100644
> > --- a/include/net/af_vsock.h
> > +++ b/include/net/af_vsock.h
> > @@ -94,7 +94,13 @@ struct vsock_transport_send_notify_data {
> >  	u64 data2; /* Transport-defined. */
> >  };
> >  
> > +#define VSOCK_TRANSPORT_F_H2G		0x00000001
> > +#define VSOCK_TRANSPORT_F_G2H		0x00000002
> > +#define VSOCK_TRANSPORT_F_DGRAM		0x00000004
> 
> Documentation comments, please.

I'll fix!

> 
> > +void vsock_core_unregister(const struct vsock_transport *t)
> > +{
> > +	mutex_lock(&vsock_register_mutex);
> > +
> > +	/* RFC-TODO: maybe we should check if there are open sockets
> > +	 * assigned to that transport and avoid the unregistration
> > +	 */
> 
> If unregister() is only called from module_exit() functions then holding
> a reference to the transport module would be enough to prevent this
> case.  The transport could only be removed once all sockets have been
> destroyed (and dropped their transport module reference).

Yes. I did this in
"[RFC PATCH 12/13] vsock: prevent transport modules unloading".

Maybe I can merge it in this patch...

Thanks,
Stefano
