Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C68B3624F
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 19:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726556AbfFERRF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 13:17:05 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:32857 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725950AbfFERRE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 13:17:04 -0400
Received: by mail-qt1-f193.google.com with SMTP id 14so18910804qtf.0
        for <netdev@vger.kernel.org>; Wed, 05 Jun 2019 10:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FTb53qVbxOIRHqrunUCYOg1oOmOI0t04sy4MVkL60/s=;
        b=Y0tL4e1JnbujxUQrZMAgSf5Uexhf79eh8shs/RCI3bqTHkpW92mXw6F+sLpX5TEzhQ
         zHlXcGTmwVKocQsXkJwOprmUdbJWLt/xssGpQqoOJQAoAAMaHF8NR/SuybgBuab0JeQf
         8BzUVzZvId4dx+tFaAaS8x5c6S01O+j+c6+da4vjL5ESHoz6DHyxlWMdy7QU45mzehxg
         jeSkVkwn3LNcN2mjWjU7NB4MCz78kkKVXhF+9+m2zI9OY1ytVGVOIoS/T9I04z3+il7n
         m9OCx30zo8XPgSBg5QWRS9Cj+LjB9W94kuhSqt8Zva0lQhbI1aQzz5aUBN16OASoQKSb
         4cmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FTb53qVbxOIRHqrunUCYOg1oOmOI0t04sy4MVkL60/s=;
        b=nVAysIxg/NeMBmT9z5dxnM0C2CHyKP1Spa/2Jjqq24PuxLzS30I/PTbbZFMTY5Q9sN
         OjTrcMemI+VFCAZH29RhSgV/3Ka/qSefxQ2XYYdnCfPI/f5ro9ceyAh0yVDfh8Aq4MQ9
         ueIzdwuBG3Hixr+d63ti5avzH7gyGwyT5Xv1BQ7lPTuf8XlKNg12hu4RigEF7tR+ssBF
         lMKr3sFNnP4q6/XgFjQmxU1iChsInVyFxhGCnP70P+ij22dvnL7N8AZNQsiqmPdQtMfM
         bW/3zJXMC2w9petRTubT3RsIFQ8qj4O5fxoTD6xrufm2VKlInVTcix87U3HRJAiDnx7b
         PVSQ==
X-Gm-Message-State: APjAAAU5Hw2uCtUj9wSYAv3Y6ECQsP74+ZwpNTIpo0yoJKnV5PDScbn0
        oC7asIaxS7XhKEo1g2FzQl0qiYFdrpDFLFKIFIA=
X-Google-Smtp-Source: APXvYqzBfc6lah0wLf8R3qkzqkivdPoRhn497fbs0Zcjx8WIOcZx1t/pz+1mTsC59lFljQQVLdPuIy8QuvCopoCdsqU=
X-Received: by 2002:ac8:4442:: with SMTP id m2mr13190069qtn.107.1559755023323;
 Wed, 05 Jun 2019 10:17:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190605155756.3779466-1-jonathan.lemon@gmail.com> <20190605155756.3779466-2-jonathan.lemon@gmail.com>
In-Reply-To: <20190605155756.3779466-2-jonathan.lemon@gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Wed, 5 Jun 2019 19:16:51 +0200
Message-ID: <CAJ+HfNizsTgxTvtyUezQkqAuoWr7txYNCuDTeWgy4UTR2hbr8g@mail.gmail.com>
Subject: Re: [PATCH 1/1] bpf: Allow bpf_map_lookup_elem() on an xskmap
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Kernel Team <kernel-team@fb.com>,
        Netdev <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 5 Jun 2019 at 17:58, Jonathan Lemon <jonathan.lemon@gmail.com> wrot=
e:
>
> Currently, the AF_XDP code uses a separate map in order to
> determine if an xsk is bound to a queue.  Instead of doing this,
> have bpf_map_lookup_elem() return a xdp_sock.
>
> Rearrange some xdp_sock members to eliminate structure holes.
>
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> ---
>  include/linux/bpf.h                           |  8 ++++
>  include/net/xdp_sock.h                        |  4 +-
>  include/uapi/linux/bpf.h                      |  4 ++
>  kernel/bpf/verifier.c                         | 26 +++++++++++-
>  kernel/bpf/xskmap.c                           |  7 ++++
>  net/core/filter.c                             | 40 +++++++++++++++++++
>  tools/include/uapi/linux/bpf.h                |  4 ++
>  .../bpf/verifier/prevent_map_lookup.c         | 15 -------
>  tools/testing/selftests/bpf/verifier/sock.c   | 18 +++++++++
>  9 files changed, 107 insertions(+), 19 deletions(-)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index ff3e00ff84d2..66b175bdc645 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -276,6 +276,7 @@ enum bpf_reg_type {
>         PTR_TO_TCP_SOCK,         /* reg points to struct tcp_sock */
>         PTR_TO_TCP_SOCK_OR_NULL, /* reg points to struct tcp_sock or NULL=
 */
>         PTR_TO_TP_BUFFER,        /* reg points to a writable raw tp's buf=
fer */
> +       PTR_TO_XDP_SOCK,         /* reg points to struct xdp_sock */
>  };
>
>  /* The information passed from prog-specific *_is_valid_access
> @@ -670,6 +671,13 @@ void __cpu_map_insert_ctx(struct bpf_map *map, u32 i=
ndex);
>  void __cpu_map_flush(struct bpf_map *map);
>  int cpu_map_enqueue(struct bpf_cpu_map_entry *rcpu, struct xdp_buff *xdp=
,
>                     struct net_device *dev_rx);
> +bool bpf_xdp_sock_is_valid_access(int off, int size, enum bpf_access_typ=
e type,
> +                                 struct bpf_insn_access_aux *info);
> +u32 bpf_xdp_sock_convert_ctx_access(enum bpf_access_type type,
> +                                   const struct bpf_insn *si,
> +                                   struct bpf_insn *insn_buf,
> +                                   struct bpf_prog *prog,
> +                                   u32 *target_size);
>
>  /* Return map's numa specified by userspace */
>  static inline int bpf_map_attr_numa_node(const union bpf_attr *attr)
> diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
> index d074b6d60f8a..ae0f368a62bb 100644
> --- a/include/net/xdp_sock.h
> +++ b/include/net/xdp_sock.h
> @@ -58,11 +58,11 @@ struct xdp_sock {
>         struct xdp_umem *umem;
>         struct list_head flush_node;
>         u16 queue_id;
> -       struct xsk_queue *tx ____cacheline_aligned_in_smp;
> -       struct list_head list;
>         bool zc;
>         /* Protects multiple processes in the control path */
>         struct mutex mutex;
> +       struct xsk_queue *tx ____cacheline_aligned_in_smp;
> +       struct list_head list;
>         /* Mutual exclusion of NAPI TX thread and sendmsg error paths
>          * in the SKB destructor callback.
>          */
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 7c6aef253173..ae0907d8c03a 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -3083,6 +3083,10 @@ struct bpf_sock_tuple {
>         };
>  };
>
> +struct bpf_xdp_sock {
> +       __u32 queue_id;
> +};
> +
>  #define XDP_PACKET_HEADROOM 256
>
>  /* User return codes for XDP prog type.
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 2778417e6e0c..abe177405989 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -334,7 +334,8 @@ static bool type_is_sk_pointer(enum bpf_reg_type type=
)
>  {
>         return type =3D=3D PTR_TO_SOCKET ||
>                 type =3D=3D PTR_TO_SOCK_COMMON ||
> -               type =3D=3D PTR_TO_TCP_SOCK;
> +               type =3D=3D PTR_TO_TCP_SOCK ||
> +               type =3D=3D PTR_TO_XDP_SOCK;
>  }
>
>  static bool reg_type_may_be_null(enum bpf_reg_type type)
> @@ -406,6 +407,7 @@ static const char * const reg_type_str[] =3D {
>         [PTR_TO_TCP_SOCK]       =3D "tcp_sock",
>         [PTR_TO_TCP_SOCK_OR_NULL] =3D "tcp_sock_or_null",
>         [PTR_TO_TP_BUFFER]      =3D "tp_buffer",
> +       [PTR_TO_XDP_SOCK]       =3D "xdp_sock",
>  };
>
>  static char slot_type_char[] =3D {
> @@ -1363,6 +1365,7 @@ static bool is_spillable_regtype(enum bpf_reg_type =
type)
>         case PTR_TO_SOCK_COMMON_OR_NULL:
>         case PTR_TO_TCP_SOCK:
>         case PTR_TO_TCP_SOCK_OR_NULL:
> +       case PTR_TO_XDP_SOCK:
>                 return true;
>         default:
>                 return false;
> @@ -1843,6 +1846,9 @@ static int check_sock_access(struct bpf_verifier_en=
v *env, int insn_idx,
>         case PTR_TO_TCP_SOCK:
>                 valid =3D bpf_tcp_sock_is_valid_access(off, size, t, &inf=
o);
>                 break;
> +       case PTR_TO_XDP_SOCK:
> +               valid =3D bpf_xdp_sock_is_valid_access(off, size, t, &inf=
o);
> +               break;
>         default:
>                 valid =3D false;
>         }
> @@ -2007,6 +2013,9 @@ static int check_ptr_alignment(struct bpf_verifier_=
env *env,
>         case PTR_TO_TCP_SOCK:
>                 pointer_desc =3D "tcp_sock ";
>                 break;
> +       case PTR_TO_XDP_SOCK:
> +               pointer_desc =3D "xdp_sock ";
> +               break;
>         default:
>                 break;
>         }
> @@ -2905,10 +2914,14 @@ static int check_map_func_compatibility(struct bp=
f_verifier_env *env,
>          * appear.
>          */
>         case BPF_MAP_TYPE_CPUMAP:
> -       case BPF_MAP_TYPE_XSKMAP:
>                 if (func_id !=3D BPF_FUNC_redirect_map)
>                         goto error;
>                 break;
> +       case BPF_MAP_TYPE_XSKMAP:
> +               if (func_id !=3D BPF_FUNC_redirect_map &&
> +                   func_id !=3D BPF_FUNC_map_lookup_elem)
> +                       goto error;
> +               break;
>         case BPF_MAP_TYPE_ARRAY_OF_MAPS:
>         case BPF_MAP_TYPE_HASH_OF_MAPS:
>                 if (func_id !=3D BPF_FUNC_map_lookup_elem)
> @@ -3799,6 +3812,7 @@ static int adjust_ptr_min_max_vals(struct bpf_verif=
ier_env *env,
>         case PTR_TO_SOCK_COMMON_OR_NULL:
>         case PTR_TO_TCP_SOCK:
>         case PTR_TO_TCP_SOCK_OR_NULL:
> +       case PTR_TO_XDP_SOCK:
>                 verbose(env, "R%d pointer arithmetic on %s prohibited\n",
>                         dst, reg_type_str[ptr_reg->type]);
>                 return -EACCES;
> @@ -5038,6 +5052,9 @@ static void mark_ptr_or_null_reg(struct bpf_func_st=
ate *state,
>                         if (reg->map_ptr->inner_map_meta) {
>                                 reg->type =3D CONST_PTR_TO_MAP;
>                                 reg->map_ptr =3D reg->map_ptr->inner_map_=
meta;
> +                       } else if (reg->map_ptr->map_type =3D=3D
> +                                  BPF_MAP_TYPE_XSKMAP) {
> +                               reg->type =3D PTR_TO_XDP_SOCK;
>                         } else {
>                                 reg->type =3D PTR_TO_MAP_VALUE;
>                         }
> @@ -6289,6 +6306,7 @@ static bool regsafe(struct bpf_reg_state *rold, str=
uct bpf_reg_state *rcur,
>         case PTR_TO_SOCK_COMMON_OR_NULL:
>         case PTR_TO_TCP_SOCK:
>         case PTR_TO_TCP_SOCK_OR_NULL:
> +       case PTR_TO_XDP_SOCK:
>                 /* Only valid matches are exact, which memcmp() above
>                  * would have accepted
>                  */
> @@ -6683,6 +6701,7 @@ static bool reg_type_mismatch_ok(enum bpf_reg_type =
type)
>         case PTR_TO_SOCK_COMMON_OR_NULL:
>         case PTR_TO_TCP_SOCK:
>         case PTR_TO_TCP_SOCK_OR_NULL:
> +       case PTR_TO_XDP_SOCK:
>                 return false;
>         default:
>                 return true;
> @@ -7816,6 +7835,9 @@ static int convert_ctx_accesses(struct bpf_verifier=
_env *env)
>                 case PTR_TO_TCP_SOCK:
>                         convert_ctx_access =3D bpf_tcp_sock_convert_ctx_a=
ccess;
>                         break;
> +               case PTR_TO_XDP_SOCK:
> +                       convert_ctx_access =3D bpf_xdp_sock_convert_ctx_a=
ccess;
> +                       break;
>                 default:
>                         continue;
>                 }
> diff --git a/kernel/bpf/xskmap.c b/kernel/bpf/xskmap.c
> index 686d244e798d..b5c58e9c4835 100644
> --- a/kernel/bpf/xskmap.c
> +++ b/kernel/bpf/xskmap.c
> @@ -153,6 +153,12 @@ void __xsk_map_flush(struct bpf_map *map)
>  }
>
>  static void *xsk_map_lookup_elem(struct bpf_map *map, void *key)
> +{
> +       WARN_ON_ONCE(!rcu_read_lock_held());
> +       return __xsk_map_lookup_elem(map, *(u32 *)key);
> +}
> +
> +static void *xsk_map_lookup_elem_sys_only(struct bpf_map *map, void *key=
)
>  {
>         return ERR_PTR(-EOPNOTSUPP);
>  }
> @@ -220,6 +226,7 @@ const struct bpf_map_ops xsk_map_ops =3D {
>         .map_free =3D xsk_map_free,
>         .map_get_next_key =3D xsk_map_get_next_key,
>         .map_lookup_elem =3D xsk_map_lookup_elem,
> +       .map_lookup_elem_sys_only =3D xsk_map_lookup_elem_sys_only,

The sys_only was news to time! Nice!

>         .map_update_elem =3D xsk_map_update_elem,
>         .map_delete_elem =3D xsk_map_delete_elem,
>         .map_check_btf =3D map_check_no_btf,
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 55bfc941d17a..f2d9d77b4b57 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -5680,6 +5680,46 @@ BPF_CALL_1(bpf_skb_ecn_set_ce, struct sk_buff *, s=
kb)
>         return INET_ECN_set_ce(skb);
>  }
>
> +bool bpf_xdp_sock_is_valid_access(int off, int size, enum bpf_access_typ=
e type,
> +                                 struct bpf_insn_access_aux *info)
> +{
> +       if (off < 0 || off >=3D offsetofend(struct bpf_xdp_sock, queue_id=
))
> +               return false;
> +
> +       if (off % size !=3D 0)
> +               return false;
> +
> +       switch (off) {
> +       default:
> +               return size =3D=3D sizeof(__u32);
> +       }

Hmm? Missing case or remove?


Bj=C3=B6rn

> +}
> +
> +u32 bpf_xdp_sock_convert_ctx_access(enum bpf_access_type type,
> +                                   const struct bpf_insn *si,
> +                                   struct bpf_insn *insn_buf,
> +                                   struct bpf_prog *prog, u32 *target_si=
ze)
> +{
> +       struct bpf_insn *insn =3D insn_buf;
> +
> +#define BPF_XDP_SOCK_GET(FIELD)                                         =
       \
> +       do {                                                            \
> +               BUILD_BUG_ON(FIELD_SIZEOF(struct xdp_sock, FIELD) >     \
> +                            FIELD_SIZEOF(struct bpf_xdp_sock, FIELD)); \
> +               *insn++ =3D BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct xdp_sock,=
 FIELD),\
> +                                     si->dst_reg, si->src_reg,         \
> +                                     offsetof(struct xdp_sock, FIELD)); =
\
> +       } while (0)
> +
> +       switch (si->off) {
> +       case offsetof(struct bpf_xdp_sock, queue_id):
> +               BPF_XDP_SOCK_GET(queue_id);
> +               break;
> +       }
> +
> +       return insn - insn_buf;
> +}
> +
>  static const struct bpf_func_proto bpf_skb_ecn_set_ce_proto =3D {
>         .func           =3D bpf_skb_ecn_set_ce,
>         .gpl_only       =3D false,
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bp=
f.h
> index 7c6aef253173..ae0907d8c03a 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -3083,6 +3083,10 @@ struct bpf_sock_tuple {
>         };
>  };
>
> +struct bpf_xdp_sock {
> +       __u32 queue_id;
> +};
> +
>  #define XDP_PACKET_HEADROOM 256
>
>  /* User return codes for XDP prog type.
> diff --git a/tools/testing/selftests/bpf/verifier/prevent_map_lookup.c b/=
tools/testing/selftests/bpf/verifier/prevent_map_lookup.c
> index bbdba990fefb..da7a4b37cb98 100644
> --- a/tools/testing/selftests/bpf/verifier/prevent_map_lookup.c
> +++ b/tools/testing/selftests/bpf/verifier/prevent_map_lookup.c
> @@ -28,21 +28,6 @@
>         .errstr =3D "cannot pass map_type 18 into func bpf_map_lookup_ele=
m",
>         .prog_type =3D BPF_PROG_TYPE_SOCK_OPS,
>  },
> -{
> -       "prevent map lookup in xskmap",
> -       .insns =3D {
> -       BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
> -       BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
> -       BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
> -       BPF_LD_MAP_FD(BPF_REG_1, 0),
> -       BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_ele=
m),
> -       BPF_EXIT_INSN(),
> -       },
> -       .fixup_map_xskmap =3D { 3 },
> -       .result =3D REJECT,
> -       .errstr =3D "cannot pass map_type 17 into func bpf_map_lookup_ele=
m",
> -       .prog_type =3D BPF_PROG_TYPE_XDP,
> -},
>  {
>         "prevent map lookup in stack trace",
>         .insns =3D {
> diff --git a/tools/testing/selftests/bpf/verifier/sock.c b/tools/testing/=
selftests/bpf/verifier/sock.c
> index b31cd2cf50d0..9ed192e14f5f 100644
> --- a/tools/testing/selftests/bpf/verifier/sock.c
> +++ b/tools/testing/selftests/bpf/verifier/sock.c
> @@ -498,3 +498,21 @@
>         .result =3D REJECT,
>         .errstr =3D "cannot pass map_type 24 into func bpf_map_lookup_ele=
m",
>  },
> +{
> +       "bpf_map_lookup_elem(xskmap, &key); xs->queue_id",
> +       .insns =3D {
> +       BPF_ST_MEM(BPF_W, BPF_REG_10, -8, 0),
> +       BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
> +       BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
> +       BPF_LD_MAP_FD(BPF_REG_1, 0),
> +       BPF_EMIT_CALL(BPF_FUNC_map_lookup_elem),
> +       BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
> +       BPF_EXIT_INSN(),
> +       BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_0, offsetof(struct bpf_xdp_=
sock, queue_id)),
> +       BPF_MOV64_IMM(BPF_REG_0, 0),
> +       BPF_EXIT_INSN(),
> +       },
> +       .fixup_map_xskmap =3D { 3 },
> +       .prog_type =3D BPF_PROG_TYPE_XDP,
> +       .result =3D ACCEPT,
> +},
> --
> 2.17.1
>
