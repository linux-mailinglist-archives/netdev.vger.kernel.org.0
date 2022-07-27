Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D03A582137
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 09:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbiG0Hgz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 03:36:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbiG0Hgy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 03:36:54 -0400
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 454B82A94C;
        Wed, 27 Jul 2022 00:36:50 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R251e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=36;SR=0;TI=SMTPD_---0VKZmDNB_1658907402;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VKZmDNB_1658907402)
          by smtp.aliyun-inc.com;
          Wed, 27 Jul 2022 15:36:43 +0800
Message-ID: <1658907340.34387-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH v13 07/42] virtio_ring: split: stop __vring_new_virtqueue as export symbol
Date:   Wed, 27 Jul 2022 15:35:40 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     Jason Wang <jasowang@redhat.com>
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
        linux-um@lists.infradead.org, netdev@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, bpf@vger.kernel.org,
        kangjie.xu@linux.alibaba.com,
        virtualization@lists.linux-foundation.org
References: <20220726072225.19884-1-xuanzhuo@linux.alibaba.com>
 <20220726072225.19884-8-xuanzhuo@linux.alibaba.com>
 <a5449e49-ba38-9760-ac07-cfad048bc602@redhat.com>
In-Reply-To: <a5449e49-ba38-9760-ac07-cfad048bc602@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Jul 2022 10:58:05 +0800, Jason Wang <jasowang@redhat.com> wrote:
>
> =E5=9C=A8 2022/7/26 15:21, Xuan Zhuo =E5=86=99=E9=81=93:
> > There is currently only one place to reference __vring_new_virtqueue()
> > directly from the outside of virtio core. And here vring_new_virtqueue()
> > can be used instead.
> >
> > Subsequent patches will modify __vring_new_virtqueue, so stop it as an
> > export symbol for now.
> >
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > ---
> >   drivers/virtio/virtio_ring.c | 25 ++++++++++++++++---------
> >   include/linux/virtio_ring.h  | 10 ----------
> >   tools/virtio/virtio_test.c   |  4 ++--
> >   3 files changed, 18 insertions(+), 21 deletions(-)
> >
> > diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> > index 0ad35eca0d39..4e54ed7ee7fb 100644
> > --- a/drivers/virtio/virtio_ring.c
> > +++ b/drivers/virtio/virtio_ring.c
> > @@ -204,6 +204,14 @@ struct vring_virtqueue {
> >   #endif
> >   };
> >
> > +static struct virtqueue *__vring_new_virtqueue(unsigned int index,
> > +					       struct vring vring,
> > +					       struct virtio_device *vdev,
> > +					       bool weak_barriers,
> > +					       bool context,
> > +					       bool (*notify)(struct virtqueue *),
> > +					       void (*callback)(struct virtqueue *),
> > +					       const char *name);
> >
> >   /*
> >    * Helpers.
> > @@ -2197,14 +2205,14 @@ irqreturn_t vring_interrupt(int irq, void *_vq)
> >   EXPORT_SYMBOL_GPL(vring_interrupt);
> >
> >   /* Only available for split ring */
> > -struct virtqueue *__vring_new_virtqueue(unsigned int index,
> > -					struct vring vring,
> > -					struct virtio_device *vdev,
> > -					bool weak_barriers,
> > -					bool context,
> > -					bool (*notify)(struct virtqueue *),
> > -					void (*callback)(struct virtqueue *),
> > -					const char *name)
> > +static struct virtqueue *__vring_new_virtqueue(unsigned int index,
> > +					       struct vring vring,
> > +					       struct virtio_device *vdev,
> > +					       bool weak_barriers,
> > +					       bool context,
> > +					       bool (*notify)(struct virtqueue *),
> > +					       void (*callback)(struct virtqueue *),
> > +					       const char *name)
> >   {
> >   	struct vring_virtqueue *vq;
> >
> > @@ -2272,7 +2280,6 @@ struct virtqueue *__vring_new_virtqueue(unsigned =
int index,
> >   	kfree(vq);
> >   	return NULL;
> >   }
> > -EXPORT_SYMBOL_GPL(__vring_new_virtqueue);
> >
> >   struct virtqueue *vring_create_virtqueue(
> >   	unsigned int index,
> > diff --git a/include/linux/virtio_ring.h b/include/linux/virtio_ring.h
> > index b485b13fa50b..8b8af1a38991 100644
> > --- a/include/linux/virtio_ring.h
> > +++ b/include/linux/virtio_ring.h
> > @@ -76,16 +76,6 @@ struct virtqueue *vring_create_virtqueue(unsigned in=
t index,
> >   					 void (*callback)(struct virtqueue *vq),
> >   					 const char *name);
> >
> > -/* Creates a virtqueue with a custom layout. */
> > -struct virtqueue *__vring_new_virtqueue(unsigned int index,
> > -					struct vring vring,
> > -					struct virtio_device *vdev,
> > -					bool weak_barriers,
> > -					bool ctx,
> > -					bool (*notify)(struct virtqueue *),
> > -					void (*callback)(struct virtqueue *),
> > -					const char *name);
> > -
> >   /*
> >    * Creates a virtqueue with a standard layout but a caller-allocated
> >    * ring.
> > diff --git a/tools/virtio/virtio_test.c b/tools/virtio/virtio_test.c
> > index 23f142af544a..86a410ddcedd 100644
> > --- a/tools/virtio/virtio_test.c
> > +++ b/tools/virtio/virtio_test.c
> > @@ -102,8 +102,8 @@ static void vq_reset(struct vq_info *info, int num,=
 struct virtio_device *vdev)
> >
> >   	memset(info->ring, 0, vring_size(num, 4096));
> >   	vring_init(&info->vring, num, info->ring, 4096);
>
>
> Let's remove the duplicated vring_init() here.
>
> With this removed:

The reason I didn't delete this vring_init() is because info->vring is used
elsewhere. So it can't be deleted directly.

Thanks.

>
> Acked-by: Jason Wang <jasowang@redhat.com>
>
>
> > -	info->vq =3D __vring_new_virtqueue(info->idx, info->vring, vdev, true,
> > -					 false, vq_notify, vq_callback, "test");
> > +	info->vq =3D vring_new_virtqueue(info->idx, num, 4096, vdev, true, fa=
lse,
> > +				       info->ring, vq_notify, vq_callback, "test");
> >   	assert(info->vq);
> >   	info->vq->priv =3D info;
> >   }
>
