Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA24146F1DC
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 18:27:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242941AbhLIRbS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 12:31:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242183AbhLIRbS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 12:31:18 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE8C4C061746;
        Thu,  9 Dec 2021 09:27:44 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id d10so15507510ybn.0;
        Thu, 09 Dec 2021 09:27:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pCkReFNzycwmra9bDr3Pm6ySMhte/S1f1z5ZgTJWVXw=;
        b=KwTLPBAwpSZjXvqyaBitmvwHh5L3ufMOcHRAsuKUQYZo6a49e7gzzRCAkke3M7hO3H
         rcJW05Tw9DXIB/TTheFPpECt51hQ23oYA4gO64a/dF7xeKZYeLb8y+Qn7j4aFbW3NZeG
         qBxmt8TbrS/3Bn0PC5HA4kIQYmnzJuLFd3xsH8idAZIq8xEQYg8LNgaqJK8f1vYkPRuf
         bQ94zx0agW9GYBEMDYRJuAbMxJUP+kLJ1/ODjxaaVNzqZ6CW5ditHHNMRxKZTP/lBEBE
         YLgenwgix0L5UAd8BNxDjJK78LsJuUceMl4h3A/0COvJTYFWz4PJ+yFQjehz908L3AuD
         KWxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pCkReFNzycwmra9bDr3Pm6ySMhte/S1f1z5ZgTJWVXw=;
        b=jdJf5bB7Qx8NVX8T1r75SaZV4SO4o1gwSI+d2DRFd8uJysLMx+t6wt7Buo2lXbonXt
         M94SyL9FvnnGIhyry17RhaFmxUfqmmRKP3BBOfqCzI1CBg8ZVVnE3yugvj2HBruG+W8V
         6YkLVy8B5HsBGgfKi90iesqk+7Geh+P4Kk2Q9Fwi2Yjy/Rr+Re4S6uqnwUUdApqVQnDf
         vJA0b5MeG0R7DdYTp6DfhrmmSIcgc8RM6LojfuZ+sakSOckS0t5RtvI2Wj5oeOn1EGeU
         zmvW/pnsXuUhv1fXAb7zzPguD7Bi3tJu/vyBN+klrH0zT4PgXY/0Th7MQHZ2RWXRZGWy
         20sw==
X-Gm-Message-State: AOAM531UuGz6gF6gTcV0QJO8k4u3yBVmrReKnmiEkna2PMLpfNqLnL+M
        LZADOouglysvar/WejuvTT+9Q3LWrgI5W0hSEa95tsedOgo=
X-Google-Smtp-Source: ABdhPJwoCPQobIbi3prHEyjeo6jIQqp6YrJObMO0wsbid/gzCJRV8pfgZqCoevPXtGp+HzmfesmhWLSNz9CwJm/yy1E=
X-Received: by 2002:a25:e90a:: with SMTP id n10mr7590667ybd.180.1639070864037;
 Thu, 09 Dec 2021 09:27:44 -0800 (PST)
MIME-Version: 1.0
References: <CAEf4BzacuM8cR8Xuv5tdg7=KScVi26pZ3CjewAy=UuHouiRZdg@mail.gmail.com>
 <20211209080051.421844-1-chi.minghao@zte.com.cn>
In-Reply-To: <20211209080051.421844-1-chi.minghao@zte.com.cn>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 9 Dec 2021 09:27:32 -0800
Message-ID: <CAEf4BzbuQzP52M6sQVic36ehmL2JO52jz08GA8swdSazF7=umg@mail.gmail.com>
Subject: Re: [PATCHv2 bpf-next] samples/bpf:remove unneeded variable
To:     cgel.zte@gmail.com
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        chiminghao <chi.minghao@zte.com.cn>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Martin Lau <kafai@fb.com>, KP Singh <kpsingh@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Zeal Robot <zealci@zte.com.cm>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 9, 2021 at 12:01 AM <cgel.zte@gmail.com> wrote:
>
> From: Minghao Chi <chi.minghao@zte.com.cn>
>
> return value form directly instead of
> taking this in another redundant variable.
>
> Reported-by: Zeal Robot <zealci@zte.com.cm>
> Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
> ---

Applied to bpf-next, thanks.

>  samples/bpf/xdp_redirect_cpu.bpf.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/samples/bpf/xdp_redirect_cpu.bpf.c b/samples/bpf/xdp_redirect_cpu.bpf.c
> index f10fe3cf25f6..25e3a405375f 100644
> --- a/samples/bpf/xdp_redirect_cpu.bpf.c
> +++ b/samples/bpf/xdp_redirect_cpu.bpf.c
> @@ -100,7 +100,6 @@ u16 get_dest_port_ipv4_udp(struct xdp_md *ctx, u64 nh_off)
>         void *data     = (void *)(long)ctx->data;
>         struct iphdr *iph = data + nh_off;
>         struct udphdr *udph;
> -       u16 dport;
>
>         if (iph + 1 > data_end)
>                 return 0;
> @@ -111,8 +110,7 @@ u16 get_dest_port_ipv4_udp(struct xdp_md *ctx, u64 nh_off)
>         if (udph + 1 > data_end)
>                 return 0;
>
> -       dport = bpf_ntohs(udph->dest);
> -       return dport;
> +       return bpf_ntohs(udph->dest);
>  }
>
>  static __always_inline
> --
> 2.25.1
>
