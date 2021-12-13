Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C65F472357
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 09:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231772AbhLMI54 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 03:57:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53952 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233487AbhLMI5z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 03:57:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639385874;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p9DVBPqK/d21aVsh+v6i0c9OVAXlQK07WZGATq/KnvE=;
        b=Uy/2QEiekuZZsyO/ICD4Sbw/vjqLtUBie59Qkse0v445p2qlsWgbOo+B/MtmqhlRu50QWh
        QCUzgyT1eB529KQ6GUTxW5KToxwZIZvO9TFYqAQDMXiajlWC2/ViGvzsQTqUkVs5LvHLol
        Qsi/gfEJLUwGmOcozZaz/l0VTog7W8Q=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-262-NmGG97fNPxy32faj6IB5jg-1; Mon, 13 Dec 2021 03:57:51 -0500
X-MC-Unique: NmGG97fNPxy32faj6IB5jg-1
Received: by mail-lj1-f199.google.com with SMTP id s16-20020a2ea710000000b0021b674e9347so4268585lje.8
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 00:57:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=p9DVBPqK/d21aVsh+v6i0c9OVAXlQK07WZGATq/KnvE=;
        b=ghkaznJ/zbnN4ceFd9z58IzC4cU4IvyWDCaFR3nWrTnLuFxEu7QvyOgMkK8cDaauTe
         yZRgqSbYijgfkWGGH3XsoZVBjZeKY5cOV79wcfVGX2HtappKC01gz4mne99sE9XRY95S
         ktafY+8q42vqhpzmchbimS0O8VlmZtHImq8X/Ump5h7uGJWAhtZamOsVabQ/pYrbXjAF
         eRdQwkDmmFC1bFZeyEgAB/3lp7Ir7oxe2NzO81eiECzTsVoDQMKORGvZJkcajMLvVILb
         rerGmttGcrq7B3brclbyXwPeh/2bYOwypKmi5hHiuQWP5o0CVyGd5+L5Y2w7vArn355U
         DtmQ==
X-Gm-Message-State: AOAM532qgk7ATTisz2a0NkLBhc063Js7O+3bkdYDB9a/+ayD0SKMChoK
        Y3L4pTm0dn/LfmPwKVkjTt35iYm+jUNp6recE6ZPp2TgWTwUlAxSpLRa1FFLg9irpvG/hAqnyC9
        2A3Ktz2LEBqtUjdhejSam2yy3brRz54ei
X-Received: by 2002:a05:6512:3b2b:: with SMTP id f43mr28111796lfv.629.1639385869926;
        Mon, 13 Dec 2021 00:57:49 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwKQv6cjOzLwU+SaW+IgVD/YNCHy3d5cQA+UHXctkBj0q7a1O8d5EuvuGrOXD0FCaxdFFZAe4G2ilJ7UjuF+y4=
X-Received: by 2002:a05:6512:3b2b:: with SMTP id f43mr28111776lfv.629.1639385869712;
 Mon, 13 Dec 2021 00:57:49 -0800 (PST)
MIME-Version: 1.0
References: <3ff5fd23-1db0-2f95-4cf9-711ef403fb62@oracle.com>
 <20210224000057-mutt-send-email-mst@kernel.org> <52836a63-4e00-ff58-50fb-9f450ce968d7@oracle.com>
 <20210228163031-mutt-send-email-mst@kernel.org> <2cb51a6d-afa0-7cd1-d6f2-6b153186eaca@redhat.com>
 <20210302043419-mutt-send-email-mst@kernel.org> <178f8ea7-cebd-0e81-3dc7-10a058d22c07@redhat.com>
 <c9a0932f-a6d7-a9df-38ba-97e50f70c2b2@oracle.com> <20211212042311-mutt-send-email-mst@kernel.org>
 <CACGkMEtwWcBNj62Yn_ZSq33N42ZG5yhCcZf=eQZ_AdVgJhEjEA@mail.gmail.com> <20211213030535-mutt-send-email-mst@kernel.org>
In-Reply-To: <20211213030535-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 13 Dec 2021 16:57:38 +0800
Message-ID: <CACGkMEtRfqRDPxXS2T-a0u4Aji3KtUq7-2iUD8Z-X1k84EgOZA@mail.gmail.com>
Subject: Re: vdpa legacy guest support (was Re: [PATCH] vdpa/mlx5:
 set_features should allow reset to zero)
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Si-Wei Liu <si-wei.liu@oracle.com>, Eli Cohen <elic@nvidia.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 13, 2021 at 4:07 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Mon, Dec 13, 2021 at 11:02:39AM +0800, Jason Wang wrote:
> > On Sun, Dec 12, 2021 at 5:26 PM Michael S. Tsirkin <mst@redhat.com> wro=
te:
> > >
> > > On Fri, Dec 10, 2021 at 05:44:15PM -0800, Si-Wei Liu wrote:
> > > > Sorry for reviving this ancient thread. I was kinda lost for the co=
nclusion
> > > > it ended up with. I have the following questions,
> > > >
> > > > 1. legacy guest support: from the past conversations it doesn't see=
m the
> > > > support will be completely dropped from the table, is my understand=
ing
> > > > correct? Actually we're interested in supporting virtio v0.95 guest=
 for x86,
> > > > which is backed by the spec at
> > > > https://ozlabs.org/~rusty/virtio-spec/virtio-0.9.5.pdf. Though I'm =
not sure
> > > > if there's request/need to support wilder legacy virtio versions ea=
rlier
> > > > beyond.
> > >
> > > I personally feel it's less work to add in kernel than try to
> > > work around it in userspace. Jason feels differently.
> > > Maybe post the patches and this will prove to Jason it's not
> > > too terrible?
> >
> > That's one way, other than the config access before setting features,
> > we need to deal with other stuffs:
> >
> > 1) VIRTIO_F_ORDER_PLATFORM
> > 2) there could be a parent device that only support 1.0 device
> >
> > And a lot of other stuff summarized in spec 7.4 which seems not an
> > easy task. Various vDPA parent drivers were written under the
> > assumption that only modern devices are supported.
> >
> > Thanks
>
> Limiting things to x86 will likely address most issues though, won't it?

For the ordering, yes. But it means we need to introduce a config
option for legacy logic?

And we need to deal with, as you said in another thread, kick before DRIVER=
_OK:

E.g we had thing like this:

        if ((status & VIRTIO_CONFIG_S_DRIVER_OK) &&
            !(status_old & VIRTIO_CONFIG_S_DRIVER_OK)) {
                ret =3D ifcvf_request_irq(adapter);
                if (ret) {

Similar issues could be found in other parents.

We also need to consider whether we should encourage the vendor to
implement the logic.

I think we can try and see how hard it is.

Thanks

>
> > >
> > > > 2. suppose some form of legacy guest support needs to be there, how=
 do we
> > > > deal with the bogus assumption below in vdpa_get_config() in the sh=
ort term?
> > > > It looks one of the intuitive fix is to move the vdpa_set_features =
call out
> > > > of vdpa_get_config() to vdpa_set_config().
> > > >
> > > >         /*
> > > >          * Config accesses aren't supposed to trigger before featur=
es are
> > > > set.
> > > >          * If it does happen we assume a legacy guest.
> > > >          */
> > > >         if (!vdev->features_valid)
> > > >                 vdpa_set_features(vdev, 0);
> > > >         ops->get_config(vdev, offset, buf, len);
> > > >
> > > > I can post a patch to fix 2) if there's consensus already reached.
> > > >
> > > > Thanks,
> > > > -Siwei
> > >
> > > I'm not sure how important it is to change that.
> > > In any case it only affects transitional devices, right?
> > > Legacy only should not care ...
> > >
> > >
> > > > On 3/2/2021 2:53 AM, Jason Wang wrote:
> > > > >
> > > > > On 2021/3/2 5:47 =E4=B8=8B=E5=8D=88, Michael S. Tsirkin wrote:
> > > > > > On Mon, Mar 01, 2021 at 11:56:50AM +0800, Jason Wang wrote:
> > > > > > > On 2021/3/1 5:34 =E4=B8=8A=E5=8D=88, Michael S. Tsirkin wrote=
:
> > > > > > > > On Wed, Feb 24, 2021 at 10:24:41AM -0800, Si-Wei Liu wrote:
> > > > > > > > > > Detecting it isn't enough though, we will need a new io=
ctl to notify
> > > > > > > > > > the kernel that it's a legacy guest. Ugh :(
> > > > > > > > > Well, although I think adding an ioctl is doable, may I
> > > > > > > > > know what the use
> > > > > > > > > case there will be for kernel to leverage such info
> > > > > > > > > directly? Is there a
> > > > > > > > > case QEMU can't do with dedicate ioctls later if there's =
indeed
> > > > > > > > > differentiation (legacy v.s. modern) needed?
> > > > > > > > BTW a good API could be
> > > > > > > >
> > > > > > > > #define VHOST_SET_ENDIAN _IOW(VHOST_VIRTIO, ?, int)
> > > > > > > > #define VHOST_GET_ENDIAN _IOW(VHOST_VIRTIO, ?, int)
> > > > > > > >
> > > > > > > > we did it per vring but maybe that was a mistake ...
> > > > > > >
> > > > > > > Actually, I wonder whether it's good time to just not support
> > > > > > > legacy driver
> > > > > > > for vDPA. Consider:
> > > > > > >
> > > > > > > 1) It's definition is no-normative
> > > > > > > 2) A lot of budren of codes
> > > > > > >
> > > > > > > So qemu can still present the legacy device since the config
> > > > > > > space or other
> > > > > > > stuffs that is presented by vhost-vDPA is not expected to be
> > > > > > > accessed by
> > > > > > > guest directly. Qemu can do the endian conversion when necess=
ary
> > > > > > > in this
> > > > > > > case?
> > > > > > >
> > > > > > > Thanks
> > > > > > >
> > > > > > Overall I would be fine with this approach but we need to avoid=
 breaking
> > > > > > working userspace, qemu releases with vdpa support are out ther=
e and
> > > > > > seem to work for people. Any changes need to take that into acc=
ount
> > > > > > and document compatibility concerns.
> > > > >
> > > > >
> > > > > Agree, let me check.
> > > > >
> > > > >
> > > > > >   I note that any hardware
> > > > > > implementation is already broken for legacy except on platforms=
 with
> > > > > > strong ordering which might be helpful in reducing the scope.
> > > > >
> > > > >
> > > > > Yes.
> > > > >
> > > > > Thanks
> > > > >
> > > > >
> > > > > >
> > > > > >
> > > > >
> > >
>

