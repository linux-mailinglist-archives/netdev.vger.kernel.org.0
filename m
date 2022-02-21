Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD1914BE3F9
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 18:58:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378732AbiBUPEP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 10:04:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378698AbiBUPEN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 10:04:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 455C3BF71
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 07:03:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645455828;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mr/1CQBSFnmPM+qg+tsLOOwlovqhtz4/EPWnJbnRwCM=;
        b=JegRAUzgndjmGQi91V2l3UVjltxeWYdyHL5jbTer9MqW+oLb5DQGw2qexOrrNboj8zMWaz
        CKgFyke6rro/5y8yfcLO8DY7v5sEbaF1khwE6vA7Ma4VTAhQ5xFL4Kc3HBjSS4ZLTZ0MvG
        eXZYh2yqi/QgQHLO6iw9poh0F2yrMdM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-56-Aq73e_zkOUO_KeRdZvDUkg-1; Mon, 21 Feb 2022 10:03:46 -0500
X-MC-Unique: Aq73e_zkOUO_KeRdZvDUkg-1
Received: by mail-wm1-f72.google.com with SMTP id h82-20020a1c2155000000b003552c13626cso8138322wmh.3
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 07:03:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mr/1CQBSFnmPM+qg+tsLOOwlovqhtz4/EPWnJbnRwCM=;
        b=vmGAtAP7BiIaLmgVyHWddwoDhu5w1hk8KTCP2EfffLETpxObc64eq4bv8p85hJOqm9
         YzhOAXv5c915MaRdT65nE5dq3dFpLv0jsuaiEfsaeec3fhu7eM9LCVIgshds9IJArhLb
         nZQH+0pFB5F3UU8x+/Wl3ox9zqhBBqCayvsNyaxmwjBF2zevQSEN3q1DBUjpY5wINwhS
         LnAm5drVKWm6aSLgfMkDw9fSrNYGOUce2lRYc3Whn2FaSqtcj15XkF8KnQuRn/kiTks1
         A4sM7vHTBXzQGniFjepuve0yzSV9IjT9GkZtT2Q1IlOeCALBUpytzTnYMJFtGA0qGupy
         5qgQ==
X-Gm-Message-State: AOAM530w1hBGOsDEA1cVYo1RUeCsZSqCBlUeX9pZYdtr7No3uTbvwlDE
        sL0B8g7mkb3ogMk+ohZ2RU1kHe0pAcXHxqw8gtDdj8bH85qEboeABPC+9rDMkRfGuGPkxkv13C3
        pOdyGQkwgIvdZVOEn
X-Received: by 2002:adf:fbd0:0:b0:1e6:8ec3:570 with SMTP id d16-20020adffbd0000000b001e68ec30570mr17166367wrs.396.1645455825783;
        Mon, 21 Feb 2022 07:03:45 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzV1pmRzjoWzZVTM1CFvom60MmV/YsWRRt4E8ofGC8c5/iOYk+2qzFWrG5At7u3dNopXHgX7g==
X-Received: by 2002:adf:fbd0:0:b0:1e6:8ec3:570 with SMTP id d16-20020adffbd0000000b001e68ec30570mr17166351wrs.396.1645455825521;
        Mon, 21 Feb 2022 07:03:45 -0800 (PST)
Received: from redhat.com ([2.55.129.240])
        by smtp.gmail.com with ESMTPSA id b7sm39967572wrp.23.2022.02.21.07.03.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 07:03:43 -0800 (PST)
Date:   Mon, 21 Feb 2022 10:03:39 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>,
        Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org,
        Asias He <asias@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Stefan Hajnoczi <stefanha@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] vhost/vsock: don't check owner in vhost_vsock_stop()
 while releasing
Message-ID: <20220221094829-mutt-send-email-mst@kernel.org>
References: <20220221114916.107045-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220221114916.107045-1-sgarzare@redhat.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 21, 2022 at 12:49:16PM +0100, Stefano Garzarella wrote:
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




> Fixes: 433fc58e6bf2 ("VSOCK: Introduce vhost_vsock.ko")
> Cc: stable@vger.kernel.org
> Reported-by: syzbot+1e3ea63db39f2b4440e0@syzkaller.appspotmail.com
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>  drivers/vhost/vsock.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> index d6ca1c7ad513..f00d2dfd72b7 100644
> --- a/drivers/vhost/vsock.c
> +++ b/drivers/vhost/vsock.c
> @@ -629,16 +629,18 @@ static int vhost_vsock_start(struct vhost_vsock *vsock)
>  	return ret;
>  }
>  
> -static int vhost_vsock_stop(struct vhost_vsock *vsock)
> +static int vhost_vsock_stop(struct vhost_vsock *vsock, bool check_owner)

>  {
>  	size_t i;
>  	int ret;
>  
>  	mutex_lock(&vsock->dev.mutex);
>  
> -	ret = vhost_dev_check_owner(&vsock->dev);
> -	if (ret)
> -		goto err;
> +	if (check_owner) {
> +		ret = vhost_dev_check_owner(&vsock->dev);
> +		if (ret)
> +			goto err;
> +	}
>  
>  	for (i = 0; i < ARRAY_SIZE(vsock->vqs); i++) {
>  		struct vhost_virtqueue *vq = &vsock->vqs[i];
> @@ -753,7 +755,7 @@ static int vhost_vsock_dev_release(struct inode *inode, struct file *file)
>  	 * inefficient.  Room for improvement here. */
>  	vsock_for_each_connected_socket(vhost_vsock_reset_orphans);
>  
> -	vhost_vsock_stop(vsock);

Let's add an explanation:

When invoked from release we can not fail so we don't
check return code of vhost_vsock_stop.
We need to stop vsock even if it's not the owner.

> +	vhost_vsock_stop(vsock, false);
>  	vhost_vsock_flush(vsock);
>  	vhost_dev_stop(&vsock->dev);
>  
> @@ -868,7 +870,7 @@ static long vhost_vsock_dev_ioctl(struct file *f, unsigned int ioctl,
>  		if (start)
>  			return vhost_vsock_start(vsock);
>  		else
> -			return vhost_vsock_stop(vsock);
> +			return vhost_vsock_stop(vsock, true);
>  	case VHOST_GET_FEATURES:
>  		features = VHOST_VSOCK_FEATURES;
>  		if (copy_to_user(argp, &features, sizeof(features)))
> -- 
> 2.35.1

