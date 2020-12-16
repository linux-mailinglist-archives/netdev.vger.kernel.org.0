Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 838EF2DC67A
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 19:29:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730748AbgLPS3G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 13:29:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:39866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730747AbgLPS3G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 13:29:06 -0500
Message-ID: <62ca779f86207d7ff2d81729e226ab362b2bf214.camel@kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608141569;
        bh=ZeATeM4vfWzru4YxMd9K+IeRL0wAdXdks6nYehKsmC8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=eqcuXYnLu0pC7alQNzKAGzoIZhQ6aMF8XtZL89uWJFTthqk2sqpH2Tt1m1advtoEe
         n74zivSc8H/9xP0ClnHzs5zRzxyn8NLqcUighAVPRgn3rkv3ITUhrEU29uUcER0M25
         Ki7HCs+x+W3MqE/PL5MP1R3ik26cc+pUvmQJvF1r9b7eE+2TWacwohrnR9HY3/Uxoh
         aZSyyJ10ZTM26lzgrLqYvPHdhQPlNG5XFisXixUQnGjGs2WdbGG6BnC48ivPwa6CLR
         B5hN1quUcJsK/0FEHywW3sI4DOppZ8UntSs03GKfYDd4N+zS+f9DPGEiGEc3kP+xGx
         LyqWcomK8HX+Q==
Subject: Re: [net-next v4 00/15] Add mlx5 subfunction support
From:   Saeed Mahameed <saeed@kernel.org>
To:     Leon Romanovsky <leonro@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Netdev <netdev@vger.kernel.org>, linux-rdma@vger.kernel.org,
        David Ahern <dsahern@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Kiran Patil <kiran.patil@intel.com>,
        Greg KH <gregkh@linuxfoundation.org>
Date:   Wed, 16 Dec 2020 09:59:27 -0800
In-Reply-To: <20201216065050.GR5005@unreal>
References: <20201214214352.198172-1-saeed@kernel.org>
         <CAKgT0UejoduCB6nYFV2atJ4fa4=v9-dsxNh4kNJNTtoHFd1DuQ@mail.gmail.com>
         <608505778d76b1b01cb3e8d19ecda5b8578f0f79.camel@kernel.org>
         <CAKgT0UfEsd0hS=iJTcVc20gohG0WQwjsGYOw1y0_=DRVbhb1Ng@mail.gmail.com>
         <ecad34f5c813591713bb59d9c5854148c3d7f291.camel@kernel.org>
         <20201215132805.22ddcd44@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <20201216065050.GR5005@unreal>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-12-16 at 08:50 +0200, Leon Romanovsky wrote:
> On Tue, Dec 15, 2020 at 01:28:05PM -0800, Jakub Kicinski wrote:
> > On Tue, 15 Dec 2020 12:35:20 -0800 Saeed Mahameed wrote:
> > > > I think the big thing we really should do if we are going to go
> > > > this
> > > > route is to look at standardizing what the flavours are that
> > > > get
> > > > created by the parent netdevice. Otherwise we are just creating
> > > > the
> > > > same mess we had with SRIOV all over again and muddying the
> > > > waters of
> > > > mediated devices.
> > > 
> > > yes in the near future we will be working on auxbus interfaces
> > > for
> > > auto-probing and user flavor selection, this is a must have
> > > feature for
> > > us.
> > 
> > Can you elaborate? I thought config would be via devlink.
> 
> Yes, everything continues to be done through devlink.
> 
> One of the immediate features is an ability to disable/enable
> creation
> of specific SF types.
> 
> For example, if user doesn't want RDMA, the SF RDMA won't be created.
> 

Devlink is an option too, we still don't have our mind set on a
specific API, we are considering both as a valuable solutions since
devlink make sense as a go to interface for everything SF, but on the
other hand, auto-probing and device instantiating is done at the auxbus
level, so it also make sense to have some sort of "device type" user
selection api in the auxbus, anyway this discussion is for a future
patch.


