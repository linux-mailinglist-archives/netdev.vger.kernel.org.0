Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 559E92FAC9
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 13:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbfE3LTm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 07:19:42 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34870 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726563AbfE3LTm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 07:19:42 -0400
Received: by mail-wm1-f68.google.com with SMTP id c6so671332wml.0
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 04:19:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=eE50XWFdQfD1Q00i8Vghtek+LYjCrHYWx1BbZdqKx/8=;
        b=mMVv30KryhqY9r4QKEzOoMGYDMmz41m2zrIMBhtzBsoJX1TuQB3tYpYYv60E2VOeCY
         fQ4zON3oSzDTx63mg0Y/zlX2VBwQtG2gNLmImMZHoo++mGI7v3IWuVSmaGURcTQEUkOA
         qw26gPIWN24GMZdif1bkBvHM6fgKlom3DK4ievTYMaynsgREShRvahh2C93L83YRr6Sk
         4bICwbJgpZS8mwUX7dUZnt/ZrWlwN5nxYrImhUu1UcGq69onol3N7rjgiAntR7jPRm1i
         pHAvCT0zQKnxzXh9lAQtxslWDArHzV/p8zE6fVvE/fmcFMSThA51FdLsEZ+nGNyxHeNI
         fN6g==
X-Gm-Message-State: APjAAAUGvnPmIFPXxARLAYawF5ARZrPO0YsMYRGqRn2xoTAhfE3xVZMs
        1QoPgtOLwkSnE/EPS+PZOcwqBw==
X-Google-Smtp-Source: APXvYqxJvfQCfSV8yD5adLahJEm4BdGDaUU6ZvezI+MGIHSj25ExbtRsirkXg3gq0ewCBuB3DR32fA==
X-Received: by 2002:a7b:ca4c:: with SMTP id m12mr1882010wml.37.1559215178993;
        Thu, 30 May 2019 04:19:38 -0700 (PDT)
Received: from steredhat.homenet.telecomitalia.it (host253-229-dynamic.248-95-r.retail.telecomitalia.it. [95.248.229.253])
        by smtp.gmail.com with ESMTPSA id o6sm1666949wmc.15.2019.05.30.04.19.37
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 30 May 2019 04:19:38 -0700 (PDT)
Date:   Thu, 30 May 2019 13:19:35 +0200
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
Message-ID: <20190530111935.ldcgif6kmyxelaag@steredhat.homenet.telecomitalia.it>
References: <20190514081543.f6nphcilgjuemlet@steredhat>
 <20190523153703.GC19296@stefanha-x1.localdomain>
 <20190527104447.gd23h2dsnmit75ry@steredhat>
 <MWHPR05MB3376D035CA84FB6189CC1BFFDA1E0@MWHPR05MB3376.namprd05.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR05MB3376D035CA84FB6189CC1BFFDA1E0@MWHPR05MB3376.namprd05.prod.outlook.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 28, 2019 at 04:01:00PM +0000, Jorgen Hansen wrote:
> > On Thu, May 23, 2019 at 04:37:03PM +0100, Stefan Hajnoczi wrote:
> > > On Tue, May 14, 2019 at 10:15:43AM +0200, Stefano Garzarella wrote:
> > > > Hi guys,
> > > > I'm currently interested on implement a multi-transport support for VSOCK in
> > > > order to handle nested VMs.
> 
> Thanks for picking this up!
> 

:)

> > > >
> > > > As Stefan suggested me, I started to look at this discussion:
> > > > https://nam04.safelinks.protection.outlook.com/?url=https%3A%2F%2Flkml.org%2Flkml%2F2017%2F8%2F17%2F551&amp;data=02%7C01%7Cjhansen%40vmware.com%7Cc2a340a868bb4525c6d408d6e2905909%7Cb39138ca3cee4b4aa4d6cd83d9dd62f0%7C0%7C0%7C636945506938670252&amp;sdata=kl820ZF1AAOXEyCZYoNPpYmLVyvK3ISr1GT0oDODEn4%3D&amp;reserved=0
> > > > Below I tried to summarize a proposal for a discussion, following the ideas
> > > > from Dexuan, Jorgen, and Stefan.
> > > >
> > > >
> > > > We can define two types of transport that we have to handle at the same time
> > > > (e.g. in a nested VM we would have both types of transport running together):
> > > >
> > > > - 'host side transport', it runs in the host and it is used to communicate with
> > > >   the guests of a specific hypervisor (KVM, VMWare or HyperV)
> > > >
> > > >   Should we support multiple 'host side transport' running at the same time?
> > > >
> > > > - 'guest side transport'. it runs in the guest and it is used to communicate
> > > >   with the host transport
> > >
> > > I find this terminology confusing.  Perhaps "host->guest" (your 'host
> > > side transport') and "guest->host" (your 'guest side transport') is
> > > clearer?
> >
> > I agree, "host->guest" and "guest->host" are better, I'll use them.
> >
> > >
> > > Or maybe the nested virtualization terminology of L2 transport (your
> > > 'host side transport') and L0 transport (your 'guest side transport')?
> > > Here we are the L1 guest and L0 is the host and L2 is our nested guest.
> > >
> >
> > I'm confused, if L2 is the nested guest, it should be the
> > 'guest side transport'. Did I miss anything?
> >
> > Maybe it is another point to your first proposal :)
> >
> > > >
> > > >
> > > > The main goal is to find a way to decide what transport use in these cases:
> > > > 1. connect() / sendto()
> > > >
> > > >     a. use the 'host side transport', if the destination is the guest
> > > >        (dest_cid > VMADDR_CID_HOST).
> > > >        If we want to support multiple 'host side transport' running at the
> > > >        same time, we should assign CIDs uniquely across all transports.
> > > >        In this way, a packet generated by the host side will get directed
> > > >        to the appropriate transport based on the CID
> > >
> > > The multiple host side transport case is unlikely to be necessary on x86
> > > where only one hypervisor uses VMX at any given time.  But eventually it
> > > may happen so it's wise to at least allow it in the design.
> > >
> >
> > Okay, I was in doubt, but I'll keep it in the design.
> >
> > > >
> > > >     b. use the 'guest side transport', if the destination is the host
> > > >        (dest_cid == VMADDR_CID_HOST)
> > >
> > > Makes sense to me.
> > >
> 
> Agreed. With the addition that VMADDR_CID_HYPERVISOR is also routed as
> "guest->host/guest side transport".
> 

Yes, I had it in mind, but I forgot to write it in the proposal.

> >> >
> >> >
> >> > 2. listen() / recvfrom()
> > > >
> >> >     a. use the 'host side transport', if the socket is bound to
> > > >        VMADDR_CID_HOST, or it is bound to VMADDR_CID_ANY and there is no
> > > >        guest transport.
> > > >        We could also define a new VMADDR_CID_LISTEN_FROM_GUEST in order to
> > > >        address this case.
> > > >        If we want to support multiple 'host side transport' running at the
> > > >        same time, we should find a way to allow an application to bound a
> > > >        specific host transport (e.g. adding new VMADDR_CID_LISTEN_FROM_KVM,
> > > >        VMADDR_CID_LISTEN_FROM_VMWARE, VMADDR_CID_LISTEN_FROM_HYPERV)
> > >
> > > Hmm...VMADDR_CID_LISTEN_FROM_KVM, VMADDR_CID_LISTEN_FROM_VMWARE,
> > > VMADDR_CID_LISTEN_FROM_HYPERV isn't very flexible.  What if my service
> > > should only be available to a subset of VMware VMs?
> >
> > You're right, it is not very flexible.
> 
> When I was last looking at this, I was considering a proposal where
> the incoming traffic would determine which transport to use for
> CID_ANY in the case of multiple transports. For stream sockets, we
> already have a shared port space, so if we receive a connection
> request for < port N, CID_ANY>, that connection would use the
> transport of the incoming request. The transport could either be a
> host->guest transport or the guest->host transport. This is a bit
> harder to do for datagrams since the VSOCK port is decided by the
> transport itself today. For VMCI, a VMCI datagram handler is allocated
> for each datagram socket, and the ID of that handler is used as the
> port. So we would potentially have to register the same datagram port
> with all transports.

So, do you think we should implement a shared port space also for
datagram sockets?

For now only the VMWare implementation supports the datagram sockets,
but in the future we could support it also on KVM and HyperV, so I think
we should consider it in this proposal.

> 
> The use of network namespaces would be complimentary to this, and
> could be used to partition VMs between hypervisors or at a finer
> granularity. This could also be used to isolate host applications from
> guest applications using the same ports with CID_ANY if necessary.
> 

Another point to the netns support, I'll put it in the proposal (or it
could go in parallel with the multi-transport support).

> >
> > >
> > > Instead it might be more appropriate to use network namespaces to create
> > > independent AF_VSOCK addressing domains.  Then you could have two
> > > separate groups of VMware VMs and selectively listen to just one group.
> > >
> >
> > Does AF_VSOCK support network namespace or it could be another
> > improvement to take care? (IIUC is not currently supported)
> >
> > A possible issue that I'm seeing with netns is if they are used for
> > other purpose (e.g. to isolate the network of a VM), we should have
> > multiple instances of the application, one per netns.
> >
> > > >
> > > >     b. use the 'guest side transport', if the socket is bound to local CID
> > > >        different from the VMADDR_CID_HOST (guest CID get with
> > > >        IOCTL_VM_SOCKETS_GET_LOCAL_CID), or it is bound to VMADDR_CID_ANY
> > > >        (to be backward compatible).
> > > >        Also in this case, we could define a new VMADDR_CID_LISTEN_FROM_HOST.
> > >
> > > Two additional topics:
> > >
> > > 1. How will loading af_vsock.ko change?
> >
> > I'd allow the loading of af_vsock.ko without any transport.
> > Maybe we should move the MODULE_ALIAS_NETPROTO(PF_VSOCK) from the
> > vmci_transport.ko to the af_vsock.ko, but this can impact the VMware
> > driver.
> 
> As I remember it, this will impact the existing VMware products. I'll
> have to double check that.
> 

Thanks! Let me know, because I think could be better if we can move it
to the af_vsock.ko, in order to be more agnostic of the transport used.

> >
> > >    In particular, can an
> > >    application create a socket in af_vsock.ko without any loaded
> > >    transport?  Can it enter listen state without any loaded transport
> > >    (this seems useful with VMADDR_CID_ANY)?
> >
> > I'll check if we can allow listen sockets without any loaded transport,
> > but I think could be a nice behaviour to have.
> >
> > >
> > > 2. Does your proposed behavior match VMware's existing nested vsock
> > >    semantics?
> >
> > I'm not sure, but I tried to follow the Jorgen's answers to the original
> > thread. I hope that this proposal matches the VMware semantic.
> 
> Yes, the semantics should be preserved.

Thanks you very much,
Stefano
