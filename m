Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35AFF55D41
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 03:14:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbfFZBOI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 21:14:08 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:33403 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726223AbfFZBOH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 21:14:07 -0400
Received: by mail-qk1-f195.google.com with SMTP id r6so335296qkc.0;
        Tue, 25 Jun 2019 18:14:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xa7kFnyQoa+lEZDO7e1IGoD9fmAsnkzHy+2marOiLwQ=;
        b=deuJZWDXie6s6wJsPRLE5XatLhfZLBdzcg6KTeUX2rNTbwn/Sr0i2IQn8sAkXCPj/W
         w3uuurc9pGXAcSTtC6m85Q93L0TM+Sm7V1ogHHAPgcEahjF9afHWYGokfqQcYY/O5k3h
         K+ty7S/xbnHiZzXDscxmuu5SJBh2Brl0CygB7ZULmdjugnRMUDSApG6K2M7EK/WaArtQ
         +5BRK/NZ/zLbuAv1BIib1n7z2B7OJ/A54VZRMDJbmXMl4VUOzwi5+Qoxttj8m1ukNhCI
         uZPXdghZ6BfI2oNRCmwWowhUYTQrqJDoOSZB1+f9vY42oLRANTYIuxdDkdNKiN19nL/e
         5TFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xa7kFnyQoa+lEZDO7e1IGoD9fmAsnkzHy+2marOiLwQ=;
        b=Y/E0LUJK/BWPK/9JWr/vCcEvdcybTh9EXyvSNlm51WSIiAUjamAFMSQufWIzVtHL99
         N+toJrMa/JzxDBLeXYckEvKtfN8bspM6At4ZhoC3oTREqNzXoKnaZRkgR4v1XhuY1C+N
         cIlUjFms1vjoEltoIJ/8DFHVqmq4Vm0q06Ph96preouXcNItlPpRz7xC+JpRW6wiEmQ7
         3GlS8V2DOTr8KTsgeGY0iMGSnA1nLwGtLOUYxNuCB0wth2dnVjH8B8lO6XBJw0Apvxd+
         9zccbhML8ZO7TMcGdIU/oBJk+U3ZuJAjPNKKALN5pITbyhx3jqYLlU+9+4BrH9RHIlwp
         IuOw==
X-Gm-Message-State: APjAAAXoDMSDXlyaDI7wr2D9e48oyBZQq45HnkJynbtjGywRPYIIKWlk
        KepULaqrEXd6h4k+3D7j1nj6QELdPFxOQHZugcs=
X-Google-Smtp-Source: APXvYqwEjNW3qilUtEwD2dd81tM9h8NAAnx3UXiozPS4tBXBBlz4c70wG/gGkbGLe8mrr+8HWDosRFreLhfZBZJdAR0=
X-Received: by 2002:a37:4d82:: with SMTP id a124mr1492498qkb.72.1561511646642;
 Tue, 25 Jun 2019 18:14:06 -0700 (PDT)
MIME-Version: 1.0
References: <20190625182352.13918-1-natechancellor@gmail.com>
In-Reply-To: <20190625182352.13918-1-natechancellor@gmail.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Tue, 25 Jun 2019 18:13:55 -0700
Message-ID: <CAPhsuW5XRqNpcw7WEsg=E6----XG6-9Cs8=wQbPRfAOXnOYv8Q@mail.gmail.com>
Subject: Re: [PATCH] xsk: Properly terminate assignment in xskq_produce_flush_desc
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        xdp-newbies@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Huckleberry <nhuck@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 25, 2019 at 12:54 PM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> Clang warns:
>
> In file included from net/xdp/xsk_queue.c:10:
> net/xdp/xsk_queue.h:292:2: warning: expression result unused
> [-Wunused-value]
>         WRITE_ONCE(q->ring->producer, q->prod_tail);
>         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> include/linux/compiler.h:284:6: note: expanded from macro 'WRITE_ONCE'
>         __u.__val;                                      \
>         ~~~ ^~~~~
> 1 warning generated.
>
> The q->prod_tail assignment has a comma at the end, not a semi-colon.
> Fix that so clang no longer warns and everything works as expected.
>
> Fixes: c497176cb2e4 ("xsk: add Rx receive functions and poll support")
> Link: https://github.com/ClangBuiltLinux/linux/issues/544
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

Cc: <stable@vger.kernel.org> # v4.18+
Acked-by: Song Liu <songliubraving@fb.com>

Thanks for the fix!


> ---
>  net/xdp/xsk_queue.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
> index 88b9ae24658d..cba4a640d5e8 100644
> --- a/net/xdp/xsk_queue.h
> +++ b/net/xdp/xsk_queue.h
> @@ -288,7 +288,7 @@ static inline void xskq_produce_flush_desc(struct xsk_queue *q)
>         /* Order producer and data */
>         smp_wmb(); /* B, matches C */
>
> -       q->prod_tail = q->prod_head,
> +       q->prod_tail = q->prod_head;
>         WRITE_ONCE(q->ring->producer, q->prod_tail);
>  }
>
> --
> 2.22.0
>
