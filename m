Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA432C0CFE
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 15:15:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387906AbgKWOL5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 09:11:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730039AbgKWOL4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 09:11:56 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4234C0613CF;
        Mon, 23 Nov 2020 06:11:56 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id l1so655026pld.5;
        Mon, 23 Nov 2020 06:11:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NU+ZBtS2PuAoVDCaiYjSDmtYV+rq9r8k1b0Hv3NXBJs=;
        b=LvN2cgYCtq6+Y48nqWXGL7phbvUQEqHQKhNBlq0qiVygA2NutirJ3tuFZs9eQKKAUN
         QA/PGelSg8ywUnfxQWvfpLiMjDGk9FJb1e5nsE+w5tybK7W++5HP7UUQ67hi3u8NjIC4
         hGJpPZmu5LJYV7nnpOA28h+SQ20FUi1pAPDrn90gu3QbsDfGvlYVsdH2BebL9hX2d/mp
         i76p6nIV2OA/PIiKLJXcEYQmP4o8iIFqK/kWYHPaVtIQexQ+RgzAGsX6rder3PwzcyYQ
         rwTMAuoW1a1Fv9Mxtv0jQlsvvHYgSykCQPa+7/tL2yBWyUsrh9pcwLeLlqeEzc8qOJW8
         PD0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NU+ZBtS2PuAoVDCaiYjSDmtYV+rq9r8k1b0Hv3NXBJs=;
        b=IJXfbTNvDgcPjLQr2rY9I4fBKFhWtKlv5S/TJEAZkFq7ZPpuVaGJTz5SbB3s8nK5bs
         Z0caerUXBIRlxMEyAazsgCKWneiA0xcsPGl+JtXawOkx6YoAwHJdhgcozkOuWwO+u2oO
         9vEMyPqdUnuLYqpftflM9z11UtmogohsGGDPZ/RKM9i3DlRm9wLY7pXCvnZxF7WGxsNI
         fg6Ge9B0wGvlor9QsmwfesMfCT15SWYp1jZ4lRVBWrOgnugjPTgVc2EdWa3407l0R0oD
         5JQDssC4SvGKLWDjIJ/7wiUhOVkR2jrnmi69//PbzfKaNDVVaIjICCrQ5ZugcybDD1gA
         9kTw==
X-Gm-Message-State: AOAM5323fHx7dE7g2vwmIMyFDncweF6GZAORdiiTAbqdZc6jo1DQopGz
        wkCQ7DU7wdIW/gSzAq16IgiwVwzsfNqeRbfmUPw=
X-Google-Smtp-Source: ABdhPJyVSvyUYOybbEj86aanBvHbx+TOibpG5xGwRLKUnt31gEUAvpWn4MdO+M5sabxVJ2pu3VS1GdZefmg187NK2Q0=
X-Received: by 2002:a17:902:be07:b029:da:c5e:81b6 with SMTP id
 r7-20020a170902be07b02900da0c5e81b6mr3997870pls.43.1606140716201; Mon, 23 Nov
 2020 06:11:56 -0800 (PST)
MIME-Version: 1.0
References: <3306b4d8-8689-b0e7-3f6d-c3ad873b7093@intel.com>
 <cover.1605686678.git.xuanzhuo@linux.alibaba.com> <dfa43bcf7083edd0823e276c0cf8e21f3a226da6.1605686678.git.xuanzhuo@linux.alibaba.com>
In-Reply-To: <dfa43bcf7083edd0823e276c0cf8e21f3a226da6.1605686678.git.xuanzhuo@linux.alibaba.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 23 Nov 2020 15:11:45 +0100
Message-ID: <CAJ8uoz3PtqzbfCD6bv1LQOtPVH3qf4mc=V=u_emTxtq3yYUeYw@mail.gmail.com>
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

On Wed, Nov 18, 2020 at 9:26 AM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
>
> datagram_poll will judge the current socket status (EPOLLIN, EPOLLOUT)
> based on the traditional socket information (eg: sk_wmem_alloc), but
> this does not apply to xsk. So this patch uses sock_poll_wait instead of
> datagram_poll, and the mask is calculated by xsk_poll.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>  net/xdp/xsk.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index cfbec39..7f0353e 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -477,11 +477,13 @@ static int xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
>  static __poll_t xsk_poll(struct file *file, struct socket *sock,
>                              struct poll_table_struct *wait)
>  {
> -       __poll_t mask = datagram_poll(file, sock, wait);
> +       __poll_t mask = 0;

It would indeed be nice to not execute a number of tests in
datagram_poll that will never be triggered. It will speed up things
for sure. But we need to make sure that removing those flags that
datagram_poll sets do not have any bad effects in the code above this.
But let us tentatively keep this patch for the next version of the
patch set. Just need to figure out how to solve your problem in a nice
way first. See discussion in patch 0/3.

>         struct sock *sk = sock->sk;
>         struct xdp_sock *xs = xdp_sk(sk);
>         struct xsk_buff_pool *pool;
>
> +       sock_poll_wait(file, sock, wait);
> +
>         if (unlikely(!xsk_is_bound(xs)))
>                 return mask;
>
> --
> 1.8.3.1
>
