Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 626851E4DF4
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 21:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729151AbgE0TO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 15:14:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725795AbgE0TO0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 15:14:26 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C915C08C5C1
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 12:14:26 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id 18so25264157iln.9
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 12:14:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6gQSEGMWPgkGGVyHG9Pe+5fUPTmNwG1QJK7jkF0ZgaY=;
        b=f2+bfCz5l3s2mc0xZ3f2Pq3WNIRwZ8/K67kflMCF9lRfWG7wXe314goLmBz5B0Cd60
         +5vJVT0dTUlySipyBR16irIcNP5wMDuUMy1RkgvXzms9Wb+oEtNLdKXLWMsusauMh+xZ
         NvgnYCDf3lgOevnvYhzKPhv4lszdeNDNo4nIbGDDXy2uvj+nCnHj/hIGINnlzaHpVnXz
         U2Mhbx0uzLlIHEMjPHZVWXi0epD+kk0mf41r3vnhMeWCo7aOEN2h0PZpzy6BNLO2CdJg
         4CXuHrITF4Ep7CvoDtfk7R317k4qcgw8oCXy50U5YmzOtUeC08H68OHTNLpfOoE9BdNN
         BAzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=6gQSEGMWPgkGGVyHG9Pe+5fUPTmNwG1QJK7jkF0ZgaY=;
        b=fSZpJUl9yjaoV2CvxppPOC+1ZIdqA5lV7A3B0+kP0K86tZ+eOcXtdghLhgL30urNmC
         IL/sqrVEgDe1c8h5AudL6xJJCLQ+nWemnygJoec4QwKN9UjcOo2r2dsyL9Yb8MhoPVqP
         bCknmjYxHaIVMKDyAvbT3Q+khGjBOgHKcEd3rXutaupRb8rH0NdN3MFNpHPbPqOW5hmF
         P6dL66UZfflVSYNaoDi/TW0uy4fMNl2i29djZSyOyUa+8X6LA0sCsLZLa7YTZ/zYj3/e
         yqPkF1FfXt6esTyp3xAJyoSNpm6Z0B0nHww5UJ0xHN4jWSB17dEdDX8HQSHPiovkn9t5
         7Ixg==
X-Gm-Message-State: AOAM5308s5HZ28AXLqmuY7Al3ShfT3x7e4Nsv2nm8HBhpsuVpt7bAy1X
        EWTESbsbW7dwJpbFnrTXsoGuVA==
X-Google-Smtp-Source: ABdhPJygidZnbAa0eGY1UJRtoYPZNdP08x0hWzTxRx7yxq441Lory3g22et2VwaQetBDV6SZ86g0Yg==
X-Received: by 2002:a92:d147:: with SMTP id t7mr4292743ilg.151.1590606865912;
        Wed, 27 May 2020 12:14:25 -0700 (PDT)
Received: from ziepe.ca ([206.223.160.26])
        by smtp.gmail.com with ESMTPSA id g21sm666621ioc.14.2020.05.27.12.14.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 27 May 2020 12:14:25 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1je1VQ-0005Pm-Hp; Wed, 27 May 2020 16:14:24 -0300
Date:   Wed, 27 May 2020 16:14:24 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        Danil Kipnis <danil.kipnis@cloud.ionos.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, rds-devel@oss.oracle.com,
        Sagi Grimberg <sagi@grimberg.me>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        target-devel@vger.kernel.org
Subject: Re: [PATCH rdma-next v3 0/6] Add Enhanced Connection Established
 (ECE)
Message-ID: <20200527191424.GA20778@ziepe.ca>
References: <20200526103304.196371-1-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200526103304.196371-1-leon@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 26, 2020 at 01:32:58PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> Changelog:
>  v3:
>  * Rebased on top of ebd6e96b33a2 RDMA/ipoib: Remove can_sleep parameter from iboib_mcast_alloc
>  * Updated rdma_reject patch to include newly added RTR ulp
>  * Remove empty hunks added by rebase
>  * Changed signature of rdma_reject so kernel users will provide reason by themselves
>  * Squashed UAPI patch to other patches which add functionality
>  * Removed define of the IBTA reason from UAPI
>  v2: https://lore.kernel.org/linux-rdma/20200413141538.935574-1-leon@kernel.org/
>  * Rebased on latest rdma-next and removed already accepted patches.
>  * Updated all rdma_reject in-kernel users to provide reject reason.
>  v1: Dropped field_avail patch in favor of mass conversion to use function
>      which already exists in the kernel code.
>  https://lore.kernel.org/lkml/20200310091438.248429-1-leon@kernel.org
>  v0: https://lore.kernel.org/lkml/20200305150105.207959-1-leon@kernel.org
> 
> Enhanced Connection Established or ECE is new negotiation scheme
> introduced in IBTA v1.4 to exchange extra information about nodes
> capabilities and later negotiate them at the connection establishment
> phase.
> 
> The RDMA-CM messages (REQ, REP, SIDR_REQ and SIDR_REP) were extended
> to carry two fields, one new and another gained new functionality:
>  * VendorID is a new field that indicates that common subset of vendor
>    option bits are supported as indicated by that VendorID.
>  * AttributeModifier already exists, but overloaded to indicate which
>    vendor options are supported by this VendorID.
> 
> This is kernel part of such functionality which is responsible to get data
> from librdmacm and properly create and handle RDMA-CM messages.
> 
> Thanks
> 
> Leon Romanovsky (6):
>   RDMA/cm: Add Enhanced Connection Establishment (ECE) bits
>   RDMA/ucma: Extend ucma_connect to receive ECE parameters
>   RDMA/ucma: Deliver ECE parameters through UCMA events
>   RDMA/cm: Send and receive ECE parameter over the wire
>   RDMA/cma: Connect ECE to rdma_accept
>   RDMA/cma: Provide ECE reject reason

Applied to for-next, thanks

Jason
