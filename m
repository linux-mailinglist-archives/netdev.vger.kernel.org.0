Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C14AD491CA6
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 04:18:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240437AbiARDRO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 22:17:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:52947 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344130AbiARDHt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 22:07:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642475268;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9CQmErdVbSRr9mtW1+GyxSplP9tubMADIUUmh9Y+ayg=;
        b=RRs87RMkYCJl+mUZsopuZkbmBCLWShGxMcq3HiFwVU3BbaoXLrXpVHmWY09WUOXYY+W0cw
        wtsopjdvkYnRnzJRWHv2k54tW6JDDFT3kQPKc1GO1eUg7zc2hOUwMgAn0lYWClXTsDw8Nf
        /jYQBjHw0Z0fxtq8eBUPM87CY8UEvvg=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-589-3XTuRXQ6N9-_Pq9SxH11lg-1; Mon, 17 Jan 2022 22:07:47 -0500
X-MC-Unique: 3XTuRXQ6N9-_Pq9SxH11lg-1
Received: by mail-pf1-f199.google.com with SMTP id f24-20020aa782d8000000b004bc00caa4c0so7290597pfn.3
        for <netdev@vger.kernel.org>; Mon, 17 Jan 2022 19:07:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9CQmErdVbSRr9mtW1+GyxSplP9tubMADIUUmh9Y+ayg=;
        b=3WvexB7XGGNPRRmMWmFrOxK+zfL+6R/VKBLD+WwSrB8peglVHWw03QBfxMsI3ykb+s
         oehncVOdVQ4r3rPl419JmfRoA3XupTGX1v+mgMk0EVAjrX79ST7mpqIiMpWkF7Eyijw6
         G24/NXeI5Bx2eyw29rBhR49pDNnwseS6AAR9L+nFXA4loWB5mMAyfgU9cNs0IHIfWjDu
         v7qP3iI6eKWdpbtoyaH7+ITeZd7QRByEabb/FFrgjqA4jF3AFfW8Jgwa+DdNYiut7KMZ
         sS/bNS6QD/xquj5UnmDgTzyHOsgjIvUY3Ck0vO6+eNMYW0p0lAJmHhsDl+vQvex3sqRe
         3QTA==
X-Gm-Message-State: AOAM532P43qyUiPpaceXFdQybrvkFw84De0jG+cHl+MJmZrrWEFXTiEC
        58I0gvxFjHegWxn5HOQq6f+LKjm6pdvkdWIdurtojqQe6Br7u5lJ8Fp1ZbU5MKK00SO1pq/wUTn
        JHs1sjfDPWW3KlalG
X-Received: by 2002:a63:9dc8:: with SMTP id i191mr21688278pgd.601.1642475265999;
        Mon, 17 Jan 2022 19:07:45 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyGn88ixeCz13kpjGb4SysE+JIuenybALI9UvqarO/71VSQGXiBlHPncz3hIYzN/LcoVqqxiA==
X-Received: by 2002:a63:9dc8:: with SMTP id i191mr21688268pgd.601.1642475265770;
        Mon, 17 Jan 2022 19:07:45 -0800 (PST)
Received: from [10.72.13.83] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a19sm4801961pfh.198.2022.01.17.19.07.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jan 2022 19:07:45 -0800 (PST)
Message-ID: <1a26d7b3-1020-50c5-f0a3-ebc645cdcddf@redhat.com>
Date:   Tue, 18 Jan 2022 11:07:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: [RFC 2/3] vdpa: support exposing the count of vqs to userspace
Content-Language: en-US
To:     "Longpeng(Mike)" <longpeng2@huawei.com>, mst@redhat.com,
        sgarzare@redhat.com, stefanha@redhat.com
Cc:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        arei.gonglei@huawei.com, yechuan@huawei.com,
        huangzhichao@huawei.com
References: <20220117092921.1573-1-longpeng2@huawei.com>
 <20220117092921.1573-3-longpeng2@huawei.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220117092921.1573-3-longpeng2@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/1/17 下午5:29, Longpeng(Mike) 写道:
> From: Longpeng <longpeng2@huawei.com>
>
> - GET_VQS_COUNT: the count of virtqueues that exposed
>
> Signed-off-by: Longpeng <longpeng2@huawei.com>
> ---
>   drivers/vhost/vdpa.c       | 13 +++++++++++++
>   include/uapi/linux/vhost.h |  3 +++
>   2 files changed, 16 insertions(+)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 1eea14a4ea56..c1074278fc6b 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -369,6 +369,16 @@ static long vhost_vdpa_get_config_size(struct vhost_vdpa *v, u32 __user *argp)
>   	return 0;
>   }
>   
> +static long vhost_vdpa_get_vqs_count(struct vhost_vdpa *v, u32 __user *argp)
> +{
> +	struct vdpa_device *vdpa = v->vdpa;


While at it, I think it's better to change vdpa->nvqs to use u32?

Thanks


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
> @@ -509,6 +519,9 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
>   	case VHOST_VDPA_GET_CONFIG_SIZE:
>   		r = vhost_vdpa_get_config_size(v, argp);
>   		break;
> +	case VHOST_VDPA_GET_VQS_COUNT:
> +		r = vhost_vdpa_get_vqs_count(v, argp);
> +		break;
>   	default:
>   		r = vhost_dev_ioctl(&v->vdev, cmd, argp);
>   		if (r == -ENOIOCTLCMD)
> diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
> index bc74e95a273a..5d99e7c242a2 100644
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

