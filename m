Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB0891644F7
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 14:04:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727686AbgBSNE5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 08:04:57 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:45377 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726617AbgBSNE5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 08:04:57 -0500
Received: by mail-qk1-f195.google.com with SMTP id a2so22820362qko.12
        for <netdev@vger.kernel.org>; Wed, 19 Feb 2020 05:04:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=goLUugo2OcTd80Umui3tF9d4Pkr7paqnVUo9dLDeBaU=;
        b=OsI3n81/VYVZ0WkakBm6Md8OmeNeMhEdktr7wEgXim8YZe7N/5zJjaf2xod5Whd6Bb
         QaJJrAMOiy1aBVHnA/CLprv0EB89Ymjj9MUl8PqBbiqq67EN1KbuqMOlDYwQKbjgOQaW
         zf/FroPxNtqkuqkaVNCZiu/msV290IQ29Zaq7nJEKR8Kwxg+5Vm/1MKn8nRSP5iFqO92
         knT357KPMvhNeBIUdGytFqc/cTstbOODiVH/5BaQWBb3SY+2z2D6CxcuLBRt1sVyE+Ef
         FLZHgOhL1l1eAmBl7iZhozVW9ayxUL1sF5aQYp09VXEUbDppncp0WZv4KL72FqUGnE+z
         aqPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=goLUugo2OcTd80Umui3tF9d4Pkr7paqnVUo9dLDeBaU=;
        b=CeD6kqjQtFO3uJtL0h9KLO73bRM2hfGNtELuEcgaNnjTSlJJldarBEyDRXNI7POFCt
         WzCdG4Id5vhiGpOrdJ5a0Nmm1EEqjKK/GyiMlE/+nxEsQVaNE+herI3NG65X8jq94sWZ
         X8Dlufe2/+f2v+Sqs62CxivN0ScPtnH5iS3E0v9vXFoe7EKnJ5N67XFccvyvgX5/rBWv
         81YWYCpm455Dw0oGZGCS131y7/q8Y8ZTgeJLdNLGoNyJSoPAzsAqEj27R7C6CCV7V/OL
         JOJB0NVqAeDUoIvljjyV3VA4MgV4LWnO6kmDdC63v3UMafXxznU8/UtmpQy+LJuAwQ3P
         42Hw==
X-Gm-Message-State: APjAAAU9YU5Tljn9CuNH3k7gtLOZNlldG5EctNRGd5OcGf7fmDtvrCz8
        gDMPUCt0XXIPb98n7XzLSa+2LA==
X-Google-Smtp-Source: APXvYqxJLsvAqlYphCh5e9GMvszpHDnG9qhhwA485l0jlHZRwK3O7Gt57g8U47CpqY7u+6v/lf4oxw==
X-Received: by 2002:a05:620a:41b:: with SMTP id 27mr23823411qkp.349.1582117496531;
        Wed, 19 Feb 2020 05:04:56 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id x197sm960409qkb.28.2020.02.19.05.04.55
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 19 Feb 2020 05:04:56 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1j4P27-0000tR-Bf; Wed, 19 Feb 2020 09:04:55 -0400
Date:   Wed, 19 Feb 2020 09:04:55 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Lang Cheng <chenglang@huawei.com>, dledford@redhat.com,
        davem@davemloft.net, salil.mehta@huawei.com,
        yisen.zhuang@huawei.com, linuxarm@huawei.com,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>, bhaktipriya96@gmail.com,
        tj@kernel.org, Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: Re: [RFC rdma-next] RDMA/core: Add attribute WQ_MEM_RECLAIM to
 workqueue "infiniband"
Message-ID: <20200219130455.GL31668@ziepe.ca>
References: <1581996935-46507-1-git-send-email-chenglang@huawei.com>
 <20200218153156.GD31668@ziepe.ca>
 <212eda31-cc86-5487-051b-cb51c368b6fe@huawei.com>
 <20200219064507.GC15239@unreal>
 <1155d15f-4188-e5cd-3e4a-6e0c52e9b1eb@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1155d15f-4188-e5cd-3e4a-6e0c52e9b1eb@huawei.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 19, 2020 at 03:40:59PM +0800, Yunsheng Lin wrote:
> +cc Bhaktipriya, Tejun and Jeff
> 
> On 2020/2/19 14:45, Leon Romanovsky wrote:
> > On Wed, Feb 19, 2020 at 09:13:23AM +0800, Yunsheng Lin wrote:
> >> On 2020/2/18 23:31, Jason Gunthorpe wrote:
> >>> On Tue, Feb 18, 2020 at 11:35:35AM +0800, Lang Cheng wrote:
> >>>> The hns3 driver sets "hclge_service_task" workqueue with
> >>>> WQ_MEM_RECLAIM flag in order to guarantee forward progress
> >>>> under memory pressure.
> >>>
> >>> Don't do that. WQ_MEM_RECLAIM is only to be used by things interlinked
> >>> with reclaimed processing.
> >>>
> >>> Work on queues marked with WQ_MEM_RECLAIM can't use GFP_KERNEL
> >>> allocations, can't do certain kinds of sleeps, can't hold certain
> >>> kinds of locks, etc.
> 
> By the way, what kind of sleeps and locks can not be done in the work
> queued to wq marked with WQ_MEM_RECLAIM?

Anything that recurses back into a blocking allocation function.

If we are freeing memory because an allocation failed (eg GFP_KERNEL)
then we cannot go back into a blockable allocation while trying to
progress the first failing allocation. That is a deadlock.

So a WQ cannot hold any locks that enclose GFP_KERNEL in any other
threads.

Unfortunately we don't have a lockdep test for this by default.

> >> hns3 ethernet driver may be used as the low level transport of a
> >> network file system, memory reclaim data path may depend on the
> >> worker in hns3 driver to bring back the ethernet link so that it flush
> >> the some cache to network based disk.
> > 
> > Unlikely that this "network file system" dependency on ethernet link is correct.
> 
> Ok, I may be wrong about the above usecase.  but the below commit
> explicitly state that network devices may be used in memory reclaim
> path.

I don't really know how this works when the networking stacks
intersect with the block stack.

Forward progress on something like a NVMeOF requires a lot of stuff to
be working, and presumably under reclaim.

But, we can't make everything WQ_MEM_RECLAIM safe, because we could
never do a GFP_KERNEL allocation..

I have never seen specific guidance what to do here, I assume it is
broken.

Jason
