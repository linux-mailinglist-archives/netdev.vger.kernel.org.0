Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1E14B99C8
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 08:21:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236154AbiBQHV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 02:21:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiBQHV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 02:21:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4D03445AE8
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 23:21:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645082501;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MK/w5CaqVN2WaOvoDgze1gKvnvxbRCEDpuTeg5VSM88=;
        b=C04arsOX0E9aF5ztCZOaR8fKXJNp2cEUt9GUJG86++LEP17Ljrge1GxiJKvtjFmdob4O1+
        BoeFtUZLB7e7hmwXLWHWWEcjsFSSs+8/zElZvrU5z2vNG7HjSq98CHMxE+YqkdJGjTwTej
        LwylsQsjV46DtzbU1HwikzrOavcUPGA=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-486-0GsJnJmBMG-CMDEHiNhJ2Q-1; Thu, 17 Feb 2022 02:21:38 -0500
X-MC-Unique: 0GsJnJmBMG-CMDEHiNhJ2Q-1
Received: by mail-lf1-f69.google.com with SMTP id f37-20020a0565123b2500b004433d9bb4feso1535948lfv.22
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 23:21:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MK/w5CaqVN2WaOvoDgze1gKvnvxbRCEDpuTeg5VSM88=;
        b=hxeIGme8+iVH1zIlkxfBuDV5RxKDULAVmaEYiYR63EEghD+MZCG34uMdJ7TxH3skz1
         VUR4t7pS00H7LbHHJhM92eY9nxe/B0XTqU51VcwJest/n0yEYT/H0e5sFEoRZI2wuxEV
         hSptqxsULXbfpjkBGpibx25VCuqHblA/BT2lidqPXD5v4Y7UvP+4wX6OKEP2PwCLBFU1
         78CSni1nCiGI4RAyWl2zFLqgUMlpUeSxB0KMS2qpMwF7WWzmRbZFayAnj2qyG36EPjAe
         8vc+ZujTkCoZmU/FUrN5/721udGkXh3bidjAga4TzSLtjNctzqf0msKJfYbZKSr+D/h6
         w7vw==
X-Gm-Message-State: AOAM5330Y3B9JYrJVRJZwWB4qGwslrJ1482X2L5w7FHTywNUkhkOnQ98
        EAXJPvqOugEhPqYeoiYXxpbxjR2qE0lasmUapmd52Z7woyKT/SHcjy4sF16iS5QqOw6ZAyzfNjx
        ugsNyhpyi6aR9Bl6tb6/dBiGBOENJxwj1
X-Received: by 2002:ac2:5dc9:0:b0:443:5db1:244c with SMTP id x9-20020ac25dc9000000b004435db1244cmr1234540lfq.84.1645082497393;
        Wed, 16 Feb 2022 23:21:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxbfpKRrqedpKyeZauCLg5Kmr+HPSiEonm1qoPRESgaCwlyrbWvcenrKeaJ0wCQuxOVhIznhGs2jYN71FJfjD0=
X-Received: by 2002:ac2:5dc9:0:b0:443:5db1:244c with SMTP id
 x9-20020ac25dc9000000b004435db1244cmr1234535lfq.84.1645082497203; Wed, 16 Feb
 2022 23:21:37 -0800 (PST)
MIME-Version: 1.0
References: <20220214081416.117695-1-xuanzhuo@linux.alibaba.com>
 <20220214081416.117695-21-xuanzhuo@linux.alibaba.com> <CACGkMEvZvhSb0veCynEHN3EfFu_FwbCAb8w1b0Oi3LDc=ffNaw@mail.gmail.com>
 <1644997568.827981-1-xuanzhuo@linux.alibaba.com>
In-Reply-To: <1644997568.827981-1-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 17 Feb 2022 15:21:26 +0800
Message-ID: <CACGkMEt_AEw2Jh9VzkGQ2A8f8Y0nuuFxr193_vnkFpc=JyD2Sg@mail.gmail.com>
Subject: Re: [PATCH v5 20/22] virtio_net: set the default max ring num
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 16, 2022 at 3:52 PM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
>
> On Wed, 16 Feb 2022 12:14:31 +0800, Jason Wang <jasowang@redhat.com> wrote:
> > On Mon, Feb 14, 2022 at 4:14 PM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
> > >
> > > Sets the default maximum ring num based on virtio_set_max_ring_num().
> > >
> > > The default maximum ring num is 1024.
> >
> > Having a default value is pretty useful, I see 32K is used by default for IFCVF.
> >
> > Rethink this, how about having a different default value based on the speed?
> >
> > Without SPEED_DUPLEX, we use 1024. Otherwise
> >
> > 10g 4096
> > 40g 8192
>
> We can define different default values of tx and rx by the way. This way I can
> just use it in the new interface of find_vqs().
>
> without SPEED_DUPLEX:  tx 512 rx 1024
>

Any reason that TX is smaller than RX?

Thanks

> Thanks.
>
>
> >
> > etc.
> >
> > (The number are just copied from the 10g/40g default parameter from
> > other vendors)
> >
> > Thanks
> >
> > >
> > > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > ---
> > >  drivers/net/virtio_net.c | 4 ++++
> > >  1 file changed, 4 insertions(+)
> > >
> > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > index a4ffd7cdf623..77e61fe0b2ce 100644
> > > --- a/drivers/net/virtio_net.c
> > > +++ b/drivers/net/virtio_net.c
> > > @@ -35,6 +35,8 @@ module_param(napi_tx, bool, 0644);
> > >  #define GOOD_PACKET_LEN (ETH_HLEN + VLAN_HLEN + ETH_DATA_LEN)
> > >  #define GOOD_COPY_LEN  128
> > >
> > > +#define VIRTNET_DEFAULT_MAX_RING_NUM 1024
> > > +
> > >  #define VIRTNET_RX_PAD (NET_IP_ALIGN + NET_SKB_PAD)
> > >
> > >  /* Amount of XDP headroom to prepend to packets for use by xdp_adjust_head */
> > > @@ -3045,6 +3047,8 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
> > >                         ctx[rxq2vq(i)] = true;
> > >         }
> > >
> > > +       virtio_set_max_ring_num(vi->vdev, VIRTNET_DEFAULT_MAX_RING_NUM);
> > > +
> > >         ret = virtio_find_vqs_ctx(vi->vdev, total_vqs, vqs, callbacks,
> > >                                   names, ctx, NULL);
> > >         if (ret)
> > > --
> > > 2.31.0
> > >
> >
>

