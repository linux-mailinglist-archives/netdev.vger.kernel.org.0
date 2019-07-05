Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DDEB60D9C
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 00:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727577AbfGEWEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 18:04:40 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:34274 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725813AbfGEWEk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 18:04:40 -0400
Received: by mail-io1-f65.google.com with SMTP id k8so22106954iot.1
        for <netdev@vger.kernel.org>; Fri, 05 Jul 2019 15:04:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=OVtvfpSoOIsfL09a8+f0FZvtld36cPLdAovABb8C+WI=;
        b=pC2d604RG2225SWqSI0F/60mLgBDf3DlMBkb5zbYSL/0KR4UuHX94l1Li5DcOaRb3V
         1fg6yCuq4z/PK95RiKdFMWmF33sH1NvS4bwQmfzSHS4mA9ghe8vTx2ICwAdx5x8bTnHL
         /KBJpGrhwGNV3PRY/sBPZbKuCLeNxgupXLGKKc6m23g1pOD8PtxGzIOsQYGjwS+xTpLv
         3IJmjWGUPB9WbAUJMLGPlyiNXf3N0yLLJn+pYBGwEy9qWUszOV+dH3BWw3qpO5y6yRXl
         RnUJrCxV67tpThQ20UNlMjj/w3G3jJqE5FNNAG+5wSVIq8/MUEsA3kb/xUqs1GUy6s14
         hm6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=OVtvfpSoOIsfL09a8+f0FZvtld36cPLdAovABb8C+WI=;
        b=KoMUE63pfEogiBTAVdxyInYIxbTI4D3QgRiL7tOmlt/lD2tUL/8Z7Zh84gwbBuUIQj
         6hJWwq5zriaUJxtjnkdRcUy5GxwEQvLNGsCpXFB6ZyyAa+nzJCFVCdMpDBPA82AZe35v
         agmmBVBfi61qft3XJ13UZelxf4MEdnx5z96F/NNhsafnncbmayWrJ3EByMtlQmeki3Hf
         siOtAe8M3LFBAkt/TwvtdPyXsnw1PQAUkTWiEZq8R62baMpG00mNrcmUFwFDmpmNqd37
         CLxVlPicH/Gn6LVtfCsgNrpdPQSO9wfb0ZA7ZWxf0WV2rutl6H3+CkjRd+LxpjlEgX7P
         JlWw==
X-Gm-Message-State: APjAAAUMunloV7YgsPQpL1/o9WL2B22JIFMYUCndM0+Ass3Hqagm1koF
        cl9RWFijU98z3JfM6lf6xwPht7OwlRSlqnvjzWg=
X-Google-Smtp-Source: APXvYqzTJnZlaArguv0mOWeoHdEPTo+dgPdYyr5kGW5KSJV5ukrJYfpV415WjVo4mIW1rqvPC+RDTE3M9tX6WOphANs=
X-Received: by 2002:a5e:8b43:: with SMTP id z3mr6554091iom.287.1562364279239;
 Fri, 05 Jul 2019 15:04:39 -0700 (PDT)
MIME-Version: 1.0
References: <156234940798.2378.9008707939063611210.stgit@alrua-x1> <156234940855.2378.3580468359411972045.stgit@alrua-x1>
In-Reply-To: <156234940855.2378.3580468359411972045.stgit@alrua-x1>
From:   Y Song <ys114321@gmail.com>
Date:   Fri, 5 Jul 2019 15:04:03 -0700
Message-ID: <CAH3MdRVHnG+cbHUmwFpkjdtBMVOVasoekxKHKn_upQuDxe5v7Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/3] xdp: Add devmap_hash map type for looking up
 devices by hashed index
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 5, 2019 at 11:14 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> A common pattern when using xdp_redirect_map() is to create a device map
> where the lookup key is simply ifindex. Because device maps are arrays,
> this leaves holes in the map, and the map has to be sized to fit the
> largest ifindex, regardless of how many devices actually are actually
> needed in the map.
>
> This patch adds a second type of device map where the key is looked up
> using a hashmap, instead of being used as an array index. This allows map=
s
> to be densely packed, so they can be smaller.
>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
>  include/linux/bpf.h                     |    7 +
>  include/linux/bpf_types.h               |    1
>  include/trace/events/xdp.h              |    3
>  include/uapi/linux/bpf.h                |    7 +
>  kernel/bpf/devmap.c                     |  192 +++++++++++++++++++++++++=
++++++
>  kernel/bpf/verifier.c                   |    2
>  net/core/filter.c                       |    9 +
>  tools/bpf/bpftool/map.c                 |    1
>  tools/include/uapi/linux/bpf.h          |    7 +
>  tools/lib/bpf/libbpf_probes.c           |    1
>  tools/testing/selftests/bpf/test_maps.c |   16 +++
>  11 files changed, 237 insertions(+), 9 deletions(-)

Could you break this patch into multiple commits for easy backporting
and easy syncing to libbpf repo?
For example, you can break it into 4 patches:
   . kernel patch
   . sync uapi bpf.h
   . tools/lib/bpf/libbpf_probes.c
   . other tools changes.

>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index bfdb54dd2ad1..f9a506147c8a 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -713,6 +713,7 @@ struct xdp_buff;
>  struct sk_buff;
>
>  struct bpf_dtab_netdev *__dev_map_lookup_elem(struct bpf_map *map, u32 k=
ey);
> +struct bpf_dtab_netdev *__dev_map_hash_lookup_elem(struct bpf_map *map, =
u32 key);
>  void __dev_map_flush(struct bpf_map *map);
>  int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
>                     struct net_device *dev_rx);
> @@ -799,6 +800,12 @@ static inline struct net_device  *__dev_map_lookup_e=
lem(struct bpf_map *map,
>         return NULL;
>  }
>
> +static inline struct net_device  *__dev_map_hash_lookup_elem(struct bpf_=
map *map,
> +                                                            u32 key)
> +{
> +       return NULL;
> +}
> +
>  static inline void __dev_map_flush(struct bpf_map *map)
>  {
>  }
> diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
> index eec5aeeeaf92..36a9c2325176 100644
> --- a/include/linux/bpf_types.h
> +++ b/include/linux/bpf_types.h
> @@ -62,6 +62,7 @@ BPF_MAP_TYPE(BPF_MAP_TYPE_ARRAY_OF_MAPS, array_of_maps_=
map_ops)
>  BPF_MAP_TYPE(BPF_MAP_TYPE_HASH_OF_MAPS, htab_of_maps_map_ops)
>  #ifdef CONFIG_NET
>  BPF_MAP_TYPE(BPF_MAP_TYPE_DEVMAP, dev_map_ops)
> +BPF_MAP_TYPE(BPF_MAP_TYPE_DEVMAP_HASH, dev_map_hash_ops)
>  BPF_MAP_TYPE(BPF_MAP_TYPE_SK_STORAGE, sk_storage_map_ops)
>  #if defined(CONFIG_BPF_STREAM_PARSER)
>  BPF_MAP_TYPE(BPF_MAP_TYPE_SOCKMAP, sock_map_ops)
[...]
