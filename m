Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A81562C24A2
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 12:39:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732880AbgKXLgv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 06:36:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731640AbgKXLgv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 06:36:51 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 161D5C0613D6;
        Tue, 24 Nov 2020 03:36:51 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id b63so18209478pfg.12;
        Tue, 24 Nov 2020 03:36:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BxmO4/Fh9U9UfKFcny2xWXoX/3HscybzrQ/hZv32x4c=;
        b=DjCGIJKuqQNI3tXEw/W+jIcQcI5P9WPzbPvZcB8SNNOOGJVqDZemCmbfCWRtyRiF92
         BCB+SAi8MK/gD4m3z43vuzGr5IEIlqGHABpzjjAnDIdzR+2ZDEjbatieGGv6ZWUyb9w2
         ZmEBsE3dbqhkIzdQrEy6bL/KXxHCdtIjCRr7cPNbiuZG0PJ8EdQTV3eCkQbI9oLBwkLv
         1tCtOasFrhzpmfSjVd0V2iDnYR44Erae+Y4xcWHg7h/38ZcFLrwlwWsgXd4oIY5JKeZm
         ZIi2UqIf9qvUuDSjSocyqou2+9nzoU+fqnYjAIckEwT58xYhqkKsSeQLw62Tw0EMsBBi
         zpEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BxmO4/Fh9U9UfKFcny2xWXoX/3HscybzrQ/hZv32x4c=;
        b=gcOCIYIBklwDZCHieSK8NuT+UCEpxayfnJViMVddGQB3qXYg9XeLNSO856MWfSLeYo
         ty/78PQZcmpWaUjt6Fqu7PG9+A7l1/B/dmvaUCJO2TRBHjZE30UCyabCiwSYRYUZzg2f
         HSdiCJq+63o1m4qiOZzfLP54CmOKJwHagAGAEMJa8uwFvvl70HAyKpwCyQ/XK7oyGMQ2
         27uEvT01SkqHOnXfpeDxbF+b2sZgZTBVfhuukqIh0kdGypFvpOY0OFTYUKiR8VMf9g9e
         j2TXAobYfmHabrpM6EyVemSYfW3vSYNajwkrouBFFKF4Su5iEXVuN5ztYf9fHyK5rlyy
         ZRVg==
X-Gm-Message-State: AOAM5319i9RN76cqjhXPsySq3Glv0TwHvxYrBGqAOZ6lPtJ4YhKLiUuN
        R9ScgCrRPh2Ek874a4ok1yJ2C7dZSWSejQW8uEw=
X-Google-Smtp-Source: ABdhPJx9EBbvQeVdCe952FLZ0pM49E46cC8dD+CrqW+vm+1pPXNhJuUuwyr5buuS+Z620D9aaZIiiRGOVdaLae8kmJA=
X-Received: by 2002:a17:90a:fb4e:: with SMTP id iq14mr4590421pjb.117.1606217810698;
 Tue, 24 Nov 2020 03:36:50 -0800 (PST)
MIME-Version: 1.0
References: <3306b4d8-8689-b0e7-3f6d-c3ad873b7093@intel.com>
 <cover.1605686678.git.xuanzhuo@linux.alibaba.com> <dfa43bcf7083edd0823e276c0cf8e21f3a226da6.1605686678.git.xuanzhuo@linux.alibaba.com>
 <CAJ8uoz3PtqzbfCD6bv1LQOtPVH3qf4mc=V=u_emTxtq3yYUeYw@mail.gmail.com>
In-Reply-To: <CAJ8uoz3PtqzbfCD6bv1LQOtPVH3qf4mc=V=u_emTxtq3yYUeYw@mail.gmail.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Tue, 24 Nov 2020 12:36:39 +0100
Message-ID: <CAJ8uoz1S1brwy+2u48Y9jn3ys6QEHQjtw3OQDj3wrgxCf7Or3w@mail.gmail.com>
Subject: Re: [PATCH 1/3] xsk: replace datagram_poll by sock_poll_wait
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 23, 2020 at 3:11 PM Magnus Karlsson
<magnus.karlsson@gmail.com> wrote:
>
> On Wed, Nov 18, 2020 at 9:26 AM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
> >
> > datagram_poll will judge the current socket status (EPOLLIN, EPOLLOUT)
> > based on the traditional socket information (eg: sk_wmem_alloc), but
> > this does not apply to xsk. So this patch uses sock_poll_wait instead of
> > datagram_poll, and the mask is calculated by xsk_poll.
> >
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > ---
> >  net/xdp/xsk.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> > index cfbec39..7f0353e 100644
> > --- a/net/xdp/xsk.c
> > +++ b/net/xdp/xsk.c
> > @@ -477,11 +477,13 @@ static int xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
> >  static __poll_t xsk_poll(struct file *file, struct socket *sock,
> >                              struct poll_table_struct *wait)
> >  {
> > -       __poll_t mask = datagram_poll(file, sock, wait);
> > +       __poll_t mask = 0;
>
> It would indeed be nice to not execute a number of tests in
> datagram_poll that will never be triggered. It will speed up things
> for sure. But we need to make sure that removing those flags that
> datagram_poll sets do not have any bad effects in the code above this.
> But let us tentatively keep this patch for the next version of the
> patch set. Just need to figure out how to solve your problem in a nice
> way first. See discussion in patch 0/3.
>
> >         struct sock *sk = sock->sk;
> >         struct xdp_sock *xs = xdp_sk(sk);
> >         struct xsk_buff_pool *pool;
> >
> > +       sock_poll_wait(file, sock, wait);
> > +
> >         if (unlikely(!xsk_is_bound(xs)))
> >                 return mask;
> >
> > --
> > 1.8.3.1
> >

The fix looks correct and it will speed things up too as a bonus.
Please include this patch in the v2 as outlined in my answer to 0/3.

Thanks!
