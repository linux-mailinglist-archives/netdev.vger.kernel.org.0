Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94B705863A2
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 06:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238845AbiHAEta (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 00:49:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238881AbiHAEt2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 00:49:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7399613E84
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 21:49:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659329366;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q+tpGySP9Lk1FyvMvrEtbd53hrU4ZKX1FexyKVAWT9g=;
        b=HdNfbLfYZDJUN5WgV+kqtn6f6DClx+U3/gEhMfZ98KLDV5HUsJSBr/IDSUUeNKaJnQuG9+
        i5Gm7RqAggl/KBW5s35m98C1n/DA+nO12w6seIVcj5ozbJftuGrQf3AQNCPtRy9jgbrkfJ
        LvATCZEVrWXq+vUfJ9lThDvzSCfl5nU=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-97-H9PNvIEsOgmh-QJaEX2Ufg-1; Mon, 01 Aug 2022 00:49:24 -0400
X-MC-Unique: H9PNvIEsOgmh-QJaEX2Ufg-1
Received: by mail-ej1-f70.google.com with SMTP id s4-20020a170906500400b006feaccb3a0eso2519462ejj.11
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 21:49:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=q+tpGySP9Lk1FyvMvrEtbd53hrU4ZKX1FexyKVAWT9g=;
        b=c6p5HJFy+SlA4P10jgrLyh10eIVXWceBzwxP0NYSdeASSHlWWTX3TiQfEEndcP/7OF
         QB2uH4f32rqUoT5p9m57wXojV8sCpcXwG7uVH9S/BaSCqBziIPmpJ/JTNefTMdyb1fsi
         eQXKHnrETRrnDKWMOkxtHlVg0dwiHCHnfr176KSUub7ATTegENTp7AyHFEKxpwCRgi3q
         /YRzeP4HdU67tXbsfdzaR3Dt46/HXZIuu2JVvRDWu/uGFPB/UJ7VoOuH56nx5ysBUmCQ
         Uh22Q76Z2p5Tt+BSLYBY1Fn5p+HNsuyhZBYT/RtX3VyelHasBWoOrZ1IsMmHVchjrjSy
         mepA==
X-Gm-Message-State: ACgBeo0q3JR6UTBfvqOxbZxY8ms5MwZjC+SllDGy5+lAzfK/aZ6fnSpS
        5NHmj7O8NWidRibPJeeQicHQqDtsOT1Xa8in49Absbdu77ZRhRd96Wo9L6G6c2EZ1P6YqEapO0a
        Ar2iV+ns2nxlS83KbyNJKAH5GRaWCJjDp
X-Received: by 2002:a17:906:7952:b0:730:6ab7:6655 with SMTP id l18-20020a170906795200b007306ab76655mr4103306ejo.171.1659329363737;
        Sun, 31 Jul 2022 21:49:23 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6QSahe3Oz+0hcT4zTabdKp5OW3wU+PvaOKgpjGIS2wuAOteNl/QWorIgyoG68O4FkZexN8Vy86JXN1G06sGrw=
X-Received: by 2002:a17:906:7952:b0:730:6ab7:6655 with SMTP id
 l18-20020a170906795200b007306ab76655mr4103291ejo.171.1659329363476; Sun, 31
 Jul 2022 21:49:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220726072225.19884-1-xuanzhuo@linux.alibaba.com>
 <20220726072225.19884-17-xuanzhuo@linux.alibaba.com> <15aa26f2-f8af-5dbd-f2b2-9270ad873412@redhat.com>
 <1658907413.1860468-2-xuanzhuo@linux.alibaba.com> <CACGkMEvxsOfiiaWWAR8P68GY1yfwgTvaAbHk1JF7pTw-o2k25w@mail.gmail.com>
 <1658992162.584327-1-xuanzhuo@linux.alibaba.com> <CACGkMEv-KYieHKXY_Qn0nfcnLMOSF=TowF5PwLKOxESL3KQ40Q@mail.gmail.com>
 <1658995783.1026692-1-xuanzhuo@linux.alibaba.com> <CACGkMEv6Ptn4zj_F-ww3Nay-VPmCNrXLaf5U98PvupAvo44FpA@mail.gmail.com>
 <1659001321.5738833-2-xuanzhuo@linux.alibaba.com>
In-Reply-To: <1659001321.5738833-2-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 1 Aug 2022 12:49:12 +0800
Message-ID: <CACGkMEvcRxbqJ01sjC50muW3cQJiJKUJW+67QrsOP662FCgi0g@mail.gmail.com>
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
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 28, 2022 at 7:27 PM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrot=
e:
>
> On Thu, 28 Jul 2022 17:04:36 +0800, Jason Wang <jasowang@redhat.com> wrot=
e:
> > On Thu, Jul 28, 2022 at 4:18 PM Xuan Zhuo <xuanzhuo@linux.alibaba.com> =
wrote:
> > >
> > > On Thu, 28 Jul 2022 15:42:50 +0800, Jason Wang <jasowang@redhat.com> =
wrote:
> > > > On Thu, Jul 28, 2022 at 3:24 PM Xuan Zhuo <xuanzhuo@linux.alibaba.c=
om> wrote:
> > > > >
> > > > > On Thu, 28 Jul 2022 10:38:51 +0800, Jason Wang <jasowang@redhat.c=
om> wrote:
> > > > > > On Wed, Jul 27, 2022 at 3:44 PM Xuan Zhuo <xuanzhuo@linux.aliba=
ba.com> wrote:
> > > > > > >
> > > > > > > On Wed, 27 Jul 2022 11:12:19 +0800, Jason Wang <jasowang@redh=
at.com> wrote:
> > > > > > > >
> > > > > > > > =E5=9C=A8 2022/7/26 15:21, Xuan Zhuo =E5=86=99=E9=81=93:
> > > > > > > > > virtio ring split supports resize.
> > > > > > > > >
> > > > > > > > > Only after the new vring is successfully allocated based =
on the new num,
> > > > > > > > > we will release the old vring. In any case, an error is r=
eturned,
> > > > > > > > > indicating that the vring still points to the old vring.
> > > > > > > > >
> > > > > > > > > In the case of an error, re-initialize(virtqueue_reinit_s=
plit()) the
> > > > > > > > > virtqueue to ensure that the vring can be used.
> > > > > > > > >
> > > > > > > > > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > > > > > > > Acked-by: Jason Wang <jasowang@redhat.com>
> > > > > > > > > ---
> > > > > > > > >   drivers/virtio/virtio_ring.c | 34 +++++++++++++++++++++=
+++++++++++++
> > > > > > > > >   1 file changed, 34 insertions(+)
> > > > > > > > >
> > > > > > > > > diff --git a/drivers/virtio/virtio_ring.c b/drivers/virti=
o/virtio_ring.c
> > > > > > > > > index b6fda91c8059..58355e1ac7d7 100644
> > > > > > > > > --- a/drivers/virtio/virtio_ring.c
> > > > > > > > > +++ b/drivers/virtio/virtio_ring.c
> > > > > > > > > @@ -220,6 +220,7 @@ static struct virtqueue *__vring_new_=
virtqueue(unsigned int index,
> > > > > > > > >                                            void (*callbac=
k)(struct virtqueue *),
> > > > > > > > >                                            const char *na=
me);
> > > > > > > > >   static struct vring_desc_extra *vring_alloc_desc_extra(=
unsigned int num);
> > > > > > > > > +static void vring_free(struct virtqueue *_vq);
> > > > > > > > >
> > > > > > > > >   /*
> > > > > > > > >    * Helpers.
> > > > > > > > > @@ -1117,6 +1118,39 @@ static struct virtqueue *vring_cre=
ate_virtqueue_split(
> > > > > > > > >     return vq;
> > > > > > > > >   }
> > > > > > > > >
> > > > > > > > > +static int virtqueue_resize_split(struct virtqueue *_vq,=
 u32 num)
> > > > > > > > > +{
> > > > > > > > > +   struct vring_virtqueue_split vring_split =3D {};
> > > > > > > > > +   struct vring_virtqueue *vq =3D to_vvq(_vq);
> > > > > > > > > +   struct virtio_device *vdev =3D _vq->vdev;
> > > > > > > > > +   int err;
> > > > > > > > > +
> > > > > > > > > +   err =3D vring_alloc_queue_split(&vring_split, vdev, n=
um,
> > > > > > > > > +                                 vq->split.vring_align,
> > > > > > > > > +                                 vq->split.may_reduce_nu=
m);
> > > > > > > > > +   if (err)
> > > > > > > > > +           goto err;
> > > > > > > >
> > > > > > > >
> > > > > > > > I think we don't need to do anything here?
> > > > > > >
> > > > > > > Am I missing something?
> > > > > >
> > > > > > I meant it looks to me most of the virtqueue_reinit() is unnece=
ssary.
> > > > > > We probably only need to reinit avail/used idx there.
> > > > >
> > > > >
> > > > > In this function, we can indeed remove some code.
> > > > >
> > > > > >       static void virtqueue_reinit_split(struct vring_virtqueue=
 *vq)
> > > > > >       {
> > > > > >               int size, i;
> > > > > >
> > > > > >               memset(vq->split.vring.desc, 0, vq->split.queue_s=
ize_in_bytes);
> > > > > >
> > > > > >               size =3D sizeof(struct vring_desc_state_split) * =
vq->split.vring.num;
> > > > > >               memset(vq->split.desc_state, 0, size);
> > > > > >
> > > > > >               size =3D sizeof(struct vring_desc_extra) * vq->sp=
lit.vring.num;
> > > > > >               memset(vq->split.desc_extra, 0, size);
> > > > >
> > > > > These memsets can be removed, and theoretically it will not cause=
 any
> > > > > exceptions.
> > > >
> > > > Yes, otherwise we have bugs in detach_buf().
> > > >
> > > > >
> > > > > >
> > > > > >
> > > > > >
> > > > > >               for (i =3D 0; i < vq->split.vring.num - 1; i++)
> > > > > >                       vq->split.desc_extra[i].next =3D i + 1;
> > > > >
> > > > > This can also be removed, but we need to record free_head that wi=
ll been update
> > > > > inside virtqueue_init().
> > > >
> > > > We can simply keep free_head unchanged? Otherwise it's a bug somewh=
ere I guess.
> > > >
> > > >
> > > > >
> > > > > >
> > > > > >               virtqueue_init(vq, vq->split.vring.num);
> > > > >
> > > > > There are some operations in this, which can also be skipped, suc=
h as setting
> > > > > use_dma_api. But I think calling this function directly will be m=
ore convenient
> > > > > for maintenance.
> > > >
> > > > I don't see anything that is necessary here.
> > >
> > > These three are currently inside virtqueue_init()
> > >
> > > vq->last_used_idx =3D 0;
> > > vq->event_triggered =3D false;
> > > vq->num_added =3D 0;
> >
> > Right. Let's keep it there.
> >
> > (Though it's kind of strange that the last_used_idx is not initialized
> > at the same place with avail_idx/flags_shadow, we can optimize it on
> > top).
>
> I put free_head =3D 0 in the attach function, it is only necessary to set
> free_head =3D 0 when a new state/extra is attached.

Ok, so I meant I tend to keep it to make this series converge soon :)

We can do optimization on top anyhow.

Thanks

>
> In this way, when we call virtqueue_init(), we don't have to worry about
> free_head being modified.
>
> Rethinking this problem, I think virtqueue_init() can be rewritten and so=
me
> variables that will not change are removed from it. (use_dma_api, event,
> weak_barriers)
>
> +static void virtqueue_init(struct vring_virtqueue *vq, u32 num)
> +{
> +       vq->vq.num_free =3D num;
> +
> +       if (vq->packed_ring)
> +               vq->last_used_idx =3D 0 | (1 << VRING_PACKED_EVENT_F_WRAP=
_CTR);
> +       else
> +               vq->last_used_idx =3D 0;
> +
> +       vq->event_triggered =3D false;
> +       vq->num_added =3D 0;
> +
> +#ifdef DEBUG
> +       vq->in_use =3D false;
> +       vq->last_add_time_valid =3D false;
> +#endif
> +}
> +
>
> Thanks.
>
>
> >
> > Thanks
> >
> > >
> > > Thanks.
> > >
> > >
> > > >
> > > > >
> > > > >
> > > > > >               virtqueue_vring_init_split(&vq->split, vq);
> > > > >
> > > > > virtqueue_vring_init_split() is necessary.
> > > >
> > > > Right.
> > > >
> > > > >
> > > > > >       }
> > > > >
> > > > > Another method, we can take out all the variables to be reinitial=
ized
> > > > > separately, and repackage them into a new function. I don=E2=80=
=99t think it=E2=80=99s worth
> > > > > it, because this path will only be reached if the memory allocati=
on fails, which
> > > > > is a rare occurrence. In this case, doing so will increase the co=
st of
> > > > > maintenance. If you think so also, I will remove the above memset=
 in the next
> > > > > version.
> > > >
> > > > I agree.
> > > >
> > > > Thanks
> > > >
> > > > >
> > > > > Thanks.
> > > > >
> > > > >
> > > > > >
> > > > > > Thanks
> > > > > >
> > > > > > >
> > > > > > > >
> > > > > > > >
> > > > > > > > > +
> > > > > > > > > +   err =3D vring_alloc_state_extra_split(&vring_split);
> > > > > > > > > +   if (err) {
> > > > > > > > > +           vring_free_split(&vring_split, vdev);
> > > > > > > > > +           goto err;
> > > > > > > >
> > > > > > > >
> > > > > > > > I suggest to move vring_free_split() into a dedicated error=
 label.
> > > > > > >
> > > > > > > Will change.
> > > > > > >
> > > > > > > Thanks.
> > > > > > >
> > > > > > >
> > > > > > > >
> > > > > > > > Thanks
> > > > > > > >
> > > > > > > >
> > > > > > > > > +   }
> > > > > > > > > +
> > > > > > > > > +   vring_free(&vq->vq);
> > > > > > > > > +
> > > > > > > > > +   virtqueue_vring_init_split(&vring_split, vq);
> > > > > > > > > +
> > > > > > > > > +   virtqueue_init(vq, vring_split.vring.num);
> > > > > > > > > +   virtqueue_vring_attach_split(vq, &vring_split);
> > > > > > > > > +
> > > > > > > > > +   return 0;
> > > > > > > > > +
> > > > > > > > > +err:
> > > > > > > > > +   virtqueue_reinit_split(vq);
> > > > > > > > > +   return -ENOMEM;
> > > > > > > > > +}
> > > > > > > > > +
> > > > > > > > >
> > > > > > > > >   /*
> > > > > > > > >    * Packed ring specific functions - *_packed().
> > > > > > > >
> > > > > > >
> > > > > >
> > > > >
> > > >
> > >
> >
>

