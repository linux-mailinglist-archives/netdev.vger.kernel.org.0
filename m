Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 373F9500A09
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 11:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241888AbiDNJkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 05:40:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241852AbiDNJke (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 05:40:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AB37370F6A
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 02:38:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649929084;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kAYBz4doVQTzyQ+XbmAkl9XBH5XLaB98KdCbNRQGiq4=;
        b=LntbUP7SFJH/zQ7kPTF5x42lw1+Texq4xdKoj+NynhWV1I9l3HcsIL4vZmtOv5kAyd2jqD
        wkKdhoWL05KrTeZU7WFcQ1iG6u317x638eRxxQXEJlAY/7x9G4v+1JDm1kCYwyKooC8ySS
        9mwcdsMYL1h4iLZibbm3k4ml8ipfujs=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-422-qO2bec6gM_uYudQ77VDxRg-1; Thu, 14 Apr 2022 05:38:03 -0400
X-MC-Unique: qO2bec6gM_uYudQ77VDxRg-1
Received: by mail-lf1-f72.google.com with SMTP id x36-20020a056512132400b0044b07b24746so2109860lfu.8
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 02:38:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=kAYBz4doVQTzyQ+XbmAkl9XBH5XLaB98KdCbNRQGiq4=;
        b=VfDllsVMOmYpXbZpyP25lNe64ZyCSziXtnUNJSV8Tz3NQWMZVQuYX8qTzPMv/ftJ7K
         nYRVhWZEwSpOegMNFeD7sw5wMSOzjmUC3gljHlc6/UFpa4dlkbq2etZ3AG17tv57NRFp
         5gBvTeMVYMac3ePxYfNHW0SE0JxYUHrfMgGu6t9sPFf1DwcloKXKGvz0t6LmivAlsVAV
         5h6Wo6n4D92Vt9ai1WegxIQn4HaAPzjkHR5P43zB5SsWZMOg9m70c4txzHxn9x9mSY6t
         GHVCkjunMYWv+hMmeW3jlQIex6GZFAdPBw0hgDVMJGyFUV6of30G+C2EzWHqyMy5R9FT
         ll5w==
X-Gm-Message-State: AOAM5323MvmfEzFGyJPnzsWsiLNCl2dlJVKpNVw+aZ3AtHdl5012qw+P
        oA2jdHpemwpTGJCxVyOt9fAYrihf9cbFi7p27s6ShOm+vg7dkuyRz4b0+3SfFPzFMlMi7qlZTFL
        +PIj+xDU9O/cxGDBBJRSksCRskkeRGykF
X-Received: by 2002:a05:6512:b81:b0:448:b342:513c with SMTP id b1-20020a0565120b8100b00448b342513cmr1374402lfv.257.1649929081551;
        Thu, 14 Apr 2022 02:38:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyT+hQL3ayUr4yHsMFIRrMraYLhBZ1J0Bf6UbhSWT+Hf8Hn8S4DOLDQKv3/usDOYYaKjPbe8DoFTVvjkWCTmg0=
X-Received: by 2002:a05:6512:b81:b0:448:b342:513c with SMTP id
 b1-20020a0565120b8100b00448b342513cmr1374387lfv.257.1649929081317; Thu, 14
 Apr 2022 02:38:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220406034346.74409-1-xuanzhuo@linux.alibaba.com>
 <20220406034346.74409-23-xuanzhuo@linux.alibaba.com> <d228a41f-a3a1-029d-f259-d4fbab822e78@redhat.com>
 <1649917349.6242197-1-xuanzhuo@linux.alibaba.com>
In-Reply-To: <1649917349.6242197-1-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 14 Apr 2022 17:37:50 +0800
Message-ID: <CACGkMEuk24R8Y-H2=cuG4VkQhTNf6CSEMJbxe7jvHFEusa815g@mail.gmail.com>
Subject: Re: [PATCH v9 22/32] virtio_pci: queue_reset: extract the logic of
 active vq for modern pci
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Vadim Pasternak <vadimp@nvidia.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        linux-um@lists.infradead.org, netdev <netdev@vger.kernel.org>,
        platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm <kvm@vger.kernel.org>,
        "open list:XDP (eXpress Data Path)" <bpf@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 14, 2022 at 2:25 PM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrot=
e:
>
> On Tue, 12 Apr 2022 14:58:19 +0800, Jason Wang <jasowang@redhat.com> wrot=
e:
> >
> > =E5=9C=A8 2022/4/6 =E4=B8=8A=E5=8D=8811:43, Xuan Zhuo =E5=86=99=E9=81=
=93:
> > > Introduce vp_active_vq() to configure vring to backend after vq attac=
h
> > > vring. And configure vq vector if necessary.
> > >
> > > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > ---
> > >   drivers/virtio/virtio_pci_modern.c | 46 ++++++++++++++++++---------=
---
> > >   1 file changed, 28 insertions(+), 18 deletions(-)
> > >
> > > diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virt=
io_pci_modern.c
> > > index 86d301f272b8..49a4493732cf 100644
> > > --- a/drivers/virtio/virtio_pci_modern.c
> > > +++ b/drivers/virtio/virtio_pci_modern.c
> > > @@ -176,6 +176,29 @@ static void vp_reset(struct virtio_device *vdev)
> > >     vp_disable_cbs(vdev);
> > >   }
> > >
> > > +static int vp_active_vq(struct virtqueue *vq, u16 msix_vec)
> > > +{
> > > +   struct virtio_pci_device *vp_dev =3D to_vp_device(vq->vdev);
> > > +   struct virtio_pci_modern_device *mdev =3D &vp_dev->mdev;
> > > +   unsigned long index;
> > > +
> > > +   index =3D vq->index;
> > > +
> > > +   /* activate the queue */
> > > +   vp_modern_set_queue_size(mdev, index, virtqueue_get_vring_size(vq=
));
> > > +   vp_modern_queue_address(mdev, index, virtqueue_get_desc_addr(vq),
> > > +                           virtqueue_get_avail_addr(vq),
> > > +                           virtqueue_get_used_addr(vq));
> > > +
> > > +   if (msix_vec !=3D VIRTIO_MSI_NO_VECTOR) {
> > > +           msix_vec =3D vp_modern_queue_vector(mdev, index, msix_vec=
);
> > > +           if (msix_vec =3D=3D VIRTIO_MSI_NO_VECTOR)
> > > +                   return -EBUSY;
> > > +   }
> > > +
> > > +   return 0;
> > > +}
> > > +
> > >   static u16 vp_config_vector(struct virtio_pci_device *vp_dev, u16 v=
ector)
> > >   {
> > >     return vp_modern_config_vector(&vp_dev->mdev, vector);
> > > @@ -220,32 +243,19 @@ static struct virtqueue *setup_vq(struct virtio=
_pci_device *vp_dev,
> > >
> > >     vq->num_max =3D num;
> > >
> > > -   /* activate the queue */
> > > -   vp_modern_set_queue_size(mdev, index, virtqueue_get_vring_size(vq=
));
> > > -   vp_modern_queue_address(mdev, index, virtqueue_get_desc_addr(vq),
> > > -                           virtqueue_get_avail_addr(vq),
> > > -                           virtqueue_get_used_addr(vq));
> > > +   err =3D vp_active_vq(vq, msix_vec);
> > > +   if (err)
> > > +           goto err;
> > >
> > >     vq->priv =3D (void __force *)vp_modern_map_vq_notify(mdev, index,=
 NULL);
> > >     if (!vq->priv) {
> > >             err =3D -ENOMEM;
> > > -           goto err_map_notify;
> > > -   }
> > > -
> > > -   if (msix_vec !=3D VIRTIO_MSI_NO_VECTOR) {
> > > -           msix_vec =3D vp_modern_queue_vector(mdev, index, msix_vec=
);
> > > -           if (msix_vec =3D=3D VIRTIO_MSI_NO_VECTOR) {
> > > -                   err =3D -EBUSY;
> > > -                   goto err_assign_vector;
> > > -           }
> > > +           goto err;
> > >     }
> > >
> > >     return vq;
> > >
> > > -err_assign_vector:
> > > -   if (!mdev->notify_base)
> > > -           pci_iounmap(mdev->pci_dev, (void __iomem __force *)vq->pr=
iv);
> >
> >
> > We need keep this or anything I missed?
>
> I think so, after modification, vp_modern_map_vq_notify is the last step =
before
> returning vq. If it fails, then vq->priv is equal to NULL, so there is no=
 need
> to execute pci_iounmap.
>
> Did I miss something?

Nope I miss that the vector is configured before the mapping.

So

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

>
> Thanks.
>
> >
> > Thanks
> >
> >
> > > -err_map_notify:
> > > +err:
> > >     vring_del_virtqueue(vq);
> > >     return ERR_PTR(err);
> > >   }
> >
>

