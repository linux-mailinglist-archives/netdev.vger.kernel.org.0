Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFC5555F50D
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 06:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231351AbiF2ESu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 00:18:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231341AbiF2ESo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 00:18:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BB1B712D0D
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 21:18:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656476321;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2h8ccNqJU95HAa4G/EVV71yAZ0Ts5Xe8taofTuRNpD4=;
        b=WpdZzBn7Lk9tqAPpuw0Cfn7SWgDXqWenBHoSTocofD5ctVEODEtAN3YATkzVaWI73nE0gn
        gSfN+RN0dVehv+9hsFxboNUFvCTwcxsYXCeK1pUEIeBh8K9Y6EJbPyWDmFGTMtQ5h2DPG6
        cK356J9oA/1+ojwdovNan6sj9y4HPdE=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-159-urMTyZbZMaOE27gM5ohmRw-1; Wed, 29 Jun 2022 00:18:40 -0400
X-MC-Unique: urMTyZbZMaOE27gM5ohmRw-1
Received: by mail-lf1-f71.google.com with SMTP id bi38-20020a0565120ea600b0047f640eaee0so7175890lfb.4
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 21:18:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2h8ccNqJU95HAa4G/EVV71yAZ0Ts5Xe8taofTuRNpD4=;
        b=YRpexJO/tG/oDLTt5IIV6GGLcuFpym+1+mDzX680LPEZBs2fvAx/4r2mYhWKDP/9p+
         3S1rM3G9T72/Xb0GZ6zWPqi6YdkcvWADkp7OxXYNuIrySmWWPH9wWOpolo8bu1dwzN3U
         czIvWF/sLWMhgKppDGxJzNpnww4qHo5iznPGVVFepDtgMaJIzLI8t+rebKToB4VLKtVf
         zjaY+R6lpQVPiBWLEaGdUhbJvqyYXEkTYUpwBBQGIifdFryAz4aPpnkya6OieJFDp84R
         VFQs2k15J0m0XZysl/9y/RgVQN20igmZMoqomKB8ymJZxnYk4av7Pi6wtIuzqmUuUhz2
         6V6g==
X-Gm-Message-State: AJIora9sUbCEZi9r8KtW88eF0QR+JnOLweHYg14qD5W4v3kUXJ5wwomt
        UyxWz1zA4IxH9w0+73KgVId+SOEjXhGfWOfd1HTb9pem/G3KZ3trxhKB7q9vSAn7R9JdDbty98q
        kEkjxFMI6sIpPT1tEuccLXftHoQQI5kke
X-Received: by 2002:a05:6512:158d:b0:47f:718c:28b5 with SMTP id bp13-20020a056512158d00b0047f718c28b5mr811909lfb.397.1656476318729;
        Tue, 28 Jun 2022 21:18:38 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vZ6G4jroIyi6EDss7eqJRupKjJ6aAZH6PLBk1sX8uk6DRDfTN14oyEf9afhAJidDtEIQTSOcMcEre11YiA3MQ=
X-Received: by 2002:a05:6512:158d:b0:47f:718c:28b5 with SMTP id
 bp13-20020a056512158d00b0047f718c28b5mr811892lfb.397.1656476318523; Tue, 28
 Jun 2022 21:18:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220623160738.632852-1-eperezma@redhat.com> <20220623160738.632852-5-eperezma@redhat.com>
In-Reply-To: <20220623160738.632852-5-eperezma@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 29 Jun 2022 12:18:27 +0800
Message-ID: <CACGkMEtbukb4gcCHytotZr7FA+Dp1cFs4BpPJatR98zqAnNZjA@mail.gmail.com>
Subject: Re: [PATCH v6 4/4] vdpa_sim: Implement suspend vdpa op
To:     =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        kvm <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Cindy Lu <lulu@redhat.com>,
        "Kamde, Tanuj" <tanuj.kamde@amd.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        "Uminski, Piotr" <Piotr.Uminski@intel.com>,
        habetsm.xilinx@gmail.com, "Dawar, Gautam" <gautam.dawar@amd.com>,
        Pablo Cascon Katchadourian <pabloc@xilinx.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Longpeng <longpeng2@huawei.com>,
        Dinan Gunawardena <dinang@xilinx.com>,
        Martin Petrus Hubertus Habets <martinh@xilinx.com>,
        Martin Porter <martinpo@xilinx.com>,
        Eli Cohen <elic@nvidia.com>, ecree.xilinx@gmail.com,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Zhang Min <zhang.min9@zte.com.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 24, 2022 at 12:08 AM Eugenio P=C3=A9rez <eperezma@redhat.com> w=
rote:
>
> Implement suspend operation for vdpa_sim devices, so vhost-vdpa will
> offer that backend feature and userspace can effectively suspend the
> device.
>
> This is a must before get virtqueue indexes (base) for live migration,
> since the device could modify them after userland gets them. There are
> individual ways to perform that action for some devices
> (VHOST_NET_SET_BACKEND, VHOST_VSOCK_SET_RUNNING, ...) but there was no
> way to perform it for any vhost device (and, in particular, vhost-vdpa).
>
> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
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
> index 0f2865899647..213883487f9b 100644
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
> +static int vdpasim_suspend(struct vdpa_device *vdpa)
> +{
> +       struct vdpasim *vdpasim =3D vdpa_to_sim(vdpa);
> +       int i;
> +
> +       spin_lock(&vdpasim->lock);
> +       vdpasim->running =3D false;
> +       if (vdpasim->running) {
> +               /* Check for missed buffers */
> +               for (i =3D 0; i < vdpasim->dev_attr.nvqs; ++i)
> +                       vdpasim_kick_vq(vdpa, i);

This seems only valid if we allow resuming?

Thanks

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
> +       .suspend                =3D vdpasim_suspend,
>         .get_config_size        =3D vdpasim_get_config_size,
>         .get_config             =3D vdpasim_get_config,
>         .set_config             =3D vdpasim_set_config,
> @@ -726,6 +746,7 @@ static const struct vdpa_config_ops vdpasim_batch_con=
fig_ops =3D {
>         .get_status             =3D vdpasim_get_status,
>         .set_status             =3D vdpasim_set_status,
>         .reset                  =3D vdpasim_reset,
> +       .suspend                =3D vdpasim_suspend,
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
>         if (!(vdpasim->status & VIRTIO_CONFIG_S_DRIVER_OK))
>                 goto out;
>
> --
> 2.31.1
>

