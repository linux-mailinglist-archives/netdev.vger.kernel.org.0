Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A01AC25F98C
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 13:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729108AbgIGLeh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 07:34:37 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:49858 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729005AbgIGLeL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 07:34:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599478450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=my7C9bnTqduGCO7MqL3mwZJ3lvwe6tTXAbKJeMeZpsw=;
        b=hd+d94Xd38d+vy6Jn3o9nBasqoEHOXvEo63LmHTairLG4MfidhVpWfXm9WSPkRkjmvSHuS
        m8efLBkWiw3alsNoW7tEi/sYUtV6mMRYrdmeuhaNoUuE+PBf2NX48IWYDzQrN2j69hSkOr
        gYsILNw9q4U2P4mk74Pxrr3KZjT5/7g=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-137-v2PNUHuFN1ixjyd29h-rOQ-1; Mon, 07 Sep 2020 07:34:09 -0400
X-MC-Unique: v2PNUHuFN1ixjyd29h-rOQ-1
Received: by mail-wm1-f70.google.com with SMTP id g79so4853878wmg.0
        for <netdev@vger.kernel.org>; Mon, 07 Sep 2020 04:34:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=my7C9bnTqduGCO7MqL3mwZJ3lvwe6tTXAbKJeMeZpsw=;
        b=oictfw3wAB8tLRG2MsEzD6goKoT/v79xTli5hlnWOTQ8mJP8TAToXcfWSRHzd6jvpt
         JYQSiSuS1nh+JFvDUMHF86bijZe3SmaMHAgycDmiYjwh5akbpCCsFBG+vIm/hUq6TKV5
         txY/GdiOGSUhAFhzpN8ZzhChZxGJYQvr8KQNSgDTLpXcptOrCIkEBjT7ImIEcJCT31CI
         SR8fgRWK7YbKSmnlQqCudWnOtMKID19RtDk0hIKceb3mO4tTTtiVD5RgNloHFPpki5zU
         0SkvpcWWCse0kNF5S9sY/jEz3in7DlfL6rddsoQiJ2nSE5n2GB38jOn55OFMY9vAuGqY
         MNBg==
X-Gm-Message-State: AOAM5302TsYYtZjWCXLWklf/F5noiVaLGZzTHEa2Xy4FcOURUfoa47Ya
        zEDL848Dkicc98FAtiQ/O8shsHoac9HJxlDObhApQJWRlHGtf7RBLkZYSYuDZcSEMApNDWeZ0mZ
        rFGVsav9iFl+rwNdY
X-Received: by 2002:a05:600c:1:: with SMTP id g1mr19389807wmc.57.1599478448524;
        Mon, 07 Sep 2020 04:34:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJylLFC0f0WrGm77BTxL4v95Dw1glpL5jHRTRjXWVbhHVzorqlr1MuKQVccvAMKh/KgK2Z+nNA==
X-Received: by 2002:a05:600c:1:: with SMTP id g1mr19389788wmc.57.1599478448324;
        Mon, 07 Sep 2020 04:34:08 -0700 (PDT)
Received: from redhat.com ([192.117.173.58])
        by smtp.gmail.com with ESMTPSA id r14sm28258858wrn.56.2020.09.07.04.34.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2020 04:34:07 -0700 (PDT)
Date:   Mon, 7 Sep 2020 07:34:00 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Eli Cohen <elic@nvidia.com>
Cc:     Jason Wang <jasowang@redhat.com>, Cindy Lu <lulu@redhat.com>,
        virtualization@lists.linux-foundation.org,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] vdpa/mlx5: Setup driver only if VIRTIO_CONFIG_S_DRIVER_OK
Message-ID: <20200907073319-mutt-send-email-mst@kernel.org>
References: <20200907075136.GA114876@mtl-vdi-166.wap.labs.mlnx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200907075136.GA114876@mtl-vdi-166.wap.labs.mlnx>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 07, 2020 at 10:51:36AM +0300, Eli Cohen wrote:
> If the memory map changes before the driver status is
> VIRTIO_CONFIG_S_DRIVER_OK, don't attempt to create resources because it
> may fail. For example, if the VQ is not ready there is no point in
> creating resources.
> 
> Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 devices")
> Signed-off-by: Eli Cohen <elic@nvidia.com>


Could you add a bit more data about the problem to the log?
To be more exact, what exactly happens right now?

> ---
>  drivers/vdpa/mlx5/net/mlx5_vnet.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> index 9df69d5efe8c..c89cd48a0aab 100644
> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> @@ -1645,6 +1645,9 @@ static int mlx5_vdpa_change_map(struct mlx5_vdpa_net *ndev, struct vhost_iotlb *
>  	if (err)
>  		goto err_mr;
>  
> +	if (!(ndev->mvdev.status & VIRTIO_CONFIG_S_DRIVER_OK))
> +		return 0;
> +
>  	restore_channels_info(ndev);
>  	err = setup_driver(ndev);
>  	if (err)
> -- 
> 2.26.0

