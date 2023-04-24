Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC896EC421
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 05:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbjDXDod (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 23:44:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230423AbjDXDoV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 23:44:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E0EC4695
        for <netdev@vger.kernel.org>; Sun, 23 Apr 2023 20:42:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682307755;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pNCBa7OjCC7JqsI3cEfxVx1YPRoGVy6yo4FMo1YynBA=;
        b=H3lDes96y5insWd3PYTcukwIgF+Nz8VX3cYZuRZdTBLqSGi2YL3GKXCpBgbcqetqEjz3lk
        qsiV8XjD6Vx2RztKHToUMYpCriiMAz7wDkBd5vCPOwwGgUxQ5HOOhn1v8xkz7sLe04O/Mj
        Ha97uaLu4zDa0X6z60LF6VjVyF6Tl9I=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-617-DJHgOx5VPWC2J9KRFvfPKA-1; Sun, 23 Apr 2023 23:42:34 -0400
X-MC-Unique: DJHgOx5VPWC2J9KRFvfPKA-1
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-38dfa5cb943so2618211b6e.1
        for <netdev@vger.kernel.org>; Sun, 23 Apr 2023 20:42:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682307753; x=1684899753;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pNCBa7OjCC7JqsI3cEfxVx1YPRoGVy6yo4FMo1YynBA=;
        b=NOyfk9bWHSnvSgN9UOR8pwhO2RSAqiwohJ/+35i1qJe3Kn5lnu2EDl5fFMZfkzDvIe
         WBbJB98+rSLSxIR3PDyqzguKnwIgWyuF2AwBa543IE9V7Z3+HrgiKiK0PUJiUbjSRkX9
         rKS8vtzpP5c7NsjpcSMjiOxrD9evXYxqzjWNCna8GBNEtMRmLN4QChHkGS5LdLsN1t/i
         nOACKjSalpQsb5BJFTvlJZTDFI78XsTlrLNbXldwcoo+kilQcTMv+tbblVWntUOuU0PN
         7w03FpuPr8bNIkl/2QD52Svd5Ru4488PWfvQUKa7bBYJpItuHhqX8oSI7FyQrSc019ec
         dW0w==
X-Gm-Message-State: AAQBX9ck3rVjGyfU6CDwprfVt4nUf7iDSLQx/r/vHjn9VgZslvB/8HHO
        EDPAnCX4j7OqtrtxX1x80svoQ9B6iB4Lsi+qa8bCLtOdrcFBp4cexxpj2+5IydNSaq7NDEjOYY+
        SPycPHPVGxSmN/W3AXa2vKWCyfgpATfug
X-Received: by 2002:a05:6808:196:b0:38e:67c5:50f9 with SMTP id w22-20020a056808019600b0038e67c550f9mr6166226oic.43.1682307753552;
        Sun, 23 Apr 2023 20:42:33 -0700 (PDT)
X-Google-Smtp-Source: AKy350bhb4SNjD4VqfNK9W6sYOBQTejlD7JIRYQvUf3qF3wdOgposi7pfPM+x9HFPX2SdLWK6pAXYrgljD8e2NvxZbs=
X-Received: by 2002:a05:6808:196:b0:38e:67c5:50f9 with SMTP id
 w22-20020a056808019600b0038e67c550f9mr6166217oic.43.1682307753329; Sun, 23
 Apr 2023 20:42:33 -0700 (PDT)
MIME-Version: 1.0
References: <20230419134329.346825-1-maxime.coquelin@redhat.com>
 <CACGkMEuiHqPkqYk1ZG3RZXLjm+EM3bmR0v1T1yH-ADEazOwTMA@mail.gmail.com>
 <d7530c13-f1a1-311e-7d5e-8e65f3bc2e50@redhat.com> <CACGkMEuWpHokhwvJ5cF41_C=ezqFhoOyUOposdZ5+==A642OmQ@mail.gmail.com>
 <88a24206-b576-efc6-1bce-7f5075024c63@redhat.com> <CACGkMEuZpk8QcrUQSOxqt6j3F9Ge-HdSs5-18FayMMQmH3Tcmg@mail.gmail.com>
 <CACycT3sbn=DSf0qW5RchV=FauDdn2eoMLEkRGAU3wXZZJwDsrw@mail.gmail.com>
In-Reply-To: <CACycT3sbn=DSf0qW5RchV=FauDdn2eoMLEkRGAU3wXZZJwDsrw@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 24 Apr 2023 11:42:22 +0800
Message-ID: <CACGkMEsUdRZEOsJX2H9b7E0uHYktm4BGkhD55Oqpwjna+Xi=vw@mail.gmail.com>
Subject: Re: [RFC 0/2] vduse: add support for networking devices
To:     Yongji Xie <xieyongji@bytedance.com>
Cc:     Maxime Coquelin <maxime.coquelin@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        David Marchand <david.marchand@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Netdev <netdev@vger.kernel.org>, xuanzhuo@linux.alibaba.com,
        Eugenio Perez Martin <eperezma@redhat.com>,
        Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 23, 2023 at 4:22=E2=80=AFPM Yongji Xie <xieyongji@bytedance.com=
> wrote:
>
> On Sun, Apr 23, 2023 at 2:31=E2=80=AFPM Jason Wang <jasowang@redhat.com> =
wrote:
> >
> > On Fri, Apr 21, 2023 at 10:28=E2=80=AFPM Maxime Coquelin
> > <maxime.coquelin@redhat.com> wrote:
> > >
> > >
> > >
> > > On 4/21/23 07:51, Jason Wang wrote:
> > > > On Thu, Apr 20, 2023 at 10:16=E2=80=AFPM Maxime Coquelin
> > > > <maxime.coquelin@redhat.com> wrote:
> > > >>
> > > >>
> > > >>
> > > >> On 4/20/23 06:34, Jason Wang wrote:
> > > >>> On Wed, Apr 19, 2023 at 9:43=E2=80=AFPM Maxime Coquelin
> > > >>> <maxime.coquelin@redhat.com> wrote:
> > > >>>>
> > > >>>> This small series enables virtio-net device type in VDUSE.
> > > >>>> With it, basic operation have been tested, both with
> > > >>>> virtio-vdpa and vhost-vdpa using DPDK Vhost library series
> > > >>>> adding VDUSE support [0] using split rings layout.
> > > >>>>
> > > >>>> Control queue support (and so multiqueue) has also been
> > > >>>> tested, but require a Kernel series from Jason Wang
> > > >>>> relaxing control queue polling [1] to function reliably.
> > > >>>>
> > > >>>> Other than that, we have identified a few gaps:
> > > >>>>
> > > >>>> 1. Reconnection:
> > > >>>>    a. VDUSE_VQ_GET_INFO ioctl() returns always 0 for avail
> > > >>>>       index, even after the virtqueue has already been
> > > >>>>       processed. Is that expected? I have tried instead to
> > > >>>>       get the driver's avail index directly from the avail
> > > >>>>       ring, but it does not seem reliable as I sometimes get
> > > >>>>       "id %u is not a head!\n" warnings. Also such solution
> > > >>>>       would not be possible with packed ring, as we need to
> > > >>>>       know the wrap counters values.
> > > >>>
> > > >>> Looking at the codes, it only returns the value that is set via
> > > >>> set_vq_state(). I think it is expected to be called before the
> > > >>> datapath runs.
> > > >>>
> > > >>> So when bound to virtio-vdpa, it is expected to return 0. But we =
need
> > > >>> to fix the packed virtqueue case, I wonder if we need to call
> > > >>> set_vq_state() explicitly in virtio-vdpa before starting the devi=
ce.
> > > >>>
> > > >>> When bound to vhost-vdpa, Qemu will call VHOST_SET_VRING_BASE whi=
ch
> > > >>> will end up a call to set_vq_state(). Unfortunately, it doesn't
> > > >>> support packed ring which needs some extension.
> > > >>>
> > > >>>>
> > > >>>>    b. Missing IOCTLs: it would be handy to have new IOCTLs to
> > > >>>>       query Virtio device status,
> > > >>>
> > > >>> What's the use case of this ioctl? It looks to me userspace is
> > > >>> notified on each status change now:
> > > >>>
> > > >>> static int vduse_dev_set_status(struct vduse_dev *dev, u8 status)
> > > >>> {
> > > >>>           struct vduse_dev_msg msg =3D { 0 };
> > > >>>
> > > >>>           msg.req.type =3D VDUSE_SET_STATUS;
> > > >>>           msg.req.s.status =3D status;
> > > >>>
> > > >>>           return vduse_dev_msg_sync(dev, &msg);
> > > >>> }
> > > >>
> > > >> The idea was to be able to query the status at reconnect time, and
> > > >> neither having to assume its value nor having to store its value i=
n a
> > > >> file (the status could change while the VDUSE application is stopp=
ed,
> > > >> but maybe it would receive the notification at reconnect).
> > > >
> > > > I see.
> > > >
> > > >>
> > > >> I will prototype using a tmpfs file to save needed information, an=
d see
> > > >> if it works.
> > > >
> > > > It might work but then the API is not self contained. Maybe it's
> > > > better to have a dedicated ioctl.
> > > >
> > > >>
> > > >>>> and retrieve the config
> > > >>>>       space set at VDUSE_CREATE_DEV time.
> > > >>>
> > > >>> In order to be safe, VDUSE avoids writable config space. Otherwis=
e
> > > >>> drivers could block on config writing forever. That's why we don'=
t do
> > > >>> it now.
> > > >>
> > > >> The idea was not to make the config space writable, but just to be=
 able
> > > >> to fetch what was filled at VDUSE_CREATE_DEV time.
> > > >>
> > > >> With the tmpfs file, we can avoid doing that and just save the con=
fig
> > > >> space there.
> > > >
> > > > Same as the case for status.
> > >
> > > I have cooked a DPDK patch to support reconnect with a tmpfs file as
> > > suggested by Yongji:
> > >
> > > https://gitlab.com/mcoquelin/dpdk-next-virtio/-/commit/53913f2b1155b0=
2c44d5d3d298aafd357e7a8c48
> >
> > This seems tricky, for example for status:
> >
> > dev->log->status =3D dev->status;
> >
> > What if we crash here?
> >
>
> The message will be re-sent by the kernel if it's not replied. But I
> think it would be better if we can restore it via some ioctl.

Yes, the point is, without a get ioctl, it's very hard to audit the code.

Thanks

>
> Thanks,
> Yongji
>

