Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B205831C4C1
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 02:05:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbhBPBEx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 20:04:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbhBPBEw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 20:04:52 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EA37C0613D6;
        Mon, 15 Feb 2021 17:04:12 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id z7so4618374plk.7;
        Mon, 15 Feb 2021 17:04:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZzvSBqVTSxnIpImJxVeR1wLR+7nkllVP+iYYh3SxnC8=;
        b=iy882G18mw6wsS5lzjPJ+NItB4FfF/snQqKO54jAwmzLWhfYKzMMtdg/Fkt+Smqr6Y
         3rKQ4lqHayNnHIh+SOOZF5ZFX3CN2LDjaM2M+PziqXkEhacWvQxWMJKurZQAaeSPZBY0
         P9E1vfT6C/Yhqj8DWFSyO6a3k3488CGMaur6pBuQeHF7Nxsj5ygVfE9wbIAquH/s47gi
         T1yCW27nKDeOujnlRQvoyx9KgKDDZz3hKm7hlJyYIDH+KIhSquh8rJ0/1SyzQBHLFKs3
         p/MSegfxQ5CDjujilak/IKuD2EuyEghJpM2esUjf2lYkOOKW2i4cqeX5WPOpGZD4BAwW
         TdRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZzvSBqVTSxnIpImJxVeR1wLR+7nkllVP+iYYh3SxnC8=;
        b=K6cjjHaJTugOIF5cZNGN66g5UUIXk8Af+U4kkEkMDdO4UXNBrwhZKCqUHYHM+geB+t
         Y45NJTPvaL+go0lePY0m537un8gCPIIS1jF6LFp8PStCgKIXKCkB87OfWN3f/QYDDjLL
         4ri/enEhSFEimUThnuu92solrb9qN0D5gVuKrytowM6/ItoH0+telxLX6F4xxvtk/erE
         f4DBV65+Fkp4QrJ0JUmO37A9Kz8qhK8kjtJcBN8JvpT7gso/UWTMqr9FWwvezaItyoGU
         DfcLoShIRQLjGZ4f03lCHBuz4wK9ua2ZqwjIRgzyHX7SYW01sCdT1tLVwDkruVSB++l8
         idqQ==
X-Gm-Message-State: AOAM531htwLmfvjrdOApCDF2sxlAIn/XBlgbtQ1IHxmjUpmUmDsGG/Kw
        3na9jSK/ZgHcR5sUU15X/pCkvvwoSotZA9MV9wk=
X-Google-Smtp-Source: ABdhPJwMjYbEt7KjKEeumohPt6RSMyYXEy9cN+G0F6n4UdhM7U/JvRhLqqCUs8k5yi2H/UjmRx5fzZNCbxx0LYXcQ0c=
X-Received: by 2002:a17:90a:8594:: with SMTP id m20mr1463419pjn.215.1613437451194;
 Mon, 15 Feb 2021 17:04:11 -0800 (PST)
MIME-Version: 1.0
References: <20210213214421.226357-1-xiyou.wangcong@gmail.com>
 <20210213214421.226357-5-xiyou.wangcong@gmail.com> <602ac96f9e30f_3ed41208b6@john-XPS-13-9370.notmuch>
 <CAM_iQpWufy-YnQnBf_kk_otLaTikK8YxkhgjHh_eiu8MA=0Raw@mail.gmail.com>
 <602b0a7046969_3ed41208dc@john-XPS-13-9370.notmuch> <CAM_iQpUomzGXdyjdCU8Ox-JZgQc=iZPZqs1UjRo3wxomf67_+A@mail.gmail.com>
 <602b17b0492a8_3ed41208f2@john-XPS-13-9370.notmuch>
In-Reply-To: <602b17b0492a8_3ed41208f2@john-XPS-13-9370.notmuch>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 15 Feb 2021 17:04:00 -0800
Message-ID: <CAM_iQpWzRpfWwZHPK=+KWbu+nLxJ=GKRHNC+97NT2DoN0qRc2A@mail.gmail.com>
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

On Mon, Feb 15, 2021 at 4:54 PM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Cong Wang wrote:
> > On Mon, Feb 15, 2021 at 3:57 PM John Fastabend <john.fastabend@gmail.com> wrote:
> > >
> > > For TCP case we can continue to use CB and not pay the price. For UDP
> > > and AF_UNIX we can do the extra alloc.
> >
> > I see your point, but specializing TCP case does not give much benefit
> > here, the skmsg code would have to check skb->protocol etc. to decide
> > whether to use TCP_SKB_CB() or skb_ext:
> >
> > if (skb->protocol == ...)
> >   TCP_SKB_CB(skb) = ...;
> > else
> >   ext = skb_ext_find(skb);
> >
> > which looks ugly to me. And I doubt skb->protocol alone is sufficient to
> > distinguish TCP, so we may end up having more checks above.
> >
> > So do you really want to trade code readability with an extra alloc?
>
> Above is ugly. So I look at where the patch replaces things,
>
> sk_psock_tls_strp_read(), this is TLS specific read hook so can't really
> work in generic case anyways.
>
> sk_psock_strp_read(), will you have UDP, AF_UNIX stream parsers? Do these
> even work outside TCP cases.
>
> For these ones: sk_psock_verdict_apply(), sk_psock_verdict_recv(),
> sk_psock_backlog(), can't we just do some refactoring around their
> hook points so we know the context. For example sk_psock_tls_verdict_apply
> is calling sk_psock_skb_redirect(). Why not have a sk_psock_unix_redirect()
> and a sk_psock_udp_redirect(). There are likely some optimizations we can
> deploy this way. We've already don this for tls and sk_msg types for example.
>
> Then the helpers will know their types by program type, just use the right
> variants.
>
> So not suggestiong if/else the checks so much as having per type hooks.
>

Hmm, but sk_psock_backlog() is still the only one that handles all three
above cases, right? It uses TCP_SKB_CB() too and more importantly it
is also why we can't use a per-cpu struct here (see bpf_redirect_info).

Thanks.
