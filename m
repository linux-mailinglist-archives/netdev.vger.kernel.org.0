Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1EC132DEB
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 12:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727423AbfFCKtx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 06:49:53 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51123 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727029AbfFCKtx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 06:49:53 -0400
Received: by mail-wm1-f65.google.com with SMTP id f204so6644106wme.0
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 03:49:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1/K2oDMMe4XYd4iMr81LAcnzSHPNze07TDOmJD2+cnY=;
        b=mHTrY7F8fBDxmsW189o/Dgp46Vtf8YHxXEI0z/8gVtWS9+tkydmqaJHOGcuKV+jSbm
         EO++4Ks0nS17d2vtaC00x8368zcczF1I1QBV4o1AnJdAMQX7h+DdGjzE/f1DIBvMgKCq
         3iYcCnp4SZZ3CCjUvJzRUauMDyaASZB5shXpI7NulEh1PvZHQccMTOJ7EJTRIOcpYoBe
         V9Ky0rT1HHGZtSxAmjIPSWaX0RidDN3BaPj02VTLp4NvPIK2nK/S5qWAuLGyPtY9MFOM
         x1+6qTto0CDdrzoOvTP9/5++42M7p7aLgdisOco3pMRpcsTfDbYQh9jqiAlwOWVKWkO+
         9QcA==
X-Gm-Message-State: APjAAAUhv3th+QC6WeDiKsSjHWTrnKPsJvy3r0wnehnRKhKT9TglA5mV
        y18qRUzvyi4rBiavr+8SxNne7A==
X-Google-Smtp-Source: APXvYqw2GFBf4ZSaOxRYPwtTIGMaJsT5wQfYhdseAdLL9A96nNAovmOE/XpesUabAOsGUPNAppAJQQ==
X-Received: by 2002:a7b:c057:: with SMTP id u23mr14046258wmc.29.1559558991684;
        Mon, 03 Jun 2019 03:49:51 -0700 (PDT)
Received: from steredhat.homenet.telecomitalia.it (host253-229-dynamic.248-95-r.retail.telecomitalia.it. [95.248.229.253])
        by smtp.gmail.com with ESMTPSA id 16sm10651269wmx.45.2019.06.03.03.49.50
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 03 Jun 2019 03:49:50 -0700 (PDT)
Date:   Mon, 3 Jun 2019 12:49:48 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jorgen Hansen <jhansen@vmware.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vishnu DASA <vdasa@vmware.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [RFC] vsock: proposal to support multiple transports at runtime
Message-ID: <20190603104948.nucmuxrst7dsu7yz@steredhat.homenet.telecomitalia.it>
References: <20190514081543.f6nphcilgjuemlet@steredhat>
 <20190523153703.GC19296@stefanha-x1.localdomain>
 <20190527104447.gd23h2dsnmit75ry@steredhat>
 <MWHPR05MB3376D035CA84FB6189CC1BFFDA1E0@MWHPR05MB3376.namprd05.prod.outlook.com>
 <20190530111935.ldcgif6kmyxelaag@steredhat.homenet.telecomitalia.it>
 <3B468856-C98D-4AFD-9369-24D39D77277F@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3B468856-C98D-4AFD-9369-24D39D77277F@vmware.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 09:24:49AM +0000, Jorgen Hansen wrote:
> On 30 May 2019, at 13:19, Stefano Garzarella <sgarzare@redhat.com> wrote:
> > 
> > On Tue, May 28, 2019 at 04:01:00PM +0000, Jorgen Hansen wrote:
> >>> On Thu, May 23, 2019 at 04:37:03PM +0100, Stefan Hajnoczi wrote:
> >>>> On Tue, May 14, 2019 at 10:15:43AM +0200, Stefano Garzarella wrote:
> > 
> >>>>> 
> >>>>> 
> >>>>> 2. listen() / recvfrom()
> >>>>> 
> >>>>>    a. use the 'host side transport', if the socket is bound to
> >>>>>       VMADDR_CID_HOST, or it is bound to VMADDR_CID_ANY and there is no
> >>>>>       guest transport.
> >>>>>       We could also define a new VMADDR_CID_LISTEN_FROM_GUEST in order to
> >>>>>       address this case.
> >>>>>       If we want to support multiple 'host side transport' running at the
> >>>>>       same time, we should find a way to allow an application to bound a
> >>>>>       specific host transport (e.g. adding new VMADDR_CID_LISTEN_FROM_KVM,
> >>>>>       VMADDR_CID_LISTEN_FROM_VMWARE, VMADDR_CID_LISTEN_FROM_HYPERV)
> >>>> 
> >>>> Hmm...VMADDR_CID_LISTEN_FROM_KVM, VMADDR_CID_LISTEN_FROM_VMWARE,
> >>>> VMADDR_CID_LISTEN_FROM_HYPERV isn't very flexible.  What if my service
> >>>> should only be available to a subset of VMware VMs?
> >>> 
> >>> You're right, it is not very flexible.
> >> 
> >> When I was last looking at this, I was considering a proposal where
> >> the incoming traffic would determine which transport to use for
> >> CID_ANY in the case of multiple transports. For stream sockets, we
> >> already have a shared port space, so if we receive a connection
> >> request for < port N, CID_ANY>, that connection would use the
> >> transport of the incoming request. The transport could either be a
> >> host->guest transport or the guest->host transport. This is a bit
> >> harder to do for datagrams since the VSOCK port is decided by the
> >> transport itself today. For VMCI, a VMCI datagram handler is allocated
> >> for each datagram socket, and the ID of that handler is used as the
> >> port. So we would potentially have to register the same datagram port
> >> with all transports.
> > 
> > So, do you think we should implement a shared port space also for
> > datagram sockets?
> 
> Yes, having the two socket types work the same way seems cleaner to me. We should at least cover it in the design.
> 

Okay, I'll add this point on a v2 of this proposal!

> > For now only the VMWare implementation supports the datagram sockets,
> > but in the future we could support it also on KVM and HyperV, so I think
> > we should consider it in this proposal.
> 
> So for now, it sounds like we could make the VMCI transport the default transport for any host side datagram socket, then.
> 

Yes, make sense.

> >> 
> >> The use of network namespaces would be complimentary to this, and
> >> could be used to partition VMs between hypervisors or at a finer
> >> granularity. This could also be used to isolate host applications from
> >> guest applications using the same ports with CID_ANY if necessary.
> >> 
> > 
> > Another point to the netns support, I'll put it in the proposal (or it
> > could go in parallel with the multi-transport support).
> > 
> 
> It should be fine to put in the proposal that we rely on namespaces to provide this support, but pursue namespaces as a separate project.

Sure.

I'll send a v2 adding all the points discussed to be sure that we are
aligned. Then I'll start working on it if we agree on the proposal.

Thanks,
Stefano
