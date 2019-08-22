Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4ACFE98E6C
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 10:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731777AbfHVIy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 04:54:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43674 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730948AbfHVIy3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 04:54:29 -0400
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0509F85A07
        for <netdev@vger.kernel.org>; Thu, 22 Aug 2019 08:54:28 +0000 (UTC)
Received: by mail-wm1-f72.google.com with SMTP id f14so1782990wmh.7
        for <netdev@vger.kernel.org>; Thu, 22 Aug 2019 01:54:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ZHz9pgYisuijk2a86Yq9hb9IHbvhgZwHYhEYSmJ9jn0=;
        b=WEJg1n+d00EtVhoHlzZYmIqBcxpqNUlU053UnurZtEsnj3gFEBosYg4+uqSYXl04i9
         K7BvL7YXVaJ31AyA+jTGrIk5JcTMYYNCrlESIxzrh3INcPF54rIqcfpnxtFA4IgG5TrS
         fvHcK7jBwl/Lk4qmmP3lRnpQER0h6Cm1c+ISuRpD0rArnlORZL4TrcpRlsTRkea9iI8X
         UO6URPgwgaRLhBQNSg32tUS/Dm5KJOajepDn76QzLh6L5Q1lVat0udVQK27kJY5pKiZU
         KY6bBYOd0d7xeNnjGM2HM90zcPuWGgUFm+rUace+in1urWw47ia0gSF1yjLiBpT1wrBu
         Vhxw==
X-Gm-Message-State: APjAAAWjghWXF9xsSbYGYXhjLovh7knUIgnK5EKxVDm17pKVHbZ3Au09
        go544svImv4AowZpJesklCgbUD/vldCu0S+AMmvLX1Fl9Qe0Kt19qJRRPwaxTSPxEInzhpClcNh
        W6EDilesjBo7XFIx+
X-Received: by 2002:adf:cd84:: with SMTP id q4mr23502288wrj.232.1566464066740;
        Thu, 22 Aug 2019 01:54:26 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyh825LuHIXll98cU7yRRsOXHgUXj6D4NMmJwTnpjy9qwpKRhbbMrOnwCnYmIgNpZVYmaHNUA==
X-Received: by 2002:adf:cd84:: with SMTP id q4mr23502255wrj.232.1566464066449;
        Thu, 22 Aug 2019 01:54:26 -0700 (PDT)
Received: from steredhat (host80-221-dynamic.18-79-r.retail.telecomitalia.it. [79.18.221.80])
        by smtp.gmail.com with ESMTPSA id 25sm1986089wmi.40.2019.08.22.01.54.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Aug 2019 01:54:25 -0700 (PDT)
Date:   Thu, 22 Aug 2019 10:54:22 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     netdev@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        Jorgen Hansen <jhansen@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vishnu Dasa <vdasa@vmware.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [RFC v2] vsock: proposal to support multiple transports at
 runtime
Message-ID: <20190822085422.6to6oo2arwwmkmql@steredhat>
References: <20190606100912.f2zuzrkgmdyxckog@steredhat>
 <20190819130911.GE28081@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190819130911.GE28081@stefanha-x1.localdomain>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 19, 2019 at 02:09:11PM +0100, Stefan Hajnoczi wrote:
> On Thu, Jun 06, 2019 at 12:09:12PM +0200, Stefano Garzarella wrote:
> > 
> > Hi all,
> > this is a v2 of a proposal addressing the comments made by Dexuan, Stefan,
> > and Jorgen.
> > 
> > v1: https://www.spinics.net/lists/netdev/msg570274.html
> > 
> > 
> > 
> > We can define two types of transport that we have to handle at the same time
> > (e.g. in a nested VM we would have both types of transport running together):
> > 
> > - 'host->guest' transport, it runs in the host and it is used to communicate
> >   with the guests of a specific hypervisor (KVM, VMWare or Hyper-V). It also
> >   runs in the guest who has nested guests, to communicate with them.
> > 
> >   [Phase 2]
> >   We can support multiple 'host->guest' transport running at the same time,
> >   but on x86 only one hypervisor uses VMX at any given time.
> > 
> > - 'guest->host' transport, it runs in the guest and it is used to communicate
> >   with the host.
> > 
> > 
> > The main goal is to find a way to decide what transport use in these cases:
> > 1. connect() / sendto()
> > 
> >    a. use the 'host->guest' transport, if the destination is the guest
> >       (dest_cid > VMADDR_CID_HOST).
> > 
> >       [Phase 2]
> >       In order to support multiple 'host->guest' transports running at the same
> >       time, we should assign CIDs uniquely across all transports. In this way,
> >       a packet generated by the host side will get directed to the appropriate
> >       transport based on the CID.
> > 
> >    b. use the 'guest->host' transport, if the destination is the host or the
> >       hypervisor.
> >       (dest_cid == VMADDR_CID_HOST || dest_cid == VMADDR_CID_HYPERVISOR)
> > 
> > 
> > 2. listen() / recvfrom()
> > 
> >    a. use the 'host->guest' transport, if the socket is bound to
> >       VMADDR_CID_HOST, or it is bound to VMADDR_CID_ANY and there is no
> >       'guest->host' transport.
> >       We could also define a new VMADDR_CID_LISTEN_FROM_GUEST in order to
> >       address this case.
> > 
> >       [Phase 2]
> >       We can support network namespaces to create independent AF_VSOCK
> >       addressing domains:
> >       - could be used to partition VMs between hypervisors or at a finer
> >    	 granularity;
> >       - could be used to isolate host applications from guest applications
> >    	 using the same ports with CID_ANY;
> > 
> >    b. use the 'guest->host' transport, if the socket is bound to local CID
> >       different from the VMADDR_CID_HOST (guest CID get with
> >       IOCTL_VM_SOCKETS_GET_LOCAL_CID), or it is bound to VMADDR_CID_ANY (to be
> >       backward compatible).
> >       Also in this case, we could define a new VMADDR_CID_LISTEN_FROM_HOST.
> > 
> >    c. shared port space between transports
> >       For incoming requests or packets, we should be able to choose which
> >       transport use, looking at the 'port' requested.
> > 
> >       - stream sockets already support shared port space between transports
> >         (one port can be assigned to only one transport)
> > 
> >       [Phase 2]
> >       - datagram sockets will support it, but for now VMCI transport is the
> >         default transport for any host side datagram socket (KVM and Hyper-V
> >         do not yet support datagrams sockets)
> > 
> > We will make the loading of af_vsock.ko independent of the transports to
> > allow to:
> >    - create a AF_VSOCK socket without any loaded transports;
> >    - listen on a socket (e.g. bound to VMADDR_CID_ANY) without any loaded
> >      transports;
> > 
> > Hopefully, we could move MODULE_ALIAS_NETPROTO(PF_VSOCK) from the
> > vmci_transport.ko to the af_vsock.ko.
> > [Jorgen will check if this will impact the existing VMware products]
> > 
> > Notes:
> >    - For Hyper-V sockets, the host can only be Windows. No changes should
> >      be required on the Windows host to support the changes on this proposal.
> > 
> >    - Communication between guests are not allowed on any transports, so we can
> >      drop packets sent from a guest to another guest (dest_cid >
> >      VMADDR_CID_HOST) if the 'host->guest' transport is not available.
> > 
> >    - [Phase 2] tag used to identify things that can be done at a later stage,
> >      but that should be taken into account during this design.
> > 
> >    - Namespace support will be developed in [Phase 2] or in a separate project.
> > 
> > 
> > 
> > Comments and suggestions are welcome.
> > I'll be on PTO for next two weeks, so sorry in advance if I'll answer later.
> > 
> > If we agree on this proposal, when I get back, I'll start working on the code
> > to get a first PATCH RFC.
> 
> Stefano,
> I've reviewed your proposal and it looks good for solving nested
> virtualization.

Hi Stefan,
Thank you very much for the review!

> 
> The tricky implementation details will be supporting listen sockets,
> especially with VMADDR_CID_ANY so they can be accessed from both
> transports.

Yes, it will be tricky because the current implementation has 1 to 1
mapping with the transport callbacks.

Maybe I could move some logic in the core (e.g. for listening sockets)
to have a single point of control. (e.g. using vsk->pending_links in all
transports)

I'll work on it in the next weeks, I'll keep you updated.

Thanks,
Stefano
