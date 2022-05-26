Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0475353508A
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 16:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346770AbiEZOZ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 10:25:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345442AbiEZOZ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 10:25:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 92170C5DB3
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 07:25:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653575120;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=REW5eBj0k51HdxwQT5MIo/NGzv21C0HdYvY4KP3ZBC8=;
        b=M0jwer66FO1jKzkbZzMlpo8pK9DgFNN61BZ6GsTj69BhrHZ4iBQwEnsGYiQ4dPPU9/ghJs
        xdC0HntxO9XqhGP0Oo/Lqas0XyN7+FMrPvlJ2INb2kF01tUD53B7YwTVf2kdlyVXOH1qnb
        ygP/1Id78jKMkMkPQa6KXXj+9xPmIoQ=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-594-kg3QufhJNa-V0pPkEHPT9g-1; Thu, 26 May 2022 10:25:19 -0400
X-MC-Unique: kg3QufhJNa-V0pPkEHPT9g-1
Received: by mail-qk1-f200.google.com with SMTP id g3-20020a05620a108300b006a329bc4da3so1485920qkk.3
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 07:25:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=REW5eBj0k51HdxwQT5MIo/NGzv21C0HdYvY4KP3ZBC8=;
        b=OYDLaztZJ90ueHfI37LDrXXaHjhNFwdiy4tIKVj2RdzKUmPWmWWLX1ECatovLySM5o
         s3Szcidb38i3uU1adEIn1QT5HiqCW5ak8hyOwC06Jrx6Iqd+CKvH6iHJQidrssCpNos1
         8ql/nVWD+tu5rWVudOgIF57Z8CuI82eK5tIoIfDVeHcxiB54FNew0B9fiOkHafTGvk0m
         Kdni7XeeQ+EcUt0p5FaHfxZ+7FgCWmwYtRZ5sdWvcM1evhH0+tYVCS2D8Hr4vk6X/Wr1
         Hk90BfCiOfVmNkM5HdgCAQYmZldnxBMMKhnviGkOVLBaGN9Y/ljQH21RSNp92Hs67FxY
         6oLw==
X-Gm-Message-State: AOAM531gVsOs5FVR3cHwq70Wk23av9sEanllR9GTKo0Hjc/DcEcCMn6M
        xYCkdX4w9pi9dWJWO/lC2I6+/1jH+e7SLlwhTKFGku7IEivrd1hERZQ0IxItTfFVwZV/Tugqk0J
        B602zorsMy5x3n9c4
X-Received: by 2002:a05:6214:27cf:b0:462:6338:f19c with SMTP id ge15-20020a05621427cf00b004626338f19cmr7054552qvb.123.1653575115874;
        Thu, 26 May 2022 07:25:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzx5+bYj+79D3UUpEhK5Xb40CENj+PWoMKEk6jIiMR1TuSf+fgweph1KuVE9X/p4pNnNr7Now==
X-Received: by 2002:a05:6214:27cf:b0:462:6338:f19c with SMTP id ge15-20020a05621427cf00b004626338f19cmr7054515qvb.123.1653575115597;
        Thu, 26 May 2022 07:25:15 -0700 (PDT)
Received: from sgarzare-redhat (host-87-12-25-16.business.telecomitalia.it. [87.12.25.16])
        by smtp.gmail.com with ESMTPSA id z20-20020a05622a061400b002f39b99f6a2sm1112748qta.60.2022.05.26.07.25.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 07:25:14 -0700 (PDT)
Date:   Thu, 26 May 2022 16:25:06 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        netdev@vger.kernel.org, martinh@xilinx.com, martinpo@xilinx.com,
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
Subject: Re: [PATCH v4 4/4] vdpa_sim: Implement stop vdpa op
Message-ID: <20220526142506.4c2j2mguwu3ejg7i@sgarzare-redhat>
References: <20220526124338.36247-1-eperezma@redhat.com>
 <20220526124338.36247-5-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220526124338.36247-5-eperezma@redhat.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 26, 2022 at 02:43:38PM +0200, Eugenio Pérez wrote:
>Implement stop operation for vdpa_sim devices, so vhost-vdpa will offer
>that backend feature and userspace can effectively stop the device.
>
>This is a must before get virtqueue indexes (base) for live migration,
>since the device could modify them after userland gets them. There are
>individual ways to perform that action for some devices
>(VHOST_NET_SET_BACKEND, VHOST_VSOCK_SET_RUNNING, ...) but there was no
>way to perform it for any vhost device (and, in particular, vhost-vdpa).
>
>Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
>---
> drivers/vdpa/vdpa_sim/vdpa_sim.c     | 21 +++++++++++++++++++++
> drivers/vdpa/vdpa_sim/vdpa_sim.h     |  1 +
> drivers/vdpa/vdpa_sim/vdpa_sim_blk.c |  3 +++
> drivers/vdpa/vdpa_sim/vdpa_sim_net.c |  3 +++
> 4 files changed, 28 insertions(+)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
>index 50d721072beb..0515cf314bed 100644
>--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
>+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
>@@ -107,6 +107,7 @@ static void vdpasim_do_reset(struct vdpasim *vdpasim)
> 	for (i = 0; i < vdpasim->dev_attr.nas; i++)
> 		vhost_iotlb_reset(&vdpasim->iommu[i]);
>
>+	vdpasim->running = true;
> 	spin_unlock(&vdpasim->iommu_lock);
>
> 	vdpasim->features = 0;
>@@ -505,6 +506,24 @@ static int vdpasim_reset(struct vdpa_device *vdpa)
> 	return 0;
> }
>
>+static int vdpasim_stop(struct vdpa_device *vdpa, bool stop)
>+{
>+	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
>+	int i;
>+
>+	spin_lock(&vdpasim->lock);
>+	vdpasim->running = !stop;
>+	if (vdpasim->running) {
>+		/* Check for missed buffers */
>+		for (i = 0; i < vdpasim->dev_attr.nvqs; ++i)
>+			vdpasim_kick_vq(vdpa, i);
>+
>+	}
>+	spin_unlock(&vdpasim->lock);
>+
>+	return 0;
>+}
>+
> static size_t vdpasim_get_config_size(struct vdpa_device *vdpa)
> {
> 	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
>@@ -694,6 +713,7 @@ static const struct vdpa_config_ops vdpasim_config_ops = {
> 	.get_status             = vdpasim_get_status,
> 	.set_status             = vdpasim_set_status,
> 	.reset			= vdpasim_reset,
>+	.stop			= vdpasim_stop,
> 	.get_config_size        = vdpasim_get_config_size,
> 	.get_config             = vdpasim_get_config,
> 	.set_config             = vdpasim_set_config,
>@@ -726,6 +746,7 @@ static const struct vdpa_config_ops vdpasim_batch_config_ops = {
> 	.get_status             = vdpasim_get_status,
> 	.set_status             = vdpasim_set_status,
> 	.reset			= vdpasim_reset,
>+	.stop			= vdpasim_stop,
> 	.get_config_size        = vdpasim_get_config_size,
> 	.get_config             = vdpasim_get_config,
> 	.set_config             = vdpasim_set_config,
>diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.h b/drivers/vdpa/vdpa_sim/vdpa_sim.h
>index 622782e92239..061986f30911 100644
>--- a/drivers/vdpa/vdpa_sim/vdpa_sim.h
>+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.h
>@@ -66,6 +66,7 @@ struct vdpasim {
> 	u32 generation;
> 	u64 features;
> 	u32 groups;
>+	bool running;
> 	/* spinlock to synchronize iommu table */
> 	spinlock_t iommu_lock;
> };
>diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c b/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
>index 42d401d43911..bcdb1982c378 100644
>--- a/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
>+++ b/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
>@@ -204,6 +204,9 @@ static void vdpasim_blk_work(struct work_struct *work)
> 	if (!(vdpasim->status & VIRTIO_CONFIG_S_DRIVER_OK))
> 		goto out;
>
>+	if (!vdpasim->running)
>+		goto out;
>+
> 	for (i = 0; i < VDPASIM_BLK_VQ_NUM; i++) {
> 		struct vdpasim_virtqueue *vq = &vdpasim->vqs[i];
>
>diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
>index 5125976a4df8..886449e88502 100644
>--- a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
>+++ b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
>@@ -154,6 +154,9 @@ static void vdpasim_net_work(struct work_struct *work)
>
> 	spin_lock(&vdpasim->lock);
>
>+	if (!vdpasim->running)
>+		goto out;
>+
> 	if (!(vdpasim->status & VIRTIO_CONFIG_S_DRIVER_OK))
> 		goto out;
>
>-- 
>2.31.1
>

