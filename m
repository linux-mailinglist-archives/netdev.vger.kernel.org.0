Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9A293ACC87
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 15:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233430AbhFRNqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 09:46:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231855AbhFRNqO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 09:46:14 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 431C7C061574;
        Fri, 18 Jun 2021 06:44:04 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id b3so587998wrm.6;
        Fri, 18 Jun 2021 06:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1KZhL4TvWHdLfflpYli1LmfRJGpIKZAtvn+Dbu/3l0s=;
        b=MGyPV4on7GsD51BQYcCQ1fZrYP8m8nAmdE+bzB6Y30bmY5GgO1akMScO+nlLoC5BiN
         pgtu1dptoKZhtPZ9ofkZNtYzl7xrRALx6BheM0R9caM0eVeaTbeSEz4CZzHsEQHczxys
         tQY5OgxxSktZ/MTRHwkD5l//mbKmSdslSZDgEU6gJFn0G0RXBCP2Fo/gwGPKlc0pJzcT
         EJerTELPQlBHy6+vuYSzuk6Q/vsGEpEKg0EaH3I85SBD3gYHeZV963+1LckpKiiOmnCT
         I3L99CSUX1WfjdmRRC5Vp5tDsoYYVCikzyDuvzGC0+H5E/7QbugXXsXeK9/N4biHcEeZ
         phTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1KZhL4TvWHdLfflpYli1LmfRJGpIKZAtvn+Dbu/3l0s=;
        b=tb8W2jvZOevedJBw0cJuGi41XflKIq1RZb4+0pxsCvRpv9jKYBBXti4ui1Ld4V8tyH
         63AiEKBS3Hzsu+FUJh+rJTKylOYXLDH10yQQxhICZftOIJQ8KMwlGzH3lwJZe9ByS1GM
         +AT7Sce6v6GJiZ3XqyyDjzVjSpGa5VQFh8WYdodoLtqTlB/iBZeLlQgfC+hQ8yDyqRHX
         VqrjOf+CnJ8h30WVrRya+Ut7+ag2ggGd2JYUUND4iwcPxnzQDMUU4160/eSoUXKNL3rC
         iRyLOlxStT7TUjPjIjLT0SGXgxtFjE8NRzSOC2SISblQREPLyDMlzSlmNrRCFitrm4tU
         2fXQ==
X-Gm-Message-State: AOAM530JdIq2NJGRp7jMSDOg2eVbXip7PKYKIP9gtri2OPlTliQZAhXV
        O6E5wiTNZbtR1aA5CpgT9QckWtD1m7kacATV4fQ=
X-Google-Smtp-Source: ABdhPJxFHfoQkx3BVfylZ5cw/ObUFz+PFEmvGBjHnKIEdcnV/CxsN+HtFZd0h4mmELSNYu7n9I+FNoXtbZJXF+6NUtE=
X-Received: by 2002:adf:f842:: with SMTP id d2mr12557882wrq.52.1624023842935;
 Fri, 18 Jun 2021 06:44:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210617092255.3487-1-magnus.karlsson@gmail.com>
In-Reply-To: <20210617092255.3487-1-magnus.karlsson@gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Fri, 18 Jun 2021 15:43:49 +0200
Message-ID: <CAJ+HfNgRFgfk5oVROquSaAw2F34A42xfGGMf_PXwVKYHXs80uQ@mail.gmail.com>
Subject: Re: [PATCH bpf] xsk: fix missing validation for skb and unaligned mode
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Netdev <netdev@vger.kernel.org>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Jun 2021 at 11:23, Magnus Karlsson <magnus.karlsson@gmail.com> w=
rote:
>
> From: Magnus Karlsson <magnus.karlsson@intel.com>
>
> Fix a missing validation of a Tx descriptor when executing in skb mode
> and the umem is in unaligned mode. A descriptor could point to a
> buffer straddling the end of the umem, thus effectively tricking the
> kernel to read outside the allowed umem region. This could lead to a
> kernel crash if that part of memory is not mapped.
>
> In zero-copy mode, the descriptor validation code rejects such
> descriptors by checking a bit in the DMA address that tells us if the
> next page is physically contiguous or not. For the last page in the
> umem, this bit is not set, therefore any descriptor pointing to a
> packet straddling this last page boundary will be rejected. However,
> the skb path does not use this bit since it copies out data and can do
> so to two different pages. (It also does not have the array of DMA
> address, so it cannot even store this bit.) The code just returned
> that the packet is always physically contiguous. But this is
> unfortunately also returned for the last page in the umem, which means
> that packets that cross the end of the umem are being allowed, which
> they should not be.
>
> Fix this by introducing a check for this in the SKB path only, not
> penalizing the zero-copy path.
>
> Fixes: 2b43470add8c ("xsk: Introduce AF_XDP buffer allocation API")
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>

Nice catch!

Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org>

> ---
>  include/net/xsk_buff_pool.h | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
> index eaa8386dbc63..7a9a23e7a604 100644
> --- a/include/net/xsk_buff_pool.h
> +++ b/include/net/xsk_buff_pool.h
> @@ -147,11 +147,16 @@ static inline bool xp_desc_crosses_non_contig_pg(st=
ruct xsk_buff_pool *pool,
>  {
>         bool cross_pg =3D (addr & (PAGE_SIZE - 1)) + len > PAGE_SIZE;
>
> -       if (pool->dma_pages_cnt && cross_pg) {
> +       if (likely(!cross_pg))
> +               return false;
> +
> +       if (pool->dma_pages_cnt) {
>                 return !(pool->dma_pages[addr >> PAGE_SHIFT] &
>                          XSK_NEXT_PG_CONTIG_MASK);
>         }
> -       return false;
> +
> +       /* skb path */
> +       return addr + len > pool->addrs_cnt;
>  }
>
>  static inline u64 xp_aligned_extract_addr(struct xsk_buff_pool *pool, u6=
4 addr)
>
> base-commit: da5ac772cfe2a03058b0accfac03fad60c46c24d
> --
> 2.29.0
>
