Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3585D114
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 15:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbfGBN6v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 09:58:51 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:40533 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726341AbfGBN6v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 09:58:51 -0400
Received: by mail-oi1-f194.google.com with SMTP id w196so13091822oie.7;
        Tue, 02 Jul 2019 06:58:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BsQb0987y7DGJiCbM+1oRL5bU8C7dXL+HPdc6nvVup8=;
        b=BCjN6TDckKE5YwlGwOhJycynO81a7qTVY0qR/emABsFXko0iCkjX15mFts+Yoj7tnF
         LGe5ZEBwT/YSOiXukqNuRtrFIjSHNS2dKomSABWgUKrZqEFQdftHc2s+nEeLBDVNmOvG
         YJgC+t0yCbyTesZMNC45yauuRu8d4Hq/tbAPfd0DMzj8CWvXyw1JHAC0DUZ3vENbGLMg
         pB4zE96mo9QopN8oKZfr5f7k5izKsm8w4oc7Q2D9Xx8LthVwwzLArBkqCc65CGfmeIJn
         CoB2+CNytDOOv0dj9PN4Wb/u5ff5vnw9baPTjxOXsPWJSAdgdqD6q5YKC2UnQETtkP1o
         BIhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BsQb0987y7DGJiCbM+1oRL5bU8C7dXL+HPdc6nvVup8=;
        b=IQzGMbUY/DIG++UcAiAMT0nk04elXyhNkuxWWuKtRIz3Gu7L5Fv9nsuG2nedCzOgJF
         lIMQaRQesySSrmURUZXLvr5V6j5rVM7svLDvragca6AbfwY5SBG2rS2VKmV2G23lBlpw
         cVn7mAHCh4nQw4CAHJnAQG8wfl5MLLnMJQKJxjfd+KSA/WPc9yJ38i/tOjvds6vMULZr
         hKwEIo5ZK81Hm51UtQFlVXjcQNW4uSyUaHbLxiaMB/mXRC/5fUD+treKPMTjNYjAKsGu
         tSA+ruos7Lb3y+sn1pnupLyIUuJzPBbErl96nGpDj+JQnJ9E0bF0EPD5nu6PjxpUcvNu
         RVMg==
X-Gm-Message-State: APjAAAWMPZwge5o03ek6FffTUr6yNNOLMr2fWooPxBsusC0/zHy7RqO3
        DQJJX7LgVDvtYD2ACQ9hRgNxetraqt1u/ZQau14=
X-Google-Smtp-Source: APXvYqxN5xda1GqazGPAFddIWqo5p+zXSgrM8ZaqJVN2w4UvmWOrV5+NVonOsYljFi7ERJFMUVlcNFxhO/OmBpuZwtw=
X-Received: by 2002:aca:4306:: with SMTP id q6mr3114545oia.39.1562075930038;
 Tue, 02 Jul 2019 06:58:50 -0700 (PDT)
MIME-Version: 1.0
References: <1562059288-26773-1-git-send-email-magnus.karlsson@intel.com>
 <1562059288-26773-3-git-send-email-magnus.karlsson@intel.com> <d4318783-18a4-d5c1-1044-691aaebb2b0a@mellanox.com>
In-Reply-To: <d4318783-18a4-d5c1-1044-691aaebb2b0a@mellanox.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Tue, 2 Jul 2019 15:58:38 +0200
Message-ID: <CAJ8uoz0jnR99iVCK+f3U5=Xo7JQ1SRM=Os7A0J9cTb_=8bL_Mg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 2/6] xsk: add support for need_wakeup flag in
 AF_XDP rings
To:     Maxim Mikityanskiy <maximmi@mellanox.com>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "bjorn.topel@intel.com" <bjorn.topel@intel.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "bruce.richardson@intel.com" <bruce.richardson@intel.com>,
        "ciara.loftus@intel.com" <ciara.loftus@intel.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "xiaolong.ye@intel.com" <xiaolong.ye@intel.com>,
        "qi.z.zhang@intel.com" <qi.z.zhang@intel.com>,
        "sridhar.samudrala@intel.com" <sridhar.samudrala@intel.com>,
        "kevin.laatz@intel.com" <kevin.laatz@intel.com>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "kiran.patil@intel.com" <kiran.patil@intel.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "maciej.fijalkowski@intel.com" <maciej.fijalkowski@intel.com>,
        "maciejromanfijalkowski@gmail.com" <maciejromanfijalkowski@gmail.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 2, 2019 at 3:47 PM Maxim Mikityanskiy <maximmi@mellanox.com> wrote:
>
> On 2019-07-02 12:21, Magnus Karlsson wrote:
> >
> > +/* XDP_RING flags */
> > +#define XDP_RING_NEED_WAKEUP (1 << 0)
> > +
> >   struct xdp_ring_offset {
> >       __u64 producer;
> >       __u64 consumer;
> >       __u64 desc;
> > +     __u64 flags;
> >   };
> >
> >   struct xdp_mmap_offsets {
>
> <snip>
>
> > @@ -621,9 +692,12 @@ static int xsk_getsockopt(struct socket *sock, int level, int optname,
> >       case XDP_MMAP_OFFSETS:
> >       {
> >               struct xdp_mmap_offsets off;
> > +             bool flags_supported = true;
> >
> > -             if (len < sizeof(off))
> > +             if (len < sizeof(off) - sizeof(off.rx.flags))
> >                       return -EINVAL;
> > +             else if (len < sizeof(off))
> > +                     flags_supported = false;
> >
> >               off.rx.producer = offsetof(struct xdp_rxtx_ring, ptrs.producer);
> >               off.rx.consumer = offsetof(struct xdp_rxtx_ring, ptrs.consumer);
> > @@ -638,6 +712,16 @@ static int xsk_getsockopt(struct socket *sock, int level, int optname,
> >               off.cr.producer = offsetof(struct xdp_umem_ring, ptrs.producer);
> >               off.cr.consumer = offsetof(struct xdp_umem_ring, ptrs.consumer);
> >               off.cr.desc     = offsetof(struct xdp_umem_ring, desc);
> > +             if (flags_supported) {
> > +                     off.rx.flags = offsetof(struct xdp_rxtx_ring,
> > +                                             ptrs.flags);
> > +                     off.tx.flags = offsetof(struct xdp_rxtx_ring,
> > +                                             ptrs.flags);
> > +                     off.fr.flags = offsetof(struct xdp_umem_ring,
> > +                                             ptrs.flags);
> > +                     off.cr.flags = offsetof(struct xdp_umem_ring,
> > +                                             ptrs.flags);
> > +             }
>
> As far as I understood (correct me if I'm wrong), you are trying to
> preserve backward compatibility, so that if userspace doesn't support
> the flags field, you will determine that by looking at len and fall back
> to the old format.

That was the intention yes.

> However, two things are broken here:
>
> 1. The check `len < sizeof(off) - sizeof(off.rx.flags)` should be `len <
> sizeof(off) - 4 * sizeof(flags)`, because struct xdp_mmap_offsets
> consists of 4 structs xdp_ring_offset.
>
> 2. The old and new formats are not binary compatible, as flags are
> inserted in the middle of struct xdp_mmap_offsets.

You are correct. Since there are four copies of the xdp_ring_offset
this simple scheme will not work. I will instead create an internal
version 1 of the struct that I fill in and pass to user space if I
detect that user space is asking for the v1 size.

Thanks for catching Maxim. Keep'em coming.

/Magnus
