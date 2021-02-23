Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 595B43227D1
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 10:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232064AbhBWJaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 04:30:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21892 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232164AbhBWJ2I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 04:28:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614072401;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=h24RIBiBzWyvnGHMRqm0bjGav8NVJ5vrDg07fowU/yw=;
        b=ZC6lkMOpxJnwN3pLWVI27kgiiNiDFW5o4scAYhe1sHx+NCNqKANaQVQzqFK+B9lyOw0M/A
        13YBF/Ye/bry6OyCptaRAYDASjIGaZZePB27j8XiCD66j3bZodxIQTb33CD+V8YSsazAnX
        X9BnvndL/9z3CwvxFpe1eIl0DupaJjo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-529-YeM2kQoXP2CVJbx2iwzpUg-1; Tue, 23 Feb 2021 04:26:39 -0500
X-MC-Unique: YeM2kQoXP2CVJbx2iwzpUg-1
Received: by mail-wr1-f71.google.com with SMTP id g5so2848997wrd.22
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 01:26:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=h24RIBiBzWyvnGHMRqm0bjGav8NVJ5vrDg07fowU/yw=;
        b=n1l9QiyOF72njS7wbcQcgAKDCv7Yh4X/mIFrVmJ4EcXNKDKiSchJkFzxf9i1k3u9+j
         jyP2L3mSkhY2ty0HzCKleOg/31WtQ2wRwMb98GkIIY4/1JALvXwWh/9VAzWGnySYkHca
         Aw8nq3siV8VzY7Lob4eq5th2tZdTZ4jGY7jxn43EXkAGygyc5c8gQ9Ujkn5aG2ISmpyt
         WUfA9BvxXsipIqKEb/dR8ZBwH/usbAJSz8tWNp4vsBo5jMMCXx3s3V2+tL3WfY7ViFr2
         gz3SVpWR0M9qMQmv11StW8mqO6/7lvxpguwpKrA4A34lD17OGGwVZT6e4aWIaz1g39on
         ycag==
X-Gm-Message-State: AOAM533fU9MuDKplbMdXLbmA02FGQN7AXshZ32vpnnThbK6Yx7558iTB
        RBgUMmViGDuxmO7dDUjOvKvvTqhs0YwpebBm6hIRds2leYnHYNdBz6Pdaeqz4uXxf3vRm0Rxznq
        YgZ+I8bLxgIx7uNr5
X-Received: by 2002:a5d:5910:: with SMTP id v16mr25412077wrd.304.1614072398474;
        Tue, 23 Feb 2021 01:26:38 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwpG+IjMBMskIS3JIko3wZp10Ib6ahzykLv4bI1e1go9h9Q19lzcgRxEOLog/5XNrwEUBFFxQ==
X-Received: by 2002:a5d:5910:: with SMTP id v16mr25412068wrd.304.1614072398336;
        Tue, 23 Feb 2021 01:26:38 -0800 (PST)
Received: from redhat.com (bzq-79-180-2-31.red.bezeqint.net. [79.180.2.31])
        by smtp.gmail.com with ESMTPSA id 36sm33421735wrj.97.2021.02.23.01.26.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 01:26:37 -0800 (PST)
Date:   Tue, 23 Feb 2021 04:26:35 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Eli Cohen <elic@nvidia.com>
Cc:     Si-Wei Liu <si-wei.liu@oracle.com>, jasowang@redhat.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH] vdpa/mlx5: set_features should allow reset to zero
Message-ID: <20210223042559-mutt-send-email-mst@kernel.org>
References: <1613735698-3328-1-git-send-email-si-wei.liu@oracle.com>
 <20210221144437.GA82010@mtl-vdi-166.wap.labs.mlnx>
 <20210221165047-mutt-send-email-mst@kernel.org>
 <20210222060526.GA110862@mtl-vdi-166.wap.labs.mlnx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210222060526.GA110862@mtl-vdi-166.wap.labs.mlnx>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 22, 2021 at 08:05:26AM +0200, Eli Cohen wrote:
> On Sun, Feb 21, 2021 at 04:52:05PM -0500, Michael S. Tsirkin wrote:
> > On Sun, Feb 21, 2021 at 04:44:37PM +0200, Eli Cohen wrote:
> > > On Fri, Feb 19, 2021 at 06:54:58AM -0500, Si-Wei Liu wrote:
> > > > Commit 452639a64ad8 ("vdpa: make sure set_features is invoked
> > > > for legacy") made an exception for legacy guests to reset
> > > > features to 0, when config space is accessed before features
> > > > are set. We should relieve the verify_min_features() check
> > > > and allow features reset to 0 for this case.
> > > > 
> > > > It's worth noting that not just legacy guests could access
> > > > config space before features are set. For instance, when
> > > > feature VIRTIO_NET_F_MTU is advertised some modern driver
> > > > will try to access and validate the MTU present in the config
> > > > space before virtio features are set. Rejecting reset to 0
> > > > prematurely causes correct MTU and link status unable to load
> > > > for the very first config space access, rendering issues like
> > > > guest showing inaccurate MTU value, or failure to reject
> > > > out-of-range MTU.
> > > > 
> > > > Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 devices")
> > > > Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
> > > > ---
> > > >  drivers/vdpa/mlx5/net/mlx5_vnet.c | 15 +--------------
> > > >  1 file changed, 1 insertion(+), 14 deletions(-)
> > > > 
> > > > diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > > index 7c1f789..540dd67 100644
> > > > --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > > +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > > @@ -1490,14 +1490,6 @@ static u64 mlx5_vdpa_get_features(struct vdpa_device *vdev)
> > > >  	return mvdev->mlx_features;
> > > >  }
> > > >  
> > > > -static int verify_min_features(struct mlx5_vdpa_dev *mvdev, u64 features)
> > > > -{
> > > > -	if (!(features & BIT_ULL(VIRTIO_F_ACCESS_PLATFORM)))
> > > > -		return -EOPNOTSUPP;
> > > > -
> > > > -	return 0;
> > > > -}
> > > > -
> > > 
> > > But what if VIRTIO_F_ACCESS_PLATFORM is not offerred? This does not
> > > support such cases.
> > 
> > Did you mean "catch such cases" rather than "support"?
> > 
> 
> Actually I meant this driver/device does not support such cases.

Well the removed code merely failed without VIRTIO_F_ACCESS_PLATFORM
it didn't actually try to support anything ...

> > 
> > > Maybe we should call verify_min_features() from mlx5_vdpa_set_status()
> > > just before attempting to call setup_driver().
> > > 
> > > >  static int setup_virtqueues(struct mlx5_vdpa_net *ndev)
> > > >  {
> > > >  	int err;
> > > > @@ -1558,18 +1550,13 @@ static int mlx5_vdpa_set_features(struct vdpa_device *vdev, u64 features)
> > > >  {
> > > >  	struct mlx5_vdpa_dev *mvdev = to_mvdev(vdev);
> > > >  	struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
> > > > -	int err;
> > > >  
> > > >  	print_features(mvdev, features, true);
> > > >  
> > > > -	err = verify_min_features(mvdev, features);
> > > > -	if (err)
> > > > -		return err;
> > > > -
> > > >  	ndev->mvdev.actual_features = features & ndev->mvdev.mlx_features;
> > > >  	ndev->config.mtu = cpu_to_mlx5vdpa16(mvdev, ndev->mtu);
> > > >  	ndev->config.status |= cpu_to_mlx5vdpa16(mvdev, VIRTIO_NET_S_LINK_UP);
> > > > -	return err;
> > > > +	return 0;
> > > >  }
> > > >  
> > > >  static void mlx5_vdpa_set_config_cb(struct vdpa_device *vdev, struct vdpa_callback *cb)
> > > > -- 
> > > > 1.8.3.1
> > > > 
> > 

