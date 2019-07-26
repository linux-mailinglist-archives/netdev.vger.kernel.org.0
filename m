Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 077537658B
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 14:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbfGZMTY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 08:19:24 -0400
Received: from mail-yb1-f194.google.com ([209.85.219.194]:39343 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbfGZMTY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 08:19:24 -0400
Received: by mail-yb1-f194.google.com with SMTP id z128so16122128yba.6
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 05:19:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J10Ar0jlilWCu0Zj032Q905iz4MewQZdqDXvEwoLJVU=;
        b=h8C+qwtM5ouOpuLNNIMve0bM7v5PyeUaOjzCBVlGPldCsUOirim2w8q2yhOmAaRqXe
         tA5LRaIZhUWjCj2cu+ALhPbK1jYsTOXf//C16y8P6j/BjfcYcEaOOE/yK+WYe+EF5AtF
         jL/aBRf8dHEC7HazrGdCYTSvFqrdE/8bC6HBbKNKsfUwt/mTF8T0nFo8wtNgwMHmP3Gp
         bAMOUju9OlIZj2AF16skhilCPHIdakPCjeAg1p2C27cLgziSidUHn33zceDc4TXi0tSE
         IZQyPOddCqmQSYNE7cXUR3ldFray8A7Io1uEULJWtNRgOeV+xO3Oc31ipgMAeSWXuR2H
         yoJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J10Ar0jlilWCu0Zj032Q905iz4MewQZdqDXvEwoLJVU=;
        b=q/IKRoK3D3+Bg77wrIEde7ZoqEEoPBrQXLu+li+BtGR21cVKtgGBAfz7DTR/+1zSkZ
         B/kFpy2p12k2NDuTBoq4YFfhgswb4N406Qvqa8WXdtfZ1k3ciL94yJx1w088T/QuwhUI
         nh++24iYLP3rxZY0Z1G17LhNuTKG54eRqul6XF3CDpZ9cZwNvgeTr2FYdeENeDu2Nfp3
         TLh60Ejc2yzInltzueenvNvVHhtydpSrVKt+I5IPgjIMJAeOIsOzF/JecWZafVi9bUIe
         MenM9SBcXdB98e2FfSRSeFMRb9S1HO/HlucjKJRvhJWUjI7HnpRbdADgfopR3bTAxQAL
         jgpw==
X-Gm-Message-State: APjAAAWjciNDOpMDiTIu7sLIRVEgWqxdgB/PaZDT1v8EMyrETtyofGMb
        /imDisMGfWCQNZhyxpb78tpOmFmrGdZ2UtNnkBv3CQ==
X-Google-Smtp-Source: APXvYqxHdW7yB3fuvKSA6aoNvuKdvqWzHQbTwm85mcT5ZR6RpLF188rS5Tnovnz/Ed+ivViXTuHLBj+wAioADERMD/0=
X-Received: by 2002:a25:5c4:: with SMTP id 187mr61277216ybf.11.1564143563240;
 Fri, 26 Jul 2019 05:19:23 -0700 (PDT)
MIME-Version: 1.0
References: <1564053847-28756-1-git-send-email-wenxu@ucloud.cn> <7b03d1fdda172ce99c3693d8403cbdaf5a31bb6c.camel@mellanox.com>
In-Reply-To: <7b03d1fdda172ce99c3693d8403cbdaf5a31bb6c.camel@mellanox.com>
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Fri, 26 Jul 2019 15:19:11 +0300
Message-ID: <CAJ3xEMi65JcF97nHeE482xgkps0GLLso+b6hp=34uX+wF=BjiQ@mail.gmail.com>
Subject: Re: [PATCH] net/mlx5e: Fix zero table prio set by user.
To:     Saeed Mahameed <saeedm@mellanox.com>,
        "wenxu@ucloud.cn" <wenxu@ucloud.cn>
Cc:     Roi Dayan <roid@mellanox.com>, Mark Bloch <markb@mellanox.com>,
        Paul Blakey <paulb@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 26, 2019 at 12:24 AM Saeed Mahameed <saeedm@mellanox.com> wrote:
>
> On Thu, 2019-07-25 at 19:24 +0800, wenxu@ucloud.cn wrote:
> > From: wenxu <wenxu@ucloud.cn>
> >
> > The flow_cls_common_offload prio is zero
> >
> > It leads the invalid table prio in hw.
> >
> > Error: Could not process rule: Invalid argument
> >
> > kernel log:
> > mlx5_core 0000:81:00.0: E-Switch: Failed to create FDB Table err -22
> > (table prio: 65535, level: 0, size: 4194304)
> >
> > table_prio = (chain * FDB_MAX_PRIO) + prio - 1;
> > should check (chain * FDB_MAX_PRIO) + prio is not 0
> >
> > Signed-off-by: wenxu <wenxu@ucloud.cn>
> > ---
> >  drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git
> > a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> > b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> > index 089ae4d..64ca90f 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> > @@ -970,7 +970,9 @@ static int esw_add_fdb_miss_rule(struct
>
> this piece of code isn't in this function, weird how it got to the
> diff, patch applies correctly though !
>
> > mlx5_eswitch *esw)
> >               flags |= (MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT |
> >                         MLX5_FLOW_TABLE_TUNNEL_EN_DECAP);
> >
> > -     table_prio = (chain * FDB_MAX_PRIO) + prio - 1;
> > +     table_prio = (chain * FDB_MAX_PRIO) + prio;
> > +     if (table_prio)
> > +             table_prio = table_prio - 1;
> >
>
> This is black magic, even before this fix.
> this -1 seems to be needed in order to call
> create_next_size_table(table_prio) with the previous "table prio" ?
> (table_prio - 1)  ?
>
> The whole thing looks wrong to me since when prio is 0 and chain is 0,
> there is not such thing table_prio - 1.
>
> mlnx eswitch guys in the cc, please advise.

basically, prio 0 is not something we ever get in the driver, since if
user space
specifies 0, the kernel generates some random non-zero prio, and we support
only prios 1-16 -- Wenxu -- what do you run to get this error?



>
> Thanks,
> Saeed.
>
> >       /* create earlier levels for correct fs_core lookup when
> >        * connecting tables
