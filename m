Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 023EB1BFE77
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 16:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbgD3Ohf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 10:37:35 -0400
Received: from mout.kundenserver.de ([212.227.126.134]:58637 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726684AbgD3Ohe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 10:37:34 -0400
Received: from mail-lj1-f181.google.com ([209.85.208.181]) by
 mrelayeu.kundenserver.de (mreue009 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1MIdW9-1jR82b0yLl-00EeNQ; Thu, 30 Apr 2020 16:37:32 +0200
Received: by mail-lj1-f181.google.com with SMTP id a21so6730895ljb.9;
        Thu, 30 Apr 2020 07:37:32 -0700 (PDT)
X-Gm-Message-State: AGi0PuYVvNVD8LV5PFwVzTONFmFqc//D+YDUDLdl+S9QWhsRflIH1pIn
        OMzUVei/m8W4oTN1kiWvgh9SNt9LQmGQj2xNE5w=
X-Google-Smtp-Source: APiQypKy09PyZ77uDaKFQBZDXtEJTxnP/Uxzu/oGwEvoJF58LAwmPUjJ46HDG+QBqJFw4DyG+mO8+PH9i4BCelnxYMs=
X-Received: by 2002:a2e:8999:: with SMTP id c25mr2478620lji.73.1588257451645;
 Thu, 30 Apr 2020 07:37:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200428212357.2708786-1-arnd@arndb.de> <20200430052157.GD432386@unreal>
In-Reply-To: <20200430052157.GD432386@unreal>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 30 Apr 2020 16:37:14 +0200
X-Gmail-Original-Message-ID: <CAK8P3a25MeyBgwZ9ZF2JbfpVChQuZ1wWc6VT1MFZ8-7haubVDw@mail.gmail.com>
Message-ID: <CAK8P3a25MeyBgwZ9ZF2JbfpVChQuZ1wWc6VT1MFZ8-7haubVDw@mail.gmail.com>
Subject: Re: [PATCH] net/mlx5: reduce stack usage in qp_read_field
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Moshe Shemesh <moshe@mellanox.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Networking <netdev@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:xOfNUyzSsonNWZrgxw2ZjAzaywN26VV5YITBAqO/SEzxptoc19J
 GDwPDqXISPWejg2N1f41nO/+NoHYrfbIfiyt3v+An3SjNKu8+GPlFesIo5AVyWNeCkoWLXH
 t/6IYeX28aInOfD9D2yAJOjGLmr6/KyfW1owlIpoS35HJ6TYO50X5FyPQDYFGWHoZdPPnxe
 LPqek/vnMZymJtaTydQxw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:bupaEUd07sg=:mLlPlQmtDA1UEP9GIqDo+D
 m+m9HDKSft6fPnYPjsu4r1Gq8+Zs/vyxShg9EgSDeuuuKj5s2Nmd6aE03nFzITkLRRlZVyWDJ
 RQvu9NWySuas2jQNGAgOFXxSIY5UsdRqGy/pHC12Ev9zz2Z7ZOXjGVzrjlxWxFxLGNrenVusZ
 z5dgMYm8OuqlCpvgcvSZS4K2bBYia5fYkwuXpf881x29qJp9NXLMPKWRywD8JU07PpD2/KHoG
 47jCULAeBaXq2M0Bc7ZGcdZfqL/cG/ZDw0U5x85ioxR1yeSS3PuNejN68dy9xXMex5w1UUY7Q
 O14yC9UQWDvwcRaj9Clj/C8vRbN3SIQYA/0nj3A8DG4uXnstuqOWcXK3aEIdNxhbPmUiS6RKB
 koPRx8upQSUcUO0TrjYdbJ/IjCeC1pj4JMst790+hpKxu7yTLh3mP5HhZeUJdfmHlZMdBpfMT
 d/ipulafFmxtrb3oH/6ylJYNh54TC1cBqnOuV0NsR07f/im1PHC2CIQfXFzaXkdYU/ryOd5eb
 NeN43GscgSJ48wRAkvjkTlyX0/MJcmzz5FG/fT9Iv5nDW67lvgpyn1Vby6QzPO1DyH5fDDmLb
 BH9lBqucIdVh7Q2Bqgra4qYQGrLXMOiwvpOV6ur9KKpVINlkYP2Ha/8FnfIzsK12oPdtdtzHa
 lqrJ4rBfuam3ZtoAEval+gCR0/ERVzln62azBxOx2pi47pUIH/qxZMBD5Gr/RLLkwGOyD7cvB
 xubwL8afsVhMAnlOrssBhi/Vvu1ii9fFoAsuZLyAgA8rKDhqDaxHFCtG8rHnRxhFjwYqhDijX
 8OOTmJwsA3T1Md2Oj6D8a+rZE8NjV/na/haiWkgQkKw+ezEmDA=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 30, 2020 at 7:22 AM Leon Romanovsky <leon@kernel.org> wrote:
> On Tue, Apr 28, 2020 at 11:23:47PM +0200, Arnd Bergmann wrote:
> > Moving the mlx5_ifc_query_qp_out_bits structure on the stack was a bit
> > excessive and now causes the compiler to complain on 32-bit architectures:
> >
> > drivers/net/ethernet/mellanox/mlx5/core/debugfs.c: In function 'qp_read_field':
> > drivers/net/ethernet/mellanox/mlx5/core/debugfs.c:274:1: error: the frame size of 1104 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]
> >
> > Revert the previous patch partially to use dynamically allocation as
> > the code did before. Unfortunately there is no good error handling
> > in case the allocation fails.
> >
> > Fixes: 57a6c5e992f5 ("net/mlx5: Replace hand written QP context struct with automatic getters")
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> >  drivers/net/ethernet/mellanox/mlx5/core/debugfs.c | 12 +++++++++---
> >  1 file changed, 9 insertions(+), 3 deletions(-)
>
> Thanks Arnd, I'll pick it to mlx5-next.
>
> I was under impression that the frame size was increased a long
> time ago. Is this 1K limit still effective for all archs?
> Or is it is 32-bit leftover?

I got the output on a 32-bit build, but that doesn't make the code
right on 64-bit.

While warning limit is generally 1024 bytes for 32-bit architectures,
and 2048 bytes fro 64-bit architectures,  we should probably
reduce the latter to something like 1280 bytes and fix up the
warnings that introduces.

Generally speaking, I'd say a function using more than a few hundred
bytes tends to be a bad idea, but we can't warn about those without
also warning about the handful of cases that do it for a good reason
and using close to 1024 bytes on 32 bit systems or a little more on
64-bit systems, in places that are known not to have deep call chains.

       Arnd
