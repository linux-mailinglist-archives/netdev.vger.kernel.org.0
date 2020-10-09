Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABE5128902C
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 19:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387831AbgJIRnG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 13:43:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732067AbgJIRmm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 13:42:42 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88ECAC0613D2;
        Fri,  9 Oct 2020 10:42:42 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id x8so7816275ybe.12;
        Fri, 09 Oct 2020 10:42:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Mg15uOqyJ0kMhKxvi4HhKQkqdFC2+c6UNBksDiJE/bE=;
        b=cp1ScTxcCj/airGHSApZxNnRoW9ofszCvh61kYL6QIds9LApGYRryPp++EYXoEffFn
         KMZAUxWOxs+WLqczY7/fFFhNJObh7kWeRvblDxtNKaic6aEkNG3IyHfXHLATYCj1MgTo
         dJ1GFFIhUMAeUyretHH4apYhTYV+uc5HDwVO0avbcgT5QrHiNrnsIndvnJl7gzdsB7Kd
         Gs+Y5BQTfysia1K0HnCBun/Pg9a5OardyfK86yj827OrnAhtaJN6a/edjYlnBeStwv4p
         1E55W3WFtUrH+B9kOK3Wq5ECLXGWOt7i3xVC05az9DWbDHoXi2krh5TPhNtk+KnLVBD8
         pXsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Mg15uOqyJ0kMhKxvi4HhKQkqdFC2+c6UNBksDiJE/bE=;
        b=ExODT9nnrq7fQQ4OMwR9HyUqDonS8kBHzKwbmFhM6DXHflEy/9f/e+UVXz16iBozvF
         X93PAjtbt3QKTs1QzsOCoPqTraiQIiDW9UEEOvQIfghaI2kYY7ipMKZ9iu0Q9JA6ysHG
         1r/Yk1w+Az6FRgHS/I3xWDcHx1+gwnIGgg1M0aVudgg/8X5W5Yq8B9B4mrIy3S4krB68
         4ysNq9JhSl0FOzuxYVBEVCKn5CkRekZHNHrvNn9rh/1NduQ8sfjUNrBile7xSAR7kvv9
         totIi514sHm/v0ritUYS36bdgNrP4OsNaMKW8U3RS1iAeno2NdRV5uC3IpbeDA9GYLbf
         /GSA==
X-Gm-Message-State: AOAM533+p1apeYi5wXI+ggl62w04fvlTQR0u9UZA7EwiB1ZB0+99ixd5
        5u+Cvkcrb9S4CFqrou+NhGs9tVfK+TlwiXGUlcQ=
X-Google-Smtp-Source: ABdhPJxXLz/djtkc6zVNYwJ47mqzmkMdA5/ZzG07AqTf6ljDXmIkUkGm8tR5tY1Ypr7SU1SGGrw34STmxAksqq+LkRY=
X-Received: by 2002:a25:8541:: with SMTP id f1mr17248740ybn.230.1602265361717;
 Fri, 09 Oct 2020 10:42:41 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1602252399.git.daniel@iogearbox.net> <48cbc4e24968da275d13bd8797fe32986938f398.1602252399.git.daniel@iogearbox.net>
In-Reply-To: <48cbc4e24968da275d13bd8797fe32986938f398.1602252399.git.daniel@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 9 Oct 2020 10:42:30 -0700
Message-ID: <CAEf4BzYVgs0vicVJTeT5yVSrOg=ArJ=BkEoA8KrwdQ8AVQ23Sg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 3/6] bpf: allow for map-in-map with dynamic
 inner array map entries
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 9, 2020 at 7:13 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> Recent work in f4d05259213f ("bpf: Add map_meta_equal map ops") and 134fede4eecf
> ("bpf: Relax max_entries check for most of the inner map types") added support
> for dynamic inner max elements for most map-in-map types. Exceptions were maps
> like array or prog array where the map_gen_lookup() callback uses the maps'
> max_entries field as a constant when emitting instructions.
>
> We recently implemented Maglev consistent hashing into Cilium's load balancer
> which uses map-in-map with an outer map being hash and inner being array holding
> the Maglev backend table for each service. This has been designed this way in
> order to reduce overall memory consumption given the outer hash map allows to
> avoid preallocating a large, flat memory area for all services. Also, the
> number of service mappings is not always known a-priori.
>
> The use case for dynamic inner array map entries is to further reduce memory
> overhead, for example, some services might just have a small number of back
> ends while others could have a large number. Right now the Maglev backend table
> for small and large number of backends would need to have the same inner array
> map entries which adds a lot of unneeded overhead.
>
> Dynamic inner array map entries can be realized by avoiding the inlined code
> generation for their lookup. The lookup will still be efficient since it will
> be calling into array_map_lookup_elem() directly and thus avoiding retpoline.
> The patch adds a BPF_F_NO_INLINE flag to map creation which internally swaps
> out map ops with a variant that does not have map_gen_lookup() callback and
> a relaxed map_meta_equal() that calls bpf_map_meta_equal() directly.
>
> Example code generation where inner map is dynamic sized array:
>
>   # bpftool p d x i 125
>   int handle__sys_enter(void * ctx):
>   ; int handle__sys_enter(void *ctx)
>      0: (b4) w1 = 0
>   ; int key = 0;
>      1: (63) *(u32 *)(r10 -4) = r1
>      2: (bf) r2 = r10
>   ;
>      3: (07) r2 += -4
>   ; inner_map = bpf_map_lookup_elem(&outer_arr_dyn, &key);
>      4: (18) r1 = map[id:468]
>      6: (07) r1 += 272
>      7: (61) r0 = *(u32 *)(r2 +0)
>      8: (35) if r0 >= 0x3 goto pc+5
>      9: (67) r0 <<= 3
>     10: (0f) r0 += r1
>     11: (79) r0 = *(u64 *)(r0 +0)
>     12: (15) if r0 == 0x0 goto pc+1
>     13: (05) goto pc+1
>     14: (b7) r0 = 0
>     15: (b4) w6 = -1
>   ; if (!inner_map)
>     16: (15) if r0 == 0x0 goto pc+6
>     17: (bf) r2 = r10
>   ;
>     18: (07) r2 += -4
>   ; val = bpf_map_lookup_elem(inner_map, &key);
>     19: (bf) r1 = r0                               | No inlining but instead
>     20: (85) call array_map_lookup_elem#149280     | call to array_map_lookup_elem()
>   ; return val ? *val : -1;                        | for inner array lookup.
>     21: (15) if r0 == 0x0 goto pc+1
>   ; return val ? *val : -1;
>     22: (61) r6 = *(u32 *)(r0 +0)
>   ; }
>     23: (bc) w0 = w6
>     24: (95) exit
>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> Acked-by: Yonghong Song <yhs@fb.com>
> ---
>  include/linux/bpf.h            |  1 +
>  include/uapi/linux/bpf.h       |  5 +++++
>  kernel/bpf/arraymap.c          | 40 ++++++++++++++++++++++++++++++++--
>  kernel/bpf/syscall.c           |  3 ++-
>  tools/include/uapi/linux/bpf.h |  5 +++++
>  5 files changed, 51 insertions(+), 3 deletions(-)
>

[...]

>
> +/* Variant which does not have map_gen_lookup() implementation, but
> + * therefore can relax map_meta_equal() check to allow for dynamic
> + * max_entries for inner maps.
> + */
> +const struct bpf_map_ops array_map_no_inline_ops = {
> +       .map_meta_equal = bpf_map_meta_equal,
> +       .map_alloc_check = array_map_alloc_check,
> +       .map_alloc = array_map_alloc,
> +       .map_free = array_map_free,
> +       .map_get_next_key = array_map_get_next_key,
> +       .map_lookup_elem = array_map_lookup_elem,
> +       .map_update_elem = array_map_update_elem,
> +       .map_delete_elem = array_map_delete_elem,
> +       .map_direct_value_addr = array_map_direct_value_addr,
> +       .map_direct_value_meta = array_map_direct_value_meta,
> +       .map_mmap = array_map_mmap,
> +       .map_seq_show_elem = array_map_seq_show_elem,
> +       .map_check_btf = array_map_check_btf,
> +       .map_lookup_batch = generic_map_lookup_batch,
> +       .map_update_batch = generic_map_update_batch,
> +       .map_btf_name = "bpf_array",
> +       .map_btf_id = &array_map_btf_id,
> +       .iter_seq_info = &iter_seq_info,
> +};
> +
>  static int percpu_array_map_btf_id;
>  const struct bpf_map_ops percpu_array_map_ops = {
>         .map_meta_equal = bpf_map_meta_equal,
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 1110ecd7d1f3..519bf867f065 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -111,7 +111,8 @@ static struct bpf_map *find_and_alloc_map(union bpf_attr *attr)
>         ops = bpf_map_types[type];
>         if (!ops)
>                 return ERR_PTR(-EINVAL);
> -
> +       if (ops->map_swap_ops)
> +               ops = ops->map_swap_ops(attr);

I'm afraid that this can cause quite a lot of confusion down the road.

Wouldn't designating -EOPNOTSUPP return code from map_gen_lookup() and
not inlining in that case as if map_gen_lookup() wasn't even defined
be a much smaller and more local (semantically) change that achieves
exactly the same thing? Doesn't seem like switching from u32 to int
for return value would be a big inconvenience for existing
implementations of inlining callbacks, right?

>         if (ops->map_alloc_check) {
>                 err = ops->map_alloc_check(attr);
>                 if (err)
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index ea8dfbe62c7a..eb384264f906 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -435,6 +435,11 @@ enum {
>
>  /* Share perf_event among processes */
>         BPF_F_PRESERVE_ELEMS    = (1U << 11),
> +
> +/* Do not inline (array) map lookups so the array map can be used for
> + * map in map with dynamic max entries.
> + */
> +       BPF_F_NO_INLINE         = (1U << 12),
>  };
>
>  /* Flags for BPF_PROG_QUERY. */
> --
> 2.21.0
>
