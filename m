Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9290A58B286
	for <lists+netdev@lfdr.de>; Sat,  6 Aug 2022 00:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241450AbiHEW4h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 18:56:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241366AbiHEW4d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 18:56:33 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB6C6120AA;
        Fri,  5 Aug 2022 15:56:32 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id d139so2945573iof.4;
        Fri, 05 Aug 2022 15:56:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=6aTUnPtbLiDNZOmm7ZJHJEmqOdom7rZsShr5BudS8+Q=;
        b=hX4XqTnWUynlWrF+u8zPv9/McHO5uzg29MxGU75VaDjXXmd94Xz0U9YKlvX/zdRGsa
         x75jhbeXOwALVyDEOAzscIesbFnzy9c/yDVhKdWZFLxnYZG9lXX2KcG3e3JheT5Ee26l
         w2hvkyQAvpUGDbVvsq3jWRZ4MA4ucXz83Kmiwl6vA0xGpYh4wdzZM3/3bw254s5YjZC0
         rsna4cwlgpBhU+XFGhBkvB2DrBCZoCuKRwBmIJYORNDaK38zsSlbs4sl1pXxh6hLRpCh
         5ulWPlxGTmLuuOPa7kcQrCvfhuFcNZ73+MmsdpNlr2+T856HU+ERQSVUeJldQTxzbsN1
         Xlvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=6aTUnPtbLiDNZOmm7ZJHJEmqOdom7rZsShr5BudS8+Q=;
        b=CnL8lhVe2uGI3JvzQuMiRvqAxqkNm6xpQHrp7V7O+7LNAK8/k+bHu+gNEGQPMWI6oz
         1QXTr0IEzpp3ehXDW6hUUzaCx1WeGolzZiSDeahj3z/7iZF1RGGuJfNT7qT2/u0O9VtQ
         oQBViuwJqBNV08AxucBTaAaQqFWH7U0vd67AJDZFtqExaxBIs+uUmXpbE1z7/67lYTk7
         rGzj0uSx4eFdsUlwTyHK3SXiokCfxCgc20+thaBHqjfHuRLia+lUVZLS/BcbtJUSbFw8
         1uAkslZ1bAAZz65w6MDFQcmKGxVB3q/a+gKI3hKS+ifX579xpi7W0LDE2kmY+Ne9kbTQ
         6/+g==
X-Gm-Message-State: ACgBeo3eAi6MRQpxHdzNEwkPCXnEtfrb0xdi3brBs2kvjrermndLH6GJ
        Kz4VN/aa0aYsR4ndtTz/PUClZhvIS1s1g3veFAdB+VSh
X-Google-Smtp-Source: AA6agR6MJBFV30kggXjBciLw1N20HUZUrzC3XwFJPgBObA70KlFFBX9l3ZmlHogoX1FMf/008T1JgavgG76JmBSrvlQ=
X-Received: by 2002:a02:2403:0:b0:342:9303:cafb with SMTP id
 f3-20020a022403000000b003429303cafbmr3992525jaa.231.1659740192165; Fri, 05
 Aug 2022 15:56:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220725085130.11553-1-memxor@gmail.com>
In-Reply-To: <20220725085130.11553-1-memxor@gmail.com>
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Sat, 6 Aug 2022 00:55:55 +0200
Message-ID: <CAP01T740E3SmW98hxooFwiB6zZ58wV2iQSTJZg-zKNYWg+x1Ow@mail.gmail.com>
Subject: Re: [PATCH bpf-next] net: netfilter: Remove ifdefs for code shared by
 BPF and ctnetlink
To:     bpf@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Jul 2022 at 10:51, Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
>
> The current ifdefry for code shared by the BPF and ctnetlink side looks
> ugly. As per Pablo's request, simplify this by unconditionally compiling
> in the code. This can be revisited when the shared code between the two
> grows further.
>
> Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---

Pablo, presumably this needs your ack before it can be applied, as it
is marked Needs Ack in patchwork.

>  include/net/netfilter/nf_conntrack_core.h | 6 ------
>  net/netfilter/nf_conntrack_core.c         | 6 ------
>  2 files changed, 12 deletions(-)
>
> diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
> index 3cd3a6e631aa..b2b9de70d9f4 100644
> --- a/include/net/netfilter/nf_conntrack_core.h
> +++ b/include/net/netfilter/nf_conntrack_core.h
> @@ -86,10 +86,6 @@ extern spinlock_t nf_conntrack_expect_lock;
>
>  /* ctnetlink code shared by both ctnetlink and nf_conntrack_bpf */
>
> -#if (IS_BUILTIN(CONFIG_NF_CONNTRACK) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF)) || \
> -    (IS_MODULE(CONFIG_NF_CONNTRACK) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF_MODULES) || \
> -    IS_ENABLED(CONFIG_NF_CT_NETLINK))
> -
>  static inline void __nf_ct_set_timeout(struct nf_conn *ct, u64 timeout)
>  {
>         if (timeout > INT_MAX)
> @@ -101,6 +97,4 @@ int __nf_ct_change_timeout(struct nf_conn *ct, u64 cta_timeout);
>  void __nf_ct_change_status(struct nf_conn *ct, unsigned long on, unsigned long off);
>  int nf_ct_change_status_common(struct nf_conn *ct, unsigned int status);
>
> -#endif
> -
>  #endif /* _NF_CONNTRACK_CORE_H */
> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> index 66a0aa8dbc3b..afe02772c010 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -2787,10 +2787,6 @@ int nf_conntrack_init_net(struct net *net)
>         return ret;
>  }
>
> -#if (IS_BUILTIN(CONFIG_NF_CONNTRACK) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF)) || \
> -    (IS_MODULE(CONFIG_NF_CONNTRACK) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF_MODULES) || \
> -    IS_ENABLED(CONFIG_NF_CT_NETLINK))
> -
>  /* ctnetlink code shared by both ctnetlink and nf_conntrack_bpf */
>
>  int __nf_ct_change_timeout(struct nf_conn *ct, u64 timeout)
> @@ -2846,5 +2842,3 @@ int nf_ct_change_status_common(struct nf_conn *ct, unsigned int status)
>         return 0;
>  }
>  EXPORT_SYMBOL_GPL(nf_ct_change_status_common);
> -
> -#endif
> --
> 2.34.1
>
