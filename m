Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 113F834FBE7
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 10:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231375AbhCaIug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 04:50:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234032AbhCaIuJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 04:50:09 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75F95C061574
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 01:50:09 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id o66so20350705ybg.10
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 01:50:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1Cbqbrv0S63UxFfl9kL+Ft82D2BkMEVLugIjIwl2Ueo=;
        b=ipL/KY5WIyONJYOI+pWjVybKmHdXmRcexHkyIyUxdgAF96UF+/L4eZVrCcmYILwKkq
         r0B3v9wmRxoI4buHh28S+wGr0eVBrbhSa4iKqPDNggsF0ph+LcREHtr0ZVN9I2zmY4rq
         9XCNYbebUhmxLzY+EnQeb85cBCROkm6pAwewA4QJuIyTGKvxMHrXzsNz1+dCCgYlr8oV
         5bjyyqc7D1HdHX0/LNUHPFjG8+Bep1aeiwSFNc0XkMcw/kDYF3ZWpa5W8ejZlahs74W1
         vp9sb5yrN9nrmiwTMp8COXAdwFMDi7c4fSCsbjZcFz5EhwaJJ5rHRSntrKUWrMyactjL
         pt7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1Cbqbrv0S63UxFfl9kL+Ft82D2BkMEVLugIjIwl2Ueo=;
        b=tQRS9ZR06t+6dwzkq5kz+lMHD3nIC4Khz5jt/sN0M7s1qrOflVM+A5z4V57VAftv1A
         bbOpAUKmiRyeS0uJg4fK0Jz3v2wFbPGOBu+CUHtFtGH0L4a8CqEEhIC8oIDhsac4FqPp
         sMvevx3LHJ+AEII61hR8UzsFLOMn3GScyDR+aT+yWg5NzHV21GTymu4kF+jBzDvtUOFm
         2eOd+yKtX6eEAPV/SaoUenGcjTrA0OlK1nR6NnfOsjP8IZQZjJMFIZtZY1NVO2mAKYY4
         2iFS9VJuSH06wjn4wU5RxstXCJuJwIjZF+qVz/Z41VrgyJkOi7WuVrGlSV+Ex76fcOeS
         Kocg==
X-Gm-Message-State: AOAM531edGJYpGBVrLfj7x35jfNMEsoB138x8NrpX0lVjS5YEf2oBz7D
        g30gujqcErWnmvg/YBhbEmEgti+XBwBGEFlkOV9OQw==
X-Google-Smtp-Source: ABdhPJzt+Ft9Nnv/KfQa/iaXRwpj1QV/HRlk3Z/043+i/5AFUQlTaKFivUxnBa6dgVfVzO5RZfO/kIR5cVbXUHnURR8=
X-Received: by 2002:a25:d687:: with SMTP id n129mr3280192ybg.132.1617180608473;
 Wed, 31 Mar 2021 01:50:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210113161819.1155526-1-eric.dumazet@gmail.com>
 <1617007696.5731978-1-xuanzhuo@linux.alibaba.com> <CANn89iLXfu7mdk+cxqVYxtJhfBQtpho6i2kyOEUbEGPXBQj+jg@mail.gmail.com>
 <20210331040405-mutt-send-email-mst@kernel.org> <CANn89iJN3SQDctZxaPdZMSPGRbjLrsYGM7=Y2POv-3Ysw-EZ_w@mail.gmail.com>
 <CANn89i+E=Bu4zPwtQGNZzoPdTzsb+9rWx0d73ZHm_nWQfHRHMA@mail.gmail.com>
In-Reply-To: <CANn89i+E=Bu4zPwtQGNZzoPdTzsb+9rWx0d73ZHm_nWQfHRHMA@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 31 Mar 2021 10:49:57 +0200
Message-ID: <CANn89iLEm-zxWyNwWNoJ_w+qEydiw2_g0tttd_y1_+_8TxVtCg@mail.gmail.com>
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

On Wed, Mar 31, 2021 at 10:46 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Wed, Mar 31, 2021 at 10:36 AM Eric Dumazet <edumazet@google.com> wrote:
> >

> >
> > I was looking at this code (page_to_skb())  a few minutes ago ;)
> >
> > pulling payload would make sense only if can pull of of it (to free the page)
> > (This is what some drivers implement and call copybreak)
> >
> > Even if we do not have an accurate knowledge of header sizes,
> > it would be better to pull only the Ethernet header and let GRO do the
> > rest during its dissection.
> >
> > Once fixed, virtio_net will reduce by 2x number of frags per skb,
> > compared to the situation before "net: avoid 32 x truesize
> > under-estimation for tiny skbs"
>
> Ie I suspect the simple way to fix this would be :
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index bb4ea9dbc16bcb19c5969fc8247478aa66c63fce..a5500bf6ac01051be949edf9fead934a90335f4f
> 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -409,9 +409,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>         offset += hdr_padded_len;
>         p += hdr_padded_len;
>
> -       copy = len;
> -       if (copy > skb_tailroom(skb))
> -               copy = skb_tailroom(skb);
> +       copy = min_t(int, len, ETH_HLEN);
>         skb_put_data(skb, p, copy);
>
>         if (metasize) {

A  'copybreak' aware version would be :

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index bb4ea9dbc16bcb19c5969fc8247478aa66c63fce..dd58b075ca53643231bc1795c7283fcd8609547b
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
+               copy = min_t(int, len, ETH_HLEN);
        skb_put_data(skb, p, copy);

        if (metasize) {
