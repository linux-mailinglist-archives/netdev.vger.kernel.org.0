Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC8F585579
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 21:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238806AbiG2TMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 15:12:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237926AbiG2TMh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 15:12:37 -0400
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BB7A823BB
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 12:12:35 -0700 (PDT)
Received: by mail-qv1-xf35.google.com with SMTP id i7so4277365qvr.8
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 12:12:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MD/Y1Ux36S7YhGnDVVwMOyxaB+EoqSrFVx9rgP9aahY=;
        b=S4AT4Ada+qIIoQWVjxhyOOAUEoHPwY3fwslxsVJJvK4hTaUep3WogZjhTKdxr1jPTj
         NiAFRDaIffdXgXTe0VuKReiQwhVGzrMVJIOOYVtzOyBFGxHzaaeKdtC8oLNszTrztzok
         Rqk9lyUKpvIWzYcNpUmJHjXubVxeTe4NqQ9gdTUEVCwmoZ46YM5vI/wKHUGHMqcTFzaj
         T2jbKkmWQY+DFZAKkBQI6hLto1jK74J3gpTOL7DyLaxU03xLOMtKIXzQk8w0EIcKb//b
         z3EH9nla/6PrrKE7pJRHlnKl1aHxOxgOQh3zgmQLWuyjeKH3+TJli3dQuVjHhAXjuSnu
         +4kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MD/Y1Ux36S7YhGnDVVwMOyxaB+EoqSrFVx9rgP9aahY=;
        b=cadEI9MRdDHpktB9Wi8KO6MEmoB+kQZytbW4UxBGQB2ZJlK/XrYGBP4aklkYcUWx6t
         eiQ5FcY3+gTVMMJQ3+3XevCfQEGoRX+vw+Rpsplnr9vLy16stCnVcGHaj1rjnbwJ1GNN
         qBk7BN4YxXpXoJEeMC9dUwlpqHm4T1B9uqTGcvIi9kKSi3zGc7DAfjJryl6Tyq2cSa3A
         fxPAsPNzKdn3EFLIvxrC7exbo7zhq0A20WNX8p/Wxpnsg0sgaqhNKtE93+jHO1NF3PmS
         4RFUJJ0i9UuZkCx7c5avMDT1OFjZA7MdZMhHZYjDijN0sLRJgIKsAAnENCSS4Aj7nSm3
         1TQg==
X-Gm-Message-State: ACgBeo0kBpudeHO6ZJe4R7TNavjJpbd95Sw6qsVqBbi8vtMLNlRyrtZl
        ZCaN/1QnMbWdL4moRmpKNsGKWg==
X-Google-Smtp-Source: AA6agR5WsDNzyc0U213ntxGsYAkELGXY7PUQTdYmx68YyABWFqKq6a8LfzXgGUZihcOAo5ixikG6Hw==
X-Received: by 2002:a05:6214:248a:b0:474:3739:6007 with SMTP id gi10-20020a056214248a00b0047437396007mr4723247qvb.57.1659121953858;
        Fri, 29 Jul 2022 12:12:33 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id dm26-20020a05620a1d5a00b006af147d4876sm3035166qkb.30.2022.07.29.12.12.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 12:12:32 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1oHVPU-000D7g-3B;
        Fri, 29 Jul 2022 16:12:32 -0300
Date:   Fri, 29 Jul 2022 16:12:32 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Long Li <longli@microsoft.com>
Cc:     Dexuan Cui <decui@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        Ajay Sharma <sharmaajay@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [Patch v4 03/12] net: mana: Handle vport sharing between devices
Message-ID: <YuQxIKxGAvUIwVmj@ziepe.ca>
References: <1655345240-26411-1-git-send-email-longli@linuxonhyperv.com>
 <1655345240-26411-4-git-send-email-longli@linuxonhyperv.com>
 <SN6PR2101MB13272044B91D6E37F7F5124FBF879@SN6PR2101MB1327.namprd21.prod.outlook.com>
 <PH7PR21MB3263F08C111C5D06C99CC32ACE869@PH7PR21MB3263.namprd21.prod.outlook.com>
 <20220720234209.GP5049@ziepe.ca>
 <PH7PR21MB3263F5FD2FA4BA6669C21509CE919@PH7PR21MB3263.namprd21.prod.outlook.com>
 <20220721143858.GV5049@ziepe.ca>
 <PH7PR21MB326339501D9CA5ABE69F8AE9CE919@PH7PR21MB3263.namprd21.prod.outlook.com>
 <20220721183219.GA6833@ziepe.ca>
 <PH7PR21MB326304834D36451E7609D102CE999@PH7PR21MB3263.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH7PR21MB326304834D36451E7609D102CE999@PH7PR21MB3263.namprd21.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 29, 2022 at 06:44:22PM +0000, Long Li wrote:
> > Subject: Re: [Patch v4 03/12] net: mana: Handle vport sharing between devices
> > 
> > On Thu, Jul 21, 2022 at 05:58:39PM +0000, Long Li wrote:
> > > > > "vport" is a hardware resource that can either be used by an
> > > > > Ethernet device, or an RDMA device. But it can't be used by both
> > > > > at the same time. The "vport" is associated with a protection
> > > > > domain and doorbell, it's programmed in the hardware. Outgoing
> > > > > traffic is enforced on this vport based on how it is programmed.
> > > >
> > > > Sure, but how is the users problem to "get this configured right"
> > > > and what exactly is the user supposed to do?
> > > >
> > > > I would expect the allocation of HW resources to be completely
> > > > transparent to the user. Why is it not?
> > > >
> > >
> > > In the hardware, RDMA RAW_QP shares the same hardware resource (in
> > > this case, the vPort in hardware table) with the ethernet NIC. When an
> > > RDMA user creates a RAW_QP, we can't just shut down the ethernet. The
> > > user is required to make sure the ethernet is not in used when he
> > > creates this QP type.
> > 
> > You haven't answered my question - how is the user supposed to achieve this?
> 
> The user needs to configure the network interface so the kernel will not use it when the user creates a RAW QP on this port.
> 
> This can be done via system configuration to not bring this
> interface online on system boot, or equivalently doing "ifconfig xxx
> down" to make the interface down when creating a RAW QP on this
> port.

That sounds horrible, why allow the user to even bind two drivers if
the two drivers can't be used together?

> > And now I also want to know why the ethernet device and rdma device can even
> > be loaded together if they cannot share the physical port?
> > Exclusivity is not a sharing model that any driver today implements.
> 
> This physical port limitation only applies to the RAW QP. For RC QP,
> the hardware doesn't have this limitation. The user can create RC
> QPs on a physical port up to the hardware limits independent of the
> Ethernet usage on the same port.

.. and it is because you support sharing models in other cases :\

> Scenario 1: The Ethernet loses TCP connection.

> 1. User A runs a program listing on a TCP port, accepts an incoming
> TCP connection and is communicating with the remote peer over this
> TCP connection.
> 2. User B creates an RDMA RAW_QP on the same port on the device.
> 3. As soon as the RAW_QP is created, the program in 1 can't
> send/receive data over this TCP connection. After some period of
> inactivity, the TCP connection terminates.

It is a little more complicated than that, but yes, that could
possibly happen if the userspace captures the right traffic.

> Please note that this may also pose a security risk. User B with
> RAW_QP can potentially hijack this TCP connection from the kernel by
> framing the correct Ethernet packets and send over this QP to trick
> the remote peer, making it believe it's User A.

Any root user can do this with the netstack using eg tcpdump, bpf,
XDP, raw sockets, etc. This is why the capability is guarded by
CAP_NET_RAW. It is nothing unusual.

> Scenario 2: The Ethernet port state changes after RDMA RAW_QP is used on the port.
> 1. User uses "ifconfig ethx down" on the NIC, intending to make it offline
> 2. User creates a RDMA RAW_QP on the same port on the device.
> 3. User destroys this RAW_QP.
> 4. The ethx device in 1 reports carrier state in step 2, in many
> Linux distributions this makes it online without user
> interaction. "ifconfig ethx" shows its state changes to "up".

This I'm not familiar with, it actually sounds like a bug that the
RAW_QP's interfere with the netdev carrier state.

> the Mellanox NICs implement the RAW_QP. IMHO, it's better to have
> the user explicitly decide whether to use Ethernet or RDMA RAW_QP on
> a specific port.

It should all be carefully documented someplace.

Jason
