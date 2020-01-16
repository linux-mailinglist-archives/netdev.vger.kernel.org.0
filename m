Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03FBF13FA39
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 21:11:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387429AbgAPULF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 15:11:05 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:43237 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730031AbgAPULF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 15:11:05 -0500
Received: by mail-qt1-f196.google.com with SMTP id d18so19964746qtj.10
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 12:11:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=VLJ8QkOcX3t7d82wsjMicfun36MkNJGJqWSP4tuEu6Y=;
        b=O3LgneW4OlbzQFQnev5YneQWSmULSclzU2wUqsZSPaY0fufd+ljEAI4ZTIsEJXigGi
         PxYDgOc5+mgruMG1kIazRNgHf4AK32SS4KBo0JXDYq0CyDL2Dwf2f8WRzhvoyuzoc9rz
         A9Tgsyec4a3SREqsNhOnas+yWw8ylhqEJnnxrqiibcmESbum6E/IHfS1fNLAfQj5GhUD
         71uOX21+TsXp83IHmE03SOVqi34OEN4a4jW/vHPEOLF7bj+2m5Ina3Az57eVKyrKHaih
         xnuU37CIois+/qXKR9DOxVZtpH3EmeERsxQyLS/xtoSQeS56ZSFireh1dr7hRX69Oatt
         smvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=VLJ8QkOcX3t7d82wsjMicfun36MkNJGJqWSP4tuEu6Y=;
        b=Dz6x0pGrWpXMn/QIOfQ1QetPUT0lOqLzPOjmwNOw7BcMhtMKWV75TvDovUJ+STxUGF
         aAdXgRT+aL7fSkZnceZ/NZHY/2ZHgMUnYe79SSBW/tYnO6OxdcQ9bSFPuWlM1HlidhR/
         Na2eLmj5wgJYdfnwvbCdCrRHt5iIe/Thz0sYx5hmeh1isVCRcOayN70zSWl4hmZqvqiv
         QM4G8garV4nOPv+Pb8C4Xp23tA4Algj0qvp1lEtTyss36zertqzu3pX/74+u4j7jGs9w
         qBdRQTLfDqrN3f/yhR9mTn2da6Rc7hr157pIwEJs+UjI4mk7fjqtJdecg5Vbdc2vb/Jh
         r8vw==
X-Gm-Message-State: APjAAAVh3+Iir042Brk+sMqN1gta+BRiUdcSHZfgKz3YHd14YzUZtRJn
        Gb03ozewLW40VKv9hJmRbiohaQ==
X-Google-Smtp-Source: APXvYqwomipdMfBOwQzlkklm9qE8ODUI5spCa3Bt9bAxIbNmwFQPyPe8ro03l0MosHBcCHXmjzMysA==
X-Received: by 2002:aed:2284:: with SMTP id p4mr4138822qtc.329.1579205464105;
        Thu, 16 Jan 2020 12:11:04 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id d51sm11781844qtc.67.2020.01.16.12.11.03
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 16 Jan 2020 12:11:03 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1isBTq-0007gA-QA; Thu, 16 Jan 2020 16:11:02 -0400
Date:   Thu, 16 Jan 2020 16:11:02 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Yishai Hadas <yishaih@mellanox.com>, linux-rdma@vger.kernel.org,
        dledford@redhat.com, saeedm@mellanox.com, maorg@mellanox.com,
        michaelgur@mellanox.com, netdev@vger.kernel.org
Subject: Re: [PATCH rdma-next 00/10] Relaxed ordering memory regions
Message-ID: <20200116201102.GH10759@ziepe.ca>
References: <1578506740-22188-1-git-send-email-yishaih@mellanox.com>
 <20200115180848.GA13397@ziepe.ca>
 <20200116092008.GB6853@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200116092008.GB6853@unreal>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 16, 2020 at 11:20:08AM +0200, Leon Romanovsky wrote:
> On Wed, Jan 15, 2020 at 02:08:48PM -0400, Jason Gunthorpe wrote:
> > On Wed, Jan 08, 2020 at 08:05:30PM +0200, Yishai Hadas wrote:
> > > This series adds an ioctl command to allocate an async event file followed by a
> > > new ioctl command to get a device context.
> > >
> > > The get device context command enables reading some core generic capabilities
> > > such as supporting an optional MR access flags by IB core and its related
> > > drivers.
> > >
> > > Once the above is enabled, a new optional MR access flag named
> > > IB_UVERBS_ACCESS_RELAXED_ORDERING is added and is used by mlx5 driver.
> > >
> > > This optional flag allows creation of relaxed ordering memory regions.  Access
> > > through such MRs can improve performance by allowing the system to reorder
> > > certain accesses.
> > >
> > > As relaxed ordering is an optimization, drivers that do not support it can
> > > simply ignore it.
> > >
> > > Note: This series relies on the 'Refactoring FD usage' series [1] that was sent
> > > to rdma-next.
> > > [1] https://patchwork.kernel.org/project/linux-rdma/list/?series=225541
> > >
> > > Yishai
> > >
> > > Jason Gunthorpe (3):
> > >   RDMA/core: Add UVERBS_METHOD_ASYNC_EVENT_ALLOC
> > >   RDMA/core: Remove ucontext_lock from the uverbs_destry_ufile_hw() path
> > >   RDMA/uverbs: Add ioctl command to get a device context
> > >
> > > Michael Guralnik (7):
> > >   net/mlx5: Expose relaxed ordering bits
> > >   RDMA/uverbs: Verify MR access flags
> > >   RDMA/core: Add optional access flags range
> > >   RDMA/efa: Allow passing of optional access flags for MR registration
> > >   RDMA/uverbs: Add new relaxed ordering memory region access flag
> > >   RDMA/core: Add the core support field to METHOD_GET_CONTEXT
> > >   RDMA/mlx5: Set relaxed ordering when requested
> >
> > This looks OK, can you update the shared branch please
> 
> Thanks, applied
> f4db8e8b0dc3 net/mlx5: Expose relaxed ordering bits

Okay, applied to for-next

Thanks,
Jason
