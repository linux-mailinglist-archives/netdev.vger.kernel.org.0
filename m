Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A00DA3950D
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 20:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729924AbfFGS5v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 14:57:51 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:33718 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729783AbfFGS5u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 14:57:50 -0400
Received: by mail-qt1-f194.google.com with SMTP id x2so2607711qtr.0
        for <netdev@vger.kernel.org>; Fri, 07 Jun 2019 11:57:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=YUXV9PM1gUReE/Arf4xImR2GHtQznOUBOXbDNdzr10w=;
        b=aKo5RpQPx8pcoIQAryKpp0vXCouQLfC4wRIivD6RgKoW79W1aecSlZIfANLyfCs7Ch
         Mw/0tY6fXxQoOMdVAo5xWFKFam24LWsX8wFYfdvqpEmbpbn7TZMlhb/T7xZm1QLL9I/X
         mjBA5NWaUzc32uvkkzyQq739YLtL7/839gCjbXWzWW5OgBo7qP8gnhh67dzcRgKUhqPD
         ruCqgtDODk7zKm4Q1V2pCFpAEn7bw/QT1Lzzuud6tHRqyiJ0/vDINoVwgcUp8/UBAonr
         UcTsNhimOqVVG2SHyWPQoaTnl6dHCKEgxRmyGiPvocN6x//MOsFQithnUXEffo/3ou6I
         S7EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=YUXV9PM1gUReE/Arf4xImR2GHtQznOUBOXbDNdzr10w=;
        b=sVy1bFaPswpvzTJNW9vorRjMGYPiGGWrSWyh+0epsNHXY1eCini3dqpTLyTqdVEt84
         nCj034sIT4MNfADTCRY5Gtn5n/VWzaZmVTfO5y8KWgtuEWJsKLN47lzrJWL+wR/ia8tZ
         E0s4tCdvtIZ5fKltSgesY8cPwVys3hZhKHZPRS+9sgwKPJFhakWpYfP7wlclw7Lxt+YK
         BjFiVA0Rz8BIU6bG4eUe5mnT4P4/dQSPfyRjriFMxwgAIjp3FO9qA34mLuKTfzxJEXOM
         No4Ysvfq/qcM01Mvs4kdNo5w2xWZWjWHqW8A+aF92B32WonoXVOpMYd5n7JaVryYDep5
         ktkQ==
X-Gm-Message-State: APjAAAWfJyzTXXwpsiedukJJYRT1YiN4lmhxNciw5qXIrVKlENYQbR7S
        Yg//uBQQlS2VbJxtCrqW3cHVHA==
X-Google-Smtp-Source: APXvYqx3TFzlyw4WzjMypOFIInBA68fRopnC9Mjfy4mwCrCnI6AM+xatVlTQmC3Ry788Y+OFyolYGw==
X-Received: by 2002:a0c:ba20:: with SMTP id w32mr44748746qvf.152.1559933870086;
        Fri, 07 Jun 2019 11:57:50 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-55-100.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.55.100])
        by smtp.gmail.com with ESMTPSA id s23sm780234qtk.31.2019.06.07.11.57.49
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 07 Jun 2019 11:57:49 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1hZK3h-00081s-2M; Fri, 07 Jun 2019 15:57:49 -0300
Date:   Fri, 7 Jun 2019 15:57:49 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     Max Gurtovoy <maxg@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "andy@greyhouse.net" <andy@greyhouse.net>,
        Tal Gilboa <talgi@mellanox.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>
Subject: Re: [pull request][for-next 0/9] Generic DIM lib for netdev and RDMA
Message-ID: <20190607185749.GQ14802@ziepe.ca>
References: <20190605232348.6452-1-saeedm@mellanox.com>
 <20190606071427.GU5261@mtr-leonro.mtl.com>
 <898e0df0-b73c-c6d7-9cbe-084163643236@mellanox.com>
 <20190606130713.GC17392@mellanox.com>
 <9faeadac971aaf481b1066b1dde0fc9e77e893a5.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9faeadac971aaf481b1066b1dde0fc9e77e893a5.camel@mellanox.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 07, 2019 at 06:14:11PM +0000, Saeed Mahameed wrote:
> On Thu, 2019-06-06 at 13:07 +0000, Jason Gunthorpe wrote:
> > On Thu, Jun 06, 2019 at 10:19:41AM +0300, Max Gurtovoy wrote:
> > > > > Solution:
> > > > > - Common logic is declared in include/linux/dim.h and
> > > > > implemented in
> > > > >    lib/dim/dim.c
> > > > > - Net DIM (existing) logic is declared in
> > > > > include/linux/net_dim.h and
> > > > >    implemented in lib/dim/net_dim.c, which uses the common
> > > > > logic from dim.h
> > > > > - Any new DIM logic will be declared in
> > > > > "/include/linux/new_dim.h" and
> > > > >     implemented in "lib/dim/new_dim.c".
> > > > > - This new implementation will expose modified versions of
> > > > > profiles,
> > > > >    dim_step() and dim_decision().
> > > > > 
> > > > > Pros for this solution are:
> > > > > - Zero impact on existing net_dim implementation and usage
> > > > > - Relatively more code reuse (compared to two separate
> > > > > solutions)
> > > > > - Increased extensibility
> > > > > 
> > > > > Tal Gilboa (6):
> > > > >        linux/dim: Move logic to dim.h
> > > > >        linux/dim: Remove "net" prefix from internal DIM members
> > > > >        linux/dim: Rename externally exposed macros
> > > > >        linux/dim: Rename net_dim_sample() to
> > > > > net_dim_update_sample()
> > > > >        linux/dim: Rename externally used net_dim members
> > > > >        linux/dim: Move implementation to .c files
> > > > > 
> > > > > Yamin Friedman (3):
> > > > >        linux/dim: Add completions count to dim_sample
> > > > >        linux/dim: Implement rdma_dim
> > > > >        RDMA/core: Provide RDMA DIM support for ULPs
> > > > Saeed,
> > > > 
> > > > No, for the RDMA patches.
> > > > We need to see usage of those APIs before merging.
> > > 
> > > I've asked Yamin to prepare patches for NVMeoF initiator and target
> > > for
> > > review, so I guess he has it on his plate (this is how he tested
> > > it..).
> > > 
> > > It might cause conflict with NVMe/blk branch maintained by Sagi,
> > > Christoph
> > > and Jens.
> > 
> > It looks like nvme could pull this series + the RDMA patches into the
> > nvme tree via PR? I'm not familiar with how that tree works.
> > 
> > But we need to get the patches posted right away..
> > 
> 
> What do you suggest here ?
> I think the netdev community also deserve to see the rdma patches, at
> least with an external link, I can drop the last patch (or two ) ? but
> i need an external rdma link for people who are going to review this
> series.

Yes, all the patches need to be posted. We should have a 'double
branch' where you send the linux/dim & net stuff to net and then we
add the RDMA stuff on top and send to nvme & rdma with the ULP
patches

Assuming nvme takes pull requests.

But the whole thing should be posted as a single series on the list to
get acks before the PRs are generated.

Similar to how we've run the mlx5 shared branch

Jason
