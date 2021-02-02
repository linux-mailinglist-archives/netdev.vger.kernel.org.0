Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64A2530C2AB
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 15:59:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234874AbhBBO5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 09:57:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234851AbhBBO5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 09:57:10 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A575C0613D6;
        Tue,  2 Feb 2021 06:56:30 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id u20so7458881iot.9;
        Tue, 02 Feb 2021 06:56:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ywprqr49p03+cfZRBeKphtdcDQnuW/e8IgxGcaB3r4c=;
        b=aEtV76fg9VVzGVjBp+L1dWv21UvqsLkrrN5OBin8JGqK5fZDNxkbjBMIparpAb+YAe
         mMllGtQWZ0d38a2tLIG0BWqY0V21UYnSeSoBfNHdlliTjH8YSXhV46UaY+SFHSOMA5BB
         iC/rQCvlRADxb7oWsUeA/5fH4j3Br28Apcai3NOOzYVEHkI2KLdC/BKl8iMqPLHDqKP5
         F8yn1LI3YXvCMB6mcSUQ/JffxA2QmDHkF3Bfgr56U3XVEv3F+RYsm++yi2hfR1UMMfHg
         yxy851+gExujpCZ4SIdSch4LPEsCNXxiydoqS03Ok5fTkvhTf5wg7jR1BhiSJEUQXE/n
         c6Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ywprqr49p03+cfZRBeKphtdcDQnuW/e8IgxGcaB3r4c=;
        b=KS3Zme5tqdKpVUYEOchm84dGpXpjXWsGQNMGv70RyYluZTXHFUBhXpkp217UGcvE5H
         ZM0OCL/cZ8C1RIa2yWnuNEsePtQtbaTy+GDZuKRvgxmIaLIZN/eXG6A+eQSCOsjHbjB6
         p/VC3T58Fo05B65nNkUlK15tLMvSRF3GBK+qK1lrlpCK8i6q3NzU0xPmYzI34/Q02caT
         IyZmwRzwIK6gtiWYrhpWfvCeg/uKziJKrLF1uoyIQ0+bifvreYW0RRcoSEUwl0bpwtQ/
         Qhac5Q2m/NC8VSWy5pSdiQKGA1gRdAIlDXzB31rLmSpgdGM4scFPmMnp/AdsOnjp22wx
         Z0AQ==
X-Gm-Message-State: AOAM532CS/MWY4gAHr7LjAj20cZc5s6dxGmy4eteDFOwSY1hKvok2+vw
        LSV/pf8JUuEOgUSpdiMwxr9ZWVsrXYg1r/2uIpxZXC59O2Q=
X-Google-Smtp-Source: ABdhPJxGVSF7gydx/xTnSJqhcdjUGh74ybjOaf6NWa0d6BxL4acTeJ5ohj306r/o/62agcvieNAmcXGajs5Bkm3rzeg=
X-Received: by 2002:a5e:8903:: with SMTP id k3mr17233798ioj.36.1612277789491;
 Tue, 02 Feb 2021 06:56:29 -0800 (PST)
MIME-Version: 1.0
References: <20210123080853.4214-1-dongli.zhang@oracle.com>
In-Reply-To: <20210123080853.4214-1-dongli.zhang@oracle.com>
From:   Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date:   Tue, 2 Feb 2021 15:56:18 +0100
Message-ID: <CAM9Jb+hWqZbS_bT+K32M33vW0WmfR=JWxogH+FciHPx0SYKrvQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] vhost scsi: alloc vhost_scsi with kvzalloc() to
 avoid delay
To:     Dongli Zhang <dongli.zhang@oracle.com>
Cc:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, joe.jin@oracle.com,
        aruna.ramakrishna@oracle.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The size of 'struct vhost_scsi' is order-10 (~2.3MB). It may take long time
> delay by kzalloc() to compact memory pages by retrying multiple times when
> there is a lack of high-order pages. As a result, there is latency to
> create a VM (with vhost-scsi) or to hotadd vhost-scsi-based storage.
>
> The prior commit 595cb754983d ("vhost/scsi: use vmalloc for order-10
> allocation") prefers to fallback only when really needed, while this patch
> allocates with kvzalloc() with __GFP_NORETRY implicitly set to avoid
> retrying memory pages compact for multiple times.
>
> The __GFP_NORETRY is implicitly set if the size to allocate is more than
> PAGE_SZIE and when __GFP_RETRY_MAYFAIL is not explicitly set.
>
> Cc: Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
> Cc: Joe Jin <joe.jin@oracle.com>
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> ---
> Changed since v1:
>   - To combine kzalloc() and vzalloc() as kvzalloc()
>     (suggested by Jason Wang)
>
>  drivers/vhost/scsi.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
> index 4ce9f00ae10e..5de21ad4bd05 100644
> --- a/drivers/vhost/scsi.c
> +++ b/drivers/vhost/scsi.c
> @@ -1814,12 +1814,9 @@ static int vhost_scsi_open(struct inode *inode, struct file *f)
>         struct vhost_virtqueue **vqs;
>         int r = -ENOMEM, i;
>
> -       vs = kzalloc(sizeof(*vs), GFP_KERNEL | __GFP_NOWARN | __GFP_RETRY_MAYFAIL);
> -       if (!vs) {
> -               vs = vzalloc(sizeof(*vs));
> -               if (!vs)
> -                       goto err_vs;
> -       }
> +       vs = kvzalloc(sizeof(*vs), GFP_KERNEL);
> +       if (!vs)
> +               goto err_vs;
>
>         vqs = kmalloc_array(VHOST_SCSI_MAX_VQ, sizeof(*vqs), GFP_KERNEL);
>         if (!vqs)

 Acked-by: Pankaj Gupta <pankaj.gupta@cloud.ionos.com>
