Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1DC36820FE
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 01:48:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbjAaAsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 19:48:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbjAaAsY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 19:48:24 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AF3E1E298;
        Mon, 30 Jan 2023 16:48:23 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id ml19so13614416ejb.0;
        Mon, 30 Jan 2023 16:48:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FSOKizBkssF6gcJAH1aaDSmtjOKhZVdKztN2lJ+lsd4=;
        b=F4TRmXccWwiU95TC4h+ggypGTwLpOMAiWeL9xnaZjt/ht3yf5TDOTy81pwbWBKMe6F
         /FI0voBc6pKSRze2rv6DZN7KyOVCUzEz5tOlkWd9bDgLLu0dORZPbdWQMq135EJlkVPr
         CPwaZyJBVy6dyAo0b6PiV46TZ3ZhojOD3O73wM5daeTKbCWDJUihtMC+mUz9Y7eauRbG
         h9ajX3oJjHFGbOd/eUegJuXCFBcOaA66j/kh45KiEEo/a9XuxnCeomo6bGYn/sR1wfVG
         c9BHZ1l2cGZoDBVp61pK4Hd6Wtivx207PPcrxBOrOJMUORMKYICdnmLcWWTn3zluPhFI
         epnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FSOKizBkssF6gcJAH1aaDSmtjOKhZVdKztN2lJ+lsd4=;
        b=QlzNUq351bpxAPT3xImmF9MzX3CbkEJToontkFKjlwlea63vYWqUwTgI6qmmUgx79N
         /r+w8DkTQ0LcSHQ6JCagiWl7YNJ1BTMuC1zu1fTLL1KPugzrrz2OUoEvVaxjfHBqoS3S
         Ur2CLyZZRRiLYfH7olo9Fely0mIq6o2SFvXKFcR35x9Jrin8vND5/yWyLmptnL+6VSa7
         UbR0CK2/QTWDMkD+uJLOEBvoqG/M/g0x6qDI7BmxU7827qhEUswWUopRhqnkemKrs4+L
         aGYg3xhnLlIn/VLF6Dq8K2QbNQaQr/ldarSP4I4h60SgT+ejr0ewcvdWKBr1VbckzYwy
         k5qA==
X-Gm-Message-State: AO0yUKUjn9H2ew05/y2LmuUmJJiRjp9w4xA0J5EY4pXVmItfM4ThNa13
        8x82OQF6Ti0ij4brFR4b9PqXkaYKWwqqAv23oA0=
X-Google-Smtp-Source: AK7set9F8P1vnCQAqYXmd7qsFLPU73eR1dk7k4B37DGQ09P/JoED1x+fsPKFbCO7oy+N5mr7pyVKuF6p/hIkduZllrA=
X-Received: by 2002:a17:907:2cea:b0:88b:93c0:34f2 with SMTP id
 hz10-20020a1709072cea00b0088b93c034f2mr530473ejc.296.1675126101657; Mon, 30
 Jan 2023 16:48:21 -0800 (PST)
MIME-Version: 1.0
References: <20230127191703.3864860-1-joannelkoong@gmail.com> <20230127191703.3864860-4-joannelkoong@gmail.com>
In-Reply-To: <20230127191703.3864860-4-joannelkoong@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 30 Jan 2023 16:48:09 -0800
Message-ID: <CAEf4BzYK2JOtChh4VNTg4L9-u9kay3zzG8X6GqTkak22E37wig@mail.gmail.com>
Subject: Re: [PATCH v9 bpf-next 3/5] bpf: Add skb dynptrs
To:     Joanne Koong <joannelkoong@gmail.com>
Cc:     bpf@vger.kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@kernel.org, ast@kernel.org, netdev@vger.kernel.org,
        memxor@gmail.com, kernel-team@fb.com
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

On Fri, Jan 27, 2023 at 11:18 AM Joanne Koong <joannelkoong@gmail.com> wrote:
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
> read-only (bpf_dynptr_write() will return an error and bpf_dynptr_data()
> will return a data slice that is read-only where any writes to it will
> be rejected by the verifier).
>
> For reads and writes through the bpf_dynptr_read() and bpf_dynptr_write()
> interfaces, reading and writing from/to data in the head as well as from/to
> non-linear paged buffers is supported. For data slices (through the
> bpf_dynptr_data() interface), if the data is in a paged buffer, the user
> must first call bpf_skb_pull_data() to pull the data into the linear
> portion.
>
> Any bpf_dynptr_write() automatically invalidates any prior data slices
> to the skb dynptr. This is because a bpf_dynptr_write() may be writing
> to data in a paged buffer, so it will need to pull the buffer first into
> the head. The reason it needs to be pulled instead of writing directly to
> the paged buffers is because they may be cloned (only the head of the skb
> is by default uncloned). As such, any bpf_dynptr_write() will
> automatically have its prior data slices invalidated, even if the write
> is to data in the skb head (the verifier has no way of differentiating
> whether the write is to the head or paged buffers during program load
> time). Please note as well that any other helper calls that change the
> underlying packet buffer (eg bpf_skb_pull_data()) invalidates any data
> slices of the skb dynptr as well. The stack trace for this is
> check_helper_call() -> clear_all_pkt_pointers() ->
> __clear_all_pkt_pointers() -> mark_reg_unknown().
>
> For examples of how skb dynptrs can be used, please see the attached
> selftests.
>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---
>  include/linux/bpf.h            |  82 +++++++++------
>  include/linux/filter.h         |  18 ++++
>  include/uapi/linux/bpf.h       |  37 +++++--
>  kernel/bpf/btf.c               |  18 ++++
>  kernel/bpf/helpers.c           |  95 ++++++++++++++---
>  kernel/bpf/verifier.c          | 185 ++++++++++++++++++++++++++-------
>  net/core/filter.c              |  60 ++++++++++-
>  tools/include/uapi/linux/bpf.h |  37 +++++--
>  8 files changed, 432 insertions(+), 100 deletions(-)
>

[...]

>  static const struct bpf_func_proto bpf_dynptr_write_proto = {
> @@ -1560,6 +1595,8 @@ static const struct bpf_func_proto bpf_dynptr_write_proto = {
>
>  BPF_CALL_3(bpf_dynptr_data, const struct bpf_dynptr_kern *, ptr, u32, offset, u32, len)
>  {
> +       enum bpf_dynptr_type type;
> +       void *data;
>         int err;
>
>         if (!ptr->data)
> @@ -1569,10 +1606,36 @@ BPF_CALL_3(bpf_dynptr_data, const struct bpf_dynptr_kern *, ptr, u32, offset, u3
>         if (err)
>                 return 0;
>
> -       if (bpf_dynptr_is_rdonly(ptr))
> -               return 0;
> +       type = bpf_dynptr_get_type(ptr);
> +
> +       switch (type) {
> +       case BPF_DYNPTR_TYPE_LOCAL:
> +       case BPF_DYNPTR_TYPE_RINGBUF:
> +               if (bpf_dynptr_is_rdonly(ptr))
> +                       return 0;

will something break if we return ptr->data for read-only LOCAL/RINGBUF dynptr?

> +
> +               data = ptr->data;
> +               break;
> +       case BPF_DYNPTR_TYPE_SKB:
> +       {
> +               struct sk_buff *skb = ptr->data;
>

[...]
