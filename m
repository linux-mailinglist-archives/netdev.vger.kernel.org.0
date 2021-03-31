Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B043334FBFD
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 10:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234388AbhCaIz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 04:55:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234501AbhCaIzM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 04:55:12 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77F4EC061574
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 01:55:01 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id k3so10036053ybh.4
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 01:55:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t0y3mrwU0m2tHBKG5Fnwle5WVpD9lRVfizkFhs4I+5I=;
        b=wWte03cFc2kKWajSrpzWjuNlVv32V52cQHvy1zqV8bTZIW4fgTCfB58h4bpBA6wOAn
         2FtgIkG52cv48k2682AXseefFFZJwnj4kNzg51ahyPTHq1+U3UrEgQ8LLDzD+ZDjLaYa
         ih2B7AMZvW2237IJDJytEeAuz/f7cBA5SDyJ9slhEiMm0jNSQIxlDx24P/DJ+8qn+yqf
         kuGjJVs1yTSgeXb54UFUUeUAoDsi64/8y7LJUuhnKqzTYGy/rJam2+Sff3qdTE8XwcOf
         UuF1rZMA24oVTAj4MRGEFuO7klgGYTVWAW0EtKLmXqx1yfBgPU5gyRHqjHsmDrwapH5n
         6OLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t0y3mrwU0m2tHBKG5Fnwle5WVpD9lRVfizkFhs4I+5I=;
        b=WmAVdPLoM8sk5KJdFJefDJpIWOlKI6rhL7NN2meKLSuRG7anfZQVpECPnDkMyJrBKw
         On4W4SLFZ/jTRaay1Vmyw+4xrGx/EqwHI3jE3p6Vxn5t0ZaJ8lbwoVA/fgifMYWxonVW
         nB1XyaxEpiDiaTKhhHJl4teXB9ekbEh0vS5K6liUMvZlA0gSJR5JCMJIe2l8tAqWJdcc
         +twa1nokXSLRUXEMK2VPNz8D5JppZR4dv3+BWQtQ0RBabQGhXm4wq8hBfj+rl3EgWcON
         mF+Kc6QUWC3iElKzjVCsSFjn72ldm5Rtkum6myRr+GoMpj8cZrIKQFPfTpM5l0F89KjK
         D1Ng==
X-Gm-Message-State: AOAM530SQfwAhyQ/YvntHBq1+22iNG66tjVpF6bP20vzGUFo2ZVVoq5P
        0R+7AXBLkngMaBWtrlr38LUfKe1YQWZHnZCcmuCtiw==
X-Google-Smtp-Source: ABdhPJz+kwBYGkDa2cfM8x0owfpceyd3XjmZF4Igw22P2n8QyhS+fSdgAgjYf0gr2cKvCtageAComTm/ekkYjHsS9R4=
X-Received: by 2002:a25:7e01:: with SMTP id z1mr3330959ybc.253.1617180900370;
 Wed, 31 Mar 2021 01:55:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210113161819.1155526-1-eric.dumazet@gmail.com>
 <1617007696.5731978-1-xuanzhuo@linux.alibaba.com> <CANn89iLXfu7mdk+cxqVYxtJhfBQtpho6i2kyOEUbEGPXBQj+jg@mail.gmail.com>
 <20210331040405-mutt-send-email-mst@kernel.org> <CANn89iJN3SQDctZxaPdZMSPGRbjLrsYGM7=Y2POv-3Ysw-EZ_w@mail.gmail.com>
 <CANn89i+E=Bu4zPwtQGNZzoPdTzsb+9rWx0d73ZHm_nWQfHRHMA@mail.gmail.com> <CANn89iLEm-zxWyNwWNoJ_w+qEydiw2_g0tttd_y1_+_8TxVtCg@mail.gmail.com>
In-Reply-To: <CANn89iLEm-zxWyNwWNoJ_w+qEydiw2_g0tttd_y1_+_8TxVtCg@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 31 Mar 2021 10:54:49 +0200
Message-ID: <CANn89iLhgOCiH5QSU15gfrepfwgh58WqY3UZpUnyi5V+vx3UDA@mail.gmail.com>
Subject: Re: [PATCH net] net: avoid 32 x truesize under-estimation for tiny skbs
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Thelen <gthelen@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, su-lifan@linux.alibaba.com,
        "dust.li" <dust.li@linux.alibaba.com>,
        Jason Wang <jasowang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 31, 2021 at 10:49 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Wed, Mar 31, 2021 at 10:46 AM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Wed, Mar 31, 2021 at 10:36 AM Eric Dumazet <edumazet@google.com> wrote:
> > >
>
> > >
> > > I was looking at this code (page_to_skb())  a few minutes ago ;)
> > >
> > > pulling payload would make sense only if can pull of of it (to free the page)
> > > (This is what some drivers implement and call copybreak)
> > >
> > > Even if we do not have an accurate knowledge of header sizes,
> > > it would be better to pull only the Ethernet header and let GRO do the
> > > rest during its dissection.
> > >
> > > Once fixed, virtio_net will reduce by 2x number of frags per skb,
> > > compared to the situation before "net: avoid 32 x truesize
> > > under-estimation for tiny skbs"
> >
> > Ie I suspect the simple way to fix this would be :
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index bb4ea9dbc16bcb19c5969fc8247478aa66c63fce..a5500bf6ac01051be949edf9fead934a90335f4f
> > 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -409,9 +409,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
> >         offset += hdr_padded_len;
> >         p += hdr_padded_len;
> >
> > -       copy = len;
> > -       if (copy > skb_tailroom(skb))
> > -               copy = skb_tailroom(skb);
> > +       copy = min_t(int, len, ETH_HLEN);
> >         skb_put_data(skb, p, copy);
> >
> >         if (metasize) {
>
> A  'copybreak' aware version would be :
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index bb4ea9dbc16bcb19c5969fc8247478aa66c63fce..dd58b075ca53643231bc1795c7283fcd8609547b
> 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -409,9 +409,13 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>         offset += hdr_padded_len;
>         p += hdr_padded_len;
>
> -       copy = len;
> -       if (copy > skb_tailroom(skb))
> -               copy = skb_tailroom(skb);
> +       /* Copy all frame if it fits skb->head,
> +        * otherwise we let GRO pull headers as needed.
> +        */
> +       if (len <= skb_tailroom(skb))
> +               copy = len;
> +       else
> +               copy = min_t(int, len, ETH_HLEN);
>         skb_put_data(skb, p, copy);
>
>         if (metasize) {

Not that we might need to include 'metasize' in the picture.

maybe :

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index bb4ea9dbc16bcb19c5969fc8247478aa66c63fce..f5a3cecd18eada32694714ecb85c205af7108aae
100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -409,9 +409,13 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
        offset += hdr_padded_len;
        p += hdr_padded_len;

-       copy = len;
-       if (copy > skb_tailroom(skb))
-               copy = skb_tailroom(skb);
+       /* Copy all frame if it fits skb->head,
+        * otherwise we let GRO pull headers as needed.
+        */
+       if (len <= skb_tailroom(skb))
+               copy = len;
+       else
+               copy = min_t(int, len, ETH_HLEN + metasize);
        skb_put_data(skb, p, copy);

        if (metasize) {
