Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92ED23BFA50
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 14:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbhGHMh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 08:37:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbhGHMh6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 08:37:58 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D48E7C06175F
        for <netdev@vger.kernel.org>; Thu,  8 Jul 2021 05:35:16 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id eb14so8370459edb.0
        for <netdev@vger.kernel.org>; Thu, 08 Jul 2021 05:35:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Wu6CLUxv00p31WZM28ChgDvx5SJMPCO2QmCIwyWG3PM=;
        b=U6cZtcKmsyh3H/V2n0Xzxvx7qb056VzwlcQctTwvLMUMF7slkyJ+u2HRsbCriFsE5h
         SUlDNjw1DCRmDR9shjVBsYFZOliEE/j+TPhM+DIXwfPFBF4nh1YzjjoRUjw9PkkSo8+1
         6ZQYklNc4VZwisy/3BW9hZsTz9E7w3aZJnIxE+m6PtL7D0WHhFDDMJpQKG5ewMF5TJ4k
         oI5r664mikBWgjRcp6x0xUf2wlg9TVu8XFB8xm7C1bTAR/E6U9rpvAx6Px60jaeP2WJg
         4+vxqTNbnUTzTp1ZuP7MIKav4u/N7a/hD83TcfqjElty1g7ECTCGbeQwaXefgo+8cvLP
         lxfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Wu6CLUxv00p31WZM28ChgDvx5SJMPCO2QmCIwyWG3PM=;
        b=BU2CwL4zXVoumjbLK8tvge2BQH+blwOttZunr3TuB0pG4/Yn66vCsiPgZJK3eKDCDX
         y2woZtj3tpGZisa2fW6Nv6gig4Ho/2juGVOOZDikoo+AMm9B9I5cnMwW7V2I+PgYhyts
         /GJMMK0pGzwxLxqjFbzR+lIPMY83y8JrUki8DaS0o89VNQDCTVUO/+uRjmWOX1y1TeRh
         q4NaExjZ3tgs3F3DJHLfPLb8H9af09Q/g172letioheTJpgvRjFM4EG7efUbHR11FEr+
         73GFmJyHx6Sn2i/HYR7lhStilO6iRIouFZjzUILcUydWz6GGwmPoHujmEVKjkbCHXamX
         o6eQ==
X-Gm-Message-State: AOAM530BihFtPQNkG5c1SHh6MXTKdgEPChsxrkC4gMeXGXOeZ6XSTJcA
        IYL+tUUbcZ5W2o7fxOPreBedsACj2zxU2IogaydJ
X-Google-Smtp-Source: ABdhPJxtQ9nu8TipqE3lXJxniWvpUcll2vH4zQXpuoPPvUTARTfDciLs1Ig+iG69XhWR8Dem3ACTnQ/cxZeiJpV2hy8=
X-Received: by 2002:a05:6402:26d4:: with SMTP id x20mr24692796edd.118.1625747715313;
 Thu, 08 Jul 2021 05:35:15 -0700 (PDT)
MIME-Version: 1.0
References: <YOL/9mxkJaokKDHc@stefanha-x1.localdomain> <5b5107fa-3b32-8a3b-720d-eee6b2a84ace@redhat.com>
 <YOQtG3gDOhHDO5CQ@stefanha-x1.localdomain> <CACGkMEs2HHbUfarum8uQ6wuXoDwLQUSXTsa-huJFiqr__4cwRg@mail.gmail.com>
 <YOSOsrQWySr0andk@stefanha-x1.localdomain> <100e6788-7fdf-1505-d69c-bc28a8bc7a78@redhat.com>
 <YOVr801d01YOPzLL@stefanha-x1.localdomain> <a03c8627-7dac-2255-a2d9-603fc623b618@redhat.com>
 <YOXOMiPl7mKd7FoM@stefanha-x1.localdomain> <d5aef112-0828-6b79-4bce-753d3cd496c1@redhat.com>
 <YObAAkabn+nr3taJ@stefanha-x1.localdomain>
In-Reply-To: <YObAAkabn+nr3taJ@stefanha-x1.localdomain>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Thu, 8 Jul 2021 20:35:04 +0800
Message-ID: <CACycT3tOFXU=zfP2qKO3Cy8Ytof3q8Osos3LE+CwMvqnjMkhJg@mail.gmail.com>
Subject: Re: [PATCH v8 10/10] Documentation: Add documentation for VDUSE
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Christian Brauner <christian.brauner@canonical.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>,
        "bcrl@kvack.org" <bcrl@kvack.org>,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?Q?Mika_Penttil=C3=A4?= <mika.penttila@nextfour.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, joro@8bytes.org,
        Greg KH <gregkh@linuxfoundation.org>,
        "songmuchun@bytedance.com" <songmuchun@bytedance.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 8, 2021 at 5:06 PM Stefan Hajnoczi <stefanha@redhat.com> wrote:
>
> On Thu, Jul 08, 2021 at 12:17:56PM +0800, Jason Wang wrote:
> >
> > =E5=9C=A8 2021/7/7 =E4=B8=8B=E5=8D=8811:54, Stefan Hajnoczi =E5=86=99=
=E9=81=93:
> > > On Wed, Jul 07, 2021 at 05:24:08PM +0800, Jason Wang wrote:
> > > > =E5=9C=A8 2021/7/7 =E4=B8=8B=E5=8D=884:55, Stefan Hajnoczi =E5=86=
=99=E9=81=93:
> > > > > On Wed, Jul 07, 2021 at 11:43:28AM +0800, Jason Wang wrote:
> > > > > > =E5=9C=A8 2021/7/7 =E4=B8=8A=E5=8D=881:11, Stefan Hajnoczi =E5=
=86=99=E9=81=93:
> > > > > > > On Tue, Jul 06, 2021 at 09:08:26PM +0800, Jason Wang wrote:
> > > > > > > > On Tue, Jul 6, 2021 at 6:15 PM Stefan Hajnoczi <stefanha@re=
dhat.com> wrote:
> > > > > > > > > On Tue, Jul 06, 2021 at 10:34:33AM +0800, Jason Wang wrot=
e:
> > > > > > > > > > =E5=9C=A8 2021/7/5 =E4=B8=8B=E5=8D=888:49, Stefan Hajno=
czi =E5=86=99=E9=81=93:
> > > > > > > > > > > On Mon, Jul 05, 2021 at 11:36:15AM +0800, Jason Wang =
wrote:
> > > > > > > > > > > > =E5=9C=A8 2021/7/4 =E4=B8=8B=E5=8D=885:49, Yongji X=
ie =E5=86=99=E9=81=93:
> > > > > > > > > > > > > > > OK, I get you now. Since the VIRTIO specifica=
tion says "Device
> > > > > > > > > > > > > > > configuration space is generally used for rar=
ely-changing or
> > > > > > > > > > > > > > > initialization-time parameters". I assume the=
 VDUSE_DEV_SET_CONFIG
> > > > > > > > > > > > > > > ioctl should not be called frequently.
> > > > > > > > > > > > > > The spec uses MUST and other terms to define th=
e precise requirements.
> > > > > > > > > > > > > > Here the language (especially the word "general=
ly") is weaker and means
> > > > > > > > > > > > > > there may be exceptions.
> > > > > > > > > > > > > >
> > > > > > > > > > > > > > Another type of access that doesn't work with t=
he VDUSE_DEV_SET_CONFIG
> > > > > > > > > > > > > > approach is reads that have side-effects. For e=
xample, imagine a field
> > > > > > > > > > > > > > containing an error code if the device encounte=
rs a problem unrelated to
> > > > > > > > > > > > > > a specific virtqueue request. Reading from this=
 field resets the error
> > > > > > > > > > > > > > code to 0, saving the driver an extra configura=
tion space write access
> > > > > > > > > > > > > > and possibly race conditions. It isn't possible=
 to implement those
> > > > > > > > > > > > > > semantics suing VDUSE_DEV_SET_CONFIG. It's anot=
her corner case, but it
> > > > > > > > > > > > > > makes me think that the interface does not allo=
w full VIRTIO semantics.
> > > > > > > > > > > > Note that though you're correct, my understanding i=
s that config space is
> > > > > > > > > > > > not suitable for this kind of error propagating. An=
d it would be very hard
> > > > > > > > > > > > to implement such kind of semantic in some transpor=
ts.  Virtqueue should be
> > > > > > > > > > > > much better. As Yong Ji quoted, the config space is=
 used for
> > > > > > > > > > > > "rarely-changing or intialization-time parameters".
> > > > > > > > > > > >
> > > > > > > > > > > >
> > > > > > > > > > > > > Agreed. I will use VDUSE_DEV_GET_CONFIG in the ne=
xt version. And to
> > > > > > > > > > > > > handle the message failure, I'm going to add a re=
turn value to
> > > > > > > > > > > > > virtio_config_ops.get() and virtio_cread_* API so=
 that the error can
> > > > > > > > > > > > > be propagated to the virtio device driver. Then t=
he virtio-blk device
> > > > > > > > > > > > > driver can be modified to handle that.
> > > > > > > > > > > > >
> > > > > > > > > > > > > Jason and Stefan, what do you think of this way?
> > > > > > > > > > > Why does VDUSE_DEV_GET_CONFIG need to support an erro=
r return value?
> > > > > > > > > > >
> > > > > > > > > > > The VIRTIO spec provides no way for the device to rep=
ort errors from
> > > > > > > > > > > config space accesses.
> > > > > > > > > > >
> > > > > > > > > > > The QEMU virtio-pci implementation returns -1 from in=
valid
> > > > > > > > > > > virtio_config_read*() and silently discards virtio_co=
nfig_write*()
> > > > > > > > > > > accesses.
> > > > > > > > > > >
> > > > > > > > > > > VDUSE can take the same approach with
> > > > > > > > > > > VDUSE_DEV_GET_CONFIG/VDUSE_DEV_SET_CONFIG.
> > > > > > > > > > >
> > > > > > > > > > > > I'd like to stick to the current assumption thich g=
et_config won't fail.
> > > > > > > > > > > > That is to say,
> > > > > > > > > > > >
> > > > > > > > > > > > 1) maintain a config in the kernel, make sure the c=
onfig space read can
> > > > > > > > > > > > always succeed
> > > > > > > > > > > > 2) introduce an ioctl for the vduse usersapce to up=
date the config space.
> > > > > > > > > > > > 3) we can synchronize with the vduse userspace duri=
ng set_config
> > > > > > > > > > > >
> > > > > > > > > > > > Does this work?
> > > > > > > > > > > I noticed that caching is also allowed by the vhost-u=
ser protocol
> > > > > > > > > > > messages (QEMU's docs/interop/vhost-user.rst), but th=
e device doesn't
> > > > > > > > > > > know whether or not caching is in effect. The interfa=
ce you outlined
> > > > > > > > > > > above requires caching.
> > > > > > > > > > >
> > > > > > > > > > > Is there a reason why the host kernel vDPA code needs=
 to cache the
> > > > > > > > > > > configuration space?
> > > > > > > > > > Because:
> > > > > > > > > >
> > > > > > > > > > 1) Kernel can not wait forever in get_config(), this is=
 the major difference
> > > > > > > > > > with vhost-user.
> > > > > > > > > virtio_cread() can sleep:
> > > > > > > > >
> > > > > > > > >      #define virtio_cread(vdev, structname, member, ptr) =
                    \
> > > > > > > > >              do {                                        =
                    \
> > > > > > > > >                      typeof(((structname*)0)->member) vir=
tio_cread_v;        \
> > > > > > > > >                                                          =
                    \
> > > > > > > > >                      might_sleep();                      =
                    \
> > > > > > > > >                      ^^^^^^^^^^^^^^
> > > > > > > > >
> > > > > > > > > Which code path cannot sleep?
> > > > > > > > Well, it can sleep but it can't sleep forever. For VDUSE, a
> > > > > > > > buggy/malicious userspace may refuse to respond to the get_=
config.
> > > > > > > >
> > > > > > > > It looks to me the ideal case, with the current virtio spec=
, for VDUSE is to
> > > > > > > >
> > > > > > > > 1) maintain the device and its state in the kernel, userspa=
ce may sync
> > > > > > > > with the kernel device via ioctls
> > > > > > > > 2) offload the datapath (virtqueue) to the userspace
> > > > > > > >
> > > > > > > > This seems more robust and safe than simply relaying everyt=
hing to
> > > > > > > > userspace and waiting for its response.
> > > > > > > >
> > > > > > > > And we know for sure this model can work, an example is TUN=
/TAP:
> > > > > > > > netdevice is abstracted in the kernel and datapath is done =
via
> > > > > > > > sendmsg()/recvmsg().
> > > > > > > >
> > > > > > > > Maintaining the config in the kernel follows this model and=
 it can
> > > > > > > > simplify the device generation implementation.
> > > > > > > >
> > > > > > > > For config space write, it requires more thought but fortun=
ately it's
> > > > > > > > not commonly used. So VDUSE can choose to filter out the
> > > > > > > > device/features that depends on the config write.
> > > > > > > This is the problem. There are other messages like SET_FEATUR=
ES where I
> > > > > > > guess we'll face the same challenge.
> > > > > > Probably not, userspace device can tell the kernel about the de=
vice_features
> > > > > > and mandated_features during creation, and the feature negotiat=
ion could be
> > > > > > done purely in the kernel without bothering the userspace.
> > > >
> > > > (For some reason I drop the list accidentally, adding them back, so=
rry)
> > > >
> > > >
> > > > > Sorry, I confused the messages. I meant SET_STATUS. It's a synchr=
onous
> > > > > interface where the driver waits for the device.
> > > >
> > > > It depends on how we define "synchronous" here. If I understand cor=
rectly,
> > > > the spec doesn't expect there will be any kind of failure for the o=
peration
> > > > of set_status itself.
> > > >
> > > > Instead, anytime it want any synchronization, it should be done via
> > > > get_status():
> > > >
> > > > 1) re-read device status to make sure FEATURES_OK is set during fea=
ture
> > > > negotiation
> > > > 2) re-read device status to be 0 to make sure the device has finish=
 the
> > > > reset
> > > >
> > > >
> > > > > VDUSE currently doesn't wait for the device emulation process to =
handle
> > > > > this message (no reply is needed) but I think this is a mistake b=
ecause
> > > > > VDUSE is not following the VIRTIO device model.
> > > >
> > > > With the trick that is done for FEATURES_OK above, I think we don't=
 need to
> > > > wait for the reply.
> > > >
> > > > If userspace takes too long to respond, it can be detected since
> > > > get_status() doesn't return the expected value for long time.
> > > >
> > > > And for the case that needs a timeout, we probably can use NEEDS_RE=
SET.
> > > I think you're right. get_status is the synchronization point, not
> > > set_status.
> > >
> > > Currently there is no VDUSE GET_STATUS message. The
> > > VDUSE_START/STOP_DATAPLANE messages could be changed to SET_STATUS so
> > > that the device emulation program can participate in emulating the
> > > Device Status field.
> >
> >
> > I'm not sure I get this, but it is what has been done?
> >
> > +static void vduse_vdpa_set_status(struct vdpa_device *vdpa, u8 status)
> > +{
> > +    struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> > +    bool started =3D !!(status & VIRTIO_CONFIG_S_DRIVER_OK);
> > +
> > +    dev->status =3D status;
> > +
> > +    if (dev->started =3D=3D started)
> > +        return;
> > +
> > +    dev->started =3D started;
> > +    if (dev->started) {
> > +        vduse_dev_start_dataplane(dev);
> > +    } else {
> > +        vduse_dev_reset(dev);
> > +        vduse_dev_stop_dataplane(dev);
> > +    }
> > +}
> >
> >
> > But the looks not correct:
> >
> > 1) !DRIVER_OK doesn't means a reset?
> > 2) Need to deal with FEATURES_OK
>
> I'm not sure if this reply was to me or to Yongji Xie?
>
> Currently vduse_vdpa_set_status() does not allow the device emulation
> program to participate fully in Device Status field changes. It hides
> the status bits and only sends VDUSE_START/STOP_DATAPLANE.
>
> I suggest having GET_STATUS/SET_STATUS messages instead, allowing the
> device emulation program to handle these parts of the VIRTIO device
> model (e.g. rejecting combinations of features that are mutually
> exclusive).
>

Yes, I will do this in the next version.

Thanks,
Yongi
