Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34D4C5AF799
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 00:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbiIFWCj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 18:02:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbiIFWCi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 18:02:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DB069C529;
        Tue,  6 Sep 2022 15:02:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5816CB81A77;
        Tue,  6 Sep 2022 22:02:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 029FDC4347C;
        Tue,  6 Sep 2022 22:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662501755;
        bh=nBcmQDHBLIYhVQ/UQfdJ+Orf/69hVWxI6lUL2Qm1X1g=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=WcLDCfbTwqsG6z6YCelGNooRWR96NzZNUSDfnFHgzznR0Iw5VrfZWlFPLQUq/cTkc
         ZJPBM7mcW8oYHSSqXhL2AIIBQ1UuOLogIrQxztvwUH/uwUqQ/3BYuOOxHL69LZ882a
         JqNZeuoXChxDiQzyCj+Nu/GJOsyoICeyvC+7UIotuYHQZ1ubL532/ze1s6kmYNfeUI
         5vfKR69Fu5uY4PpAViW3LKWbXPg+hfLem9pjbOpnNMw25CMCuSFhU57YXlrDjCpCKB
         X5+4/8CXKz4EqaXDqSscRx3qFd3SSLmqQMRg8DGn7wxIQUFWP2B9VvnxozUQpMEoj5
         0VdiggOU1vG/Q==
Received: by mail-oo1-f47.google.com with SMTP id d63-20020a4a5242000000b0044880019622so2157153oob.13;
        Tue, 06 Sep 2022 15:02:34 -0700 (PDT)
X-Gm-Message-State: ACgBeo02j5Fr0afKgaQQyxLC/ZNBgy1XbcA6XuT6LQ1EqKklr54foFXh
        +Kyn88026BqfaJ3wIbQ99/NbznYDC4WjTk3b7Gk=
X-Google-Smtp-Source: AA6agR4BP2cI9xGbtAsE+DjrSMLKis2GHtwL9O3p6Eex/reIoV3LGsswg1JZ5egzZfZrfYHKEq/dsx7pZfok/GNmE80=
X-Received: by 2002:a4a:e60e:0:b0:448:aea3:3557 with SMTP id
 f14-20020a4ae60e000000b00448aea33557mr254915oot.50.1662501754021; Tue, 06 Sep
 2022 15:02:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220905193359.969347-1-toke@redhat.com> <20220905193359.969347-3-toke@redhat.com>
In-Reply-To: <20220905193359.969347-3-toke@redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 6 Sep 2022 15:02:23 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7U6twQbjXLTaEkCpddAaauaEb0k=g5YnCjmo5TtOx6iA@mail.gmail.com>
Message-ID: <CAPhsuW7U6twQbjXLTaEkCpddAaauaEb0k=g5YnCjmo5TtOx6iA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 2/3] bpf: Expand map key argument of
 bpf_redirect_map to u64
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 5, 2022 at 12:34 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> For queueing packets in XDP we want to add a new redirect map type with
> support for 64-bit indexes. To prepare fore this, expand the width of the
> 'key' argument to the bpf_redirect_map() helper. Since BPF registers are
> always 64-bit, this should be safe to do after the fact.
>
> Reviewed-by: Stanislav Fomichev <sdf@google.com>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

Acked-by: Song Liu <song@kernel.org>

> ---
>  include/linux/bpf.h      |  2 +-
>  include/linux/filter.h   | 12 ++++++------
>  include/uapi/linux/bpf.h |  2 +-
>  kernel/bpf/cpumap.c      |  4 ++--
>  kernel/bpf/devmap.c      |  4 ++--
>  kernel/bpf/verifier.c    |  2 +-
>  net/core/filter.c        |  4 ++--
>  net/xdp/xskmap.c         |  4 ++--
>  8 files changed, 17 insertions(+), 17 deletions(-)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 9c1674973e03..222cba23e6d9 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -134,7 +134,7 @@ struct bpf_map_ops {
>         struct bpf_local_storage __rcu ** (*map_owner_storage_ptr)(void *=
owner);
>
>         /* Misc helpers.*/
> -       int (*map_redirect)(struct bpf_map *map, u32 ifindex, u64 flags);
> +       int (*map_redirect)(struct bpf_map *map, u64 key, u64 flags);
>
>         /* map_meta_equal must be implemented for maps that can be
>          * used as an inner map.  It is a runtime check to ensure
> diff --git a/include/linux/filter.h b/include/linux/filter.h
> index 527ae1d64e27..eff295509f03 100644
> --- a/include/linux/filter.h
> +++ b/include/linux/filter.h
> @@ -637,13 +637,13 @@ struct bpf_nh_params {
>  };
>
>  struct bpf_redirect_info {
> -       u32 flags;
> -       u32 tgt_index;
> +       u64 tgt_index;
>         void *tgt_value;
>         struct bpf_map *map;
> +       u32 flags;
> +       u32 kern_flags;
>         u32 map_id;
>         enum bpf_map_type map_type;
> -       u32 kern_flags;
>         struct bpf_nh_params nh;
>  };
>
> @@ -1493,7 +1493,7 @@ static inline bool bpf_sk_lookup_run_v6(struct net =
*net, int protocol,
>  }
>  #endif /* IS_ENABLED(CONFIG_IPV6) */
>
> -static __always_inline int __bpf_xdp_redirect_map(struct bpf_map *map, u=
32 ifindex,
> +static __always_inline int __bpf_xdp_redirect_map(struct bpf_map *map, u=
64 index,
>                                                   u64 flags, const u64 fl=
ag_mask,
>                                                   void *lookup_elem(struc=
t bpf_map *map, u32 key))
>  {
> @@ -1504,7 +1504,7 @@ static __always_inline int __bpf_xdp_redirect_map(s=
truct bpf_map *map, u32 ifind
>         if (unlikely(flags & ~(action_mask | flag_mask)))
>                 return XDP_ABORTED;
>
> -       ri->tgt_value =3D lookup_elem(map, ifindex);
> +       ri->tgt_value =3D lookup_elem(map, index);
>         if (unlikely(!ri->tgt_value) && !(flags & BPF_F_BROADCAST)) {
>                 /* If the lookup fails we want to clear out the state in =
the
>                  * redirect_info struct completely, so that if an eBPF pr=
ogram
> @@ -1516,7 +1516,7 @@ static __always_inline int __bpf_xdp_redirect_map(s=
truct bpf_map *map, u32 ifind
>                 return flags & action_mask;
>         }
>
> -       ri->tgt_index =3D ifindex;
> +       ri->tgt_index =3D index;
>         ri->map_id =3D map->id;
>         ri->map_type =3D map->map_type;
>
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 837c0f9b7fdd..c6d37ac2b87c 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -2629,7 +2629,7 @@ union bpf_attr {
>   *     Return
>   *             0 on success, or a negative error in case of failure.
>   *
> - * long bpf_redirect_map(struct bpf_map *map, u32 key, u64 flags)
> + * long bpf_redirect_map(struct bpf_map *map, u64 key, u64 flags)
>   *     Description
>   *             Redirect the packet to the endpoint referenced by *map* a=
t
>   *             index *key*. Depending on its type, this *map* can contai=
n
> diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
> index b5ba34ddd4b6..39ed08a2bb52 100644
> --- a/kernel/bpf/cpumap.c
> +++ b/kernel/bpf/cpumap.c
> @@ -668,9 +668,9 @@ static int cpu_map_get_next_key(struct bpf_map *map, =
void *key, void *next_key)
>         return 0;
>  }
>
> -static int cpu_map_redirect(struct bpf_map *map, u32 ifindex, u64 flags)
> +static int cpu_map_redirect(struct bpf_map *map, u64 index, u64 flags)
>  {
> -       return __bpf_xdp_redirect_map(map, ifindex, flags, 0,
> +       return __bpf_xdp_redirect_map(map, index, flags, 0,
>                                       __cpu_map_lookup_elem);
>  }
>
> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> index f9a87dcc5535..d01e4c55b376 100644
> --- a/kernel/bpf/devmap.c
> +++ b/kernel/bpf/devmap.c
> @@ -992,14 +992,14 @@ static int dev_map_hash_update_elem(struct bpf_map =
*map, void *key, void *value,
>                                          map, key, value, map_flags);
>  }
>
> -static int dev_map_redirect(struct bpf_map *map, u32 ifindex, u64 flags)
> +static int dev_map_redirect(struct bpf_map *map, u64 ifindex, u64 flags)
>  {
>         return __bpf_xdp_redirect_map(map, ifindex, flags,
>                                       BPF_F_BROADCAST | BPF_F_EXCLUDE_ING=
RESS,
>                                       __dev_map_lookup_elem);
>  }
>
> -static int dev_hash_map_redirect(struct bpf_map *map, u32 ifindex, u64 f=
lags)
> +static int dev_hash_map_redirect(struct bpf_map *map, u64 ifindex, u64 f=
lags)
>  {
>         return __bpf_xdp_redirect_map(map, ifindex, flags,
>                                       BPF_F_BROADCAST | BPF_F_EXCLUDE_ING=
RESS,
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 068b20ed34d2..844a44694b6f 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -14169,7 +14169,7 @@ static int do_misc_fixups(struct bpf_verifier_env=
 *env)
>                         BUILD_BUG_ON(!__same_type(ops->map_peek_elem,
>                                      (int (*)(struct bpf_map *map, void *=
value))NULL));
>                         BUILD_BUG_ON(!__same_type(ops->map_redirect,
> -                                    (int (*)(struct bpf_map *map, u32 if=
index, u64 flags))NULL));
> +                                    (int (*)(struct bpf_map *map, u64 in=
dex, u64 flags))NULL));
>                         BUILD_BUG_ON(!__same_type(ops->map_for_each_callb=
ack,
>                                      (int (*)(struct bpf_map *map,
>                                               bpf_callback_t callback_fn,
> diff --git a/net/core/filter.c b/net/core/filter.c
> index ee768bb5b5ab..285eaee2b373 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -4408,10 +4408,10 @@ static const struct bpf_func_proto bpf_xdp_redire=
ct_proto =3D {
>         .arg2_type      =3D ARG_ANYTHING,
>  };
>
> -BPF_CALL_3(bpf_xdp_redirect_map, struct bpf_map *, map, u32, ifindex,
> +BPF_CALL_3(bpf_xdp_redirect_map, struct bpf_map *, map, u64, key,
>            u64, flags)
>  {
> -       return map->ops->map_redirect(map, ifindex, flags);
> +       return map->ops->map_redirect(map, key, flags);
>  }
>
>  static const struct bpf_func_proto bpf_xdp_redirect_map_proto =3D {
> diff --git a/net/xdp/xskmap.c b/net/xdp/xskmap.c
> index acc8e52a4f5f..771d0fa90ef5 100644
> --- a/net/xdp/xskmap.c
> +++ b/net/xdp/xskmap.c
> @@ -231,9 +231,9 @@ static int xsk_map_delete_elem(struct bpf_map *map, v=
oid *key)
>         return 0;
>  }
>
> -static int xsk_map_redirect(struct bpf_map *map, u32 ifindex, u64 flags)
> +static int xsk_map_redirect(struct bpf_map *map, u64 index, u64 flags)
>  {
> -       return __bpf_xdp_redirect_map(map, ifindex, flags, 0,
> +       return __bpf_xdp_redirect_map(map, index, flags, 0,
>                                       __xsk_map_lookup_elem);
>  }
>
> --
> 2.37.2
>
