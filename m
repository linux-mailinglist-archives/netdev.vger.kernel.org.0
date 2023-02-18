Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE5469B734
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 01:55:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbjBRAzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 19:55:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjBRAzR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 19:55:17 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C3195EC82;
        Fri, 17 Feb 2023 16:55:16 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id i28so10100001eda.8;
        Fri, 17 Feb 2023 16:55:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=CNmN9i9I04usvowrOynVaiHCZz/BOIYMI3jRO+izgks=;
        b=Pz80ikC3QUwINLyEWuiLFy6z5SpyCZQTxcbnCzzC7P+VZdavB3flh/bGIia5GC4rcS
         b9PiYZCyRP7QHe2TZuoS9+RBwAOZFWQ4F0UrgCF181qNCC3Sm2y1evJnyUwZ9fnG4Kk2
         HPNocltC6SM0GO5RGbRAgDOhiRz7duKQdAqGOVVdH6nTyKcJr887i4rs5F3cAqVSr21q
         VsI6D9VS6dQjISwzhgC2XLLyuqPhKWSIfTlUBvb205HF32GTq7V+6k017E/ZRHj9hmJV
         vOSC6PKDjppkag9MkI/f/Sesmr7sbd761/gT1C/HxmRh6i7lMZSarZlo7rnQCDYjVZuO
         hF3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CNmN9i9I04usvowrOynVaiHCZz/BOIYMI3jRO+izgks=;
        b=52IuMWn+r54EHDlH1bocgLlAPo/uOxVJEVOFSnb+0W0g4b3E2tDD3EimHEWKchhgdM
         VyUoVTyQkAp3RO5FyEt2IDE36whR7ovZ3BLLZaL5TlGiThepzuZl9eN9D6E0IjJEDn+I
         hVn9OxriGAn7dnZLCdish+2mvEVDFiCAYkN62SoFSg9/IYaAbGtwshMrywomfdglHtm8
         CXUOODQQtzz5glOlWALemfzCqorGco8tZBD77mm7JBmv9qNMLFRxO+7pY0eeX9frqQYi
         QawP+NkBdSi/PGSjehbXTi2TVR7f1yO1F2O252wwC1dltHwFuVq2t26xS4KehXXzf0iV
         ylxA==
X-Gm-Message-State: AO0yUKXpaaI1ZDPsIxxwK8+EoebtQSAmaLBqzlEGZ/VomK2jjE8+GnQP
        hPVEBbjTfEgWZgzyGNw15HbqIEiPoCFIuh3MRzs=
X-Google-Smtp-Source: AK7set9Ix9rF5QlyxVAzzhxH/P0WvbwlMmvB2ClF+EorJYBEJV935ED3KnVrCQ/Sv3IeGgCjpkDnanwCV1C+Wy0p3rA=
X-Received: by 2002:a17:906:f88f:b0:8b0:7e1d:f6fa with SMTP id
 lg15-20020a170906f88f00b008b07e1df6famr1167986ejb.15.1676681714931; Fri, 17
 Feb 2023 16:55:14 -0800 (PST)
MIME-Version: 1.0
References: <20230216225524.1192789-1-joannelkoong@gmail.com> <20230216225524.1192789-7-joannelkoong@gmail.com>
In-Reply-To: <20230216225524.1192789-7-joannelkoong@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 17 Feb 2023 16:55:02 -0800
Message-ID: <CAEf4BzYxAi9ECwW33EJAVbcDuF7qFAXwbMeyLBSzNpsSqQEiGw@mail.gmail.com>
Subject: Re: [PATCH v10 bpf-next 6/9] bpf: Add skb dynptrs
To:     Joanne Koong <joannelkoong@gmail.com>
Cc:     bpf@vger.kernel.org, martin.lau@kernel.org, andrii@kernel.org,
        memxor@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 16, 2023 at 2:56 PM Joanne Koong <joannelkoong@gmail.com> wrote:
>
> Add skb dynptrs, which are dynptrs whose underlying pointer points
> to a skb. The dynptr acts on skb data. skb dynptrs have two main
> benefits. One is that they allow operations on sizes that are not
> statically known at compile-time (eg variable-sized accesses).
> Another is that parsing the packet data through dynptrs (instead of
> through direct access of skb->data and skb->data_end) can be more
> ergonomic and less brittle (eg does not need manual if checking for
> being within bounds of data_end).
>
> For bpf prog types that don't support writes on skb data, the dynptr is
> read-only (bpf_dynptr_write() will return an error)
>
> For reads and writes through the bpf_dynptr_read() and bpf_dynptr_write()
> interfaces, reading and writing from/to data in the head as well as from/to
> non-linear paged buffers is supported. Data slices through the
> bpf_dynptr_data API are not supported; instead bpf_dynptr_slice() and
> bpf_dynptr_slice_rdwr() (added in subsequent commit) should be used.
>
> For examples of how skb dynptrs can be used, please see the attached
> selftests.
>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---
>  include/linux/bpf.h            | 14 ++++++-
>  include/linux/filter.h         | 18 ++++++++
>  include/uapi/linux/bpf.h       | 14 ++++++-
>  kernel/bpf/btf.c               | 18 ++++++++
>  kernel/bpf/helpers.c           | 76 +++++++++++++++++++++++++++-------
>  kernel/bpf/verifier.c          | 70 ++++++++++++++++++++++++++++++-
>  net/core/filter.c              | 67 ++++++++++++++++++++++++++++++
>  tools/include/uapi/linux/bpf.h | 14 ++++++-
>  8 files changed, 270 insertions(+), 21 deletions(-)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 296841a31749..3d18be35a5e6 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -607,11 +607,14 @@ enum bpf_type_flag {
>          */
>         NON_OWN_REF             = BIT(14 + BPF_BASE_TYPE_BITS),
>
> +       /* DYNPTR points to sk_buff */
> +       DYNPTR_TYPE_SKB         = BIT(15 + BPF_BASE_TYPE_BITS),
> +
>         __BPF_TYPE_FLAG_MAX,
>         __BPF_TYPE_LAST_FLAG    = __BPF_TYPE_FLAG_MAX - 1,
>  };
>
> -#define DYNPTR_TYPE_FLAG_MASK  (DYNPTR_TYPE_LOCAL | DYNPTR_TYPE_RINGBUF)
> +#define DYNPTR_TYPE_FLAG_MASK  (DYNPTR_TYPE_LOCAL | DYNPTR_TYPE_RINGBUF | DYNPTR_TYPE_SKB)
>
>  /* Max number of base types. */
>  #define BPF_BASE_TYPE_LIMIT    (1UL << BPF_BASE_TYPE_BITS)
> @@ -1146,6 +1149,8 @@ enum bpf_dynptr_type {
>         BPF_DYNPTR_TYPE_LOCAL,
>         /* Underlying data is a ringbuf record */
>         BPF_DYNPTR_TYPE_RINGBUF,
> +       /* Underlying data is a sk_buff */
> +       BPF_DYNPTR_TYPE_SKB,
>  };
>
>  int bpf_dynptr_check_size(u32 size);
> @@ -2846,6 +2851,8 @@ u32 bpf_sock_convert_ctx_access(enum bpf_access_type type,
>                                 struct bpf_insn *insn_buf,
>                                 struct bpf_prog *prog,
>                                 u32 *target_size);
> +int bpf_dynptr_from_skb_rdonly(struct sk_buff *skb, u64 flags,
> +                              struct bpf_dynptr_kern *ptr);
>  #else
>  static inline bool bpf_sock_common_is_valid_access(int off, int size,
>                                                    enum bpf_access_type type,
> @@ -2867,6 +2874,11 @@ static inline u32 bpf_sock_convert_ctx_access(enum bpf_access_type type,
>  {
>         return 0;
>  }
> +static inline int bpf_dynptr_from_skb_rdonly(struct sk_buff *skb, u64 flags,
> +                                            struct bpf_dynptr_kern *ptr)
> +{
> +       return 0;


should this return -EOPNOTSUPP instead?

> +}
>  #endif
>
>  #ifdef CONFIG_INET

[...]
