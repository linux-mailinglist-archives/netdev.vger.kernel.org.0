Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEABF12FCEB
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 20:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728514AbgACTRv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 14:17:51 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:35311 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728380AbgACTRu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 14:17:50 -0500
Received: by mail-qt1-f193.google.com with SMTP id e12so37617707qto.2
        for <netdev@vger.kernel.org>; Fri, 03 Jan 2020 11:17:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=AQfRgEzNKScVK7ORZRzMdOSrFYvw4wiqBCw8mzrg00M=;
        b=VahfFbMWaYxHPKRzq0VsNrFDbBB1N2TcThK/1s9hxBQGZYFQ5mA51nr1pimQe777Ml
         CjpkUL2i/i3/IV4UN8VQFIviQAAtaDaeBCBsk9Lre4Ut5A7tuCYeK9aAw6G0GSVpHeaH
         4zKP+PrL+oY7E87MPsu0MtxmQgsanh5U6TO3og229B3aYcr2LZIXVvE9cZqkQ0NO8dk/
         IetVU2OZYDn44grfPTj4+LkOi7YhxZU7nQeFK9+2Kzguy/7JipwNEw9YsogTZd8wwbQI
         DmrK4Un0KJzeXCKS9ayuXwgy15WU5XpYAyzRHSWQ9Vxhhnvrx0UUm7EFZD5uxx9PIqg9
         qCrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=AQfRgEzNKScVK7ORZRzMdOSrFYvw4wiqBCw8mzrg00M=;
        b=Jnq579Tjjhgcw5UtvasIl5DcvLj4auo6Sg9dD+PhmavZ02T8WbKwoHbyikUefZGeBE
         QQRjj41TwbnGiuApw4x/M3pm9a4QfLXzUgGNqT9PgujL9O5CJ66yOOVw2LxhlFsWgaan
         j6wkI3NYt4bc511g9kTmWwAesq+8+OXoeJgSDpJT93EkchBUjt10I4oN9rvZnBqSy0Fs
         pahELBjdW5inGq3gEBMcV7Xag6nPPxG7sxfbT7/S6nQiX+L9jXAoqXM7msg0eMfRR9wf
         3kzFF2xaBYGBeo3vYvzM25QjPcBGuDKdgTFP98uFKtaIMNyiqY7RQ7nzx//kEpUSoY2f
         vlDA==
X-Gm-Message-State: APjAAAWpGtB0C0PVnMtb/t18U7fRW3nuJC4Oor0+rn2q4rNqz4zoRyau
        X8iGddpvWDhieYDNN+96IhtSTA==
X-Google-Smtp-Source: APXvYqzq/nBgkpzyxtGJwi+WqXurr0HvLJDWrEu1KFzURvBrcPkzj7hOTvm0V83k6i3BZ+MA8SveVw==
X-Received: by 2002:ac8:41cc:: with SMTP id o12mr52737417qtm.263.1578079070036;
        Fri, 03 Jan 2020 11:17:50 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id z8sm18853143qth.16.2020.01.03.11.17.49
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 03 Jan 2020 11:17:49 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1inSSD-0005rm-2U; Fri, 03 Jan 2020 15:17:49 -0400
Date:   Fri, 3 Jan 2020 15:17:49 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Liran Alon <liran.alon@oracle.com>
Cc:     saeedm@mellanox.com, leon@kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, eli@mellanox.com, tariqt@mellanox.com,
        danielm@mellanox.com,
        =?utf-8?B?SMOla29u?= Bugge <haakon.bugge@oracle.com>
Subject: Re: [PATCH v2] net: mlx5: Use iowriteXbe() to ring doorbell and
 remove reduntant wmb()
Message-ID: <20200103191749.GE9706@ziepe.ca>
References: <20200103175207.72655-1-liran.alon@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200103175207.72655-1-liran.alon@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 03, 2020 at 07:52:07PM +0200, Liran Alon wrote:
> diff --git a/include/linux/mlx5/cq.h b/include/linux/mlx5/cq.h
> index 40748fc1b11b..4631ad35da53 100644
> +++ b/include/linux/mlx5/cq.h
> @@ -162,13 +162,8 @@ static inline void mlx5_cq_arm(struct mlx5_core_cq *cq, u32 cmd,
>  
>  	*cq->arm_db = cpu_to_be32(sn << 28 | cmd | ci);
>  
> -	/* Make sure that the doorbell record in host memory is
> -	 * written before ringing the doorbell via PCI MMIO.
> -	 */
> -	wmb();
> -
> -	doorbell[0] = cpu_to_be32(sn << 28 | cmd | ci);
> -	doorbell[1] = cpu_to_be32(cq->cqn);
> +	doorbell[0] = sn << 28 | cmd | ci;
> +	doorbell[1] = cq->cqn;

This does actually have to change to a u64 otherwise it is not the
same.

On x86 LE, it was
 db[0] = swab(a)
 db[1] = swab(b)
 __raw_writel(db)

Now it is
 db[0] = a
 db[1] = b
 __raw_writel(swab(db))

Putting the swab around the u64 swaps the order of a/b in the TLP.

It might be tempting to swap db[0]/db[1] but IIRC this messed it up on
BE.

The sanest, simplest solution is to use a u64 natively, as the example
I gave did.

There is also the issue of casting a u32 to a u64 and possibly
triggering a unaligned kernel access, presumably this doesn't happen
today only by some lucky chance..

>  	mlx5_write64(doorbell, uar_page + MLX5_CQ_DOORBELL);
>  }
> diff --git a/include/linux/mlx5/doorbell.h b/include/linux/mlx5/doorbell.h
> index 5c267707e1df..9c1d35777323 100644
> +++ b/include/linux/mlx5/doorbell.h
> @@ -43,17 +43,15 @@
>   * Note that the write is not atomic on 32-bit systems! In contrast to 64-bit
>   * ones, it requires proper locking. mlx5_write64 doesn't do any locking, so use
>   * it at your own discretion, protected by some kind of lock on 32 bits.
> - *
> - * TODO: use write{q,l}_relaxed()
>   */
>  
> -static inline void mlx5_write64(__be32 val[2], void __iomem *dest)
> +static inline void mlx5_write64(u32 val[2], void __iomem *dest)
>  {

So this should accept a straight u64, the goofy arrays have to go away

>  #if BITS_PER_LONG == 64
> -	__raw_writeq(*(u64 *)val, dest);
> +	iowrite64be(*(u64 *)val, dest);
>  #else
> -	__raw_writel((__force u32) val[0], dest);
> -	__raw_writel((__force u32) val[1], dest + 4);
> +	iowrite32be(val[0], dest);
> +	iowrite32be(val[1], dest + 4);

With a u64 input this fallback is written as

  iowrite32be(val >> 32, dest)
  iowrite32be((u32)val, dest + 4)

Which matches the definition for how write64 must construct a TLP.

And arguably the first one should be _relaxed (but nobody cares about
this code path)

Jason
