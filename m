Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15C386B0FCB
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 18:06:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbjCHRGj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 12:06:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbjCHRG3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 12:06:29 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 968D0B1A45;
        Wed,  8 Mar 2023 09:06:11 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id m25-20020a7bcb99000000b003e7842b75f2so1584228wmi.3;
        Wed, 08 Mar 2023 09:06:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678295170;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jxjOeoSJYZftjCsyIDR0MxAv/SG7UzlBkygO1Kd0d3M=;
        b=IlLYy4C9hZ+GmRwp3m8Vllwil64S9X++Cd3MUCc4RqHkpLbUutHkTNSTcpqWZg5CC1
         FSSr55202Std7DjYSrNePuo+Fl2Y1LZhAdcbkGO7vjQ52g0HxBemX7R2ANTr2+4zZ/vk
         RlQClzUw86fBk8pJJEycaYGBSrJxxL7/Qkee0UjM/FNF5vpmjppCKhazJakdqyLPODaQ
         DyDgRSjWzvk218OSPjAoamhokzxxyOEQyT3g5lkmWwy0yKHIQzFaErvy4oU0pLXloixm
         5jQ1ArUOTShgWyxcT9DGjjkp2aAepBax7Uef8CdIRcmOrLY7l0iGIjFpHG8eKWguAreV
         oTNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678295170;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jxjOeoSJYZftjCsyIDR0MxAv/SG7UzlBkygO1Kd0d3M=;
        b=V48BBsmMSQqQRWkQdM2d8yX0pSJjhbmIf+25s4y3Tqe3YhtYPTXLSEQSalY/T4hgFb
         4Dz3mTS5PkKk2T118seDsbKg1lTiRkWM2SYWzc5ZwDZJ53ePJW5QCbqOrTW5bC60NJw5
         6AFbm6Uq4l0WPRI0wFz7GWdvJV06yeuIdq/qgs2Te4VYIpGt0ad+c0lpWDq/lyNSGK52
         MystqbaQOdMolMXNUS4sBpM0tGnctC7JS4tN4YeZrnuBAggDLcRpdnU5jrJC57T9Hgyf
         j5Kc9bxpmRz6kqAWGlyVS207Fp/MymixVWsrXMB5fO+/0+VxBMgh5ziz90UI2zkSd0OP
         wjoQ==
X-Gm-Message-State: AO0yUKUli71ryBacyfSN0UkOQZ0SM/sdNlrfI/THXZ8ZxSDp5EPHfScH
        RSkljjwV8wff4iOWXfCyBJrLUVOnYJ4=
X-Google-Smtp-Source: AK7set8NIgpFPbRvFUEqOTUDR4RxtvfYyIAefw7y5eZdDMQIr7V8onbteUNxPD4jrceTM4j5zQ4Nhw==
X-Received: by 2002:a05:600c:5123:b0:3ea:ecc2:daab with SMTP id o35-20020a05600c512300b003eaecc2daabmr18182819wms.3.1678295169674;
        Wed, 08 Mar 2023 09:06:09 -0800 (PST)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id d1-20020a5d4f81000000b002c54e26bca5sm15627158wru.49.2023.03.08.09.06.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 09:06:09 -0800 (PST)
Date:   Wed, 8 Mar 2023 17:06:06 +0000
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     Gautam Dawar <gautam.dawar@amd.com>
Cc:     linux-net-drivers@amd.com, jasowang@redhat.com,
        Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        eperezma@redhat.com, harpreet.anand@amd.com, tanuj.kamde@amd.com,
        koushik.dutta@amd.com
Subject: Re: [PATCH net-next v2 08/14] sfc: implement vdpa vring config
 operations
Message-ID: <ZAjAfoWwgVxsndgD@gmail.com>
Mail-Followup-To: Gautam Dawar <gautam.dawar@amd.com>,
        linux-net-drivers@amd.com, jasowang@redhat.com,
        Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        eperezma@redhat.com, harpreet.anand@amd.com, tanuj.kamde@amd.com,
        koushik.dutta@amd.com
References: <20230307113621.64153-1-gautam.dawar@amd.com>
 <20230307113621.64153-9-gautam.dawar@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230307113621.64153-9-gautam.dawar@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 07, 2023 at 05:06:10PM +0530, Gautam Dawar wrote:
> This patch implements the vDPA config operations related to
> virtqueues or vrings. These include setting vring address,
> getting vq state, operations to enable/disable a vq etc.
> The resources required for vring operations eg. VI, interrupts etc.
> are also allocated.
> 
> Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
> ---
>  drivers/net/ethernet/sfc/ef100_vdpa.c     |  46 +++-
>  drivers/net/ethernet/sfc/ef100_vdpa.h     |  54 +++++
>  drivers/net/ethernet/sfc/ef100_vdpa_ops.c | 275 ++++++++++++++++++++++
>  3 files changed, 374 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.c b/drivers/net/ethernet/sfc/ef100_vdpa.c
> index 4c5a98c9d6c3..c66e5aef69ea 100644
> --- a/drivers/net/ethernet/sfc/ef100_vdpa.c
> +++ b/drivers/net/ethernet/sfc/ef100_vdpa.c
> @@ -14,6 +14,7 @@
>  #include "ef100_vdpa.h"
>  #include "mcdi_vdpa.h"
>  #include "mcdi_filters.h"
> +#include "mcdi_functions.h"
>  #include "ef100_netdev.h"
>  
>  static struct virtio_device_id ef100_vdpa_id_table[] = {
> @@ -47,12 +48,31 @@ int ef100_vdpa_init(struct efx_probe_data *probe_data)
>  	return rc;
>  }
>  
> +static int vdpa_allocate_vis(struct efx_nic *efx, unsigned int *allocated_vis)
> +{
> +	/* The first VI is reserved for MCDI
> +	 * 1 VI each for rx + tx ring
> +	 */
> +	unsigned int max_vis = 1 + EF100_VDPA_MAX_QUEUES_PAIRS;
> +	unsigned int min_vis = 1 + 1;
> +	int rc;
> +
> +	rc = efx_mcdi_alloc_vis(efx, min_vis, max_vis,
> +				NULL, allocated_vis);
> +	if (!rc)
> +		return rc;
> +	if (*allocated_vis < min_vis)
> +		return -ENOSPC;
> +	return 0;
> +}
> +
>  static void ef100_vdpa_delete(struct efx_nic *efx)
>  {
>  	if (efx->vdpa_nic) {
>  		/* replace with _vdpa_unregister_device later */
>  		put_device(&efx->vdpa_nic->vdpa_dev.dev);
>  	}
> +	efx_mcdi_free_vis(efx);
>  }
>  
>  void ef100_vdpa_fini(struct efx_probe_data *probe_data)
> @@ -104,9 +124,19 @@ static struct ef100_vdpa_nic *ef100_vdpa_create(struct efx_nic *efx,
>  {
>  	struct ef100_nic_data *nic_data = efx->nic_data;
>  	struct ef100_vdpa_nic *vdpa_nic;
> +	unsigned int allocated_vis;
>  	int rc;
> +	u8 i;
>  
>  	nic_data->vdpa_class = dev_type;
> +	rc = vdpa_allocate_vis(efx, &allocated_vis);
> +	if (rc) {
> +		pci_err(efx->pci_dev,
> +			"%s Alloc VIs failed for vf:%u error:%d\n",
> +			 __func__, nic_data->vf_index, rc);
> +		return ERR_PTR(rc);
> +	}
> +
>  	vdpa_nic = vdpa_alloc_device(struct ef100_vdpa_nic,
>  				     vdpa_dev, &efx->pci_dev->dev,
>  				     &ef100_vdpa_config_ops,
> @@ -117,7 +147,8 @@ static struct ef100_vdpa_nic *ef100_vdpa_create(struct efx_nic *efx,
>  			"vDPA device allocation failed for vf: %u\n",
>  			nic_data->vf_index);
>  		nic_data->vdpa_class = EF100_VDPA_CLASS_NONE;
> -		return ERR_PTR(-ENOMEM);
> +		rc = -ENOMEM;
> +		goto err_alloc_vis_free;
>  	}
>  
>  	mutex_init(&vdpa_nic->lock);
> @@ -125,11 +156,21 @@ static struct ef100_vdpa_nic *ef100_vdpa_create(struct efx_nic *efx,
>  	vdpa_nic->vdpa_dev.dma_dev = &efx->pci_dev->dev;
>  	vdpa_nic->vdpa_dev.mdev = efx->mgmt_dev;
>  	vdpa_nic->efx = efx;
> +	vdpa_nic->max_queue_pairs = allocated_vis - 1;
>  	vdpa_nic->pf_index = nic_data->pf_index;
>  	vdpa_nic->vf_index = nic_data->vf_index;
>  	vdpa_nic->vdpa_state = EF100_VDPA_STATE_INITIALIZED;
>  	vdpa_nic->mac_address = (u8 *)&vdpa_nic->net_config.mac;
>  
> +	for (i = 0; i < (2 * vdpa_nic->max_queue_pairs); i++) {
> +		rc = ef100_vdpa_init_vring(vdpa_nic, i);
> +		if (rc) {
> +			pci_err(efx->pci_dev,
> +				"vring init idx: %u failed, rc: %d\n", i, rc);
> +			goto err_put_device;
> +		}
> +	}
> +
>  	rc = get_net_config(vdpa_nic);
>  	if (rc)
>  		goto err_put_device;
> @@ -146,6 +187,9 @@ static struct ef100_vdpa_nic *ef100_vdpa_create(struct efx_nic *efx,
>  err_put_device:
>  	/* put_device invokes ef100_vdpa_free */
>  	put_device(&vdpa_nic->vdpa_dev.dev);
> +
> +err_alloc_vis_free:
> +	efx_mcdi_free_vis(efx);
>  	return ERR_PTR(rc);
>  }
>  
> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.h b/drivers/net/ethernet/sfc/ef100_vdpa.h
> index dcf4a8156415..348ca8a7404b 100644
> --- a/drivers/net/ethernet/sfc/ef100_vdpa.h
> +++ b/drivers/net/ethernet/sfc/ef100_vdpa.h
> @@ -32,6 +32,21 @@
>  /* Alignment requirement of the Virtqueue */
>  #define EF100_VDPA_VQ_ALIGN 4096
>  
> +/* Vring configuration definitions */
> +#define EF100_VRING_ADDRESS_CONFIGURED 0x1
> +#define EF100_VRING_SIZE_CONFIGURED 0x10
> +#define EF100_VRING_READY_CONFIGURED 0x100
> +#define EF100_VRING_CONFIGURED (EF100_VRING_ADDRESS_CONFIGURED | \
> +				EF100_VRING_SIZE_CONFIGURED | \
> +				EF100_VRING_READY_CONFIGURED)
> +#define EF100_VRING_CREATED 0x1000

I only see these defines used a bit masks. So why skip all the bits
in stead of using 0x2, 0x4, 0x8 respectively?

Martin

> +
> +/* Maximum size of msix name */
> +#define EF100_VDPA_MAX_MSIX_NAME_SIZE 256
> +
> +/* Default high IOVA for MCDI buffer */
> +#define EF100_VDPA_IOVA_BASE_ADDR 0x20000000000
> +
>  /**
>   * enum ef100_vdpa_nic_state - possible states for a vDPA NIC
>   *
> @@ -57,6 +72,41 @@ enum ef100_vdpa_vq_type {
>  	EF100_VDPA_VQ_NTYPES
>  };
>  
> +/**
> + * struct ef100_vdpa_vring_info - vDPA vring data structure
> + *
> + * @desc: Descriptor area address of the vring
> + * @avail: Available area address of the vring
> + * @used: Device area address of the vring
> + * @size: Number of entries in the vring
> + * @vring_state: bit map to track vring configuration
> + * @last_avail_idx: last available index of the vring
> + * @last_used_idx: last used index of the vring
> + * @doorbell_offset: doorbell offset
> + * @doorbell_offset_valid: true if @doorbell_offset is updated
> + * @vring_type: type of vring created
> + * @vring_ctx: vring context information
> + * @msix_name: device name for vring irq handler
> + * @irq: irq number for vring irq handler
> + * @cb: callback for vring interrupts
> + */
> +struct ef100_vdpa_vring_info {
> +	dma_addr_t desc;
> +	dma_addr_t avail;
> +	dma_addr_t used;
> +	u32 size;
> +	u16 vring_state;
> +	u32 last_avail_idx;
> +	u32 last_used_idx;
> +	u32 doorbell_offset;
> +	bool doorbell_offset_valid;
> +	enum ef100_vdpa_vq_type vring_type;
> +	struct efx_vring_ctx *vring_ctx;
> +	char msix_name[EF100_VDPA_MAX_MSIX_NAME_SIZE];
> +	u32 irq;
> +	struct vdpa_callback cb;
> +};
> +
>  /**
>   *  struct ef100_vdpa_nic - vDPA NIC data structure
>   *
> @@ -70,6 +120,7 @@ enum ef100_vdpa_vq_type {
>   * @features: negotiated feature bits
>   * @max_queue_pairs: maximum number of queue pairs supported
>   * @net_config: virtio_net_config data
> + * @vring: vring information of the vDPA device.
>   * @mac_address: mac address of interface associated with this vdpa device
>   * @mac_configured: true after MAC address is configured
>   * @cfg_cb: callback for config change
> @@ -86,6 +137,7 @@ struct ef100_vdpa_nic {
>  	u64 features;
>  	u32 max_queue_pairs;
>  	struct virtio_net_config net_config;
> +	struct ef100_vdpa_vring_info vring[EF100_VDPA_MAX_QUEUES_PAIRS * 2];
>  	u8 *mac_address;
>  	bool mac_configured;
>  	struct vdpa_callback cfg_cb;
> @@ -95,6 +147,8 @@ int ef100_vdpa_init(struct efx_probe_data *probe_data);
>  void ef100_vdpa_fini(struct efx_probe_data *probe_data);
>  int ef100_vdpa_register_mgmtdev(struct efx_nic *efx);
>  void ef100_vdpa_unregister_mgmtdev(struct efx_nic *efx);
> +void ef100_vdpa_irq_vectors_free(void *data);
> +int ef100_vdpa_init_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx);
>  
>  static inline bool efx_vdpa_is_little_endian(struct ef100_vdpa_nic *vdpa_nic)
>  {
> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
> index a2364ef9f492..0051c4c0e47c 100644
> --- a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
> +++ b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
> @@ -9,13 +9,270 @@
>  
>  #include <linux/vdpa.h>
>  #include "ef100_vdpa.h"
> +#include "io.h"
>  #include "mcdi_vdpa.h"
>  
> +/* Get the queue's function-local index of the associated VI
> + * virtqueue number queue 0 is reserved for MCDI
> + */
> +#define EFX_GET_VI_INDEX(vq_num) (((vq_num) / 2) + 1)
> +
>  static struct ef100_vdpa_nic *get_vdpa_nic(struct vdpa_device *vdev)
>  {
>  	return container_of(vdev, struct ef100_vdpa_nic, vdpa_dev);
>  }
>  
> +void ef100_vdpa_irq_vectors_free(void *data)
> +{
> +	pci_free_irq_vectors(data);
> +}
> +
> +static int create_vring_ctx(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
> +{
> +	struct efx_vring_ctx *vring_ctx;
> +	u32 vi_index;
> +
> +	if (idx % 2) /* Even VQ for RX and odd for TX */
> +		vdpa_nic->vring[idx].vring_type = EF100_VDPA_VQ_TYPE_NET_TXQ;
> +	else
> +		vdpa_nic->vring[idx].vring_type = EF100_VDPA_VQ_TYPE_NET_RXQ;
> +	vi_index = EFX_GET_VI_INDEX(idx);
> +	vring_ctx = efx_vdpa_vring_init(vdpa_nic->efx, vi_index,
> +					vdpa_nic->vring[idx].vring_type);
> +	if (IS_ERR(vring_ctx))
> +		return PTR_ERR(vring_ctx);
> +
> +	vdpa_nic->vring[idx].vring_ctx = vring_ctx;
> +	return 0;
> +}
> +
> +static void delete_vring_ctx(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
> +{
> +	efx_vdpa_vring_fini(vdpa_nic->vring[idx].vring_ctx);
> +	vdpa_nic->vring[idx].vring_ctx = NULL;
> +}
> +
> +static void reset_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
> +{
> +	vdpa_nic->vring[idx].vring_type = EF100_VDPA_VQ_NTYPES;
> +	vdpa_nic->vring[idx].vring_state = 0;
> +	vdpa_nic->vring[idx].last_avail_idx = 0;
> +	vdpa_nic->vring[idx].last_used_idx = 0;
> +}
> +
> +int ef100_vdpa_init_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
> +{
> +	u32 offset;
> +	int rc;
> +
> +	vdpa_nic->vring[idx].irq = -EINVAL;
> +	rc = create_vring_ctx(vdpa_nic, idx);
> +	if (rc) {
> +		dev_err(&vdpa_nic->vdpa_dev.dev,
> +			"%s: create_vring_ctx failed, idx:%u, err:%d\n",
> +			__func__, idx, rc);
> +		return rc;
> +	}
> +
> +	rc = efx_vdpa_get_doorbell_offset(vdpa_nic->vring[idx].vring_ctx,
> +					  &offset);
> +	if (rc) {
> +		dev_err(&vdpa_nic->vdpa_dev.dev,
> +			"%s: get_doorbell failed idx:%u, err:%d\n",
> +			__func__, idx, rc);
> +		goto err_get_doorbell_offset;
> +	}
> +	vdpa_nic->vring[idx].doorbell_offset = offset;
> +	vdpa_nic->vring[idx].doorbell_offset_valid = true;
> +
> +	return 0;
> +
> +err_get_doorbell_offset:
> +	delete_vring_ctx(vdpa_nic, idx);
> +	return rc;
> +}
> +
> +static bool is_qid_invalid(struct ef100_vdpa_nic *vdpa_nic, u16 idx,
> +			   const char *caller)
> +{
> +	if (unlikely(idx >= (vdpa_nic->max_queue_pairs * 2))) {
> +		dev_err(&vdpa_nic->vdpa_dev.dev,
> +			"%s: Invalid qid %u\n", caller, idx);
> +		return true;
> +	}
> +	return false;
> +}
> +
> +static int ef100_vdpa_set_vq_address(struct vdpa_device *vdev,
> +				     u16 idx, u64 desc_area, u64 driver_area,
> +				     u64 device_area)
> +{
> +	struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
> +
> +	if (is_qid_invalid(vdpa_nic, idx, __func__))
> +		return -EINVAL;
> +
> +	mutex_lock(&vdpa_nic->lock);
> +	vdpa_nic->vring[idx].desc = desc_area;
> +	vdpa_nic->vring[idx].avail = driver_area;
> +	vdpa_nic->vring[idx].used = device_area;
> +	vdpa_nic->vring[idx].vring_state |= EF100_VRING_ADDRESS_CONFIGURED;
> +	mutex_unlock(&vdpa_nic->lock);
> +	return 0;
> +}
> +
> +static void ef100_vdpa_set_vq_num(struct vdpa_device *vdev, u16 idx, u32 num)
> +{
> +	struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
> +
> +	if (is_qid_invalid(vdpa_nic, idx, __func__))
> +		return;
> +
> +	if (!is_power_of_2(num)) {
> +		dev_err(&vdev->dev, "%s: Index:%u size:%u not power of 2\n",
> +			__func__, idx, num);
> +		return;
> +	}
> +	if (num > EF100_VDPA_VQ_NUM_MAX_SIZE) {
> +		dev_err(&vdev->dev, "%s: Index:%u size:%u more than max:%u\n",
> +			__func__, idx, num, EF100_VDPA_VQ_NUM_MAX_SIZE);
> +		return;
> +	}
> +	mutex_lock(&vdpa_nic->lock);
> +	vdpa_nic->vring[idx].size  = num;
> +	vdpa_nic->vring[idx].vring_state |= EF100_VRING_SIZE_CONFIGURED;
> +	mutex_unlock(&vdpa_nic->lock);
> +}
> +
> +static void ef100_vdpa_kick_vq(struct vdpa_device *vdev, u16 idx)
> +{
> +	struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
> +	u32 idx_val;
> +
> +	if (is_qid_invalid(vdpa_nic, idx, __func__))
> +		return;
> +
> +	if (!(vdpa_nic->vring[idx].vring_state & EF100_VRING_CREATED))
> +		return;
> +
> +	idx_val = idx;
> +	_efx_writed(vdpa_nic->efx, cpu_to_le32(idx_val),
> +		    vdpa_nic->vring[idx].doorbell_offset);
> +}
> +
> +static void ef100_vdpa_set_vq_cb(struct vdpa_device *vdev, u16 idx,
> +				 struct vdpa_callback *cb)
> +{
> +	struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
> +
> +	if (is_qid_invalid(vdpa_nic, idx, __func__))
> +		return;
> +
> +	if (cb)
> +		vdpa_nic->vring[idx].cb = *cb;
> +}
> +
> +static void ef100_vdpa_set_vq_ready(struct vdpa_device *vdev, u16 idx,
> +				    bool ready)
> +{
> +	struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
> +
> +	if (is_qid_invalid(vdpa_nic, idx, __func__))
> +		return;
> +
> +	mutex_lock(&vdpa_nic->lock);
> +	if (ready) {
> +		vdpa_nic->vring[idx].vring_state |=
> +					EF100_VRING_READY_CONFIGURED;
> +	} else {
> +		vdpa_nic->vring[idx].vring_state &=
> +					~EF100_VRING_READY_CONFIGURED;
> +	}
> +	mutex_unlock(&vdpa_nic->lock);
> +}
> +
> +static bool ef100_vdpa_get_vq_ready(struct vdpa_device *vdev, u16 idx)
> +{
> +	struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
> +	bool ready;
> +
> +	if (is_qid_invalid(vdpa_nic, idx, __func__))
> +		return false;
> +
> +	mutex_lock(&vdpa_nic->lock);
> +	ready = vdpa_nic->vring[idx].vring_state & EF100_VRING_READY_CONFIGURED;
> +	mutex_unlock(&vdpa_nic->lock);
> +	return ready;
> +}
> +
> +static int ef100_vdpa_set_vq_state(struct vdpa_device *vdev, u16 idx,
> +				   const struct vdpa_vq_state *state)
> +{
> +	struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
> +
> +	if (is_qid_invalid(vdpa_nic, idx, __func__))
> +		return -EINVAL;
> +
> +	mutex_lock(&vdpa_nic->lock);
> +	vdpa_nic->vring[idx].last_avail_idx = state->split.avail_index;
> +	vdpa_nic->vring[idx].last_used_idx = state->split.avail_index;
> +	mutex_unlock(&vdpa_nic->lock);
> +	return 0;
> +}
> +
> +static int ef100_vdpa_get_vq_state(struct vdpa_device *vdev,
> +				   u16 idx, struct vdpa_vq_state *state)
> +{
> +	struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
> +
> +	if (is_qid_invalid(vdpa_nic, idx, __func__))
> +		return -EINVAL;
> +
> +	mutex_lock(&vdpa_nic->lock);
> +	state->split.avail_index = (u16)vdpa_nic->vring[idx].last_used_idx;
> +	mutex_unlock(&vdpa_nic->lock);
> +
> +	return 0;
> +}
> +
> +static struct vdpa_notification_area
> +		ef100_vdpa_get_vq_notification(struct vdpa_device *vdev,
> +					       u16 idx)
> +{
> +	struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
> +	struct vdpa_notification_area notify_area = {0, 0};
> +
> +	if (is_qid_invalid(vdpa_nic, idx, __func__))
> +		goto end;
> +
> +	mutex_lock(&vdpa_nic->lock);
> +	notify_area.addr = (uintptr_t)(vdpa_nic->efx->membase_phys +
> +				vdpa_nic->vring[idx].doorbell_offset);
> +	/* VDPA doorbells are at a stride of VI/2
> +	 * One VI stride is shared by both rx & tx doorbells
> +	 */
> +	notify_area.size = vdpa_nic->efx->vi_stride / 2;
> +	mutex_unlock(&vdpa_nic->lock);
> +
> +end:
> +	return notify_area;
> +}
> +
> +static int ef100_get_vq_irq(struct vdpa_device *vdev, u16 idx)
> +{
> +	struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
> +	u32 irq;
> +
> +	if (is_qid_invalid(vdpa_nic, idx, __func__))
> +		return -EINVAL;
> +
> +	mutex_lock(&vdpa_nic->lock);
> +	irq = vdpa_nic->vring[idx].irq;
> +	mutex_unlock(&vdpa_nic->lock);
> +
> +	return irq;
> +}
> +
>  static u32 ef100_vdpa_get_vq_align(struct vdpa_device *vdev)
>  {
>  	return EF100_VDPA_VQ_ALIGN;
> @@ -80,6 +337,8 @@ static void ef100_vdpa_set_config_cb(struct vdpa_device *vdev,
>  
>  	if (cb)
>  		vdpa_nic->cfg_cb = *cb;
> +	else
> +		memset(&vdpa_nic->cfg_cb, 0, sizeof(vdpa_nic->cfg_cb));
>  }
>  
>  static u16 ef100_vdpa_get_vq_num_max(struct vdpa_device *vdev)
> @@ -137,14 +396,30 @@ static void ef100_vdpa_set_config(struct vdpa_device *vdev, unsigned int offset,
>  static void ef100_vdpa_free(struct vdpa_device *vdev)
>  {
>  	struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
> +	int i;
>  
>  	if (vdpa_nic) {
> +		for (i = 0; i < (vdpa_nic->max_queue_pairs * 2); i++) {
> +			reset_vring(vdpa_nic, i);
> +			if (vdpa_nic->vring[i].vring_ctx)
> +				delete_vring_ctx(vdpa_nic, i);
> +		}
>  		mutex_destroy(&vdpa_nic->lock);
>  		vdpa_nic->efx->vdpa_nic = NULL;
>  	}
>  }
>  
>  const struct vdpa_config_ops ef100_vdpa_config_ops = {
> +	.set_vq_address	     = ef100_vdpa_set_vq_address,
> +	.set_vq_num	     = ef100_vdpa_set_vq_num,
> +	.kick_vq	     = ef100_vdpa_kick_vq,
> +	.set_vq_cb	     = ef100_vdpa_set_vq_cb,
> +	.set_vq_ready	     = ef100_vdpa_set_vq_ready,
> +	.get_vq_ready	     = ef100_vdpa_get_vq_ready,
> +	.set_vq_state	     = ef100_vdpa_set_vq_state,
> +	.get_vq_state	     = ef100_vdpa_get_vq_state,
> +	.get_vq_notification = ef100_vdpa_get_vq_notification,
> +	.get_vq_irq          = ef100_get_vq_irq,
>  	.get_vq_align	     = ef100_vdpa_get_vq_align,
>  	.get_device_features = ef100_vdpa_get_device_features,
>  	.set_driver_features = ef100_vdpa_set_driver_features,
> -- 
> 2.30.1
