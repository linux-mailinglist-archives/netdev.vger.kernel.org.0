Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48DE31CB8A1
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 21:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727844AbgEHTxA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 15:53:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727838AbgEHTw7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 15:52:59 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E802C061A0C
        for <netdev@vger.kernel.org>; Fri,  8 May 2020 12:52:58 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id k81so2987196qke.5
        for <netdev@vger.kernel.org>; Fri, 08 May 2020 12:52:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+PiQ6ckxUTnSDo+AGLRh/Fg+o3k0O3ko3wY06x3JoKE=;
        b=Ts3CIrENqZECosUV9ufuB6NplQ4bZIANry4cTq9ctiFl2W3eKhj5UpDDQOEaY6A2Yd
         mNvqS8MpDNbFmXG47isv0LHHuWhU9DrWeNeUqpMHP3rRP+c5b6gcvtAg+8ZLRMd/gdoD
         1i8v4D54gKF1JaotzplFLT3nMfQ5VKcTVTMjFomlH2d9ykBhs9YeoAV4r0fEyjl3TlPr
         v2KDioACvLG1JOHWROC3jtqtFiE8v+6chVfwhJVwQ6LpHrO+DnmO5kWS3VjbGmk9WNEY
         aeK1VQ7Ix6UqBc9nyw9EdxtaWdyBCOYz2f1ZZWBmiN42UGRN2WCkIjnAj9hWJy7yjUPW
         HsMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+PiQ6ckxUTnSDo+AGLRh/Fg+o3k0O3ko3wY06x3JoKE=;
        b=WJoRItStvZhUQg6+xir/eUlJxGjI5k8bZGzbTJy3CoY8NseENZt52Hn98dhZf9n3Ho
         CVDGFVe6nx9oEWZUoNz5CHsLrIefyTgcDYQzlP0cIn3bU/lxR6ddyedBHRo2kfnnbajS
         018H+6kJGTsL6OaNYbOOK+qJA8C2YXOvsaGKtrUvgxf9bO6UwEPFbL5ygJ4zI2KYOcoZ
         7wgEX4VTF2uv9Pg3/y+U10MermbfFjx2xV51+JUGs3nSeu/IguCuh9tp7rpkXzq9fnlX
         gREwbuLLLsUlyEhc6f7+RBE/tiZtN5J8nW4nybXrueb3vgD4uVorkevPFwjgeNj6rGwn
         0FXw==
X-Gm-Message-State: AGi0PuYpc/AGSRJJwkJn+RmmoTDaZsc6UwTYkOOaIsntD8Y2/JoBE6EW
        Kvu7+77oepJpRqdXVRKvnlhBIQ==
X-Google-Smtp-Source: APiQypJ92/0qZ5iunL9hikarn4eDK0RllMv8mjTvIrEJ1zjbLNqAjWeKqDY9cc4vVlZEbqAojJlNqA==
X-Received: by 2002:a37:a4d8:: with SMTP id n207mr4488919qke.354.1588967577470;
        Fri, 08 May 2020 12:52:57 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id c4sm1945896qkf.120.2020.05.08.12.52.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 May 2020 12:52:56 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jX93I-0002SQ-9Q; Fri, 08 May 2020 16:52:56 -0300
Date:   Fri, 8 May 2020 16:52:56 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-rdma@vger.kernel.org, kvm@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH 09/12] rdma: use __anon_inode_getfd
Message-ID: <20200508195256.GA8912@ziepe.ca>
References: <20200508153634.249933-1-hch@lst.de>
 <20200508153634.249933-10-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200508153634.249933-10-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 08, 2020 at 05:36:31PM +0200, Christoph Hellwig wrote:
> Use __anon_inode_getfd instead of opencoding the logic using
> get_unused_fd_flags + anon_inode_getfile.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/infiniband/core/rdma_core.c | 17 ++++-------------
>  1 file changed, 4 insertions(+), 13 deletions(-)

 
> diff --git a/drivers/infiniband/core/rdma_core.c b/drivers/infiniband/core/rdma_core.c
> index 5128cb16bb485..541e5e06347f6 100644
> --- a/drivers/infiniband/core/rdma_core.c
> +++ b/drivers/infiniband/core/rdma_core.c
> @@ -462,30 +462,21 @@ alloc_begin_fd_uobject(const struct uverbs_api_object *obj,
>  	if (WARN_ON(fd_type->fops->release != &uverbs_uobject_fd_release))
>  		return ERR_PTR(-EINVAL);
>  
> -	new_fd = get_unused_fd_flags(O_CLOEXEC);
> -	if (new_fd < 0)
> -		return ERR_PTR(new_fd);
> -
>  	uobj = alloc_uobj(attrs, obj);
>  	if (IS_ERR(uobj))
> -		goto err_fd;
> +		return uobj;
>  
>  	/* Note that uverbs_uobject_fd_release() is called during abort */
> -	filp = anon_inode_getfile(fd_type->name, fd_type->fops, NULL,
> -				  fd_type->flags);
> -	if (IS_ERR(filp)) {
> -		uobj = ERR_CAST(filp);
> +	new_fd = __anon_inode_getfd(fd_type->name, fd_type->fops, NULL,
> +			fd_type->flags | O_CLOEXEC, &filp);
> +	if (new_fd < 0)
>  		goto err_uobj;

This will conflict with a fix (83a267021221 'RDMA/core: Fix
overwriting of uobj in case of error') that is going to go to -rc
soon.

Also the above misses returning an ERR_PTR if __anon_inode_getfd fails, it
returns a uobj that had been freed.. I suppose it should be something
like

if (new_fd < 0) {
   uverbs_uobject_put(uobj);
   return ERR_PTR(new_fd)
}

?

Jason
