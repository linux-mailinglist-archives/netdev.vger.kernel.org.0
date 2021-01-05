Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 563E42EAA31
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 12:51:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729840AbhAELue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 06:50:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48870 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726074AbhAELud (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 06:50:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609847346;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Fut1Y2EsHn3bhvP0i73Cj1gJTUlxPV1KUG+a0d7acj8=;
        b=G6dFy5y7mg2LsRHdenq1MUSc+lgZrW9feGFvj/oaTi6EbDl9R8YXy+rraeXDASCHDK6DUM
        Jrf190M1jtUTLdQ5veVrrBXDJahsR7n0kdmhRHyHbdkJ2taCJC37wPV9ZDDixRbb6rZiNJ
        jGOhN3G2Px1M4Oez3C94mK+HmUaZltQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-97-B9eWz5UPPDeyGJs8oFu5kA-1; Tue, 05 Jan 2021 06:49:04 -0500
X-MC-Unique: B9eWz5UPPDeyGJs8oFu5kA-1
Received: by mail-wr1-f69.google.com with SMTP id g16so14810152wrv.1
        for <netdev@vger.kernel.org>; Tue, 05 Jan 2021 03:49:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Fut1Y2EsHn3bhvP0i73Cj1gJTUlxPV1KUG+a0d7acj8=;
        b=KFB2p9HFzNFV69yVWjB+BKud0awonnQ2vnQU/HKC7nqPYpfuWigrwMs4iUuJzk0Et6
         aNemLdi7egHANX5SfH2jHXRjY1/zSngvxABQepMGFnZR9WKbnuL4JjGq5N7G84ILtCBZ
         9MS30vICnv5l72HTLS7INkwht1h7JzbVQpulT0jYvsgHJ5DmRSTg7G9o67qkMZNYiRY5
         ep4rc8ERI5GbHp/ZCiJmwMGuv65eYn6jqNgt3B671mcIqQX/st/Mp4dlni2CJWWerr4P
         K+6DbNmjAnL/Iv2BpJ0q1LXuT9OKqXosm4SSRVcDpEvJUfIQewCWDTr9RdRY7iw/3FIv
         QjYQ==
X-Gm-Message-State: AOAM532DYcYL1ZZhxRnj+Q5vsfoyU9EpcAAFFqbP4NKTVLbgB3Xnapr6
        1QGh4nbYIsjn/NkjNQMdLyvd1+eKu9+/LsQCrRbeH9Je58hETyQ4GOZCiOCLtVHA7xP6j9TRRIW
        MJgDuBdJGabu/tm/f
X-Received: by 2002:a1c:cc14:: with SMTP id h20mr3173808wmb.180.1609847342666;
        Tue, 05 Jan 2021 03:49:02 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxgeopOVLBCAF7wx6sxfCGX6KW/lKRsu1Rt6mVUnL57qixRveaV+Tq9/8s/30f9SXbM2rOPtw==
X-Received: by 2002:a1c:cc14:: with SMTP id h20mr3173794wmb.180.1609847342474;
        Tue, 05 Jan 2021 03:49:02 -0800 (PST)
Received: from redhat.com (bzq-79-178-32-166.red.bezeqint.net. [79.178.32.166])
        by smtp.gmail.com with ESMTPSA id z13sm5081842wmz.3.2021.01.05.03.49.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jan 2021 03:49:01 -0800 (PST)
Date:   Tue, 5 Jan 2021 06:48:58 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Parav Pandit <parav@nvidia.com>
Cc:     virtualization@lists.linux-foundation.org, jasowang@redhat.com,
        elic@nvidia.com, netdev@vger.kernel.org
Subject: Re: [PATCH linux-next v3 6/6] vdpa_sim_net: Add support for user
 supported devices
Message-ID: <20210105064707-mutt-send-email-mst@kernel.org>
References: <20201112064005.349268-1-parav@nvidia.com>
 <20210105103203.82508-1-parav@nvidia.com>
 <20210105103203.82508-7-parav@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210105103203.82508-7-parav@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 05, 2021 at 12:32:03PM +0200, Parav Pandit wrote:
> Enable user to create vdpasim net simulate devices.
> 
> Show vdpa management device that supports creating, deleting vdpa devices.
> 
> $ vdpa mgmtdev show
> vdpasim_net:
>   supported_classes
>     net
> 
> $ vdpa mgmtdev show -jp
> {
>     "show": {
>         "vdpasim_net": {
>             "supported_classes": {
>               "net"
>         }
>     }
> }
> 
> Create a vdpa device of type networking named as "foo2" from
> the management device vdpasim:
> 
> $ vdpa dev add mgmtdev vdpasim_net name foo2
> 
> Show the newly created vdpa device by its name:
> $ vdpa dev show foo2
> foo2: type network mgmtdev vdpasim_net vendor_id 0 max_vqs 2 max_vq_size 256
> 
> $ vdpa dev show foo2 -jp
> {
>     "dev": {
>         "foo2": {
>             "type": "network",
>             "mgmtdev": "vdpasim_net",
>             "vendor_id": 0,
>             "max_vqs": 2,
>             "max_vq_size": 256
>         }
>     }
> }


I'd like an example of how do device specific
(e.g. net specific) interfaces tie in to this.


> Delete the vdpa device after its use:
> $ vdpa dev del foo2
> 
> Signed-off-by: Parav Pandit <parav@nvidia.com>
> Reviewed-by: Eli Cohen <elic@nvidia.com>
> Acked-by: Jason Wang <jasowang@redhat.com>
> ---
> Changelog:
> v2->v3:
>  - removed code branches due to default device removal patch
> v1->v2:
>  - rebased
> ---
>  drivers/vdpa/vdpa_sim/vdpa_sim.c     |  3 +-
>  drivers/vdpa/vdpa_sim/vdpa_sim.h     |  2 +
>  drivers/vdpa/vdpa_sim/vdpa_sim_net.c | 96 ++++++++++++++++++++--------
>  3 files changed, 75 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> index db1636a99ba4..d5942842432d 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> @@ -235,7 +235,7 @@ struct vdpasim *vdpasim_create(struct vdpasim_dev_attr *dev_attr)
>  		ops = &vdpasim_config_ops;
>  
>  	vdpasim = vdpa_alloc_device(struct vdpasim, vdpa, NULL, ops,
> -				    dev_attr->nvqs, NULL);
> +				    dev_attr->nvqs, dev_attr->name);
>  	if (!vdpasim)
>  		goto err_alloc;
>  
> @@ -249,6 +249,7 @@ struct vdpasim *vdpasim_create(struct vdpasim_dev_attr *dev_attr)
>  	if (dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64)))
>  		goto err_iommu;
>  	set_dma_ops(dev, &vdpasim_dma_ops);
> +	vdpasim->vdpa.mdev = dev_attr->mgmt_dev;
>  
>  	vdpasim->config = kzalloc(dev_attr->config_size, GFP_KERNEL);
>  	if (!vdpasim->config)
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.h b/drivers/vdpa/vdpa_sim/vdpa_sim.h
> index b02142293d5b..6d75444f9948 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim.h
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.h
> @@ -33,6 +33,8 @@ struct vdpasim_virtqueue {
>  };
>  
>  struct vdpasim_dev_attr {
> +	struct vdpa_mgmt_dev *mgmt_dev;
> +	const char *name;
>  	u64 supported_features;
>  	size_t config_size;
>  	size_t buffer_size;
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
> index f0482427186b..d344c5b7c914 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
> @@ -35,8 +35,6 @@ MODULE_PARM_DESC(macaddr, "Ethernet MAC address");
>  
>  static u8 macaddr_buf[ETH_ALEN];
>  
> -static struct vdpasim *vdpasim_net_dev;
> -
>  static void vdpasim_net_work(struct work_struct *work)
>  {
>  	struct vdpasim *vdpasim = container_of(work, struct vdpasim, work);
> @@ -120,21 +118,23 @@ static void vdpasim_net_get_config(struct vdpasim *vdpasim, void *config)
>  	memcpy(net_config->mac, macaddr_buf, ETH_ALEN);
>  }
>  
> -static int __init vdpasim_net_init(void)
> +static void vdpasim_net_mgmtdev_release(struct device *dev)
> +{
> +}
> +
> +static struct device vdpasim_net_mgmtdev = {
> +	.init_name = "vdpasim_net",
> +	.release = vdpasim_net_mgmtdev_release,
> +};
> +
> +static int vdpasim_net_dev_add(struct vdpa_mgmt_dev *mdev, const char *name)
>  {
>  	struct vdpasim_dev_attr dev_attr = {};
> +	struct vdpasim *simdev;
>  	int ret;
>  
> -	if (macaddr) {
> -		mac_pton(macaddr, macaddr_buf);
> -		if (!is_valid_ether_addr(macaddr_buf)) {
> -			ret = -EADDRNOTAVAIL;
> -			goto out;
> -		}
> -	} else {
> -		eth_random_addr(macaddr_buf);
> -	}
> -
> +	dev_attr.mgmt_dev = mdev;
> +	dev_attr.name = name;
>  	dev_attr.id = VIRTIO_ID_NET;
>  	dev_attr.supported_features = VDPASIM_NET_FEATURES;
>  	dev_attr.nvqs = VDPASIM_NET_VQ_NUM;
> @@ -143,29 +143,75 @@ static int __init vdpasim_net_init(void)
>  	dev_attr.work_fn = vdpasim_net_work;
>  	dev_attr.buffer_size = PAGE_SIZE;
>  
> -	vdpasim_net_dev = vdpasim_create(&dev_attr);
> -	if (IS_ERR(vdpasim_net_dev)) {
> -		ret = PTR_ERR(vdpasim_net_dev);
> -		goto out;
> +	simdev = vdpasim_create(&dev_attr);
> +	if (IS_ERR(simdev))
> +		return PTR_ERR(simdev);
> +
> +	ret = _vdpa_register_device(&simdev->vdpa);
> +	if (ret)
> +		goto reg_err;
> +
> +	return 0;
> +
> +reg_err:
> +	put_device(&simdev->vdpa.dev);
> +	return ret;
> +}
> +
> +static void vdpasim_net_dev_del(struct vdpa_mgmt_dev *mdev,
> +				struct vdpa_device *dev)
> +{
> +	struct vdpasim *simdev = container_of(dev, struct vdpasim, vdpa);
> +
> +	_vdpa_unregister_device(&simdev->vdpa);
> +}
> +
> +static const struct vdpa_mgmtdev_ops vdpasim_net_mgmtdev_ops = {
> +	.dev_add = vdpasim_net_dev_add,
> +	.dev_del = vdpasim_net_dev_del
> +};
> +
> +static struct virtio_device_id id_table[] = {
> +	{ VIRTIO_ID_NET, VIRTIO_DEV_ANY_ID },
> +	{ 0 },
> +};
> +
> +static struct vdpa_mgmt_dev mgmt_dev = {
> +	.device = &vdpasim_net_mgmtdev,
> +	.id_table = id_table,
> +	.ops = &vdpasim_net_mgmtdev_ops,
> +};
> +
> +static int __init vdpasim_net_init(void)
> +{
> +	int ret;
> +
> +	if (macaddr) {
> +		mac_pton(macaddr, macaddr_buf);
> +		if (!is_valid_ether_addr(macaddr_buf))
> +			return -EADDRNOTAVAIL;
> +	} else {
> +		eth_random_addr(macaddr_buf);
>  	}

Hmm so all devices start out with the same MAC
until changed? And how is the change effected?


> -	ret = vdpa_register_device(&vdpasim_net_dev->vdpa);
> +	ret = device_register(&vdpasim_net_mgmtdev);
>  	if (ret)
> -		goto put_dev;
> +		return ret;
>  
> +	ret = vdpa_mgmtdev_register(&mgmt_dev);
> +	if (ret)
> +		goto parent_err;
>  	return 0;
>  
> -put_dev:
> -	put_device(&vdpasim_net_dev->vdpa.dev);
> -out:
> +parent_err:
> +	device_unregister(&vdpasim_net_mgmtdev);
>  	return ret;
>  }
>  
>  static void __exit vdpasim_net_exit(void)
>  {
> -	struct vdpa_device *vdpa = &vdpasim_net_dev->vdpa;
> -
> -	vdpa_unregister_device(vdpa);
> +	vdpa_mgmtdev_unregister(&mgmt_dev);
> +	device_unregister(&vdpasim_net_mgmtdev);
>  }
>  
>  module_init(vdpasim_net_init);
> -- 
> 2.26.2

