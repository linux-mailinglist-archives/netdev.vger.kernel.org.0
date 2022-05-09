Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C78C52039A
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 19:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239718AbiEIRdC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 13:33:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239662AbiEIRdB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 13:33:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CCB2E27F13F
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 10:29:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652117345;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YAaPwuIhuOIj3S+ua/Pq7rXl0IrKK5z92u9LkwzBcjU=;
        b=XJsD8AdEEJp9Ix5DwXUdSAd4PW9NoETpgqz4dOP8HboKZW67xA7oLCFPxksrzSsz4G9M71
        5+7reSSZfYJivoYJOKBlZhNyfxRAtlQv5aCWTuqTqcEDyKfMO0X24yAkGe1VhGp4deltkf
        fPDxv59pvmz15rF7omjgl2k1AeIZawc=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-25-7WwCelyEOqyfv20alFKfmw-1; Mon, 09 May 2022 13:29:04 -0400
X-MC-Unique: 7WwCelyEOqyfv20alFKfmw-1
Received: by mail-il1-f197.google.com with SMTP id g11-20020a056e021a2b00b002cf48b48824so7953535ile.21
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 10:29:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YAaPwuIhuOIj3S+ua/Pq7rXl0IrKK5z92u9LkwzBcjU=;
        b=YYX1slIm1fg2RNtACjS618flFTCDYyPZt5AK4DJbbJZNxId7Mz1ZAMtNWPDuBrQWQd
         ARKQHWfuFInTdbrot4gTluJl6P6oICF14lk329OYuhOteiKJxmZ4NTjPkjQdGljQKsjZ
         hK0300KSzFi1EZaG2KZmFit/fqzwYidqsgblwO9f3vSKaXU2kT7zkBg3ebH6hJLApd77
         3iC9qrG5Wyi4hZ17oINNaXnbCLLvUri6pEn9RVFFIla/VCh4RDExBthcnIsO6uZU8KYJ
         aWGvZzZLNCHpWKMqiCpoRcAwwufbV9m5jXRujyB3Cb16MHlB6m1T9vePD/XN4JbdROgZ
         fOeQ==
X-Gm-Message-State: AOAM532/EQYa7fQUYICEEIfooctV+gegLrKXQ1PBg8u2cXlr/i4BIyeF
        n49Lhq1s8r4nJQ887aOd8N8g0NDQei+MUlTROUTpMLAsEfvlgWkfktzCtFR9dsj4xpTTCq6CxYr
        nOMC4qJZepA48xb/X
X-Received: by 2002:a05:6e02:1a62:b0:2cf:5990:57ce with SMTP id w2-20020a056e021a6200b002cf599057cemr7136892ilv.275.1652117344024;
        Mon, 09 May 2022 10:29:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxNjAgSm+icCqcHehI3ihb6tELcKjLdun1j+AD/NdZT2Y59Hpb7xmkrgeWSiuNDXUYV6QDduA==
X-Received: by 2002:a05:6e02:1a62:b0:2cf:5990:57ce with SMTP id w2-20020a056e021a6200b002cf599057cemr7136885ilv.275.1652117343705;
        Mon, 09 May 2022 10:29:03 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id u3-20020a056638134300b0032b93db7422sm3758669jad.32.2022.05.09.10.29.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 10:29:03 -0700 (PDT)
Date:   Mon, 9 May 2022 11:29:01 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     <jgg@nvidia.com>, <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <maorg@nvidia.com>, <cohuck@redhat.com>
Subject: Re: [PATCH V1 mlx5-next 2/4] vfio/mlx5: Manage the VF attach/detach
 callback from the PF
Message-ID: <20220509112901.7ab66865.alex.williamson@redhat.com>
In-Reply-To: <20220508131053.241347-3-yishaih@nvidia.com>
References: <20220508131053.241347-1-yishaih@nvidia.com>
        <20220508131053.241347-3-yishaih@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 8 May 2022 16:10:51 +0300
Yishai Hadas <yishaih@nvidia.com> wrote:

> Manage the VF attach/detach callback from the PF.
> 
> This lets the driver to enable parallel VFs migration as will be
> introduced in the next patch.
> 
> As part of this, reorganize the VF is migratable code to be in a
> separate function and rename it to be set_migratable() to match its
> functionality.
> 
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/vfio/pci/mlx5/cmd.c  | 63 ++++++++++++++++++++++++++++++++++++
>  drivers/vfio/pci/mlx5/cmd.h  | 22 +++++++++++++
>  drivers/vfio/pci/mlx5/main.c | 40 ++++-------------------
>  3 files changed, 91 insertions(+), 34 deletions(-)
> 
> diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
> index 5c9f9218cc1d..5031978ae63a 100644
> --- a/drivers/vfio/pci/mlx5/cmd.c
> +++ b/drivers/vfio/pci/mlx5/cmd.c
> @@ -71,6 +71,69 @@ int mlx5vf_cmd_query_vhca_migration_state(struct pci_dev *pdev, u16 vhca_id,
>  	return ret;
>  }
>  
> +static int mlx5fv_vf_event(struct notifier_block *nb,
> +			   unsigned long event, void *data)
> +{
> +	struct mlx5vf_pci_core_device *mvdev =
> +		container_of(nb, struct mlx5vf_pci_core_device, nb);
> +
> +	mutex_lock(&mvdev->state_mutex);
> +	switch (event) {
> +	case MLX5_PF_NOTIFY_ENABLE_VF:
> +		mvdev->mdev_detach = false;
> +		break;
> +	case MLX5_PF_NOTIFY_DISABLE_VF:
> +		mvdev->mdev_detach = true;
> +		break;
> +	default:
> +		break;
> +	}
> +	mlx5vf_state_mutex_unlock(mvdev);
> +	return 0;
> +}
> +
> +void mlx5vf_cmd_remove_migratable(struct mlx5vf_pci_core_device *mvdev)
> +{
> +	mlx5_sriov_blocking_notifier_unregister(mvdev->mdev, mvdev->vf_id,
> +						&mvdev->nb);
> +}
> +
> +void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev)
> +{
> +	struct pci_dev *pdev = mvdev->core_device.pdev;
> +	int ret;
> +
> +	if (!pdev->is_virtfn)
> +		return;
> +
> +	mvdev->mdev = mlx5_vf_get_core_dev(pdev);
> +	if (!mvdev->mdev)
> +		return;
> +
> +	if (!MLX5_CAP_GEN(mvdev->mdev, migration))
> +		goto end;
> +
> +	mvdev->vf_id = pci_iov_vf_id(pdev);
> +	if (mvdev->vf_id < 0)
> +		goto end;
> +
> +	mutex_init(&mvdev->state_mutex);
> +	spin_lock_init(&mvdev->reset_lock);
> +	mvdev->nb.notifier_call = mlx5fv_vf_event;
> +	ret = mlx5_sriov_blocking_notifier_register(mvdev->mdev, mvdev->vf_id,
> +						    &mvdev->nb);
> +	if (ret)
> +		goto end;
> +
> +	mvdev->migrate_cap = 1;
> +	mvdev->core_device.vdev.migration_flags =
> +		VFIO_MIGRATION_STOP_COPY |
> +		VFIO_MIGRATION_P2P;
> +
> +end:
> +	mlx5_vf_put_core_dev(mvdev->mdev);
> +}
> +
>  int mlx5vf_cmd_get_vhca_id(struct pci_dev *pdev, u16 function_id, u16 *vhca_id)
>  {
>  	struct mlx5_core_dev *mdev = mlx5_vf_get_core_dev(pdev);
> diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
> index 1392a11a9cc0..340a06b98007 100644
> --- a/drivers/vfio/pci/mlx5/cmd.h
> +++ b/drivers/vfio/pci/mlx5/cmd.h
> @@ -7,6 +7,7 @@
>  #define MLX5_VFIO_CMD_H
>  
>  #include <linux/kernel.h>
> +#include <linux/vfio_pci_core.h>
>  #include <linux/mlx5/driver.h>
>  
>  struct mlx5_vf_migration_file {
> @@ -24,13 +25,34 @@ struct mlx5_vf_migration_file {
>  	unsigned long last_offset;
>  };
>  
> +struct mlx5vf_pci_core_device {
> +	struct vfio_pci_core_device core_device;
> +	int vf_id;
> +	u16 vhca_id;
> +	u8 migrate_cap:1;
> +	u8 deferred_reset:1;
> +	/* protect migration state */
> +	struct mutex state_mutex;
> +	enum vfio_device_mig_state mig_state;
> +	/* protect the reset_done flow */
> +	spinlock_t reset_lock;
> +	struct mlx5_vf_migration_file *resuming_migf;
> +	struct mlx5_vf_migration_file *saving_migf;
> +	struct notifier_block nb;
> +	struct mlx5_core_dev *mdev;
> +	u8 mdev_detach:1;


This should be packed with the other bit fields, there's plenty of
space there.


> +};
> +
>  int mlx5vf_cmd_suspend_vhca(struct pci_dev *pdev, u16 vhca_id, u16 op_mod);
>  int mlx5vf_cmd_resume_vhca(struct pci_dev *pdev, u16 vhca_id, u16 op_mod);
>  int mlx5vf_cmd_query_vhca_migration_state(struct pci_dev *pdev, u16 vhca_id,
>  					  size_t *state_size);
>  int mlx5vf_cmd_get_vhca_id(struct pci_dev *pdev, u16 function_id, u16 *vhca_id);
> +void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev);
> +void mlx5vf_cmd_remove_migratable(struct mlx5vf_pci_core_device *mvdev);
>  int mlx5vf_cmd_save_vhca_state(struct pci_dev *pdev, u16 vhca_id,
>  			       struct mlx5_vf_migration_file *migf);
>  int mlx5vf_cmd_load_vhca_state(struct pci_dev *pdev, u16 vhca_id,
>  			       struct mlx5_vf_migration_file *migf);
> +void mlx5vf_state_mutex_unlock(struct mlx5vf_pci_core_device *mvdev);
>  #endif /* MLX5_VFIO_CMD_H */
> diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
> index bbec5d288fee..9716c87e31f9 100644
> --- a/drivers/vfio/pci/mlx5/main.c
> +++ b/drivers/vfio/pci/mlx5/main.c
> @@ -17,7 +17,6 @@
>  #include <linux/uaccess.h>
>  #include <linux/vfio.h>
>  #include <linux/sched/mm.h>
> -#include <linux/vfio_pci_core.h>
>  #include <linux/anon_inodes.h>
>  
>  #include "cmd.h"
> @@ -25,20 +24,6 @@
>  /* Arbitrary to prevent userspace from consuming endless memory */
>  #define MAX_MIGRATION_SIZE (512*1024*1024)
>  
> -struct mlx5vf_pci_core_device {
> -	struct vfio_pci_core_device core_device;
> -	u16 vhca_id;
> -	u8 migrate_cap:1;
> -	u8 deferred_reset:1;
> -	/* protect migration state */
> -	struct mutex state_mutex;
> -	enum vfio_device_mig_state mig_state;
> -	/* protect the reset_done flow */
> -	spinlock_t reset_lock;
> -	struct mlx5_vf_migration_file *resuming_migf;
> -	struct mlx5_vf_migration_file *saving_migf;
> -};
> -
>  static struct page *
>  mlx5vf_get_migration_page(struct mlx5_vf_migration_file *migf,
>  			  unsigned long offset)
> @@ -444,7 +429,7 @@ mlx5vf_pci_step_device_state_locked(struct mlx5vf_pci_core_device *mvdev,
>   * This function is called in all state_mutex unlock cases to
>   * handle a 'deferred_reset' if exists.
>   */
> -static void mlx5vf_state_mutex_unlock(struct mlx5vf_pci_core_device *mvdev)
> +void mlx5vf_state_mutex_unlock(struct mlx5vf_pci_core_device *mvdev)
>  {
>  again:
>  	spin_lock(&mvdev->reset_lock);
> @@ -596,24 +581,7 @@ static int mlx5vf_pci_probe(struct pci_dev *pdev,
>  	if (!mvdev)
>  		return -ENOMEM;
>  	vfio_pci_core_init_device(&mvdev->core_device, pdev, &mlx5vf_pci_ops);
> -
> -	if (pdev->is_virtfn) {
> -		struct mlx5_core_dev *mdev =
> -			mlx5_vf_get_core_dev(pdev);
> -
> -		if (mdev) {
> -			if (MLX5_CAP_GEN(mdev, migration)) {
> -				mvdev->migrate_cap = 1;
> -				mvdev->core_device.vdev.migration_flags =
> -					VFIO_MIGRATION_STOP_COPY |
> -					VFIO_MIGRATION_P2P;
> -				mutex_init(&mvdev->state_mutex);
> -				spin_lock_init(&mvdev->reset_lock);
> -			}
> -			mlx5_vf_put_core_dev(mdev);
> -		}
> -	}
> -
> +	mlx5vf_cmd_set_migratable(mvdev);
>  	ret = vfio_pci_core_register_device(&mvdev->core_device);
>  	if (ret)
>  		goto out_free;
> @@ -622,6 +590,8 @@ static int mlx5vf_pci_probe(struct pci_dev *pdev,
>  	return 0;
>  
>  out_free:
> +	if (mvdev->migrate_cap)
> +		mlx5vf_cmd_remove_migratable(mvdev);
>  	vfio_pci_core_uninit_device(&mvdev->core_device);
>  	kfree(mvdev);
>  	return ret;
> @@ -632,6 +602,8 @@ static void mlx5vf_pci_remove(struct pci_dev *pdev)
>  	struct mlx5vf_pci_core_device *mvdev = dev_get_drvdata(&pdev->dev);
>  
>  	vfio_pci_core_unregister_device(&mvdev->core_device);
> +	if (mvdev->migrate_cap)
> +		mlx5vf_cmd_remove_migratable(mvdev);
>  	vfio_pci_core_uninit_device(&mvdev->core_device);
>  	kfree(mvdev);
>  }


Personally, I'd push the test into the function, ie.

void mlx5vf_cmd_remove_migratable(struct mlx5vf_pci_core_device *mvdev)
{
	if (!mvdev->migrate_cap)
		return;

	...
}

But it's clearly functional this way as well.  Please do fix the bit
field packing though.  Thanks,

Alex

