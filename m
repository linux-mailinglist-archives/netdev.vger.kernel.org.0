Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B0D91BD416
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 07:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbgD2Fi5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 01:38:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725861AbgD2Fi4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 01:38:56 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D74FC03C1AC;
        Tue, 28 Apr 2020 22:38:55 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id 23so890679qkf.0;
        Tue, 28 Apr 2020 22:38:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E5tO7IyjDy27dRgQJSryE1tlREbFpt2RlmLrQ3RxKKk=;
        b=XxOtUwhPU2acqMi7BJ1hBTOO3x5LBBZfyHGh9PsAjeZAoghxNVtjwVu56myOZO4Sxj
         Aag1Api5a04rhqS0dpsECvefKcRYsIlV4+zrJermKiPDVJvq+LH02D7KVtdomWdUbR8M
         +PHYxgAMT6mBtienPgCLk+lzKyzarOZJ3J++YMtbaZUL9maDYZWcuUT/bL/c5MWGo539
         VUBwjbV6ggiai1xMV4qybcYX84jfMTMwlaNn7CPLmIlGPvy9OW1ITg/Gef3NCMR4B1oK
         laD6ud84NWYjWRlNqSiJarmsFfqXig+tA7YavnH6HPXcnsg/OlrG9iuGp9nfOetY7vVa
         PXMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E5tO7IyjDy27dRgQJSryE1tlREbFpt2RlmLrQ3RxKKk=;
        b=r2Qq/qFc71CG/QVAsqvlj+zLiOQ7nj3eJAyUWqDgUDKJywHkt0P7L5vyikNdPa4Db2
         ULsNHDwsoidmEbL1OtGX97OwsJEQJXT6lFWumEnDgHNQd5nD3Q5OdwCs8pdVNzjyX/NH
         XxCMHJzkj9HWRvLe0yR+zbZGaj2A2xRAoOPH//+mHCemET20lTcxU8QUcFO6qhOP2sV+
         zaJ+KohkIk6YUDn4UjTI/PAwu65J7s++zrDcFB/zmVcjbbrznlcI3YFObDDWybhEFFCZ
         DZyx8iJQfRczkdNZjcBEFquIAOTEbKtL3egTnpR4pRXi76ja642r9Eb18jzCr9IYCxs9
         IW5g==
X-Gm-Message-State: AGi0PubahfCgmYkApsOuKaLd2P/2EdOwZof63hmGIRxCyMFqt58SnoOJ
        Qflg707zvn4/xSND2lCWs7Ki0cSTXU7NUxXfxFG0iUo5
X-Google-Smtp-Source: APiQypKJB/vHUUGzVvRbQcU3wzSSr3dcQQkY9t/TnV2GzZQSa26NoDQdIRv8kQLNrq/7VGfEf7PlKNs9KStyBxKgLLk=
X-Received: by 2002:ae9:e10b:: with SMTP id g11mr33289946qkm.449.1588138734222;
 Tue, 28 Apr 2020 22:38:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200427201235.2994549-1-yhs@fb.com> <20200427201235.2994615-1-yhs@fb.com>
In-Reply-To: <20200427201235.2994615-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 28 Apr 2020 22:38:43 -0700
Message-ID: <CAEf4BzYvZ3Z=AHUVVV=Z2ne4QwRF86e7W_ZfmL1qwbEA6UWY9Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 01/19] net: refactor net assignment for
 seq_net_private structure
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 27, 2020 at 1:13 PM Yonghong Song <yhs@fb.com> wrote:
>
> Refactor assignment of "net" in seq_net_private structure
> in proc_net.c to a helper function. The helper later will
> be used by bpfdump.

typo: bpfdump -> bpf_iter ?

Otherwise:

Acked-by: Andrii Nakryiko <andriin@fb.com>

>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  fs/proc/proc_net.c           | 5 ++---
>  include/linux/seq_file_net.h | 8 ++++++++
>  2 files changed, 10 insertions(+), 3 deletions(-)
>
> diff --git a/fs/proc/proc_net.c b/fs/proc/proc_net.c
> index 4888c5224442..aee07c19cf8b 100644
> --- a/fs/proc/proc_net.c
> +++ b/fs/proc/proc_net.c
> @@ -75,9 +75,8 @@ static int seq_open_net(struct inode *inode, struct file *file)
>                 put_net(net);
>                 return -ENOMEM;
>         }
> -#ifdef CONFIG_NET_NS
> -       p->net = net;
> -#endif
> +
> +       set_seq_net_private(p, net);
>         return 0;
>  }
>
> diff --git a/include/linux/seq_file_net.h b/include/linux/seq_file_net.h
> index 0fdbe1ddd8d1..0ec4a18b9aca 100644
> --- a/include/linux/seq_file_net.h
> +++ b/include/linux/seq_file_net.h
> @@ -35,4 +35,12 @@ static inline struct net *seq_file_single_net(struct seq_file *seq)
>  #endif
>  }
>
> +static inline void set_seq_net_private(struct seq_net_private *p,
> +                                      struct net *net)
> +{
> +#ifdef CONFIG_NET_NS
> +       p->net = net;
> +#endif
> +}
> +
>  #endif
> --
> 2.24.1
>
