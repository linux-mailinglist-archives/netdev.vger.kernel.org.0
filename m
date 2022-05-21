Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A909D52FA0C
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 10:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243095AbiEUIgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 04:36:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241392AbiEUIgi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 04:36:38 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DF9959BA5;
        Sat, 21 May 2022 01:36:35 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id e2so2568142wrc.1;
        Sat, 21 May 2022 01:36:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=N7GQcxlQmzuFm2GdLfuNosKdxkt6SYCMhr68Bo/2CKY=;
        b=XwWwu7Z/xPBN19Q3XQRw1hX/M0t7sm82KatyyXMRAcxgRHTUkPP/Yoe4o/vjCtinnx
         jTG1VEhVc1G3VBXTYul1SFutU7LrdiN45TSmaiKOU2akPit5b1KFwDh7dAd8n15fxjZa
         QIdjkt02zY5r90zssnxaIawEziLiI2fUgAI5JNCsfY8kPUsGDNNCFrXuCTNKylJ3c5NU
         7+R1d3w4psYatktbjL9c3tZtb6fEdBQFhHPEhcMVBW1RQhrMXOsuYM5WEoHBJI3nSuDE
         Rab2r7OCWjkyJtKPJZoiECs9LsqpmWUJ3niXsEyqM2lVPnijhTgElL+UZVkvqdLpvSbG
         PgUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=N7GQcxlQmzuFm2GdLfuNosKdxkt6SYCMhr68Bo/2CKY=;
        b=foF8n4NUxjuYbPGlk11/QFbBk83lF15WdbjetZq8iXrISOSA1aNW0CJrokqIbLW7uH
         INWHfkcxZBfRfMM9T7zIkTypRtuOzd8mHxXY/yyonrNMUx+MzvPd8o2r0PwS0/sge4um
         GTX61HEoUb48hkOSbjq85nssozcesaxbL4pSKQJkrg27+QZNRftobpg4ZWmgYb8TRXPK
         rybEM0kunYOUUmOFyeC6vXawliOrsN6yFkM4AUV7s1e0CnQZ4SaFNzP6rSFE2gvA6Kx9
         kjPe05UvPUoLPuGy2NDSvOQPeEB1PnbjSNTFERi9N/0PJ69/lWnrGIvD3e4qy2MuKoDX
         PGMA==
X-Gm-Message-State: AOAM530jOsopEmp9sfhvkJj1FDHxSd24JTL1bHWiBEOrsawB9XpYJyWq
        scpjFPrOKUJI7+kxCo6ft0Y=
X-Google-Smtp-Source: ABdhPJwWdVCCSUaF6RxpyV4z+S0vfuk4oGrrixWd5wMdXgozc0XB6f56JRZ5J7/AAxX2UXqm+ZlAMg==
X-Received: by 2002:a05:6000:1565:b0:20e:651d:7ff4 with SMTP id 5-20020a056000156500b0020e651d7ff4mr11505802wrz.641.1653122193583;
        Sat, 21 May 2022 01:36:33 -0700 (PDT)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id j39-20020a05600c48a700b00397071b10dfsm3734512wmp.10.2022.05.21.01.36.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 May 2022 01:36:33 -0700 (PDT)
Date:   Sat, 21 May 2022 09:36:30 +0100
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Stefano Garzarella <sgarzare@redhat.com>,
        Longpeng <longpeng2@huawei.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>, martinh@xilinx.com,
        hanand@xilinx.com, Si-Wei Liu <si-wei.liu@oracle.com>,
        dinang@xilinx.com, Eli Cohen <elic@nvidia.com>, lvivier@redhat.com,
        pabloc@xilinx.com, gautam.dawar@amd.com,
        Xie Yongji <xieyongji@bytedance.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        tanuj.kamde@amd.com, Wu Zongyong <wuzongyong@linux.alibaba.com>,
        martinpo@xilinx.com, lulu@redhat.com, ecree.xilinx@gmail.com,
        Parav Pandit <parav@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Zhang Min <zhang.min9@zte.com.cn>
Subject: Re: [PATCH 3/4] vhost-vdpa: uAPI to stop the device
Message-ID: <20220521083630.GA5298@gmail.com>
Mail-Followup-To: Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Stefano Garzarella <sgarzare@redhat.com>,
        Longpeng <longpeng2@huawei.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>, martinh@xilinx.com,
        hanand@xilinx.com, Si-Wei Liu <si-wei.liu@oracle.com>,
        dinang@xilinx.com, Eli Cohen <elic@nvidia.com>, lvivier@redhat.com,
        pabloc@xilinx.com, gautam.dawar@amd.com,
        Xie Yongji <xieyongji@bytedance.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        tanuj.kamde@amd.com, Wu Zongyong <wuzongyong@linux.alibaba.com>,
        martinpo@xilinx.com, lulu@redhat.com, ecree.xilinx@gmail.com,
        Parav Pandit <parav@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Zhang Min <zhang.min9@zte.com.cn>
References: <20220520172325.980884-1-eperezma@redhat.com>
 <20220520172325.980884-4-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220520172325.980884-4-eperezma@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 20, 2022 at 07:23:24PM +0200, Eugenio Pérez wrote:
> The ioctl adds support for stop the device from userspace.
> 
> Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
> ---
>  drivers/vhost/vdpa.c       | 18 ++++++++++++++++++
>  include/uapi/linux/vhost.h |  3 +++
>  2 files changed, 21 insertions(+)
> 
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index a325bc259afb..da4a8c709bc1 100644
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
> +	if (copy_to_user(argp, &stop, sizeof(stop)))

You want to use copy_from_user() here.

Martin

> +		return -EFAULT;
> +
> +	return ops->stop(vdpa, stop);
> +}
> +
>  static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
>  				   void __user *argp)
>  {
> @@ -649,6 +664,9 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
>  	case VHOST_VDPA_GET_VQS_COUNT:
>  		r = vhost_vdpa_get_vqs_count(v, argp);
>  		break;
> +	case VHOST_STOP:
> +		r = vhost_vdpa_stop(v, argp);
> +		break;
>  	default:
>  		r = vhost_dev_ioctl(&v->vdev, cmd, argp);
>  		if (r == -ENOIOCTLCMD)
> diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
> index cab645d4a645..e7526968ab0c 100644
> --- a/include/uapi/linux/vhost.h
> +++ b/include/uapi/linux/vhost.h
> @@ -171,4 +171,7 @@
>  #define VHOST_VDPA_SET_GROUP_ASID	_IOW(VHOST_VIRTIO, 0x7C, \
>  					     struct vhost_vring_state)
>  
> +/* Stop or resume a device so it does not process virtqueue requests anymore */
> +#define VHOST_STOP			_IOW(VHOST_VIRTIO, 0x7D, int)
> +
>  #endif
> -- 
> 2.27.0
