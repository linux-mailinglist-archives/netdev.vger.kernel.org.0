Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D41A4A536D
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 00:41:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbiAaXlu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 18:41:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53262 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229678AbiAaXlt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 18:41:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643672509;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IsJZQuAnrZzrOSNtgUK/+418ygrBDiEFHYd4U7hkJP0=;
        b=jCmKBZiSRCm/THbgR4bi1a4cqX4iCS3vAtPXdOFbPE37wqHYe1ev6EfSwp+/4sEX+Z0l8X
        ZdGVTd1Zz0EZVTLM3cgupg8+L1gwapuUc0nURIHKWLQbnbqOwjMcoqNO3wtDYU/8ph2p7d
        JTbfa2h5CjD9V/S4flbd97p2YgsMk1M=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-502-XUIrAJ4bOBijf2ttDROPiQ-1; Mon, 31 Jan 2022 18:41:47 -0500
X-MC-Unique: XUIrAJ4bOBijf2ttDROPiQ-1
Received: by mail-ot1-f71.google.com with SMTP id x55-20020a05683040b700b005a08a3347ccso8784689ott.0
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 15:41:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IsJZQuAnrZzrOSNtgUK/+418ygrBDiEFHYd4U7hkJP0=;
        b=UB4oVWablunwZy1UlQBnOry4+P6zwlBy2Rk55EP7EEyWFuqQDoP/Omkr2Bp/4YG4Sb
         bAKKddmiMgfVDB4tYYwSLvnJRKoInS9ztVP8heREmqRXWknD0r7Mb7EdhxrCRFo9BDXd
         CnFrH+8/kzMr38o6m/kdFA/NuLXFyxvPujA9wbY3tYODnAuYbtBhXVf9D9YpjzylsRIX
         ppq07BK59miqZy8U6bbHGcSEI4wbIjrPpGjjy4sI6oeivbNOGil9DnvXsIrupYw7y5Vh
         +8zATdoCAA5jWZprWHkGp/NjkdlvzWEcM1w/wOxA/jIsunjRDDVMZg4bWDq2K3sCQnsx
         lkgg==
X-Gm-Message-State: AOAM532+79lC+YBvR9jocPIfM920Hj/joRMWNFuj9KXBpsIV+MFzox5l
        U2NwROM6ioIIrL90RYvhft1u10fKDaTACwJP0uyt+t4bRY/yQWxkr1VR0N6PTflLAZYP6pBKB4u
        4FlwtzRnoZ0xlTTp4
X-Received: by 2002:a05:6808:170c:: with SMTP id bc12mr18626111oib.171.1643672506955;
        Mon, 31 Jan 2022 15:41:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyh4qPDVhHYhJ+cdHNlNgk4ULx7R1+bmY3JDl6uPWenQ+Kn8B9uxAH1rlJjD/2b+rIpUxClBg==
X-Received: by 2002:a05:6808:170c:: with SMTP id bc12mr18626093oib.171.1643672506710;
        Mon, 31 Jan 2022 15:41:46 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id x1sm10661262oto.38.2022.01.31.15.41.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jan 2022 15:41:46 -0800 (PST)
Date:   Mon, 31 Jan 2022 16:41:43 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     <bhelgaas@google.com>, <jgg@nvidia.com>, <saeedm@nvidia.com>,
        <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>, <maorg@nvidia.com>
Subject: Re: [PATCH V6 mlx5-next 07/15] vfio: Have the core code decode the
 VFIO_DEVICE_FEATURE ioctl
Message-ID: <20220131164143.6c145fdb.alex.williamson@redhat.com>
In-Reply-To: <20220130160826.32449-8-yishaih@nvidia.com>
References: <20220130160826.32449-1-yishaih@nvidia.com>
        <20220130160826.32449-8-yishaih@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 30 Jan 2022 18:08:18 +0200
Yishai Hadas <yishaih@nvidia.com> wrote:

> From: Jason Gunthorpe <jgg@nvidia.com>
> 
> Invoke a new device op 'device_feature' to handle just the data array
> portion of the command. This lifts the ioctl validation to the core code
> and makes it simpler for either the core code, or layered drivers, to
> implement their own feature values.
> 
> Provide vfio_check_feature() to consolidate checking the flags/etc against
> what the driver supports.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_pci.c      |  1 +
>  drivers/vfio/pci/vfio_pci_core.c | 90 ++++++++++++--------------------
>  drivers/vfio/vfio.c              | 46 ++++++++++++++--
>  include/linux/vfio.h             | 32 ++++++++++++
>  include/linux/vfio_pci_core.h    |  2 +
>  5 files changed, 109 insertions(+), 62 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index a5ce92beb655..2b047469e02f 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -130,6 +130,7 @@ static const struct vfio_device_ops vfio_pci_ops = {
>  	.open_device	= vfio_pci_open_device,
>  	.close_device	= vfio_pci_core_close_device,
>  	.ioctl		= vfio_pci_core_ioctl,
> +	.device_feature = vfio_pci_core_ioctl_feature,
>  	.read		= vfio_pci_core_read,
>  	.write		= vfio_pci_core_write,
>  	.mmap		= vfio_pci_core_mmap,
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index f948e6cd2993..14a22ff20ef8 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -1114,70 +1114,44 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
>  
>  		return vfio_pci_ioeventfd(vdev, ioeventfd.offset,
>  					  ioeventfd.data, count, ioeventfd.fd);
> -	} else if (cmd == VFIO_DEVICE_FEATURE) {
> -		struct vfio_device_feature feature;
> -		uuid_t uuid;
> -
> -		minsz = offsetofend(struct vfio_device_feature, flags);
> -
> -		if (copy_from_user(&feature, (void __user *)arg, minsz))
> -			return -EFAULT;
> -
> -		if (feature.argsz < minsz)
> -			return -EINVAL;
> -
> -		/* Check unknown flags */
> -		if (feature.flags & ~(VFIO_DEVICE_FEATURE_MASK |
> -				      VFIO_DEVICE_FEATURE_SET |
> -				      VFIO_DEVICE_FEATURE_GET |
> -				      VFIO_DEVICE_FEATURE_PROBE))
> -			return -EINVAL;
> -
> -		/* GET & SET are mutually exclusive except with PROBE */
> -		if (!(feature.flags & VFIO_DEVICE_FEATURE_PROBE) &&
> -		    (feature.flags & VFIO_DEVICE_FEATURE_SET) &&
> -		    (feature.flags & VFIO_DEVICE_FEATURE_GET))
> -			return -EINVAL;
> -
> -		switch (feature.flags & VFIO_DEVICE_FEATURE_MASK) {
> -		case VFIO_DEVICE_FEATURE_PCI_VF_TOKEN:
> -			if (!vdev->vf_token)
> -				return -ENOTTY;
> -
> -			/*
> -			 * We do not support GET of the VF Token UUID as this
> -			 * could expose the token of the previous device user.
> -			 */
> -			if (feature.flags & VFIO_DEVICE_FEATURE_GET)
> -				return -EINVAL;
> -
> -			if (feature.flags & VFIO_DEVICE_FEATURE_PROBE)
> -				return 0;
> -
> -			/* Don't SET unless told to do so */
> -			if (!(feature.flags & VFIO_DEVICE_FEATURE_SET))
> -				return -EINVAL;
> +	}
> +	return -ENOTTY;
> +}
> +EXPORT_SYMBOL_GPL(vfio_pci_core_ioctl);
>  
> -			if (feature.argsz < minsz + sizeof(uuid))
> -				return -EINVAL;
> +int vfio_pci_core_ioctl_feature(struct vfio_device *device, u32 flags,
> +				void __user *arg, size_t argsz)
> +{
> +	struct vfio_pci_core_device *vdev =
> +		container_of(device, struct vfio_pci_core_device, vdev);
> +	uuid_t uuid;
> +	int ret;

Nit, should uuid at least be scoped within the token code?  Or token
code pushed to a separate function?

>  
> -			if (copy_from_user(&uuid, (void __user *)(arg + minsz),
> -					   sizeof(uuid)))
> -				return -EFAULT;
> +	switch (flags & VFIO_DEVICE_FEATURE_MASK) {
> +	case VFIO_DEVICE_FEATURE_PCI_VF_TOKEN:
> +		if (!vdev->vf_token)
> +			return -ENOTTY;
> +		/*
> +		 * We do not support GET of the VF Token UUID as this could
> +		 * expose the token of the previous device user.
> +		 */
> +		ret = vfio_check_feature(flags, argsz, VFIO_DEVICE_FEATURE_SET,
> +					sizeof(uuid));
> +		if (ret != 1)
> +			return ret;
>  
> -			mutex_lock(&vdev->vf_token->lock);
> -			uuid_copy(&vdev->vf_token->uuid, &uuid);
> -			mutex_unlock(&vdev->vf_token->lock);
> +		if (copy_from_user(&uuid, arg, sizeof(uuid)))
> +			return -EFAULT;
>  
> -			return 0;
> -		default:
> -			return -ENOTTY;
> -		}
> +		mutex_lock(&vdev->vf_token->lock);
> +		uuid_copy(&vdev->vf_token->uuid, &uuid);
> +		mutex_unlock(&vdev->vf_token->lock);
> +		return 0;
> +	default:
> +		return -ENOTTY;
>  	}
> -
> -	return -ENOTTY;
>  }
> -EXPORT_SYMBOL_GPL(vfio_pci_core_ioctl);
> +EXPORT_SYMBOL_GPL(vfio_pci_core_ioctl_feature);
...
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 76191d7abed1..ca69516f869d 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -55,6 +55,7 @@ struct vfio_device {
>   * @match: Optional device name match callback (return: 0 for no-match, >0 for
>   *         match, -errno for abort (ex. match with insufficient or incorrect
>   *         additional args)
> + * @device_feature: Fill in the VFIO_DEVICE_FEATURE ioctl
>   */
>  struct vfio_device_ops {
>  	char	*name;
> @@ -69,8 +70,39 @@ struct vfio_device_ops {
>  	int	(*mmap)(struct vfio_device *vdev, struct vm_area_struct *vma);
>  	void	(*request)(struct vfio_device *vdev, unsigned int count);
>  	int	(*match)(struct vfio_device *vdev, char *buf);
> +	int	(*device_feature)(struct vfio_device *device, u32 flags,
> +				  void __user *arg, size_t argsz);
>  };
>  
> +/**
> + * vfio_check_feature - Validate user input for the VFIO_DEVICE_FEATURE ioctl
> + * @flags: Arg from the device_feature op
> + * @argsz: Arg from the device_feature op
> + * @supported_ops: Combination of VFIO_DEVICE_FEATURE_GET and SET the driver
> + *                 supports
> + * @minsz: Minimum data size the driver accepts
> + *
> + * For use in a driver's device_feature op. Checks that the inputs to the
> + * VFIO_DEVICE_FEATURE ioctl are correct for the driver's feature. Returns 1 if
> + * the driver should execute the get or set, otherwise the relevant
> + * value should be returned.
> + */
> +static inline int vfio_check_feature(u32 flags, size_t argsz, u32 supported_ops,
> +				    size_t minsz)
> +{
> +	if ((flags & (VFIO_DEVICE_FEATURE_GET | VFIO_DEVICE_FEATURE_SET)) &
> +	    ~supported_ops)
> +		return -EINVAL;

These look like cases where it would be useful for userspace debugging
to differentiate errnos.

-EOPNOTSUPP?

> +	if (flags & VFIO_DEVICE_FEATURE_PROBE)
> +		return 0;
> +	/* Without PROBE one of GET or SET must be requested */
> +	if (!(flags & (VFIO_DEVICE_FEATURE_GET | VFIO_DEVICE_FEATURE_SET)))
> +		return -EINVAL;
> +	if (argsz < minsz)
> +		return -EINVAL;

-ENOSPC?

Thanks,
Alex

