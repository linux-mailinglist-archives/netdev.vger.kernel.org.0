Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20A13260E54
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 11:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728936AbgIHJJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 05:09:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728490AbgIHJJI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 05:09:08 -0400
Received: from mail-vk1-xa42.google.com (mail-vk1-xa42.google.com [IPv6:2607:f8b0:4864:20::a42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E6E9C061573
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 02:09:07 -0700 (PDT)
Received: by mail-vk1-xa42.google.com with SMTP id x142so3903079vke.0
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 02:09:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xa7xtiDUR5RV/cSQB5POhuYJlwhl4FEMKcEMcGkz8dg=;
        b=ponikEIgesq5XMY4a7Lvx5i8bSPfrnEf6J9ng5iFm6ce0r8Rxb2rxNe9nYtF7QeYrW
         k78nWi74LeA4km+tIsOEXZHD/RYZWTgeSVzLWamYujW9Ne7sXTYXhjro12JTay3If3xr
         c5yV/dyntqW6tmyQvQfvj0N5jWYVGLsGR3LDcKCu7ZsO+AJ5sm2YEVlAtV0o32B5F9/a
         UVcQBLcaGnkDt3JPXcN9kExmHbnp0cvOPGAoznR+/Re5e7f1aSDrKv5lXAqnUQ4R8rxP
         axf5fQiSS1HCLuQjrezSyzHBgJleo6i/aLYq5xnP4Rjp/f970yL3rKkn8MuSFD2/6rfj
         llog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xa7xtiDUR5RV/cSQB5POhuYJlwhl4FEMKcEMcGkz8dg=;
        b=dziR9mMUD93gcpEwT/xUdJhdOERGmGMOrX6/lOw9mNOYAj86fdbSqpvvUSBodtX2+O
         jcvQxAH02txhY3sQ2T79N/duEAhYfCgjwirnHtiRjCcfld1GIWpxthHwQ4EMWEEbwsRD
         zoHmzMVuO84QDFuIoJlkrn4psWiccEbAAG+FL9vgR+yHhVmBNtNs/jx0JTP0xl5HaU47
         QLNC+oVoPaG7YI9ELChGAZF/liYYOYW64QFShR/r2RMbh8b47AunrFCNNEfwLluPe8nH
         B0V18VSwPEV8vHj00dBxVHjtJR/jJTYdWsNHlD4WmqWmE9v164Je+NBuMw9QvI1Nr9Cs
         +czw==
X-Gm-Message-State: AOAM53019EqOyqOGK54jAIq+qCwcHx3vOIf0+a6FBZQNaIkaOiKh10SP
        t6BZTXbgAz0LauNP4rw0R9ScWCHuIGfMdA==
X-Google-Smtp-Source: ABdhPJydl3YfLjMAN2wohSqzrV2J/eFSi49Mhs8CI+LlA2VOVWJlSzu7qG7uLz1A7ggvOLRTrlvFyA==
X-Received: by 2002:a1f:4357:: with SMTP id q84mr13561328vka.4.1599556146324;
        Tue, 08 Sep 2020 02:09:06 -0700 (PDT)
Received: from mail-vs1-f52.google.com (mail-vs1-f52.google.com. [209.85.217.52])
        by smtp.gmail.com with ESMTPSA id b17sm1187406vsr.17.2020.09.08.02.09.05
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2020 02:09:05 -0700 (PDT)
Received: by mail-vs1-f52.google.com with SMTP id e14so8566575vsa.9
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 02:09:05 -0700 (PDT)
X-Received: by 2002:a67:f5d4:: with SMTP id t20mr13221933vso.1.1599556144891;
 Tue, 08 Sep 2020 02:09:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200903210022.22774-1-saeedm@nvidia.com> <20200903210022.22774-3-saeedm@nvidia.com>
 <CA+FuTSdP5=OPKsJHNW737JP+jDa-rDYDm0vLfX7vqnFX8yur1w@mail.gmail.com> <bee9e22e-f28f-cbc8-52df-6445f4955a01@nvidia.com>
In-Reply-To: <bee9e22e-f28f-cbc8-52df-6445f4955a01@nvidia.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 8 Sep 2020 11:08:28 +0200
X-Gmail-Original-Message-ID: <CA+FuTSdNm1+sTwM-gikcHG6qyA9jXYqVtd3B0mrhir9F-mrrfA@mail.gmail.com>
Message-ID: <CA+FuTSdNm1+sTwM-gikcHG6qyA9jXYqVtd3B0mrhir9F-mrrfA@mail.gmail.com>
Subject: Re: [net-next 02/10] net/mlx5e: Refactor xmit functions
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

On Tue, Sep 8, 2020 at 10:59 AM Maxim Mikityanskiy <maximmi@nvidia.com> wrote:
>
> On 2020-09-04 18:27, Willem de Bruijn wrote:
> > On Thu, Sep 3, 2020 at 11:00 PM Saeed Mahameed <saeedm@nvidia.com> wrote:
> >>
> >> From: Maxim Mikityanskiy <maximmi@mellanox.com>
> >>
> >> A huge function mlx5e_sq_xmit was split into several to achieve multiple
> >> goals:
> >>
> >> 1. Reuse the code in IPoIB.
> >>
> >> 2. Better intergrate with TLS, IPSEC, GENEVE and checksum offloads. Now
> >> it's possible to reserve space in the WQ before running eseg-based
> >> offloads, so:
> >>
> >> 2.1. It's not needed to copy cseg and eseg after mlx5e_fill_sq_frag_edge
> >> anymore.
> >>
> >> 2.2. mlx5e_txqsq_get_next_pi will be used instead of the legacy
> >> mlx5e_fill_sq_frag_edge for better code maintainability and reuse.
> >>
> >> 3. Prepare for the upcoming TX MPWQE for SKBs. It will intervene after
> >> mlx5e_sq_calc_wqe_attr to check if it's possible to use MPWQE, and the
> >> code flow will split into two paths: MPWQE and non-MPWQE.
> >>
> >> Two high-level functions are provided to send packets:
> >>
> >> * mlx5e_xmit is called by the networking stack, runs offloads and sends
> >> the packet. In one of the following patches, MPWQE support will be added
> >> to this flow.
> >>
> >> * mlx5e_sq_xmit_simple is called by the TLS offload, runs only the
> >> checksum offload and sends the packet.
> >>
> >> This change has no performance impact in TCP single stream test and
> >> XDP_TX single stream test.
> >>
> >> UDP pktgen (burst 32), single stream:
> >>    Packet rate: 17.55 Mpps -> 19.23 Mpps
> >>    Instructions per packet: 420 -> 360
> >>    Cycles per packet: 165 -> 142
> >>
> >> CPU: Intel(R) Xeon(R) CPU E5-2680 v3 @ 2.50GHz (x86_64)
> >> NIC: Mellanox ConnectX-6 Dx
> >>
> >> To get this performance gain, manual optimizations of function inlining
> >> were performed. It's important to have mlx5e_sq_xmit_wqe inline,
> >> otherwise the packet rate will be 1 Mpps less in UDP pktgen test.
> >> __always_inline is required, because gcc uninlines it when it's called
> >> from two places (mlx5e_xmit and mlx5e_sq_xmit_simple).
> >>
> >> Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
> >> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> >> ---
> >>   .../net/ethernet/mellanox/mlx5/core/en/txrx.h |  63 +--
> >>   .../mellanox/mlx5/core/en_accel/en_accel.h    |   5 +
> >>   .../mellanox/mlx5/core/en_accel/tls_rxtx.c    |   6 +-
> >>   .../net/ethernet/mellanox/mlx5/core/en_tx.c   | 391 ++++++++++--------
> >>   4 files changed, 243 insertions(+), 222 deletions(-)
> >
> > This combines a lot of changes. Including supposed noops, but with
> > subtle changes, like converting to struct initializers.
>
> Struct initializers are mostly used in the new code. I can split out the
> only converted occurrence.
>
> > Probably deserves to be broken up a bit more.
> >
> > For instance, a pure noop patch that moves
> > mlx5e_txwqe_build_eseg_csum,
>
> OK. Not sure I really need to move it though.

Even better.

In general, I don't really care how this patch is simplified, but as
is it is long and combines code moves, refactors that are supposedly a
noop and new functionality. I imagine that there must be some strategy
to break it up into sensible manageable chunks.
