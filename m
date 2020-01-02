Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE0D12EA7C
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 20:29:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728772AbgABT3g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 14:29:36 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:37358 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728420AbgABT3f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 14:29:35 -0500
Received: by mail-qk1-f195.google.com with SMTP id 21so32175049qky.4
        for <netdev@vger.kernel.org>; Thu, 02 Jan 2020 11:29:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=lZawS7LGBxSe67WYxo4+2TlBhXSo7e1vXlOhgZaRFGA=;
        b=QdlVzk/9rTnnZmcfS4UM55LnlRhp1CQyFlnaGCqlttXPXPKK2C4PdVfXa4AqNKaz3f
         qAJz2IbW8160zbhmmqlonOOuxN9pqxRt5R7ao9j6JiY+WXC6mbJNm4Ga3jQoOZ3xzMNN
         hMJ/W9S4SCrPdYV2aj9AZPjfyAf+sixb9lyB92pBggsAObC1H9ttH5NEFN6VXvOy2PSN
         sjPxtZqErcA5Rd4I8KJLpZo3Pa9VIhGQJ+7VI2DtFjSrp29jf8+7nrBPtyL7SalBYUtE
         riv72932/EGIwk5LzYfyzaz0mu9tql65EGVnjXvWpmIW1TsDCdWDcjt7UyMa1/cOONmK
         MQSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=lZawS7LGBxSe67WYxo4+2TlBhXSo7e1vXlOhgZaRFGA=;
        b=tKw9i1ijbtS7YZjlwodlTLd/NSo18unPUyPTJtoNP7DMdQVIhzGOAIqHXr3DSk7MnA
         lbxKjH2Xgc3bMwqyMYvE4OzSNpi++1TZB1Df0Hnqq6gSsE7r0lengYNif7XhKLe9L5nb
         PiSG0euU9mM+tkg9Fei0TyRTgBgkXRZzbRLF+QBloWdUv/loHCIaUHahm5bFk74EtV1R
         6o4KxpBN3GGHLqGci3wzRRKvoRbhS8nYMwfKTyZTg7ctmt04OPsYMYWTP9+gfw9EUYbG
         YrjPIugdL19wDPRqka4MwOp9KFY5FZIkyLPxXH9sRSjofd0k2DV2tzF8yzevNtcrqXBJ
         MoYQ==
X-Gm-Message-State: APjAAAVfglljjkBpw2TpqkRMmMC1OT/2KiiN5nIhs4y6zqlp2wP9aFeO
        e+Usa7d++Gc8Eiz19oillJeFgA==
X-Google-Smtp-Source: APXvYqyT0jnZMEQTogE6nq/iKpifSkHJ7/jv2qA6H8QXBJY9qsxB6DK1bc0V5PIcN/3wpFofDWoNMg==
X-Received: by 2002:ae9:f016:: with SMTP id l22mr67838939qkg.101.1577993374877;
        Thu, 02 Jan 2020 11:29:34 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id g52sm14467349qta.58.2020.01.02.11.29.34
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 02 Jan 2020 11:29:34 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1in6A2-0005bl-1D; Thu, 02 Jan 2020 15:29:34 -0400
Date:   Thu, 2 Jan 2020 15:29:34 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Liran Alon <liran.alon@oracle.com>
Cc:     saeedm@mellanox.com, leon@kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, eli@mellanox.com, tariqt@mellanox.com,
        danielm@mellanox.com,
        =?utf-8?B?SMOla29u?= Bugge <haakon.bugge@oracle.com>
Subject: Re: [PATCH] net: mlx5: Use writeX() to ring doorbell and remove
 reduntant wmb()
Message-ID: <20200102192934.GH9282@ziepe.ca>
References: <20200102174436.66329-1-liran.alon@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200102174436.66329-1-liran.alon@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 02, 2020 at 07:44:36PM +0200, Liran Alon wrote:
> Currently, mlx5e_notify_hw() executes wmb() to complete writes to cache-coherent
> memory before ringing doorbell. Doorbell is written to by mlx5_write64()
> which use __raw_writeX().
> 
> This is semantically correct but executes reduntant wmb() in some architectures.
> For example, in x86, a write to UC memory guarantees that any previous write to
> WB memory will be globally visible before the write to UC memory. Therefore, there
> is no need to also execute wmb() before write to doorbell which is mapped as UC memory.
> 
> The consideration regarding this between different architectures is handled
> properly by the writeX() macro. Which is defined differently for different
> architectures. E.g. On x86, it is just a memory write. However, on ARM, it
> is defined as __iowmb() folowed by a memory write. __iowmb() is defined
> as wmb().

This reasoning seems correct, though I would recommend directly
refering to locking/memory-barriers.txt which explains this.

> Therefore, change mlx5_write64() to use writeX() and remove wmb() from
> it's callers.

Yes, wmb(); writel(); is always redundant
  
> diff --git a/include/linux/mlx5/cq.h b/include/linux/mlx5/cq.h
> index 40748fc1b11b..28744a725e64 100644
> +++ b/include/linux/mlx5/cq.h
> @@ -162,11 +162,6 @@ static inline void mlx5_cq_arm(struct mlx5_core_cq *cq, u32 cmd,
>  
>  	*cq->arm_db = cpu_to_be32(sn << 28 | cmd | ci);
>  
> -	/* Make sure that the doorbell record in host memory is
> -	 * written before ringing the doorbell via PCI MMIO.
> -	 */
> -	wmb();
> -

Why did this one change? The doorbell memory here is not a writel():

>  	doorbell[0] = cpu_to_be32(sn << 28 | cmd | ci);
>  	doorbell[1] = cpu_to_be32(cq->cqn);

>  static inline void mlx5_write64(__be32 val[2], void __iomem *dest)
>  {
>  #if BITS_PER_LONG == 64
> -	__raw_writeq(*(u64 *)val, dest);
> +	writeq(*(u64 *)val, dest);

I want to say this might cause problems with endian swapping as writeq
also does some swaps that __raw does not? Is this true?

ie writeq does not accept a be32

Some time ago I reworked this similar code in userspace to use a u64
and remove the swapping from the caller.

Jason
