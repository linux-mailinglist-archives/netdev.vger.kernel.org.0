Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E0C333FDDB
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 04:33:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbhCRDdB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 23:33:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37751 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230192AbhCRDc0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 23:32:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616038346;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jLTPt0xOZQl9IIcVBTaP1P5SgdeBnCH6KEmvNhfyD0k=;
        b=eJxy9VBHSJGvfr7wibCIYMh+oT6wh+NHsRbPswsY97fOjQiTwDPP5QlOQPopQ1LAOplTun
        I8foGMFPdBhnRSu8dDOov9UHhIQuNaJH5jM5OtVJFpUpoj3QgMwVfNhc6ByVmaNd4bLwyw
        vFWig9yswVI/fqUH1V7tGibgIpWp5/8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-211-e1GUImQ-P96rYKksfeWs3g-1; Wed, 17 Mar 2021 23:32:22 -0400
X-MC-Unique: e1GUImQ-P96rYKksfeWs3g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 846D31084C83;
        Thu, 18 Mar 2021 03:32:20 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-131.pek2.redhat.com [10.72.13.131])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 923922B431;
        Thu, 18 Mar 2021 03:31:58 +0000 (UTC)
Subject: Re: [PATCH v4 14/14] vdpa_sim_blk: add support for vdpa management
 tool
To:     Stefano Garzarella <sgarzare@redhat.com>,
        virtualization@lists.linux-foundation.org
Cc:     netdev@vger.kernel.org, Xie Yongji <xieyongji@bytedance.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org, Max Gurtovoy <mgurtovoy@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org
References: <20210315163450.254396-1-sgarzare@redhat.com>
 <20210315163450.254396-15-sgarzare@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <94bb9e5a-a1b9-2e0d-d5ec-c6a3eaebea88@redhat.com>
Date:   Thu, 18 Mar 2021 11:31:54 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210315163450.254396-15-sgarzare@redhat.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/3/16 ÉÏÎç12:34, Stefano Garzarella Ð´µÀ:
> Enable the user to create vDPA block simulator devices using the
> vdpa management tool:
>
>      # Show vDPA supported devices
>      $ vdpa mgmtdev show
>      vdpasim_blk:
>        supported_classes block
>
>      # Create a vDPA block device named as 'blk0' from the management
>      # device vdpasim:
>      $ vdpa dev add mgmtdev vdpasim_blk name blk0
>
>      # Show the info of the 'blk0' device just created
>      $ vdpa dev show blk0 -jp
>      {
>          "dev": {
>              "blk0": {
>                  "type": "block",
>                  "mgmtdev": "vdpasim_blk",
>                  "vendor_id": 0,
>                  "max_vqs": 1,
>                  "max_vq_size": 256
>              }
>          }
>      }
>
>      # Delete the vDPA device after its use
>      $ vdpa dev del blk0
>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/vdpa/vdpa_sim/vdpa_sim_blk.c | 76 +++++++++++++++++++++++-----
>   1 file changed, 63 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c b/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
> index 643ae3bc62c0..5bfe1c281645 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
> @@ -37,7 +37,6 @@
>   #define VDPASIM_BLK_SEG_MAX	32
>   #define VDPASIM_BLK_VQ_NUM	1
>   
> -static struct vdpasim *vdpasim_blk_dev;
>   static char vdpasim_blk_id[VIRTIO_BLK_ID_BYTES] = "vdpa_blk_sim";
>   
>   static bool vdpasim_blk_check_range(u64 start_sector, size_t range_size)
> @@ -241,11 +240,23 @@ static void vdpasim_blk_get_config(struct vdpasim *vdpasim, void *config)
>   	blk_config->blk_size = cpu_to_vdpasim32(vdpasim, SECTOR_SIZE);
>   }
>   
> -static int __init vdpasim_blk_init(void)
> +static void vdpasim_blk_mgmtdev_release(struct device *dev)
> +{
> +}
> +
> +static struct device vdpasim_blk_mgmtdev = {
> +	.init_name = "vdpasim_blk",
> +	.release = vdpasim_blk_mgmtdev_release,
> +};
> +
> +static int vdpasim_blk_dev_add(struct vdpa_mgmt_dev *mdev, const char *name)
>   {
>   	struct vdpasim_dev_attr dev_attr = {};
> +	struct vdpasim *simdev;
>   	int ret;
>   
> +	dev_attr.mgmt_dev = mdev;
> +	dev_attr.name = name;
>   	dev_attr.id = VIRTIO_ID_BLOCK;
>   	dev_attr.supported_features = VDPASIM_BLK_FEATURES;
>   	dev_attr.nvqs = VDPASIM_BLK_VQ_NUM;
> @@ -254,29 +265,68 @@ static int __init vdpasim_blk_init(void)
>   	dev_attr.work_fn = vdpasim_blk_work;
>   	dev_attr.buffer_size = VDPASIM_BLK_CAPACITY << SECTOR_SHIFT;
>   
> -	vdpasim_blk_dev = vdpasim_create(&dev_attr);
> -	if (IS_ERR(vdpasim_blk_dev)) {
> -		ret = PTR_ERR(vdpasim_blk_dev);
> -		goto out;
> -	}
> +	simdev = vdpasim_create(&dev_attr);
> +	if (IS_ERR(simdev))
> +		return PTR_ERR(simdev);
>   
> -	ret = vdpa_register_device(&vdpasim_blk_dev->vdpa, VDPASIM_BLK_VQ_NUM);
> +	ret = _vdpa_register_device(&simdev->vdpa, VDPASIM_BLK_VQ_NUM);
>   	if (ret)
>   		goto put_dev;
>   
>   	return 0;
>   
>   put_dev:
> -	put_device(&vdpasim_blk_dev->vdpa.dev);
> -out:
> +	put_device(&simdev->vdpa.dev);
>   	return ret;
>   }
>   
> -static void __exit vdpasim_blk_exit(void)
> +static void vdpasim_blk_dev_del(struct vdpa_mgmt_dev *mdev,
> +				struct vdpa_device *dev)
>   {
> -	struct vdpa_device *vdpa = &vdpasim_blk_dev->vdpa;
> +	struct vdpasim *simdev = container_of(dev, struct vdpasim, vdpa);
> +
> +	_vdpa_unregister_device(&simdev->vdpa);
> +}
> +
> +static const struct vdpa_mgmtdev_ops vdpasim_blk_mgmtdev_ops = {
> +	.dev_add = vdpasim_blk_dev_add,
> +	.dev_del = vdpasim_blk_dev_del
> +};
>   
> -	vdpa_unregister_device(vdpa);
> +static struct virtio_device_id id_table[] = {
> +	{ VIRTIO_ID_BLOCK, VIRTIO_DEV_ANY_ID },
> +	{ 0 },
> +};
> +
> +static struct vdpa_mgmt_dev mgmt_dev = {
> +	.device = &vdpasim_blk_mgmtdev,
> +	.id_table = id_table,
> +	.ops = &vdpasim_blk_mgmtdev_ops,
> +};
> +
> +static int __init vdpasim_blk_init(void)
> +{
> +	int ret;
> +
> +	ret = device_register(&vdpasim_blk_mgmtdev);
> +	if (ret)
> +		return ret;
> +
> +	ret = vdpa_mgmtdev_register(&mgmt_dev);
> +	if (ret)
> +		goto parent_err;
> +
> +	return 0;
> +
> +parent_err:
> +	device_unregister(&vdpasim_blk_mgmtdev);
> +	return ret;
> +}
> +
> +static void __exit vdpasim_blk_exit(void)
> +{
> +	vdpa_mgmtdev_unregister(&mgmt_dev);
> +	device_unregister(&vdpasim_blk_mgmtdev);
>   }
>   
>   module_init(vdpasim_blk_init)

