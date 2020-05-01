Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D34561C1819
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 16:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729259AbgEAOov (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 10:44:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728914AbgEAOou (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 10:44:50 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 657CCC061A0E
        for <netdev@vger.kernel.org>; Fri,  1 May 2020 07:44:50 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id y19so4827754qvv.4
        for <netdev@vger.kernel.org>; Fri, 01 May 2020 07:44:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=U5PjdaeI6wDSO7gdM3zjoZXmYp1q+jp147y29p4wfzk=;
        b=WSaJ6f9mlX6vD9GW6hdUsSCHrqyxVZrj8VQbADFepWoMu+riIrRDlbxe2fXg39EBzE
         x0sPGzykUtDIw9y8F1etfKcdCE6zLKITFVNf7PWP9CGCM1wRw4afh+zOcpJwRhyI/pSV
         Z4dqRySdZO0gx0Az0U8CcLmDe2uJcbj6sj7cw8cUu0PGIYmB9fYVAX7HRUmWIXfnMYMZ
         0gVH5jxfjS7SHwEHZ+3CUT0hVJlo1Qeu0Yli3BNO7HUqSqMz3PDsBYDxBzXXsGjnSioh
         uzcGqtT/UHUIfAkbT1zaawUZsETjrLGUip/xd8XHDv5iyYsxihqmf1onzHBlGo8pNrbQ
         NaAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=U5PjdaeI6wDSO7gdM3zjoZXmYp1q+jp147y29p4wfzk=;
        b=aNHYgq7e3q7ygxvk+IorgTb8qmNJqxfeiY0RreZcWgpju89kD+sKQhsiERjhRjlt9R
         KV7mYDzOmGcxUZueRQ/x5dudiceY3TCrDf5kjTIIbjim7Yf3sGATcuTOziTC3n3cuY9W
         1g6S8JdBx/MN+K6d7dSCUbqp6rJMz0jTY9jWXYKT7PbcQvxeIVWX0iIzXHZYTW64JR2Z
         m76dKF9GsijmvkrnLMwRxH1Wg74pCKla2DKT8okqoMKo4g9RXzYDj3sqDhAFy0DZQYoS
         nFaS0v9uxc6wwtvTGrWk9UhMHqKlBgh9t0dUmSaXy9yF1wEmk533rgANTosgGBQgWYjn
         5trA==
X-Gm-Message-State: AGi0PuZ8m1Rdu+2wIHgix8pcXRP2mRmqkvwH1zQtpHdXo+iZAIlVq/3y
        PDTDdMJrOUYUyFhAik0H2cGs9A==
X-Google-Smtp-Source: APiQypLxzTulW5VDBvswuNVdHxLVKhlwnSaXPY4brbLdxFwXbg3UVgvOUCx6csk4zv6d348AETjL1g==
X-Received: by 2002:ad4:4dc8:: with SMTP id cw8mr2444533qvb.83.1588344289315;
        Fri, 01 May 2020 07:44:49 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id f198sm2876635qke.46.2020.05.01.07.44.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 01 May 2020 07:44:48 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jUWuG-0001Yo-4D; Fri, 01 May 2020 11:44:48 -0300
Date:   Fri, 1 May 2020 11:44:48 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Maor Gottlieb <maorg@mellanox.com>
Cc:     davem@davemloft.net, dledford@redhat.com, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, kuba@kernel.org,
        jiri@mellanox.com, dsahern@kernel.org, leonro@mellanox.com,
        saeedm@mellanox.com, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, alexr@mellanox.com
Subject: Re: [PATCH V8 mlx5-next 00/16] Add support to get xmit slave
Message-ID: <20200501144448.GO26002@ziepe.ca>
References: <20200430192146.12863-1-maorg@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430192146.12863-1-maorg@mellanox.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 30, 2020 at 10:21:30PM +0300, Maor Gottlieb wrote:
> Hi Dave,
> 
> This series is a combination of netdev and RDMA, so in order to avoid
> conflicts, we would like to ask you to route this series through
> mlx5-next shared branch. It is based on v5.7-rc2 tag.
> 
> 
> The following series adds support to get the LAG master xmit slave by
> introducing new .ndo - ndo_get_xmit_slave. Every LAG module can
> implement it and it first implemented in the bond driver. 
> This is follow-up to the RFC discussion [1].
> 
> The main motivation for doing this is for drivers that offload part
> of the LAG functionality. For example, Mellanox Connect-X hardware
> implements RoCE LAG which selects the TX affinity when the resources
> are created and port is remapped when it goes down.
> 
> The first part of this patchset introduces the new .ndo and add the
> support to the bonding module.
> 
> The second part adds support to get the RoCE LAG xmit slave by building
> skb of the RoCE packet based on the AH attributes and call to the new
> .ndo.
> 
> The third part change the mlx5 driver driver to set the QP's affinity
> port according to the slave which found by the .ndo.
> 
> Thanks
> 
> [1]
> https://lore.kernel.org/netdev/20200126132126.9981-1-maorg@xxxxxxxxxxxx/

where did these xxxxx's come from?

> Change log:
> v8: Fix bad numbering of v7. 
> v7: Change only in RDMA part:
> 	- return slave and as output
> 	- Don't hold lock while allocating skb.
>     In addition, reorder patches, so mlx5 patches are before RDMA.
> v6: patch 1 - Fix commit message and add function description. 
>     patch 10 - Keep udata as function argument.
> v5: patch 1 - Remove rcu lock.
>     patch 10 - Refactor patch that group the AH attributes in struct.
>     patch 11 - call the ndo while holding the rcu and initialize xmit_slave.
>     patch 12 - Store the xmit slave in rdma_ah_init_attr and qp_attr.
> 
> v4: 1. Rename master_get_xmit_slave to netdev_get_xmit_slave and move
> the implementation to dev.c 
>     2. Remove unnecessary check of NULL pointer.
>     3. Fix typo.
> v3: 1. Move master_get_xmit_slave to netdevice.h and change the flags
> arg.
> to bool.
>     2. Split helper functions commit to multiple commits for each bond
> mode.
>     3. Extract refcotring changes to seperate commits.
> v2: The first patch wasn't sent in v1.
> v1:
> https://lore.kernel.org/netdev/ac373456-b838-29cf-645f-b1ea1a93e3b0@xxxxxxxxx/T/#t 
> 
> Maor Gottlieb (16):
>   net/core: Introduce netdev_get_xmit_slave
>   bonding: Export skip slave logic to function
>   bonding: Rename slave_arr to usable_slaves
>   bonding/alb: Add helper functions to get the xmit slave
>   bonding: Add helper function to get the xmit slave based on hash
>   bonding: Add helper function to get the xmit slave in rr mode
>   bonding: Add function to get the xmit slave in active-backup mode
>   bonding: Add array of all slaves
>   bonding: Implement ndo_get_xmit_slave
>   net/mlx5: Change lag mutex lock to spin lock
>   net/mlx5: Add support to get lag physical port
>   RDMA: Group create AH arguments in struct
>   RDMA/core: Add LAG functionality
>   RDMA/core: Get xmit slave for LAG
>   RDMA/mlx5: Refactor affinity related code
>   RDMA/mlx5: Set lag tx affinity according to slave

It seems fine to me too, Saeed, can you apply the net parts to the
mlx5 shared branch with DaveM's ack? Thanks

Jason
