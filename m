Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16FD849DC95
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 09:33:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237782AbiA0IcO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 03:32:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:46366 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237759AbiA0IcN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 03:32:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643272333;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+hzsSfEt812B+qp8pLaEKXZY4iqaixHPcS2PC/AJjRY=;
        b=MurpCxLX4MVfpLh+nEA96tThpLOhga6z7gnKh/XUDxLL+ELwWmcZzeRtvf6tuyONCxq+Ou
        Azycl2Am14mXf/34nNrDFznt6XCwMW9zbLOPAv8rRrbN+Hemlq/9WHN1Lr/xaygnPKnGmq
        IqhnfIrWIrNtvqavcD8pp2yEwxrqj9I=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-645-cO-1aPG7P82InuCGhBx9ag-1; Thu, 27 Jan 2022 03:32:11 -0500
X-MC-Unique: cO-1aPG7P82InuCGhBx9ag-1
Received: by mail-lf1-f69.google.com with SMTP id p31-20020a056512139f00b0043489d9cf38so773633lfa.23
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 00:32:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+hzsSfEt812B+qp8pLaEKXZY4iqaixHPcS2PC/AJjRY=;
        b=T/LNb0jGhK/c2QP9YPeAKBvKRdl06e/kpMzuIhV/czg8au3jkT0mi0iS6WnkhqYsTF
         kmkMNkRPP/gwGvo2iMi0LmrWpub5zu7Ew3ymZPjjT+oZYVTt8O4tQUrKi0culzn/PBhE
         W0rLx3KEqB7dSXOo53t/AimdPw29zHBv7JTdpBMtgqrPF/CIcPpJHWc7r5O2K3snxCUU
         Y81eWIyeXYO9+b2ADlCpi+xZqlDYEO+ZHNtziGGPAmXLl4PrFJrK37sPvVGX6VmgebhH
         zmIfZXQq0/mQ6cf7/n+yjrsKiQkTtmgUYPho9d1cJwTicCBsOk2q2rERwYbo8fjWQ0tO
         OPpw==
X-Gm-Message-State: AOAM5319zRPVKR6LrckVRoLNl2CI0Ih+M2Fml0LYjo+bOWzbd3yM/VoE
        lj368SehZFnflOf66f1Cj+S1rwVtS7f10t36lGCSE8534QMdI15g9vJj6EeMN7jcYCYcHZf48/y
        xImk4GYdp1YA0MuSaR3r6mTwgrpaeGubB
X-Received: by 2002:a19:6a12:: with SMTP id u18mr2163149lfu.348.1643272330165;
        Thu, 27 Jan 2022 00:32:10 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzn9eSiGGfhLO0zjsI1+u0gJevThcq9mgdnntxuPkuBy9qCRRpx6z8S1fE44dsCdfLi8ZxWyEDp9ctCVdi+w8s=
X-Received: by 2002:a19:6a12:: with SMTP id u18mr2163143lfu.348.1643272329966;
 Thu, 27 Jan 2022 00:32:09 -0800 (PST)
MIME-Version: 1.0
References: <20220127020807.844630-1-yinxiujiang@kylinos.cn>
In-Reply-To: <20220127020807.844630-1-yinxiujiang@kylinos.cn>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 27 Jan 2022 16:31:58 +0800
Message-ID: <CACGkMEtEYmVNWqaaEhLZgiv9HZGUAP6zwqXfpdDA_CM2_tav0Q@mail.gmail.com>
Subject: Re: [PATCH] vhost: Make use of the helper macro kthread_run()
To:     Yin Xiujiang <yinxiujiang@kylinos.cn>
Cc:     mst <mst@redhat.com>, kvm <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 27, 2022 at 10:08 AM Yin Xiujiang <yinxiujiang@kylinos.cn> wrote:
>
> Repalce kthread_create/wake_up_process() with kthread_run()
> to simplify the code.
>
> Signed-off-by: Yin Xiujiang <yinxiujiang@kylinos.cn>
> ---
>  drivers/vhost/vhost.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 59edb5a1ffe2..19e9eda9fc71 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -595,7 +595,7 @@ long vhost_dev_set_owner(struct vhost_dev *dev)
>
>         dev->kcov_handle = kcov_common_handle();
>         if (dev->use_worker) {
> -               worker = kthread_create(vhost_worker, dev,
> +               worker = kthread_run(vhost_worker, dev,
>                                         "vhost-%d", current->pid);

Mike plans to introduce user_worker_create() to allow rlimit check[1].
So this is probably not needed.

Thanks

[1] https://www.spinics.net/lists/kernel/msg4161030.html (I'm not sure
this is the recent version, please check the list)


>                 if (IS_ERR(worker)) {
>                         err = PTR_ERR(worker);
> @@ -603,7 +603,6 @@ long vhost_dev_set_owner(struct vhost_dev *dev)
>                 }
>
>                 dev->worker = worker;
> -               wake_up_process(worker); /* avoid contributing to loadavg */
>
>                 err = vhost_attach_cgroups(dev);
>                 if (err)
> --
> 2.30.0
>

