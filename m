Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56CE255E989
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346769AbiF1NoB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 09:44:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346790AbiF1Nnw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 09:43:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3111718B2B
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 06:43:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656423828;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=abXoIOqyAhxt2c9XGMOMQUpyKJ4rqMJ6hybu9hpX0PI=;
        b=fKPXuQ3gYZWullknpFnkPzlUMVAa3CHtv5OJN9N7AG36R9ZAqBau4GtSxzmVLGbpStZPie
        NcTV57LGiGF7d9kJCIpu66amSn7L3XU0Jwo6SjOuRgaFtfgQyEOVLZd1h1fhmEhrV+bpVu
        E1G2eCLFiaIN60H2AKYISpEiX8oRl2w=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-150-z9jL5y31Nhe9QkTF6Cp5Tg-1; Tue, 28 Jun 2022 09:43:46 -0400
X-MC-Unique: z9jL5y31Nhe9QkTF6Cp5Tg-1
Received: by mail-wm1-f72.google.com with SMTP id o28-20020a05600c511c00b003a04f97f27aso1583573wms.9
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 06:43:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=abXoIOqyAhxt2c9XGMOMQUpyKJ4rqMJ6hybu9hpX0PI=;
        b=jjE+WHAE+W7MufPNWNoP8bJkk1nUs1pPeqCNNq7mzekLMioCREIE6WC36PRZOa0lEA
         0icDp+fq/kmO7KYhsB+oUPoHY4Rb/FvYSMNIl04W9wLeVlj5Rz90q75qM1x3U4s/RP94
         rea9M1hK6LjPa26bOPkvxOudqwU6VA9ZS7gbh+s/XXGweig89ze72HUy5TetunHuUMwu
         uMissokCaBkI2WeYqIBNHbhVLVkWB/jemcjzvtgEx3FnL95klCjp3P/YDKtBjcVDpMf1
         dEEuIMsFnrmOizGumkFr/iUxn24p+SDERXnPSNpsryuy2ya1iID9fmKh51cBzJrGy6Tf
         wxsA==
X-Gm-Message-State: AJIora/KlFs++xnrEqAAuoumMHSDCHJ7jhgK//DiVkYR014mvMV1+jb8
        PJgDE6w6YDwq8JZDJhOhTh9ze6wRPpIC2zkzTYLlIanDbEjMaXPsMDe+2e2v1MxFruJJz6Icpb2
        oveymKuW1cgoWnTBo
X-Received: by 2002:a05:6000:1a8b:b0:219:af0c:ddf8 with SMTP id f11-20020a0560001a8b00b00219af0cddf8mr16993632wry.142.1656423824960;
        Tue, 28 Jun 2022 06:43:44 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1ulCbVDwMIzdNmmQrb5kCw0weokx6fGGdIcmA6shirIYjb3LYAkbgo0mXLYbXoBYhaHKES0mQ==
X-Received: by 2002:a05:6000:1a8b:b0:219:af0c:ddf8 with SMTP id f11-20020a0560001a8b00b00219af0cddf8mr16993581wry.142.1656423824625;
        Tue, 28 Jun 2022 06:43:44 -0700 (PDT)
Received: from sgarzare-redhat (host-87-11-6-149.retail.telecomitalia.it. [87.11.6.149])
        by smtp.gmail.com with ESMTPSA id j18-20020a05600c42d200b003a02b9c47e4sm24072440wme.27.2022.06.28.06.43.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 06:43:44 -0700 (PDT)
Date:   Tue, 28 Jun 2022 15:43:40 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>
Cc:     netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        lulu@redhat.com, tanuj.kamde@amd.com,
        Si-Wei Liu <si-wei.liu@oracle.com>, Piotr.Uminski@intel.com,
        habetsm.xilinx@gmail.com, gautam.dawar@amd.com, pabloc@xilinx.com,
        Zhu Lingshan <lingshan.zhu@intel.com>, lvivier@redhat.com,
        Longpeng <longpeng2@huawei.com>, dinang@xilinx.com,
        martinh@xilinx.com, martinpo@xilinx.com,
        Eli Cohen <elic@nvidia.com>, ecree.xilinx@gmail.com,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, hanand@xilinx.com,
        Xie Yongji <xieyongji@bytedance.com>,
        Zhang Min <zhang.min9@zte.com.cn>
Subject: Re: [PATCH v6 2/4] vhost-vdpa: introduce SUSPEND backend feature bit
Message-ID: <20220628134340.5fla7surd34bwnq3@sgarzare-redhat>
References: <20220623160738.632852-1-eperezma@redhat.com>
 <20220623160738.632852-3-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220623160738.632852-3-eperezma@redhat.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 23, 2022 at 06:07:36PM +0200, Eugenio Pérez wrote:
>Userland knows if it can suspend the device or not by checking this feature
>bit.
>
>It's only offered if the vdpa driver backend implements the suspend()
>operation callback, and to offer it or userland to ack it if the backend
>does not offer that callback is an error.

Should we document in the previous patch that the callback must be 
implemented only if the drive/device support it?

The rest LGTM although I have a doubt whether it is better to move this 
patch after patch 3, or merge it with patch 3, for bisectability since 
we enable the feature here but if the userspace calls ioctl() with 
VHOST_VDPA_SUSPEND we reply back that it is not supported.

Thanks,
Stefano

>
>Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
>---
> drivers/vhost/vdpa.c             | 16 +++++++++++++++-
> include/uapi/linux/vhost_types.h |  2 ++
> 2 files changed, 17 insertions(+), 1 deletion(-)
>
>diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
>index 23dcbfdfa13b..3d636e192061 100644
>--- a/drivers/vhost/vdpa.c
>+++ b/drivers/vhost/vdpa.c
>@@ -347,6 +347,14 @@ static long vhost_vdpa_set_config(struct vhost_vdpa *v,
> 	return 0;
> }
>
>+static bool vhost_vdpa_can_suspend(const struct vhost_vdpa *v)
>+{
>+	struct vdpa_device *vdpa = v->vdpa;
>+	const struct vdpa_config_ops *ops = vdpa->config;
>+
>+	return ops->suspend;
>+}
>+
> static long vhost_vdpa_get_features(struct vhost_vdpa *v, u64 __user *featurep)
> {
> 	struct vdpa_device *vdpa = v->vdpa;
>@@ -577,7 +585,11 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
> 	if (cmd == VHOST_SET_BACKEND_FEATURES) {
> 		if (copy_from_user(&features, featurep, sizeof(features)))
> 			return -EFAULT;
>-		if (features & ~VHOST_VDPA_BACKEND_FEATURES)
>+		if (features & ~(VHOST_VDPA_BACKEND_FEATURES |
>+				 BIT_ULL(VHOST_BACKEND_F_SUSPEND)))
>+			return -EOPNOTSUPP;
>+		if ((features & BIT_ULL(VHOST_BACKEND_F_SUSPEND)) &&
>+		     !vhost_vdpa_can_suspend(v))
> 			return -EOPNOTSUPP;
> 		vhost_set_backend_features(&v->vdev, features);
> 		return 0;
>@@ -628,6 +640,8 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
> 		break;
> 	case VHOST_GET_BACKEND_FEATURES:
> 		features = VHOST_VDPA_BACKEND_FEATURES;
>+		if (vhost_vdpa_can_suspend(v))
>+			features |= BIT_ULL(VHOST_BACKEND_F_SUSPEND);
> 		if (copy_to_user(featurep, &features, sizeof(features)))
> 			r = -EFAULT;
> 		break;
>diff --git a/include/uapi/linux/vhost_types.h b/include/uapi/linux/vhost_types.h
>index 634cee485abb..1bdd6e363f4c 100644
>--- a/include/uapi/linux/vhost_types.h
>+++ b/include/uapi/linux/vhost_types.h
>@@ -161,5 +161,7 @@ struct vhost_vdpa_iova_range {
>  * message
>  */
> #define VHOST_BACKEND_F_IOTLB_ASID  0x3
>+/* Device can be suspended */
>+#define VHOST_BACKEND_F_SUSPEND  0x4
>
> #endif
>-- 
>2.31.1
>

