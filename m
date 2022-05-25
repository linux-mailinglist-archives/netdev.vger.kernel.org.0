Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6CF2533586
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 04:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243729AbiEYCyg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 22:54:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240516AbiEYCyf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 22:54:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 99DB47090B
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 19:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653447273;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L6n7+yQgn+nVFUYyJzAWXpzjroQrckSxh/1Ms4Uuyq4=;
        b=QogKXykY8GRczE+uIg9F2Dpya0T9W5csFPscnI+jfJfxi9Mpht4VM1lGesHeD9SItio9jh
        YJjUZ9A4fxt5aLwyaI85ddIpb7SEM8vXKxDOO7TKKTOIppNnoRdEQ1Ll0Bycj/nPcSqB3y
        7pA2+gVnV33hG2+IC642QdHU1eRPLBo=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-362-hOctQSS2MfiZH4T5gBNVeg-1; Tue, 24 May 2022 22:54:32 -0400
X-MC-Unique: hOctQSS2MfiZH4T5gBNVeg-1
Received: by mail-lf1-f69.google.com with SMTP id c6-20020a056512104600b00477b25bfdf8so10009012lfb.9
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 19:54:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=L6n7+yQgn+nVFUYyJzAWXpzjroQrckSxh/1Ms4Uuyq4=;
        b=2ivgr6zZIds3emL8wBwoRIOv5mL5AF7QBKlLQINhtFvGHnUdEMxXszlVqb09UIkRpN
         wqQmW4n6RWHrI4UjQE/9Fpv5BtEj8Tgd2ky1wp92y2FjExhwWRnc+MQUQy8aVeW+i/tw
         AWhs2QAJ4M0dV16a35KmavOVSax8x+5AVAkTmNtR6R7rdWYIujjU62WHu27vt1ep9uOq
         rBFchE55S9axYXCak/bti9GpUl10ebs/hxENktd5Fexl5lhjbJ7V0huZhuLif1WfH0W7
         MgNUZMqfLLI9A5GUAKjpgcinJVcV5tQ8b5wZ23HGlRCOqTf9TFDlrFOHmuwdEWKXqNxU
         pqcw==
X-Gm-Message-State: AOAM531rTrwX/v6Z8wZNt2yme6VVPXT6fVk8Z2ILsuaPR7Ecq32pBPjD
        /XlJZmPmbMdsqKc4S8Cy+eqysyd6Ar0RqYe2ugxvJ+L+dmBkEjXz7vHJyEC0O+HVw2aYaAxJRmm
        UZ4+RPePQxzJ4AHG9ClXFSK1TXHewpC2j
X-Received: by 2002:a2e:1651:0:b0:253:d7ce:22df with SMTP id 17-20020a2e1651000000b00253d7ce22dfmr16348511ljw.315.1653447270772;
        Tue, 24 May 2022 19:54:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwIeIyQFHdGFnE6GT5C+d47WqLD+jsGOmC4iPh7DCf0Fyx5p+BGfhhylBc3/GXzoRqdQbk+uILqUmEN70ocZiY=
X-Received: by 2002:a2e:1651:0:b0:253:d7ce:22df with SMTP id
 17-20020a2e1651000000b00253d7ce22dfmr16348477ljw.315.1653447270564; Tue, 24
 May 2022 19:54:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220524170610.2255608-1-eperezma@redhat.com> <20220524170610.2255608-5-eperezma@redhat.com>
In-Reply-To: <20220524170610.2255608-5-eperezma@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 25 May 2022 10:54:19 +0800
Message-ID: <CACGkMEvCzxy+1BX2FMs5CvsvVvd9oedtgXmpiyAZWZECPypRig@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] vdpa_sim: Implement stop vdpa op
To:     =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Parav Pandit <parav@nvidia.com>,
        Zhang Min <zhang.min9@zte.com.cn>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>, tanuj.kamde@amd.com,
        "Dawar, Gautam" <gautam.dawar@amd.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Xie Yongji <xieyongji@bytedance.com>,
        Dinan Gunawardena <dinang@xilinx.com>,
        habetsm.xilinx@gmail.com, Eli Cohen <elic@nvidia.com>,
        Pablo Cascon Katchadourian <pabloc@xilinx.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Cindy Lu <lulu@redhat.com>,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        ecree.xilinx@gmail.com, "Uminski, Piotr" <Piotr.Uminski@intel.com>,
        Martin Porter <martinpo@xilinx.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Longpeng <longpeng2@huawei.com>,
        Martin Petrus Hubertus Habets <martinh@xilinx.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 25, 2022 at 1:06 AM Eugenio P=C3=A9rez <eperezma@redhat.com> wr=
ote:
>
> Implement stop operation for vdpa_sim devices, so vhost-vdpa will offer
> that backend feature and userspace can effectively stop the device.
>
> This is a must before get virtqueue indexes (base) for live migration,
> since the device could modify them after userland gets them. There are
> individual ways to perform that action for some devices
> (VHOST_NET_SET_BACKEND, VHOST_VSOCK_SET_RUNNING, ...) but there was no
> way to perform it for any vhost device (and, in particular, vhost-vdpa).
>
> After the return of ioctl with stop !=3D 0, the device MUST finish any
> pending operations like in flight requests. It must also preserve all
> the necessary state (the virtqueue vring base plus the possible device
> specific states) that is required for restoring in the future. The
> device must not change its configuration after that point.
>
> After the return of ioctl with stop =3D=3D 0, the device can continue
> processing buffers as long as typical conditions are met (vq is enabled,
> DRIVER_OK status bit is enabled, etc).
>
> In the future, we will provide features similar to
> VHOST_USER_GET_INFLIGHT_FD so the device can save pending operations.
>
> Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> ---
>  drivers/vdpa/vdpa_sim/vdpa_sim.c     | 21 +++++++++++++++++++++
>  drivers/vdpa/vdpa_sim/vdpa_sim.h     |  1 +
>  drivers/vdpa/vdpa_sim/vdpa_sim_blk.c |  3 +++
>  drivers/vdpa/vdpa_sim/vdpa_sim_net.c |  3 +++
>  4 files changed, 28 insertions(+)
>
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdp=
a_sim.c
> index 50d721072beb..0515cf314bed 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> @@ -107,6 +107,7 @@ static void vdpasim_do_reset(struct vdpasim *vdpasim)
>         for (i =3D 0; i < vdpasim->dev_attr.nas; i++)
>                 vhost_iotlb_reset(&vdpasim->iommu[i]);
>
> +       vdpasim->running =3D true;
>         spin_unlock(&vdpasim->iommu_lock);
>
>         vdpasim->features =3D 0;
> @@ -505,6 +506,24 @@ static int vdpasim_reset(struct vdpa_device *vdpa)
>         return 0;
>  }
>
> +static int vdpasim_stop(struct vdpa_device *vdpa, bool stop)
> +{
> +       struct vdpasim *vdpasim =3D vdpa_to_sim(vdpa);
> +       int i;
> +
> +       spin_lock(&vdpasim->lock);
> +       vdpasim->running =3D !stop;
> +       if (vdpasim->running) {
> +               /* Check for missed buffers */
> +               for (i =3D 0; i < vdpasim->dev_attr.nvqs; ++i)
> +                       vdpasim_kick_vq(vdpa, i);
> +
> +       }
> +       spin_unlock(&vdpasim->lock);
> +
> +       return 0;
> +}
> +
>  static size_t vdpasim_get_config_size(struct vdpa_device *vdpa)
>  {
>         struct vdpasim *vdpasim =3D vdpa_to_sim(vdpa);
> @@ -694,6 +713,7 @@ static const struct vdpa_config_ops vdpasim_config_op=
s =3D {
>         .get_status             =3D vdpasim_get_status,
>         .set_status             =3D vdpasim_set_status,
>         .reset                  =3D vdpasim_reset,
> +       .stop                   =3D vdpasim_stop,
>         .get_config_size        =3D vdpasim_get_config_size,
>         .get_config             =3D vdpasim_get_config,
>         .set_config             =3D vdpasim_set_config,
> @@ -726,6 +746,7 @@ static const struct vdpa_config_ops vdpasim_batch_con=
fig_ops =3D {
>         .get_status             =3D vdpasim_get_status,
>         .set_status             =3D vdpasim_set_status,
>         .reset                  =3D vdpasim_reset,
> +       .stop                   =3D vdpasim_stop,
>         .get_config_size        =3D vdpasim_get_config_size,
>         .get_config             =3D vdpasim_get_config,
>         .set_config             =3D vdpasim_set_config,
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.h b/drivers/vdpa/vdpa_sim/vdp=
a_sim.h
> index 622782e92239..061986f30911 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim.h
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.h
> @@ -66,6 +66,7 @@ struct vdpasim {
>         u32 generation;
>         u64 features;
>         u32 groups;
> +       bool running;
>         /* spinlock to synchronize iommu table */
>         spinlock_t iommu_lock;
>  };
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c b/drivers/vdpa/vdpa_sim=
/vdpa_sim_blk.c
> index 42d401d43911..bcdb1982c378 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
> @@ -204,6 +204,9 @@ static void vdpasim_blk_work(struct work_struct *work=
)
>         if (!(vdpasim->status & VIRTIO_CONFIG_S_DRIVER_OK))
>                 goto out;
>
> +       if (!vdpasim->running)
> +               goto out;
> +
>         for (i =3D 0; i < VDPASIM_BLK_VQ_NUM; i++) {
>                 struct vdpasim_virtqueue *vq =3D &vdpasim->vqs[i];
>
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c b/drivers/vdpa/vdpa_sim=
/vdpa_sim_net.c
> index 5125976a4df8..886449e88502 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
> @@ -154,6 +154,9 @@ static void vdpasim_net_work(struct work_struct *work=
)
>
>         spin_lock(&vdpasim->lock);
>
> +       if (!vdpasim->running)
> +               goto out;
> +

Do we need to check vdpasim->running in vdpasim_kick_vq()?

Thanks

>         if (!(vdpasim->status & VIRTIO_CONFIG_S_DRIVER_OK))
>                 goto out;
>
> --
> 2.27.0
>

