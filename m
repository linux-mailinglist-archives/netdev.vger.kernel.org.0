Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA384260E49
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 11:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728804AbgIHJFD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 05:05:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728739AbgIHJFC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 05:05:02 -0400
Received: from mail-vk1-xa41.google.com (mail-vk1-xa41.google.com [IPv6:2607:f8b0:4864:20::a41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33009C061573
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 02:05:02 -0700 (PDT)
Received: by mail-vk1-xa41.google.com with SMTP id n7so3883029vkq.5
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 02:05:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CwVo4IAPIk+boOD3HK3VVHdTIHQTTXxp5+uKxnmqy+k=;
        b=XNiUJeXACLLFkSCFizYYYWB6PK3Rf7k0kiYAnVldT0pvc+PevJ1fuPFURXPH4a+0mx
         s7fERGkdGvAxOJvt3dp7BiyxPii+SB0/amVj+NnOGZqxFKYwgFF9WD1u55P8iwLMc8Mu
         KaKIR2tAEb4FDlh3NIttXtzmJ7siFlwhmPyQxOsdgszmadC49+r1nkiYRpuHZnqc0eyW
         YK5fapuNfAokkiXbP36UxLZV3HbfBzKJoZ7EvrSMogRuvilv0O76IfyDdQrJoV1BFcdX
         qL0XtB6aGGhj2BMW4MNA/djfFQUmBzUiTIJjHeL+Vmkjt+4+XDp7ZIejSOkmy9XJFwmp
         gR3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CwVo4IAPIk+boOD3HK3VVHdTIHQTTXxp5+uKxnmqy+k=;
        b=dM3IkA5z1U0B81tdVpBmN71vQP6bmgqPiQUIE4aNqRvFBLQd378A0bxAm1dwnNJJ1N
         lbFBQdoWJhqdX8+4NWHwAKiZ2pqUBpjke429YTS6zdaVq5w+TjH+03W17DefW31J3RSO
         9c+/Pd3bn8PKw+psVKzrgBRMNZQBHPecKK3bGbMjK7OXpx8LwPDdf2j1gjh9igu9bFKa
         IQPlmwarP9BRbHhKx+9bxWkORXi/v9qE6v/Ri50aiYVE1Z1cKfxJr+wskAriYDKnaYAW
         QUTcOENAxAP4S8por/z6jMWW20i8Ydmk3QGc9eFJyIZjMv7F7Ao7Kx6otN6gpx4+Xw+T
         BwPw==
X-Gm-Message-State: AOAM531w88xjGGiIShrLQG0GMMclAYHlnRYaIESB8QdW4f+rEDOGp0DP
        5q3YjyLYufmoGgwghOZh4jbtOmj0U1JeMA==
X-Google-Smtp-Source: ABdhPJxBfX/U+11ZZ4uJ3jnCuSpoNTj1JGxzhyFrpoTRmx3LQHWxL+pZCAkfcl+sIyH8j5VGZ1ydVA==
X-Received: by 2002:a1f:2e54:: with SMTP id u81mr116980vku.10.1599555900778;
        Tue, 08 Sep 2020 02:05:00 -0700 (PDT)
Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com. [209.85.217.54])
        by smtp.gmail.com with ESMTPSA id m6sm443455vsr.32.2020.09.08.02.04.59
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2020 02:05:00 -0700 (PDT)
Received: by mail-vs1-f54.google.com with SMTP id e14so8561316vsa.9
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 02:04:59 -0700 (PDT)
X-Received: by 2002:a67:c78b:: with SMTP id t11mr13738763vsk.109.1599555899405;
 Tue, 08 Sep 2020 02:04:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200903210022.22774-1-saeedm@nvidia.com> <20200903210022.22774-10-saeedm@nvidia.com>
 <CA+FuTSdoUHM=8Z1FQ8L_eOGwKyzQyO3PD-FHvsf2Q0wBOJ9X7Q@mail.gmail.com> <3cadeba3-bf14-428a-5783-9b8ec547f716@nvidia.com>
In-Reply-To: <3cadeba3-bf14-428a-5783-9b8ec547f716@nvidia.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 8 Sep 2020 11:04:22 +0200
X-Gmail-Original-Message-ID: <CA+FuTScVsah+=DeQ3EYnK92fr_S9F+gvn0F2hJ5_cMtx1L3fjA@mail.gmail.com>
Message-ID: <CA+FuTScVsah+=DeQ3EYnK92fr_S9F+gvn0F2hJ5_cMtx1L3fjA@mail.gmail.com>
Subject: Re: [net-next 09/10] net/mlx5e: Move TX code into functions to be
 used by MPWQE
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 8, 2020 at 11:00 AM Maxim Mikityanskiy <maximmi@nvidia.com> wrote:
>
> On 2020-09-04 18:06, Willem de Bruijn wrote:
> > On Thu, Sep 3, 2020 at 11:01 PM Saeed Mahameed <saeedm@nvidia.com> wrote:
> >>
> >> From: Maxim Mikityanskiy <maximmi@mellanox.com>
> >>
> >> mlx5e_txwqe_complete performs some actions that can be taken to separate
> >> functions:
> >>
> >> 1. Update the flags needed for hardware timestamping.
> >>
> >> 2. Stop the TX queue if it's full.
> >>
> >> Take these actions into separate functions to be reused by the MPWQE
> >> code in the following commit and to maintain clear responsibilities of
> >> functions.
> >>
> >> Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
> >> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> >> ---
> >>   .../net/ethernet/mellanox/mlx5/core/en_tx.c   | 23 ++++++++++++++-----
> >>   1 file changed, 17 insertions(+), 6 deletions(-)
> >>
> >> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
> >> index 9ced350150b3..3b68c8333875 100644
> >> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
> >> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
> >> @@ -311,6 +311,20 @@ static inline void mlx5e_sq_calc_wqe_attr(struct sk_buff *skb,
> >>          };
> >>   }
> >>
> >> +static inline void mlx5e_tx_skb_update_hwts_flags(struct sk_buff *skb)
> >> +{
> >> +       if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP))
> >> +               skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
> >> +}
> >
> > Subjective, but this helper adds a level of indirection and introduces
> > code churn without simplying anything, imho.
>
> It's added for the sake of being reused in non-MPWQE and MPWQE flows.

I understand. I'm just saying that a helper for two lines whose
function is clear just adds a layer of obfuscation. As said, that is
subjective, so just keep as is as you disagree.
