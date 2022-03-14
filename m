Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 913D84D7AA1
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 07:04:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234963AbiCNGFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 02:05:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236314AbiCNGFR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 02:05:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DA45D10FFE
        for <netdev@vger.kernel.org>; Sun, 13 Mar 2022 23:04:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647237847;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2XWjbqYvqLIcliuu04CPptAo3wxpLIB8KYTjyLRm6Co=;
        b=b957BwVgMAX529zRUk62js2uw9oTrwCMyhYNP4vOjryb4a4DiXEHpVf9+y1UCdsUIqVwq0
        1syFwW34/qvcEwj+Kkl4XvoPBQys5+7ti0/sE8Ul1xXZUxT2ImgXSv9krM9F+F4pIoKJpz
        4PD3aVSvEOYs3M03oRvcq1w2dzH5Glw=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-645-8glDWMt7NGOprPcQ-CB_nw-1; Mon, 14 Mar 2022 02:04:05 -0400
X-MC-Unique: 8glDWMt7NGOprPcQ-CB_nw-1
Received: by mail-pg1-f197.google.com with SMTP id l6-20020a637006000000b003811a27370aso4705777pgc.2
        for <netdev@vger.kernel.org>; Sun, 13 Mar 2022 23:04:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=2XWjbqYvqLIcliuu04CPptAo3wxpLIB8KYTjyLRm6Co=;
        b=ul3hKQASYEI4MSGqYdNFsEwgtoHwlFSa/Hz2K6/MMx7MDVpVtWIS3uZP/Zre3JrHWp
         e0df14cjuAXeGb7TxN4ABcjP0SOVD4NpB5QlqqBxRfPoc3sx5UZ2gbpkgd+5l9zAVNFI
         YmGNDtEJ2ldWRVC1nkWQru9evUcYm4He/iXOpQhFOmcBjkRdz2tKD2VDy9eJYlC9si/p
         wXUnq4ak10sap2SqZWDk/3xae6b5+gANCj1tXEzC16f8GrQU9ekFcufXITiVj7kpREvn
         XZi+nHI9coDo8oJHZeL7xxVPZB1HhwmD3Y+5r5+qhDCUN1RzUJjX08nqIQDrApT1VDo5
         r5dA==
X-Gm-Message-State: AOAM531jd9P5+jRxOmndp3vSlYeRVAayXkMKv+bzMa19po7oL/h26h2p
        BcjXbYeRFqXHdV9zsHb1KwEOWIvLjn/Nq3zn+0zpEybR/fYVTrqk9Vg1bWkF/wc21gyn/+OvoWR
        Y+dqEzqi701NPCtZI
X-Received: by 2002:a63:7e43:0:b0:374:75ce:4d80 with SMTP id o3-20020a637e43000000b0037475ce4d80mr18764263pgn.589.1647237844687;
        Sun, 13 Mar 2022 23:04:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzO7HvxYfUJ+fU3+y7Rq7dQeKdgwueK3KHb/k4WgR6BCnKo7nRgyKt6rA8fOZWbZufNvs0EAQ==
X-Received: by 2002:a63:7e43:0:b0:374:75ce:4d80 with SMTP id o3-20020a637e43000000b0037475ce4d80mr18764244pgn.589.1647237844397;
        Sun, 13 Mar 2022 23:04:04 -0700 (PDT)
Received: from [10.72.13.210] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t8-20020aa79468000000b004f764340d8bsm17045588pfq.92.2022.03.13.23.04.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Mar 2022 23:04:03 -0700 (PDT)
Message-ID: <7f7553d0-2217-6122-227a-a3bfd5706ac5@redhat.com>
Date:   Mon, 14 Mar 2022 14:03:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.2
Subject: Re: [PATCH v2 2/2] vdpa: support exposing the count of vqs to
 userspace
Content-Language: en-US
To:     "Longpeng(Mike)" <longpeng2@huawei.com>, mst@redhat.com,
        sgarzare@redhat.com, stefanha@redhat.com
Cc:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        arei.gonglei@huawei.com, yechuan@huawei.com,
        huangzhichao@huawei.com, gdawar@xilinx.com
References: <20220310072051.2175-1-longpeng2@huawei.com>
 <20220310072051.2175-3-longpeng2@huawei.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220310072051.2175-3-longpeng2@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/3/10 下午3:20, Longpeng(Mike) 写道:
> From: Longpeng <longpeng2@huawei.com>
>
> - GET_VQS_COUNT: the count of virtqueues that exposed
>
> And change vdpa_device.nvqs and vhost_vdpa.nvqs to use u32.


Patch looks good, a nit is that we'd better use a separate patch for the 
u32 converting.

Thanks


>
> Signed-off-by: Longpeng <longpeng2@huawei.com>
> ---
>   drivers/vdpa/vdpa.c        |  6 +++---
>   drivers/vhost/vdpa.c       | 23 +++++++++++++++++++----
>   include/linux/vdpa.h       |  6 +++---
>   include/uapi/linux/vhost.h |  3 +++
>   4 files changed, 28 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
> index 1ea5254..2b75c00 100644
> --- a/drivers/vdpa/vdpa.c
> +++ b/drivers/vdpa/vdpa.c
> @@ -232,7 +232,7 @@ static int vdpa_name_match(struct device *dev, const void *data)
>   	return (strcmp(dev_name(&vdev->dev), data) == 0);
>   }
>   
> -static int __vdpa_register_device(struct vdpa_device *vdev, int nvqs)
> +static int __vdpa_register_device(struct vdpa_device *vdev, u32 nvqs)
>   {
>   	struct device *dev;
>   
> @@ -257,7 +257,7 @@ static int __vdpa_register_device(struct vdpa_device *vdev, int nvqs)
>    *
>    * Return: Returns an error when fail to add device to vDPA bus
>    */
> -int _vdpa_register_device(struct vdpa_device *vdev, int nvqs)
> +int _vdpa_register_device(struct vdpa_device *vdev, u32 nvqs)
>   {
>   	if (!vdev->mdev)
>   		return -EINVAL;
> @@ -274,7 +274,7 @@ int _vdpa_register_device(struct vdpa_device *vdev, int nvqs)
>    *
>    * Return: Returns an error when fail to add to vDPA bus
>    */
> -int vdpa_register_device(struct vdpa_device *vdev, int nvqs)
> +int vdpa_register_device(struct vdpa_device *vdev, u32 nvqs)
>   {
>   	int err;
>   
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 605c7ae..69b3f05 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -42,7 +42,7 @@ struct vhost_vdpa {
>   	struct device dev;
>   	struct cdev cdev;
>   	atomic_t opened;
> -	int nvqs;
> +	u32 nvqs;
>   	int virtio_id;
>   	int minor;
>   	struct eventfd_ctx *config_ctx;
> @@ -158,7 +158,8 @@ static long vhost_vdpa_set_status(struct vhost_vdpa *v, u8 __user *statusp)
>   	struct vdpa_device *vdpa = v->vdpa;
>   	const struct vdpa_config_ops *ops = vdpa->config;
>   	u8 status, status_old;
> -	int ret, nvqs = v->nvqs;
> +	u32 nvqs = v->nvqs;
> +	int ret;
>   	u16 i;
>   
>   	if (copy_from_user(&status, statusp, sizeof(status)))
> @@ -369,6 +370,16 @@ static long vhost_vdpa_get_config_size(struct vhost_vdpa *v, u32 __user *argp)
>   	return 0;
>   }
>   
> +static long vhost_vdpa_get_vqs_count(struct vhost_vdpa *v, u32 __user *argp)
> +{
> +	struct vdpa_device *vdpa = v->vdpa;
> +
> +	if (copy_to_user(argp, &vdpa->nvqs, sizeof(vdpa->nvqs)))
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +
>   static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
>   				   void __user *argp)
>   {
> @@ -509,6 +520,9 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
>   	case VHOST_VDPA_GET_CONFIG_SIZE:
>   		r = vhost_vdpa_get_config_size(v, argp);
>   		break;
> +	case VHOST_VDPA_GET_VQS_COUNT:
> +		r = vhost_vdpa_get_vqs_count(v, argp);
> +		break;
>   	default:
>   		r = vhost_dev_ioctl(&v->vdev, cmd, argp);
>   		if (r == -ENOIOCTLCMD)
> @@ -965,7 +979,8 @@ static int vhost_vdpa_open(struct inode *inode, struct file *filep)
>   	struct vhost_vdpa *v;
>   	struct vhost_dev *dev;
>   	struct vhost_virtqueue **vqs;
> -	int nvqs, i, r, opened;
> +	int r, opened;
> +	u32 i, nvqs;
>   
>   	v = container_of(inode->i_cdev, struct vhost_vdpa, cdev);
>   
> @@ -1018,7 +1033,7 @@ static int vhost_vdpa_open(struct inode *inode, struct file *filep)
>   
>   static void vhost_vdpa_clean_irq(struct vhost_vdpa *v)
>   {
> -	int i;
> +	u32 i;
>   
>   	for (i = 0; i < v->nvqs; i++)
>   		vhost_vdpa_unsetup_vq_irq(v, i);
> diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
> index a526919..8943a20 100644
> --- a/include/linux/vdpa.h
> +++ b/include/linux/vdpa.h
> @@ -83,7 +83,7 @@ struct vdpa_device {
>   	unsigned int index;
>   	bool features_valid;
>   	bool use_va;
> -	int nvqs;
> +	u32 nvqs;
>   	struct vdpa_mgmt_dev *mdev;
>   };
>   
> @@ -338,10 +338,10 @@ struct vdpa_device *__vdpa_alloc_device(struct device *parent,
>   				       dev_struct, member)), name, use_va), \
>   				       dev_struct, member)
>   
> -int vdpa_register_device(struct vdpa_device *vdev, int nvqs);
> +int vdpa_register_device(struct vdpa_device *vdev, u32 nvqs);
>   void vdpa_unregister_device(struct vdpa_device *vdev);
>   
> -int _vdpa_register_device(struct vdpa_device *vdev, int nvqs);
> +int _vdpa_register_device(struct vdpa_device *vdev, u32 nvqs);
>   void _vdpa_unregister_device(struct vdpa_device *vdev);
>   
>   /**
> diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
> index bc74e95..5d99e7c 100644
> --- a/include/uapi/linux/vhost.h
> +++ b/include/uapi/linux/vhost.h
> @@ -154,4 +154,7 @@
>   /* Get the config size */
>   #define VHOST_VDPA_GET_CONFIG_SIZE	_IOR(VHOST_VIRTIO, 0x79, __u32)
>   
> +/* Get the count of all virtqueues */
> +#define VHOST_VDPA_GET_VQS_COUNT	_IOR(VHOST_VIRTIO, 0x80, __u32)
> +
>   #endif

