Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8567658FA51
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 11:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234633AbiHKJ7B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 05:59:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234550AbiHKJ67 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 05:58:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0630A91094
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 02:58:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660211937;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/R7Dryv+d3GV8pIXJrc5C98POWrIYtqGZwBiNr+Dx9I=;
        b=R/Nvp7V91kusqwT9k4PzuN7jZvNUv/gvSztRZ5DAlrxSTXYo926VipWA6/8rY6WmBxBO8/
        HvWtdMkAmECg+ZL0dGU0uzjtXGhFpoSB9IJNNncESX/iFzoKxzZLtu0R3flqTpnBYucUim
        w7fICKaxUoIRf593/gMqYgKEADCWP/8=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-350-KRB23_AqOwGMX2HPMfV5Kg-1; Thu, 11 Aug 2022 05:58:55 -0400
X-MC-Unique: KRB23_AqOwGMX2HPMfV5Kg-1
Received: by mail-qk1-f197.google.com with SMTP id q20-20020a05620a0d9400b006b6540e8d79so14511566qkl.14
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 02:58:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=/R7Dryv+d3GV8pIXJrc5C98POWrIYtqGZwBiNr+Dx9I=;
        b=hlFFgr3rP36Wn5689RZG8HM57+VWaUgToaCWzFK0vBZkAbyQi1lOlSKz9oyrww1+hh
         IC9qRMH6U8E/6hiR16bNr5/K+f4wLZGRE0ny5c9/OICvfxg7eSDSOdBjwGlrtDcPq7y3
         NswvpH+8uoJTAMKLPv/96NrQyelLdIJmwfpUDJWLA1N3BskH2ToFsR/VJYCzCsvCIo+2
         363RU4NbQe2j+J8U4r0HBLg9UnSWQSU7P5YfC/PXooJiWEnoRrTocoz0jSkxNyg/CQaX
         05BBLWI/Gz1WYbF+V7//ZM2M9ilbytli1YWb2X4O0R0nnczA1Pb12OHzhOcGj3vXlfyD
         IUHA==
X-Gm-Message-State: ACgBeo3kUICQqkvCYo46z8Rgu9TFE6BElu5azwnrJWNGVUOXS1ZcMOnp
        8TazAvlPfobPNvTkIuVSLECikReWDigyaq8l/dmKHnyO4fcqd9X96qHkKx09CBBoWyHJIzbOatd
        /am6DakhZPKnaBbAIasj/APHPaNEnml03
X-Received: by 2002:a05:620a:f10:b0:6aa:318e:55a9 with SMTP id v16-20020a05620a0f1000b006aa318e55a9mr23448013qkl.559.1660211935150;
        Thu, 11 Aug 2022 02:58:55 -0700 (PDT)
X-Google-Smtp-Source: AA6agR46iI6RWBek+haxJNWFLlFbtaxPouhpPjWxx1Oi5kVglzYBHHk8gTkRWafFNCXiOMZYpxsi+7dCewFJ21Y2Eu8=
X-Received: by 2002:a05:620a:f10:b0:6aa:318e:55a9 with SMTP id
 v16-20020a05620a0f1000b006aa318e55a9mr23447989qkl.559.1660211934843; Thu, 11
 Aug 2022 02:58:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220810171512.2343333-1-eperezma@redhat.com> <20220810171512.2343333-4-eperezma@redhat.com>
 <20220811042847-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220811042847-mutt-send-email-mst@kernel.org>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Thu, 11 Aug 2022 11:58:18 +0200
Message-ID: <CAJaqyWc46O6TNZzVSizDXnWk4KkM40O9+M2CNVOdkLzUdXmFqQ@mail.gmail.com>
Subject: Re: [PATCH v7 3/4] vhost-vdpa: uAPI to suspend the device
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        Dinan Gunawardena <dinang@xilinx.com>,
        Martin Porter <martinpo@xilinx.com>,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        "Uminski, Piotr" <Piotr.Uminski@intel.com>,
        "Dawar, Gautam" <gautam.dawar@amd.com>, ecree.xilinx@gmail.com,
        Martin Petrus Hubertus Habets <martinh@xilinx.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Pablo Cascon Katchadourian <pabloc@xilinx.com>,
        habetsm.xilinx@gmail.com, Laurent Vivier <lvivier@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        "Kamde, Tanuj" <tanuj.kamde@amd.com>,
        Longpeng <longpeng2@huawei.com>, Cindy Lu <lulu@redhat.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Parav Pandit <parav@nvidia.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Eli Cohen <elic@nvidia.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Zhang Min <zhang.min9@zte.com.cn>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 11, 2022 at 10:29 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Wed, Aug 10, 2022 at 07:15:11PM +0200, Eugenio P=C3=A9rez wrote:
> > The ioctl adds support for suspending the device from userspace.
> >
> > This is a must before getting virtqueue indexes (base) for live migrati=
on,
> > since the device could modify them after userland gets them. There are
> > individual ways to perform that action for some devices
> > (VHOST_NET_SET_BACKEND, VHOST_VSOCK_SET_RUNNING, ...) but there was no
> > way to perform it for any vhost device (and, in particular, vhost-vdpa)=
.
> >
> > After a successful return of the ioctl call the device must not process
> > more virtqueue descriptors. The device can answer to read or writes of
> > config fields as if it were not suspended. In particular, writing to
> > "queue_enable" with a value of 1 will not make the device start
> > processing buffers of the virtqueue.
> >
> > Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> > Message-Id: <20220623160738.632852-4-eperezma@redhat.com>
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>
> You are not supposed to include upstream maintainer's signoff
> like this.
>

I'm very sorry, I modified the commits in your vhost branch and I left
the signoff (and message-id) lines by mistake.

> > ---
> > v7: Delete argument to ioctl, unused
> > ---
> >  drivers/vhost/vdpa.c       | 19 +++++++++++++++++++
> >  include/uapi/linux/vhost.h |  9 +++++++++
> >  2 files changed, 28 insertions(+)
> >
> > diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> > index 3d636e192061..7fa671ac4bdf 100644
> > --- a/drivers/vhost/vdpa.c
> > +++ b/drivers/vhost/vdpa.c
> > @@ -478,6 +478,22 @@ static long vhost_vdpa_get_vqs_count(struct vhost_=
vdpa *v, u32 __user *argp)
> >       return 0;
> >  }
> >
> > +/* After a successful return of ioctl the device must not process more
> > + * virtqueue descriptors. The device can answer to read or writes of c=
onfig
> > + * fields as if it were not suspended. In particular, writing to "queu=
e_enable"
> > + * with a value of 1 will not make the device start processing buffers=
.
> > + */
> > +static long vhost_vdpa_suspend(struct vhost_vdpa *v)
> > +{
> > +     struct vdpa_device *vdpa =3D v->vdpa;
> > +     const struct vdpa_config_ops *ops =3D vdpa->config;
> > +
> > +     if (!ops->suspend)
> > +             return -EOPNOTSUPP;
> > +
> > +     return ops->suspend(vdpa);
> > +}
> > +
> >  static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int =
cmd,
> >                                  void __user *argp)
> >  {
> > @@ -654,6 +670,9 @@ static long vhost_vdpa_unlocked_ioctl(struct file *=
filep,
> >       case VHOST_VDPA_GET_VQS_COUNT:
> >               r =3D vhost_vdpa_get_vqs_count(v, argp);
> >               break;
> > +     case VHOST_VDPA_SUSPEND:
> > +             r =3D vhost_vdpa_suspend(v);
> > +             break;
> >       default:
> >               r =3D vhost_dev_ioctl(&v->vdev, cmd, argp);
> >               if (r =3D=3D -ENOIOCTLCMD)
> > diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
> > index cab645d4a645..f9f115a7c75b 100644
> > --- a/include/uapi/linux/vhost.h
> > +++ b/include/uapi/linux/vhost.h
> > @@ -171,4 +171,13 @@
> >  #define VHOST_VDPA_SET_GROUP_ASID    _IOW(VHOST_VIRTIO, 0x7C, \
> >                                            struct vhost_vring_state)
> >
> > +/* Suspend a device so it does not process virtqueue requests anymore
> > + *
> > + * After the return of ioctl the device must preserve all the necessar=
y state
> > + * (the virtqueue vring base plus the possible device specific states)=
 that is
> > + * required for restoring in the future. The device must not change it=
s
> > + * configuration after that point.
> > + */
> > +#define VHOST_VDPA_SUSPEND           _IO(VHOST_VIRTIO, 0x7D)
> > +
> >  #endif
> > --
> > 2.31.1
>

