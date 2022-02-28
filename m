Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 603AE4C645A
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 09:07:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233834AbiB1IIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 03:08:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233560AbiB1IIV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 03:08:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E1E0C33E20
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 00:07:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646035660;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZEg+1lw95oVgyFcFAqtClQVp7snHOaZZ37kJvcE2J+E=;
        b=XqrFaj4F135it6vhaJJm2w4y3n4jB07m+U7WUm8P7bDtMMXaOaeaHV5v+ynnz/slaCPPG/
        l49fyOmtVwgF+6HzROcpYSLbVRTdPOo8rhNWmWHkr/lAhBx7TOTLLybWP+QXwt0nDvoqua
        /RbhupE5GlMvNztQGCZ03qtLKyXPQnU=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-449-QH9GpSqsMI6O9a20n7R55A-1; Mon, 28 Feb 2022 03:07:36 -0500
X-MC-Unique: QH9GpSqsMI6O9a20n7R55A-1
Received: by mail-pg1-f200.google.com with SMTP id u74-20020a63794d000000b00373efe2ac5aso6154109pgc.14
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 00:07:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZEg+1lw95oVgyFcFAqtClQVp7snHOaZZ37kJvcE2J+E=;
        b=bg5+hvQkm57DUN9udFZRuoAGQVyVgzTwQ1DFa7+GCT4eZaf8NQZs/16rqC0zyH7Ltg
         pZCmVpAQUcxuQJd0dWWp1llJ4JCSk43fFaVbzBf5OUBfbkl074/QArqs0gFKb/GEGAFo
         Q+hfFjMcblyrhI2dcElGZn7luXgoK5Vj4dyWB4T5K9d/eU0SPa22vE7W9HXjDho2mtZy
         KKOYobrxhP3agHl9q8gVU7tTT3YK6wCk3GuwGkrtoAhDsW3ZnAvNeyk3CB30UuNHs+U1
         LWQvFPI4WXCzkgFAVwSVca7FCKv5knGpgCU5fYXsHFZDS7rUhMo7hGYiLwX8dkmTSmZG
         iIqg==
X-Gm-Message-State: AOAM532hVxN3GvZqS+EDoNpVd/79MeAkc6TFNbYb0FO5M/AsOr+Oe8yC
        1lFTx8k7lJg4q8/Fwr5ODseyMo+2q9UuCh6T4Z7M4MyyfXYIjhiIy8abs5JNHZVdrQAkZJnXBnw
        EoieOis2wMwfdWf7u
X-Received: by 2002:a17:902:b692:b0:151:5474:d3ee with SMTP id c18-20020a170902b69200b001515474d3eemr8260951pls.139.1646035655194;
        Mon, 28 Feb 2022 00:07:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJznHT+nxWUnKGWZ5hcEVi75Ogi5dSqPiYgaue8FxDbPTCecmBni8Dqz6AEQvbkaw/HCAc7kRA==
X-Received: by 2002:a17:902:b692:b0:151:5474:d3ee with SMTP id c18-20020a170902b69200b001515474d3eemr8260925pls.139.1646035654918;
        Mon, 28 Feb 2022 00:07:34 -0800 (PST)
Received: from [10.72.13.215] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id lr2-20020a17090b4b8200b001bd6b5cce1dsm206968pjb.36.2022.02.28.00.07.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Feb 2022 00:07:34 -0800 (PST)
Message-ID: <efaa9bf0-5b5a-a33e-ce38-44473159d44a@redhat.com>
Date:   Mon, 28 Feb 2022 16:07:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [RFC PATCH v2 05/19] vdpa: introduce virtqueue groups
Content-Language: en-US
To:     Gautam Dawar <gautam.dawar@xilinx.com>
Cc:     gdawar@xilinx.com, martinh@xilinx.com, hanand@xilinx.com,
        tanujk@xilinx.com, eperezma@redhat.com,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Eli Cohen <elic@nvidia.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Parav Pandit <parav@nvidia.com>,
        Longpeng <longpeng2@huawei.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
References: <20201216064818.48239-1-jasowang@redhat.com>
 <20220224212314.1326-1-gdawar@xilinx.com>
 <20220224212314.1326-6-gdawar@xilinx.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220224212314.1326-6-gdawar@xilinx.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/2/25 上午5:22, Gautam Dawar 写道:
> This patch introduces virtqueue groups to vDPA device. The virtqueue
> group is the minimal set of virtqueues that must share an address
> space. And the address space identifier could only be attached to
> a specific virtqueue group.
>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> Signed-off-by: Gautam Dawar <gdawar@xilinx.com>
> ---
>   drivers/vdpa/ifcvf/ifcvf_main.c   |  8 +++++++-
>   drivers/vdpa/mlx5/net/mlx5_vnet.c |  8 +++++++-
>   drivers/vdpa/vdpa.c               |  3 +++
>   drivers/vdpa/vdpa_sim/vdpa_sim.c  |  9 ++++++++-
>   drivers/vdpa/vdpa_sim/vdpa_sim.h  |  1 +
>   include/linux/vdpa.h              | 16 ++++++++++++----
>   6 files changed, 38 insertions(+), 7 deletions(-)


We had three more parents now, so we should convert them as well:

vp_vdpa, VDUSE and eni_vdpa.

Thanks


>
> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
> index d1a6b5ab543c..c815a2e62440 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
> @@ -378,6 +378,11 @@ static size_t ifcvf_vdpa_get_config_size(struct vdpa_device *vdpa_dev)
>   	return  vf->config_size;
>   }
>   
> +static u32 ifcvf_vdpa_get_vq_group(struct vdpa_device *vdpa, u16 idx)
> +{
> +	return 0;
> +}
> +
>   static void ifcvf_vdpa_get_config(struct vdpa_device *vdpa_dev,
>   				  unsigned int offset,
>   				  void *buf, unsigned int len)
> @@ -453,6 +458,7 @@ static const struct vdpa_config_ops ifc_vdpa_ops = {
>   	.get_device_id	= ifcvf_vdpa_get_device_id,
>   	.get_vendor_id	= ifcvf_vdpa_get_vendor_id,
>   	.get_vq_align	= ifcvf_vdpa_get_vq_align,
> +	.get_vq_group	= ifcvf_vdpa_get_vq_group,
>   	.get_config_size	= ifcvf_vdpa_get_config_size,
>   	.get_config	= ifcvf_vdpa_get_config,
>   	.set_config	= ifcvf_vdpa_set_config,
> @@ -507,7 +513,7 @@ static int ifcvf_vdpa_dev_add(struct vdpa_mgmt_dev *mdev, const char *name,
>   	pdev = ifcvf_mgmt_dev->pdev;
>   	dev = &pdev->dev;
>   	adapter = vdpa_alloc_device(struct ifcvf_adapter, vdpa,
> -				    dev, &ifc_vdpa_ops, name, false);
> +				    dev, &ifc_vdpa_ops, 1, name, false);
>   	if (IS_ERR(adapter)) {
>   		IFCVF_ERR(pdev, "Failed to allocate vDPA structure");
>   		return PTR_ERR(adapter);
> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> index b53603d94082..fcfc28460b72 100644
> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> @@ -1847,6 +1847,11 @@ static u32 mlx5_vdpa_get_vq_align(struct vdpa_device *vdev)
>   	return PAGE_SIZE;
>   }
>   
> +static u32 mlx5_vdpa_get_vq_group(struct vdpa_device *vdpa, u16 idx)
> +{
> +	return 0;
> +}
> +
>   enum { MLX5_VIRTIO_NET_F_GUEST_CSUM = 1 << 9,
>   	MLX5_VIRTIO_NET_F_CSUM = 1 << 10,
>   	MLX5_VIRTIO_NET_F_HOST_TSO6 = 1 << 11,
> @@ -2363,6 +2368,7 @@ static const struct vdpa_config_ops mlx5_vdpa_ops = {
>   	.get_vq_notification = mlx5_get_vq_notification,
>   	.get_vq_irq = mlx5_get_vq_irq,
>   	.get_vq_align = mlx5_vdpa_get_vq_align,
> +	.get_vq_group = mlx5_vdpa_get_vq_group,
>   	.get_device_features = mlx5_vdpa_get_device_features,
>   	.set_driver_features = mlx5_vdpa_set_driver_features,
>   	.get_driver_features = mlx5_vdpa_get_driver_features,
> @@ -2575,7 +2581,7 @@ static int mlx5_vdpa_dev_add(struct vdpa_mgmt_dev *v_mdev, const char *name,
>   	}
>   
>   	ndev = vdpa_alloc_device(struct mlx5_vdpa_net, mvdev.vdev, mdev->device, &mlx5_vdpa_ops,
> -				 name, false);
> +				 1, name, false);
>   	if (IS_ERR(ndev))
>   		return PTR_ERR(ndev);
>   
> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
> index 9846c9de4bfa..a07bf0130559 100644
> --- a/drivers/vdpa/vdpa.c
> +++ b/drivers/vdpa/vdpa.c
> @@ -159,6 +159,7 @@ static void vdpa_release_dev(struct device *d)
>    * initialized but before registered.
>    * @parent: the parent device
>    * @config: the bus operations that is supported by this device
> + * @ngroups: number of groups supported by this device
>    * @size: size of the parent structure that contains private data
>    * @name: name of the vdpa device; optional.
>    * @use_va: indicate whether virtual address must be used by this device
> @@ -171,6 +172,7 @@ static void vdpa_release_dev(struct device *d)
>    */
>   struct vdpa_device *__vdpa_alloc_device(struct device *parent,
>   					const struct vdpa_config_ops *config,
> +					unsigned int ngroups,
>   					size_t size, const char *name,
>   					bool use_va)
>   {
> @@ -203,6 +205,7 @@ struct vdpa_device *__vdpa_alloc_device(struct device *parent,
>   	vdev->config = config;
>   	vdev->features_valid = false;
>   	vdev->use_va = use_va;
> +	vdev->ngroups = ngroups;
>   
>   	if (name)
>   		err = dev_set_name(&vdev->dev, "%s", name);
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> index ddbe142af09a..c98cb1f869fa 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> @@ -250,7 +250,7 @@ struct vdpasim *vdpasim_create(struct vdpasim_dev_attr *dev_attr)
>   	else
>   		ops = &vdpasim_config_ops;
>   
> -	vdpasim = vdpa_alloc_device(struct vdpasim, vdpa, NULL, ops,
> +	vdpasim = vdpa_alloc_device(struct vdpasim, vdpa, NULL, ops, 1,
>   				    dev_attr->name, false);
>   	if (IS_ERR(vdpasim)) {
>   		ret = PTR_ERR(vdpasim);
> @@ -399,6 +399,11 @@ static u32 vdpasim_get_vq_align(struct vdpa_device *vdpa)
>   	return VDPASIM_QUEUE_ALIGN;
>   }
>   
> +static u32 vdpasim_get_vq_group(struct vdpa_device *vdpa, u16 idx)
> +{
> +	return 0;
> +}
> +
>   static u64 vdpasim_get_device_features(struct vdpa_device *vdpa)
>   {
>   	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
> @@ -620,6 +625,7 @@ static const struct vdpa_config_ops vdpasim_config_ops = {
>   	.set_vq_state           = vdpasim_set_vq_state,
>   	.get_vq_state           = vdpasim_get_vq_state,
>   	.get_vq_align           = vdpasim_get_vq_align,
> +	.get_vq_group           = vdpasim_get_vq_group,
>   	.get_device_features    = vdpasim_get_device_features,
>   	.set_driver_features    = vdpasim_set_driver_features,
>   	.get_driver_features    = vdpasim_get_driver_features,
> @@ -650,6 +656,7 @@ static const struct vdpa_config_ops vdpasim_batch_config_ops = {
>   	.set_vq_state           = vdpasim_set_vq_state,
>   	.get_vq_state           = vdpasim_get_vq_state,
>   	.get_vq_align           = vdpasim_get_vq_align,
> +	.get_vq_group           = vdpasim_get_vq_group,
>   	.get_device_features    = vdpasim_get_device_features,
>   	.set_driver_features    = vdpasim_set_driver_features,
>   	.get_driver_features    = vdpasim_get_driver_features,
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.h b/drivers/vdpa/vdpa_sim/vdpa_sim.h
> index cd58e888bcf3..0be7c1e7ef80 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim.h
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.h
> @@ -63,6 +63,7 @@ struct vdpasim {
>   	u32 status;
>   	u32 generation;
>   	u64 features;
> +	u32 groups;
>   	/* spinlock to synchronize iommu table */
>   	spinlock_t iommu_lock;
>   };
> diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
> index 2de442ececae..026b7ad72ed7 100644
> --- a/include/linux/vdpa.h
> +++ b/include/linux/vdpa.h
> @@ -85,6 +85,7 @@ struct vdpa_device {
>   	bool use_va;
>   	int nvqs;
>   	struct vdpa_mgmt_dev *mdev;
> +	unsigned int ngroups;
>   };
>   
>   /**
> @@ -172,6 +173,10 @@ struct vdpa_map_file {
>    *				for the device
>    *				@vdev: vdpa device
>    *				Returns virtqueue algin requirement
> + * @get_vq_group:		Get the group id for a specific virtqueue
> + *				@vdev: vdpa device
> + *				@idx: virtqueue index
> + *				Returns u32: group id for this virtqueue
>    * @get_device_features:	Get virtio features supported by the device
>    *				@vdev: vdpa device
>    *				Returns the virtio features support by the
> @@ -282,6 +287,7 @@ struct vdpa_config_ops {
>   
>   	/* Device ops */
>   	u32 (*get_vq_align)(struct vdpa_device *vdev);
> +	u32 (*get_vq_group)(struct vdpa_device *vdev, u16 idx);
>   	u64 (*get_device_features)(struct vdpa_device *vdev);
>   	int (*set_driver_features)(struct vdpa_device *vdev, u64 features);
>   	u64 (*get_driver_features)(struct vdpa_device *vdev);
> @@ -314,6 +320,7 @@ struct vdpa_config_ops {
>   
>   struct vdpa_device *__vdpa_alloc_device(struct device *parent,
>   					const struct vdpa_config_ops *config,
> +					unsigned int ngroups,
>   					size_t size, const char *name,
>   					bool use_va);
>   
> @@ -324,17 +331,18 @@ struct vdpa_device *__vdpa_alloc_device(struct device *parent,
>    * @member: the name of struct vdpa_device within the @dev_struct
>    * @parent: the parent device
>    * @config: the bus operations that is supported by this device
> + * @ngroups: the number of virtqueue groups supported by this device
>    * @name: name of the vdpa device
>    * @use_va: indicate whether virtual address must be used by this device
>    *
>    * Return allocated data structure or ERR_PTR upon error
>    */
> -#define vdpa_alloc_device(dev_struct, member, parent, config, name, use_va)   \
> -			  container_of(__vdpa_alloc_device( \
> -				       parent, config, \
> +#define vdpa_alloc_device(dev_struct, member, parent, config, ngroups, name, use_va)   \
> +			  container_of((__vdpa_alloc_device( \
> +				       parent, config, ngroups, \
>   				       sizeof(dev_struct) + \
>   				       BUILD_BUG_ON_ZERO(offsetof( \
> -				       dev_struct, member)), name, use_va), \
> +				       dev_struct, member)), name, use_va)), \
>   				       dev_struct, member)
>   
>   int vdpa_register_device(struct vdpa_device *vdev, int nvqs);

