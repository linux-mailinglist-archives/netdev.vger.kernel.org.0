Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA54543BDB3
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 01:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231948AbhJZXTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 19:19:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39566 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240216AbhJZXTM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 19:19:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635290208;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sHa+eLMZtXxhRGGVtp2qH+0qlLckFjrLAPT8DfDOLD8=;
        b=OI6TnWLw6Jps4OsxH4I0jIRRqKxz7APin3BJrHqdAODpFIhx6ozIIOu0WNqA0iunyzbsVi
        G0JWKgsJw5L+eE7qzRnqaOuciCQuNxvG57Me4e5qF5XRMM9MgaMPL3TWaKRfm5HVmRy6SH
        YO82dM5v91v+zboqpwyQQ7TCgMmZLho=
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
 [209.85.161.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-549-zNVlAQtKNJeOcNQHEoXcDw-1; Tue, 26 Oct 2021 19:16:46 -0400
X-MC-Unique: zNVlAQtKNJeOcNQHEoXcDw-1
Received: by mail-oo1-f69.google.com with SMTP id i25-20020a4ad399000000b002b85e3dd7d5so415493oos.2
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 16:16:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sHa+eLMZtXxhRGGVtp2qH+0qlLckFjrLAPT8DfDOLD8=;
        b=7F3xTP2jIucBTqOvHGUI/3DbZ4Ttnl4oqP5/8AyAzo6ZTRte3jj1IY9rCxY97vDK1i
         jpMXv80BBYYZ8nyKOIFcoJYPdGqiYAI9VnPaXCd+HXcOebZPP0hG9yLRtLOVOro5km7z
         0eFDiW6/s42zGtEjh2olObhOOIqFpo52uSnx6hINWykcKEWZG45zxo74PBs0VrncO1+5
         OI24OX533U+s/fqaMyZ6LaiyiKC3N/WO2hJXyYLd9mxxPZjNkFK9q5anLj+vOOlNod6G
         ULVz5zDxTH0CQijAqgXnsIL2ewy0YYDMQHQBnzL4VU0fj3PaQVhfcsMA/GDjUnN4HPMs
         6WkQ==
X-Gm-Message-State: AOAM531B8/BN4BejMlZCfUtwbkuCbBCFh0scjgED2ycc11xFpiwi+KHI
        PuKxrbkIpN2VOy9cWPMRUjNdEafBSYVDoUsn1y3JfgTBFZEHGM+oM9cYaynZDyEBa9yyZhHLuz8
        rGUmbCLxjtqANkMH9
X-Received: by 2002:a05:6808:2217:: with SMTP id bd23mr1278893oib.175.1635290205970;
        Tue, 26 Oct 2021 16:16:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyqvmHfiT4YSTufLF8iMK4o6Ez+q3fllqQ6Qjs8MU+3DMnMVBnFgYwtO9abT6zQuW9ndIGwsw==
X-Received: by 2002:a05:6808:2217:: with SMTP id bd23mr1278871oib.175.1635290205669;
        Tue, 26 Oct 2021 16:16:45 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id n187sm4987049oif.52.2021.10.26.16.16.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 16:16:45 -0700 (PDT)
Date:   Tue, 26 Oct 2021 17:16:44 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     <bhelgaas@google.com>, <jgg@nvidia.com>, <saeedm@nvidia.com>,
        <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>, <maorg@nvidia.com>
Subject: Re: [PATCH V4 mlx5-next 13/13] vfio/mlx5: Use its own PCI
 reset_done error handler
Message-ID: <20211026171644.41019161.alex.williamson@redhat.com>
In-Reply-To: <20211026090605.91646-14-yishaih@nvidia.com>
References: <20211026090605.91646-1-yishaih@nvidia.com>
        <20211026090605.91646-14-yishaih@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Oct 2021 12:06:05 +0300
Yishai Hadas <yishaih@nvidia.com> wrote:

> Register its own handler for pci_error_handlers.reset_done and update
> state accordingly.
> 
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/vfio/pci/mlx5/main.c | 54 ++++++++++++++++++++++++++++++++++--
>  1 file changed, 52 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
> index 4b21b388dcc5..c157f540d384 100644
> --- a/drivers/vfio/pci/mlx5/main.c
> +++ b/drivers/vfio/pci/mlx5/main.c
> @@ -55,8 +55,11 @@ struct mlx5vf_pci_migration_info {
>  struct mlx5vf_pci_core_device {
>  	struct vfio_pci_core_device core_device;
>  	u8 migrate_cap:1;
> +	u8 defered_reset:1;

s/defered/deferred/ throughout

>  	/* protect migration state */
>  	struct mutex state_mutex;
> +	/* protect the reset_done flow */
> +	spinlock_t reset_lock;
>  	struct mlx5vf_pci_migration_info vmig;
>  };
>  
> @@ -471,6 +474,47 @@ mlx5vf_pci_migration_data_rw(struct mlx5vf_pci_core_device *mvdev,
>  	return count;
>  }
>  
> +/* This function is called in all state_mutex unlock cases to
> + * handle a 'defered_reset' if exists.
> + */

I refrained from noting it elsewhere, but we're not in net/ or
drivers/net/ here, but we're using their multi-line comment style.  Are
we using the strong relation to a driver that does belong there as
justification for the style here?

> +static void mlx5vf_state_mutex_unlock(struct mlx5vf_pci_core_device *mvdev)
> +{
> +again:
> +	spin_lock(&mvdev->reset_lock);
> +	if (mvdev->defered_reset) {
> +		mvdev->defered_reset = false;
> +		spin_unlock(&mvdev->reset_lock);
> +		mlx5vf_reset_mig_state(mvdev);
> +		mvdev->vmig.vfio_dev_state = VFIO_DEVICE_STATE_RUNNING;
> +		goto again;
> +	}
> +	mutex_unlock(&mvdev->state_mutex);
> +	spin_unlock(&mvdev->reset_lock);
> +}
> +
> +static void mlx5vf_pci_aer_reset_done(struct pci_dev *pdev)
> +{
> +	struct mlx5vf_pci_core_device *mvdev = dev_get_drvdata(&pdev->dev);
> +
> +	if (!mvdev->migrate_cap)
> +		return;
> +
> +	/* As the higher VFIO layers are holding locks across reset and using
> +	 * those same locks with the mm_lock we need to prevent ABBA deadlock
> +	 * with the state_mutex and mm_lock.
> +	 * In case the state_mutex was taken alreday we differ the cleanup work

s/alreday/already/  s/differ/defer/ 

> +	 * to the unlock flow of the other running context.
> +	 */
> +	spin_lock(&mvdev->reset_lock);
> +	mvdev->defered_reset = true;
> +	if (!mutex_trylock(&mvdev->state_mutex)) {
> +		spin_unlock(&mvdev->reset_lock);
> +		return;
> +	}
> +	spin_unlock(&mvdev->reset_lock);
> +	mlx5vf_state_mutex_unlock(mvdev);
> +}
> +
>  static ssize_t mlx5vf_pci_mig_rw(struct vfio_pci_core_device *vdev,
>  				 char __user *buf, size_t count, loff_t *ppos,
>  				 bool iswrite)
> @@ -539,7 +583,7 @@ static ssize_t mlx5vf_pci_mig_rw(struct vfio_pci_core_device *vdev,
>  	}
>  
>  end:
> -	mutex_unlock(&mvdev->state_mutex);
> +	mlx5vf_state_mutex_unlock(mvdev);

I'm a little lost here, if the operation was to read the device_state
and mvdev->vmig.vfio_dev_state was error, that's already been copied to
the user buffer, so the user continues to see the error state for the
first read of device_state after reset if they encounter this race?
Thanks,

Alex

>  	return ret;
>  }
>  
> @@ -634,6 +678,7 @@ static int mlx5vf_pci_probe(struct pci_dev *pdev,
>  			if (MLX5_CAP_GEN(mdev, migration)) {
>  				mvdev->migrate_cap = 1;
>  				mutex_init(&mvdev->state_mutex);
> +				spin_lock_init(&mvdev->reset_lock);
>  			}
>  			mlx5_vf_put_core_dev(mdev);
>  		}
> @@ -668,12 +713,17 @@ static const struct pci_device_id mlx5vf_pci_table[] = {
>  
>  MODULE_DEVICE_TABLE(pci, mlx5vf_pci_table);
>  
> +const struct pci_error_handlers mlx5vf_err_handlers = {
> +	.reset_done = mlx5vf_pci_aer_reset_done,
> +	.error_detected = vfio_pci_aer_err_detected,
> +};
> +
>  static struct pci_driver mlx5vf_pci_driver = {
>  	.name = KBUILD_MODNAME,
>  	.id_table = mlx5vf_pci_table,
>  	.probe = mlx5vf_pci_probe,
>  	.remove = mlx5vf_pci_remove,
> -	.err_handler = &vfio_pci_core_err_handlers,
> +	.err_handler = &mlx5vf_err_handlers,
>  };
>  
>  static void __exit mlx5vf_pci_cleanup(void)

