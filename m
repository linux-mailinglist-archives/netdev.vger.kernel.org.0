Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FEAD31C5ED
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 05:09:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbhBPEH1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 23:07:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbhBPEHY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 23:07:24 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1490DC061574;
        Mon, 15 Feb 2021 20:06:44 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id j12so5353412pfj.12;
        Mon, 15 Feb 2021 20:06:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2f/WzFqo4KBhWk18IB9V9gin87MBd6a226oxEeyLBXQ=;
        b=K5NbXh3WiV5h8wIzLRYH02AT1NAEB2YzB/mMTlaRXveZlJv7KdnG82w40aid+hHsD0
         4fHHOVzBWn04cYzfcZjbDJDwI+RAbouODrnna2pre5oBx7oSNGeYxFvMjO1PCLuNBDJf
         7gurBROhw3BHTcZa/hy7RltzV2UN3S4zXpA05naa5leSnzDMjvPpTTQcFbdoRpTHDuC3
         WOB29g0Pg6rXPo3xEm1uwAZnfUTtTm0ZHrMiMxwwaoIkTfNOwzb484uYx2m4Bgxr7bs1
         +N7x0vORHxzHZwp0FdglwiCg9UbPp+Accb0Tht97Ez3iYhkcCrmSTu6oyRQoWWOt5v5b
         j1Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2f/WzFqo4KBhWk18IB9V9gin87MBd6a226oxEeyLBXQ=;
        b=Xzm2X3B+DAVKbuF9/nLJOhe+SvpomMpCwdgRDJGzmZEPh87Ps/RIiBxY0R4iTh6jzb
         JS4Yq6PAbwA4YzYxudeYabfj84Iab3L5+s7AQE6ZoY2mvzufondO5Qk8Nq9mdLFYMyE6
         UKTTIVcRl5tOV6AqPrsApyTqLkGlSXoQs8aAgI92YwitBRGrQLG+olD+PQwvHy946rRX
         Lg5zK5rzmz4kgzS878hTbNoflTYb9CbETzd4yY0t18CC9IOdBdDy321DwU8A6n4pD67I
         3GxQ+ZnNMvk7crtXnm1RT4NghfHNo8U7mbrgyn5TwhANRyr6R6uVB3EMXyO6TTA/A1BP
         UagA==
X-Gm-Message-State: AOAM532ZWDrrIHswrwzqYVuvL+D06rjonYegiQNPbKER6K+xxqkPk9Be
        O2dwVLl1ANzhPAfN7JnEiIh0KMW9Z9yO693tUR9aINGBw8iHdA==
X-Google-Smtp-Source: ABdhPJyZNziypOeaKgqbxl4AWVtF/EC/WLKiYgto5LufnZmf5x3OCmWPb3mzZTbFgb2hqpNhKpkbQnq6EINHXv/XNa4=
X-Received: by 2002:a63:3c4e:: with SMTP id i14mr17155217pgn.266.1613448403462;
 Mon, 15 Feb 2021 20:06:43 -0800 (PST)
MIME-Version: 1.0
References: <20210213214421.226357-1-xiyou.wangcong@gmail.com>
 <20210213214421.226357-5-xiyou.wangcong@gmail.com> <602ac96f9e30f_3ed41208b6@john-XPS-13-9370.notmuch>
 <CAM_iQpWufy-YnQnBf_kk_otLaTikK8YxkhgjHh_eiu8MA=0Raw@mail.gmail.com>
 <602b0a7046969_3ed41208dc@john-XPS-13-9370.notmuch> <CAM_iQpUomzGXdyjdCU8Ox-JZgQc=iZPZqs1UjRo3wxomf67_+A@mail.gmail.com>
 <602b17b0492a8_3ed41208f2@john-XPS-13-9370.notmuch> <CAM_iQpWzRpfWwZHPK=+KWbu+nLxJ=GKRHNC+97NT2DoN0qRc2A@mail.gmail.com>
 <602b24ca1fdca_51bf220832@john-XPS-13-9370.notmuch>
In-Reply-To: <602b24ca1fdca_51bf220832@john-XPS-13-9370.notmuch>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 15 Feb 2021 20:06:32 -0800
Message-ID: <CAM_iQpVm_GdVT7MiuVGpzvx9zEsXKjZer5yF8Vh8c3EKVBM3-Q@mail.gmail.com>
Subject: Re: [Patch bpf-next v3 4/5] skmsg: use skb ext instead of TCP_SKB_CB
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, duanxiongchun@bytedance.com,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        jiang.wang@bytedance.com, Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 15, 2021 at 5:50 PM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Cong Wang wrote:
> > On Mon, Feb 15, 2021 at 4:54 PM John Fastabend <john.fastabend@gmail.com> wrote:
> > >
> > > Cong Wang wrote:
> > > > On Mon, Feb 15, 2021 at 3:57 PM John Fastabend <john.fastabend@gmail.com> wrote:
> > > > >
> > > > > For TCP case we can continue to use CB and not pay the price. For UDP
> > > > > and AF_UNIX we can do the extra alloc.
> > > >
> > > > I see your point, but specializing TCP case does not give much benefit
> > > > here, the skmsg code would have to check skb->protocol etc. to decide
> > > > whether to use TCP_SKB_CB() or skb_ext:
> > > >
> > > > if (skb->protocol == ...)
> > > >   TCP_SKB_CB(skb) = ...;
> > > > else
> > > >   ext = skb_ext_find(skb);
> > > >
> > > > which looks ugly to me. And I doubt skb->protocol alone is sufficient to
> > > > distinguish TCP, so we may end up having more checks above.
> > > >
> > > > So do you really want to trade code readability with an extra alloc?
> > >
> > > Above is ugly. So I look at where the patch replaces things,
> > >
> > > sk_psock_tls_strp_read(), this is TLS specific read hook so can't really
> > > work in generic case anyways.
> > >
> > > sk_psock_strp_read(), will you have UDP, AF_UNIX stream parsers? Do these
> > > even work outside TCP cases.
> > >
> > > For these ones: sk_psock_verdict_apply(), sk_psock_verdict_recv(),
> > > sk_psock_backlog(), can't we just do some refactoring around their
> > > hook points so we know the context. For example sk_psock_tls_verdict_apply
> > > is calling sk_psock_skb_redirect(). Why not have a sk_psock_unix_redirect()
> > > and a sk_psock_udp_redirect(). There are likely some optimizations we can
> > > deploy this way. We've already don this for tls and sk_msg types for example.
> > >
> > > Then the helpers will know their types by program type, just use the right
> > > variants.
> > >
> > > So not suggestiong if/else the checks so much as having per type hooks.
> > >
> >
> > Hmm, but sk_psock_backlog() is still the only one that handles all three
> > above cases, right? It uses TCP_SKB_CB() too and more importantly it
> > is also why we can't use a per-cpu struct here (see bpf_redirect_info).
>
> Right, but the workqueue is created at init time where we will know the
> socket type based on the program/map types so can build the redirect
> backlog queue there based on the type needed. I also have a patch in

Hmm? How could a socket type match the skb type when we redirect
across-protocol?

In my use case, I want to redirect an AF_UNIX skb to a UDP socket,
clearly checking the UDP socket workqueue can't find out it is an
AF_UNIX skb. It has to be a per-skb check.

> mind that would do more specific TCP things in that code anyways. I
> can flush it out this week if anyone cares. The idea is we are wasting
> lots of cycles using skb_send_sock_locked when we can just inject
> the packet directlyy into the tcp stack.

Actually I did try the same, it clearly doesn't work for cross-protocol.

Anyway, please let me know what your suggestion for skb ext here?

It looks like we either have some ugly packet type checks, or just
use the skb ext. I don't see any other way yet, I also explored the
struct sk_buff again and still can not find anything we can reuse.
(_skb_refdst can only be reused very briefly with
tcp_skb_tsorted_save().)

Therefore, I believe using skb ext is still the best solution here.

>
> Also on the original patch here, we can't just kfree_skb() on alloc
> errors because that will look like a data drop. Errors need to be
> handled gracefully without dropping data. At least in the TCP case,
> but probably also in UDP and AF_UNIX cases as well. Original code
> was pretty loose in this regard, but it caused users to write bug
> reports and then I've been fixing most of them. If you see more
> cases let me know.

What's your suggestion here? Return -EAGAIN? But it requires
the caller put it in a loop to be graceful, but we can't do it in, for
example, sk_psock_tls_strp_read().

Thanks.
