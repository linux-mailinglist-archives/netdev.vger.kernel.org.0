Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4C164B034
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 08:10:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234274AbiLMHJ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 02:09:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233843AbiLMHJ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 02:09:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 054F3129
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 23:09:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670915340;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=baSvTJ/dt1dfXrXEGH7AD5AcoL7LDCy+sWq48EykxiE=;
        b=Dyzz6+mv7U3XC4GTKMEJh/8OqdWsr7z56QdshU1UTejaM+sT50HtaWouOJ6IJCts9WBRQM
        HSGh/864xpL05SjR7Baulc5P2mQVn0OfdqmtOYVNTzj+VkWONlcBCM8wNYupON4R0mTxyb
        5Nf1uWoIQDJWJLSIksMuRiS4NTQWmQw=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-399-51H3R-y0PkeLCZarrLNj1w-1; Tue, 13 Dec 2022 02:08:58 -0500
X-MC-Unique: 51H3R-y0PkeLCZarrLNj1w-1
Received: by mail-ot1-f70.google.com with SMTP id bx9-20020a056830600900b0066debed5e7dso8183447otb.10
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 23:08:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=baSvTJ/dt1dfXrXEGH7AD5AcoL7LDCy+sWq48EykxiE=;
        b=kAQlEvdHaOBGDo8L7b/9ajahaSJUY5kyTYfDquopLpiZKQGMs8Fo/mj0kGRXfzPDrA
         kBeRbvXqt1CkuLPtBw+T/DSFq9RliUpicM+GCzFHDyRrr/k/h51QZ7H+y2tjyLFgxE37
         J+brJPWBcL1tA/Lbl8Tzv9OCI4sMuDvoT9e5KfVrfvRSOuAIAzLjUmIJ3SKqRB2Xewfq
         45pJPjCTeK58uKfKq03UzEo8zmhREvlydrOl55034SW6iWqXK282f3V9tOpKO7fbvfuQ
         hgg22A1HRAIE03XAyhfz2lt7sg/cQFzybi0tm+XCQqa6EGKRbaA5CNjIi5ivh9QW9zz8
         qLOQ==
X-Gm-Message-State: ANoB5pmPsahxxiKPb2q2hlmJWX4XL45J91Qpdafi6VJwVKrBcu6W2BRn
        L/mkkOpa2CTQ0htYnjYb5anuC7LuppTT2zFlubhn69K04sgI9ifF0pSMvTLilz9kIja2MYIXogv
        izrDoR2P2p2YUAAhpuwdaPAR8FT6KAZJc
X-Received: by 2002:a05:6870:170e:b0:144:a97b:1ae2 with SMTP id h14-20020a056870170e00b00144a97b1ae2mr125807oae.35.1670915338175;
        Mon, 12 Dec 2022 23:08:58 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7bENDWmfDZYeIweNiEBrolCH9eeGe1c2BkAEMp4MeNJeA/fKB5xNDuCi9TQvoRkwJfWFGdPbZzSWZ9+fSs5eI=
X-Received: by 2002:a05:6870:170e:b0:144:a97b:1ae2 with SMTP id
 h14-20020a056870170e00b00144a97b1ae2mr125803oae.35.1670915337843; Mon, 12 Dec
 2022 23:08:57 -0800 (PST)
MIME-Version: 1.0
References: <20221122074348.88601-1-hengqi@linux.alibaba.com>
 <20221122074348.88601-7-hengqi@linux.alibaba.com> <CACGkMEsbX8w1wuU+954zVwNT5JvCHX7a9baKRytVb641UmNsuw@mail.gmail.com>
 <8b143235-2e74-eddf-4c22-a36d679d093e@linux.alibaba.com>
In-Reply-To: <8b143235-2e74-eddf-4c22-a36d679d093e@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 13 Dec 2022 15:08:46 +0800
Message-ID: <CACGkMEsX=p4VM0yW0E3oaO=hBJx6y2x8fDkChh=ju13Y_tmjVA@mail.gmail.com>
Subject: Re: [RFC PATCH 6/9] virtio_net: construct multi-buffer xdp in mergeable
To:     Heng Qi <hengqi@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 8, 2022 at 4:30 PM Heng Qi <hengqi@linux.alibaba.com> wrote:
>
>
>
> =E5=9C=A8 2022/12/6 =E4=B8=8B=E5=8D=882:33, Jason Wang =E5=86=99=E9=81=93=
:
> > On Tue, Nov 22, 2022 at 3:44 PM Heng Qi <hengqi@linux.alibaba.com> wrot=
e:
> >> Build multi-buffer xdp using virtnet_build_xdp_buff() in mergeable.
> >>
> >> For the prefilled buffer before xdp is set, vq reset can be
> >> used to clear it, but most devices do not support it at present.
> >> In order not to bother users who are using xdp normally, we do
> >> not use vq reset for the time being.
> > I guess to tweak the part to say we will probably use vq reset in the f=
uture.
>
> OK, it works.
>
> >
> >> At the same time, virtio
> >> net currently uses comp pages, and bpf_xdp_frags_increase_tail()
> >> needs to calculate the tailroom of the last frag, which will
> >> involve the offset of the corresponding page and cause a negative
> >> value, so we disable tail increase by not setting xdp_rxq->frag_size.
> >>
> >> Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
> >> Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> >> ---
> >>   drivers/net/virtio_net.c | 67 +++++++++++++++++++++++---------------=
--
> >>   1 file changed, 38 insertions(+), 29 deletions(-)
> >>
> >> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> >> index 20784b1d8236..83e6933ae62b 100644
> >> --- a/drivers/net/virtio_net.c
> >> +++ b/drivers/net/virtio_net.c
> >> @@ -994,6 +994,7 @@ static struct sk_buff *receive_mergeable(struct ne=
t_device *dev,
> >>                                           unsigned int *xdp_xmit,
> >>                                           struct virtnet_rq_stats *sta=
ts)
> >>   {
> >> +       unsigned int tailroom =3D SKB_DATA_ALIGN(sizeof(struct skb_sha=
red_info));
> >>          struct virtio_net_hdr_mrg_rxbuf *hdr =3D buf;
> >>          u16 num_buf =3D virtio16_to_cpu(vi->vdev, hdr->num_buffers);
> >>          struct page *page =3D virt_to_head_page(buf);
> >> @@ -1024,53 +1025,50 @@ static struct sk_buff *receive_mergeable(struc=
t net_device *dev,
> >>          rcu_read_lock();
> >>          xdp_prog =3D rcu_dereference(rq->xdp_prog);
> >>          if (xdp_prog) {
> >> +               unsigned int xdp_frags_truesz =3D 0;
> >> +               struct skb_shared_info *shinfo;
> >>                  struct xdp_frame *xdpf;
> >>                  struct page *xdp_page;
> >>                  struct xdp_buff xdp;
> >>                  void *data;
> >>                  u32 act;
> >> +               int i;
> >>
> >> -               /* Transient failure which in theory could occur if
> >> -                * in-flight packets from before XDP was enabled reach
> >> -                * the receive path after XDP is loaded.
> >> -                */
> >> -               if (unlikely(hdr->hdr.gso_type))
> >> -                       goto err_xdp;
> > Two questions:
> >
> > 1) should we keep this check for the XDP program that can't deal with X=
DP frags?
>
> Yes, the problem is the same as the xdp program without xdp.frags when
> GRO_HW, I will correct it.
>
> > 2) how could we guarantee that the vnet header (gso_type/csum_start
> > etc) is still valid after XDP (where XDP program can choose to
> > override the header)?
>
> We can save the vnet headr before the driver receives the packet and
> build xdp_buff, and then use
> the pre-saved value in the subsequent process.

The problem is that XDP may modify the packet (header) so some fields
are not valid any more (e.g csum_start/offset ?).

If I was not wrong, there's no way for the XDP program to access those
fields or does it support it right now?

>
> >> -
> >> -               /* Buffers with headroom use PAGE_SIZE as alloc size,
> >> -                * see add_recvbuf_mergeable() + get_mergeable_buf_len=
()
> >> +               /* Now XDP core assumes frag size is PAGE_SIZE, but bu=
ffers
> >> +                * with headroom may add hole in truesize, which
> >> +                * make their length exceed PAGE_SIZE. So we disabled =
the
> >> +                * hole mechanism for xdp. See add_recvbuf_mergeable()=
.
> >>                   */
> >>                  frame_sz =3D headroom ? PAGE_SIZE : truesize;
> >>
> >> -               /* This happens when rx buffer size is underestimated
> >> -                * or headroom is not enough because of the buffer
> >> -                * was refilled before XDP is set. This should only
> >> -                * happen for the first several packets, so we don't
> >> -                * care much about its performance.
> >> +               /* This happens when headroom is not enough because
> >> +                * of the buffer was prefilled before XDP is set.
> >> +                * This should only happen for the first several packe=
ts.
> >> +                * In fact, vq reset can be used here to help us clean=
 up
> >> +                * the prefilled buffers, but many existing devices do=
 not
> >> +                * support it, and we don't want to bother users who a=
re
> >> +                * using xdp normally.
> >>                   */
> >> -               if (unlikely(num_buf > 1 ||
> >> -                            headroom < virtnet_get_headroom(vi))) {
> >> -                       /* linearize data for XDP */
> >> -                       xdp_page =3D xdp_linearize_page(rq, &num_buf,
> >> -                                                     page, offset,
> >> -                                                     VIRTIO_XDP_HEADR=
OOM,
> >> -                                                     &len);
> >> -                       frame_sz =3D PAGE_SIZE;
> >> +               if (unlikely(headroom < virtnet_get_headroom(vi))) {
> >> +                       if ((VIRTIO_XDP_HEADROOM + len + tailroom) > P=
AGE_SIZE)
> >> +                               goto err_xdp;
> >>
> >> +                       xdp_page =3D alloc_page(GFP_ATOMIC);
> >>                          if (!xdp_page)
> >>                                  goto err_xdp;
> >> +
> >> +                       memcpy(page_address(xdp_page) + VIRTIO_XDP_HEA=
DROOM,
> >> +                              page_address(page) + offset, len);
> >> +                       frame_sz =3D PAGE_SIZE;
> > How can we know a single page is sufficient here? (before XDP is set,
> > we reserve neither headroom nor tailroom).
>
> This is only for the first buffer, refer to add_recvbuf_mergeable() and
> get_mergeable_buf_len() A buffer is always no larger than a page.

Ok.

Thanks

>
> >
> >>                          offset =3D VIRTIO_XDP_HEADROOM;
> > I think we should still try to do linearization for the XDP program
> > that doesn't support XDP frags.
>
> Yes, you are right.
>
> Thanks.
>
> >
> > Thanks
> >
> >>                  } else {
> >>                          xdp_page =3D page;
> >>                  }
> >> -
> >> -               /* Allow consuming headroom but reserve enough space t=
o push
> >> -                * the descriptor on if we get an XDP_TX return code.
> >> -                */
> >>                  data =3D page_address(xdp_page) + offset;
> >> -               xdp_init_buff(&xdp, frame_sz - vi->hdr_len, &rq->xdp_r=
xq);
> >> -               xdp_prepare_buff(&xdp, data - VIRTIO_XDP_HEADROOM + vi=
->hdr_len,
> >> -                                VIRTIO_XDP_HEADROOM, len - vi->hdr_le=
n, true);
> >> +               err =3D virtnet_build_xdp_buff(dev, vi, rq, &xdp, data=
, len, frame_sz,
> >> +                                            &num_buf, &xdp_frags_true=
sz, stats);
> >> +               if (unlikely(err))
> >> +                       goto err_xdp_frags;
> >>
> >>                  act =3D bpf_prog_run_xdp(xdp_prog, &xdp);
> >>                  stats->xdp_packets++;
> >> @@ -1164,6 +1162,17 @@ static struct sk_buff *receive_mergeable(struct=
 net_device *dev,
> >>                                  __free_pages(xdp_page, 0);
> >>                          goto err_xdp;
> >>                  }
> >> +err_xdp_frags:
> >> +               shinfo =3D xdp_get_shared_info_from_buff(&xdp);
> >> +
> >> +               if (unlikely(xdp_page !=3D page))
> >> +                       __free_pages(xdp_page, 0);
> >> +
> >> +               for (i =3D 0; i < shinfo->nr_frags; i++) {
> >> +                       xdp_page =3D skb_frag_page(&shinfo->frags[i]);
> >> +                       put_page(xdp_page);
> >> +               }
> >> +               goto err_xdp;
> >>          }
> >>          rcu_read_unlock();
> >>
> >> --
> >> 2.19.1.6.gb485710b
> >>
>

