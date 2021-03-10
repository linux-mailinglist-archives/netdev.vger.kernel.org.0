Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3A4B3347DF
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 20:26:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232676AbhCJTZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 14:25:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230522AbhCJTZX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 14:25:23 -0500
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1232DC061760
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 11:25:23 -0800 (PST)
Received: by mail-qt1-x82a.google.com with SMTP id l14so11169463qtr.10
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 11:25:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=p1t+LCEcToEO69LuDJ+gvgB0pJUBvojUJco+R6+E7r0=;
        b=G6c97RpwrUiksDQL3ooSo0UyafF3XoYJnjyw+X5wptdXsADPWUu6Kx4jtC1tOfLMKV
         ZSQcvgkal3/4373Yuc3LdBFG0cly5Bw16zOWlRaGOu7D3aSeEk+muhsP2S9t6ebijv4o
         ql9ukP6txd4IbeO6hdttHXz5S70tllyYZPhYy/o3YUHsg0fxCPzoDPwXnd9TM+k7ME5n
         aM1MIzW4YYib90pTV/pwkFZN/G/LYvXEiDsu+Yq/n/Y3f8hRG3P9mIUwQ6Z7CJ4L3Wof
         J0XQHVWgWJeWmpfGfcScJWIrPb8xzOcDcoU2lvaFILTwrN1Pzj4DpwHA2cUigGkHobdC
         ZSfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=p1t+LCEcToEO69LuDJ+gvgB0pJUBvojUJco+R6+E7r0=;
        b=okAH2xxC1QCdwbLzM7SblgY952BGp3hGErWichxxEg5rvLm1unNajy5Qrqr3G8xJRn
         jmnAFforu7i7vm7UpBUSNuEqmmVGpxpbggUtzIJIjbtQwsCwItSbgHHiGfV1RVVarFIU
         Q9DDlYXOyEOLg5eg0iTpUrximlOx/m3rpKJGvYeAIyyXzv/4lL7OnZCz93krYuLEIKxj
         YgS6O2Fk/WvqH/EDTUVZ49Vyj41DMw+j6Mhf7eBsFsARAb6GEF0dUpxDOtIxsrL11FCi
         d+Tt3oWC7yAYxaS+1+FDYbCMhrGudg1CzZQQZmB9Cc0KkwT0+Qr3jb8n6F/0vKIWvhOA
         cGdg==
X-Gm-Message-State: AOAM531bg4jKsWa+w53GZ7S8uNrvzzXuC27oa5byRc2BhA8EDvR6vcdt
        iUNFRNqqV3FJ84pWjQoOt+kr0w==
X-Google-Smtp-Source: ABdhPJyhOTekQq5OqxwdHNOvwOjYK0Ycq4jpvHa7GN/3UcDN+2T2yFDy526sD0o9vqRmnmNYtqMLWQ==
X-Received: by 2002:ac8:149a:: with SMTP id l26mr4114299qtj.210.1615404322324;
        Wed, 10 Mar 2021 11:25:22 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-115-133.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.115.133])
        by smtp.gmail.com with ESMTPSA id o1sm124518qtq.81.2021.03.10.11.25.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 11:25:21 -0800 (PST)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1lK4SP-00AtUF-1k; Wed, 10 Mar 2021 15:25:21 -0400
Date:   Wed, 10 Mar 2021 15:25:21 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [net 13/18] RDMA/mlx5: Fix timestamp default mode
Message-ID: <20210310192521.GO444867@ziepe.ca>
References: <20210310190342.238957-1-saeed@kernel.org>
 <20210310190342.238957-14-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210310190342.238957-14-saeed@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 10, 2021 at 11:03:37AM -0800, Saeed Mahameed wrote:
> From: Maor Gottlieb <maorg@nvidia.com>
> 
> 1. Don't set the ts_format bit to default when it reserved - device is
>    running in the old mode (free running).
> 2. XRC doesn't have a CQ therefore the ts format in the QP
>    context should be default / free running.
> 3. Set ts_format to WQ.
> 
> Fixes: 2fe8d4b87802 ("RDMA/mlx5: Fail QP creation if the device can not support the CQE TS")
> Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> ---
>  drivers/infiniband/hw/mlx5/qp.c | 18 ++++++++++++++----
>  1 file changed, 14 insertions(+), 4 deletions(-)

Acked-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
