Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5DA4C079D
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 03:09:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236723AbiBWCJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 21:09:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233115AbiBWCJp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 21:09:45 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C2FCE344F3
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 18:09:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645582157;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=W9LkpmwRUB9s3DzzklqywD2GBEtiMiXthflpW97NS2M=;
        b=i3PwiWxKRcCCRLelxFJMc8oFWIJjZE923xibPM10bxF/6Y42q87Z7EKls4dqbSK8CkhTVA
        rC2mZJ7gB/56E5HV29FelPEeayZOvACq3ZWQ6BEU8b0lVyKUU4N8Dm58Q5THTFptu64LLQ
        f5wfu9z6V20Wz+F1X7ca2mgKPWUAEjA=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-37-TX7pP-N4MBOyFSNxyPyRdQ-1; Tue, 22 Feb 2022 21:09:16 -0500
X-MC-Unique: TX7pP-N4MBOyFSNxyPyRdQ-1
Received: by mail-lj1-f198.google.com with SMTP id x8-20020a2ea7c8000000b00246215e0fc3so6664500ljp.8
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 18:09:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W9LkpmwRUB9s3DzzklqywD2GBEtiMiXthflpW97NS2M=;
        b=ylsDqmRIaVRrLn7x73KWdXrI2+/ZTo6+WAlNx5p2NFfEcqg6ot/+GLcbPrm6vxk8jG
         zGci2TKe8wVIbRATrlyPkHcYggyxLqGpgDZ4+3K3VIfP/7SYgksxhJSS89le1kvwURf+
         nnqX4grvaT/qWGuv0h4GOrO5SMTNow5e/+Eq/SrNZ1a7xmxPEqYzJehY+ggWV79/gqKP
         CmFn7Q2pjMYKMgukAO3+XyCdupMgV3IqJybWCltYAySK7g+NsaD0Vl1RIY8T2yS2v2BZ
         UgBojJPxdAkI6F+y6xxsOOERvC1kWYS9RtYF7xZ0du8sJBoMrbOPqjiQ9vA7/L3WlXnP
         hk4A==
X-Gm-Message-State: AOAM5339TtrSt43gHCZ+01ubSd0+j5V+dsCpP5kLrzW5ds6aQymTLtYi
        G1bPbjgWsYG6XK/k3y4L6Gq6Oo0x9hWr9Ryzfh1LHiDKLiJw030Om4KnRQk74dmzDyAJfPmP2YB
        W7J1B/xDNJoiLzsvk0HxOk44G4oRgIRhr
X-Received: by 2002:ac2:4da1:0:b0:438:74be:5a88 with SMTP id h1-20020ac24da1000000b0043874be5a88mr17748775lfe.210.1645582155156;
        Tue, 22 Feb 2022 18:09:15 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwWVsv8Sx14FGPZdp4dBv1csb/D6luqE37ndqXaLZ0eJ0z4lL/rN+eJyDfku6eJ6K+YiTb9ktJZ9PM21p2/UQY=
X-Received: by 2002:ac2:4da1:0:b0:438:74be:5a88 with SMTP id
 h1-20020ac24da1000000b0043874be5a88mr17748759lfe.210.1645582154950; Tue, 22
 Feb 2022 18:09:14 -0800 (PST)
MIME-Version: 1.0
References: <20220222094742.16359-1-sgarzare@redhat.com>
In-Reply-To: <20220222094742.16359-1-sgarzare@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 23 Feb 2022 10:09:03 +0800
Message-ID: <CACGkMEtN_YO1Avi79bMyaCqLHMMpDaPvh1oVQPEMRYky_Zbugg@mail.gmail.com>
Subject: Re: [PATCH v2] vhost/vsock: don't check owner in vhost_vsock_stop()
 while releasing
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        syzbot <syzbot+1e3ea63db39f2b4440e0@syzkaller.appspotmail.com>,
        kvm <kvm@vger.kernel.org>,
        Anirudh Rayabharam <mail@anirudhrb.com>,
        syzbot+3140b17cb44a7b174008@syzkaller.appspotmail.com,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mike Christie <michael.christie@oracle.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 22, 2022 at 5:47 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
>
> vhost_vsock_stop() calls vhost_dev_check_owner() to check the device
> ownership. It expects current->mm to be valid.
>
> vhost_vsock_stop() is also called by vhost_vsock_dev_release() when
> the user has not done close(), so when we are in do_exit(). In this
> case current->mm is invalid and we're releasing the device, so we
> should clean it anyway.
>
> Let's check the owner only when vhost_vsock_stop() is called
> by an ioctl.
>
> When invoked from release we can not fail so we don't check return
> code of vhost_vsock_stop(). We need to stop vsock even if it's not
> the owner.
>
> Fixes: 433fc58e6bf2 ("VSOCK: Introduce vhost_vsock.ko")
> Cc: stable@vger.kernel.org
> Reported-by: syzbot+1e3ea63db39f2b4440e0@syzkaller.appspotmail.com
> Reported-and-tested-by: syzbot+3140b17cb44a7b174008@syzkaller.appspotmail.com
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>

Acked-by: Jason Wang <jasowang@redhat.com>

> ---
> v2:
> - initialized `ret` in vhost_vsock_stop [Dan]
> - added comment about vhost_vsock_stop() calling in the code and an explanation
>   in the commit message [MST]
>
> v1: https://lore.kernel.org/virtualization/20220221114916.107045-1-sgarzare@redhat.com
> ---
>  drivers/vhost/vsock.c | 21 ++++++++++++++-------
>  1 file changed, 14 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> index d6ca1c7ad513..37f0b4274113 100644
> --- a/drivers/vhost/vsock.c
> +++ b/drivers/vhost/vsock.c
> @@ -629,16 +629,18 @@ static int vhost_vsock_start(struct vhost_vsock *vsock)
>         return ret;
>  }
>
> -static int vhost_vsock_stop(struct vhost_vsock *vsock)
> +static int vhost_vsock_stop(struct vhost_vsock *vsock, bool check_owner)
>  {
>         size_t i;
> -       int ret;
> +       int ret = 0;
>
>         mutex_lock(&vsock->dev.mutex);
>
> -       ret = vhost_dev_check_owner(&vsock->dev);
> -       if (ret)
> -               goto err;
> +       if (check_owner) {
> +               ret = vhost_dev_check_owner(&vsock->dev);
> +               if (ret)
> +                       goto err;
> +       }
>
>         for (i = 0; i < ARRAY_SIZE(vsock->vqs); i++) {
>                 struct vhost_virtqueue *vq = &vsock->vqs[i];
> @@ -753,7 +755,12 @@ static int vhost_vsock_dev_release(struct inode *inode, struct file *file)
>          * inefficient.  Room for improvement here. */
>         vsock_for_each_connected_socket(vhost_vsock_reset_orphans);
>
> -       vhost_vsock_stop(vsock);
> +       /* Don't check the owner, because we are in the release path, so we
> +        * need to stop the vsock device in any case.
> +        * vhost_vsock_stop() can not fail in this case, so we don't need to
> +        * check the return code.
> +        */
> +       vhost_vsock_stop(vsock, false);
>         vhost_vsock_flush(vsock);
>         vhost_dev_stop(&vsock->dev);
>
> @@ -868,7 +875,7 @@ static long vhost_vsock_dev_ioctl(struct file *f, unsigned int ioctl,
>                 if (start)
>                         return vhost_vsock_start(vsock);
>                 else
> -                       return vhost_vsock_stop(vsock);
> +                       return vhost_vsock_stop(vsock, true);
>         case VHOST_GET_FEATURES:
>                 features = VHOST_VSOCK_FEATURES;
>                 if (copy_to_user(argp, &features, sizeof(features)))
> --
> 2.35.1
>

