Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39360322AD6
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 13:54:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232450AbhBWMyI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 07:54:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:40651 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232210AbhBWMyH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 07:54:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614084760;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VpKnhF8xzE+xk7DZzBaL35pVUpraUP2Beq7jfgkgyxg=;
        b=RphS48IvCAlghY2WKVJ0rSf/Ii3dxRT1683P93JjwXTIv9x4+xKBDuCpvIPFxi1cYjg7Z3
        mrKTXGz/ja2ANu2nLYiKcDVrDB9OzbDkI7JK7VlP9Dqf3t8UPJNNel/nMXhG9Ge4xSYidu
        PPBOX/RXczzOE0Pf3Ta7gzfRyAGO/8Q=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-506-olYGbeE1OQy9f-sngN1AUA-1; Tue, 23 Feb 2021 07:52:38 -0500
X-MC-Unique: olYGbeE1OQy9f-sngN1AUA-1
Received: by mail-wr1-f71.google.com with SMTP id g5so3049730wrd.22
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 04:52:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VpKnhF8xzE+xk7DZzBaL35pVUpraUP2Beq7jfgkgyxg=;
        b=tHLzQSR9K2Tk2kKNmHRuJk/5mPa2dJVlQZeKHlnWC0leptCccMV+RvoVSnpZTGvv0W
         ACxgYDbNt1aMN/k940tiL8FbnyO937FJZSlD6Q0GEZ7rb2EYR3GX/H9GmFXElb6/kAlQ
         KJIw3aQVz2w1gfYs18TxYUCkSEII2XZAiGAmhHJZWIYAIUY+SvM4crUu9MuRqekSFrwP
         xGXNblw9hnUs0lD8+XZ+QL5utThQJJfobHFwVxbglwdKytn0cuKVlLUT9WSvQ8vRTsEe
         Nzo730xVccgXBrjQsuWdwUTIDAFC/L5ND/o0fPN9UL6JaVc3/yufMHOM1uhoEARFojUU
         lzBg==
X-Gm-Message-State: AOAM531FB24zIl62xPPcPvcXKHSxwR+ZnMpotedY3e5vY7oCjK7Y2bbI
        EwcMAnYF3Kq+Pq3uvtxVpvUHqzrGIaieKxKbXSrQR8+pgH1vsx26NX3zlXjkzS1xa8UVVanaaiF
        SnCy8kVa0mkOoRR5D
X-Received: by 2002:a05:600c:35c2:: with SMTP id r2mr23376666wmq.54.1614084757592;
        Tue, 23 Feb 2021 04:52:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzGEt76S1XmRrvr3buiAqZHZo63kQk76TRhwqBQKdNL6YEogoa1tLlZDqDWzOplA9TFvNjfQw==
X-Received: by 2002:a05:600c:35c2:: with SMTP id r2mr23376657wmq.54.1614084757390;
        Tue, 23 Feb 2021 04:52:37 -0800 (PST)
Received: from redhat.com (bzq-79-180-2-31.red.bezeqint.net. [79.180.2.31])
        by smtp.gmail.com with ESMTPSA id v18sm2777629wml.45.2021.02.23.04.52.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 04:52:36 -0800 (PST)
Date:   Tue, 23 Feb 2021 07:52:34 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Eli Cohen <elic@nvidia.com>
Cc:     jasowang@redhat.com, si-wei.liu@oracle.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Parav Pandit <parav@nvidia.com>
Subject: Re: [PATCH v2] vdpa/mlx5: Enable user to add/delete vdpa device
Message-ID: <20210223075211-mutt-send-email-mst@kernel.org>
References: <20210218074157.43220-1-elic@nvidia.com>
 <20210223072847-mutt-send-email-mst@kernel.org>
 <20210223123304.GA170700@mtl-vdi-166.wap.labs.mlnx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210223123304.GA170700@mtl-vdi-166.wap.labs.mlnx>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 23, 2021 at 02:33:04PM +0200, Eli Cohen wrote:
> On Tue, Feb 23, 2021 at 07:29:32AM -0500, Michael S. Tsirkin wrote:
> > On Thu, Feb 18, 2021 at 09:41:57AM +0200, Eli Cohen wrote:
> > > Allow to control vdpa device creation and destruction using the vdpa
> > > management tool.
> > > 
> > > Examples:
> > > 1. List the management devices
> > > $ vdpa mgmtdev show
> > > pci/0000:3b:00.1:
> > >   supported_classes net
> > > 
> > > 2. Create vdpa instance
> > > $ vdpa dev add mgmtdev pci/0000:3b:00.1 name vdpa0
> > > 
> > > 3. Show vdpa devices
> > > $ vdpa dev show
> > > vdpa0: type network mgmtdev pci/0000:3b:00.1 vendor_id 5555 max_vqs 16 \
> > > max_vq_size 256
> > > 
> > > Signed-off-by: Eli Cohen <elic@nvidia.com>
> > > Reviewed-by: Parav Pandit <parav@nvidia.com>
> > 
> > Not sure which tree this is for, I could not apply this.
> > 
> 
> Depends on Parav's vdpa tool patches. We'll send the entire series again
> - Parav's and my patches.


I think I have them in the linux next branch, no?


> > > ---
> > > v0->v1:
> > > set mgtdev->ndev NULL on dev delete
> > > v1->v2: Resend
> > > 
> > >  drivers/vdpa/mlx5/net/mlx5_vnet.c | 79 +++++++++++++++++++++++++++----
> > >  1 file changed, 70 insertions(+), 9 deletions(-)
> > > 
> > > diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > index a51b0f86afe2..08fb481ddc4f 100644
> > > --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > @@ -1974,23 +1974,32 @@ static void init_mvqs(struct mlx5_vdpa_net *ndev)
> > >  	}
> > >  }
> > >  
> > > -static int mlx5v_probe(struct auxiliary_device *adev,
> > > -		       const struct auxiliary_device_id *id)
> > > +struct mlx5_vdpa_mgmtdev {
> > > +	struct vdpa_mgmt_dev mgtdev;
> > > +	struct mlx5_adev *madev;
> > > +	struct mlx5_vdpa_net *ndev;
> > > +};
> > > +
> > > +static int mlx5_vdpa_dev_add(struct vdpa_mgmt_dev *v_mdev, const char *name)
> > >  {
> > > -	struct mlx5_adev *madev = container_of(adev, struct mlx5_adev, adev);
> > > -	struct mlx5_core_dev *mdev = madev->mdev;
> > > +	struct mlx5_vdpa_mgmtdev *mgtdev = container_of(v_mdev, struct mlx5_vdpa_mgmtdev, mgtdev);
> > >  	struct virtio_net_config *config;
> > >  	struct mlx5_vdpa_dev *mvdev;
> > >  	struct mlx5_vdpa_net *ndev;
> > > +	struct mlx5_core_dev *mdev;
> > >  	u32 max_vqs;
> > >  	int err;
> > >  
> > > +	if (mgtdev->ndev)
> > > +		return -ENOSPC;
> > > +
> > > +	mdev = mgtdev->madev->mdev;
> > >  	/* we save one virtqueue for control virtqueue should we require it */
> > >  	max_vqs = MLX5_CAP_DEV_VDPA_EMULATION(mdev, max_num_virtio_queues);
> > >  	max_vqs = min_t(u32, max_vqs, MLX5_MAX_SUPPORTED_VQS);
> > >  
> > >  	ndev = vdpa_alloc_device(struct mlx5_vdpa_net, mvdev.vdev, mdev->device, &mlx5_vdpa_ops,
> > > -				 2 * mlx5_vdpa_max_qps(max_vqs), NULL);
> > > +				 2 * mlx5_vdpa_max_qps(max_vqs), name);
> > >  	if (IS_ERR(ndev))
> > >  		return PTR_ERR(ndev);
> > >  
> > > @@ -2018,11 +2027,12 @@ static int mlx5v_probe(struct auxiliary_device *adev,
> > >  	if (err)
> > >  		goto err_res;
> > >  
> > > -	err = vdpa_register_device(&mvdev->vdev);
> > > +	mvdev->vdev.mdev = &mgtdev->mgtdev;
> > > +	err = _vdpa_register_device(&mvdev->vdev);
> > >  	if (err)
> > >  		goto err_reg;
> > >  
> > > -	dev_set_drvdata(&adev->dev, ndev);
> > > +	mgtdev->ndev = ndev;
> > >  	return 0;
> > >  
> > >  err_reg:
> > > @@ -2035,11 +2045,62 @@ static int mlx5v_probe(struct auxiliary_device *adev,
> > >  	return err;
> > >  }
> > >  
> > > +static void mlx5_vdpa_dev_del(struct vdpa_mgmt_dev *v_mdev, struct vdpa_device *dev)
> > > +{
> > > +	struct mlx5_vdpa_mgmtdev *mgtdev = container_of(v_mdev, struct mlx5_vdpa_mgmtdev, mgtdev);
> > > +
> > > +	_vdpa_unregister_device(dev);
> > > +	mgtdev->ndev = NULL;
> > > +}
> > > +
> > > +static const struct vdpa_mgmtdev_ops mdev_ops = {
> > > +	.dev_add = mlx5_vdpa_dev_add,
> > > +	.dev_del = mlx5_vdpa_dev_del,
> > > +};
> > > +
> > > +static struct virtio_device_id id_table[] = {
> > > +	{ VIRTIO_ID_NET, VIRTIO_DEV_ANY_ID },
> > > +	{ 0 },
> > > +};
> > > +
> > > +static int mlx5v_probe(struct auxiliary_device *adev,
> > > +		       const struct auxiliary_device_id *id)
> > > +
> > > +{
> > > +	struct mlx5_adev *madev = container_of(adev, struct mlx5_adev, adev);
> > > +	struct mlx5_core_dev *mdev = madev->mdev;
> > > +	struct mlx5_vdpa_mgmtdev *mgtdev;
> > > +	int err;
> > > +
> > > +	mgtdev = kzalloc(sizeof(*mgtdev), GFP_KERNEL);
> > > +	if (!mgtdev)
> > > +		return -ENOMEM;
> > > +
> > > +	mgtdev->mgtdev.ops = &mdev_ops;
> > > +	mgtdev->mgtdev.device = mdev->device;
> > > +	mgtdev->mgtdev.id_table = id_table;
> > > +	mgtdev->madev = madev;
> > > +
> > > +	err = vdpa_mgmtdev_register(&mgtdev->mgtdev);
> > > +	if (err)
> > > +		goto reg_err;
> > > +
> > > +	dev_set_drvdata(&adev->dev, mgtdev);
> > > +
> > > +	return 0;
> > > +
> > > +reg_err:
> > > +	kfree(mdev);
> > > +	return err;
> > > +}
> > > +
> > >  static void mlx5v_remove(struct auxiliary_device *adev)
> > >  {
> > > -	struct mlx5_vdpa_dev *mvdev = dev_get_drvdata(&adev->dev);
> > > +	struct mlx5_vdpa_mgmtdev *mgtdev;
> > >  
> > > -	vdpa_unregister_device(&mvdev->vdev);
> > > +	mgtdev = dev_get_drvdata(&adev->dev);
> > > +	vdpa_mgmtdev_unregister(&mgtdev->mgtdev);
> > > +	kfree(mgtdev);
> > >  }
> > >  
> > >  static const struct auxiliary_device_id mlx5v_id_table[] = {
> > > -- 
> > > 2.29.2
> > 

