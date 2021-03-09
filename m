Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6BC332D6B
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 18:40:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbhCIRkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 12:40:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbhCIRjw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 12:39:52 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BE4CC06174A
        for <netdev@vger.kernel.org>; Tue,  9 Mar 2021 09:39:52 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id g27so14845245iox.2
        for <netdev@vger.kernel.org>; Tue, 09 Mar 2021 09:39:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lUaBBP/7pP4tS9Tf6LkqYKfvNFAq+wPQoN5CLfaWLvs=;
        b=smX3pRbMx1Stj6rnMmLdF9Hm6gLrzk3ouuAuy+4LXFRNVmRxT4Kjiu4THJtrZ9hPNq
         gQvpJ4SmCo+7Vvm9/PqmaMesPa78QnNhTCox0ok2VAN8TuFVNTxu8Dz/Tx9codycR1D6
         rg7IZ4ufBchaT/YlmXeMqSH/SNxp5580BJtVcUkF3esqdCRhWo+iXkKt5cTEC5PCVjGi
         9jwBUY5/DnzGh4ZEr+cH5d+mqgFzGboypnL9o6NFfgpw+nYcGZlE0RSjYjSrWLpXD0Mq
         u9EH0lNyaF0eip/iUxLw2fPiudO+J6ODNeSrcP+3fstDUFoJLX6ZRF53MYCaWn+eQQkX
         6myw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lUaBBP/7pP4tS9Tf6LkqYKfvNFAq+wPQoN5CLfaWLvs=;
        b=MSlXzEDNZV92WjhQuhVSNVdGHe9R6EGKAOTK/KZNzAzD7s3wJEneDvwE+R5hPS+imE
         v6cPQ2nrtH70jF5GsZQyhN7KwQUZsfCpM7fnpzMNaGo1BYtkLs84K4yHYzfY6H66u0uh
         OaR2rK2QlyfLWd9Ewe8HNlK1Dsmo31SEh6w3gxGCVRZnv+ldi3Y0CGQFQX7HYieT/Td1
         6T1soQ6J1TsCqb0BZ/W8z5xkiiME35QPZzSGd+RKIp939pGCQUNSBAyQOyctKkH9l2gW
         h6w9HtkjCbvrBtVO6QtLLVMDh5QUcEfP5xyY6Aa0Qp+LPPwHB1znyhQKaN7tHVFSMvnF
         efqw==
X-Gm-Message-State: AOAM530MMsfzaveelMgApOq3lCNltal4g3lkA4cn5Nij2Mnm7rb4V7dV
        1bT9MI98l+/wWN0XB8GsiBIVbRpK1Mcd7ilcGSPAfnfSY0I=
X-Google-Smtp-Source: ABdhPJydTGDzDZ4JJitnlBQnQFE2Vr3Jj0c3LBjKK/uEQdz/X0DOyADiq4Fg9EwzuCo/ZC26WYGE1rFhogfPHgukM54=
X-Received: by 2002:a05:6638:1390:: with SMTP id w16mr29751069jad.83.1615311591557;
 Tue, 09 Mar 2021 09:39:51 -0800 (PST)
MIME-Version: 1.0
References: <20210309031028.97385-1-xiangxia.m.yue@gmail.com>
In-Reply-To: <20210309031028.97385-1-xiangxia.m.yue@gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 9 Mar 2021 09:39:40 -0800
Message-ID: <CAKgT0UfZ0c4P4SMyCV9LAN=9PV=B6=0Ck+8jeZV4OxSGHnAuzg@mail.gmail.com>
Subject: Re: [PATCH] net: sock: simplify tw proto registration
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 8, 2021 at 7:15 PM <xiangxia.m.yue@gmail.com> wrote:
>
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> Introduce a new function twsk_prot_init, inspired by
> req_prot_init, to simplify the "proto_register" function.
>
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> ---
>  net/core/sock.c | 44 ++++++++++++++++++++++++++++----------------
>  1 file changed, 28 insertions(+), 16 deletions(-)
>
> diff --git a/net/core/sock.c b/net/core/sock.c
> index 0ed98f20448a..610de4295101 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -3475,6 +3475,32 @@ static int req_prot_init(const struct proto *prot)
>         return 0;
>  }
>
> +static int twsk_prot_init(const struct proto *prot)
> +{
> +       struct timewait_sock_ops *twsk_prot = prot->twsk_prot;
> +
> +       if (!twsk_prot)
> +               return 0;
> +
> +       twsk_prot->twsk_slab_name = kasprintf(GFP_KERNEL, "tw_sock_%s",
> +                                             prot->name);
> +       if (!twsk_prot->twsk_slab_name)
> +               return -ENOMEM;
> +
> +       twsk_prot->twsk_slab =
> +               kmem_cache_create(twsk_prot->twsk_slab_name,
> +                                 twsk_prot->twsk_obj_size, 0,
> +                                 SLAB_ACCOUNT | prot->slab_flags,
> +                                 NULL);
> +       if (!twsk_prot->twsk_slab) {
> +               pr_crit("%s: Can't create timewait sock SLAB cache!\n",
> +                       prot->name);
> +               return -ENOMEM;
> +       }
> +
> +       return 0;
> +}
> +

So one issue here is that you have two returns but they both have the
same error clean-up outside of the function. It might make more sense
to look at freeing the kasprintf if the slab allocation fails and then
using the out_free_request_sock_slab jump label below if the slab
allocation failed.

>  int proto_register(struct proto *prot, int alloc_slab)
>  {
>         int ret = -ENOBUFS;
> @@ -3496,22 +3522,8 @@ int proto_register(struct proto *prot, int alloc_slab)
>                 if (req_prot_init(prot))
>                         goto out_free_request_sock_slab;
>
> -               if (prot->twsk_prot != NULL) {
> -                       prot->twsk_prot->twsk_slab_name = kasprintf(GFP_KERNEL, "tw_sock_%s", prot->name);
> -
> -                       if (prot->twsk_prot->twsk_slab_name == NULL)
> -                               goto out_free_request_sock_slab;
> -
> -                       prot->twsk_prot->twsk_slab =
> -                               kmem_cache_create(prot->twsk_prot->twsk_slab_name,
> -                                                 prot->twsk_prot->twsk_obj_size,
> -                                                 0,
> -                                                 SLAB_ACCOUNT |
> -                                                 prot->slab_flags,
> -                                                 NULL);
> -                       if (prot->twsk_prot->twsk_slab == NULL)
> -                               goto out_free_timewait_sock_slab;
> -               }
> +               if (twsk_prot_init(prot))
> +                       goto out_free_timewait_sock_slab;

So assuming the code above takes care of freeing the slab name in case
of slab allocation failure then this would be better off jumping to
out_free_request_sock_slab.

>         }
>
>         mutex_lock(&proto_list_mutex);
> --
> 2.27.0
>
