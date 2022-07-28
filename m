Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D74405839AA
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 09:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234668AbiG1HnJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 03:43:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234230AbiG1HnH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 03:43:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EBDD9606AC
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 00:43:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658994184;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MiRkDMIa3SaNcNAA4LhevtztHl/rFve9e8RNCF7+zFQ=;
        b=eFIIcTPhqtBqOXdkN8FJu7gTSWotVhGDlBI0DsmaEuQERG/U5ixemzBzKlf9wdltI5334P
        5y0+S1nbso3PrlP27Q9ZaA3d6av2ixSrTH8KI9c11SXy4R9EH73U0lUplXJixexOfEH+is
        M0oj18pfomfXKE2+Wb5HkCpTE8K0zbU=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-408-SkEsdazXPE-BFJZpgxKqvg-1; Thu, 28 Jul 2022 03:43:03 -0400
X-MC-Unique: SkEsdazXPE-BFJZpgxKqvg-1
Received: by mail-lf1-f69.google.com with SMTP id k25-20020a195619000000b00489e6a6527eso386719lfb.8
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 00:43:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=MiRkDMIa3SaNcNAA4LhevtztHl/rFve9e8RNCF7+zFQ=;
        b=tx1oVvSXSiBNobHsoIk9Bnjx95/xidfc+Xt3yMEsYDZVo4ozInKg+xuL9ckGEtUT0m
         uAjI8QrPYDmXokZtiS1WLLTf0kM93N1Z9KPxH3rDQQL4vpmr6DCMY2qBSyS5P3DP92tM
         S+/IOwDNtkU+a2Shjtlb1qgBk2TxZIqn8RdBDMsQrxlp24bNImGVx3cRWZdWM+uBp1eA
         tbMLX0o1PvV2vP7RQfCreHhhEu1bmIMxVtp6vtSgZjLqxRfwIdoN/BmG9I7a7MNKPfr5
         T7PhTiPCDAdTGOM+iCeyq/RXex/ky4KRPtH+DLceqs4FA4T8jo+KgTVr94GHPTmhbOvU
         Kr+g==
X-Gm-Message-State: AJIora8doMxcbWhuUYqzw+xzfOaQgPqkOhSGQQNwMyttYx52DwlI2P1v
        XaoBmkpUZPzZsh44ZCIYS8U/YrGgyCLKFDGlmXwZEEjoCYZo7sViFYPvqZF1VyAs4QFsA46tqeT
        gZDOI4c0uJ5BgDTSJEbWiCeJ0xtRP7q+L
X-Received: by 2002:a2e:a99e:0:b0:25e:a54:8328 with SMTP id x30-20020a2ea99e000000b0025e0a548328mr5494955ljq.141.1658994181675;
        Thu, 28 Jul 2022 00:43:01 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1u68nBKmGtn3ybA4uLX2AOBJSklXcUMjbmYLhRoC0rjTaSlVKsgAzpWU4s1tY/769/tc0LwTRbMsEcj8iXfSPw=
X-Received: by 2002:a2e:a99e:0:b0:25e:a54:8328 with SMTP id
 x30-20020a2ea99e000000b0025e0a548328mr5494947ljq.141.1658994181424; Thu, 28
 Jul 2022 00:43:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220726072225.19884-1-xuanzhuo@linux.alibaba.com>
 <20220726072225.19884-17-xuanzhuo@linux.alibaba.com> <15aa26f2-f8af-5dbd-f2b2-9270ad873412@redhat.com>
 <1658907413.1860468-2-xuanzhuo@linux.alibaba.com> <CACGkMEvxsOfiiaWWAR8P68GY1yfwgTvaAbHk1JF7pTw-o2k25w@mail.gmail.com>
 <1658992162.584327-1-xuanzhuo@linux.alibaba.com>
In-Reply-To: <1658992162.584327-1-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 28 Jul 2022 15:42:50 +0800
Message-ID: <CACGkMEv-KYieHKXY_Qn0nfcnLMOSF=TowF5PwLKOxESL3KQ40Q@mail.gmail.com>
Subject: Re: [PATCH v13 16/42] virtio_ring: split: introduce virtqueue_resize_split()
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Vadim Pasternak <vadimp@nvidia.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        linux-um@lists.infradead.org, netdev <netdev@vger.kernel.org>,
        platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm <kvm@vger.kernel.org>,
        "open list:XDP (eXpress Data Path)" <bpf@vger.kernel.org>,
        Kangjie Xu <kangjie.xu@linux.alibaba.com>,
        virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 28, 2022 at 3:24 PM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrot=
e:
>
> On Thu, 28 Jul 2022 10:38:51 +0800, Jason Wang <jasowang@redhat.com> wrot=
e:
> > On Wed, Jul 27, 2022 at 3:44 PM Xuan Zhuo <xuanzhuo@linux.alibaba.com> =
wrote:
> > >
> > > On Wed, 27 Jul 2022 11:12:19 +0800, Jason Wang <jasowang@redhat.com> =
wrote:
> > > >
> > > > =E5=9C=A8 2022/7/26 15:21, Xuan Zhuo =E5=86=99=E9=81=93:
> > > > > virtio ring split supports resize.
> > > > >
> > > > > Only after the new vring is successfully allocated based on the n=
ew num,
> > > > > we will release the old vring. In any case, an error is returned,
> > > > > indicating that the vring still points to the old vring.
> > > > >
> > > > > In the case of an error, re-initialize(virtqueue_reinit_split()) =
the
> > > > > virtqueue to ensure that the vring can be used.
> > > > >
> > > > > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > > > Acked-by: Jason Wang <jasowang@redhat.com>
> > > > > ---
> > > > >   drivers/virtio/virtio_ring.c | 34 +++++++++++++++++++++++++++++=
+++++
> > > > >   1 file changed, 34 insertions(+)
> > > > >
> > > > > diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio=
_ring.c
> > > > > index b6fda91c8059..58355e1ac7d7 100644
> > > > > --- a/drivers/virtio/virtio_ring.c
> > > > > +++ b/drivers/virtio/virtio_ring.c
> > > > > @@ -220,6 +220,7 @@ static struct virtqueue *__vring_new_virtqueu=
e(unsigned int index,
> > > > >                                            void (*callback)(struc=
t virtqueue *),
> > > > >                                            const char *name);
> > > > >   static struct vring_desc_extra *vring_alloc_desc_extra(unsigned=
 int num);
> > > > > +static void vring_free(struct virtqueue *_vq);
> > > > >
> > > > >   /*
> > > > >    * Helpers.
> > > > > @@ -1117,6 +1118,39 @@ static struct virtqueue *vring_create_virt=
queue_split(
> > > > >     return vq;
> > > > >   }
> > > > >
> > > > > +static int virtqueue_resize_split(struct virtqueue *_vq, u32 num=
)
> > > > > +{
> > > > > +   struct vring_virtqueue_split vring_split =3D {};
> > > > > +   struct vring_virtqueue *vq =3D to_vvq(_vq);
> > > > > +   struct virtio_device *vdev =3D _vq->vdev;
> > > > > +   int err;
> > > > > +
> > > > > +   err =3D vring_alloc_queue_split(&vring_split, vdev, num,
> > > > > +                                 vq->split.vring_align,
> > > > > +                                 vq->split.may_reduce_num);
> > > > > +   if (err)
> > > > > +           goto err;
> > > >
> > > >
> > > > I think we don't need to do anything here?
> > >
> > > Am I missing something?
> >
> > I meant it looks to me most of the virtqueue_reinit() is unnecessary.
> > We probably only need to reinit avail/used idx there.
>
>
> In this function, we can indeed remove some code.
>
> >       static void virtqueue_reinit_split(struct vring_virtqueue *vq)
> >       {
> >               int size, i;
> >
> >               memset(vq->split.vring.desc, 0, vq->split.queue_size_in_b=
ytes);
> >
> >               size =3D sizeof(struct vring_desc_state_split) * vq->spli=
t.vring.num;
> >               memset(vq->split.desc_state, 0, size);
> >
> >               size =3D sizeof(struct vring_desc_extra) * vq->split.vrin=
g.num;
> >               memset(vq->split.desc_extra, 0, size);
>
> These memsets can be removed, and theoretically it will not cause any
> exceptions.

Yes, otherwise we have bugs in detach_buf().

>
> >
> >
> >
> >               for (i =3D 0; i < vq->split.vring.num - 1; i++)
> >                       vq->split.desc_extra[i].next =3D i + 1;
>
> This can also be removed, but we need to record free_head that will been =
update
> inside virtqueue_init().

We can simply keep free_head unchanged? Otherwise it's a bug somewhere I gu=
ess.


>
> >
> >               virtqueue_init(vq, vq->split.vring.num);
>
> There are some operations in this, which can also be skipped, such as set=
ting
> use_dma_api. But I think calling this function directly will be more conv=
enient
> for maintenance.

I don't see anything that is necessary here.

>
>
> >               virtqueue_vring_init_split(&vq->split, vq);
>
> virtqueue_vring_init_split() is necessary.

Right.

>
> >       }
>
> Another method, we can take out all the variables to be reinitialized
> separately, and repackage them into a new function. I don=E2=80=99t think=
 it=E2=80=99s worth
> it, because this path will only be reached if the memory allocation fails=
, which
> is a rare occurrence. In this case, doing so will increase the cost of
> maintenance. If you think so also, I will remove the above memset in the =
next
> version.

I agree.

Thanks

>
> Thanks.
>
>
> >
> > Thanks
> >
> > >
> > > >
> > > >
> > > > > +
> > > > > +   err =3D vring_alloc_state_extra_split(&vring_split);
> > > > > +   if (err) {
> > > > > +           vring_free_split(&vring_split, vdev);
> > > > > +           goto err;
> > > >
> > > >
> > > > I suggest to move vring_free_split() into a dedicated error label.
> > >
> > > Will change.
> > >
> > > Thanks.
> > >
> > >
> > > >
> > > > Thanks
> > > >
> > > >
> > > > > +   }
> > > > > +
> > > > > +   vring_free(&vq->vq);
> > > > > +
> > > > > +   virtqueue_vring_init_split(&vring_split, vq);
> > > > > +
> > > > > +   virtqueue_init(vq, vring_split.vring.num);
> > > > > +   virtqueue_vring_attach_split(vq, &vring_split);
> > > > > +
> > > > > +   return 0;
> > > > > +
> > > > > +err:
> > > > > +   virtqueue_reinit_split(vq);
> > > > > +   return -ENOMEM;
> > > > > +}
> > > > > +
> > > > >
> > > > >   /*
> > > > >    * Packed ring specific functions - *_packed().
> > > >
> > >
> >
>

