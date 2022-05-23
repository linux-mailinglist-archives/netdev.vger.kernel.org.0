Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7548E531C10
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 22:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbiEWTaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 15:30:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiEWT2h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 15:28:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4A8081912D7
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 12:08:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653332912;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jb5wziDvVzOcnMghncHpaoaqtsyiv3uiEKe6IzxyHp0=;
        b=GMz2YORnIMe2XyHiC5Wg8UgdfEmEdxs/2CNRYIP9KfSCJL0yygVfiuHD1J7a55lE0nm4JK
        RC8lSgLW0Knlx4Hr6cgL5r9FEZ9k/n/jf1UfXWh8tKCCgHwQcFcniHvZvJlnPqr/Utsvtc
        WOplaRsFfRaxOiH/qQAPRCgHoS8Uk+U=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-543-86IRpaeXOf-OlrBoKPwwuA-1; Mon, 23 May 2022 15:08:31 -0400
X-MC-Unique: 86IRpaeXOf-OlrBoKPwwuA-1
Received: by mail-qt1-f200.google.com with SMTP id m6-20020ac866c6000000b002f52f9fb4edso12186352qtp.19
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 12:08:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=jb5wziDvVzOcnMghncHpaoaqtsyiv3uiEKe6IzxyHp0=;
        b=eQ2axWXcfEOohCq0fGPkE6f5uAYxw9q+ybCMxm4c2h43X3XuUgWJIyfp4SiOmHPW27
         ADZMmUaUIA8evaQeYXANJwfZdylFTFpMNChnOoRk4tuQ4G+cClNI2loZGbdlxuSa7iGb
         RYW5UWDTZeN6w98BJWhXSYPIzth8+nGceM3St92A4YHRXj2TBeDlncf0gPJ3V63e8hKt
         vxKjkhpG0jQ2yetmD733s+eBH7HEHW4vx2ydYH6RU3piJWfTrEbzZKV654O+nFEIKI3t
         nxvn8VqSqgevr7OWsZvS5rdRyUMKructZTEoEuXicKG1zgstlo3au9Ttl/x2aiZ39K5r
         cVdQ==
X-Gm-Message-State: AOAM530byZEhhFq6d9dlUH9khsPfJb/UHLiuUJF3a/O/CEx+kwY0NQ0i
        oqPwj2H/i5El+9Q9LGvTgwm/tLG3yLQCCJ8i8N6vHA4mfcywKD8sLFYaYHWdODmypplIDC28BBe
        ZFPqgh/im7/W5GPzn14M+01cPIjrffH+V
X-Received: by 2002:a05:620a:1332:b0:6a3:71c3:b227 with SMTP id p18-20020a05620a133200b006a371c3b227mr6335975qkj.406.1653332910505;
        Mon, 23 May 2022 12:08:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzip2FRxkOIYUK/P3PS3jeC5wwlP+h2dRIrExiI+wuGlG5RC+2gUVOUH6G2tziTzPqSW2OXB7XseSqD5lM7onI=
X-Received: by 2002:a05:620a:1332:b0:6a3:71c3:b227 with SMTP id
 p18-20020a05620a133200b006a371c3b227mr6335948qkj.406.1653332910302; Mon, 23
 May 2022 12:08:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220520172325.980884-1-eperezma@redhat.com> <20220520172325.980884-5-eperezma@redhat.com>
 <20220523082738.h7lvwkysnqhynf37@sgarzare-redhat>
In-Reply-To: <20220523082738.h7lvwkysnqhynf37@sgarzare-redhat>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Mon, 23 May 2022 21:07:54 +0200
Message-ID: <CAJaqyWd0L3ihByNxQfHsra=vd9SYCBWk8sqhFmm0Lcz4gz=5wA@mail.gmail.com>
Subject: Re: [PATCH 4/4] vdpa_sim: Implement stop vdpa op
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     virtualization <virtualization@lists.linux-foundation.org>,
        Jason Wang <jasowang@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Longpeng <longpeng2@huawei.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Martin Petrus Hubertus Habets <martinh@xilinx.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>, dinang@xilinx.com,
        Eli Cohen <elic@nvidia.com>,
        Laurent Vivier <lvivier@redhat.com>, pabloc@xilinx.com,
        "Dawar, Gautam" <gautam.dawar@amd.com>,
        Xie Yongji <xieyongji@bytedance.com>, habetsm.xilinx@gmail.com,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        tanuj.kamde@amd.com, Wu Zongyong <wuzongyong@linux.alibaba.com>,
        martinpo@xilinx.com, Cindy Lu <lulu@redhat.com>,
        ecree.xilinx@gmail.com, Parav Pandit <parav@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Zhang Min <zhang.min9@zte.com.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 23, 2022 at 10:28 AM Stefano Garzarella <sgarzare@redhat.com> w=
rote:
>
> On Fri, May 20, 2022 at 07:23:25PM +0200, Eugenio P=C3=A9rez wrote:
> >Implement stop operation for vdpa_sim devices, so vhost-vdpa will offer
> >that backend feature and userspace can effectively stop the device.
> >
> >This is a must before get virtqueue indexes (base) for live migration,
> >since the device could modify them after userland gets them. There are
> >individual ways to perform that action for some devices
> >(VHOST_NET_SET_BACKEND, VHOST_VSOCK_SET_RUNNING, ...) but there was no
> >way to perform it for any vhost device (and, in particular, vhost-vdpa).
> >
> >Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> >---
> > drivers/vdpa/vdpa_sim/vdpa_sim.c     | 21 +++++++++++++++++++++
> > drivers/vdpa/vdpa_sim/vdpa_sim.h     |  1 +
> > drivers/vdpa/vdpa_sim/vdpa_sim_net.c |  3 +++
> > 3 files changed, 25 insertions(+)
> >
> >diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vd=
pa_sim.c
> >index 50d721072beb..0515cf314bed 100644
> >--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
> >+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> >@@ -107,6 +107,7 @@ static void vdpasim_do_reset(struct vdpasim *vdpasim=
)
> >       for (i =3D 0; i < vdpasim->dev_attr.nas; i++)
> >               vhost_iotlb_reset(&vdpasim->iommu[i]);
> >
> >+      vdpasim->running =3D true;
> >       spin_unlock(&vdpasim->iommu_lock);
> >
> >       vdpasim->features =3D 0;
> >@@ -505,6 +506,24 @@ static int vdpasim_reset(struct vdpa_device *vdpa)
> >       return 0;
> > }
> >
> >+static int vdpasim_stop(struct vdpa_device *vdpa, bool stop)
> >+{
> >+      struct vdpasim *vdpasim =3D vdpa_to_sim(vdpa);
> >+      int i;
> >+
> >+      spin_lock(&vdpasim->lock);
> >+      vdpasim->running =3D !stop;
> >+      if (vdpasim->running) {
> >+              /* Check for missed buffers */
> >+              for (i =3D 0; i < vdpasim->dev_attr.nvqs; ++i)
> >+                      vdpasim_kick_vq(vdpa, i);
> >+
> >+      }
> >+      spin_unlock(&vdpasim->lock);
> >+
> >+      return 0;
> >+}
> >+
> > static size_t vdpasim_get_config_size(struct vdpa_device *vdpa)
> > {
> >       struct vdpasim *vdpasim =3D vdpa_to_sim(vdpa);
> >@@ -694,6 +713,7 @@ static const struct vdpa_config_ops vdpasim_config_o=
ps =3D {
> >       .get_status             =3D vdpasim_get_status,
> >       .set_status             =3D vdpasim_set_status,
> >       .reset                  =3D vdpasim_reset,
> >+      .stop                   =3D vdpasim_stop,
> >       .get_config_size        =3D vdpasim_get_config_size,
> >       .get_config             =3D vdpasim_get_config,
> >       .set_config             =3D vdpasim_set_config,
> >@@ -726,6 +746,7 @@ static const struct vdpa_config_ops vdpasim_batch_co=
nfig_ops =3D {
> >       .get_status             =3D vdpasim_get_status,
> >       .set_status             =3D vdpasim_set_status,
> >       .reset                  =3D vdpasim_reset,
> >+      .stop                   =3D vdpasim_stop,
> >       .get_config_size        =3D vdpasim_get_config_size,
> >       .get_config             =3D vdpasim_get_config,
> >       .set_config             =3D vdpasim_set_config,
> >diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.h b/drivers/vdpa/vdpa_sim/vd=
pa_sim.h
> >index 622782e92239..061986f30911 100644
> >--- a/drivers/vdpa/vdpa_sim/vdpa_sim.h
> >+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.h
> >@@ -66,6 +66,7 @@ struct vdpasim {
> >       u32 generation;
> >       u64 features;
> >       u32 groups;
> >+      bool running;
> >       /* spinlock to synchronize iommu table */
> >       spinlock_t iommu_lock;
> > };
> >diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c b/drivers/vdpa/vdpa_si=
m/vdpa_sim_net.c
> >index 5125976a4df8..886449e88502 100644
> >--- a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
> >+++ b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
> >@@ -154,6 +154,9 @@ static void vdpasim_net_work(struct work_struct *wor=
k)
> >
> >       spin_lock(&vdpasim->lock);
> >
> >+      if (!vdpasim->running)
> >+              goto out;
> >+
>
> It would be nice to do the same for vdpa_sim_blk as well.
>

Agree, it will be added in the next revision. If not, blk presents an
invalid backend feature bit.

Thanks!

> Thanks,
> Stefano
>

