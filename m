Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04C8156B8E4
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 13:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238141AbiGHLsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 07:48:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238123AbiGHLsW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 07:48:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 05394951D8
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 04:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657280901;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qz83jQ6ie8rpR79Lw5oBAFua2qVBO7q3ChvGPuAzjrw=;
        b=T2bivFwuHapcklp2AKZVISQTV/DHQp3r3CCLenZK7lYDGAOQGD2g8f7cu3c0wb+Q8kKnef
        x6b7hcJJ546X8GWVmdMdVz+o+LpOHMqJfoGHRWutttNejW8WWN6ZhjRnjW83I9hzasFGQi
        MLGqHZPKfzW6tIgnPWdd8+3tbWj5j24=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-413-nwyH2FJ1Pgups1hblRy-Dw-1; Fri, 08 Jul 2022 07:48:20 -0400
X-MC-Unique: nwyH2FJ1Pgups1hblRy-Dw-1
Received: by mail-qk1-f199.google.com with SMTP id s9-20020a05620a254900b006b54dd4d6deso5170429qko.3
        for <netdev@vger.kernel.org>; Fri, 08 Jul 2022 04:48:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Qz83jQ6ie8rpR79Lw5oBAFua2qVBO7q3ChvGPuAzjrw=;
        b=7nKOJFlhuRS5qBcosxR1c1k2VaQUSETxKvGllBQiuDQL8y7LlAL+02YALY5Ehni0uk
         g3EBQLK/XKUpy2vj4XlqZhaBhsmJ1hdFEeKvWOCGoSM5+eAZH0xRWV//FANZs33pzdAU
         lq4GpVzZAAYK+4zYWfYuWTS8MX4aNh03LEyWJWSiJ8HwzOpR3KIikTv6z87U8qbqqgab
         e5itdIFMKyMEZQaKXvqfJGXN5DVmmAkq0jJ3A4kz7vnrzfWKEGtygv1tMDa4pN3YU3l3
         WJP+E4f82f+obzUSYJDZk4r0OucDpS6p5HFgTEfv1P7B/TbTaikikaKTdiZLNPBX1v+C
         6ibg==
X-Gm-Message-State: AJIora+rDEO/e+UFcLMqJ9H2Dkaj3qtJ3mhaIUMnHXcg8dnfkBThbufr
        PRZrMgQfSnI7o/HQKe9d6LGHcWH3kcKjZP9OZgv3PCbE4v5U57al/ZMO9kwVm9uChzv2//qD34y
        MmKKfM/95G/imDwyH4og27fVKxiyhKtpf
X-Received: by 2002:ac8:5b51:0:b0:317:3513:cf60 with SMTP id n17-20020ac85b51000000b003173513cf60mr2447559qtw.495.1657280899667;
        Fri, 08 Jul 2022 04:48:19 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1usVpZKD7lAzE4htKPsep3j+Ey0tw3eoaPrJNum/msse0zljtQvQdftD4RelMyTVPVazDTazPU1BOO+SKyLp1g=
X-Received: by 2002:ac8:5b51:0:b0:317:3513:cf60 with SMTP id
 n17-20020ac85b51000000b003173513cf60mr2447536qtw.495.1657280899449; Fri, 08
 Jul 2022 04:48:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220623160738.632852-1-eperezma@redhat.com> <20220623160738.632852-4-eperezma@redhat.com>
 <CAGxU2F43+5zsQOR4ReTtQtEF47s6y-XKcevosMOzUdEqpLhAsg@mail.gmail.com>
In-Reply-To: <CAGxU2F43+5zsQOR4ReTtQtEF47s6y-XKcevosMOzUdEqpLhAsg@mail.gmail.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Fri, 8 Jul 2022 13:47:43 +0200
Message-ID: <CAJaqyWdn=mShLEZzfJB_+PwM+pkLhLMJaMOjdFtuW8tYbbU3FQ@mail.gmail.com>
Subject: Re: [PATCH v6 3/4] vhost-vdpa: uAPI to suspend the device
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>, Jason Wang <jasowang@redhat.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
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
        Dan Carpenter <dan.carpenter@oracle.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Zhang Min <zhang.min9@zte.com.cn>
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

On Tue, Jun 28, 2022 at 3:45 PM Stefano Garzarella <sgarzare@redhat.com> wr=
ote:
>
> On Thu, Jun 23, 2022 at 06:07:37PM +0200, Eugenio P=C3=A9rez wrote:
> >The ioctl adds support for suspending the device from userspace.
> >
> >This is a must before getting virtqueue indexes (base) for live migratio=
n,
> >since the device could modify them after userland gets them. There are
> >individual ways to perform that action for some devices
> >(VHOST_NET_SET_BACKEND, VHOST_VSOCK_SET_RUNNING, ...) but there was no
> >way to perform it for any vhost device (and, in particular, vhost-vdpa).
> >
> >After a successful return of the ioctl call the device must not process
> >more virtqueue descriptors. The device can answer to read or writes of
> >config fields as if it were not suspended. In particular, writing to
> >"queue_enable" with a value of 1 will not make the device start
> >processing buffers of the virtqueue.
> >
> >Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> >---
> > drivers/vhost/vdpa.c       | 19 +++++++++++++++++++
> > include/uapi/linux/vhost.h | 14 ++++++++++++++
> > 2 files changed, 33 insertions(+)
> >
> >diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> >index 3d636e192061..7fa671ac4bdf 100644
> >--- a/drivers/vhost/vdpa.c
> >+++ b/drivers/vhost/vdpa.c
> >@@ -478,6 +478,22 @@ static long vhost_vdpa_get_vqs_count(struct vhost_v=
dpa *v, u32 __user *argp)
> >       return 0;
> > }
> >
> >+/* After a successful return of ioctl the device must not process more
> >+ * virtqueue descriptors. The device can answer to read or writes of co=
nfig
> >+ * fields as if it were not suspended. In particular, writing to "queue=
_enable"
> >+ * with a value of 1 will not make the device start processing buffers.
> >+ */
> >+static long vhost_vdpa_suspend(struct vhost_vdpa *v)
> >+{
> >+      struct vdpa_device *vdpa =3D v->vdpa;
> >+      const struct vdpa_config_ops *ops =3D vdpa->config;
> >+
> >+      if (!ops->suspend)
> >+              return -EOPNOTSUPP;
> >+
> >+      return ops->suspend(vdpa);
> >+}
> >+
> > static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int c=
md,
> >                                  void __user *argp)
> > {
> >@@ -654,6 +670,9 @@ static long vhost_vdpa_unlocked_ioctl(struct file *f=
ilep,
> >       case VHOST_VDPA_GET_VQS_COUNT:
> >               r =3D vhost_vdpa_get_vqs_count(v, argp);
> >               break;
> >+      case VHOST_VDPA_SUSPEND:
> >+              r =3D vhost_vdpa_suspend(v);
> >+              break;
> >       default:
> >               r =3D vhost_dev_ioctl(&v->vdev, cmd, argp);
> >               if (r =3D=3D -ENOIOCTLCMD)
> >diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
> >index cab645d4a645..6d9f45163155 100644
> >--- a/include/uapi/linux/vhost.h
> >+++ b/include/uapi/linux/vhost.h
> >@@ -171,4 +171,18 @@
> > #define VHOST_VDPA_SET_GROUP_ASID     _IOW(VHOST_VIRTIO, 0x7C, \
> >                                            struct vhost_vring_state)
> >
> >+/* Suspend or resume a device so it does not process virtqueue requests=
 anymore
> >+ *
> >+ * After the return of ioctl with suspend !=3D 0, the device must finis=
h any
> >+ * pending operations like in flight requests. It must also preserve al=
l the
> >+ * necessary state (the virtqueue vring base plus the possible device s=
pecific
> >+ * states) that is required for restoring in the future. The device mus=
t not
> >+ * change its configuration after that point.
> >+ *
> >+ * After the return of ioctl with suspend =3D=3D 0, the device can cont=
inue
> >+ * processing buffers as long as typical conditions are met (vq is enab=
led,
> >+ * DRIVER_OK status bit is enabled, etc).
> >+ */
> >+#define VHOST_VDPA_SUSPEND            _IOW(VHOST_VIRTIO, 0x7D, int)
>                                          ^
> IIUC we are not using the argument anymore, so this should be changed in
> _IO(VHOST_VIRTIO, 0x7D).
>
> And we should update a bit the documentation.
>

Totally right, replacing it for the next version.

Thanks!

> Thanks,
> Stefano
>

