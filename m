Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE4E73ACC4A
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 15:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233832AbhFRNgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 09:36:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232253AbhFRNgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 09:36:23 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31A35C061574;
        Fri, 18 Jun 2021 06:34:13 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id e22so7226774wrc.1;
        Fri, 18 Jun 2021 06:34:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=uhR3Q/lpS2AFK+I3SN0ClOhvE4Lw7GtrMAtUB+dc6tk=;
        b=Hul4qQjBl1N89PIdc175BHvCmYNeQxkePLeSt9OSflGDOvGFcW+XNbESzS43d49weR
         BeVfMR27gB52BMwMiTCRSumyt3eaDC+GLxuf30K2BXrnUFUgLKis5PLXx8v0G0pLQlUt
         b1I3tDKqkNWQ5ie45te1jlCFtrFS/6BrZg3St1uFTTe9Ipuyb42M6UcrbUNQo2t5SJ/x
         SMUvNSWHJssr24M3h72QZiYa1U48E9jz77oOUkXQGadi1P6rT0btldsew5Sc96RrlmZj
         WQsQ2LZL30w+JTTzQ9Nrv4lD3I3Trrw/qggPky0+rg6+4+gxfxmYy6WY83CGL9O9IOsZ
         ZhhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=uhR3Q/lpS2AFK+I3SN0ClOhvE4Lw7GtrMAtUB+dc6tk=;
        b=jJVso0OdNtnCBDLosHyQ/RW757pXhowibumukUvnexMUDuvzI2dot1DfEq+VWUWV27
         CmlVKQjSEw8QLn01E6esR0oHhCwdn2tX5UtYjp+OjYhCfEZNZJHFzBGFK4sl+NmJ+IhD
         3nHleGevyGUVa9lfBmcTjWL6fAnghwA8H0veZdAVqKp2/rZBZfHETMt3XUBYM+UGd3Ss
         JKvzadFMN/h5hbqu9mfOyHRNRlQALCvtk9ey0twSgWq+UXsA0x2D6a4t48P2rm4xMrfi
         myV0bVgmxX9ICC1Qrt3N5a/MIsPywzC4YWrUWtylNcdY3kBk7reYyeauAXmmiG8E1a34
         47OA==
X-Gm-Message-State: AOAM5313/uf/3JRqzUyKiHCqEpxO9LPghdR/M4UffE0QfjacFQb93Oer
        efYED3gDASEppr2AvBMAxwXrrUDe7xBBvxDNtFY=
X-Google-Smtp-Source: ABdhPJzYCV83/GN7MQdS0/ddWZP+M6sYDMTiIR21IotEGijWpNtVHNIJX18GQfvUtH2GnjGbx/0TAJ56Aod/r1PI6F4=
X-Received: by 2002:adf:ba07:: with SMTP id o7mr12411429wrg.160.1624023251740;
 Fri, 18 Jun 2021 06:34:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210618075805.14412-1-magnus.karlsson@gmail.com>
In-Reply-To: <20210618075805.14412-1-magnus.karlsson@gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Fri, 18 Jun 2021 15:33:58 +0200
Message-ID: <CAJ+HfNhP48y=zpzjr60hbp4iJzBFTWG9-JaBf0bQcSsAW71xTQ@mail.gmail.com>
Subject: Re: [PATCH bpf v2] xsk: fix broken Tx ring validation
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Netdev <netdev@vger.kernel.org>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Jun 2021 at 09:58, Magnus Karlsson <magnus.karlsson@gmail.com> w=
rote:
>
> From: Magnus Karlsson <magnus.karlsson@intel.com>
>
> Fix broken Tx ring validation for AF_XDP. The commit under the Fixes
> tag, fixed an off-by-one error in the validation but introduced
> another error. Descriptors are now let through even if they straddle a
> chunk boundary which they are not allowed to do in aligned mode. Worse
> is that they are let through even if they straddle the end of the umem
> itself, tricking the kernel to read data outside the allowed umem
> region which might or might not be mapped at all.
>
> Fix this by reintroducing the old code, but subtract the length by one
> to fix the off-by-one error that the original patch was
> addressing. The test chunk !=3D chunk_end makes sure packets do not
> straddle chunk boundraries. Note that packets of zero length are
> allowed in the interface, therefore the test if the length is
> non-zero.
>
> v1 -> v2:
> * Improved commit message
>
> Fixes: ac31565c2193 ("xsk: Fix for xp_aligned_validate_desc() when len =
=3D=3D chunk_size")
> Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>

Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org>

> ---
>  net/xdp/xsk_queue.h | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
>
> diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
> index 9d2a89d793c0..9ae13cccfb28 100644
> --- a/net/xdp/xsk_queue.h
> +++ b/net/xdp/xsk_queue.h
> @@ -128,12 +128,15 @@ static inline bool xskq_cons_read_addr_unchecked(st=
ruct xsk_queue *q, u64 *addr)
>  static inline bool xp_aligned_validate_desc(struct xsk_buff_pool *pool,
>                                             struct xdp_desc *desc)
>  {
> -       u64 chunk;
> -
> -       if (desc->len > pool->chunk_size)
> -               return false;
> +       u64 chunk, chunk_end;
>
>         chunk =3D xp_aligned_extract_addr(pool, desc->addr);
> +       if (likely(desc->len)) {
> +               chunk_end =3D xp_aligned_extract_addr(pool, desc->addr + =
desc->len - 1);
> +               if (chunk !=3D chunk_end)
> +                       return false;
> +       }
> +
>         if (chunk >=3D pool->addrs_cnt)
>                 return false;
>
>
> base-commit: da5ac772cfe2a03058b0accfac03fad60c46c24d
> --
> 2.29.0
>
