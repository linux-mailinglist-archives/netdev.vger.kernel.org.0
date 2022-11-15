Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7A462A16C
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 19:38:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbiKOSiD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 13:38:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbiKOSiA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 13:38:00 -0500
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 275A8209B9
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 10:37:59 -0800 (PST)
Received: by mail-ot1-x334.google.com with SMTP id p10-20020a9d76ca000000b0066d6c6bce58so5975380otl.7
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 10:37:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vRtHQTIXlGRFGOjkr6EDMKnB9t1vQVBbtJP/KeMf3TE=;
        b=fjujC6ulsB7CfxonS1ufPghI3e7ar9cDBjeFsF8wxKMIGbDPvLv6cGUn/9pTiOZGNt
         5bcTR6A33gYqJ4KomGMXa7ZhzLPBd8i4EBzsccXqr6qpab0dxZgONax2AuCaDiMp7wS2
         h+YJsRo0UjPCfymXFkSEl3julaAltSBCea96L2AqEAQ/QCIRW0/21oc7r0uOMymyaS6y
         JJ8cHtHz2it+7C9cqq41gh2bkYR5MzQVQefiuoddgtCuciTuo1vq6r5Ce3CimLoXoJXK
         r/F7kcpUq0Asw+Q6n98aWeNNpTXMc/D25wT+aV1t5O2BTKZbRblIKRCcEFaJl5BLuifl
         a2pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vRtHQTIXlGRFGOjkr6EDMKnB9t1vQVBbtJP/KeMf3TE=;
        b=eV/FDbiACnb9MqYePR3HrfH66nc2SqjprywMRQ3YFLhiMYzlM8qqkDeOXaacZWXU5g
         nUlqGRci4xk0ysP4qWqTfL0vnCNP4Gp8ZcJXwC8bP7Mpj1fLxvDV7llaktrpSr2q/roN
         7V/pBta6RX4ObGk8i7ypT5+6No9fV9C5V49Sx4y89d1zZYuWyqWovABRWCJCP0ILzX9n
         xU5ReXOiivRB9Og3ehnaKz2k/crL/CZ+p5QEdZP+klZooYlWmQsiYph5sXSg4kOs7e1P
         ukDb3sH/9POxbRlHPjVygcmqEDrFaKUuovm9igxz3yHiuXubkzZkCC6vHLzOsJgI/bCj
         1Gsg==
X-Gm-Message-State: ANoB5pnjEgTD8dr5pmADHNEZnDQiYmzF0xGbCeyddoiaeYFznIPxHQuY
        o5+FTqDXPlYrtL20ANLMwTchc8JXRwEjxYUsyB9tFg==
X-Google-Smtp-Source: AA0mqf7nGu1hdcRmaEQRilm++4rBOBHGZLtO0CdDoKzmySMbMnklS5VR/2vo7uuw7LOuqEaCPb632pXxbQ4VGQmEA/g=
X-Received: by 2002:a9d:685a:0:b0:66c:dd29:813d with SMTP id
 c26-20020a9d685a000000b0066cdd29813dmr9601285oto.312.1668537478354; Tue, 15
 Nov 2022 10:37:58 -0800 (PST)
MIME-Version: 1.0
References: <20221115030210.3159213-1-sdf@google.com> <20221115030210.3159213-4-sdf@google.com>
 <87k03wi46i.fsf@toke.dk>
In-Reply-To: <87k03wi46i.fsf@toke.dk>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Tue, 15 Nov 2022 10:37:47 -0800
Message-ID: <CAKH8qBv0oOnZY3YiXu_SNnRYTgd64KhMgBOgKT2zMmkRiiNHHw@mail.gmail.com>
Subject: Re: [xdp-hints] [PATCH bpf-next 03/11] bpf: Support inlined/unrolled
 kfuncs for xdp metadata
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 15, 2022 at 8:16 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Stanislav Fomichev <sdf@google.com> writes:
>
> > Kfuncs have to be defined with KF_UNROLL for an attempted unroll.
> > For now, only XDP programs can have their kfuncs unrolled, but
> > we can extend this later on if more programs would like to use it.
> >
> > For XDP, we define a new kfunc set (xdp_metadata_kfunc_ids) which
> > implements all possible metatada kfuncs. Not all devices have to
> > implement them. If unrolling is not supported by the target device,
> > the default implementation is called instead. The default
> > implementation is unconditionally unrolled to 'return false/0/NULL'
> > for now.
> >
> > Upon loading, if BPF_F_XDP_HAS_METADATA is passed via prog_flags,
> > we treat prog_index as target device for kfunc unrolling.
> > net_device_ops gains new ndo_unroll_kfunc which does the actual
> > dirty work per device.
> >
> > The kfunc unrolling itself largely follows the existing map_gen_lookup
> > unrolling example, so there is nothing new here.
> >
> > Cc: John Fastabend <john.fastabend@gmail.com>
> > Cc: David Ahern <dsahern@gmail.com>
> > Cc: Martin KaFai Lau <martin.lau@linux.dev>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: Willem de Bruijn <willemb@google.com>
> > Cc: Jesper Dangaard Brouer <brouer@redhat.com>
> > Cc: Anatoly Burakov <anatoly.burakov@intel.com>
> > Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
> > Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
> > Cc: Maryam Tahhan <mtahhan@redhat.com>
> > Cc: xdp-hints@xdp-project.net
> > Cc: netdev@vger.kernel.org
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >  Documentation/bpf/kfuncs.rst   |  8 +++++
> >  include/linux/bpf.h            |  1 +
> >  include/linux/btf.h            |  1 +
> >  include/linux/btf_ids.h        |  4 +++
> >  include/linux/netdevice.h      |  5 +++
> >  include/net/xdp.h              | 24 +++++++++++++
> >  include/uapi/linux/bpf.h       |  5 +++
> >  kernel/bpf/syscall.c           | 28 ++++++++++++++-
> >  kernel/bpf/verifier.c          | 65 ++++++++++++++++++++++++++++++++++
> >  net/core/dev.c                 |  7 ++++
> >  net/core/xdp.c                 | 39 ++++++++++++++++++++
> >  tools/include/uapi/linux/bpf.h |  5 +++
> >  12 files changed, 191 insertions(+), 1 deletion(-)
> >
> > diff --git a/Documentation/bpf/kfuncs.rst b/Documentation/bpf/kfuncs.rs=
t
> > index 0f858156371d..1723de2720bb 100644
> > --- a/Documentation/bpf/kfuncs.rst
> > +++ b/Documentation/bpf/kfuncs.rst
> > @@ -169,6 +169,14 @@ rebooting or panicking. Due to this additional res=
trictions apply to these
> >  calls. At the moment they only require CAP_SYS_BOOT capability, but mo=
re can be
> >  added later.
> >
> > +2.4.8 KF_UNROLL flag
> > +-----------------------
> > +
> > +The KF_UNROLL flag is used for kfuncs that the verifier can attempt to=
 unroll.
> > +Unrolling is currently implemented only for XDP programs' metadata kfu=
ncs.
> > +The main motivation behind unrolling is to remove function call overhe=
ad
> > +and allow efficient inlined kfuncs to be generated.
> > +
> >  2.5 Registering the kfuncs
> >  --------------------------
> >
> > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > index 798aec816970..bf8936522dd9 100644
> > --- a/include/linux/bpf.h
> > +++ b/include/linux/bpf.h
> > @@ -1240,6 +1240,7 @@ struct bpf_prog_aux {
> >               struct work_struct work;
> >               struct rcu_head rcu;
> >       };
> > +     const struct net_device_ops *xdp_kfunc_ndo;
> >  };
> >
> >  struct bpf_prog {
> > diff --git a/include/linux/btf.h b/include/linux/btf.h
> > index d80345fa566b..950cca997a5a 100644
> > --- a/include/linux/btf.h
> > +++ b/include/linux/btf.h
> > @@ -51,6 +51,7 @@
> >  #define KF_TRUSTED_ARGS (1 << 4) /* kfunc only takes trusted pointer a=
rguments */
> >  #define KF_SLEEPABLE    (1 << 5) /* kfunc may sleep */
> >  #define KF_DESTRUCTIVE  (1 << 6) /* kfunc performs destructive actions=
 */
> > +#define KF_UNROLL       (1 << 7) /* kfunc unrolling can be attempted *=
/
> >
> >  /*
> >   * Return the name of the passed struct, if exists, or halt the build =
if for
> > diff --git a/include/linux/btf_ids.h b/include/linux/btf_ids.h
> > index c9744efd202f..eb448e9c79bb 100644
> > --- a/include/linux/btf_ids.h
> > +++ b/include/linux/btf_ids.h
> > @@ -195,6 +195,10 @@ asm(                                              =
       \
> >  __BTF_ID_LIST(name, local)                           \
> >  __BTF_SET8_START(name, local)
> >
> > +#define BTF_SET8_START_GLOBAL(name)                  \
> > +__BTF_ID_LIST(name, global)                          \
> > +__BTF_SET8_START(name, global)
> > +
> >  #define BTF_SET8_END(name)                           \
> >  asm(                                                 \
> >  ".pushsection " BTF_IDS_SECTION ",\"a\";      \n"    \
> > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > index 02a2318da7c7..2096b4f00e4b 100644
> > --- a/include/linux/netdevice.h
> > +++ b/include/linux/netdevice.h
> > @@ -73,6 +73,8 @@ struct udp_tunnel_info;
> >  struct udp_tunnel_nic_info;
> >  struct udp_tunnel_nic;
> >  struct bpf_prog;
> > +struct bpf_insn;
> > +struct bpf_patch;
> >  struct xdp_buff;
> >
> >  void synchronize_net(void);
> > @@ -1604,6 +1606,9 @@ struct net_device_ops {
> >       ktime_t                 (*ndo_get_tstamp)(struct net_device *dev,
> >                                                 const struct skb_shared=
_hwtstamps *hwtstamps,
> >                                                 bool cycles);
> > +     void                    (*ndo_unroll_kfunc)(const struct bpf_prog=
 *prog,
> > +                                                 u32 func_id,
> > +                                                 struct bpf_patch *pat=
ch);
> >  };
> >
> >  /**
> > diff --git a/include/net/xdp.h b/include/net/xdp.h
> > index 55dbc68bfffc..2a82a98f2f9f 100644
> > --- a/include/net/xdp.h
> > +++ b/include/net/xdp.h
> > @@ -7,6 +7,7 @@
> >  #define __LINUX_NET_XDP_H__
> >
> >  #include <linux/skbuff.h> /* skb_shared_info */
> > +#include <linux/btf_ids.h> /* btf_id_set8 */
> >
> >  /**
> >   * DOC: XDP RX-queue information
> > @@ -409,4 +410,27 @@ void xdp_attachment_setup(struct xdp_attachment_in=
fo *info,
> >
> >  #define DEV_MAP_BULK_SIZE XDP_BULK_QUEUE_SIZE
> >
> > +#define XDP_METADATA_KFUNC_xxx       \
> > +     XDP_METADATA_KFUNC(XDP_METADATA_KFUNC_RX_TIMESTAMP_SUPPORTED, \
> > +                        bpf_xdp_metadata_rx_timestamp_supported) \
> > +     XDP_METADATA_KFUNC(XDP_METADATA_KFUNC_RX_TIMESTAMP, \
> > +                        bpf_xdp_metadata_rx_timestamp) \
> > +
> > +enum {
> > +#define XDP_METADATA_KFUNC(name, str) name,
> > +XDP_METADATA_KFUNC_xxx
> > +#undef XDP_METADATA_KFUNC
> > +MAX_XDP_METADATA_KFUNC,
> > +};
> > +
> > +#ifdef CONFIG_DEBUG_INFO_BTF
> > +extern struct btf_id_set8 xdp_metadata_kfunc_ids;
> > +static inline u32 xdp_metadata_kfunc_id(int id)
> > +{
> > +     return xdp_metadata_kfunc_ids.pairs[id].id;
> > +}
> > +#else
> > +static inline u32 xdp_metadata_kfunc_id(int id) { return 0; }
> > +#endif
> > +
> >  #endif /* __LINUX_NET_XDP_H__ */
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index fb4c911d2a03..b444b1118c4f 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -1156,6 +1156,11 @@ enum bpf_link_type {
> >   */
> >  #define BPF_F_XDP_HAS_FRAGS  (1U << 5)
> >
> > +/* If BPF_F_XDP_HAS_METADATA is used in BPF_PROG_LOAD command, the loa=
ded
> > + * program becomes device-bound but can access it's XDP metadata.
> > + */
> > +#define BPF_F_XDP_HAS_METADATA       (1U << 6)
> > +
> >  /* link_create.kprobe_multi.flags used in LINK_CREATE command for
> >   * BPF_TRACE_KPROBE_MULTI attach type to create return probe.
> >   */
> > diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> > index 85532d301124..597c41949910 100644
> > --- a/kernel/bpf/syscall.c
> > +++ b/kernel/bpf/syscall.c
> > @@ -2426,6 +2426,20 @@ static bool is_perfmon_prog_type(enum bpf_prog_t=
ype prog_type)
> >  /* last field in 'union bpf_attr' used by this command */
> >  #define      BPF_PROG_LOAD_LAST_FIELD core_relo_rec_size
> >
> > +static int xdp_resolve_netdev(struct bpf_prog *prog, int ifindex)
> > +{
> > +     struct net *net =3D current->nsproxy->net_ns;
> > +     struct net_device *dev;
> > +
> > +     for_each_netdev(net, dev) {
> > +             if (dev->ifindex =3D=3D ifindex) {
>
> So this is basically dev_get_by_index(), except you're not doing
> dev_hold()? Which also means there's no protection against the netdev
> going away?

Yeah, good point, will use dev_get_by_index here instead with proper refcnt=
..

> > +                     prog->aux->xdp_kfunc_ndo =3D dev->netdev_ops;
> > +                     return 0;
> > +             }
> > +     }
>
> > +     return -EINVAL;
> > +}
> > +
> >  static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr)
> >  {
> >       enum bpf_prog_type type =3D attr->prog_type;
> > @@ -2443,7 +2457,8 @@ static int bpf_prog_load(union bpf_attr *attr, bp=
fptr_t uattr)
> >                                BPF_F_TEST_STATE_FREQ |
> >                                BPF_F_SLEEPABLE |
> >                                BPF_F_TEST_RND_HI32 |
> > -                              BPF_F_XDP_HAS_FRAGS))
> > +                              BPF_F_XDP_HAS_FRAGS |
> > +                              BPF_F_XDP_HAS_METADATA))
> >               return -EINVAL;
> >
> >       if (!IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) &&
> > @@ -2531,6 +2546,17 @@ static int bpf_prog_load(union bpf_attr *attr, b=
pfptr_t uattr)
> >       prog->aux->sleepable =3D attr->prog_flags & BPF_F_SLEEPABLE;
> >       prog->aux->xdp_has_frags =3D attr->prog_flags & BPF_F_XDP_HAS_FRA=
GS;
> >
> > +     if (attr->prog_flags & BPF_F_XDP_HAS_METADATA) {
> > +             /* Reuse prog_ifindex to carry request to unroll
> > +              * metadata kfuncs.
> > +              */
> > +             prog->aux->offload_requested =3D false;
> > +
> > +             err =3D xdp_resolve_netdev(prog, attr->prog_ifindex);
> > +             if (err < 0)
> > +                     goto free_prog;
> > +     }
> > +
> >       err =3D security_bpf_prog_alloc(prog->aux);
> >       if (err)
> >               goto free_prog;
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index 07c0259dfc1a..b657ed6eb277 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -9,6 +9,7 @@
> >  #include <linux/types.h>
> >  #include <linux/slab.h>
> >  #include <linux/bpf.h>
> > +#include <linux/bpf_patch.h>
> >  #include <linux/btf.h>
> >  #include <linux/bpf_verifier.h>
> >  #include <linux/filter.h>
> > @@ -14015,6 +14016,43 @@ static int fixup_call_args(struct bpf_verifier=
_env *env)
> >       return err;
> >  }
> >
> > +static int unroll_kfunc_call(struct bpf_verifier_env *env,
> > +                          struct bpf_insn *insn,
> > +                          struct bpf_patch *patch)
> > +{
> > +     enum bpf_prog_type prog_type;
> > +     struct bpf_prog_aux *aux;
> > +     struct btf *desc_btf;
> > +     u32 *kfunc_flags;
> > +     u32 func_id;
> > +
> > +     desc_btf =3D find_kfunc_desc_btf(env, insn->off);
> > +     if (IS_ERR(desc_btf))
> > +             return PTR_ERR(desc_btf);
> > +
> > +     prog_type =3D resolve_prog_type(env->prog);
> > +     func_id =3D insn->imm;
> > +
> > +     kfunc_flags =3D btf_kfunc_id_set_contains(desc_btf, prog_type, fu=
nc_id);
> > +     if (!kfunc_flags)
> > +             return 0;
> > +     if (!(*kfunc_flags & KF_UNROLL))
> > +             return 0;
> > +     if (prog_type !=3D BPF_PROG_TYPE_XDP)
> > +             return 0;
>
> Should this just handle XDP_METADATA_KFUNC_EXPORT_TO_SKB instead of
> passing that into the driver (to avoid every driver having to
> reimplement the same call to xdp_metadata_export_to_skb())?

Good idea, will try to move it here.
