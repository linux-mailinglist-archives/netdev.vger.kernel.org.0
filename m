Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57047321172
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 08:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbhBVHgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 02:36:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33769 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230022AbhBVHgK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 02:36:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613979283;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6FVHK+rXFWPhvTdgY3ca3NMaeJHpQu46VbcX/NLNp1o=;
        b=YOJc6VhrxPq6zMYAvv7o9fZW68kSUf9wwDwuFwqF9ID8/oscYz0fD/iCxw9X2o4lKzhsyw
        InM3CLsZd+1tdgns/8r6VHpFohtb8LuUxzvLUxI80OhNg5p6aBzLJZPVglgAqBTBYSzKob
        1pgiyuidy2zrLH6yTSAj5mt5N5XoNk4=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-511-JUNA_8iWOZ6Gyq0omCebTw-1; Mon, 22 Feb 2021 02:34:42 -0500
X-MC-Unique: JUNA_8iWOZ6Gyq0omCebTw-1
Received: by mail-ed1-f69.google.com with SMTP id g20so3951966edy.7
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 23:34:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=6FVHK+rXFWPhvTdgY3ca3NMaeJHpQu46VbcX/NLNp1o=;
        b=LPo+jsPoVd78h8+MO7m+0EVqQOTYSJUvkdrL3+xaGcgCZ6QW4Wht/x4TuRkmebsIbV
         tIsoNUaPaV84Pmyshq9GTl/wHDiELmhIy+pISeYx3UpICXoyo7ubjcbJh1K6hZe6ct2x
         VNrfPX0+zXHWubGpOMzy4emg1b0jeeqWqlZmWmsdaxHF1aikzL3UKLL2YXB2pUvdjdwW
         LjB7YlQkhjAHYuXAYkg2WoeGBTxiOsWCdgMIGhlDFQMQtv/70VYsilEPWQHkxGwrNfpt
         3TjRFzfv8anDQrmrEq+IoH99vKmlIi0Q77Szl88ccYzRLKi7wXDk+fgcuS/dQBY8vKAP
         1Ajg==
X-Gm-Message-State: AOAM533sa2fDeZlYXDatUfqu5OrwH369GbHb4h0HHyHPI1Un08Q1+aP+
        9+30zFxfUeZKYeoqCE5EjhDsv7P7fvwDzq8qE8Usk0eNF+mCx+RoR+QzXtzczdKEf+5EeDCE0jQ
        2oBRlXWYRXgABYAsE
X-Received: by 2002:a05:6402:3d8:: with SMTP id t24mr21009501edw.298.1613979280875;
        Sun, 21 Feb 2021 23:34:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxEzpKE3VGwXPIdtln/AiroN8FBRqHsg0v8D6hpM8GMEsbhJmhd1UQeVTsGMSLWYiL91843Cw==
X-Received: by 2002:a05:6402:3d8:: with SMTP id t24mr21009478edw.298.1613979280624;
        Sun, 21 Feb 2021 23:34:40 -0800 (PST)
Received: from redhat.com (bzq-79-180-2-31.red.bezeqint.net. [79.180.2.31])
        by smtp.gmail.com with ESMTPSA id m26sm4603396eja.6.2021.02.21.23.34.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Feb 2021 23:34:40 -0800 (PST)
Date:   Mon, 22 Feb 2021 02:34:37 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Si-Wei Liu <si-wei.liu@oracle.com>, elic@nvidia.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH] vdpa/mlx5: set_features should allow reset to zero
Message-ID: <20210222023040-mutt-send-email-mst@kernel.org>
References: <1613735698-3328-1-git-send-email-si-wei.liu@oracle.com>
 <605e7d2d-4f27-9688-17a8-d57191752ee7@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <605e7d2d-4f27-9688-17a8-d57191752ee7@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 22, 2021 at 12:14:17PM +0800, Jason Wang wrote:
> 
> On 2021/2/19 7:54 下午, Si-Wei Liu wrote:
> > Commit 452639a64ad8 ("vdpa: make sure set_features is invoked
> > for legacy") made an exception for legacy guests to reset
> > features to 0, when config space is accessed before features
> > are set. We should relieve the verify_min_features() check
> > and allow features reset to 0 for this case.
> > 
> > It's worth noting that not just legacy guests could access
> > config space before features are set. For instance, when
> > feature VIRTIO_NET_F_MTU is advertised some modern driver
> > will try to access and validate the MTU present in the config
> > space before virtio features are set.
> 
> 
> This looks like a spec violation:
> 
> "
> 
> The following driver-read-only field, mtu only exists if VIRTIO_NET_F_MTU is
> set.
> This field specifies the maximum MTU for the driver to use.
> "
> 
> Do we really want to workaround this?
> 
> Thanks

And also:

The driver MUST follow this sequence to initialize a device:
1. Reset the device.
2. Set the ACKNOWLEDGE status bit: the guest OS has noticed the device.
3. Set the DRIVER status bit: the guest OS knows how to drive the device.
4. Read device feature bits, and write the subset of feature bits understood by the OS and driver to the
device. During this step the driver MAY read (but MUST NOT write) the device-specific configuration
fields to check that it can support the device before accepting it.
5. Set the FEATURES_OK status bit. The driver MUST NOT accept new feature bits after this step.
6. Re-read device status to ensure the FEATURES_OK bit is still set: otherwise, the device does not
support our subset of features and the device is unusable.
7. Perform device-specific setup, including discovery of virtqueues for the device, optional per-bus setup,
reading and possibly writing the device’s virtio configuration space, and population of virtqueues.
8. Set the DRIVER_OK status bit. At this point the device is “live”.


so accessing config space before FEATURES_OK is a spec violation, right?


> 
> > Rejecting reset to 0
> > prematurely causes correct MTU and link status unable to load
> > for the very first config space access, rendering issues like
> > guest showing inaccurate MTU value, or failure to reject
> > out-of-range MTU.
> > 
> > Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 devices")
> > Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
> > ---
> >   drivers/vdpa/mlx5/net/mlx5_vnet.c | 15 +--------------
> >   1 file changed, 1 insertion(+), 14 deletions(-)
> > 
> > diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > index 7c1f789..540dd67 100644
> > --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > @@ -1490,14 +1490,6 @@ static u64 mlx5_vdpa_get_features(struct vdpa_device *vdev)
> >   	return mvdev->mlx_features;
> >   }
> > -static int verify_min_features(struct mlx5_vdpa_dev *mvdev, u64 features)
> > -{
> > -	if (!(features & BIT_ULL(VIRTIO_F_ACCESS_PLATFORM)))
> > -		return -EOPNOTSUPP;
> > -
> > -	return 0;
> > -}
> > -
> >   static int setup_virtqueues(struct mlx5_vdpa_net *ndev)
> >   {
> >   	int err;
> > @@ -1558,18 +1550,13 @@ static int mlx5_vdpa_set_features(struct vdpa_device *vdev, u64 features)
> >   {
> >   	struct mlx5_vdpa_dev *mvdev = to_mvdev(vdev);
> >   	struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
> > -	int err;
> >   	print_features(mvdev, features, true);
> > -	err = verify_min_features(mvdev, features);
> > -	if (err)
> > -		return err;
> > -
> >   	ndev->mvdev.actual_features = features & ndev->mvdev.mlx_features;
> >   	ndev->config.mtu = cpu_to_mlx5vdpa16(mvdev, ndev->mtu);
> >   	ndev->config.status |= cpu_to_mlx5vdpa16(mvdev, VIRTIO_NET_S_LINK_UP);
> > -	return err;
> > +	return 0;
> >   }
> >   static void mlx5_vdpa_set_config_cb(struct vdpa_device *vdev, struct vdpa_callback *cb)

