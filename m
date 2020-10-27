Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF6C829AB6C
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 13:05:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1750631AbgJ0MFY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 08:05:24 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:44496 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439079AbgJ0MFX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 08:05:23 -0400
Received: by mail-pg1-f196.google.com with SMTP id o3so652571pgr.11
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 05:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jh7sDSXXWr1G/EJt2NwYBs7gBq8ZBGiSTik+UKT8RDo=;
        b=c9cGaErAJceMBjUwS5KyqXKvvC1/ex4YeMQZg5pytCzXzMqDllWFagBhopX+/4PuLh
         yHDRL9G8Nw9C0PJ/ImPGiRSr05T5xxLlfbIyvk6/FdwVJ7nD/D6Cr29i3VsSiSHBPoLe
         /c3DbGIz9VsgxW5e4Axl58EPREAMLv44wrMyjYRI4fv6we9JNpzql6ulGVcNsbes8VuH
         SXAx5L/TI4QCP64g8LLY2DTkOeH4Yajd4NAuxhqA/myXH8aumAnO0j64av0yMBjwL4vP
         6sQGQ0vVyyonX2dW4/JOB/AYqijhTIY/dawztd6b1jHBGjoSkMzgDE7kkmNE6kYHEgIL
         nr3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jh7sDSXXWr1G/EJt2NwYBs7gBq8ZBGiSTik+UKT8RDo=;
        b=ZPDJPxYlNYwQXmNIkW5TQNeOwEUU/MRAIvEjilZi8lD1GPc1fbydxd/jZsKMLsKAeU
         dRUd80fnfbZkCEy5EvwpozC4pQf2gfsj/D0eeDtHYYRVUBJOH3Q6j9TgxzeeQYDeJSRk
         4gxTwQgnM8HWj4KBY0ZPJaAzyy26Q4KD3sCCopY+RL0ERIf12YV2Pi3vr5HsrDc0/rli
         R83OWT1oYBU3KZfLbDFbAEMBXm6czBna8IedXm7V6O4aQ1eeyy2Xlj53CnICk5Nqw8F4
         tfAkW5Dt0SrXTmhmkyPVxl1RqX8OI++tI9hpwHHafTizbFiRPK8ta6xepEF5+B+Js8Ox
         NN+Q==
X-Gm-Message-State: AOAM532qVrZXnEvkNC/uwFmlw7+heAu4RkD2CdSQBYd61kn/wx2Bxy3r
        MTcWs1eT8y9abZ9uSv7vTQarVA==
X-Google-Smtp-Source: ABdhPJzt3qVz9rP8KwZ0eK2QmO6Zin+JfYz3eJD4f6acxIROeLz+sjmqqWUlU+ROPKcys6yt1Awi+Q==
X-Received: by 2002:a62:343:0:b029:15c:e33c:faff with SMTP id 64-20020a6203430000b029015ce33cfaffmr1227137pfd.7.1603800321422;
        Tue, 27 Oct 2020 05:05:21 -0700 (PDT)
Received: from ?IPv6:240e:82:3:96c8:9dbf:9753:3203:b67b? ([240e:82:3:96c8:9dbf:9753:3203:b67b])
        by smtp.gmail.com with ESMTPSA id ms10sm1892683pjb.46.2020.10.27.05.05.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Oct 2020 05:05:20 -0700 (PDT)
Subject: Re: [PATCH] RDMA: Add rdma_connect_locked()
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Danil Kipnis <danil.kipnis@cloud.ionos.com>,
        Doug Ledford <dledford@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Keith Busch <kbusch@kernel.org>,
        linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org,
        Max Gurtovoy <mgurtovoy@nvidia.com>, netdev@vger.kernel.org,
        rds-devel@oss.oracle.com, Sagi Grimberg <sagi@grimberg.me>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>
References: <0-v1-75e124dbad74+b05-rdma_connect_locking_jgg@nvidia.com>
From:   Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Message-ID: <11bb18bd-a26a-d0e2-9ff6-6d7e2bf3fb86@cloud.ionos.com>
Date:   Tue, 27 Oct 2020 13:05:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0-v1-75e124dbad74+b05-rdma_connect_locking_jgg@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/26/20 15:25, Jason Gunthorpe wrote:
> There are two flows for handling RDMA_CM_EVENT_ROUTE_RESOLVED, either the
> handler triggers a completion and another thread does rdma_connect() or
> the handler directly calls rdma_connect().
> 
> In all cases rdma_connect() needs to hold the handler_mutex, but when
> handler's are invoked this is already held by the core code. This causes
> ULPs using the 2nd method to deadlock.
> 
> Provide a rdma_connect_locked() and have all ULPs call it from their
> handlers.
> 
> Reported-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
> Fixes: 2a7cec538169 ("RDMA/cma: Fix locking for the RDMA_CM_CONNECT state"
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/infiniband/core/cma.c            | 39 +++++++++++++++++++++---
>   drivers/infiniband/ulp/iser/iser_verbs.c |  2 +-
>   drivers/infiniband/ulp/rtrs/rtrs-clt.c   |  4 +--
>   drivers/nvme/host/rdma.c                 | 10 +++---
>   include/rdma/rdma_cm.h                   | 13 +-------
>   net/rds/ib_cm.c                          |  5 +--
>   6 files changed, 47 insertions(+), 26 deletions(-)
> 
> Seems people are not testing these four ULPs against rdma-next.. Here is a
> quick fix for the issue:
> 
> https://lore.kernel.org/r/3b1f7767-98e2-93e0-b718-16d1c5346140@cloud.ionos.com

I can't see the previous calltrace with this patch.

Tested-by: Guoqing Jiang<guoqing.jiang@cloud.ionos.com>


Thanks,
Guoqing
