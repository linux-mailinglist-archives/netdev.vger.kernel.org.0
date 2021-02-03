Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B64D30D209
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 04:20:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232692AbhBCDKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 22:10:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232681AbhBCDKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 22:10:39 -0500
Received: from mail-vk1-xa2c.google.com (mail-vk1-xa2c.google.com [IPv6:2607:f8b0:4864:20::a2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22545C06178C
        for <netdev@vger.kernel.org>; Tue,  2 Feb 2021 19:10:42 -0800 (PST)
Received: by mail-vk1-xa2c.google.com with SMTP id e1so5322709vkd.10
        for <netdev@vger.kernel.org>; Tue, 02 Feb 2021 19:10:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vto/V1nRpDAFJV1sEHH2oRj6U8SE/m/GDas+n8ie/uk=;
        b=R1JWG/fvahbGis3N5lNENtgw49fcpCeWOw3K0s7EnNM1nnCmtFBKm8LrpVBp89IK5e
         jxIefXSfumNgFLriRAHx4ieI7bEoIzrCuQDi6vhAgB5E79xIicUi366oEK6ohgf+tJpJ
         GcWczerX0Qg3KhudrPqgiWrcq3e07pDqudq5LOw0+NnXPoHCgMo79yx8VsBBjGCfp3pR
         D3IdKXdNs3QvsKH1xtqKWWuR969AlhT6lKMfXrcopIAUKan5KbxCkeo+w9vi0rd/q9kS
         yQPhmMjNjhb+wp/KK+3ZhR3bF0VfKpjb9OY/pxnFAlLFV/VislotLWjJkDbvJqPJcTGp
         Rtaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vto/V1nRpDAFJV1sEHH2oRj6U8SE/m/GDas+n8ie/uk=;
        b=ewQV+TIMiB/hfDsElpTFY481fAb+5hou1ut6jRXIuf66I72sYQarBFFnqAQSDUbhmn
         xpTHgT2+gbSTeqA3oMUK4LLaBuY9f1hgIQ2QJluMCtujTMzYFmGUL6NLptF41XJFTtmR
         eEdhOuCIBN4KsHcAwfFeJYegQ/yr7026rLmUjKkWjX6Ap9ZEGjhP0c53+zK465bjtEK0
         9p8lRF2SVTkaDPn+xkenM/7o3bdlyq3JMJJbOYWJcoTcHxp6ZZNdIlYCXi7dheqS1dUO
         zsVp4XDh18JnMAJni8M3wxXXJvXFTjOV28KH0ARDzHvCb8hzvM9WSdzk6xQ3kSGzMO5o
         ZBAg==
X-Gm-Message-State: AOAM530jtdW6VJ9nYzdRcvEpU5+J/n+2/zy7qbERuudqiGfXcHOyOVeN
        yIJT+CyiBjmE8t2X1HwHIMXuISWzuhc=
X-Google-Smtp-Source: ABdhPJyKX6teOu/Ng0/1IEmMHB/gXZ9iYqLKmoXadP+1RCuNwtaPaVVCddmoaD+1iN6rKMcdmg/t5A==
X-Received: by 2002:a1f:a8c5:: with SMTP id r188mr667553vke.1.1612321840928;
        Tue, 02 Feb 2021 19:10:40 -0800 (PST)
Received: from mail-ua1-f44.google.com (mail-ua1-f44.google.com. [209.85.222.44])
        by smtp.gmail.com with ESMTPSA id e19sm108405vke.12.2021.02.02.19.10.39
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Feb 2021 19:10:39 -0800 (PST)
Received: by mail-ua1-f44.google.com with SMTP id o31so2904543uae.2
        for <netdev@vger.kernel.org>; Tue, 02 Feb 2021 19:10:39 -0800 (PST)
X-Received: by 2002:ab0:7a6b:: with SMTP id c11mr705536uat.37.1612321839100;
 Tue, 02 Feb 2021 19:10:39 -0800 (PST)
MIME-Version: 1.0
References: <20210202194539.1442079-1-willemdebruijn.kernel@gmail.com> <CAKgT0Uc5ZoKFb4bxiPPz-S0snexe45F6c1JLb_uG6f+aPuLbhg@mail.gmail.com>
In-Reply-To: <CAKgT0Uc5ZoKFb4bxiPPz-S0snexe45F6c1JLb_uG6f+aPuLbhg@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 2 Feb 2021 22:10:02 -0500
X-Gmail-Original-Message-ID: <CA+FuTScNiQ2iicjOOumDeYM5kcQDew0DBjxB43JLGwqj+PVsyg@mail.gmail.com>
Message-ID: <CA+FuTScNiQ2iicjOOumDeYM5kcQDew0DBjxB43JLGwqj+PVsyg@mail.gmail.com>
Subject: Re: [PATCH net] udp: fix skb_copy_and_csum_datagram with odd segment sizes
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, oliver.graute@gmail.com,
        Sagi Grimberg <sagi@grimberg.me>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@lst.de>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 2, 2021 at 8:50 PM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Tue, Feb 2, 2021 at 11:45 AM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > From: Willem de Bruijn <willemb@google.com>
> >
> > When iteratively computing a checksum with csum_block_add, track the
> > offset to correctly rotate in csum_block_add when offset is odd.
> >
> > The open coded implementation of skb_copy_and_csum_datagram did this.
> > With the switch to __skb_datagram_iter calling csum_and_copy_to_iter,
> > pos was reinitialized to 0 on each call.
> >
> > Bring back the pos by passing it along with the csum to the callback.
> >
> > Link: https://lore.kernel.org/netdev/20210128152353.GB27281@optiplex/
> > Fixes: 950fcaecd5cc ("datagram: consolidate datagram copy to iter helpers")
> > Reported-by: Oliver Graute <oliver.graute@gmail.com>
> > Signed-off-by: Willem de Bruijn <willemb@google.com>
> >
> > ---
> >
> > Once the fix makes it to net-next, I'll follow-up with a regression
> > test to tools/testing/selftests/net
> > ---
> >  include/linux/uio.h |  8 +++++++-
> >  lib/iov_iter.c      | 24 ++++++++++++++----------
> >  net/core/datagram.c |  4 +++-
> >  3 files changed, 24 insertions(+), 12 deletions(-)
> >
> > diff --git a/include/linux/uio.h b/include/linux/uio.h
> > index 72d88566694e..308194b08ca8 100644
> > --- a/include/linux/uio.h
> > +++ b/include/linux/uio.h
> > @@ -260,7 +260,13 @@ static inline void iov_iter_reexpand(struct iov_iter *i, size_t count)
> >  {
> >         i->count = count;
> >  }
> > -size_t csum_and_copy_to_iter(const void *addr, size_t bytes, void *csump, struct iov_iter *i);
> > +
> > +struct csum_state {
> > +       __wsum *csump;
> > +       size_t off;
> > +};
> > +
>
> So now that we have a struct maintaining the state I am not sure it
> makes sense to be storing a pointer here. You can likely just get away
> with storing the checksum value itself and save yourself the extra
> pointer chases every time you want to read or write the checksum.
>
> Then it is just the task for the caller to initialize the checksum and
> offset, and to copy the checksum to the appropriate pointer when done.
> As it stands I am not sure there is much value updating the checksum
> when the entire operation could fail anyway and return -EFAULT so it
> is probably better to hold off on updating the checksum until you have
> computed the entire thing.
>
> > +size_t csum_and_copy_to_iter(const void *addr, size_t bytes, void *csstate, struct iov_iter *i);
> >  size_t csum_and_copy_from_iter(void *addr, size_t bytes, __wsum *csum, struct iov_iter *i);
> >  bool csum_and_copy_from_iter_full(void *addr, size_t bytes, __wsum *csum, struct iov_iter *i);
> >  size_t hash_and_copy_to_iter(const void *addr, size_t bytes, void *hashp,
> > diff --git a/lib/iov_iter.c b/lib/iov_iter.c
> > index a21e6a5792c5..087235d60514 100644
> > --- a/lib/iov_iter.c
> > +++ b/lib/iov_iter.c
> > @@ -592,14 +592,15 @@ static __wsum csum_and_memcpy(void *to, const void *from, size_t len,
> >  }
> >
> >  static size_t csum_and_copy_to_pipe_iter(const void *addr, size_t bytes,
> > -                               __wsum *csum, struct iov_iter *i)
> > +                                        struct csum_state *csstate,
> > +                                        struct iov_iter *i)
> >  {
> >         struct pipe_inode_info *pipe = i->pipe;
> >         unsigned int p_mask = pipe->ring_size - 1;
> > +       __wsum sum = *csstate->csump;
> > +       size_t off = csstate->off;
> >         unsigned int i_head;
> >         size_t n, r;
> > -       size_t off = 0;
> > -       __wsum sum = *csum;
> >
> >         if (!sanity(i))
> >                 return 0;
> > @@ -621,7 +622,8 @@ static size_t csum_and_copy_to_pipe_iter(const void *addr, size_t bytes,
> >                 i_head++;
> >         } while (n);
> >         i->count -= bytes;
> > -       *csum = sum;
> > +       *csstate->csump = sum;
> > +       csstate->off = off;
> >         return bytes;
> >  }
> >
> > @@ -1522,18 +1524,19 @@ bool csum_and_copy_from_iter_full(void *addr, size_t bytes, __wsum *csum,
> >  }
> >  EXPORT_SYMBOL(csum_and_copy_from_iter_full);
> >
> > -size_t csum_and_copy_to_iter(const void *addr, size_t bytes, void *csump,
> > +size_t csum_and_copy_to_iter(const void *addr, size_t bytes, void *_csstate,
> >                              struct iov_iter *i)
> >  {
> > +       struct csum_state *csstate = _csstate;
> >         const char *from = addr;
> > -       __wsum *csum = csump;
> >         __wsum sum, next;
> > -       size_t off = 0;
> > +       size_t off;
> >
> >         if (unlikely(iov_iter_is_pipe(i)))
> > -               return csum_and_copy_to_pipe_iter(addr, bytes, csum, i);
> > +               return csum_and_copy_to_pipe_iter(addr, bytes, _csstate, i);
> >
> > -       sum = *csum;
> > +       sum = *csstate->csump;
> > +       off = csstate->off;
> >         if (unlikely(iov_iter_is_discard(i))) {
> >                 WARN_ON(1);     /* for now */
> >                 return 0;
> > @@ -1561,7 +1564,8 @@ size_t csum_and_copy_to_iter(const void *addr, size_t bytes, void *csump,
> >                 off += v.iov_len;
> >         })
> >         )
> > -       *csum = sum;
> > +       *csstate->csump = sum;
> > +       csstate->off = off;
> >         return bytes;
> >  }
> >  EXPORT_SYMBOL(csum_and_copy_to_iter);
> > diff --git a/net/core/datagram.c b/net/core/datagram.c
> > index 81809fa735a7..c6ac5413dda9 100644
> > --- a/net/core/datagram.c
> > +++ b/net/core/datagram.c
> > @@ -721,8 +721,10 @@ static int skb_copy_and_csum_datagram(const struct sk_buff *skb, int offset,
> >                                       struct iov_iter *to, int len,
> >                                       __wsum *csump)
> >  {
> > +       struct csum_state csdata = { .csump = csump };
> > +
> >         return __skb_datagram_iter(skb, offset, to, len, true,
> > -                       csum_and_copy_to_iter, csump);
> > +                       csum_and_copy_to_iter, &csdata);
> >  }
> >
> >  /**
>
> The rest of this looks good to me, and my only complaint is the
> performance nit called out above.
>
> Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>

Thanks a lot for reviewing. Good point on the unnecessary pointer.
I'll revise that as suggested.
