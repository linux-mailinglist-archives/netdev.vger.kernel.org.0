Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 442695713FC
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 10:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232577AbiGLIJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 04:09:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232545AbiGLIJM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 04:09:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6C7E433A34
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 01:09:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657613350;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rJcskA/Zg+I54A7KxLAxiRGb8qrTlBqKeeRMZ0ymcfk=;
        b=NF3TB8hXvcEVSErbhcA45YJ3KCRdcJ1zJl4uQgvg40NzZMrKwNVxZxWATPNXtUdgF6zKmE
        2QTGTC56SraZollrrs3/AzVo5c2yUDfYyzOpTvE+ekbdzOozO3FOuqrrsmRUz2bUz/6c1I
        B82n9j/DeF1ccBByYVfW+0nBY49q/Xs=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-637-YIY37TV-MyiLCUS7QhaKUw-1; Tue, 12 Jul 2022 04:09:09 -0400
X-MC-Unique: YIY37TV-MyiLCUS7QhaKUw-1
Received: by mail-lf1-f69.google.com with SMTP id br6-20020a056512400600b00482af9d63faso3327963lfb.22
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 01:09:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rJcskA/Zg+I54A7KxLAxiRGb8qrTlBqKeeRMZ0ymcfk=;
        b=eiDmEzjhEx6vC5Bf3HFk/50LJevHaWk7vp0genonciGdlOyFdUUt+HPg62egMAabOl
         Wkc57HN9SpAlbyQohHp3mgAfL3JfzCqR5xPjJ5nPjQ9YTfIKE7hMp2D2FIuR8vy2/D11
         hhfIhVOqQCMlBscvNLKrSb1165vUxiaxENR1RukuRtOMgno04x8U+9uzy1TWj4A8cyMx
         qh/TiAzAiKA1dg63Rn1eLrlB2riHUKThV8Z0jCH5phPusmZK0QBclVHDsbb06DFS364+
         uf+h2hZjscCdbzMICjlQzh1E+91xZ1ItB2jCspf8NWeU4UZCUaaTx7Fanywg1CgkSQw4
         0vzw==
X-Gm-Message-State: AJIora/jS3n/CQNHP/o8ZADmrczuHY82UrwMgjKTDMHISPMRjIeEi2HR
        YVen7eV8PXHm08nnAAcesVHAWHQQlB2nFPehgxnUIFb5wirlV3veZS+cQhvOw82mjb3r/NtE4ng
        boUHWmMs9uCXVs/n/jTQK80ieA6/B622C
X-Received: by 2002:ac2:50d1:0:b0:489:fb36:cde1 with SMTP id h17-20020ac250d1000000b00489fb36cde1mr264133lfm.411.1657613347827;
        Tue, 12 Jul 2022 01:09:07 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vjIfYeHw/U8j+flo57s9r09p+WpV9Mywo429Jk8FiV/6lmU1F4kq5TwCDtQJDxdvwRs4LWoN08HBHaUIS+RT0=
X-Received: by 2002:ac2:50d1:0:b0:489:fb36:cde1 with SMTP id
 h17-20020ac250d1000000b00489fb36cde1mr264103lfm.411.1657613347609; Tue, 12
 Jul 2022 01:09:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220623160738.632852-1-eperezma@redhat.com> <20220623160738.632852-4-eperezma@redhat.com>
 <CACGkMEt6YQvtyYwkYVxmZ01pZJK9PMFM2oPTVttPZ_kZDY-9Jw@mail.gmail.com> <CAJaqyWfGXu8k7JN1gCPdUXS2_Dct73w4wS_SdB3aLqVCWJqJQg@mail.gmail.com>
In-Reply-To: <CAJaqyWfGXu8k7JN1gCPdUXS2_Dct73w4wS_SdB3aLqVCWJqJQg@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 12 Jul 2022 16:08:56 +0800
Message-ID: <CACGkMEv0W=CYduTV44R71knWwyoEd9VAth0eHuwEFa9T4Njhhg@mail.gmail.com>
Subject: Re: [PATCH v6 3/4] vhost-vdpa: uAPI to suspend the device
To:     Eugenio Perez Martin <eperezma@redhat.com>
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
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 8, 2022 at 7:53 PM Eugenio Perez Martin <eperezma@redhat.com> w=
rote:
>
> On Wed, Jun 29, 2022 at 6:16 AM Jason Wang <jasowang@redhat.com> wrote:
> >
> > On Fri, Jun 24, 2022 at 12:08 AM Eugenio P=C3=A9rez <eperezma@redhat.co=
m> wrote:
> > >
> > > The ioctl adds support for suspending the device from userspace.
> > >
> > > This is a must before getting virtqueue indexes (base) for live migra=
tion,
> > > since the device could modify them after userland gets them. There ar=
e
> > > individual ways to perform that action for some devices
> > > (VHOST_NET_SET_BACKEND, VHOST_VSOCK_SET_RUNNING, ...) but there was n=
o
> > > way to perform it for any vhost device (and, in particular, vhost-vdp=
a).
> > >
> > > After a successful return of the ioctl call the device must not proce=
ss
> > > more virtqueue descriptors. The device can answer to read or writes o=
f
> > > config fields as if it were not suspended. In particular, writing to
> > > "queue_enable" with a value of 1 will not make the device start
> > > processing buffers of the virtqueue.
> > >
> > > Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> > > ---
> > >  drivers/vhost/vdpa.c       | 19 +++++++++++++++++++
> > >  include/uapi/linux/vhost.h | 14 ++++++++++++++
> > >  2 files changed, 33 insertions(+)
> > >
> > > diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> > > index 3d636e192061..7fa671ac4bdf 100644
> > > --- a/drivers/vhost/vdpa.c
> > > +++ b/drivers/vhost/vdpa.c
> > > @@ -478,6 +478,22 @@ static long vhost_vdpa_get_vqs_count(struct vhos=
t_vdpa *v, u32 __user *argp)
> > >         return 0;
> > >  }
> > >
> > > +/* After a successful return of ioctl the device must not process mo=
re
> > > + * virtqueue descriptors. The device can answer to read or writes of=
 config
> > > + * fields as if it were not suspended. In particular, writing to "qu=
eue_enable"
> > > + * with a value of 1 will not make the device start processing buffe=
rs.
> > > + */
> > > +static long vhost_vdpa_suspend(struct vhost_vdpa *v)
> > > +{
> > > +       struct vdpa_device *vdpa =3D v->vdpa;
> > > +       const struct vdpa_config_ops *ops =3D vdpa->config;
> > > +
> > > +       if (!ops->suspend)
> > > +               return -EOPNOTSUPP;
> > > +
> > > +       return ops->suspend(vdpa);
> > > +}
> > > +
> > >  static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned in=
t cmd,
> > >                                    void __user *argp)
> > >  {
> > > @@ -654,6 +670,9 @@ static long vhost_vdpa_unlocked_ioctl(struct file=
 *filep,
> > >         case VHOST_VDPA_GET_VQS_COUNT:
> > >                 r =3D vhost_vdpa_get_vqs_count(v, argp);
> > >                 break;
> > > +       case VHOST_VDPA_SUSPEND:
> > > +               r =3D vhost_vdpa_suspend(v);
> > > +               break;
> > >         default:
> > >                 r =3D vhost_dev_ioctl(&v->vdev, cmd, argp);
> > >                 if (r =3D=3D -ENOIOCTLCMD)
> > > diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
> > > index cab645d4a645..6d9f45163155 100644
> > > --- a/include/uapi/linux/vhost.h
> > > +++ b/include/uapi/linux/vhost.h
> > > @@ -171,4 +171,18 @@
> > >  #define VHOST_VDPA_SET_GROUP_ASID      _IOW(VHOST_VIRTIO, 0x7C, \
> > >                                              struct vhost_vring_state=
)
> > >
> > > +/* Suspend or resume a device so it does not process virtqueue reque=
sts anymore
> > > + *
> > > + * After the return of ioctl with suspend !=3D 0, the device must fi=
nish any
> > > + * pending operations like in flight requests.
> >
> > I'm not sure we should mandate the flush here. This probably blocks us
> > from adding inflight descriptor reporting in the future.
> >
>
> That's right. Maybe we should add a flags argument to allow not to
> flush in flight descriptors in the future? Or maybe the right solution
> is to discard that requirement and to mandate in_order to be
> migratable at the moment?

I think it's better not to limit the device behaviour like flush or
in_order here. This may simplify the work for adding inflight
descriptor support.

For the device that doesn't care about the inflight descriptor, this
patch is sufficient for doing live migration.
For the device that requires an inflight descriptor, this patch is
insufficient, it requires future extension to get those descriptors.
In this case, device has the flexibility to flush or not so:

1) if we don't get any inflight descriptors, the device may do the flush be=
fore
2) if we get inflight descriptors, we need to restore them

Thanks

>
> Thanks!
>
> > Thanks
> >
> > It must also preserve all the
> > > + * necessary state (the virtqueue vring base plus the possible devic=
e specific
> > > + * states) that is required for restoring in the future. The device =
must not
> > > + * change its configuration after that point.
> > > + *
> > > + * After the return of ioctl with suspend =3D=3D 0, the device can c=
ontinue
> > > + * processing buffers as long as typical conditions are met (vq is e=
nabled,
> > > + * DRIVER_OK status bit is enabled, etc).
> > > + */
> > > +#define VHOST_VDPA_SUSPEND             _IOW(VHOST_VIRTIO, 0x7D, int)
> > > +
> > >  #endif
> > > --
> > > 2.31.1
> > >
> >
>

