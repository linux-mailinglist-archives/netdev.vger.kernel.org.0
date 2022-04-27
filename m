Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E5695123BF
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 22:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235122AbiD0UTY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 16:19:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237936AbiD0UTN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 16:19:13 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A17FE48E42;
        Wed, 27 Apr 2022 13:15:57 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id m6so290347iob.4;
        Wed, 27 Apr 2022 13:15:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=StZFkhkWluC1Znj+MNB2QO5yO4V9dUAmo6rSZi6ENF8=;
        b=jmMBeALmx5s5xeXDPJ5GbHnAQFhmJhE22Luh8WiUNW+cmy28ysLn/vagbVllDxx30r
         /RmZ36gmqFNWlaXpt8fAHoe2tMM+KXksQ1brRsRwGi1ri/UBFkO5N/qMELlf+dXI6g09
         zZYnkOOl/iZ6skhH20TnhTCZuGfBR7ZzqXc/6vl2Ox/x1x/l1CzGRIwSt1we0GmmhsDT
         YMb7nK022hbb66Ds0sAwM/Dh7rU/FViCGbBbrv0hOUxmiJYHkMmLUILC0N1Ur9RKVDzE
         gLBIkf6LS692kmqOJpkcInlIv9yzFU45enHayP1kNl2/5NVptk+vD31bE1MVjf/+DW6H
         qThg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=StZFkhkWluC1Znj+MNB2QO5yO4V9dUAmo6rSZi6ENF8=;
        b=QrG242vGDRYOgHUdYRwMwVTZ6DLQiYY2gYYYPNO1qWFxLWpniu1N8jhxHcLFqwmG6G
         RT0+unLitvpnmqQytdFiZfZPoKIlZyJUxe0PhwjIwTwZ7x5C0aMASbCQNMAGemSXvnHf
         LmAxAlSH9lfvXi03yLCWSWZ0GzzkhEGfZPUQcLzjvR+GSzv8zHEy4QoeSOo/TrRk253X
         74kRJaFbOXWBroTYkb11Nf67vFulrXnCrsDGAI5gHquIkSu3LmZ+BQdvV611fNjGaNKX
         +Ys32gVZ0xwGmDlZTrmvJ46+Wyzkg2P9BkULITHvOi08wp9VsbJrNhrrA/ETqtfOBMkw
         AWdw==
X-Gm-Message-State: AOAM532pI30D1BHZwnSzlzblT322b80FQs0CrVAVGoJ8uCplgOgTePH4
        NEm7//eRYfiq3YdL6b/e0nj01fcmFGNOlZ9cYHI=
X-Google-Smtp-Source: ABdhPJy3QpIrZ+jps6RdB9IjIeQHnMIaW8A5MmytFOn9UJasHI9nTBt5TAX76Xvuxor2kJGuKjJKH4JwJ+TNLzvNFS0=
X-Received: by 2002:a05:6638:3393:b0:32a:93cd:7e48 with SMTP id
 h19-20020a056638339300b0032a93cd7e48mr12912852jav.93.1651090557001; Wed, 27
 Apr 2022 13:15:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220425184149.1173545-1-ctakshak@fb.com>
In-Reply-To: <20220425184149.1173545-1-ctakshak@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 27 Apr 2022 13:15:46 -0700
Message-ID: <CAEf4BzZ6oTz=gojxFvPKnrJ_cV_eS_Ra7YZDiJvfTdteEC8d2w@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 1/2] bpf: Extend batch operations for
 map-in-map bpf-maps
To:     Takshak Chahande <ctakshak@fb.com>, Yonghong Song <yhs@fb.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, ndixit@fb.com,
        Martin Lau <kafai@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>
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

On Mon, Apr 25, 2022 at 11:42 AM Takshak Chahande <ctakshak@fb.com> wrote:
>
> This patch extends batch operations support for map-in-map map-types:
> BPF_MAP_TYPE_HASH_OF_MAPS and BPF_MAP_TYPE_ARRAY_OF_MAPS
>
> A usecase where outer HASH map holds hundred of VIP entries and its
> associated reuse-ports per VIP stored in REUSEPORT_SOCKARRAY type
> inner map, needs to do batch operation for performance gain.
>
> This patch leverages the exiting generic functions for most of the batch
> operations. As map-in-map's value contains the actual reference of the inner map,
> for BPF_MAP_TYPE_HASH_OF_MAPS type, it needed an extra step to fetch the
> map_id from the reference value.
>
> selftests are added in next patch that has v1->v3 changes
>
> Signed-off-by: Takshak Chahande <ctakshak@fb.com>
> ---

cc'ing Yonghong who was involved in designing and implementing these
batch APIs. PTAL when you get a chance, thanks!

>  kernel/bpf/arraymap.c |  2 ++
>  kernel/bpf/hashtab.c  | 12 ++++++++++--
>  2 files changed, 12 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
> index 7f145aefbff8..f0852b6617cc 100644
> --- a/kernel/bpf/arraymap.c
> +++ b/kernel/bpf/arraymap.c
> @@ -1344,6 +1344,8 @@ const struct bpf_map_ops array_of_maps_map_ops = {
>         .map_fd_put_ptr = bpf_map_fd_put_ptr,
>         .map_fd_sys_lookup_elem = bpf_map_fd_sys_lookup_elem,
>         .map_gen_lookup = array_of_map_gen_lookup,
> +       .map_lookup_batch = generic_map_lookup_batch,
> +       .map_update_batch = generic_map_update_batch,
>         .map_check_btf = map_check_no_btf,
>         .map_btf_name = "bpf_array",
>         .map_btf_id = &array_of_maps_map_btf_id,
> diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
> index c68fbebc8c00..fd537bfba84c 100644
> --- a/kernel/bpf/hashtab.c
> +++ b/kernel/bpf/hashtab.c
> @@ -139,7 +139,7 @@ static inline bool htab_use_raw_lock(const struct bpf_htab *htab)
>
>  static void htab_init_buckets(struct bpf_htab *htab)
>  {
> -       unsigned i;
> +       unsigned int i;
>
>         for (i = 0; i < htab->n_buckets; i++) {
>                 INIT_HLIST_NULLS_HEAD(&htab->buckets[i].head, i);
> @@ -1594,7 +1594,7 @@ __htab_map_lookup_and_delete_batch(struct bpf_map *map,
>         void __user *uvalues = u64_to_user_ptr(attr->batch.values);
>         void __user *ukeys = u64_to_user_ptr(attr->batch.keys);
>         void __user *ubatch = u64_to_user_ptr(attr->batch.in_batch);
> -       u32 batch, max_count, size, bucket_size;
> +       u32 batch, max_count, size, bucket_size, map_id;
>         struct htab_elem *node_to_free = NULL;
>         u64 elem_map_flags, map_flags;
>         struct hlist_nulls_head *head;
> @@ -1719,6 +1719,13 @@ __htab_map_lookup_and_delete_batch(struct bpf_map *map,
>                         }
>                 } else {
>                         value = l->key + roundup_key_size;
> +                       if (map->map_type == BPF_MAP_TYPE_HASH_OF_MAPS) {
> +                               struct bpf_map **inner_map = value;
> +                                /* Actual value is the id of the inner map */
> +                               map_id = map->ops->map_fd_sys_lookup_elem(*inner_map);
> +                               value = &map_id;
> +                       }
> +
>                         if (elem_map_flags & BPF_F_LOCK)
>                                 copy_map_value_locked(map, dst_val, value,
>                                                       true);
> @@ -2425,6 +2432,7 @@ const struct bpf_map_ops htab_of_maps_map_ops = {
>         .map_fd_sys_lookup_elem = bpf_map_fd_sys_lookup_elem,
>         .map_gen_lookup = htab_of_map_gen_lookup,
>         .map_check_btf = map_check_no_btf,
> +       BATCH_OPS(htab),
>         .map_btf_name = "bpf_htab",
>         .map_btf_id = &htab_of_maps_map_btf_id,
>  };
> --
> 2.30.2
>
