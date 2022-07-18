Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE29577E10
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 10:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233490AbiGRI4l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 04:56:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233407AbiGRI4k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 04:56:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 76A21EE1B
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 01:56:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658134598;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OWEVZ0lWemvnjJGr1KMJVEu33/f4lcOHck1LBmLT0x4=;
        b=NWPyndKqiiALIP0h9Pk5HFNLdaRo74E7HqnT5JnQeuq4WI3nacKSGivB4DgbxhbMjsmeKn
        ASLHd+lSj/QrGkGVbq3wx/AiMFdF7wFLzd/Jq8wGdPmqPAN0zgaUf5V7Meob/5vH1qQx/O
        1XcmVgTlq7efUkg7K8ShMKEIeyPAwkg=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-675-16Ae7KntO8aB4kcBCT1ufg-1; Mon, 18 Jul 2022 04:56:37 -0400
X-MC-Unique: 16Ae7KntO8aB4kcBCT1ufg-1
Received: by mail-lf1-f70.google.com with SMTP id o20-20020ac24c54000000b0048a286ed00dso2502051lfk.14
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 01:56:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=OWEVZ0lWemvnjJGr1KMJVEu33/f4lcOHck1LBmLT0x4=;
        b=qgo4hH5BmA/KVAwTcW7r30fWEF0S/xdaEQRCC6RvUcoPUh8isYGmXntCINLR/0HN39
         wZLtFJthI3m/NZp5aGZiVkpcJskMNrFb2z2q1GFPqbmGO9qnTmg1ekI4DgenTTeaWYIT
         yRFNPITOqk9BIKh0oPKgJVf3Rn1cBTcrsSNP8ztx07SYY6Lz0RpUOv2Z8k3WFLlDilDY
         NxKWb5uvd/Mz6rEWv1/NhjIhVDJWjeN/cVPuCXusIBG0QirkTEymoWL6LCkS+jgsM5Cx
         CzjjPG1YGEIPsT6saqSuRnKTczv/XWgLQwvrx8oDEIz+XWC31P5QnA1bdcTz7K8au5nI
         kZqw==
X-Gm-Message-State: AJIora+ygTg9SibwVawLHvErCMRGgSO6QPwFE/KNqqOuh0DnP1ZfOy63
        /B4mxJ+dAGLUeMZ5dhGfOztnRaXUuCuTczrWGLrELIhsVZPl8dNE7CDjYMPR+D9x0rwiCiVvgB+
        1WDM05EarE6MPD97aPwJDLa6yHE0Kx6QL
X-Received: by 2002:ac2:4c4c:0:b0:489:fe2c:c877 with SMTP id o12-20020ac24c4c000000b00489fe2cc877mr15771587lfk.238.1658134595388;
        Mon, 18 Jul 2022 01:56:35 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uT17stmgD/4/ICa/9NkCqW44+T43NZzTbYZlFnn5f6GksCmVOwfYnKSj/DtJ2DugQNpv1qMO4BpXj9dv3Brrw=
X-Received: by 2002:ac2:4c4c:0:b0:489:fe2c:c877 with SMTP id
 o12-20020ac24c4c000000b00489fe2cc877mr15771561lfk.238.1658134595164; Mon, 18
 Jul 2022 01:56:35 -0700 (PDT)
MIME-Version: 1.0
References: <20220629065656.54420-1-xuanzhuo@linux.alibaba.com>
 <20220629065656.54420-39-xuanzhuo@linux.alibaba.com> <c0747cbc-685b-85a9-1931-0124124755f2@redhat.com>
 <1656986375.3420787-1-xuanzhuo@linux.alibaba.com> <CACGkMEu80KP-ULz_CBvauRk_3XsCubMkkWv0uLnbt-wib5KOnA@mail.gmail.com>
 <1657874178.9766078-2-xuanzhuo@linux.alibaba.com>
In-Reply-To: <1657874178.9766078-2-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 18 Jul 2022 16:56:24 +0800
Message-ID: <CACGkMEtF5NSXh-=nnsniLqy0pX2Tpyh413S5Bu5vZ6h=d+aHTA@mail.gmail.com>
Subject: Re: [PATCH v11 38/40] virtio_net: support rx queue resize
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
        kangjie.xu@linux.alibaba.com,
        virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 15, 2022 at 4:37 PM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrot=
e:
>
> On Fri, 8 Jul 2022 14:20:52 +0800, Jason Wang <jasowang@redhat.com> wrote=
:
> > On Tue, Jul 5, 2022 at 10:00 AM Xuan Zhuo <xuanzhuo@linux.alibaba.com> =
wrote:
> > >
> > > On Mon, 4 Jul 2022 11:44:12 +0800, Jason Wang <jasowang@redhat.com> w=
rote:
> > > >
> > > > =E5=9C=A8 2022/6/29 14:56, Xuan Zhuo =E5=86=99=E9=81=93:
> > > > > This patch implements the resize function of the rx queues.
> > > > > Based on this function, it is possible to modify the ring num of =
the
> > > > > queue.
> > > > >
> > > > > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > > > ---
> > > > >   drivers/net/virtio_net.c | 22 ++++++++++++++++++++++
> > > > >   1 file changed, 22 insertions(+)
> > > > >
> > > > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > > > index 9fe222a3663a..6ab16fd193e5 100644
> > > > > --- a/drivers/net/virtio_net.c
> > > > > +++ b/drivers/net/virtio_net.c
> > > > > @@ -278,6 +278,8 @@ struct padded_vnet_hdr {
> > > > >     char padding[12];
> > > > >   };
> > > > >
> > > > > +static void virtnet_rq_free_unused_buf(struct virtqueue *vq, voi=
d *buf);
> > > > > +
> > > > >   static bool is_xdp_frame(void *ptr)
> > > > >   {
> > > > >     return (unsigned long)ptr & VIRTIO_XDP_FLAG;
> > > > > @@ -1846,6 +1848,26 @@ static netdev_tx_t start_xmit(struct sk_bu=
ff *skb, struct net_device *dev)
> > > > >     return NETDEV_TX_OK;
> > > > >   }
> > > > >
> > > > > +static int virtnet_rx_resize(struct virtnet_info *vi,
> > > > > +                        struct receive_queue *rq, u32 ring_num)
> > > > > +{
> > > > > +   int err, qindex;
> > > > > +
> > > > > +   qindex =3D rq - vi->rq;
> > > > > +
> > > > > +   napi_disable(&rq->napi);
> > > >
> > > >
> > > > Do we need to cancel the refill work here?
> > >
> > >
> > > I think no, napi_disable is mutually exclusive, which ensures that th=
ere will be
> > > no conflicts between them.
> >
> > So this sounds similar to what I've fixed recently.
> >
> > 1) NAPI schedule delayed work.
> > 2) we disable NAPI here
> > 3) delayed work get schedule and call NAPI again
> >
> > ?
>
> Yes, but I don't think there are any negative effects.

An infinite wait on the napi_disable()?

Thanks

>
> Thanks.
>
> >
> > Thanks
> >
> > >
> > > Thanks.
> > >
> > > >
> > > > Thanks
> > > >
> > > >
> > > > > +
> > > > > +   err =3D virtqueue_resize(rq->vq, ring_num, virtnet_rq_free_un=
used_buf);
> > > > > +   if (err)
> > > > > +           netdev_err(vi->dev, "resize rx fail: rx queue index: =
%d err: %d\n", qindex, err);
> > > > > +
> > > > > +   if (!try_fill_recv(vi, rq, GFP_KERNEL))
> > > > > +           schedule_delayed_work(&vi->refill, 0);
> > > > > +
> > > > > +   virtnet_napi_enable(rq->vq, &rq->napi);
> > > > > +   return err;
> > > > > +}
> > > > > +
> > > > >   /*
> > > > >    * Send command via the control virtqueue and check status.  Co=
mmands
> > > > >    * supported by the hypervisor, as indicated by feature bits, s=
hould
> > > >
> > >
> >
>

