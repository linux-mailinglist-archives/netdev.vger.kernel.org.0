Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8839F58D14D
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 02:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244696AbiHIATG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 20:19:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244653AbiHIATE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 20:19:04 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BF825F6B;
        Mon,  8 Aug 2022 17:19:02 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id gb36so19475310ejc.10;
        Mon, 08 Aug 2022 17:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=TlM9leardc/lh2LAQcB7vPGtKrRV8tCxZE6tCV2q/hQ=;
        b=VsnzieyrIyNJZZwyHN0jtoFOIpZfLyZFOi1lYn8touGkiYf4w+JAgrG1eWHpD+jrdV
         R07dDJfmhqLjearJ1lyl7LCZ4hvDoJVr7A8Si1D3+OaiMyN5aW86ZJQr9IHkMMFzfsbr
         rmi+xmz2pgROi8oYv5koHymujX9oIuhcHFdQwMnkTK17Yim9kH33pkjbHAB6R0ELQzKI
         2Ysm8bKSs9lyCPp53i/WovGrjs+rjovSnVBoD85i54YkRBFtDw7ba0YuILGnLjlfVsO2
         2wPNEirmmM815pBen/hQC7Gj7RgUYxcNdu1+BP5BLfoSy0nISGaoIUqqnkNt7F2NUzCD
         6sKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=TlM9leardc/lh2LAQcB7vPGtKrRV8tCxZE6tCV2q/hQ=;
        b=sJpjlr7gIeU7mmWev09xxt1Ayx93l/aZ5LRY+pFeI+/nvhM29gjt9xbRZkyAj/qlMe
         ocEEv4TkUw+osnH+7AKBU5CcQFGf8x1LCGMSeP3R+Ob/bbIVtfywBWaz/jrshSfz64Yq
         1iVxw3vh9EqpmWn6+xNRsiz7Ay8oWQoK+M0pKliEsYsRWHqm+8k1TWDBisSwZHwBBndm
         Y3I86sRXcVvyq6C9ojA+U7XL/GunrWNRLGqP3BeVKM9NvAcAWyigpOcJldSVBo+f63is
         LHSY4Lfsu14mvrSSO194VYKk6o72+E/QOCafPWhid00eTgH5PIqz2kvGix6v+QzhybUM
         bwCA==
X-Gm-Message-State: ACgBeo1fCiTmO1pgmJLUuEE5BZzJxU4gL0B0RJVxBZS4HrocrUU/JWVG
        it0ZVwZbModh5T+qzL3xO5QeZtnWuF+N9SFXHJo=
X-Google-Smtp-Source: AA6agR7jsp2GdBBsJMK1XRlFbL78j6qGRxxcAxXMkQ9l/oLN7j+VD7I75rRoCu4Vib7KufeKo7eWlxIMKbKtTjwoIsA=
X-Received: by 2002:a17:907:3e08:b0:730:d55c:1b26 with SMTP id
 hp8-20020a1709073e0800b00730d55c1b26mr15119311ejc.226.1660004340751; Mon, 08
 Aug 2022 17:19:00 -0700 (PDT)
MIME-Version: 1.0
References: <20220805214821.1058337-1-haoluo@google.com> <20220805214821.1058337-5-haoluo@google.com>
In-Reply-To: <20220805214821.1058337-5-haoluo@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 8 Aug 2022 17:18:49 -0700
Message-ID: <CAEf4BzZHf89Ds8nQWFCH00fKs9-9GkJ0d+Hrp-LkMCDUP_td0A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7 4/8] bpf: Introduce cgroup iter
To:     Hao Luo <haoluo@google.com>
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        cgroups@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        KP Singh <kpsingh@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Michal Koutny <mkoutny@suse.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        David Rientjes <rientjes@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Yosry Ahmed <yosryahmed@google.com>
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

On Fri, Aug 5, 2022 at 2:49 PM Hao Luo <haoluo@google.com> wrote:
>
> Cgroup_iter is a type of bpf_iter. It walks over cgroups in four modes:
>
>  - walking a cgroup's descendants in pre-order.
>  - walking a cgroup's descendants in post-order.
>  - walking a cgroup's ancestors.
>  - process only the given cgroup.
>
> When attaching cgroup_iter, one can set a cgroup to the iter_link
> created from attaching. This cgroup is passed as a file descriptor
> or cgroup id and serves as the starting point of the walk. If no
> cgroup is specified, the starting point will be the root cgroup v2.
>
> For walking descendants, one can specify the order: either pre-order or
> post-order. For walking ancestors, the walk starts at the specified
> cgroup and ends at the root.
>
> One can also terminate the walk early by returning 1 from the iter
> program.
>
> Note that because walking cgroup hierarchy holds cgroup_mutex, the iter
> program is called with cgroup_mutex held.
>
> Currently only one session is supported, which means, depending on the
> volume of data bpf program intends to send to user space, the number
> of cgroups that can be walked is limited. For example, given the current
> buffer size is 8 * PAGE_SIZE, if the program sends 64B data for each
> cgroup, assuming PAGE_SIZE is 4kb, the total number of cgroups that can
> be walked is 512. This is a limitation of cgroup_iter. If the output
> data is larger than the kernel buffer size, after all data in the
> kernel buffer is consumed by user space, the subsequent read() syscall
> will signal EOPNOTSUPP. In order to work around, the user may have to
> update their program to reduce the volume of data sent to output. For
> example, skip some uninteresting cgroups. In future, we may extend
> bpf_iter flags to allow customizing buffer size.
>
> Acked-by: Yonghong Song <yhs@fb.com>
> Acked-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Hao Luo <haoluo@google.com>
> ---
>  include/linux/bpf.h                           |   8 +
>  include/uapi/linux/bpf.h                      |  38 +++
>  kernel/bpf/Makefile                           |   3 +
>  kernel/bpf/cgroup_iter.c                      | 286 ++++++++++++++++++
>  tools/include/uapi/linux/bpf.h                |  38 +++
>  .../selftests/bpf/prog_tests/btf_dump.c       |   4 +-
>  6 files changed, 375 insertions(+), 2 deletions(-)
>  create mode 100644 kernel/bpf/cgroup_iter.c
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 20c26aed7896..09b5c2167424 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -48,6 +48,7 @@ struct mem_cgroup;
>  struct module;
>  struct bpf_func_state;
>  struct ftrace_ops;
> +struct cgroup;
>
>  extern struct idr btf_idr;
>  extern spinlock_t btf_idr_lock;
> @@ -1730,7 +1731,14 @@ int bpf_obj_get_user(const char __user *pathname, int flags);
>         int __init bpf_iter_ ## target(args) { return 0; }
>
>  struct bpf_iter_aux_info {
> +       /* for map_elem iter */
>         struct bpf_map *map;
> +
> +       /* for cgroup iter */
> +       struct {
> +               struct cgroup *start; /* starting cgroup */
> +               int order;
> +       } cgroup;
>  };
>
>  typedef int (*bpf_iter_attach_target_t)(struct bpf_prog *prog,
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 59a217ca2dfd..4d758b2e70d6 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -87,10 +87,37 @@ struct bpf_cgroup_storage_key {
>         __u32   attach_type;            /* program attach type (enum bpf_attach_type) */
>  };
>
> +enum bpf_iter_order {
> +       BPF_ITER_ORDER_DEFAULT = 0,     /* default order. */

why is this default order necessary? It just adds confusion (I had to
look up source code to know what is default order). I might have
missed some discussion, so if there is some very good reason, then
please document this in commit message. But I'd rather not do some
magical default order instead. We can set 0 to mean invalid and error
out, or just do SELF as the very first value (and if user forgot to
specify more fancy mode, they hopefully will quickly discover this in
their testing).

> +       BPF_ITER_SELF,                  /* process only a single object. */
> +       BPF_ITER_DESCENDANTS_PRE,       /* walk descendants in pre-order. */
> +       BPF_ITER_DESCENDANTS_POST,      /* walk descendants in post-order. */
> +       BPF_ITER_ANCESTORS_UP,          /* walk ancestors upward. */
> +};
> +

This is a somewhat pedantic nit, so feel free to ignore completely,
but don't DESCENDANTS_{PRE,POST} and ANCESTORS_UP also include "self"?
As it is right now, BPF_ITER_SELF name might be read as implying that
DESCENDANTS and ANCESTORS order don't include self. So I don't know,
maybe BPF_ITER_SELF_ONLY would be a bit clearer?


>  union bpf_iter_link_info {
>         struct {
>                 __u32   map_fd;
>         } map;
> +       struct {
> +               /* Valid values include:
> +                *  - BPF_ITER_ORDER_DEFAULT
> +                *  - BPF_ITER_SELF
> +                *  - BPF_ITER_DESCENDANTS_PRE
> +                *  - BPF_ITER_DESCENDANTS_POST
> +                *  - BPF_ITER_ANCESTORS_UP
> +                * for cgroup_iter, DEFAULT is equivalent to DESCENDANTS_PRE.
> +                */
> +               __u32   order;
> +
> +               /* At most one of cgroup_fd and cgroup_id can be non-zero. If
> +                * both are zero, the walk starts from the default cgroup v2
> +                * root. For walking v1 hierarchy, one should always explicitly
> +                * specify cgroup_fd.
> +                */
> +               __u32   cgroup_fd;
> +               __u64   cgroup_id;
> +       } cgroup;
>  };
>
>  /* BPF syscall commands, see bpf(2) man-page for more details. */
> @@ -6134,11 +6161,22 @@ struct bpf_link_info {
>                 struct {
>                         __aligned_u64 target_name; /* in/out: target_name buffer ptr */
>                         __u32 target_name_len;     /* in/out: target_name buffer len */
> +
> +                       /* If the iter specific field is 32 bits, it can be put
> +                        * in the first or second union. Otherwise it should be
> +                        * put in the second union.
> +                        */
>                         union {
>                                 struct {
>                                         __u32 map_id;
>                                 } map;
>                         };
> +                       union {
> +                               struct {
> +                                       __u64 cgroup_id;
> +                                       __u32 order;
> +                               } cgroup;
> +                       };
>                 } iter;

But other than above, I like how UAPI looks like, thanks!

[...]

> + *
> + * For walking descendants, cgroup_iter can walk in either pre-order or
> + * post-order. For walking ancestors, the iter walks up from a cgroup to
> + * the root.
> + *
> + * The iter program can terminate the walk early by returning 1. Walk
> + * continues if prog returns 0.
> + *
> + * The prog can check (seq->num == 0) to determine whether this is
> + * the first element. The prog may also be passed a NULL cgroup,
> + * which means the walk has completed and the prog has a chance to
> + * do post-processing, such as outputing an epilogue.

typo: outputting

> + *
> + * Note: the iter_prog is called with cgroup_mutex held.
> + *
> + * Currently only one session is supported, which means, depending on the
> + * volume of data bpf program intends to send to user space, the number
> + * of cgroups that can be walked is limited. For example, given the current
> + * buffer size is 8 * PAGE_SIZE, if the program sends 64B data for each
> + * cgroup, assuming PAGE_SIZE is 4kb, the total number of cgroups that can
> + * be walked is 512. This is a limitation of cgroup_iter. If the output data
> + * is larger than the kernel buffer size, after all data in the kernel buffer
> + * is consumed by user space, the subsequent read() syscall will signal
> + * EOPNOTSUPP. In order to work around, the user may have to update their
> + * program to reduce the volume of data sent to output. For example, skip
> + * some uninteresting cgroups.
> + */
> +

[...]

> +
> +static void bpf_iter_cgroup_show_fdinfo(const struct bpf_iter_aux_info *aux,
> +                                       struct seq_file *seq)
> +{
> +       char *buf;
> +
> +       buf = kzalloc(PATH_MAX, GFP_KERNEL);
> +       if (!buf) {
> +               seq_puts(seq, "cgroup_path:\t<unknown>\n");
> +               goto show_order;
> +       }
> +
> +       /* If cgroup_path_ns() fails, buf will be an empty string, cgroup_path
> +        * will print nothing.
> +        *
> +        * Path is in the calling process's cgroup namespace.
> +        */
> +       cgroup_path_ns(aux->cgroup.start, buf, PATH_MAX,
> +                      current->nsproxy->cgroup_ns);
> +       seq_printf(seq, "cgroup_path:\t%s\n", buf);
> +       kfree(buf);
> +
> +show_order:
> +       if (aux->cgroup.order == BPF_ITER_DESCENDANTS_PRE)
> +               seq_puts(seq, "order: pre\n");
> +       else if (aux->cgroup.order == BPF_ITER_DESCENDANTS_POST)
> +               seq_puts(seq, "order: post\n");
> +       else if (aux->cgroup.order == BPF_ITER_ANCESTORS_UP)
> +               seq_puts(seq, "order: up\n");
> +       else /* BPF_ITER_SELF */
> +               seq_puts(seq, "order: self\n");

should we output "descendants_pre", "descendants_post", "ancestors_up"
and "self" to match enum names more uniformly? We had similar
discussion when Daniel Mueller was doing some clean up in bpftool and
public's opinion was that uniform and consistent mapping between
kernel enum and it's string representation is more valuable than
shortness of the string.

> +}
> +

[...]
