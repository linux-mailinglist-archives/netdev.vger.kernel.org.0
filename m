Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C1205204CC
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 20:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240325AbiEIS6s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 14:58:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240293AbiEIS6q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 14:58:46 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E81AC268EBB
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 11:54:50 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id r11so26627443ybg.6
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 11:54:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X0sMQBHSskuqvgCxyDD6vukBrJmCjilH3IG/hxMADfM=;
        b=Bm5VseLdSz6vj3QRWYpfiFZmzmsz2CsNxphcSGTb/eCr9G+EKVL2D9mENtDeKgr/0d
         X1/4NjBFAgYZy22Il6rMgvl/XqVaaiVFTV1Ym+ch2gq+WVBAh0PPU3t0rnxPqhZqU80v
         zYFbR4TXbs23V3VnANy/e5wdX/RkTK8UVVbBZ+C06i8H/is8wGBQiV/xkyPccoOQCLY3
         su21qKo4upCcjCOePHQX5iinnwWWi2lpV9QNHfD+vEksWj9KN13i8rWwJsgNZZ+J28Yj
         F63SkWgUtRFJbuGvJmwRhhAXCcS27sh5CjDig7XJxO9+q0e4EmFu6bmStVgO3HxH3j4V
         Xubg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X0sMQBHSskuqvgCxyDD6vukBrJmCjilH3IG/hxMADfM=;
        b=UQ6mjC8zy4E7giYaBLBI7W5KwRqNQnjN7XRrSEvpm/QfyuJ2JBj3Du+A0m2SNctvuL
         UdJXc4dxfKt/VpF4P/0TtF+AxeB/H40JhEkbScqCwlVh8t0tSIWZgSK6rc1wjFYvQvSm
         pqSOxrVyiW8tLLA9uRnhkqtFeA3q1D5K6z1MmHGZ0zX4qcIkqsvhp/MugME93VMEJjkp
         7b8u8pWSJAqZEJroGhfInajYcbRXpGhslRtQTOuSLnZGrebQa2xMpopetTWg82uNNwQl
         PbPWCFSKRJztBUD1Y9aY9sBI9WPk2HkUSjdOBaLfQkDmNVmaF70nheJRbQwQv1ag8cgB
         Kn4w==
X-Gm-Message-State: AOAM531eAmsMdlsAxnIT9k/XuAZhILH+Y+VlBLptSTCcrtWdrN8nwBbd
        0HqQa1CTYHUbYgKugX/7+H7icOc1ZV9ehkR9UFdFww==
X-Google-Smtp-Source: ABdhPJxO45XpznWObp8568DYxoFQxpd6PuhnF2420TobSEsPrXyp8atBy/McQschPjzw25uC2fdXNi1Scss9qD0lQPI=
X-Received: by 2002:a25:8b88:0:b0:64b:8a2:aae4 with SMTP id
 j8-20020a258b88000000b0064b08a2aae4mr117172ybl.231.1652122489726; Mon, 09 May
 2022 11:54:49 -0700 (PDT)
MIME-Version: 1.0
References: <CANn89iJW9GCUWBRtutv1=KHYn0Gpj8ue6bGWMO9LLGXqvgWhmQ@mail.gmail.com>
 <165212006050.5729.9059171256935942562.stgit@localhost.localdomain>
In-Reply-To: <165212006050.5729.9059171256935942562.stgit@localhost.localdomain>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 9 May 2022 11:54:38 -0700
Message-ID: <CANn89iL+r=dgW4ndjBBR=E0KQ0rBVshWMQOVmco0cZDbNXymrw@mail.gmail.com>
Subject: Re: [PATCH 0/2] Replacements for patches 2 and 7 in Big TCP series
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Coco Li <lixiaoyan@google.com>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-15.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 9, 2022 at 11:17 AM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> This patch set is meant to replace patches 2 and 7 in the Big TCP series.
> From what I can tell it looks like they can just be dropped from the series
> and these two patches could be added to the end of the set.
>
> With these patches I have verified that both the loopback and mlx5 drivers
> are able to send and receive IPv6 jumbogram frames when configured with a
> g[sr]o_max_size value larger than 64K.
>
> Note I had to make one minor change to iproute2 to allow submitting a value
> larger than 64K in that I removed a check that was limiting gso_max_size to
> no more than 65536. In the future an alternative might be to fetch the
> IFLA_TSO_MAX_SIZE attribute if it exists and use that, and if not then use
> 65536 as the limit.

OK, thanks.

My remarks are :

1) Adding these enablers at the end of the series will not be
bisection friendly.

2) Lots more changes, and more backport conflicts for us.

I do not care really, it seems you absolutely hate the new attributes,
I can live with that,
but honestly this makes the BIG TCP patch series quite invasive.


>
> ---
>
> Alexander Duyck (2):
>       net: Allow gso_max_size to exceed 65536
>       net: Allow gro_max_size to exceed 65536
>
>
>  drivers/net/ethernet/amd/xgbe/xgbe.h            |  3 ++-
>  drivers/net/ethernet/mellanox/mlx5/core/en_rx.c |  2 +-
>  drivers/net/ethernet/sfc/ef100_nic.c            |  3 ++-
>  drivers/net/ethernet/sfc/falcon/tx.c            |  3 ++-
>  drivers/net/ethernet/sfc/tx_common.c            |  3 ++-
>  drivers/net/ethernet/synopsys/dwc-xlgmac.h      |  3 ++-
>  drivers/net/hyperv/rndis_filter.c               |  2 +-
>  drivers/scsi/fcoe/fcoe.c                        |  2 +-
>  include/linux/netdevice.h                       |  6 ++++--
>  include/net/ipv6.h                              |  2 +-
>  net/bpf/test_run.c                              |  2 +-
>  net/core/dev.c                                  |  7 ++++---
>  net/core/gro.c                                  |  8 ++++++++
>  net/core/rtnetlink.c                            | 10 +---------
>  net/core/sock.c                                 |  4 ++++
>  net/ipv4/tcp_bbr.c                              |  2 +-
>  net/ipv4/tcp_output.c                           |  2 +-
>  net/sctp/output.c                               |  3 ++-
>  18 files changed, 40 insertions(+), 27 deletions(-)
>
> --
>
