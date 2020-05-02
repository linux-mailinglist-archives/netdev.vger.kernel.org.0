Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 365601C28EB
	for <lists+netdev@lfdr.de>; Sun,  3 May 2020 01:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbgEBXcB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 May 2020 19:32:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726375AbgEBXcB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 May 2020 19:32:01 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9CFCC061A0C
        for <netdev@vger.kernel.org>; Sat,  2 May 2020 16:32:00 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id f13so1522983qkh.2
        for <netdev@vger.kernel.org>; Sat, 02 May 2020 16:32:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/1DbMFmvECUwqhpprqNIvSsKZKaPSwXzMOZXVSeg9WA=;
        b=X394ECiJAQZjxMdfIMPlY1m53HZbSw7vrLMkcUexK56QDcxi1uqLsd5vybajXI/biV
         DErDCai56z2ni4j9fYsgYBYO9dvhEZNprAkKp9dhzBVRzgfGjfhGl5xaNvTDXyPWOIqn
         cQh31zYHWCdd0/fKZqOzvbRsbJgZ24Fn10d/2zYvkrAnsGCeUXNcfbgaMono2mVAReU/
         ttoDgxmASE0E9coap7qkguZXrMOh70lsO9F/+9lVjm76XjZxGDEY/j5J5sxcAhLswEIK
         hjkp8mSb8JknYBwZO9sJhGZTpR37QPE/fd/Qavjj93P8aoQZlWwVeAyfHdTLyJ3JSVU4
         GJyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=/1DbMFmvECUwqhpprqNIvSsKZKaPSwXzMOZXVSeg9WA=;
        b=B8g1c9TiUL2//4A6A/lWwLeY5EPriZ/GXCnouWW+W03EjeJJ61Q4TtqntsA4iK5rTP
         IORIr2nJqQjIjYUpzkuoR27UVK/L2md0AiYc5gj6nlmPM9Eh4XjD6ECuwYIRWYiWdSBD
         HrRwGvrW82VWaNCMX8P9EOsbXdOiUxSe4A2lHZa1zfdsWhLDuatZLxn85d5CwFk7IBON
         ceC7Yc4vGgc3F8z61EW/eiUXzJI+r/KuXbhIXAGut+6IjDz7PpgGJ9TjIgp9G2vMWwQ8
         wf2w+qPzGpsMaEqJp/utL4ooRreZOGfLy2Bjz61K8ph5vM7zH89Al5l226xghwSsgb8x
         sJOg==
X-Gm-Message-State: AGi0Pubtx2Q36g+Axt6CJ+eFTXbBV1d7O64rO3kB78NjOEUB5jm2eKJM
        /oZiZy/9gr4z+uIezVjiui5rJg==
X-Google-Smtp-Source: APiQypIvgCgIyZ/kfRddzoxvxN25mUOpc12gyDyssCFkW8KX9VTilXpbcWULnoiZczLI9gNDUpG60w==
X-Received: by 2002:a37:a78b:: with SMTP id q133mr10046838qke.354.1588462319856;
        Sat, 02 May 2020 16:31:59 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id d207sm2515218qkc.49.2020.05.02.16.31.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 02 May 2020 16:31:59 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jV1by-00076t-H0; Sat, 02 May 2020 20:31:58 -0300
Date:   Sat, 2 May 2020 20:31:58 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     Maor Gottlieb <maorg@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "vfalico@gmail.com" <vfalico@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Leon Romanovsky <leonro@mellanox.com>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        "andy@greyhouse.net" <andy@greyhouse.net>,
        "j.vosburgh@gmail.com" <j.vosburgh@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>,
        Alex Rosenbaum <alexr@mellanox.com>
Subject: Re: [PATCH V8 mlx5-next 00/16] Add support to get xmit slave
Message-ID: <20200502233158.GR26002@ziepe.ca>
References: <20200430192146.12863-1-maorg@mellanox.com>
 <20200501144448.GO26002@ziepe.ca>
 <3bee27c7f4b28d55ef73e5be5c2024d90d7949b9.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3bee27c7f4b28d55ef73e5be5c2024d90d7949b9.camel@mellanox.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 01, 2020 at 07:28:14PM +0000, Saeed Mahameed wrote:
> On Fri, 2020-05-01 at 11:44 -0300, Jason Gunthorpe wrote:
> > On Thu, Apr 30, 2020 at 10:21:30PM +0300, Maor Gottlieb wrote:
> > > Hi Dave,
> > > 
> > > This series is a combination of netdev and RDMA, so in order to
> > > avoid
> > > conflicts, we would like to ask you to route this series through
> > > mlx5-next shared branch. It is based on v5.7-rc2 tag.
> > > 
> > > 
> > > The following series adds support to get the LAG master xmit slave
> > > by
> > > introducing new .ndo - ndo_get_xmit_slave. Every LAG module can
> > > implement it and it first implemented in the bond driver. 
> > > This is follow-up to the RFC discussion [1].
> > > 
> > > The main motivation for doing this is for drivers that offload part
> > > of the LAG functionality. For example, Mellanox Connect-X hardware
> > > implements RoCE LAG which selects the TX affinity when the
> > > resources
> > > are created and port is remapped when it goes down.
> > > 
> > > The first part of this patchset introduces the new .ndo and add the
> > > support to the bonding module.
> > > 
> > > The second part adds support to get the RoCE LAG xmit slave by
> > > building
> > > skb of the RoCE packet based on the AH attributes and call to the
> > > new
> > > .ndo.
> > > 
> > > The third part change the mlx5 driver driver to set the QP's
> > > affinity
> > > port according to the slave which found by the .ndo.
> > > 
> > > Thanks
> > > 
> > > [1]
> > > https://lore.kernel.org/netdev/20200126132126.9981-1-maorg@xxxxxxxxxxxx/
> > 
> > where did these xxxxx's come from?
> > 
> > > Change log:
> > > v8: Fix bad numbering of v7. 
> > > v7: Change only in RDMA part:
> > > 	- return slave and as output
> > > 	- Don't hold lock while allocating skb.
> > >     In addition, reorder patches, so mlx5 patches are before RDMA.
> > > v6: patch 1 - Fix commit message and add function description. 
> > >     patch 10 - Keep udata as function argument.
> > > v5: patch 1 - Remove rcu lock.
> > >     patch 10 - Refactor patch that group the AH attributes in
> > > struct.
> > >     patch 11 - call the ndo while holding the rcu and initialize
> > > xmit_slave.
> > >     patch 12 - Store the xmit slave in rdma_ah_init_attr and
> > > qp_attr.
> > > 
> > > v4: 1. Rename master_get_xmit_slave to netdev_get_xmit_slave and
> > > move
> > > the implementation to dev.c 
> > >     2. Remove unnecessary check of NULL pointer.
> > >     3. Fix typo.
> > > v3: 1. Move master_get_xmit_slave to netdevice.h and change the
> > > flags
> > > arg.
> > > to bool.
> > >     2. Split helper functions commit to multiple commits for each
> > > bond
> > > mode.
> > >     3. Extract refcotring changes to seperate commits.
> > > v2: The first patch wasn't sent in v1.
> > > v1:
> > > https://lore.kernel.org/netdev/ac373456-b838-29cf-645f-b1ea1a93e3b0@xxxxxxxxx/T/#t 
> > > 
> > > Maor Gottlieb (16):
> > >   net/core: Introduce netdev_get_xmit_slave
> > >   bonding: Export skip slave logic to function
> > >   bonding: Rename slave_arr to usable_slaves
> > >   bonding/alb: Add helper functions to get the xmit slave
> > >   bonding: Add helper function to get the xmit slave based on hash
> > >   bonding: Add helper function to get the xmit slave in rr mode
> > >   bonding: Add function to get the xmit slave in active-backup mode
> > >   bonding: Add array of all slaves
> > >   bonding: Implement ndo_get_xmit_slave
> > >   net/mlx5: Change lag mutex lock to spin lock
> > >   net/mlx5: Add support to get lag physical port
> > >   RDMA: Group create AH arguments in struct
> > >   RDMA/core: Add LAG functionality
> > >   RDMA/core: Get xmit slave for LAG
> > >   RDMA/mlx5: Refactor affinity related code
> > >   RDMA/mlx5: Set lag tx affinity according to slave
> > 
> > It seems fine to me too, Saeed, can you apply the net parts to the
> > mlx5 shared branch with DaveM's ack? Thanks
> > 
> 
> Done:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git/log/?h=mlx5-next

Okay, applied thanks

Jason
