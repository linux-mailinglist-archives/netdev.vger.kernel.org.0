Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4862E3D22AE
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 13:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231713AbhGVKqQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 06:46:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231286AbhGVKqP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 06:46:15 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ADD0C061575
        for <netdev@vger.kernel.org>; Thu, 22 Jul 2021 04:26:50 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id r135so4783251ybc.0
        for <netdev@vger.kernel.org>; Thu, 22 Jul 2021 04:26:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LY/3UQVMLCt1YmqZR3yy9aFu3cFmtUpm6v8HH0OSmpc=;
        b=DzQJSlI/+Mu0zyH8vlobVbL5E3AUDLfvusB5aX9EK/4Qdr0LwIaNjK64Smd0Ez3eBC
         Jza1U59xvhpt9V4o0kuew5hXp3MLmNsQDRurz3U/iyFIt8d4yCF6X6v/W8WgfXX8BBgU
         Oc9rnZucceIOUiCAm/y85j4vT0sN15aTpMSy1EeGobg+r+zcPxjmr1AJ+dOg32EIfuGI
         IYOpUQC+FPdeWb/xt7CkFPw0SmZmTjNMih2HKR5KC8ThtrJQxoI+QpNSlT3avs5WOEnC
         zLI9kFQwnzSIQbCf5hSOw9rMpMiQS8RzxZ1XiST4DFxAvq/jce9enPnQnJRx9bV4VhBG
         Bs6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LY/3UQVMLCt1YmqZR3yy9aFu3cFmtUpm6v8HH0OSmpc=;
        b=tvFVO2SqhSg+sil3jOXase2VjJqcrpbB0hGeo5ZSbKo8ARltXlW979+Gi75vOL6IN+
         +y0BKMlrtUvaIvnhLd4/C+5Za9gMaLHkzUaw+D6hEos0Ts4Ok++Dp8ENRII7ILVKrXqL
         TaT6n9q5BFv+NWHsa+eZ68QvipQnFHcrYC5/kWz6rWQpVqzFAUtXo1AEgLRCcbKLf90g
         1LSevGHrkQ2ZQzK9PzjnfDT+zQOC2a+7NnuT74X59TGzIVEoQoG8HaCX/lbAm3TBhnZM
         Mp5V+XBz5DWkfPj9VoKfpwohgmqSVWBlIK6Bv4IITIFpEtwNbF+HhLiXnLzjDDEHMY5m
         /ohw==
X-Gm-Message-State: AOAM53378jAS+0M97lCh3AkXusrxBRWRh6kPCGE37cCO6NvbmEON8G/q
        u+b3Cnru1fRJshUXhOvkwsyNgS9K+4kZT8fsr1OrlA==
X-Google-Smtp-Source: ABdhPJyL4vwqaMpNugwufDInzlGAlBzOgDGT0wpkeVoth+W+20J79EbDnLUBZEHhtECw0hpcbHNjvL+caHgL2+V33GM=
X-Received: by 2002:a25:afcd:: with SMTP id d13mr49814639ybj.504.1626953209728;
 Thu, 22 Jul 2021 04:26:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210722110325.371-1-borisp@nvidia.com> <20210722110325.371-2-borisp@nvidia.com>
In-Reply-To: <20210722110325.371-2-borisp@nvidia.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 22 Jul 2021 13:26:38 +0200
Message-ID: <CANn89iLP4yXDK9nOq6Lxs9NrfAOZ6RuX5B5SV0Japx50KvnEyQ@mail.gmail.com>
Subject: Re: [PATCH v5 net-next 01/36] net: Introduce direct data placement
 tcp offload
To:     Boris Pismenny <borisp@nvidia.com>
Cc:     David Ahern <dsahern@gmail.com>, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Christoph Hellwig <hch@lst.de>, sagi@grimberg.me, axboe@fb.com,
        kbusch@kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        smalin@marvell.com, boris.pismenny@gmail.com,
        linux-nvme@lists.infradead.org, netdev <netdev@vger.kernel.org>,
        benishay@nvidia.com, ogerlitz@nvidia.com, yorayz@nvidia.com,
        Boris Pismenny <borisp@mellanox.com>,
        Ben Ben-Ishay <benishay@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 22, 2021 at 1:04 PM Boris Pismenny <borisp@nvidia.com> wrote:
>
> From: Boris Pismenny <borisp@mellanox.com>
>
>
...

>  };
>
>  const char
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index e6ca5a1f3b59..4a7160bba09b 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -5149,6 +5149,9 @@ tcp_collapse(struct sock *sk, struct sk_buff_head *list, struct rb_root *root,
>                 memcpy(nskb->cb, skb->cb, sizeof(skb->cb));
>  #ifdef CONFIG_TLS_DEVICE
>                 nskb->decrypted = skb->decrypted;
> +#endif
> +#ifdef CONFIG_ULP_DDP
> +               nskb->ddp_crc = skb->ddp_crc;

Probably you do not want to attempt any collapse if skb->ddp_crc is
set right there.

>  #endif
>                 TCP_SKB_CB(nskb)->seq = TCP_SKB_CB(nskb)->end_seq = start;
>                 if (list)
> @@ -5182,6 +5185,11 @@ tcp_collapse(struct sock *sk, struct sk_buff_head *list, struct rb_root *root,
>  #ifdef CONFIG_TLS_DEVICE
>                                 if (skb->decrypted != nskb->decrypted)
>                                         goto end;
> +#endif
> +#ifdef CONFIG_ULP_DDP
> +
> +                               if (skb->ddp_crc != nskb->ddp_crc)

This checks only the second, third, and remaining skbs.

> +                                       goto end;
>  #endif
>                         }
>                 }


tcp_collapse() is copying data from small skbs to pack it to bigger
skb (one page of payload), in case
of memory emergency/pressure (socket queues are full)

If your changes are trying to avoid 'needless'  copies, maybe you
should reconsider and let the emergency packing be done.

If the copy is not _possible_, you should rephrase your changelog to
clearly state the kernel _cannot_ access this memory in any way.
