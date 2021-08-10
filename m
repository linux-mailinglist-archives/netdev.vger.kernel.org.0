Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B01983E5BD8
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 15:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241597AbhHJNiI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 09:38:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241563AbhHJNiD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 09:38:03 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EBFBC0613D3
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 06:37:41 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id x7so15373879ilh.10
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 06:37:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=csVOACPDP1qngSSliCngUR28zuz3Rq1l/jFifM6PtPQ=;
        b=EhpG0sOIYIWFhM988LReWhSQhb7bUwOYYlzL8o7Mdvyp8kYIHZQwBRqSi6h6OlsLlR
         GH2vIj15e0Ulp4TesTUrRlStpA5gdFGXMN+GbHT5rRVY3S2Yi5aUIgDC4fLjS8LlGYeK
         3AwGJ+eLgC3SVyA2xUHxoHVIdPUM92/ocAtlc8XVJQLZXhXxsnSwEKAbK1BnQZ7sn7ar
         uNz0OFJKRJ4J30agewhvzs1z4n9QqySI31Yogxdmxu1+eN+NOpHmwIMdZURR3s2xvxto
         ufpXRFJ0jgXAmhvvKmNgglC8xX6YREpuhIZBq6fZHZaHM5pGefixWRhBnsVVmMItU/QK
         mGRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=csVOACPDP1qngSSliCngUR28zuz3Rq1l/jFifM6PtPQ=;
        b=BKl+NT3XwhvrfwyEDXSiBpRsqZ/19/McR7AL7KbI+lOM6ThnN9cRQg7HK7Y7IAAVK/
         bTJbkv8Yd2L+CxHz+N1LhHCoH/WBYjJYl+Jb8Tw+zcAxwGwc5RpCih1VuXeFwlF3/o2g
         BhGTXY7RelrpYzCxMmvjjTjjFzOTaNw6ZkG6/U20m97QG2OJyDDkBmQs0H8MtYjqP75g
         Bl+AguNnZahHkqaK/E5DGZnGp3mfH0OKWs0cd8D7mNwCfhoC5cUeQsxlGHDhWLayBWXe
         JNh+7ydaVxn6EMwBo6TPHoEe8gEEcFt/m9+esGInRZKieNNJzLMxeN9gx4Q/+AuE9rIG
         HbXw==
X-Gm-Message-State: AOAM5307KGGDwZ77Qj8UMVwRPuGv5QCYFBQtWuvGmyaMgEQ4wrULth97
        89QuCth+1lCRX1IODEtjC+OYNDmbMhls4ktu7wc=
X-Google-Smtp-Source: ABdhPJy7Z7khDppO8U5qMy4HqGlCkNlq4zE7AxkKB0pxCO2cWIaPtpMskTv3U1cGMcHq8nCKRtMZjvSq7wQolcVEE3s=
X-Received: by 2002:a05:6e02:1bcb:: with SMTP id x11mr763516ilv.168.1628602661048;
 Tue, 10 Aug 2021 06:37:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210722110325.371-1-borisp@nvidia.com> <20210723055626.GA32126@lst.de>
 <02c4e0af-0ae9-f4d9-d2ad-65802bdf036a@grimberg.me> <CAJ3xEMjzRqrj-EN7gbqKmD5txAV-gZn828V+6QAf5wfwYsqySQ@mail.gmail.com>
 <1d461a0d-cda5-2086-ec17-c5bb3a80846f@grimberg.me>
In-Reply-To: <1d461a0d-cda5-2086-ec17-c5bb3a80846f@grimberg.me>
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Tue, 10 Aug 2021 16:37:29 +0300
Message-ID: <CAJ3xEMj=nLp4-GUSMYH0tgK69bfhuUYDjtE8fHFy=n2x2-cL_Q@mail.gmail.com>
Subject: Re: [PATCH v5 net-next 00/36] nvme-tcp receive and tarnsmit offloads
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     Christoph Hellwig <hch@lst.de>, Boris Pismenny <borisp@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Saeed Mahameed <saeedm@nvidia.com>, axboe@fb.com,
        Keith Busch <kbusch@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Shai Malin <smalin@marvell.com>, boris.pismenny@gmail.com,
        linux-nvme@lists.infradead.org,
        Linux Netdev List <netdev@vger.kernel.org>,
        benishay@nvidia.com, Or Gerlitz <ogerlitz@nvidia.com>,
        Yoray Zack <yorayz@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 6, 2021 at 10:46 PM Sagi Grimberg <sagi@grimberg.me> wrote:
> On 8/4/21 6:51 AM, Or Gerlitz wrote:
> > On Fri, Jul 23, 2021 at 10:59 PM Sagi Grimberg <sagi@grimberg.me> wrote:

> >> [.. ] It is difficult to review.
> >> The order should be:
> >> 1. ulp_ddp interface
> >> 2. nvme-tcp changes
> >> 3. mlx5e changes
> >
> > .. and this is exactly how the series is organized, for v6 we will drop the
> > TX offload part and stick to completing the review on the RX offload part.
> >
> >> Also even beyond grouping patches together I have 2 requests:
> >> 1. Please consolidate ddp routines under a single ifdef (also minimize
> >> the ifdef in call-sites).
> >
> > ok, will make an effort to be better in that respect
> >
> >> 2. When consolidating functions, try to do this as prep patches
> >> documenting in the change log that it is preparing to add ddp. Its
> >> difficult digesting both at times.
> >
> > to clarify, you would like patch #5 "nvme-tcp: Add DDP offload control path"
> > to only add the call sites and if-not-deffed implementation for the added knobs:
> >
> > nvme_tcp_offload_socket
> > nvme_tcp_unoffload_socket
> > nvme_tcp_offload_limits
> > nvme_tcp_resync_response
> >
> > and a 2nd patch to add the if-yes-deffed implementation?
> >
> > This makes sense, however IMHO repeating this prep exercise for
> > the data-path patch (#6 "nvme-tcp: Add DDP data-path") doesn't
> > seem to provide notable value  b/c you will only see two call sites
> > for the two added empty knobs:
> >
> > nvme_tcp_setup_ddp
> > nvme_tcp_teardown_ddp
> >
> > but whatever you prefer, so.. let us know

> I was more referring to routines that now grew the ddp path
> and changed in the same time like:

> nvme_tcp_complete_request

not sure to follow on this one.. It's added on patch #6 "nvme-tcp: Add
DDP data-path"
and then used twice in the same patch replacing calls to nvme_try_complete_req
and then to nvme_complete_rq -- so how want this  be broken to prep/usage?

> nvme_tcp_consume_skb

this routine was born due to the ddp_ prefix addition to the iov copy
iter functions, which we are now removing due to feedback from Al

> etc..
