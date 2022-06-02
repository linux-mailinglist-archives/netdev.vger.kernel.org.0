Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED1E53B36D
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 08:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbiFBGWm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 02:22:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230454AbiFBGWk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 02:22:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D718427CF7
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 23:22:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654150955;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dftoX5xxTZB/c8O5WA81vrlQezqU2CDPcAxmSZhNEc4=;
        b=Hxp3PweVceqPY9q0omzQ4eKyLu/maXeie1mURY0XlG/gN9FWUHFdPVV/A6q/lZNwDvzWhQ
        QpEGRV0FWauwoJCi/T0YG9VfQ/grfR0nwfZrN1yorRRFR3cAfRGW0FoAOThmhdIXVQXSMD
        Yut10gLONjr3+n/DQjmEQPYkhrxQPBQ=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-34-MYWcukJ-OF6UpB-_ZsWe9A-1; Thu, 02 Jun 2022 02:22:32 -0400
X-MC-Unique: MYWcukJ-OF6UpB-_ZsWe9A-1
Received: by mail-qt1-f197.google.com with SMTP id s36-20020a05622a1aa400b00304b8f28352so2979302qtc.23
        for <netdev@vger.kernel.org>; Wed, 01 Jun 2022 23:22:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=dftoX5xxTZB/c8O5WA81vrlQezqU2CDPcAxmSZhNEc4=;
        b=DTvvsmlDNbyc9lGIiOw06gxhCuoa0DuBkok8cZknBgQin6iUjczOHRoc8wPNVBwzx6
         aNHjM5bwxxWL/Vxg7lhg+y227JYH/SiAqf88o7u7432srwDaXVuSePb0vPAWS7IFUWpb
         vE+F6jFADoGMT7UCpGQBwZShwQMNFaZUUarESSo/CyGh4dzXuGKADtHLDM03JwABw/C8
         QGhLEhiYPVaMWjLnUzxTid2nO99CbToTBBlq4xOdqtuk1hefyTFKmLgGQlKhsNYubGLa
         CkF+KR4m7lHVR1x7n/l9xpa9g97ofgTcpyLcwJNuthbSk9v+7bdJqrmXcAdu8lNXr2Bq
         SHpA==
X-Gm-Message-State: AOAM531ohEvHB8K9fhEwREYYeMElhTd34/SdZkYnWYGiHx4XsEMkJ8PG
        itnorQFPUmtfpGsc6DV3oiLKulPMYPs/aiYd4HVrYXR5vhceuBSkjiTaptxGktah78R/GnBHFXs
        zSPxJO37CjxtzkqcV7yY2ERXx27a1Qky/
X-Received: by 2002:a0c:e702:0:b0:467:538e:ebba with SMTP id d2-20020a0ce702000000b00467538eebbamr2217017qvn.2.1654150951941;
        Wed, 01 Jun 2022 23:22:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz0WJo9DePlOEq7IsA8BZdRFxkhg64PwaZaZWcafFZW35XH5PUzPmmmXhlP8oswWj9PLLjDa3nyytbYkOLb1wI=
X-Received: by 2002:a0c:e702:0:b0:467:538e:ebba with SMTP id
 d2-20020a0ce702000000b00467538eebbamr2216984qvn.2.1654150951730; Wed, 01 Jun
 2022 23:22:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220526124338.36247-1-eperezma@redhat.com> <20220526124338.36247-4-eperezma@redhat.com>
 <20220601070303-mutt-send-email-mst@kernel.org> <CAJaqyWcK7CwWLr5unxXr=FDbuufeA38X0eAboJy8yKLcsdiPow@mail.gmail.com>
 <PH0PR12MB54819A5DC204CED360C3BA86DCDF9@PH0PR12MB5481.namprd12.prod.outlook.com>
In-Reply-To: <PH0PR12MB54819A5DC204CED360C3BA86DCDF9@PH0PR12MB5481.namprd12.prod.outlook.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Thu, 2 Jun 2022 08:21:55 +0200
Message-ID: <CAJaqyWfJVDj+u0UVXGkJFriRJ5Lo5os6FWq02Q7av+NYG2JB9w@mail.gmail.com>
Subject: Re: [PATCH v4 3/4] vhost-vdpa: uAPI to stop the device
To:     Parav Pandit <parav@nvidia.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Martin Petrus Hubertus Habets <martinh@xilinx.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Martin Porter <martinpo@xilinx.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Pablo Cascon Katchadourian <pabloc@xilinx.com>,
        Eli Cohen <elic@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Zhang Min <zhang.min9@zte.com.cn>,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        Cindy Lu <lulu@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        "Uminski, Piotr" <Piotr.Uminski@intel.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        "Dawar, Gautam" <gautam.dawar@amd.com>,
        "habetsm.xilinx@gmail.com" <habetsm.xilinx@gmail.com>,
        "Kamde, Tanuj" <tanuj.kamde@amd.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Dinan Gunawardena <dinang@xilinx.com>,
        Longpeng <longpeng2@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 1, 2022 at 9:13 PM Parav Pandit <parav@nvidia.com> wrote:
>
>
>
> > From: Eugenio Perez Martin <eperezma@redhat.com>
> > Sent: Wednesday, June 1, 2022 7:15 AM
> >
> > On Wed, Jun 1, 2022 at 1:03 PM Michael S. Tsirkin <mst@redhat.com> wrot=
e:
> > >
> > > On Thu, May 26, 2022 at 02:43:37PM +0200, Eugenio P=C3=A9rez wrote:
> > > > The ioctl adds support for stop the device from userspace.
> > > >
> > > > Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> > > > ---
> > > >  drivers/vhost/vdpa.c       | 18 ++++++++++++++++++
> > > >  include/uapi/linux/vhost.h | 14 ++++++++++++++
> > > >  2 files changed, 32 insertions(+)
> > > >
> > > > diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c index
> > > > 32713db5831d..d1d19555c4b7 100644
> > > > --- a/drivers/vhost/vdpa.c
> > > > +++ b/drivers/vhost/vdpa.c
> > > > @@ -478,6 +478,21 @@ static long vhost_vdpa_get_vqs_count(struct
> > vhost_vdpa *v, u32 __user *argp)
> > > >       return 0;
> > > >  }
> > > >
> > > > +static long vhost_vdpa_stop(struct vhost_vdpa *v, u32 __user *argp=
)
> > > > +{
> > > > +     struct vdpa_device *vdpa =3D v->vdpa;
> > > > +     const struct vdpa_config_ops *ops =3D vdpa->config;
> > > > +     int stop;
> > > > +
> > > > +     if (!ops->stop)
> > > > +             return -EOPNOTSUPP;
> > > > +
> > > > +     if (copy_from_user(&stop, argp, sizeof(stop)))
> > > > +             return -EFAULT;
> > > > +
> > > > +     return ops->stop(vdpa, stop);
> > > > +}
> > > > +
> > > >  static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned =
int
> > cmd,
> > > >                                  void __user *argp)  { @@ -650,6
> > > > +665,9 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
> > > >       case VHOST_VDPA_GET_VQS_COUNT:
> > > >               r =3D vhost_vdpa_get_vqs_count(v, argp);
> > > >               break;
> > > > +     case VHOST_VDPA_STOP:
> > > > +             r =3D vhost_vdpa_stop(v, argp);
> > > > +             break;
> > > >       default:
> > > >               r =3D vhost_dev_ioctl(&v->vdev, cmd, argp);
> > > >               if (r =3D=3D -ENOIOCTLCMD) diff --git
> > > > a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h index
> > > > cab645d4a645..c7e47b29bf61 100644
> > > > --- a/include/uapi/linux/vhost.h
> > > > +++ b/include/uapi/linux/vhost.h
> > > > @@ -171,4 +171,18 @@
> > > >  #define VHOST_VDPA_SET_GROUP_ASID    _IOW(VHOST_VIRTIO, 0x7C,
> > \
> > > >                                            struct vhost_vring_state=
)
> > > >
> > > > +/* Stop or resume a device so it does not process virtqueue
> > > > +requests anymore
> > > > + *
> > > > + * After the return of ioctl with stop !=3D 0, the device must fin=
ish
> > > > +any
> > > > + * pending operations like in flight requests. It must also
> > > > +preserve all
> > > > + * the necessary state (the virtqueue vring base plus the possible
> > > > +device
> > > > + * specific states) that is required for restoring in the future.
> > > > +The
> > > > + * device must not change its configuration after that point.
> > > > + *
> > > > + * After the return of ioctl with stop =3D=3D 0, the device can
> > > > +continue
> > > > + * processing buffers as long as typical conditions are met (vq is
> > > > +enabled,
> > > > + * DRIVER_OK status bit is enabled, etc).
> > > > + */
> > > > +#define VHOST_VDPA_STOP                      _IOW(VHOST_VIRTIO, 0x=
7D, int)
> > > > +
> A better name is VHOST_VDPA_SET_STATE
> State =3D stop/suspend
> State =3D start/resume
>
> Suspend/resume seems more logical, as opposed start/stop, because it more=
 clearly indicates that the resume (start) is from some programmed beginnin=
g (and not first boot).
>

It's fine to move to that nomenclature in my opinion.

> > > >  #endif
> > >
> > > I wonder how does this interact with the admin vq idea.
> > > I.e. if we stop all VQs then apparently admin vq can't work either ..=
.
> > > Thoughts?
> > >
> >
> > Copying here the answer to Parav, feel free to answer to any thread or
> > highlight if I missed something :). Using the admin vq proposal termino=
logy of
> > "device group".
> >
> > --
> > This would stop a device of a device
> > group, but not the whole virtqueue group. If the admin VQ is offered by=
 the
> > PF (since it's not exposed to the guest), it will continue accepting re=
quests as
> > normal. If it's exposed in the VF, I think the best bet is to shadow it=
, since
> > guest and host requests could conflict.
> >
>
> vhost-vdpa device is exposed for a VF through vp-vdpa driver to user land=
.
> Now vp-vdpa driver will have to choose between using config register vs u=
sing AQ to suspend/resume the device.
>

vp_vdpa cannot choose if the virtio device has an admin vq or any
other feature, it just wraps the virtio device. If that virtio device
does not expose AQ, vp_vdpa cannot expose it.

> Why not always begin with more superior interface of AQ that address mult=
iple of these needs for LM case?
>

Because it doesn't address valid use cases like vp_vdpa with no AQ,
devices that are not VF, or nested virtualization.

VHOST_VDPA_STOP / VHOST_VDPA_SET_STATE does not replace AQ commands:
It's just the way vhost-vdpa exposes that capability to qemu. vdpa
backend is free to choose whatever methods it finds better to
implement it.

> For LM case, more you explore, we realize that either VF relying on PF's =
AQ for query/config/setup/restore makes more sense or have its own dedicate=
d AQ.
>

This ioctl does not mandate that the device cannot implement it
through AQ, or that the device has to be a VF.

Thanks!

> VM's suspend/resume operation can be handled through the shadow Q.
>
> > Since this is offered through vdpa, the device backend driver can route=
 it to
> > whatever method works better for the hardware. For example, to send an
> > admin vq command to the PF. That's why it's important to keep the featu=
re
> > as self-contained and orthogonal to others as possible.
> > --
> >
> > > > --
> > > > 2.31.1
> > >
>

