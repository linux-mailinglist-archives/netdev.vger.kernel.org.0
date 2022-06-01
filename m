Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77DD753A386
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 13:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352472AbiFALEA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 07:04:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345880AbiFALD7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 07:03:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D38A2880EB
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 04:03:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654081437;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Tgtl50+cOg4p6sNpA44wE53+ToNHu8zqxjdgIaqTCDg=;
        b=KJrj5FW2RXPCJAq4+3QdbEBw5gCI/Q7id2HOQ8cvmQpEJ5KTHqjEj+74oZODnZB3FLwF6x
        lEY1Pn7y9LVZ/1rG6CotSiQjfkUzVFQoXgTUo1H3CMUaRu3wxb2YnKGTny4qM90le4wUD0
        zKrlV4C7fEnVVqXpqhQCryfm9qLNG8g=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-628-XrLpnGuKN6GuvF1a9phNmw-1; Wed, 01 Jun 2022 07:03:54 -0400
X-MC-Unique: XrLpnGuKN6GuvF1a9phNmw-1
Received: by mail-wr1-f69.google.com with SMTP id bv12-20020a0560001f0c00b0020e359b3852so227741wrb.14
        for <netdev@vger.kernel.org>; Wed, 01 Jun 2022 04:03:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Tgtl50+cOg4p6sNpA44wE53+ToNHu8zqxjdgIaqTCDg=;
        b=rgCTWJdSAUDQWc5CmHYbr6NIwyqXt7psZggTi3gk6GRIht31PVelSbQbkjUnjGQpH7
         LvEY416dy+t/ZO4GkPc/YyX5owHWVzt2rthyeG5YgTvoSRbvgEH7dfzGO5XmvaVrVo4q
         jpZh2k/X76esF9lg24sxxNwUli+VIlmfVWwNJv5gox9R7mrdT0sx7FN/p3pKr2CA9lqe
         EzBmucehxMqEskuqbZIlLNZ/R/LJjI7uI4zI2razbTCS/U0gUtIW4JT49JMOTLh1qG/s
         MLYNNqg5QjdL0bhAqxuGVxayW+czagUPL1jwPVPHy+S3O2jetRIgPI30EIwWwFPZa2iY
         EaZQ==
X-Gm-Message-State: AOAM532CNqqmYXP8qYtr+ejhcttrcc3QMcgRhwUw9TnuIXktJJhcbhCZ
        +nSiCpksjrRKcf2K0EJUdiOygoOA9ZMmBzvZ6uW/NtRuOu8w7H9aFg2YvzsTxb/DHFepzATmVVO
        tvq1zqVC95XmMbwEn
X-Received: by 2002:a5d:5145:0:b0:210:55c:4790 with SMTP id u5-20020a5d5145000000b00210055c4790mr26849896wrt.714.1654081432923;
        Wed, 01 Jun 2022 04:03:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzgKD3kkMJ5yY3Qc/mDpdOAlutZgyiyXLasWfkgGa3quLXJOeNWzJU9s8z4oSyg2SRWcOUapA==
X-Received: by 2002:a5d:5145:0:b0:210:55c:4790 with SMTP id u5-20020a5d5145000000b00210055c4790mr26849873wrt.714.1654081432646;
        Wed, 01 Jun 2022 04:03:52 -0700 (PDT)
Received: from redhat.com ([2.52.157.68])
        by smtp.gmail.com with ESMTPSA id q15-20020adff50f000000b002102e6b757csm1518657wro.90.2022.06.01.04.03.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jun 2022 04:03:51 -0700 (PDT)
Date:   Wed, 1 Jun 2022 07:03:44 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        netdev@vger.kernel.org, martinh@xilinx.com,
        Stefano Garzarella <sgarzare@redhat.com>, martinpo@xilinx.com,
        lvivier@redhat.com, pabloc@xilinx.com,
        Parav Pandit <parav@nvidia.com>, Eli Cohen <elic@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Zhang Min <zhang.min9@zte.com.cn>,
        Wu Zongyong <wuzongyong@linux.alibaba.com>, lulu@redhat.com,
        Zhu Lingshan <lingshan.zhu@intel.com>, Piotr.Uminski@intel.com,
        Si-Wei Liu <si-wei.liu@oracle.com>, ecree.xilinx@gmail.com,
        gautam.dawar@amd.com, habetsm.xilinx@gmail.com,
        tanuj.kamde@amd.com, hanand@xilinx.com, dinang@xilinx.com,
        Longpeng <longpeng2@huawei.com>
Subject: Re: [PATCH v4 3/4] vhost-vdpa: uAPI to stop the device
Message-ID: <20220601070303-mutt-send-email-mst@kernel.org>
References: <20220526124338.36247-1-eperezma@redhat.com>
 <20220526124338.36247-4-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220526124338.36247-4-eperezma@redhat.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 26, 2022 at 02:43:37PM +0200, Eugenio Pérez wrote:
> The ioctl adds support for stop the device from userspace.
> 
> Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
> ---
>  drivers/vhost/vdpa.c       | 18 ++++++++++++++++++
>  include/uapi/linux/vhost.h | 14 ++++++++++++++
>  2 files changed, 32 insertions(+)
> 
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 32713db5831d..d1d19555c4b7 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -478,6 +478,21 @@ static long vhost_vdpa_get_vqs_count(struct vhost_vdpa *v, u32 __user *argp)
>  	return 0;
>  }
>  
> +static long vhost_vdpa_stop(struct vhost_vdpa *v, u32 __user *argp)
> +{
> +	struct vdpa_device *vdpa = v->vdpa;
> +	const struct vdpa_config_ops *ops = vdpa->config;
> +	int stop;
> +
> +	if (!ops->stop)
> +		return -EOPNOTSUPP;
> +
> +	if (copy_from_user(&stop, argp, sizeof(stop)))
> +		return -EFAULT;
> +
> +	return ops->stop(vdpa, stop);
> +}
> +
>  static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
>  				   void __user *argp)
>  {
> @@ -650,6 +665,9 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
>  	case VHOST_VDPA_GET_VQS_COUNT:
>  		r = vhost_vdpa_get_vqs_count(v, argp);
>  		break;
> +	case VHOST_VDPA_STOP:
> +		r = vhost_vdpa_stop(v, argp);
> +		break;
>  	default:
>  		r = vhost_dev_ioctl(&v->vdev, cmd, argp);
>  		if (r == -ENOIOCTLCMD)
> diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
> index cab645d4a645..c7e47b29bf61 100644
> --- a/include/uapi/linux/vhost.h
> +++ b/include/uapi/linux/vhost.h
> @@ -171,4 +171,18 @@
>  #define VHOST_VDPA_SET_GROUP_ASID	_IOW(VHOST_VIRTIO, 0x7C, \
>  					     struct vhost_vring_state)
>  
> +/* Stop or resume a device so it does not process virtqueue requests anymore
> + *
> + * After the return of ioctl with stop != 0, the device must finish any
> + * pending operations like in flight requests. It must also preserve all
> + * the necessary state (the virtqueue vring base plus the possible device
> + * specific states) that is required for restoring in the future. The
> + * device must not change its configuration after that point.
> + *
> + * After the return of ioctl with stop == 0, the device can continue
> + * processing buffers as long as typical conditions are met (vq is enabled,
> + * DRIVER_OK status bit is enabled, etc).
> + */
> +#define VHOST_VDPA_STOP			_IOW(VHOST_VIRTIO, 0x7D, int)
> +
>  #endif

I wonder how does this interact with the admin vq idea.
I.e. if we stop all VQs then apparently admin vq can't
work either ...
Thoughts?

> -- 
> 2.31.1

