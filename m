Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2680553A3B0
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 13:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352596AbiFALPw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 07:15:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352589AbiFALPu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 07:15:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DE5BEA2058
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 04:15:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654082149;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a0kzdEPVlsKUsss8CVBPt526beqGmW7esjoGk5RxzSg=;
        b=Erm1KJrJ4b7S9dgcN1hNbkjoBZVkP/ZJ1MJVvQnmvzTUDYK44lTcN3vn/T1XsI7aJI2HQ2
        zvAvs9FSUUl/lcj88K+B+s77Jkq3XY3EBk55skya/+F6VsD1eIWii6dLMjJkYC4pTmqsch
        g0SuY/fpINtobsL38vBzjL2Je3BA2oE=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-341-VKkPGISWOGmmlItufWsH8g-1; Wed, 01 Jun 2022 07:15:45 -0400
X-MC-Unique: VKkPGISWOGmmlItufWsH8g-1
Received: by mail-qt1-f200.google.com with SMTP id u17-20020a05622a199100b002fbc827c739so1034520qtc.8
        for <netdev@vger.kernel.org>; Wed, 01 Jun 2022 04:15:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=a0kzdEPVlsKUsss8CVBPt526beqGmW7esjoGk5RxzSg=;
        b=YvFjWTlort+Fcn33wGtasvXjqQXMM8QQWmje14bztV1woeR+BNw4V/jv9QZOtqN+pL
         8FfsOUvOhawFhxWR1mWdg2vhyWuCdjualwVyj7rGc5NTra4ydo4IUxHdG0BlL12FxjTt
         cJ5/M/eZBzPECYTW8Qk7j7gCT2WJsxYZymYIXbHdt5Qq8N2Fjp4+tHk1y8uCokhxyIBy
         XWTIVjCY4ge1dPRjY7p7VwD+KtksJHchnymuNcLs8WRoGO594C3Nsye4FmCH1Jl4mm+t
         3GzTxmL9EE4Rrw1xbaGHaxg7lw3SAMN9n/RzJWsn9EOw91Rygnp3bUwcO6sGWP3A+MU7
         ErAA==
X-Gm-Message-State: AOAM532yECbpaIADJ1QMsEKE1ATmLq1Z4TCr/dRhhYU7LKrloeA//Yjs
        2Oe3Edu71Fi28pJUHS6JNpZ6Rm/perYzbjLNV1LgFxnHh4LX/TOVIr52M9t09Cv2B5EvH92mVJU
        pxzkRSdQdep8C/JLTjoxyV1MohXOUS3ei
X-Received: by 2002:a05:620a:2804:b0:67d:1e7b:b528 with SMTP id f4-20020a05620a280400b0067d1e7bb528mr44009333qkp.193.1654082145005;
        Wed, 01 Jun 2022 04:15:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxFXMZXLVyFwTyYq6IDOWeXu8G9b4pZz4jhyq32PX89m0mCaVF+Znn3KVg7Aol3B6sxVE+47vjCI0GRB17nZ18=
X-Received: by 2002:a05:620a:2804:b0:67d:1e7b:b528 with SMTP id
 f4-20020a05620a280400b0067d1e7bb528mr44009313qkp.193.1654082144729; Wed, 01
 Jun 2022 04:15:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220526124338.36247-1-eperezma@redhat.com> <20220526124338.36247-4-eperezma@redhat.com>
 <20220601070303-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220601070303-mutt-send-email-mst@kernel.org>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Wed, 1 Jun 2022 13:15:08 +0200
Message-ID: <CAJaqyWcK7CwWLr5unxXr=FDbuufeA38X0eAboJy8yKLcsdiPow@mail.gmail.com>
Subject: Re: [PATCH v4 3/4] vhost-vdpa: uAPI to stop the device
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Martin Petrus Hubertus Habets <martinh@xilinx.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Martin Porter <martinpo@xilinx.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Pablo Cascon Katchadourian <pabloc@xilinx.com>,
        Parav Pandit <parav@nvidia.com>, Eli Cohen <elic@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Zhang Min <zhang.min9@zte.com.cn>,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        Cindy Lu <lulu@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        "Uminski, Piotr" <Piotr.Uminski@intel.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>, ecree.xilinx@gmail.com,
        "Dawar, Gautam" <gautam.dawar@amd.com>, habetsm.xilinx@gmail.com,
        "Kamde, Tanuj" <tanuj.kamde@amd.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Dinan Gunawardena <dinang@xilinx.com>,
        Longpeng <longpeng2@huawei.com>
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

On Wed, Jun 1, 2022 at 1:03 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Thu, May 26, 2022 at 02:43:37PM +0200, Eugenio P=C3=A9rez wrote:
> > The ioctl adds support for stop the device from userspace.
> >
> > Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> > ---
> >  drivers/vhost/vdpa.c       | 18 ++++++++++++++++++
> >  include/uapi/linux/vhost.h | 14 ++++++++++++++
> >  2 files changed, 32 insertions(+)
> >
> > diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> > index 32713db5831d..d1d19555c4b7 100644
> > --- a/drivers/vhost/vdpa.c
> > +++ b/drivers/vhost/vdpa.c
> > @@ -478,6 +478,21 @@ static long vhost_vdpa_get_vqs_count(struct vhost_=
vdpa *v, u32 __user *argp)
> >       return 0;
> >  }
> >
> > +static long vhost_vdpa_stop(struct vhost_vdpa *v, u32 __user *argp)
> > +{
> > +     struct vdpa_device *vdpa =3D v->vdpa;
> > +     const struct vdpa_config_ops *ops =3D vdpa->config;
> > +     int stop;
> > +
> > +     if (!ops->stop)
> > +             return -EOPNOTSUPP;
> > +
> > +     if (copy_from_user(&stop, argp, sizeof(stop)))
> > +             return -EFAULT;
> > +
> > +     return ops->stop(vdpa, stop);
> > +}
> > +
> >  static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int =
cmd,
> >                                  void __user *argp)
> >  {
> > @@ -650,6 +665,9 @@ static long vhost_vdpa_unlocked_ioctl(struct file *=
filep,
> >       case VHOST_VDPA_GET_VQS_COUNT:
> >               r =3D vhost_vdpa_get_vqs_count(v, argp);
> >               break;
> > +     case VHOST_VDPA_STOP:
> > +             r =3D vhost_vdpa_stop(v, argp);
> > +             break;
> >       default:
> >               r =3D vhost_dev_ioctl(&v->vdev, cmd, argp);
> >               if (r =3D=3D -ENOIOCTLCMD)
> > diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
> > index cab645d4a645..c7e47b29bf61 100644
> > --- a/include/uapi/linux/vhost.h
> > +++ b/include/uapi/linux/vhost.h
> > @@ -171,4 +171,18 @@
> >  #define VHOST_VDPA_SET_GROUP_ASID    _IOW(VHOST_VIRTIO, 0x7C, \
> >                                            struct vhost_vring_state)
> >
> > +/* Stop or resume a device so it does not process virtqueue requests a=
nymore
> > + *
> > + * After the return of ioctl with stop !=3D 0, the device must finish =
any
> > + * pending operations like in flight requests. It must also preserve a=
ll
> > + * the necessary state (the virtqueue vring base plus the possible dev=
ice
> > + * specific states) that is required for restoring in the future. The
> > + * device must not change its configuration after that point.
> > + *
> > + * After the return of ioctl with stop =3D=3D 0, the device can contin=
ue
> > + * processing buffers as long as typical conditions are met (vq is ena=
bled,
> > + * DRIVER_OK status bit is enabled, etc).
> > + */
> > +#define VHOST_VDPA_STOP                      _IOW(VHOST_VIRTIO, 0x7D, =
int)
> > +
> >  #endif
>
> I wonder how does this interact with the admin vq idea.
> I.e. if we stop all VQs then apparently admin vq can't
> work either ...
> Thoughts?
>

Copying here the answer to Parav, feel free to answer to any thread or
highlight if I missed something :). Using the admin vq proposal
terminology of "device group".

--
This would stop a device of a device
group, but not the whole virtqueue group. If the admin VQ is offered
by the PF (since it's not exposed to the guest), it will continue
accepting requests as normal. If it's exposed in the VF, I think the
best bet is to shadow it, since guest and host requests could
conflict.

Since this is offered through vdpa, the device backend driver can
route it to whatever method works better for the hardware. For
example, to send an admin vq command to the PF. That's why it's
important to keep the feature as self-contained and orthogonal to
others as possible.
--

> > --
> > 2.31.1
>

