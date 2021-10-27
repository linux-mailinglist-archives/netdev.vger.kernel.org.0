Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B14043D208
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 22:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234302AbhJ0UEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 16:04:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46667 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234111AbhJ0UEk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 16:04:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635364933;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eKmmGD1nx7i4kqTzjfQkUa6PYfuzA04HlQL71OLcyPY=;
        b=JrdUJ8VpNYx8C4/R6EsRzRdu924e1cv96AV3lt8pvdpcjSTC22XUXSyOwY+3013Zzig2Nt
        EQNcn0x1hY3On+XEkl4hRy6UEPtSlTyX66OPcyNFHCyYZePwBEjA9ukAH2xMXN4s1v6jal
        GAto4Z13XoCHhoIUoPBCqRz5uPEgA/U=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-369-H8JCNk_iNpW6jRR-2HrL8w-1; Wed, 27 Oct 2021 16:02:12 -0400
X-MC-Unique: H8JCNk_iNpW6jRR-2HrL8w-1
Received: by mail-ed1-f70.google.com with SMTP id v9-20020a50d849000000b003dcb31eabaaso3384267edj.13
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 13:02:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eKmmGD1nx7i4kqTzjfQkUa6PYfuzA04HlQL71OLcyPY=;
        b=kVeLRtgMxxxtOMEYFX21BjSOX0jZ5kyNea5xyMVKujNovHwTpNTDtTaIh940IcPH8M
         9W7AW8uUInZCcfQHTdPJOuFQleuT302QkAJLuQoHPAJPQEy1e/YUF7WKVSyWd+50AC//
         Mwo8zYe0199iGASJ5Z/edHPaujb+iJY236KIovy8hNnTRInE6HQ6McRjUC+hXei3Y15r
         iwJCL2GUWH3e2DFSz93MsZm9Xw6AcV55b78Zmku2WYcE1YcRM3XMrccCYrQsLxaMT/xl
         XJhR/MtJsyLgk3dFeLu5pWhScG5fynTLD/Aj7PIWNhzddBjoYApi+l9+XpTABcYaqfN/
         Q4Og==
X-Gm-Message-State: AOAM530lHJHl8qh9X9BxGRwppWnc1U04IQOJuSJMTbTkmse0bAbDOUIX
        WMsVawZr70MDbj24crd/in7FI/5nbJ/yykRvzJ6un9aLxbAvaNIyOdJPJezhfAHPocI6kbVGlho
        9ABWAsfIqJezaG1xH
X-Received: by 2002:a50:d4c9:: with SMTP id e9mr47956051edj.12.1635364931125;
        Wed, 27 Oct 2021 13:02:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxrbQM+YpSGU4dsYU7jyrTt7pf6zqbcGk70m2QTsfqcvWmFs6yg5FyLDWycPtgyIove9NTZ6w==
X-Received: by 2002:a50:d4c9:: with SMTP id e9mr47956020edj.12.1635364930922;
        Wed, 27 Oct 2021 13:02:10 -0700 (PDT)
Received: from redhat.com ([2.55.137.59])
        by smtp.gmail.com with ESMTPSA id ne2sm420373ejc.44.2021.10.27.13.02.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 13:02:10 -0700 (PDT)
Date:   Wed, 27 Oct 2021 16:02:06 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Cai Huoqing <caihuoqing@baidu.com>
Cc:     Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>
Subject: Re: [PATCH] vhost: Make use of the helper macro kthread_run()
Message-ID: <20211027160010-mutt-send-email-mst@kernel.org>
References: <20211021084406.2660-1-caihuoqing@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211021084406.2660-1-caihuoqing@baidu.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 21, 2021 at 04:44:06PM +0800, Cai Huoqing wrote:
> Repalce kthread_create/wake_up_process() with kthread_run()
> to simplify the code.
> 
> Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>

Pls check how this interacts with Mike Christie's patches.
Pls fix up the typo in the commit log.

> ---
>  drivers/vhost/vhost.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 59edb5a1ffe2..e67bd5603b5f 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -595,15 +595,15 @@ long vhost_dev_set_owner(struct vhost_dev *dev)
>  
>  	dev->kcov_handle = kcov_common_handle();
>  	if (dev->use_worker) {
> -		worker = kthread_create(vhost_worker, dev,
> -					"vhost-%d", current->pid);
> +		/* avoid contributing to loadavg */

doesn't this comment have any value anymore?

> +		worker = kthread_run(vhost_worker, dev,
> +				     "vhost-%d", current->pid);
>  		if (IS_ERR(worker)) {
>  			err = PTR_ERR(worker);
>  			goto err_worker;
>  		}
>  
>  		dev->worker = worker;
> -		wake_up_process(worker); /* avoid contributing to loadavg */
>  
>  		err = vhost_attach_cgroups(dev);
>  		if (err)
> -- 
> 2.25.1

