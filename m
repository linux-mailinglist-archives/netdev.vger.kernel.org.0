Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 683E413CB9E
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 19:05:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729147AbgAOSFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 13:05:52 -0500
Received: from mail-qv1-f67.google.com ([209.85.219.67]:41197 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728921AbgAOSFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 13:05:52 -0500
Received: by mail-qv1-f67.google.com with SMTP id x1so7790609qvr.8
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 10:05:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=PRN5r/yQBDrZdUF4jkcibfR6wsU0zRPswMMEipbG8wA=;
        b=lyf4hkqwAtfAgfoltDCD81VxONTKCdSOEvnDQkxriLEv98ZNBLQFOnsGyiLmYkNMEL
         Hye2l9W1z0LTyfrOGdeWUGat3scmaehcxEfPXXuJ9kG30WQ6eIzhSlNQHxLo/SeEu4K7
         9d59wtCxIK890isftNqh1aeON41sVXp1lOUFcpq26W+LjjCdKWy60AJvGc4xOVKxKGCp
         V8zlkrL/0yvlWeoGZlySBkbcOYVejwhOhRv+ElDFIsJsWFWjhnfLR+8swggi6ZqgBmfS
         /aU8vLp5puFDxwrghib2s3UTMxUPJNaoXA4S+PdMHWKkCa9K8K+xb3/nCOy9OodcU5EB
         08OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=PRN5r/yQBDrZdUF4jkcibfR6wsU0zRPswMMEipbG8wA=;
        b=lPi0aZfIBehBcGtEsPZ8XzeGh7Mga9Rh2tqbG9Ua2l+0MXVhLD7PBcjAtLZuqC6xIH
         4BxMM756gKgDVh458YRUPfwacRCCrSxZoKF2VTc9odrP2a5jHRmFp1xyhUPSqaoNNtlO
         d/ztbtUFUVCxTnPeEtNmv6y3TAAtP8CQJbJdHKkwcKJMEr6o7UlTra0if2X9baNNq5pw
         C1bRzu+nO0c+4LHnDES34QkArEjTzBO/2A6bfGOUjWdiiry0ROkQ8ie4whfRdviqwbxw
         gN7iQlVMY+luf02rZXstZGpaSOW90Z1dbVqhr6L7f8ih39oVC0OCQhSUYuffWotHB0qi
         7WnA==
X-Gm-Message-State: APjAAAUkDTa5nUcK2sW47qjiC/R7S+0wEUCmbd0Lfw9zoC6oQa1PlDOp
        8kLVlJabJNLKvlQdv/RJnJNOFg==
X-Google-Smtp-Source: APXvYqzsN2F/Yz9kixpW11WSJq/ddxDEc728m47p92CkqguMwsoB2aOwV7a+qJaXne4z6aCMx72JMw==
X-Received: by 2002:a05:6214:1103:: with SMTP id e3mr23425799qvs.159.1579111551369;
        Wed, 15 Jan 2020 10:05:51 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id t42sm10141050qtt.84.2020.01.15.10.05.49
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 15 Jan 2020 10:05:50 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1irn37-0003Ry-8j; Wed, 15 Jan 2020 14:05:49 -0400
Date:   Wed, 15 Jan 2020 14:05:49 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Yishai Hadas <yishaih@mellanox.com>
Cc:     linux-rdma@vger.kernel.org, dledford@redhat.com,
        saeedm@mellanox.com, maorg@mellanox.com, michaelgur@mellanox.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH rdma-next 08/10] RDMA/uverbs: Add new relaxed ordering
 memory region access flag
Message-ID: <20200115180549.GA8252@ziepe.ca>
References: <1578506740-22188-1-git-send-email-yishaih@mellanox.com>
 <1578506740-22188-9-git-send-email-yishaih@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1578506740-22188-9-git-send-email-yishaih@mellanox.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 08, 2020 at 08:05:38PM +0200, Yishai Hadas wrote:
> From: Michael Guralnik <michaelgur@mellanox.com>
> 
> Adding new relaxed ordering access flag for memory regions.
> Using memory regions with relaxed ordeing set can enhance performance.
> 
> This access flag is handled in a best-effort manner, drivers should
> ignore if they don't support setting relaxed ordering.
> 
> Signed-off-by: Michael Guralnik <michaelgur@mellanox.com>
> Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
>  include/rdma/ib_verbs.h                 | 1 +
>  include/uapi/rdma/ib_user_ioctl_verbs.h | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index ffb358f..2b3c16f 100644
> +++ b/include/rdma/ib_verbs.h
> @@ -1418,6 +1418,7 @@ enum ib_access_flags {
>  	IB_ZERO_BASED = IB_UVERBS_ACCESS_ZERO_BASED,
>  	IB_ACCESS_ON_DEMAND = IB_UVERBS_ACCESS_ON_DEMAND,
>  	IB_ACCESS_HUGETLB = IB_UVERBS_ACCESS_HUGETLB,
> +	IB_ACCESS_RELAXED_ORDERING = IB_UVERBS_ACCESS_RELAXED_ORDERING,
>  
>  	IB_ACCESS_OPTIONAL = IB_UVERBS_ACCESS_OPTIONAL_RANGE,
>  	IB_ACCESS_SUPPORTED =
> diff --git a/include/uapi/rdma/ib_user_ioctl_verbs.h b/include/uapi/rdma/ib_user_ioctl_verbs.h
> index 76dbbd9..2a165f4 100644
> +++ b/include/uapi/rdma/ib_user_ioctl_verbs.h
> @@ -54,6 +54,7 @@ enum ib_uverbs_access_flags {
>  	IB_UVERBS_ACCESS_ON_DEMAND = 1 << 6,
>  	IB_UVERBS_ACCESS_HUGETLB = 1 << 7,
>  
> +	IB_UVERBS_ACCESS_RELAXED_ORDERING = IB_UVERBS_ACCESS_OPTIONAL_FIRST,
>  	IB_UVERBS_ACCESS_OPTIONAL_RANGE =
>  		((IB_UVERBS_ACCESS_OPTIONAL_LAST << 1) - 1) &
>  		~(IB_UVERBS_ACCESS_OPTIONAL_FIRST - 1)

I would like to see a followup patch to add the DMA_ATTR_WEAK_ORDERING
setting to ib_umem_get when RELAXED_ORDERING is set.

Jason
