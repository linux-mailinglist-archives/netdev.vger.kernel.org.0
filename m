Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D194C3429
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 14:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbfJAMXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 08:23:34 -0400
Received: from mail-yb1-f196.google.com ([209.85.219.196]:38909 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726131AbfJAMXd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 08:23:33 -0400
Received: by mail-yb1-f196.google.com with SMTP id x4so1129546ybr.5
        for <netdev@vger.kernel.org>; Tue, 01 Oct 2019 05:23:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Dj1eOuRIe9q1OFBHy/V6DwvZ5+1knz9sgpKJnqf5ES4=;
        b=pp3NyaJLzTQdgetptP4ACx5dFgxrlQdqJsoVDE1NZYv2UZRfEUwrCoTgWhJaHgSAZ9
         Xn33mnwsn+g5dYtZ3virrq9EMgeDOKYNVAgiDoqiQkE40gsgVJVkn11oI/31TbBKsbyB
         xDVqneQKMz61r2UEGKnAeP0zHSgR0yOQ2GCqg3AkBP54kB99FiVPLvld8um1697pvC1X
         4nY37pqtMDfhW/dMGNVOE7uZ7Et6HyxIHdgBtlQKpIGnYUC9xt7xnGr+RzVb0KVtG652
         RSYL4LGsyCPbTW/OaZuxaLMxvqXW04cRRFLn+I3lXeuiGbZlxbGyCtqkssRtctR4BnFR
         ghtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Dj1eOuRIe9q1OFBHy/V6DwvZ5+1knz9sgpKJnqf5ES4=;
        b=RWu2kD/x/MLH3G1xo7jZhwqxxklN4SgwyG+YLdMYZieQjioPE+CBU2raWO95ZcwbVm
         q2Eo6kcSmRZSn8F+0as5InD6E5yOiiKybopEWZLMLyg3GiB00jKp9RVU3IVz7WQMblOM
         TQ3FP6BoIaoP19n3kYgbZHYKk2uqcht2YxRZN8MrfyRb/vwQ0flDxEY+TtJHG8VDYOS/
         5bQGndCwOiY/ZwxzTGXLNI9N9gb0h5XvIDnrOmXdBiT8WxLmjniVRUoh4h06645GwZ00
         S5B+9Bux7y9AECUR6+DIb5W9rMLrJ0okXpNeGVF0AIIJ9jDXohEt+V9bhYf3HXq1EVIl
         kqqA==
X-Gm-Message-State: APjAAAUti8cwpZv3UvaJdqYjtdbb85PYtdc7cVhCPiJcZ6SrJ28K+eVp
        XTSXfyl5TYac4agKMyvY9G+6NTm+
X-Google-Smtp-Source: APXvYqwQPofChoumfYML1wyw4oIgWbm9uXMNp+QQfsgw/d3P9f4quEVtRq6GF4LSV9pE/qFiHyQqmA==
X-Received: by 2002:a25:bfc7:: with SMTP id q7mr16288506ybm.388.1569932612173;
        Tue, 01 Oct 2019 05:23:32 -0700 (PDT)
Received: from mail-yw1-f47.google.com (mail-yw1-f47.google.com. [209.85.161.47])
        by smtp.gmail.com with ESMTPSA id z127sm3661424ywd.45.2019.10.01.05.23.30
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Oct 2019 05:23:31 -0700 (PDT)
Received: by mail-yw1-f47.google.com with SMTP id d192so3081826ywa.1
        for <netdev@vger.kernel.org>; Tue, 01 Oct 2019 05:23:30 -0700 (PDT)
X-Received: by 2002:a0d:e255:: with SMTP id l82mr15521968ywe.269.1569932610351;
 Tue, 01 Oct 2019 05:23:30 -0700 (PDT)
MIME-Version: 1.0
References: <1569881518-21885-1-git-send-email-johunt@akamai.com>
 <1569881518-21885-2-git-send-email-johunt@akamai.com> <CAKgT0UfXYHDiz7uf51araHXTizRQpQgi8tDqNp6nX2YzeOoZ3A@mail.gmail.com>
In-Reply-To: <CAKgT0UfXYHDiz7uf51araHXTizRQpQgi8tDqNp6nX2YzeOoZ3A@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 1 Oct 2019 08:22:53 -0400
X-Gmail-Original-Message-ID: <CA+FuTSfHxNw4P9sp83_DoMmb-5NQXwSn74CUH80Ai2MSjPcjZw@mail.gmail.com>
Message-ID: <CA+FuTSfHxNw4P9sp83_DoMmb-5NQXwSn74CUH80Ai2MSjPcjZw@mail.gmail.com>
Subject: Re: [PATCH 2/2] udp: only do GSO if # of segs > 1
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Josh Hunt <johunt@akamai.com>, David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "Duyck, Alexander H" <alexander.h.duyck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 30, 2019 at 7:57 PM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Mon, Sep 30, 2019 at 3:13 PM Josh Hunt <johunt@akamai.com> wrote:
> >
> > Prior to this change an application sending <= 1MSS worth of data and
> > enabling UDP GSO would fail if the system had SW GSO enabled, but the
> > same send would succeed if HW GSO offload is enabled. In addition to this
> > inconsistency the error in the SW GSO case does not get back to the
> > application if sending out of a real device so the user is unaware of this
> > failure.
> >
> > With this change we only perform GSO if the # of segments is > 1 even
> > if the application has enabled segmentation. I've also updated the
> > relevant udpgso selftests.
> >
> > Fixes: bec1f6f69736 ("udp: generate gso with UDP_SEGMENT")
> > Signed-off-by: Josh Hunt <johunt@akamai.com>
> > ---
> >  net/ipv4/udp.c                       |  5 +++--
> >  net/ipv6/udp.c                       |  5 +++--
> >  tools/testing/selftests/net/udpgso.c | 16 ++++------------
> >  3 files changed, 10 insertions(+), 16 deletions(-)
> >
> > diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> > index be98d0b8f014..ac0baf947560 100644
> > --- a/net/ipv4/udp.c
> > +++ b/net/ipv4/udp.c
> > @@ -821,6 +821,7 @@ static int udp_send_skb(struct sk_buff *skb, struct flowi4 *fl4,
> >         int is_udplite = IS_UDPLITE(sk);
> >         int offset = skb_transport_offset(skb);
> >         int len = skb->len - offset;
> > +       int datalen = len - sizeof(*uh);
> >         __wsum csum = 0;
> >
> >         /*
> > @@ -832,7 +833,7 @@ static int udp_send_skb(struct sk_buff *skb, struct flowi4 *fl4,
> >         uh->len = htons(len);
> >         uh->check = 0;
> >
> > -       if (cork->gso_size) {
> > +       if (cork->gso_size && datalen > cork->gso_size) {
> >                 const int hlen = skb_network_header_len(skb) +
> >                                  sizeof(struct udphdr);
> >
>
> So what about the datalen == cork->gso_size case? That would only
> generate one segment wouldn't it?

Segmentation drops packets in this boundary case (not sure why).

> Shouldn't the test really be "datalen < cork->gso_size"? That should
> be the only check you need since if gso_size is 0 this statement would
> always fail anyway.
>
> Thanks.
>
> - Alex

The original choice was made to match GSO behavior of other protocols.
The drop occurs in protocol-independent skb_segment.

But I had not anticipated HW GSO to behave differently. With that,
aligning the two makes sense. Especially as UDP GSO is exposed to
userspace. Having to explicitly code a branch whether or not to pass
UDP_SEGMENT on each send based on size is confusing.

gso_size is supplied by the user. That value need not be smaller than
or equal to MTU minus headers. Some of the tests inside the branch,
especially

      if (hlen + cork->gso_size > cork->fragsize) {
              kfree_skb(skb);
              return -EINVAL;
      }

still need to be checked.
