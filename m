Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD201287C07
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 21:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729494AbgJHTEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 15:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726006AbgJHTEj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 15:04:39 -0400
Received: from mail-vs1-xe2b.google.com (mail-vs1-xe2b.google.com [IPv6:2607:f8b0:4864:20::e2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5AA8C061755
        for <netdev@vger.kernel.org>; Thu,  8 Oct 2020 12:04:39 -0700 (PDT)
Received: by mail-vs1-xe2b.google.com with SMTP id x185so3661807vsb.1
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 12:04:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QGE0pxv70aIldxUeZF5iAxoTyZgre/aBj5qPSL/tqUA=;
        b=FT9f+WIk7crurF5wAqHaM+dumnycaOOKEMIitEkSaMy+riLzK1ByMMm2SfKPpXFy32
         Hn4C3KF2RpdasIKE9KgIrv+rr1+Z+vJlVaI73NKS0+17/l7t1yQZjdFS9PRZtJdKP96G
         mvmPp6pF56IczM+YupQUKwUZofTSwGpkHJH9hPBupZLFQb7QcmBKzJhkpLsocFcjTlR3
         wPEVy44F80nraZFrtJaT5FmZg4UNN1goGcVNsQkuORWayDbo/fDvvsibCORBDeJFQ2wR
         9Aht8lA8AiH0aqjpU/kJdjGCi4DFRbW2WB1YK8NOcvRQbVkRTQuntJlaiK/YmNnR69se
         0f+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QGE0pxv70aIldxUeZF5iAxoTyZgre/aBj5qPSL/tqUA=;
        b=EFiG4q+tdZdwX359SjvZN2q7l1vRT66uh9G3DDIt7Tg8VT2zTkq/yuVRo5TDt8WRYj
         s4R3qIAnBz2M9YXl6SiGbU2wk0LlWIV2TtgycJvvySGfs9z9PhuimIhzLx7iy57IIim3
         AB0WSVx8vNWQL19npkpoWgGChZ3h0ohbViqTL34xfV549qCL3YRiqTsybzCNkbfQjc0+
         jYVc+Ont2xgrXzXMo+aKE7/hQvmhPropMy3lZoD4c8YAHZwNEUQxljI36UzTkaXYfFBr
         lUmX/8oJ6LSFiaI5m3qWa2k3YQp5wcQfzYjkT5wE2jGDjCxs8cObvU0tCv4v3LHupN/K
         R3lQ==
X-Gm-Message-State: AOAM531dcDIRuUutSiQUB4g76ogcLva3kH6Y9uWw5o7jJTIyYZP286rE
        VOYZMBGkypHaxyZ718BLNz896/qYKKw=
X-Google-Smtp-Source: ABdhPJxodac5pRjd4e1VUUJb5k15uNpWmEHNeBMPRSKORM39/nDNnV7VlgR93j06JkjrMHV5ktopRw==
X-Received: by 2002:a67:ef1b:: with SMTP id j27mr1983640vsr.1.1602183877672;
        Thu, 08 Oct 2020 12:04:37 -0700 (PDT)
Received: from mail-ua1-f51.google.com (mail-ua1-f51.google.com. [209.85.222.51])
        by smtp.gmail.com with ESMTPSA id a10sm761827vsm.28.2020.10.08.12.04.36
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2020 12:04:36 -0700 (PDT)
Received: by mail-ua1-f51.google.com with SMTP id c1so2226034uap.3
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 12:04:36 -0700 (PDT)
X-Received: by 2002:ab0:2a43:: with SMTP id p3mr5852134uar.122.1602183876196;
 Thu, 08 Oct 2020 12:04:36 -0700 (PDT)
MIME-Version: 1.0
References: <20201008012154.11149-1-xiyou.wangcong@gmail.com>
 <CA+FuTSeMYFh3tY9cJN6h02E+r3BST=w74+pD=zraLXsmJTLZXA@mail.gmail.com> <CAM_iQpWCR84sD6dZBforgt4cg-Jya91D6EynDo2y2sC7vi-vMg@mail.gmail.com>
In-Reply-To: <CAM_iQpWCR84sD6dZBforgt4cg-Jya91D6EynDo2y2sC7vi-vMg@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 8 Oct 2020 15:04:01 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdKa1Q36ONbsGOMqXDCUiiDNsA6rkqyrzB+eXJj=MyRKA@mail.gmail.com>
Message-ID: <CA+FuTSdKa1Q36ONbsGOMqXDCUiiDNsA6rkqyrzB+eXJj=MyRKA@mail.gmail.com>
Subject: Re: [Patch net] ip_gre: set dev->hard_header_len properly
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        syzbot <syzbot+4a2c52677a8a1aa283cb@syzkaller.appspotmail.com>,
        William Tu <u9012063@gmail.com>, Xie He <xie.he.0141@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 8, 2020 at 1:34 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Thu, Oct 8, 2020 at 4:49 AM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > On Wed, Oct 7, 2020 at 9:22 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > >
> > > GRE tunnel has its own header_ops, ipgre_header_ops, and sets it
> > > conditionally. When it is set, it assumes the outer IP header is
> > > already created before ipgre_xmit().
> > >
> > > This is not true when we send packets through a raw packet socket,
> > > where L2 headers are supposed to be constructed by user. Packet
> > > socket calls dev_validate_header() to validate the header. But
> > > GRE tunnel does not set dev->hard_header_len, so that check can
> > > be simply bypassed, therefore uninit memory could be passed down
> > > to ipgre_xmit().
> >
> > If dev->hard_header_len is zero, the packet socket will not reserve
> > room for the link layer header, so skb->data points to network_header.
> > But I don't see any uninitialized packet data?
>
> The uninit data is allocated by packet_alloc_skb(), if dev->hard_header_len
> is 0 and 'len' is anything between [0, tunnel->hlen + sizeof(struct iphdr)),
> dev_validate_header() still returns true obviously but only 'len'
> bytes are copied
> from user-space by skb_copy_datagram_from_iter(). Therefore, those bytes
> within range (len, tunnel->hlen + sizeof(struct iphdr)] are uninitialized.

With dev->hard_header_len of zero, packet_alloc_skb() only allocates len bytes.

With SOCK_RAW, the writer is expected to write the ip and gre header
and include these in the send len argument. The only difference I see
is that with hard_header_len the data starts reserve bytes before
skb_network_header, and an additional tail has been allocated that is
not used.

But this also fixes a potentially more serious bug. With SOCK_DGRAM,
dev_hard_header/ipgre_header just assumes that there is enough room in
the packet to skb_push(skb, t->hlen + sizeof(*iph)). Which may be
false if this header length had not been reserved.

Though I've mainly looked at packet_snd. Perhaps you are referring to
tpacket_snd?
