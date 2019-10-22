Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE352E0AD8
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 19:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731422AbfJVRmb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 13:42:31 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:39716 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727226AbfJVRmb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 13:42:31 -0400
Received: by mail-qk1-f194.google.com with SMTP id 4so17047283qki.6
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 10:42:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Gkeh9SXr2W/e0d/g6gOQoAJngpnGHvNbt25Adv2nDyA=;
        b=J1ud/+VTA4mBP9KsI/BEYsYsFpq5vdsH2zlZE4wcAGMR+XXOvli7YhMZNgS0cVNsmO
         HrlLhS7gdwodoByMTCBJTDiNkvMDgonB5UXFhypFVHAXJtx0Bkn5uNVTc5jaXVHZxE7v
         7m7cTh95J0auoveA4XtlZu0mS0JYWlMdmZZZXDhEHpF6iRXw2fHRqQt6nxYjkji/CLFz
         /QX9ER8GtWRQz+iaLi55ARSAAMd8hYzhn9WzY+ADNRJywk0l6iQpjZ0PF8oSdud7Ky/f
         jS5kocl49x36ie/wrXwD3a3JwcJSej128enzFNLKINbnGZtj5G2NVNH4qOLylL4ucZSy
         xscg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Gkeh9SXr2W/e0d/g6gOQoAJngpnGHvNbt25Adv2nDyA=;
        b=OGunk7i9O/uIvUHomxCvXYfTrCAPamDBytBrZc3srhO0alda3iVKsvcBP7u/AbY+8O
         UGHlIiS+fzN2S070YeIorq3K1Y8XZGjHQDP2WLD33TNRXHAr8qS1Z9yPTc6p3UiZh/Zd
         Ayx8jrS67ks2fjkp0I6X4QxZYII156fNfmJRA0mR7bnpazsLyiHtG0+6CWNM0wzyEH8K
         wPrqp8WxOiA5143bobP7xs9L6yZtZYf0/Vgs/dMhDHaybDmMsMFb9cWO6hBVb3oMBNPN
         UYTx4AepIoXgdXU2pvc8rss4fcGHWlE24MZoANrPelI/ERalhK4BMCmRpDbGa2fKLyj/
         MYLg==
X-Gm-Message-State: APjAAAUFZHJ/1YqkxvO2jTgwWZWDumt6kgMT8scOHNuAR4rkgAfc2H3k
        Ela/xjWyIVc2mA9EAoUV/YI74w==
X-Google-Smtp-Source: APXvYqyNGe52mC3C1CtBUXMYilijRoJ4kPAIEvAuvYC+PJQx5sWz3FTJJUaHusEPOLdLQ9bZHbmfXA==
X-Received: by 2002:a37:bf05:: with SMTP id p5mr4099896qkf.111.1571766149903;
        Tue, 22 Oct 2019 10:42:29 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-180.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.180])
        by smtp.gmail.com with ESMTPSA id x64sm1881486qkd.88.2019.10.22.10.42.29
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 22 Oct 2019 10:42:29 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1iMyAu-0006VF-P2; Tue, 22 Oct 2019 14:42:28 -0300
Date:   Tue, 22 Oct 2019 14:42:28 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yamin Friedman <yaminf@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next v2 0/3] Optimize SGL registration
Message-ID: <20191022174228.GA24923@ziepe.ca>
References: <20191007135933.12483-1-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191007135933.12483-1-leon@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 07, 2019 at 04:59:30PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> Changelog
> v1->v2: https://lore.kernel.org/linux-rdma/20191007115819.9211-1-leon@kernel.org
>  * Used Christoph's comment
>  * Change patch code flow to have one DMA_FROM_DEVICE check
> v0->v1: https://lore.kernel.org/linux-rdma/20191006155955.31445-1-leon@kernel.org
>  * Reorganized patches to have IB/core changes separated from mlx5
>  * Moved SGL check before rdma_rw_force_mr
>  * Added and rephrased original comment.
> 
> -----------------------------------------------------------------------------
> Hi,
> 
> This series from Yamin implements long standing "TODO" existed in rw.c.
> 
> Thanks
> 
> Yamin Friedman (3):
>   net/mlx5: Expose optimal performance scatter entries capability
>   RDMA/rw: Support threshold for registration vs scattering to local
>     pages
>   RDMA/mlx5: Add capability for max sge to get optimized performance

Applied to for-next with various fixes from Christoph and Bart

Thanks,
Jason
